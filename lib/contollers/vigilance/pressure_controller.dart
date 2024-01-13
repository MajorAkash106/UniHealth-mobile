import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/pressure_install_history_model.dart';
import 'package:medical_app/model/vigilance/pressure_risk_hitory_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class PressureController extends GetxController {
  final HistoryController _historyController = HistoryController();
  final VigilanceController vigilanceController = VigilanceController();
  var allData = List<NRSListData>().obs;

  Future<String> getData(String id) async {
    try {
      var data = await getJson(id);
      print('data from json file: ${json.decode(data)}');
      NRSModel model = NRSModel.fromJson(json.decode(data));
      print(model.success);
      print(model.message);

      if (model.success == true) {
        allData.clear();

        print(model.data);
        allData.addAll(model.data);
      } else {
        ShowMsg(model.message);
      }
    } catch (e) {
      print('exception occur : ${e}');
      ServerError();
    }

    return "success";
  }

  Future<String> onSavedRisk(
    PatientDetailsData data,
    List<NRSListData> selectedList,
    int score,
  ) async {
    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "score": score,
      "output": getResult(score) + " ($score ${'points'.tr})",
      "risk_braden_data": selectedList,
    };

    print('final Data: ${jsonEncode(finalData)}');

    await saveHistory(data.sId, finalData, ConstConfig.pressure_risk,
        data.hospital.first.sId);

    await vigilanceController
        .saveData(data, finalData, VigiLanceBoxes.pressureUlcer_status_risk,
            VigiLanceBoxes.pressureUlcer)
        .then((value) {
      Get.to(Step1HospitalizationScreen(
          patientUserId: data.sId, index: 3, statusIndex: 0));
    });
    // await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);

    return 'success';
  }

  Future<String> onSavedInstalled(PatientDetailsData data,
      List<NRSListData> selectedList, String stage) async {
    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "output": stage,
      "installed_data": selectedList,
    };

    print('final Data: ${jsonEncode(finalData)}');

    await saveHistory(data.sId, finalData, ConstConfig.pressure_installed,
        data.hospital.first.sId);

    await vigilanceController
        .saveData(
            data,
            finalData,
            VigiLanceBoxes.pressureUlcer_installed_status,
            VigiLanceBoxes.pressureUlcer)
        .then((value) {
      Get.to(Step1HospitalizationScreen(
          patientUserId: data.sId, index: 3, statusIndex: 4));
    });
    // await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);

    return 'success';
  }

  Future<String> saveHistory(
      String patientId, Map data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();
    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      print('internet avialable');
      await _historyController.saveMultipleMsgHistory(patientId, type, [data]);
    }
  }

  var historyData = List<PressureRiskData>().obs;
  var historyDataInstall = List<PressureInstallData>().obs;

  void getHistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.pressure_risk,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        PressureRiskHistory model =
            PressureRiskHistory.fromJson(json.decode(value.body));
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

  void getHistoryDataInstall(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.pressure_installed,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        PressureInstallHistory model =
            PressureInstallHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          historyDataInstall.clear();
          print(model.data);
          historyDataInstall.addAll(model.data.reversed);

          historyDataInstall.sort((a, b) {
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

  getResult(int score) {
    // SEVERE RISK: Total score ≤ 9 (SHOW THE TOTAL OF POINTS AND RELATED GRADE, AS FOR INSTANCE: 8 = SEVERE RISK)
    // HIGH RISK: Total score 10-12
    // MODERATE RISK: Total score 13-14
    // MILD RISK: Total score 15-18
    if (score <= 9) {
      return "severe_risk".tr;
    } else if (score >= 10 && score <= 12) {
      return "high__risk".tr;
    } else if (score >= 13 && score <= 14) {
      return "moderate_risk".tr;
    } else if (score >= 15 && score <= 18) {
      return "mild_risk".tr;
    } else {
      // return "NULL";
      return "no_risk".tr;
    }
  }

  Future<Vigilance> getPriviousData(
      PatientDetailsData data, String type, String status) async {
    Vigilance _vigilance;
    if (!data.vigilance.isNullOrBlank) {
      _vigilance = data.vigilance.firstWhere(
          (element) => element.type == type && element.status == status,
          orElse: () => null);
    }
    return _vigilance;
  }

  Future<Vigilance> getPressureUlcer(PatientDetailsData data) async {

    Vigilance _vigilanceRisk;
    Vigilance _vigilanceInstall;
    if (!data.vigilance.isNullOrBlank) {
      try {
        _vigilanceRisk = await data.vigilance.firstWhere(
            (element) =>
                element.type == VigiLanceBoxes.pressureUlcer &&
                element.status == VigiLanceBoxes.pressureUlcer_status_risk,
            orElse: () => null);
        _vigilanceInstall = await data.vigilance.firstWhere(
            (element) =>
                element.type == VigiLanceBoxes.pressureUlcer &&
                element.status == VigiLanceBoxes.pressureUlcer_installed_status,
            orElse: () => null);
      } catch (e) {
      }
    }


    if (!_vigilanceInstall.isNullOrBlank &&
        !_vigilanceInstall.result.first.output.isNullOrBlank) {

      return _vigilanceInstall;
    } else if (!_vigilanceRisk.isNullOrBlank) {

      return _vigilanceRisk;
    } else {

      return _vigilanceInstall;
    }
  }
}
