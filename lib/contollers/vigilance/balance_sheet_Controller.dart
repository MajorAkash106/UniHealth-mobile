import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_history.dart';
import 'package:medical_app/model/vigilance/fluid_history_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion_report_screen.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class BalanceSheetController extends GetxController {
  final VigilanceController vigilanceController = VigilanceController();
  final HistoryController _historyController = HistoryController();
  final PatientSlipController patientSlipController = PatientSlipController();

  Future<bool> getRoute(String hosId) async {
    bool internet = await checkConnectivityWithToggle(hosId);

    return internet;
  }

  Future<String> onSaved(
      PatientDetailsData data,
      String _value,
      TextEditingController _date,
      String time,
      int selectedIndex,
      TextEditingController ml) async {
    print('item : ${_value}');
    print('date : ${_date.text}');
    print('in & out : ${selectedIndex}');
    print('ml : ${ml.text}');

    List<vigi_resultData> _getfluid = [];
    String balanceSheet;
    await getFluidBalanace(data).then((val) {
      if (val != null) {
        _getfluid.addAll(val.result[0].data);
        balanceSheet = val.result[0].balanceSince;
      }
    });

    _getfluid.add(vigi_resultData(
        // date: DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1))),
        // date: DateFormat(commonDateFormat).format(DateTime.now()),
        date: _date.text,
        intOut: selectedIndex.toString(),
        item: _value,
        ml: ml.text,
        time: time //DateFormat('HH:mm').format(DateTime.now())
        // time: '04:15'
        ));

    Map finalData = {
      "lastUpdate": '${DateFormat(commonDateFormat).format(DateTime.now())}',
      "balance_since": balanceSheet ?? '',
      "data": _getfluid
    };

    print('final Data: ${jsonEncode(finalData)}');

    //checking mode here if online then switch online otherwise offline
    bool mode = await getRoute(data.hospital.first.sId);
    if (mode != null && mode) {
      print('internet avialable');

      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
      await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);
    } else {
      await vigilanceController.saveDataOffline(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
    }

    return 'success';
  }

  Future<String> onEdit(
      PatientDetailsData data,
      String _value,
      TextEditingController _date,
      int selectedIndex,
      TextEditingController ml,
      vigi_resultData previousData,
      bool delete) async {
    print("xxxx....${jsonEncode(previousData)}");
    print('item : ${_value}');
    print('date : ${_date.text}');
    print('in & out : ${selectedIndex}');
    print('ml : ${ml.text}');

    List<vigi_resultData> _getfluid = [];
    int index = 0;
    String balanceSheet;
    await getFluidBalanace(data).then((val) {
      if (val != null) {
        print("alll... ${jsonEncode(val.result[0].data)}");
        index = val.result[0].data.indexOf(previousData);

        val.result[0].data.remove(previousData);

        _getfluid.addAll(val.result[0].data);
        balanceSheet = val.result[0].balanceSince;
      }
    });

    if (!delete) {
      print("idx.. ${index}");
      await _getfluid.insert(
          index,
          vigi_resultData(
              intOut: selectedIndex.toString(),
              item: _value,
              ml: ml.text,
              date: previousData.date,
              time: previousData.time));
    }

    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "balance_since": balanceSheet ?? '',
      "data": _getfluid
    };

    print('final Data: ${jsonEncode(finalData)}');

    //checking mode here if online then switch online otherwise offline
    bool mode = await getRoute(data.hospital.first.sId);
    if (mode != null && mode) {
      print('internet avialable');
      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
      await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);
    } else {
      await vigilanceController.saveDataOffline(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
    }

    return 'success';
  }

  Future<String> onSetting(PatientDetailsData data, String balanceSince) async {
    List<vigi_resultData> _getfluid = [];

    await getFluidBalanace(data).then((val) {
      if (val != null) {
        _getfluid.addAll(val.result[0].data);
      }
    });

    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "balance_since": balanceSince,
      "data": _getfluid
    };

    print('final Data: ${jsonEncode(finalData)}');

    //checking mode here if online then switch online otherwise offline
    bool mode = await getRoute(data.hospital.first.sId);
    if (mode != null && mode) {
      print('internet avialable');
      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
      await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);
    } else {
      await vigilanceController.saveDataOffline(data, finalData,
          VigiLanceBoxes.fluidBalance_status, VigiLanceBoxes.fluidBalance);
    }

    return 'success';
  }

  Future<String> saveHistory(String patientId, Map data, type) async {
    await _historyController.saveMultipleMsgHistory(patientId, type, [data]);
  }

  var historyData = List<FluidHistoryData>().obs;

  void getHistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.fluidHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        FluidBalanceHistory model =
            FluidBalanceHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          historyData.clear();
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

  Future<double> getNutritional(PatientDetailsData data, String type) async {
    // double lastwork = 0;
    double currentwork = 0.0;
    Vigilance vigilance = await getFluidBalanace(data);
    String workingday = await getWorkingDays(data.hospital[0].sId);

    if (vigilance != null && vigilance.result.first.data != null) {
      print('getting vigilance len : ${vigilance.result.first.data.length}');

      for (var a in vigilance.result.first.data) {
        print('obj : ${a.date} ${a.time}:00');
        var dateTimee = await '${a.date} ${a.time}:00';

        var today =
            '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
        var last =
            '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
        print('today --- ${today}');

        print(
            's d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

        // bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
        bool curruntday =
            await DateTime.parse(dateTimee).isAfter(DateTime.parse(today));

        if (curruntday == true) {
          if (a.intOut == '0' && a.item == type) {
            currentwork = currentwork + double.parse(a.ml);
          }
        }
        // else if (get == true) {
        //   if (a.intOut == '1' && a.item == 'Nasogastric Tube') {
        //     lastwork = lastwork + double.parse(a.ml);
        //   }
        // }
      }

      // print('last workday  : ${lastwork}');
      print('current workday  : ${currentwork}');
    }

    return currentwork;
  }

  //for refresh screen for infusion sheer before this fn this is calling everywhere

  void refreshInfusionSheet(
      String patientId,
      String title,
      String formula_status,
      bool isFromEn,
      bool isFromPn,
      String type,
      String hospId) async {
    final PatientSlipController _patientSlipController =
        PatientSlipController();

    bool mode = await getRoute(hospId);
    if (mode != null && mode) {
      await _patientSlipController.getDetails(patientId, 0).then((val) {
        Get.off(InfusionReport(
            title: title,
            patientDetailsData: _patientSlipController.patientDetailsData[0],
            formula_status: formula_status,
            isFromEn: isFromEn ? true : false,
            type: type,
            isFromPn: isFromPn ? true : false));
      });
      print('internet avialable');
    } else {
      await patientSlipController.getReturnOffline(patientId, 0).then((pData) {
        Get.off(InfusionReport(
            title: title,
            patientDetailsData: pData,
            formula_status: formula_status,
            isFromEn: isFromEn ? true : false,
            type: type,
            isFromPn: isFromPn ? true : false));
      });
    }
  }
}
