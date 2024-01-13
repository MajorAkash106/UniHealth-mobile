import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/bloodpressure_HistoryModel.dart';
import 'package:medical_app/model/vigilance/circulation_model.dart';
import 'package:medical_app/model/vigilance/vaso_pressureHistory.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class CirculationSheetController extends GetxController {
  final VigilanceController vigilanceController = VigilanceController();
  final HistoryController _historyController = HistoryController();

  Future<String> onSaved(
      {PatientDetailsData data,
      String sbp,
      String dbp,
      String map,
      int tablenumber,
      String drug,
      String unitType,
      String drug_amt,
      String concenteratrion,
      String dose,
      String infusion,
      String diluent,
      String date,String time
      }) async {
    Get.back();
    List<BloodPressor> _bloodpressor = [];
    List<Vasopressor> _vasopressor = [];

    await getCirculationData(data).then((val) {
      if (val != null) {
        print('kkkkk');
        // print(val.result[0].circulaltiondata.bloodPressor[0].date);
        _bloodpressor.addAll(val.result[0].circulaltiondata.bloodPressor);
        _vasopressor.addAll(val.result[0].circulaltiondata.vasopressor);
      }
    });
    tablenumber == 0
        ? _bloodpressor.add(BloodPressor(
      date: date,
      time: time,
            // date: DateFormat(commonDateFormat).format(DateTime.now()),
            sbp: double.parse(sbp).toString(),
            //sbp,
            dbp: double.parse(dbp).toString(),
            // dbp,
            map: double.parse(map).toString(),
            //map,
            // time: DateFormat('HH:mm').format(DateTime.now())
            // time: '04:15'
            ))
        : _vasopressor.add(Vasopressor(
            drug: drug,
            // date: DateFormat(commonDateFormat).format(DateTime.now()),
            // time: DateFormat('HH:mm').format(DateTime.now()),
        date: date,time: time,
            unit_type: unitType,
            drug_amount: double.parse(drug_amt).toString(),
            //drug_amt,
            concentration: double.parse(concenteratrion).toString(),
            //concenteratrion,
            dose: double.parse(dose).toString(),
            // dose,
            infusion: double.parse(infusion).toString(),
            // infusion,
            diluent: double.parse(diluent).toString(),
            concentration_unit: unitType == 'u' ? 'U/ml' : 'mcg/mL'

            // diluent
            ));

    // Map finalData = {
    //   "lastUpdate": "",
    //   "blood_pressor": _bloodpressor,
    //   "vasopressor": []
    // };

    Map finalData = {
      "circulaltiondata": {
        "lastUpdate": '${DateTime.now()}',
        "blood_pressor": _bloodpressor,
        "vasopressor": _vasopressor
      }
    };
    print('final data ... ${finalData.toString()}');
    await vigilanceController.saveData(data, finalData,
        VigiLanceBoxes.circulation_status, VigiLanceBoxes.circulation);

    Map dataForHistory = tablenumber == 0
        ? {
            "lastUpdate": '${DateTime.now()}',
            "data": [
              {
                "date": DateFormat(commonDateFormat).format(DateTime.now()),
                "time": DateFormat('HH:mm').format(DateTime.now()),
                "sbp": double.parse(sbp).toString(), //sbp,
                "dbp": double.parse(dbp).toString(), //dbp,
                "map": double.parse(map).toString(), //map,
                "flag": "Added"
              }
            ]
          }
        : {
            "lastUpdate": '${DateTime.now()}',
            "data": [
              {
                "date": DateFormat(commonDateFormat).format(DateTime.now()),
                "time": DateFormat('HH:mm').format(DateTime.now()),
                "flag": "Added",
                "drug": drug,
                "drug_amount": double.parse(drug_amt).toString(),
                //drug_amt,
                "concentration": double.parse(concenteratrion).toString(),
                //concenteratrion,
                "dose": double.parse(dose).toString(),
                //dose,
                "diluent": double.parse(diluent).toString(),
                //diluent,
                "infusion": double.parse(infusion).toString(),
                //infusion
              }
            ]
          };

    print(jsonEncode(dataForHistory));
    await saveHistory(
        data.sId,
        dataForHistory,
        tablenumber == 0
            ? ConstConfig.blood_pressureHistory
            : ConstConfig.vaso_pressureHistory,
        data.hospital.first.sId);

    return 'success';
  }

  Future<String> onEdit(
      {PatientDetailsData data,
      String sbp,
      String dbp,
      String map,
      var previousData,
      // Vasopressor previous_vasoData,
      bool delete,
      int tablenumber,
      String drug,
      String unitType,
      String drug_amt,
      String concenteratrion,
      String dose,
      String infusion,
      String diluent,String date,String time}) async {
    Get.back();
    List<BloodPressor> _bloodPressor = [];
    List<Vasopressor> _vasoPressor = [];
    int index = 0;

    await getCirculationData(data).then((val) {
      if (val != null) {
        print('ppp....${jsonEncode(previousData)}');
        tablenumber == 0
            ? index = val.result[0].circulaltiondata.bloodPressor
                .indexOf(previousData)
            : index = val.result[0].circulaltiondata.vasopressor
                .indexOf(previousData);
        tablenumber == 0
            ? val.result[0].circulaltiondata.bloodPressor.remove(previousData)
            : val.result[0].circulaltiondata.vasopressor.remove(previousData);

        print('qqqqq....${jsonEncode(_bloodPressor.toString())}');

        _bloodPressor.addAll(val.result[0].circulaltiondata.bloodPressor);
        _vasoPressor.addAll(val.result[0].circulaltiondata.vasopressor);
        print('rrrr....${jsonEncode(_bloodPressor)}');
      }
    });

    if (!delete) {
      print('...sss.....${jsonEncode(_bloodPressor)}');
      tablenumber == 0
          ? await _bloodPressor.insert(
              index,
              BloodPressor(
                  sbp: sbp,
                  dbp: dbp,
                  map: map,
                  // date: previousData.date,
                  // time: previousData.time
                date: date,time: time
              ))
          : await _vasoPressor.insert(
              index,
              Vasopressor(
                  drug: drug,
                  // date: previousData.date,
                  // time: previousData.time,
                  date: date,time: time,
                  unit_type: unitType,
                  drug_amount: drug_amt,
                  concentration: concenteratrion,
                  dose: dose,
                  infusion: infusion,
                  diluent: diluent,
                  concentration_unit: unitType == 'u' ? 'U/ml' : 'mcg/mL'));

      Map finalData = {
        "circulaltiondata": {
          "lastUpdate": '${DateTime.now()}',
          "blood_pressor": _bloodPressor,
          "vasopressor": _vasoPressor
        }
      };

      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.circulation_status, VigiLanceBoxes.circulation);

      Map dataForHistory = tablenumber == 0
          ? {
              "lastUpdate": '${DateTime.now()}',
              "data": [
                {
                  "date": previousData.date,
                  "time": previousData.time,
                  "sbp": sbp,
                  "dbp": dbp,
                  "map": map,
                  "flag": "Edited"
                }
              ]
            }
          : {
              "lastUpdate": '${DateTime.now()}',
              "data": [
                {
                  "date": previousData.date,
                  "time": previousData.time,
                  "flag": "Edited",
                  "drug": drug,
                  "drug_amount": drug_amt,
                  "concentration": concenteratrion,
                  "dose": dose,
                  "diluent": diluent,
                  "infusion": infusion
                }
              ]
            };
      await saveHistory(
          data.sId,
          dataForHistory,
          tablenumber == 0
              ? ConstConfig.blood_pressureHistory
              : ConstConfig.vaso_pressureHistory,
          data.hospital.first.sId);
    } else {
      // Map finalData = {"lastUpdate": '${DateTime.now()}',"balance_since": balanceSheet??'', "data": _getfluid};
      Map finalData = {
        "circulaltiondata": {
          "lastUpdate": '${DateTime.now()}',
          "blood_pressor": _bloodPressor,
          "vasopressor": _vasoPressor
        }
      };
      print('...tttt.....${jsonEncode(_bloodPressor)}');
      print('...uuuuu.....${jsonEncode(finalData)}');
      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.circulation_status, VigiLanceBoxes.circulation);

      Map dataForHistory = tablenumber == 0
          ? {
              "lastUpdate": '${DateTime.now()}',
              "data": [
                {
                  "date": previousData.date,
                  "time": previousData.time,
                  "sbp": sbp,
                  "dbp": dbp,
                  "map": map,
                  "flag": "Deleted"
                }
              ]
            }
          : {
              "lastUpdate": '${DateTime.now()}',
              "data": [
                {
                  "date": previousData.date,
                  "time": previousData.time,
                  "flag": "Delete",
                  "drug": drug,
                  "drug_amount": drug_amt,
                  "concentration": concenteratrion,
                  "dose": dose,
                  "diluent": diluent,
                  "infusion": infusion
                }
              ]
            };
      await saveHistory(
          data.sId,
          dataForHistory,
          tablenumber == 0
              ? ConstConfig.blood_pressureHistory
              : ConstConfig.vaso_pressureHistory,
          data.hospital.first.sId);
    }

    return 'success';
  }

  Future<String> saveHistory(
      String patientId, Map data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();

    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      await _historyController.saveMultipleMsgHistory(patientId, type, [data]);
      print('internet avialable');
    }
  }

  var historyData = List<BpHistoryData>().obs;

  void getBpHistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.blood_pressureHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        BloodPressureHistory model =
            BloodPressureHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          // historyData.clear();
          print(model.data);
          historyData.addAll(model.data.reversed);

          historyData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }

  var vasohistoryData = List<VasoPressureHistoryData>().obs;

  void getVaso_HistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.vaso_pressureHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        VasoPressureHistory model =
            VasoPressureHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        // Get.back();
        if (model.success == true) {
          // historyData.clear();
          print(model.data);
          vasohistoryData.addAll(model.data.reversed);

          vasohistoryData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }
}
//updated by raman at 14 oct 12:28
