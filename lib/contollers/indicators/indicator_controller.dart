import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/contollers/indicators/diarrhea_config.dart';
import 'package:medical_app/model/indicator.dart';
import 'package:medical_app/model/indicator/indicator_data.dart';
import 'package:medical_app/model/indicator/months_data.dart' as month;
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/patient_list.dart';
import 'package:medical_app/config/cons/indicator_type.dart';
import '../../config/Snackbars.dart';
import '../../config/cons/APIs.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/WardListModel.dart';
import '../../json_config/const/json_fun.dart';
import '../../json_config/const/json_paths.dart';
import '../../model/duration_date.dart';
import '../../model/hospitalListModel.dart';
import '../../model/indicator/multiple_patient_history.dart';
import '../sqflite/database/hospitals_offline.dart';
import '../sqflite/utils/Utils.dart';
import 'ns_config.dart';

class IndicatorController extends GetxController {
  HospitalSqflite _hospitalSqflite = HospitalSqflite();

  NSConfig _nsConfig = NSConfig();
  List<HospitalListData> hosp = <HospitalListData>[].obs;
  List<Indicators> indicators = <Indicators>[].obs;
  List<WardData> wards = <WardData>[].obs;
  List<PatientDetailsData> patients = <PatientDetailsData>[].obs;
  List<month.Info> months = <month.Info>[].obs;
  var isError = false.obs;

  Future<String> getWardData(String id) async {
    print(APIUrls.getWardList);
    print(id);
    print("api calling ${APIUrls.getWardList}");

    showLoader();
    try {
      Request request = Request(url: APIUrls.getWardList2, body: {
        'hospitalId': id,
        'type': '0',
      });

      print(request.body);

      await request.post().then((value) {
        WardList wardList = WardList.fromJson(json.decode(value.body));

        print(wardList.success);
        print(wardList.message);
        Get.back();
        if (wardList.success == true) {
          wards.clear();
          wards.addAll(wardList.data);
          wards.sort((a, b) {
            return a.wardname
                .toString()
                .toLowerCase()
                .compareTo(b.wardname.toString().toLowerCase());
          });
        } else {
          isError.value = true;
          // ShowMsg(wardList.message);
        }
      });
    } catch (e) {
      print('exception occur : ${e}');
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future<String> getPatientsData(String hospId, String wardId) async {
    print("api calling ${APIUrls.getPatients}");

    showLoader();
    try {
      var payload;
      if (wardId == null) {
        payload = {
          'hospitalId': hospId,
        };
      } else {
        payload = {
          'hospitalId': hospId,
          'wardId': wardId,
        };
      }

      Request request = Request(url: APIUrls.getPatients, body: payload);

      print(request.body);

      await request.post().then((value) {
        PatientList data = PatientList.fromJson(json.decode(value.body));

        print(data.success);
        print(data.message);
        Get.back();
        if (data.success == true) {
          patients.clear();
          patients.addAll(data.data);
        } else {
          isError.value = true;
          // ShowMsg(wardList.message);
        }
      });
    } catch (e) {
      print('exception occur : ${e}');
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future<void> getIndicators() async {
    var data = await getJson(JsonFilePath.indicator);
    print('data from json file: ${json.decode(data)}');
    Indicator _indicator = Indicator.fromJson(json.decode(data));
    indicators.addAll(_indicator.indicators);
  }

  Future<void> getHospFromLocal() async {
    await _hospitalSqflite.getHospitals().then((res) {
      if (res != null) {
        HospitalsListDetails hospitalDetails = res;
        print(hospitalDetails.success);
        print(hospitalDetails.message);
        if (hospitalDetails.success == true) {
          print("hospital Details data length: ${hospitalDetails.data.length}");
          // return hospitalDetails.data;

          hosp.addAll(hospitalDetails.data);
        } else {
          ShowMsg(hospitalDetails.message);
        }
        getIndicators();
      } else {
        DATADOESNOTEXIST();
      }
    });
  }


  List<PatientDetailsData> getPatients(String wardId) {
    List<PatientDetailsData> output = [];

    adLog('wardId : $wardId');

    if (wardId != null) {
      for (var a in patients) {
        if (a.wardId.sId == wardId) {
          output.add(a);
        }
      }
    } else {
      output = patients;
    }

    return output;
  }

  List<PatientDetailsData> getPatientWithDuration(
      List<PatientDetailsData> data, DurationDate durationDate) {
    List<PatientDetailsData> output = [];

    DateTime startDate = durationDate.startDate;
    DateTime endDate = durationDate.endDate;

    for (var it in data) {
      DateTime admitDate = DateTime.parse('${it.admissionDate} 00:00:00');

      if (admitDate.isAfter(startDate) && admitDate.isBefore(endDate)) {
        output.add(it);
      }
    }

    return output;
  }

  Future<List<IndicatorData>> getFreq(
      List<PatientDetailsData> data, List<DurationDate> dates) async {
    List<IndicatorData> output = [];

    await dates.forEach((it) {
      int In24hourCount = 0;
      for (var a in data) {
        DateTime admitDate = DateTime.parse('${a.admissionDate} 00:00:00');
        DateTime startDate = it.startDate;
        DateTime endDate = it.endDate;

        adLog('getting en history=> startDate : $startDate  endDate : $endDate  admitDate : $admitDate');

        adLog('endate ${admitDate.isAfter(startDate) && admitDate.isBefore(endDate)}');

        if (admitDate.isAfter(startDate) && admitDate.isBefore(endDate)) {
          bool isIn24hour = _nsConfig.getPatientScreening(a);
          // adLog("isIn24hour: $isIn24hour");
          if (isIn24hour) {
            In24hourCount++;
          }

          adLog('${it.startDate} - ${it.endDate}');
          adLog('*****************************************');
          adLog('total :: ${data.length}');
          adLog('In24hourCount :: ${In24hourCount}');

          var in24hourPer = (In24hourCount / data.length) * 100;
          var out24hourPer = 100 - in24hourPer;

          adLog('in24hour : $in24hourPer, out24hour : $out24hourPer');
          output.add(IndicatorData(
            in24hour: in24hourPer,
            out24hour: out24hourPer,
            total: 100.0,
            diarrhea: 0,
            durationDate: it,
            indicatorType: indicatorType.one,
          ));
        }
      }
    });

    return output;
  }

  Future<List<IndicatorData>> getBothHistory(
      String hospId, String wardId, List<DurationDate> dates) async {
    DiarrheaConfig _diarrheaConfig = DiarrheaConfig();
    await _diarrheaConfig.getHistoryData(
        hospId, wardId, ConstConfig.abdomenHistory);
    await _diarrheaConfig.getHistoryData(
        hospId, wardId, ConstConfig.enteralHistory);

    List<IndicatorData> indicators = [];

    for (var it in dates) {
      List<mHistory> usingEn = await _diarrheaConfig.dataWithEn(it);
      List<mHistory> usingDiarrhea =
          await _diarrheaConfig.dataWithDia(it, usingEn);

      adLog('${it.startDate} - ${it.endDate}');
      adLog('*****************************************');
      adLog('totalDiarrhea :: ${usingDiarrhea.length}');
      adLog('totalEn :: ${usingEn.length}');
      adLog('total :: ${_diarrheaConfig.enData.length}');
      adLog('per :: ${(usingDiarrhea.length / usingEn.length) * 100}');

      await indicators.add(IndicatorData(
          in24hour: 0,
          out24hour: 0,
          total: 100.0,
          diarrhea: (usingDiarrhea.length / usingEn.length) * 100,
          durationDate: it,
          indicatorType: indicatorType.two));
    }

    return indicators;
  }
}
