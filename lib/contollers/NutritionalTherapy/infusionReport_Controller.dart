import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusionReportModel.dart';

class InfusionReportController extends GetxController {
  // final PatientSlipController patientSlipController = PatientSlipController();


  //checking routes means user want to navigate online or offline
  Future<InfusionReportModel> getRouteForMode(
      String userid, String formulaStatus, var context, String hospId) async {
    bool internet = await checkConnectivityWithToggle(hospId);
    InfusionReportModel output;
    if (internet != null && internet) {
      output = await getInfusionReport(userid, formulaStatus, context);
      print('internet avialable');
    } else {
      output = await getInfusionFromSqlite(userid, formulaStatus, context);
    }

    return output;
  }

  Future<InfusionReportModel> getInfusionReport(
      String userid, String formulaStatus, var context) async {
    InfusionReportModel model;

    Request request = Request(
        url: APIUrls.getFormulas,
        body: {"userId": userid, "formulastatus": formulaStatus});
    print(APIUrls.getFormulas);
    print(request.body);

    await request.post().then((res) {
      print(res.body);
      model = InfusionReportModel.fromJson(jsonDecode(res.body));
    });
    // Get.back();
    if (model.success == true) {
      print(model.data.first.formula.length);
      print('infusion report..  ${jsonEncode(model.data)}');
    } else {
      print('state false');
      ShowMsg(model.message);
    }

    return model;
  }

  //getting infusion data from local database & return as a infusion model
  Future<InfusionReportModel> getInfusionFromSqlite(
      String userid, String formulaStatus, var context) async {
    SaveDataSqflite sqflite = SaveDataSqflite();
    PatientDetailsData pData = await sqflite.getData(userid);

    print("pData.enteralFormula::: ${pData.enteralFormula}");


    InfusionReportModel output = await InfusionReportModel(
        data:formulaStatus == "enteral"? pData.enteralFormula:pData.parenteralFormula, success: true, message: '');

    return output;
  }

  Future<List<vigi_resultData>> getInfusionSheet(
      PatientDetailsData data, String type, String date, String time) async {
    // double lastwork = 0;
    List<vigi_resultData> infusionSheet = [];
    double currentwork = 0.0;
    Vigilance vigilance = await getFluidBalanace(data);
    String workingday = await getWorkingDays(data.hospital[0].sId);
    var concenated_date_fromfunc = '${date} ${time}:00';
    var date_concenated_with_adminTime = '${date} ${workingday}:00';
    print(concenated_date_fromfunc);
    print("concenated_date_fromfunc");
    print(date_concenated_with_adminTime);

    if (vigilance != null && vigilance.result.first.data != null) {
      print('getting vigilance len : ${vigilance.result.first.data.length}');
      bool isbefore = DateTime.parse(concenated_date_fromfunc)
          .isBefore(DateTime.parse(date_concenated_with_adminTime));
      if (isbefore) {
        var date_1 = DateTime.parse(date_concenated_with_adminTime)
            .subtract(Duration(days: 1));
        var date_2 = DateTime.parse(date_1.toString()).add(Duration(days: 1));
        for (var a in vigilance.result.first.data) {
          print('obj : ${a.date} ${a.time}:00');
          var dateTimee = await '${a.date} ${a.time}:00';
          // var target_date = '${DateFormat(commonDateFormat).format(date)} ${workingday}:00';
          // var dateAfter_targetDate = DateTime.parse(target_date).add(Duration(days: 1));

          print('target date --- ${date_1}');
          print('date after target date --- ${date_2}');

          // print('s d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

          // bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
          // bool targetedData = await DateTime.parse(dateTimee).isAfter(DateTime.parse(target_date))&& DateTime.parse(dateTimee).isBefore(DateTime.parse(dateAfter_targetDate.toString()));
          bool targetedData = await DateTime.parse(dateTimee)
                  .isAfter(DateTime.parse(date_1.toString())) &&
              DateTime.parse(dateTimee)
                  .isBefore(DateTime.parse(date_2.toString()));

          if (targetedData == true) {
            print("tttt");
            if (a.item == type) {
              // currentwork = currentwork + double.parse(a.ml);
              infusionSheet.add(a);
            }
          } else {
            print('nooooo');
          }
        }
      } else {
        for (var a in vigilance.result.first.data) {
          print('obj : ${a.date} ${a.time}:00');
          var dateTimee = await '${a.date} ${a.time}:00';
          var target_date =
              '${DateFormat(commonDateFormat).format(DateTime.parse(date))} ${workingday}:00';
          var dateAfter_targetDate =
              DateTime.parse(target_date).add(Duration(days: 1));
          // var today = '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
          // var last = '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
          print('target date --- ${target_date}');
          print('date after target date --- ${dateAfter_targetDate}');

          // print('s d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

          // bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
          bool targetedData = await DateTime.parse(dateTimee)
                  .isAfter(DateTime.parse(target_date)) &&
              DateTime.parse(dateTimee)
                  .isBefore(DateTime.parse(dateAfter_targetDate.toString()));

          if (targetedData == true) {
            print("111");
            print(a.ml);
            if (a.item == type) {
              // currentwork = currentwork + double.parse(a.ml);
              infusionSheet.add(a);
            }
          } else {
            print('33333');
          }
        }
      }

      // print('last workday  : ${lastwork}');
      print('current workday  : ${currentwork}');
    }

    return infusionSheet;
  }

  Future<double> getInfusedVol(
    PatientDetailsData data,
    String type,
    String date,
    String time,
  ) async {
    // double lastwork = 0;
//this function is used for 2 parts please make seperate if any changes in one
    // it is returning total infused for both ( IN and OUT )

    double infusedVol = 0.0;
    Vigilance vigilance = await getFluidBalanace(data);
    String workingday = await getWorkingDays(data.hospital[0].sId);
    var concenated_date_fromfunc = '${date} ${time}:00';
    var date_concenated_with_adminTime = '${date} ${workingday}:00';
    print(concenated_date_fromfunc);
    print("concenated_date_fromfunc");
    print(date_concenated_with_adminTime);

    if (vigilance != null && vigilance.result.first.data != null) {
      print('getting vigilance len : ${vigilance.result.first.data.length}');
      bool isbefore = DateTime.parse(concenated_date_fromfunc)
          .isBefore(DateTime.parse(date_concenated_with_adminTime));
      if (isbefore) {
        var date_1 = DateTime.parse(date_concenated_with_adminTime)
            .subtract(Duration(days: 1));
        var date_2 = DateTime.parse(date_concenated_with_adminTime)
            .add(Duration(days: 1));
        for (var a in vigilance.result.first.data) {
          print('obj : ${a.date} ${a.time}:00');
          var dateTimee = await '${a.date} ${a.time}:00';
          // var target_date = '${DateFormat(commonDateFormat).format(date)} ${workingday}:00';
          // var dateAfter_targetDate = DateTime.parse(target_date).add(Duration(days: 1));

          print('target date --- ${date_1}');
          print('date after target date --- ${date_2}');

          // print('s d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

          // bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
          // bool targetedData = await DateTime.parse(dateTimee).isAfter(DateTime.parse(target_date))&& DateTime.parse(dateTimee).isBefore(DateTime.parse(dateAfter_targetDate.toString()));
          bool targetedData = await DateTime.parse(date_1.toString())
                  .isAfter(DateTime.parse(date_1.toString())) &&
              DateTime.parse(dateTimee)
                  .isBefore(DateTime.parse(date_2.toString()));

          if (targetedData == true) {
            print("tttt");
            if (a.item == type) {
              infusedVol = infusedVol + double.parse(a.ml);
            }
          } else {
            print('nooooo');
          }
        }
      } else {
        for (var a in vigilance.result.first.data) {
          print('obj : ${a.date} ${a.time}:00');
          var dateTimee = await '${a.date} ${a.time}:00';
          var target_date =
              '${DateFormat(commonDateFormat).format(DateTime.parse(date))} ${workingday}:00';
          var dateAfter_targetDate =
              DateTime.parse(target_date).add(Duration(days: 1));
          // var today = '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
          // var last = '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
          print('target date --- ${target_date}');
          print('date after target date --- ${dateAfter_targetDate}');

          // print('s d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

          // bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
          bool targetedData = await DateTime.parse(dateTimee)
                  .isAfter(DateTime.parse(target_date)) &&
              DateTime.parse(dateTimee)
                  .isBefore(DateTime.parse(dateAfter_targetDate.toString()));

          if (targetedData == true) {
            print("111");
            if (a.item == type) {
              infusedVol = infusedVol + double.parse(a.ml);
            }
          } else {
            print('33333');
          }
        }
      }

      // print('last workday  : ${lastwork}');
      print('current workday  : ${infusedVol}');
    }
    var ret_obj;
    if (type == "Enteral Nutrition") {
      ret_obj = infusedVol / 0.75;
    } else {
      ret_obj = infusedVol;
    }

    return ret_obj;
  }

  Future<double> getinfused_BetweenIntervals(
    PatientDetailsData data,
    String type,
    DateTime start_interval,
    DateTime end_interval,
  ) async {
    double infusedVol = 0.0;
    Vigilance vigilance = await getFluidBalanace(data);

    if (vigilance != null && vigilance.result.first.data != null) {
      for (var a in vigilance.result.first.data) {
        var dateTimee = await '${a.date} ${a.time}:00';

        adLog('dateTimee=== : $dateTimee');

        bool targetData = DateTime.parse(dateTimee).isAfter(start_interval) && DateTime.parse(dateTimee).isBefore(end_interval);
        if (targetData == true) {
          print("111");
          if (a.item == type) {
            infusedVol = infusedVol + double.parse(a.ml);
          }
        } else {
          print('33333');
        }
      }
    }

    var ret_obj;
    if (type == "Enteral Nutrition" ||
        type == "Enteral Protein Module" ||
        type == "Enteral Fiber Module") {
      ret_obj = infusedVol / 0.75;
    } else {
      ret_obj = infusedVol;
    }

    print('ret_obj :: $ret_obj');
    return ret_obj;
  }

  Future<double> getinfused_BetweenIntervalsReport(
      PatientDetailsData data,
      String type,
      DateTime start_interval,
      DateTime end_interval,
      ) async {
    double infusedVol;
    Vigilance vigilance = await getFluidBalanace(data);

    if (vigilance != null && vigilance.result.first.data != null) {
      for (var a in vigilance.result.first.data) {
        var dateTimee = await '${a.date} ${a.time}:00';
        bool targetData = DateTime.parse(dateTimee).isAfter(start_interval) &&
            DateTime.parse(dateTimee).isBefore(end_interval);

        adLog('a.item :: ${a.ml}  dateTimee :: $dateTimee');
        adLog('start_interval : $start_interval   end_interval : $end_interval');

        if (targetData == true) {
          print("111");
          if (a.item == type) {


            infusedVol = 0.0;
            infusedVol = infusedVol + double.parse(a.ml);
          }
        } else {
          print('33333');
        }
      }
    }

    var ret_obj;
    if (type == "Enteral Nutrition" || type == "Enteral Protein Module" || type == "Enteral Fiber Module") {

      if(infusedVol!=null) {
        ret_obj = infusedVol / 0.75;
      }

    } else {
      ret_obj = infusedVol;
    }
    return ret_obj;
  }

}
