import 'dart:convert';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusion_formula.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusionReport_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_model.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/contollers/NutritionalTherapy/getCurrentNeed.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/fiberProteinModule.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

// import 'package:medical_app/model/NutritionalTherapy/parenteral_NutritionalModel.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_History_Model.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class ParenteralNutrional_Controller extends GetxController {
  HistoryController _historyController = HistoryController();
  PARENTERALDATA parenteraldata;
  BalanceSheetController balanceSheetController = BalanceSheetController();
  InfusionReportController infuse_controller = InfusionReportController();
  EnteralNutritionalController eternalCtrlr = EnteralNutritionalController();
  var readyTouse = List<PARENTERALDATA>().obs;

  Future<ParenteralData> getParenteral(PatientDetailsData data) async {
    ParenteralData parenteralData;
    if (!data.ntdata.isNullOrBlank) {
      var getdata = await data.ntdata.firstWhere(
          (element) =>
              element.type == NTBoxes.parenteralFormula &&
              element.status == PARENTERAL_STATUS.parenteral_status,
          orElse: () => null);
      if (!getdata.isNullOrBlank && !getdata.result.isNullOrBlank) {
        parenteralData = await getdata?.result[0].parenteralData;
      }
    }
    return parenteralData;
  }

  Future<List<ParenteralData>> getParenteralList(
      PatientDetailsData data) async {
    List<ParenteralData> parenteralData = [];
    if (!data.ntdata.isNullOrBlank) {
      var getdata = await data.ntdata.firstWhere(
          (element) =>
              element.type == NTBoxes.parenteralFormula &&
              element.status == PARENTERAL_STATUS.parenteral_status,
          orElse: () => null);
      if (!getdata.isNullOrBlank && getdata.result.isNotEmpty) {
        parenteralData = await getdata.result[0].parenteralDetails;
      }
    }
    print('return previous data -  ${parenteralData.length}');
    return parenteralData;
  }

  Future<Parenteral_NutritionalModel> getRouteModuleForMode(
      String hospId) async {
    bool internet = await checkConnectivityWithToggle(hospId);
    Parenteral_NutritionalModel output;
    if (internet != null && internet) {
      output = await get_parenteral_nutrinoalData(hospId);
      print('internet avialable');
    } else {
      output = await get_parenteral_nutrinoalDataFromSqlite(hospId);
    }

    return output;
  }

  Future<Parenteral_NutritionalModel> get_parenteral_nutrinoalData(
      String hospitalId) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    Parenteral_NutritionalModel parenteral_nutritionalModel;
    try {
      print(APIUrls.getNutritionParenteral);
      Request request = Request(url: APIUrls.getNutritionParenteral, body: {
        'hospitalId': hospitalId,
      });
      print(request.body);
      await request.post().then((value) {
        parenteral_nutritionalModel =
            Parenteral_NutritionalModel.fromJson(jsonDecode(value.body));
        print(value.body);
        print(parenteral_nutritionalModel.success);
        print(parenteral_nutritionalModel.data.length);

        if (parenteral_nutritionalModel.success == true) {
          print('ppppppp');
          print(parenteral_nutritionalModel.data.isNotEmpty
              ? parenteral_nutritionalModel.data[0].title
              : 'mmmmmmm');

          for (var a in parenteral_nutritionalModel.data) {
            if (a.isActive) {
              readyTouse.add(a);
            }
          }
        } else {
          ShowMsg(parenteral_nutritionalModel.message);
        }
      });
    } catch (e) {
      print("Exception...${e.toString()}");
    }
    return parenteral_nutritionalModel;
  }

  Future<Parenteral_NutritionalModel> get_parenteral_nutrinoalDataFromSqlite(
      String hospId) async {
    Parenteral_NutritionalModel output;
    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {
          var data = wardList.offline.ntPanel.parenteralData;
          print('ppppppp');
          print(data.isNotEmpty ? data[0].title : 'mmmmmmm');

          for (var a in data) {
            if (a.isActive) {
              readyTouse.add(a);
            }
          }

          output = Parenteral_NutritionalModel(
              data: data, message: "", success: true);
        } else {
          ShowMsg(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    return output;
  }

  Future<String> computeVolume(PARENTERALDATA _pdata, String bagsPerDay,
      String startTime, String hourInfusion) async {
    // Total Volume (calculated = ‘Number of bags/day’ x ‘Volume per bag’ registered ON ADMIN PANEL for that parenteral formula)

    String output;
    if (!_pdata.isNullOrBlank && !bagsPerDay.isNullOrBlank) {
      print('bag ml : ${jsonEncode(_pdata)}');
      print('bag ml : ${_pdata.bag}');

      double bag = double.parse(_pdata.bag);
      double perday = double.parse(bagsPerDay);
      double total = bag * perday;
      output = await total.toStringAsFixed(2);
      print('total volume : ${output}');
    }
    return output;
  }

  Future<String> computeCalories(PARENTERALDATA _pdata, String bagsPerDay,
      String startTime, String hourInfusion) async {
    // Total kcal (calculated = ‘Number of bags/day’ x ‘kcal total’ registered ON ADMIN PANEL for that parenteral formula)

    String output;
    if (!_pdata.isNullOrBlank && !bagsPerDay.isNullOrBlank) {
      print('bag ml : ${jsonEncode(_pdata)}');
      print('bag ml : ${_pdata.bag}');

      // int bag =  _pdata.bag;
      double kcal = double.parse(_pdata.kcal);
      double perday = double.parse(bagsPerDay);
      double total = perday * kcal;
      output = await total.toStringAsFixed(2);
      print('total calories : ${output}');
    }
    return output;
  }

  Future<List<double>> computeMacro(
      PARENTERALDATA _pdata, String bagsPerDay) async {
    //Protein (g) (calculated = ‘Number of bags/day’ x ‘protein (g)’ registered ON ADMIN PANEL for that parenteral formula)
    // Glucose (g) (calculated = ‘Number of bags/day’ x ‘glucose (g)’ registered ON ADMIN PANEL for that parenteral formula)
    // Lipids (g) (calculated = ‘Number of bags/day’ x ‘lipids (g)’ registered ON ADMIN PANEL for that parenteral formula)

    double protien;
    double liquid;
    double glucose;
    List<double> output = [];
    if (!_pdata.isNullOrBlank && !bagsPerDay.isNullOrBlank) {
      // print('bag ml : ${jsonEncode(_pdata)}');
      // print('bag ml : ${_pdata.bag}');

      double perday = await double.parse(bagsPerDay);
      protien = await perday * double.parse(_pdata.protein);
      liquid = await perday * double.parse(_pdata.lipids);
      glucose = await perday * double.parse(_pdata.glucose);

      output = [protien, liquid, glucose];
      print('total macro : ${output}');
    }
    return output;
  }

  Future<List<double>> computeRelativeMcro(
      PARENTERALDATA _pdata,
      String bagsPerDay,
      PatientDetailsData patientDetailsData,
      String _infusion,
      String getLipids,
      String getGlucose) async {
    //Lipids g/kg/day (calculated = ‘Lipids (g)’ / ‘weight after discount’ )
    // Glucose g/kg/min (calculated = (‘Glucose (g)’ / 1000) / ‘weight after discount’ / (‘Hours of infusion’ x 60)

    double liquid;
    double glucose;
    List<double> output = [];
    // if (!_pdata.isNullOrBlank && !bagsPerDay.isNullOrBlank) {
    // print('bag ml : ${jsonEncode(_pdata)}');
    // print('bag ml : ${_pdata.bag}');

    if (!patientDetailsData.anthropometry.isNullOrBlank &&
        !patientDetailsData
            ?.anthropometry?.first?.discountedWeight?.isNullOrBlank &&
        _infusion.isNotEmpty &&
        getLipids.isNotEmpty &&
        getGlucose.isNotEmpty) {
      double discountedWeight = await double.parse(
          patientDetailsData.anthropometry.first.discountedWeight);

      liquid = await double.parse(getLipids) / discountedWeight;
      glucose = await (double.parse(getGlucose) * 1000) /
          discountedWeight /
          (double.parse(_infusion) * 60);

      print(
          "glucose = (double.parse(${getGlucose}) / 1000 ) / $discountedWeight / (double.parse($_infusion) * 60)");

      output = [liquid, glucose];
      print('total relative macro : ${output}');
    }
    // }
    return output;
  }

  Future<String> onSavedParenteral(
    PatientDetailsData data,
    Map readyData,
    Reduced_options reducedOptions,
    int teamStatus,
    bool tabStatus,
    Map manipulated,
    Map nonNutritional,
    bool is_lastPresent,
  ) async {
    var surgery_postOpList = await get_reduced_justif(
        data,
        Surgery_postOpList(
            lastUpdate: DateTime.now().toString(),
            surgery_postOp: reducedOptions.surgery_postOp,
            type: "justification"));
    Reducesed_justification reducesed_justification = Reducesed_justification(
        lastUpdate: DateTime.now().toString(),
        justification: reducedOptions.selected_reason,
        surgery_postOp: reducedOptions.surgery_postOp,
        surgery_postOpList: surgery_postOpList);

    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "team_status": teamStatus,
      "tab_status": tabStatus,
      "ready_to_use": readyData,
      "manipulated": manipulated,
      "non_nutritional": nonNutritional,
      "reduced_justification": reducesed_justification,
      // "ready_to_use_details": [readyData],
      // "manipulated_details": [manipulated],
    };

    List<ParenteralData> getParenteral =
        await addParenteralItem(data, finalData);
    Map output = {
      "lastUpdate": '${DateTime.now()}',
      "parenteral_data": finalData,
      "parenteral_details": getParenteral,
    };

    print('parenteral details : ${getParenteral.length}');
    print('final data on saved : ${jsonEncode(output)}');
    print(manipulated["total_macro"]);
    print(readyData["total_macro"]["protein"]);
    var calc_needData = await calAchievement_PlannedProtein(
        tabStatus == true
            ? double.parse(readyData["total_macro"]["protein"])
            : double.parse(manipulated["total_macro"]["protein"]),
        tabStatus
            ? double.parse(readyData["total_vol"])
            : double.parse(manipulated["total_vol"]),
        tabStatus
            ? double.parse(readyData["current_work"])
            : double.parse(manipulated["current_work"]),
        tabStatus
            ? double.parse(readyData["total_cal"])
            : double.parse(manipulated["total_cal"]),
        data,
        "parenteral",
        parenteraldata);
    print('rrrfr.....${nonNutritional["total"]}');
    var non_nutritional_item = await Needs(
        lastUpdate: DateTime.now().toString(),
        plannedKcal: "0.0",
        plannedPtn: "0.0",
        type: "non_nutritional",
        achievementProtein: "0.0",
        achievementKcal:
            nonNutritional["total"] == "" ? "0.0" : nonNutritional["total"]);

    List<Needs> needsData = [];
    if (tabStatus) {
      needsData = await getNut(
        data,
        readyData['current_work'],
        calc_needData,
        non_nutritional_item,
        readyData['title_id'],
      );
    } else {
      needsData = await getNut(
        data,
        manipulated['current_work'],
        calc_needData,
        non_nutritional_item,
        '',
      );
    }

    var first_interval_times;
    var second_interval_times;
    double getInfused = await balanceSheetController.getNutritional(
        data, "Parenteral Nutrition");


   adLog('message start_date :: ${manipulated["start_date"]}');
    // var paternal_interval = await eternalCtrlr.getTimeInterval(data, "", 0);

    first_interval_times = await eternalCtrlr.getTimeInterval(data,
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
        1);
    second_interval_times = await eternalCtrlr.getTimeInterval(data,
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
        2);
    var first_interval_ml_Expected = await computeCurrentWorkFirstInterveral(
        data,
        tabStatus ? readyData["total_vol"] : manipulated["total_vol"],
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
    );
    var nextday_ml_Expected = await computeCurrentWorkSecondInterveral(
        data,
        tabStatus ? readyData["total_vol"] : manipulated["total_vol"],
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
        is_lastPresent
            ? first_interval_ml_Expected
            : tabStatus == true
                ? readyData['current_work']
                : manipulated['current_work'],
        tabStatus ? readyData["hr_infusion"] : manipulated["hr_infusion"],
        tabStatus);

    print("last_present...gg ${is_lastPresent}");
    print("last_present...gg ${first_interval_ml_Expected}");
    Map parenteral_firstInterval = {
      "type": "Parenteral Nutrition",
      // "start_interval":paternal_interval[0].toString(),
      "start_interval": first_interval_times[0].toString(),
      // "end_interval":paternal_interval[1].toString(),
      "end_interval": first_interval_times[1].toString(),
      "date": DateFormat(commonDateFormat).format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "lastUpdate": '${DateTime.now()}',
      "formula_name": tabStatus == true ? readyData['title'] : "manipulated",
      // "expected_vol": tabStatus == true ? readyData['current_work'] : manipulated['current_work'],
      "expected_vol": is_lastPresent
          ? first_interval_ml_Expected
          : tabStatus == true
              ? readyData['current_work']
              : manipulated['current_work'],
      "infused_vol": getInfused.toString()
    };

    Map parenteral_secondInterval = {
      "type": "Parenteral Nutrition",
      // "start_interval":paternal_interval[0].toString(),
      "start_interval": second_interval_times[0].toString(),
      // "end_interval":paternal_interval[1].toString(),
      "end_interval": second_interval_times[1].toString(),
      "date": DateFormat(commonDateFormat).format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "lastUpdate": '${DateTime.now()}',
      "formula_name": tabStatus == true ? readyData['title'] : "manipulated",
      "expected_vol": nextday_ml_Expected,
      //tabStatus == true ? readyData['current_work'] : manipulated['current_work'],
      "infused_vol": getInfused.toString()
    };

    adLog('parenteral_secondInterval :: ${parenteral_secondInterval}');

    var times = await eternalCtrlr.getHospital_start_endTime(data);

    List formula_data = [parenteral_firstInterval, parenteral_secondInterval];

    await getRouteForModeSave(data, output, needsData, formula_data, times);
  }

  Future<String> getRouteForModeSave(PatientDetailsData data, Map dataa,
      List<Needs> needsData, List formulaData, List<String> times) async {
    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {
      await apicall(data, dataa, needsData, formulaData, times);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, needsData, formulaData, times);
    }

    return 'success';
  }

  Future<String> apicall(PatientDetailsData data, Map dataa,
      List<Needs> needsData, List formulaData, List<String> times) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.parenteralFormula,
        "status": PARENTERAL_STATUS.parenteral_status,
        'score': '0',
        'apptype': '1',
        'needs': needsData.isNotEmpty
            ? jsonEncode(needsData)
            : jsonEncode(data.needs),
        'result': jsonEncode([dataa]),
        'formula': jsonEncode(formulaData),

        "currenttime": DateFormat('HH:mm').format(DateTime.now()),
        // "hospitaltime":times[1],
        "hospitaltime": DateFormat('HH:mm').format(DateTime.parse(times[1])),
        "date": DateFormat(commonDateFormat).format(DateTime.now()),
        "time": DateFormat('HH:mm').format(DateTime.now()),

        "currentdate": times[0],
        "hospitaldate": times[1],
        "formulastatus": "parenteral",
        "hospitalId": data.hospital.first.sId
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          Get.offAll(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 4,
            statusIndex: 5,
          ));

          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
      Map historymap = {
        "lastUpdate": dataa["lastUpdate"],
        "parenteral_data": dataa["parenteral_data"]
      };
      print("historymap.toString()");
      print(historymap.toString());
      _historyController.saveMultipleMsgHistory(
          data.sId, ConstConfig.parenteralHistory, [historymap]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  void saveDataOffline(PatientDetailsData data, Map dataa,
      List<Needs> needsData, List formulaData, List<String> times) async {
    // "type": NTBoxes.parenteralFormula,
    // "status": PARENTERAL_STATUS.parenteral_status,

    List<Ntdata> getData = await data.ntdata;

    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Ntdata updatedData = await Ntdata(
        status: PARENTERAL_STATUS.parenteral_status,
        type: NTBoxes.parenteralFormula,
        score: '0',
        userId: data.sId,
        result: [res]);

    print("updatedData::${updatedData}");

    if (getData.length != 0) {
      Ntdata conditionData;
      for (var a in getData) {
        if (a.type == NTBoxes.parenteralFormula &&
            a.status == PARENTERAL_STATUS.parenteral_status) {
          conditionData = a;
          break;
        }
      }
      getData.remove(conditionData);
      getData.add(updatedData);
    } else {
      getData.add(updatedData);
    }

    print('getData :: ${getData}');
    data.ntdata = await getData;

    // data.needs = needsData.isNotEmpty? jsonEncode(needsData): jsonEncode(data.needs);

    if (needsData.isNotEmpty) {
      data.needs = needsData;
    }

    print('data.needs :: ${data.needs}');

    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

    InfusionReportFormula reportFormula = InfusionReportFormula();
    await reportFormula.updateParenteralFormulaInfusion(
        data, dataa, formulaData, times);

    Get.offAll(Step1HospitalizationScreen(
      patientUserId: data.sId,
      index: 4,
      statusIndex: 5,
    ));
  }

  Future<String> getRouteForModeSaveInterupted(
      PatientDetailsData data, List<Needs> needs) async {
    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {
      await apicallInterrupted(data, needs);
      print('internet avialable');
    } else {
      await saveDataOfflineInterupted(data, needs);
    }

    return 'success';
  }

  Future<String> apicallInterrupted(
      PatientDetailsData data, List<Needs> needs) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.parenteralFormula,
        "status": PARENTERAL_STATUS.parenteral_status,
        'score': '0',
        'apptype': '1',
        'needs': jsonEncode(needs),
        'result': jsonEncode([]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          Get.offAll(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 4,
            statusIndex: 5,
          ));

          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
      // Map historymap = {
      //   "lastUpdate":dataa["lastUpdate"],
      //   "parenteral_data":dataa["parenteral_data"]
      //
      // };
      // print("historymap.toString()");
      // print(historymap.toString());
      // _historyController.saveMultipleMsgHistory(data.sId, ConstConfig.parenteralHistory, [historymap]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  void saveDataOfflineInterupted(
      PatientDetailsData data, List<Needs> needs) async {
    // "type": NTBoxes.parenteralFormula,
    // "status": PARENTERAL_STATUS.parenteral_status,

    List<Ntdata> getData = await data.ntdata;

    Ntdata updatedData = await Ntdata(
        status: PARENTERAL_STATUS.parenteral_status,
        type: NTBoxes.parenteralFormula,
        score: '0',
        userId: data.sId,
        result: []);

    print("updatedData::${updatedData}");

    if (getData.length != 0) {
      Ntdata conditionData;
      for (var a in getData) {
        if (a.type == NTBoxes.parenteralFormula &&
            a.status == PARENTERAL_STATUS.parenteral_status) {
          conditionData = a;
          break;
        }
      }
      getData.remove(conditionData);
      getData.add(updatedData);
    } else {
      getData.add(updatedData);
    }

    print('getData :: ${getData}');
    data.ntdata = await getData;

    data.needs = needs;
    print('data.needs :: ${data.needs}');

    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);
    Get.offAll(Step1HospitalizationScreen(
      patientUserId: data.sId,
      index: 4,
      statusIndex: 5,
    ));
  }

  Future<List<ParenteralData>> addParenteralItem(
      PatientDetailsData data, Map item) async {
    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    List<ParenteralData> previous = await getParenteralList(data);

    List<ParenteralData> allData = [];
    ParenteralData addItem = ParenteralData();

    if (previous != null && previous.isNotEmpty) {
      print('privous : ${previous.length}');
      for (var a in previous) {
        if (DateTime.parse(a.lastUpdate).isAfter(lastWorkStart)) {
          allData.add(a);
        }
      }
      // allData.addAll(previous);
    }

    addItem.lastUpdate = item['lastUpdate'];
    addItem.teamStatus = item['team_status'];
    addItem.tabStatus = item['tab_status'];

    ReadyToUse readyToUse = ReadyToUse();
    readyToUse.lastUpdate = item['ready_to_use']['lastUpdate'];
    readyToUse.title = item['ready_to_use']['title'];
    readyToUse.titleId = item['ready_to_use']['title_id'];
    readyToUse.bagPerDay = item['ready_to_use']['bag_per_day'];
    readyToUse.bagsFromAdmin = item['ready_to_use']['bags_from_admin'];
    readyToUse.startTime = item['ready_to_use']['start_time'];
    readyToUse.startDate = item['ready_to_use']['start_date'];
    readyToUse.hrInfusion = item['ready_to_use']['hr_infusion'];
    readyToUse.totalVol = item['ready_to_use']['total_vol'];
    readyToUse.totalCal = item['ready_to_use']['total_cal'];
    readyToUse.currentWork = item['ready_to_use']['current_work'];

    TotalMacro totalMacro = TotalMacro();

    totalMacro.protein = item['ready_to_use']['total_macro']['protein'];
    totalMacro.glucose = item['ready_to_use']['total_macro']['glucose'];
    totalMacro.liquid = item['ready_to_use']['total_macro']['liquid'];

    readyToUse.totalMacro = totalMacro;

    RelativeMacro relativeMacro = RelativeMacro();

    relativeMacro.liquid = item['ready_to_use']['relative_macro']['liquid'];
    relativeMacro.glucose = item['ready_to_use']['relative_macro']['glucose'];

    readyToUse.relativeMacro = relativeMacro;

    addItem.readyToUse = readyToUse;

    Manipulated manipulated = Manipulated();
    manipulated.lastUpdate = item['manipulated']['lastUpdate'];
    manipulated.startTime = item['manipulated']['start_time'];
    manipulated.startDate = item['manipulated']['start_date'];
    manipulated.hrInfusion = item['manipulated']['hr_infusion'];
    manipulated.totalVol = item['manipulated']['total_vol'];
    manipulated.totalCal = item['manipulated']['total_cal'];
    manipulated.currentWork = item['manipulated']['current_work'];

    TotalMacro totalMacro2 = TotalMacro();
    totalMacro2.glucose = item['manipulated']['total_macro']['glucose'];
    totalMacro2.protein = item['manipulated']['total_macro']['protein'];
    totalMacro2.liquid = item['manipulated']['total_macro']['liquid'];

    manipulated.totalMacro = totalMacro2;

    RelativeMacro relativeMacro2 = RelativeMacro();

    relativeMacro2.liquid = item['manipulated']['relative_macro']['liquid'];
    relativeMacro2.glucose = item['manipulated']['relative_macro']['glucose'];

    manipulated.relativeMacro = relativeMacro2;

    addItem.manipulated = manipulated;

    NonNutritional nonNutritional = NonNutritional();

    nonNutritional.propofol = item['non_nutritional']['propofol'];
    nonNutritional.glucose = item['non_nutritional']['glucose'];
    nonNutritional.citrate = item['non_nutritional']['citrate'];
    nonNutritional.total = item['non_nutritional']['total'];

    addItem.nonNutritional = nonNutritional;

    allData.add(addItem);

    return allData;
  }

  Future<String> computeCurrentWork(
      PatientDetailsData data,
      String totalVol,
      String hourPerDay,
      String bagsPerDay,
      String bags,
      String _startTime,
      String _startDate,
      bool tabStatus) async {
    DateTime currentWorkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));
    double output;
    if (!totalVol.isNullOrBlank &&
        !_startTime.isNullOrBlank && !_startDate.isNullOrBlank &&
        !hourPerDay.isNullOrBlank) {

      adLog('_startDate :: $_startDate');

      DateTime startTime = DateTime.parse(
          '${DateFormat(commonDateFormat).format(DateTime.parse(_startDate))} ${_startTime}:00');


      adLog('currentWorkday :: $currentWorkday startTime :: $startTime');

      double hour = currentWorkday.difference(startTime).inMinutes/60;

      adLog('getting hour:: $hour');

      // double total =
      // adLog('mlPerhour ${totalVol} * hourPerday $hourPerDay / 24 * totalHours $hour');

      //[number of bags x bag (mL)] x [number of hours from start time up to the workday start] / number of hours of infusion
      // output = (double.parse(totalVol) * double.parse(hourPerDay) )/ (24 * hour);
      // adLog("bags bags :: double.parse($bagsPerDay) * double.parse($bags)) * ($hour / double.parse($hourPerDay)");

      if (tabStatus) {
        output = (double.parse(bagsPerDay) * double.parse(bags)) *
            (hour / double.parse(hourPerDay));
      } else {
        output = (double.parse(totalVol) * hour) / double.parse(hourPerDay);
      }
      adLog('output current work : ${output}');
    }

    return output?.toStringAsFixed(1) ?? null;
  }

  Future<String> computeCurrentWorkSecondInterveral(
      PatientDetailsData data,
      String totalVol,
      String _startTime,
      String _startDate,
      var currentWork,
      var hrInfusion,
      bool tabStatus) async {
    print('current work First Interval');
    // DateTime currentWorkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now());
    DateTime currentWorkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));
    double output;
    if (!totalVol.isNullOrBlank && !_startTime.isNullOrBlank) {
      // DateTime startTime = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${_startTime}:00');
      DateTime startTime = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.parse(_startDate).add(Duration(days: 1)))} ${_startTime}:00');

      double hour = startTime.difference(currentWorkday).inMinutes/60;

      print('getting hour ${hour}');

      // print('current work second Interval : ${output}');
      //
      // adLog('totalVol : $totalVol  current work : $currentWork');

      // if (tabStatus) {
      //   var calculated = double.parse(totalVol) / (24 / hour);
      //   output = calculated;
      // } else {
        adLog('else part');
        double calculated = (double.parse(totalVol) * hour) / double.parse(hrInfusion);

        var remaining = double.parse(totalVol) - double.parse(currentWork ?? '0.0');

        adLog('remaining $remaining < calculated $calculated');

        bool diff = remaining < calculated;
        if (diff) {
          output = remaining;
        } else {
          output = calculated;
        }
      // }
    }

    return output?.toStringAsFixed(1) ?? "0.0";
  }

  Future<String> computeCurrentWorkFirstInterveral(
      PatientDetailsData data, String totalVol, String _startTime,String _startDate) async {
    print('current work First Interval');
    // DateTime currentWorkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now());
    DateTime currentWorkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));
    double output;
    if (!totalVol.isNullOrBlank && !_startTime.isNullOrBlank) {
      // DateTime startTime = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${_startTime}:00');
      adLog('_startTime ::: $_startTime _startDate : $_startDate');

      DateTime startTime = DateTime.parse(
          '$_startDate ${_startTime}:00');

      double hour = currentWorkday.difference(startTime).inMinutes/60;

      print('getting hour ${hour}');

      output = double.parse(totalVol) / (24 / hour);
      print('current work First Intervall : ${output}');
    }

    return output?.toStringAsFixed(1) ?? "0.0";
  }

  Future<double> computeCurrentWorkPreviousSchduled(
    PatientDetailsData data,
  ) async {
    List<ParenteralData> previous = await getParenteralList(data);
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    DateTime currentworkdayend = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    double output = 0.0;

    if (previous != null && previous.isNotEmpty) {
      List<ParenteralData> last = [];
      List<ParenteralData> current = [];
      for (var a in previous) {
        DateTime _date = DateTime.parse(a.lastUpdate);
        if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
          last.add(a);
        } else if (_date.isAfter(currentworkday) &&
            _date.isBefore(currentworkdayend)) {
          current.add(a);
        }
      }

      print('last ${last.length}');
      print('current ${current.length}');

      if (last.isNotEmpty) {
        ParenteralData lastwork = await updatedDateSelect(last);
        // output.add(lastwork);
        print('last selcted : ${lastwork}');

        if (lastwork.tabStatus) {
          DateTime startTime = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.parse(lastwork.readyToUse.startDate).add(Duration(days: 1)))} ${lastwork.readyToUse.startTime}:00');
          print('today diff : ${startTime.difference(currentworkday).inHours}');
          double hour = startTime.difference(currentworkday).inMinutes/60;

          double a = (double.parse(lastwork.readyToUse.bagPerDay) *
                  double.parse(lastwork.readyToUse.bagsFromAdmin)) *
              (hour / double.parse(lastwork.readyToUse.hrInfusion));

          adLog('bagPerDay : ${lastwork.readyToUse.bagPerDay} * bagsFromAdmin ${lastwork.readyToUse.bagsFromAdmin} * hour $hour/hrInfusion ${lastwork.readyToUse.hrInfusion}');
          print('current work scheduled if: ${a}');

          var infusion = await computeCurrentWorkPrevious(data) ?? null;
          adLog(
              ' ======>   infusion: $infusion  total vol: ${lastwork.readyToUse.totalVol}');

          var remaining = double.parse(lastwork.readyToUse.totalVol) - double.parse(infusion ?? '0.0');

          // output = a;

          bool diff = remaining < a;
          if (diff) {
            output = remaining;
          } else {
            output = a;
          }

        } else {

          adLog('lastwork.manipulated.startDate :: ${lastwork.manipulated.startDate}');

          DateTime startTime = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.parse(lastwork.manipulated.startDate).add(Duration(days: 1)))} ${lastwork.manipulated.startTime}:00');
          print(' ${startTime.difference(currentworkday).inHours}');
          double hour = startTime.difference(currentworkday).inMinutes/60;

          double calculated =
              (double.parse(lastwork.manipulated.totalVol) * hour) / double.parse(lastwork.manipulated.hrInfusion);

          var infusion = await computeCurrentWorkPrevious(data) ?? null;
          adLog(
              ' ======>   infusion: $infusion  total vol: ${lastwork.manipulated.totalVol}');

          var remaining = double.parse(lastwork.manipulated.totalVol) - double.parse(infusion ?? '0.0');

          adLog('remaining $remaining < calculated $calculated');

          bool diff = remaining < calculated;
          if (diff) {
            output = remaining;
          } else {
            output = calculated;
          }
        }
      }
    }

    adLog('computeCurrentWorkPreviousSchduled $output');

    return output;
  }

  Future<String> computeCurrentWorkPrevious(
    PatientDetailsData data,
  ) async {
    List<ParenteralData> previous = await getParenteralList(data);
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    // DateTime currentworkdayend = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    adLog('lastworkday : $lastworkday ---- currentworkday : $currentworkday');

    String output;

    if (previous != null && previous.isNotEmpty) {
      List<ParenteralData> last = [];

      for (var a in previous) {
        DateTime _date = DateTime.parse(a.lastUpdate);
        if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
          last.add(a);
        }
      }

      print('last ${last.length}');
      // print('current ${current.length}');

      if (last.isNotEmpty) {
        ParenteralData lastwork = await updatedDateSelect(last);
        // output.add(lastwork);
        print('last selcted : ${lastwork}');

        if (lastwork.tabStatus) {
          output = lastwork.readyToUse.currentWork;
        } else {
          output = lastwork.manipulated.currentWork;
        }
      }
      // if (current.isNotEmpty) {
      //   LastSelected currentwork = await updatedDateSelect(current);
      //   output.add(currentwork);
      //   print('current selcted : ${currentwork}');
      // }
    }

    print('last infusion : ${output}');
    return output;
  }

  Future<List<Needs>> getneedsAfterInterpt(
    PatientDetailsData data,
    bool tabStatus,
    String readyData_ptn,
    String manipulated_ptn,
    String readyData_totalVol,
    String mani_totalVol,
    String ready_currentWork,
    String mani_currentWork,
    String ready_totalkcl,
    String mani_totalkcl,
    String ready_titleId,
  ) async {
    print(readyData_ptn);
    print(tabStatus);
    print(manipulated_ptn);
    print(readyData_totalVol);
    var calc_needData = await calAchievement_PlannedProtein(
        tabStatus == true
            ? double.parse(readyData_ptn)
            : double.parse(manipulated_ptn),
        tabStatus
            ? double.parse(readyData_totalVol)
            : double.parse(mani_totalVol),
        tabStatus
            ? double.parse(ready_currentWork)
            : double.parse(mani_currentWork),
        tabStatus ? double.parse(ready_totalkcl) : double.parse(mani_totalkcl),
        data,
        "parenteral",
        parenteraldata);
    // print('rrrfr.....${nonNutritional["total"]}');
    var non_nutritional_item = await Needs(
        lastUpdate: DateTime.now().toString(),
        plannedKcal: "0.0",
        plannedPtn: "0.0",
        type: "non_nutritional",
        achievementProtein: "0.0",
        achievementKcal: "0.0");

    List<Needs> needsData = [];
    if (tabStatus) {
      needsData = await getNut(
        data,
        ready_currentWork,
        calc_needData,
        non_nutritional_item,
        ready_titleId,
      );
    }
    return needsData;
  }

  Future<ParenteralData> updatedDateSelect(List<ParenteralData> list) async {
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  var historyData = List<Data_history>().obs;

  Future<List<Data_history>> getParenteral_HistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.parenteralHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        Parenteral_HIstoryModel model =
            Parenteral_HIstoryModel.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          // historyData.clear();
          print(model.data);
          historyData.addAll(model.data);

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
    return historyData;
  }

  //get needs data from parenteral formula (both ready to use & manipulated)
  //***********************************************************************
  Future<List<Needs>> getNut(PatientDetailsData data, String currentWork,
      Needs additem, Needs non_nutritional_item, String id) async {
    // double getInfused = await balanceSheetController.getNutritional(
    //     data, "Parenteral Nutrition");
    // print('getInfused : $getInfused');
    // print('getCurrentWork : $currentWork');

    // var getData;
    // getData = await readyTouse.firstWhere((element) => element.sId == id,
    //     orElse: () => null);

    // print('selected dropdown value : ${jsonEncode(getData)}');
    //
    // double getcurrentwork = double.parse(currentWork);
    // // double protein = double.parse(getData.protein);
    // // double kcal = double.parse(getData.kcal);
    //
    // double getPer = (getInfused * 100) / getcurrentwork;
    //
    // print('enteral nutritional acceptance per : ${getPer}');
    //
    // double pkcal = ifBlankReturnZero(getData != null ? getData.kcal : "0.0");
    // double pptn = ifBlankReturnZero(getData != null ? getData.protein : "0.0");
    // double akcal = pkcal * getPer / 100;
    // double aptn = pptn * getPer / 100;
    //
    // print('---------total----------');
    // print('plan kcal : ${pkcal}');
    // print('plan ptn : ${pptn}');
    //
    // print('Ach kcal : ${akcal}');
    // print('Ach ptn : ${aptn}');
    //
    Needs addItem = additem;

    // addItem.lastUpdate = '${DateTime.now()}';
    // addItem.type = PARENTERAL_STATUS.parenteral_status;
    //
    // addItem.plannedKcal = pkcal.toString();
    // addItem.plannedPtn = pptn.toString();
    //
    // addItem.achievementKcal = akcal.toStringAsFixed(2);
    // addItem.achievementProtein = aptn.toStringAsFixed(2);

    print('jsonEncode : ${jsonEncode(addItem)}');

    List<Needs> output = await getNeeds(addItem, non_nutritional_item, data);

    return output;
  }

  Future<List<Needs>> getNeeds(
      Needs addItem, Needs nonNutritional, PatientDetailsData data) async {
    NeedsController needsController = NeedsController();

    List<Needs> output = [];
    if (data.needs != null && data.needs.isNotEmpty) {
      output.addAll(data.needs);
    }
    output.add(addItem);
    output.add(nonNutritional);

    print('sending objects : ${jsonEncode(output)}');

    List<Needs> getFilteredData = await needsController.removeSameOb(
        output, data.hospital.first.sId, addItem.type);
    print('getFiltered data : ${jsonEncode(getFilteredData)}');

    List<Needs> finalFilteredData = await needsController.removeSameOb(
        getFilteredData, data.hospital.first.sId, nonNutritional.type);

    return finalFilteredData;
  }

  ifBlankReturnZero(String text) {
    if (text != null && text != '') {
      return double.parse(text.toString());
    } else {
      return 0.0;
    }
  }

  Future<List<Surgery_postOpList>> get_reduced_justif(
      PatientDetailsData data, Surgery_postOpList add_item) async {
    print('pp');
    ParenteralData p_data = await getParenteral(data);
    List<Surgery_postOpList> output = [];

    if (p_data != null && !p_data.isNullOrBlank) {
      for (var a in p_data.reducesed_justification.surgery_postOpList) {
        output.add(a);
      }
    } else {
      output = [];
    }
    output.add(add_item);
    print("iiiiii");
    print(jsonEncode(output));
    var final_list = await eternalCtrlr.removeSameOb_forReducedJustification(
        output, data.hospital.first.sId, add_item.type);
    return final_list;
  }

  Future<Needs> calAchievement_PlannedProtein(
      double protein,
      double total_vol,
      double expected_infused,
      double total_cal,
      PatientDetailsData patentDetail,
      String type,
      PARENTERALDATA parenteraldata) async {
    double proteinPerMl;
    double caloriePerMl;
    double protein_acceptance;
    double calorie_acceptance;
    double infused_vol;
    double plannedProtein = 0.0;
    double achievementProtein = 0.0;
    double plannedKcl = 0.0;
    double achievementKcl = 0.0;

    double protienPerML = 0.0;
    double kcalPerML = 0.0;
    bool isSecond = false;

    if (parenteraldata != null) {
      protienPerML = double.parse(parenteraldata.protein) /
          double.parse(parenteraldata.bag);
      kcalPerML =
          double.parse(parenteraldata.kcal) / double.parse(parenteraldata.bag);
    }

    if (parenteraldata == null) {
      protienPerML = protein;
      kcalPerML = total_cal;
      isSecond = true;
    }

    List<Needs> output = [];
    infused_vol = await infuse_controller.getInfusedVol(
      patentDetail,
      "Parenteral Nutrition",
      DateFormat(commonDateFormat).format(DateTime.now()),
      DateFormat('HH:mm').format(DateTime.now()),
    );
    // infused_vol=await getInfusedVolume(patentDetail, hospitalId);

    print("infused volume ${infused_vol}");

    if (total_vol != 0 || expected_infused != 0 || total_cal != 0) {
      adLog('going with if case expected_infused : $expected_infused');

      proteinPerMl = protein / total_vol;
      plannedProtein = expected_infused * proteinPerMl;
      print("planned protein ${plannedProtein}");
      protein_acceptance = (infused_vol * 100) / expected_infused;
      print("planned acceptance ${protein_acceptance}");
      achievementProtein = (protein_acceptance * plannedProtein) / 100;
      print("achievement protein ${achievementProtein}");

      caloriePerMl = total_cal / total_vol;
      adLog('total_cal $total_cal/ total_vol $total_vol');
      plannedKcl = expected_infused * caloriePerMl;
      print("planned calorie ${plannedKcl}");
      calorie_acceptance = (infused_vol * 100) / expected_infused;
      achievementKcl = (calorie_acceptance * plannedKcl) / 100;
      adLog('(calorie_acceptance $calorie_acceptance * plannedKcl) / 100');
      print("achievement calorie ${achievementKcl}");

      output.add(Needs(
        plannedPtn: "${plannedProtein.toStringAsFixed(2)}",
        plannedKcal: "${plannedKcl.toStringAsFixed(2)}",
        achievementProtein: "${achievementProtein.toStringAsFixed(2)}",
        achievementKcal: "${achievementKcl.toStringAsFixed(2)}",
        type: type,
        lastUpdate: DateTime.now().toString(),
        isSecond: isSecond,
        calculatedParameters: CalculatedParameters(
            protien_perML: protienPerML.toString(),
            kcl_perML: kcalPerML.toString(),
            curruntWork: expected_infused.toString()),
      ));
    } else {
      adLog('going with else case');
      output.add(Needs(
          plannedPtn: "${plannedProtein.toStringAsFixed(2)}",
          plannedKcal: "${plannedKcl.toStringAsFixed(2)}",
          achievementProtein: "${achievementProtein.toStringAsFixed(2)}",
          achievementKcal: "${achievementKcl.toStringAsFixed(2)}",
          type: type,
          lastUpdate: DateTime.now().toString(),
          isSecond: isSecond,
          calculatedParameters: CalculatedParameters(
              protien_perML: protienPerML.toString(),
              kcl_perML: kcalPerML.toString(),
              curruntWork: expected_infused.toString())));
    }
    print("qqqqq ---- ${jsonEncode(output[0])}");
    return output[0];
  }

  // Future<double> getInfusedVolume(PatientDetailsData patentDetail,String hospitalId) async {
  //   String workingday =  await getWorkingDays(hospitalId);
  //
  //   double sum=0.0;
  //   print("===working day ${workingday}");
  //
  //   DateTime now = DateTime.now();
  //   String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
  //   var startDate= "${todayFormattedDate}" +" "+ workingday;
  //   DateTime sd= DateTime.parse(startDate);
  //   print("===start Date ${sd}");
  //
  //   final tomorrow = DateTime(now.year, now.month, now.day + 1);
  //   String tommorowFormattedDate = DateFormat('yyyy-MM-dd').format(tomorrow);
  //   var endDate= "${tommorowFormattedDate}" +" "+ workingday;
  //   DateTime ed=DateTime.parse(endDate);
  //   print("===end date ${ed}");
  //
  //
  //  await getFluidBalanace(patentDetail).then((value){
  //
  //    if(value.result.first.data.length!=null){
  //      for(int i=0;i< value.result.first.data.length;i++){
  //        var date="${(value.result.first.data[i].date)}"+" "+"${(value.result.first.data[i].time)+":00"}";
  //        DateTime d=DateTime.parse(date);
  //        print("===date ${d}");
  //
  //        if(d.isAfter(sd) && d.isBefore(ed)){
  //          if(value.result.first.data[i].item=="Parenteral Nutrition"){
  //            sum = sum + double.parse(value.result[0].data[i].ml);
  //          }
  //        }
  //      }
  //    }
  //     print("===sum ${sum}");
  //   });
  //
  //   print("===return value ${sum}");
  //   return sum;
  //
  // }

  Future<Needs_CurrentDay_List> getNeeds_achievementData(
      PatientDetailsData data, String hospitalId) async {
    List<Needs> needsList = [];
    List<Needs> currentDayNeedsData = [];
    List<Needs> lastDayNeedsData = [];

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    final lastDay = DateTime(now.year, now.month, now.day - 1);
    String tommorowFormattedDate = DateFormat('yyyy-MM-dd').format(lastDay);
    var ed = "${tommorowFormattedDate}" + " " + workingday;
    DateTime LastWorkStart = DateTime.parse(ed);
    print("===last work day date ${LastWorkStart}");

    if (data.needs.length != null) {
      needsList = data.needs;
      print("===needs list length ${needsList.length}");
    }

    for (int i = 0; i < needsList.length; i++) {
      DateTime dateTime = DateTime.parse(needsList[i].lastUpdate);
      print("===dateTime ${dateTime}");

      print(
          "${LastWorkEndCurrentStart} ------ ${LastWorkEndCurrentStart.add(Duration(days: 1))}");

      if (dateTime.isAfter(LastWorkEndCurrentStart) &&
          dateTime.isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
        currentDayNeedsData.add(
          Needs(
              lastUpdate: needsList[i].lastUpdate,
              type: needsList[i].type,
              achievementKcal: needsList[i].achievementKcal,
              achievementProtein: needsList[i].achievementProtein,
              plannedPtn: needsList[i].plannedPtn,
              plannedKcal: needsList[i].plannedKcal,
              isSecond: needsList[i].isSecond,
              calculatedParameters: needsList[i].calculatedParameters == null
                  ? null
                  : needsList[i].calculatedParameters
              //calculatedParameters: CalculatedParameters(protien_perML: needsList[i].calculatedParameters.protien_perML,kcl_perML: needsList[i].calculatedParameters.kcl_perML,curruntWork: needsList[i].calculatedParameters.curruntWork)
              ),
        );
      } else if (dateTime.isBefore(LastWorkEndCurrentStart) &&
          dateTime.isAfter(LastWorkStart)) {
        print("ioioioi ${jsonEncode(needsList[i])}");
        // print("ioioioidddd ${jsonEncode(needsList[i].calculatedParameters)}");
        // print("===dyuy ${jsonEncode(CalculatedParameters(protien_perML: needsList[i].calculatedParameters.protien_perML,kcl_perML: needsList[i].calculatedParameters.kcl_perML,curruntWork: needsList[i].calculatedParameters.curruntWork))}");
        lastDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal,
            calculatedParameters: needsList[i].calculatedParameters == null
                ? null
                : needsList[i].calculatedParameters
            // CalculatedParameters(protien_perML: needsList[i].calculatedParameters.protien_perML,kcl_perML: needsList[i].calculatedParameters.kcl_perML,curruntWork: needsList[i].calculatedParameters.curruntWork)
            ));
      }
    }

    print("===length of currentDayNeedsData ${currentDayNeedsData.length}");
    print("===length of currentDayNeedsData ${lastDayNeedsData.length}");

    return Needs_CurrentDay_List(
        currentDayList: currentDayNeedsData,
        lastDayList: lastDayNeedsData,
        allDayList: needsList);
  }

  Future<Sum_of_ptn_kacl_needsData> get_currentDay_sum_of_enteral_data(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;
    Needs_CurrentDay_List data =
        await getNeeds_achievementData(patientDetailsData, hospitalId);

    if (data.currentDayList.length != null && data.currentDayList.isNotEmpty) {
      for (int i = 0; i < data.currentDayList.length; i++) {
        if (data.currentDayList[i].type == "enteral") {
          total_ptn =
              total_ptn + double.parse(data.currentDayList[i].plannedPtn);
          total_kacl =
              total_kacl + double.parse(data.currentDayList[i].plannedKcal);
        }
      }
      print("===expected ptn amount enteral ${total_ptn}");
      print("===expected kcal amount enteral ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_currentDay_sum_of_proteinModule_data(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;
    Needs_CurrentDay_List data =
        await getNeeds_achievementData(patientDetailsData, hospitalId);

    if (data.currentDayList.length != null && data.currentDayList.isNotEmpty) {
      for (int i = 0; i < data.currentDayList.length; i++) {
        if (data.currentDayList[i].type == "Enteral Protein Module") {
          total_ptn = double.parse(data.currentDayList[i].plannedPtn);
          total_kacl = double.parse(data.currentDayList[i].plannedPtn) * 4;
        }
      }
      print("===amount of protein in protein module ${total_ptn}");
      print("===amount of kacl in protein module ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_currentDay_sum_of_non_nutritional(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double total_kacl = 0.0;
    Needs_CurrentDay_List data =
        await getNeeds_achievementData(patientDetailsData, hospitalId);

    if (data.currentDayList.length != null && data.currentDayList.isNotEmpty) {
      for (int i = 0; i < data.currentDayList.length; i++) {
        if (data.currentDayList[i].type == "non_nutritional") {
          total_kacl =
              total_kacl + double.parse(data.currentDayList[i].achievementKcal);
        }
      }

      print("===amount of kacl in non-nutritional ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: 0, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_ONSData(
      PatientDetailsData patientDetailsData, String hostiptalId) async {
    double ptn = 0.0;
    double kacl = 0.0;

    String workingday = await getWorkingDays(hostiptalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (int i = 0; i < patientDetailsData.ntdata.length; i++) {
      if (patientDetailsData.ntdata[i].status == "ons_acceptance" &&
          patientDetailsData.ntdata[i].type == "3") {
        for (int j = 0;
            j < patientDetailsData.ntdata[i].result.first.onsData.length;
            j++) {
          if (DateTime.parse(patientDetailsData
                      .ntdata[i].result.first.onsData[j].lastUpdate)
                  .isAfter(LastWorkEndCurrentStart) &&
              DateTime.parse(patientDetailsData
                      .ntdata[i].result.first.onsData[j].lastUpdate)
                  .isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
            ptn = double.parse(
                patientDetailsData.ntdata[i].result.first.onsData[j].ptn);
            kacl = double.parse(
                patientDetailsData.ntdata[i].result.first.onsData[j].kcal);
          }
        }
      }
    }
    print("===protein amount in ons${ptn}");
    print("===calorie amount in ons ${kacl}");
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn, sum_of_kacl: kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_oralDiet_NtData(
      PatientDetailsData patientDetailsData, String hostiptalId) async {
    double ptn = 0.0;
    double kacl = 0.0;

    String workingday = await getWorkingDays(hostiptalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (int i = 0; i < patientDetailsData.ntdata.length; i++) {
      if (patientDetailsData.ntdata[i].status == "fasting_oral" &&
          patientDetailsData.ntdata[i].type == "2") {
        for (int j = 0;
            j <
                patientDetailsData
                    .ntdata[i].result.first.fastingOralData.length;
            j++) {
          if (DateTime.parse(patientDetailsData
                      .ntdata[i].result.first.fastingOralData[j].lastUpdate)
                  .isAfter(LastWorkEndCurrentStart) &&
              DateTime.parse(patientDetailsData
                      .ntdata[i].result.first.fastingOralData[j].lastUpdate)
                  .isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
            if (patientDetailsData
                        .ntdata[i].result.first.fastingOralData[j].ptn !=
                    null &&
                patientDetailsData
                        .ntdata[i].result.first.fastingOralData[j].kcal !=
                    null) {
              ptn = double.parse(patientDetailsData
                  .ntdata[i].result.first.fastingOralData[j].ptn);
              kacl = double.parse(patientDetailsData
                  .ntdata[i].result.first.fastingOralData[j].kcal);
            } else {
              ptn = 0;
              kacl = 0;
            }
          }
        }
      }
    }
    print("===protein amount on oraldiet ${ptn}");
    print("===calorie amount in oraldiet ${kacl}");
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn, sum_of_kacl: kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_paternal_current_data(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double total_CurrentDayptn = 0.0;
    double total_CurrentDaykacl = 0.0;
    double prtn_perMl = 0.0;
    double kacl_perMl = 0.0;

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    if (patientDetailsData.ntdata.length != null &&
        patientDetailsData.ntdata.isNotEmpty) {
      for (int i = 0; i < patientDetailsData.ntdata.length; i++) {
        if (patientDetailsData.ntdata[i].status == "parenteral" &&
            patientDetailsData.ntdata[i].type == "6") {
          for (int j = 0;
              j <
                  patientDetailsData
                      .ntdata[i].result.first.parenteralDetails.length;
              j++) {
            if (DateTime.parse(patientDetailsData
                        .ntdata[i].result.first.parenteralDetails[j].lastUpdate)
                    .isAfter(LastWorkEndCurrentStart) &&
                DateTime.parse(patientDetailsData
                        .ntdata[i].result.first.parenteralDetails[j].lastUpdate)
                    .isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
              prtn_perMl = double.parse(patientDetailsData
                      .ntdata[i]
                      .result
                      .first
                      .parenteralDetails[j]
                      .readyToUse
                      .totalMacro
                      .protein) /
                  double.parse(patientDetailsData.ntdata[i].result.first
                      .parenteralDetails[j].readyToUse.bagPerDay);
              total_CurrentDayptn = total_CurrentDayptn +
                  prtn_perMl *
                      double.parse(patientDetailsData.ntdata[i].result.first
                          .parenteralDetails[j].readyToUse.currentWork);
              kacl_perMl = double.parse(patientDetailsData.ntdata[i].result
                      .first.parenteralDetails[j].readyToUse.totalCal) /
                  double.parse(patientDetailsData.ntdata[i].result.first
                      .parenteralDetails[j].readyToUse.bagPerDay);
              total_CurrentDaykacl = total_CurrentDaykacl +
                  kacl_perMl *
                      double.parse(patientDetailsData.ntdata[i].result.first
                          .parenteralDetails[j].readyToUse.currentWork);
            }
          }
        }
      }
    }

    print("=== total protein amount in paternal ${total_CurrentDayptn}");
    print("=== total calorie amount in paternal ${total_CurrentDaykacl}");
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_CurrentDayptn, sum_of_kacl: total_CurrentDaykacl);
  }

  Future<Sum_of_ptn_kacl_needsData> getSum(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double final_ptn = 0.0;
    double final_kacl = 0.0;

    Sum_of_ptn_kacl_needsData ptn_kacl_of_parental_currentDay =
        await get_currentDay_sum_of_paternal_data(
            patientDetailsData, hospitalId);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_eternal_currentDay =
        await get_currentDay_sum_of_enteral_data(
            patientDetailsData, hospitalId);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_oralDiet_currentDay =
        await get_oralDiet_NtData(patientDetailsData, hospitalId);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_ons_currentDay =
        await get_ONSData(patientDetailsData, hospitalId);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_protenModule_currentDay =
        await get_currentDay_sum_of_proteinModule_data(
            patientDetailsData, hospitalId);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_nonNutritional_currentDay =
        await get_currentDay_sum_of_non_nutritional(
            patientDetailsData, hospitalId);

    if (ptn_kacl_of_parental_currentDay.sum_of_ptn != null &&
        ptn_kacl_of_eternal_currentDay.sum_of_ptn != null &&
        ptn_kacl_of_oralDiet_currentDay.sum_of_ptn != null &&
        ptn_kacl_of_ons_currentDay.sum_of_ptn != null &&
        ptn_kacl_of_protenModule_currentDay.sum_of_ptn != null &&
        ptn_kacl_of_nonNutritional_currentDay.sum_of_ptn != null) {
      final_ptn = ptn_kacl_of_parental_currentDay.sum_of_ptn +
          ptn_kacl_of_eternal_currentDay.sum_of_ptn +
          ptn_kacl_of_oralDiet_currentDay.sum_of_ptn +
          ptn_kacl_of_ons_currentDay.sum_of_ptn +
          ptn_kacl_of_protenModule_currentDay.sum_of_ptn +
          ptn_kacl_of_nonNutritional_currentDay.sum_of_ptn;
    }

    if (ptn_kacl_of_parental_currentDay.sum_of_kacl != null &&
        ptn_kacl_of_eternal_currentDay.sum_of_kacl != null &&
        ptn_kacl_of_oralDiet_currentDay.sum_of_kacl != null &&
        ptn_kacl_of_ons_currentDay.sum_of_kacl != null &&
        ptn_kacl_of_protenModule_currentDay.sum_of_kacl != null &&
        ptn_kacl_of_nonNutritional_currentDay.sum_of_kacl != null) {
      final_kacl = ptn_kacl_of_parental_currentDay.sum_of_kacl +
          ptn_kacl_of_eternal_currentDay.sum_of_kacl +
          ptn_kacl_of_oralDiet_currentDay.sum_of_kacl +
          ptn_kacl_of_ons_currentDay.sum_of_kacl +
          ptn_kacl_of_protenModule_currentDay.sum_of_kacl +
          ptn_kacl_of_nonNutritional_currentDay.sum_of_kacl;
    }

    print("===final protein ${final_ptn}");
    print("===final kacl ${final_kacl}");

    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: final_ptn, sum_of_kacl: final_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_currentDay_sum_of_paternal_data(
    PatientDetailsData patientDetailsData,
    String hospitalId,
  ) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;
    Needs_CurrentDay_List data =
        await getNeeds_achievementData(patientDetailsData, hospitalId);

    if (data.currentDayList.length != null && data.currentDayList.isNotEmpty) {
      for (int i = 0; i < data.currentDayList.length; i++) {
        if (data.currentDayList[i].type == "parenteral") {
          total_ptn =
              total_ptn + double.parse(data.currentDayList[i].plannedPtn);
          total_kacl =
              total_kacl + double.parse(data.currentDayList[i].plannedKcal);
        }
      }
      print("=== ptn amount in  parentral ${total_ptn}");
      print("=== kacl amount in  parentral ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_min_max_ptn_Kacl> get_condition_customizedData(
      PatientDetailsData patientDetailsData, String hospitalId) async {
    double sum_max_ptn = 0.0;
    double sum_min_ptn = 0.0;
    double sum_max_kacl = 0.0;
    double sum_min_kacl = 0.0;

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (int i = 0; i < patientDetailsData.ntdata.length; i++) {
      if (patientDetailsData.ntdata[i].status == "customized" &&
          patientDetailsData.ntdata[i].type == "1") {
        if (patientDetailsData.ntdata[i].result.first.cutomizedData != null &&
            !patientDetailsData.ntdata[i].result.first.cutomizedData.isBlank) {
          sum_min_kacl = double.parse(patientDetailsData
              .ntdata[i].result.first.cutomizedData.minEnergy);
          sum_max_kacl = double.parse(patientDetailsData
              .ntdata[i].result.first.cutomizedData.maxEnergy);
          sum_min_ptn = double.parse(patientDetailsData
              .ntdata[i].result.first.cutomizedData.minProtien);
          sum_max_ptn = double.parse(patientDetailsData
              .ntdata[i].result.first.cutomizedData.maxProtien);
        }
      }
    }

    print("== minimum customized protein ${sum_min_ptn}");
    print("== maximum customized protein ${sum_max_ptn}");
    print("== minimum customized kcal ${sum_min_kacl}");
    print("== maximum customized kacal ${sum_max_kacl}");

    return Sum_of_min_max_ptn_Kacl(
        min_ptn: sum_min_ptn,
        max_ptn: sum_max_ptn,
        min_kacl: sum_min_kacl,
        max_kacl: sum_max_kacl);
  }

  int getPercent(double min_value, double max_value) {
    double result = 0.0;
    int resultPerc = 0;
    if (max_value != null && max_value != 0.0 && min_value != null) {
      result = (min_value * 100) / max_value;
      resultPerc = result.round();
    } else {
      return 0;
    }
    return resultPerc;
  }

  Future<Needs_Show_Data> getPercentOfNeedsData(
      PatientDetailsData patientDetailsData, String hostpitalId) async {
    // Sum_of_ptn_kacl_needsData d1= await getSum(patientDetailsData, patientDetailsData.hospital.first.sId);
    Sum_of_min_max_ptn_Kacl d2 = await get_condition_customizedData(
        patientDetailsData, patientDetailsData.hospital.first.sId);
    print('getData d2 : $d2');

    CurrentNeed currentNeed = CurrentNeed();

    List<double> getData = await currentNeed.getCurrentNeed(patientDetailsData);

    print('getData for planned : $getData');
    // print('getData for planned : ${jsonEncode(d2)}');

    //    if((getData[0]==0.0 && getData[1]==0.0)) {
    // getData = [d2.min_ptn,d2.min_kacl];
    //    // updated by akash at 17 may 8:14 PM
    //    }

    int get_min_kacl_per = await getPercent(getData[1] ?? 0, d2.min_kacl);
    int get_max_kaclPerc = await getPercent(getData[1] ?? 0, d2.max_kacl);
    int get_min_ptn_perc = await getPercent(getData[0] ?? 0, d2.min_ptn);
    int get_max_ptn_perc = await getPercent(getData[0] ?? 0, d2.max_ptn);

    print("=====perc of mininum kacl ${get_min_kacl_per}");
    print("=====perc of maximum kacl ${get_max_kaclPerc}");
    print("=====perc of mininum protein ${get_min_ptn_perc}");
    print("=====perc of maximum protein ${get_max_ptn_perc}");
    print("========================================== ${d2}");

    return Needs_Show_Data(
        customized_min_kacl: d2.min_kacl,
        customized_max_kacl: d2.max_kacl,
        customized_min_ptn: d2.min_ptn,
        customized_max_ptn: d2.max_ptn,
        min_kacl_perc: get_min_kacl_per,
        max_kacl_perc: get_max_kaclPerc,
        min_ptn_perc: get_min_ptn_perc,
        max_ptn_perc: get_max_ptn_perc);
  }

  /*=====================================kcal and protein calculation for last and since admission======================================================================*/

  Future<Sum_of_ptn_kacl_needsData> get_NtData_fasting_oral_filter_list(
      List<Ntdata> dataList, String value_of_day, String hospitalId) async {
    double kacl_amt = 0.0;
    double ptn_amt = 0.0;

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].status == "fasting_oral" && dataList[i].type == "2") {
        for (int j = 0;
            j < dataList[i].result.first.fastingOralData.length;
            j++) {
          if (value_of_day == "lastDay") {
            if (DateTime.parse(
                        dataList[i].result.first.fastingOralData[j].lastUpdate)
                    .isBefore(LastWorkEndCurrentStart) &&
                DateTime.parse(
                        dataList[i].result.first.fastingOralData[j].lastUpdate)
                    .isAfter(
                        LastWorkEndCurrentStart.subtract(Duration(days: 1)))) {
              ptn_amt =
                  double.parse(dataList[i].result.first.fastingOralData[j].ptn);
              kacl_amt = double.parse(
                  dataList[i].result.first.fastingOralData[j].kcal);
            }
          } else if (value_of_day == "sinceAdmission") {
            ptn_amt = ptn_amt +
                double.parse(dataList[i].result.first.fastingOralData[j].ptn);
            kacl_amt = kacl_amt +
                double.parse(dataList[i].result.first.fastingOralData[j].kcal);
          }
        }
      }
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_kacl: kacl_amt, sum_of_ptn: ptn_amt);
  }

  Future<Sum_of_ptn_kacl_needsData> get_NtData_Onsfilter_list(
      List<Ntdata> dataList, String value_of_day, String hospitalId) async {
    double kacl_amt = 0.0;
    double ptn_amt = 0.0;

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");
    print(
        "===current Date ${LastWorkEndCurrentStart.subtract(Duration(days: 1))}");
    print(
        "===current Date ${LastWorkEndCurrentStart.subtract(Duration(days: 2))}");

    for (int i = 0; i < dataList.length; i++) {
      if (dataList[i].status == "ons_acceptance" && dataList[i].type == "3") {
        for (int j = 0; j < dataList[i].result.first.onsData.length; j++) {
          if (value_of_day == "lastDay") {
            if (DateTime.parse(dataList[i].result.first.onsData[j].lastUpdate)
                    .isBefore(LastWorkEndCurrentStart) &&
                DateTime.parse(dataList[i].result.first.onsData[j].lastUpdate)
                    .isAfter(
                        LastWorkEndCurrentStart.subtract(Duration(days: 1)))) {
              ptn_amt = double.parse(dataList[i].result.first.onsData[j].ptn);
              kacl_amt = double.parse(dataList[i].result.first.onsData[j].kcal);
            }
          } else if (value_of_day == "sinceAdmission") {
            ptn_amt =
                ptn_amt + double.parse(dataList[i].result.first.onsData[j].ptn);
            kacl_amt = kacl_amt +
                double.parse(dataList[i].result.first.onsData[j].kcal);
          }
        }
      }
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_kacl: kacl_amt, sum_of_ptn: ptn_amt);
  }

  Future<Sum_of_min_max_ptn_Kacl> get_sorted_data_of_customized_details(
      List<CutomizedData> dataList, String hospitalId, String value) async {
    List<CutomizedData> LastDay_customizedList = [];
    double total_customized_min_ptn = 0.0;
    double total_customized_max_ptn = 0.0;
    double total_customized_min_kcal = 0.0;
    double total_customized_max_kcal = 0.0;

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (int i = 0; i < dataList.length; i++) {
      if (DateTime.parse(dataList[i].lastUpdate)
              .isAfter(LastWorkEndCurrentStart.subtract(Duration(days: 1))) &&
          DateTime.parse(dataList[i].lastUpdate)
              .isBefore(LastWorkEndCurrentStart)) {
        LastDay_customizedList.add(CutomizedData(
            minEnergy: dataList[i].minEnergy,
            maxEnergy: dataList[i].maxEnergy,
            maxProtien: dataList[i].maxProtien,
            minProtien: dataList[i].minProtien,
            minEnergyValue: dataList[i].minEnergyValue,
            maxEnergyValue: dataList[i].maxEnergyValue,
            minProtienValue: dataList[i].minProtienValue,
            manProtienValue: dataList[i].manProtienValue,
            lastUpdate: dataList[i].lastUpdate,
            condition: dataList[i].condition));
      } else {
        if (dataList.isNotEmpty && dataList.length != null) {
          for (int i = 0; i < dataList.length; i++) {
            total_customized_min_ptn =
                total_customized_min_ptn + double.parse(dataList[i].minProtien);
            total_customized_max_ptn =
                total_customized_max_ptn + double.parse(dataList[i].maxProtien);
            total_customized_min_kcal =
                total_customized_min_kcal + double.parse(dataList[i].minEnergy);
            total_customized_max_kcal =
                total_customized_max_kcal + double.parse(dataList[i].maxEnergy);
          }
        }
      }
    }

    print("Last Day customizedList ${LastDay_customizedList.length}");

    if (LastDay_customizedList.isNotEmpty) {
      LastDay_customizedList.sort((a, b) {
        var adate = DateTime.parse(a.lastUpdate);
        var bdate = DateTime.parse(b.lastUpdate);

        return -adate.compareTo(bdate);
      });
      print(
          "=last day sorted list 123 \n ${jsonEncode(LastDay_customizedList)}");
    }

    if (value == "lastDay") {
      print("== greater value \n ${jsonEncode(LastDay_customizedList[0])}");
      return Sum_of_min_max_ptn_Kacl(
          min_kacl: double.parse(LastDay_customizedList[0].minEnergy),
          max_kacl: double.parse(LastDay_customizedList[0].maxEnergy),
          min_ptn: double.parse(LastDay_customizedList[0].minProtien),
          max_ptn: double.parse(LastDay_customizedList[0].maxProtien));
    } else if (value == "sinceAdmission") {
      return Sum_of_min_max_ptn_Kacl(
          min_kacl: total_customized_min_kcal,
          max_kacl: total_customized_max_kcal,
          min_ptn: total_customized_min_ptn,
          max_ptn: total_customized_max_ptn);
    }
  }

  Future<Sum_of_min_max_ptn_Kacl> get_sum_of_allDay_customized_data(
      List<CutomizedData> dataList) async {
    double total_customized_min_ptn = 0.0;
    double total_customized_max_ptn = 0.0;
    double total_customized_min_kcal = 0.0;
    double total_customized_max_kcal = 0.0;

    if (dataList.isNotEmpty && dataList.length != null) {
      for (int i = 0; i < dataList.length; i++) {
        total_customized_min_ptn =
            total_customized_min_ptn + double.parse(dataList[i].minProtien);
        total_customized_max_ptn =
            total_customized_max_ptn + double.parse(dataList[i].maxProtien);
        total_customized_min_kcal =
            total_customized_min_kcal + double.parse(dataList[i].minEnergy);
        total_customized_max_kcal =
            total_customized_max_kcal + double.parse(dataList[i].maxEnergy);
      }
    }

    print("total sum of customized min protein ${total_customized_min_ptn}");
    print("total sum of customized max protein ${total_customized_max_ptn}");
    print("total sum of customized min kcal ${total_customized_min_kcal}");
    print("total sum of customized max kcal ${total_customized_max_kcal}");

    return Sum_of_min_max_ptn_Kacl(
        min_ptn: total_customized_min_ptn,
        max_ptn: total_customized_max_ptn,
        min_kacl: total_customized_min_kcal,
        max_kacl: total_customized_max_kcal);
  }

  Future<Sum_of_ptn_kacl_needsData> get_last_day_eternalData(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "enteral") {
          total_ptn = total_ptn + double.parse(dataList[i].plannedPtn);
          total_kacl = total_kacl + double.parse(dataList[i].plannedKcal);
        }
      }
      print("===expected ptn amount enteral ${total_ptn}");
      print("===expected kcal amount enteral ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastday_sum_of_paternal_data(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "parenteral") {
          total_ptn = total_ptn + double.parse(dataList[i].plannedPtn);
          total_kacl = total_kacl + double.parse(dataList[i].plannedKcal);
        }
      }
      print("=== ptn amount in  parentral ${total_ptn}");
      print("=== kacl amount in  parentral ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<CalculatedParameters> get_lastday_parentralcalulated_params(
      List<Needs> dataList) async {
    var retData;
    if (dataList.length != null && dataList.isNotEmpty) {
      print("datalist... ${jsonEncode(dataList)}");
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "parenteral") {
          print("9999.. ${jsonEncode(dataList[i])}");
          retData = await CalculatedParameters(
              protien_perML: dataList[i].calculatedParameters.protien_perML,
              kcl_perML: dataList[i].calculatedParameters.kcl_perML,
              curruntWork: dataList[i].calculatedParameters.curruntWork);
          // print("9999.. ${jsonEncode(retData)}");
        }
      }
      // print("=== ptn amount in  parentral ${total_ptn}");
      // print("=== kacl amount in  parentral ${total_kacl}");
    }

    return retData;
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastday_parentraldata(
      List<Needs> dataList, double infusedParenteral) async {
    var retData;
    double a = 0.0;
    double b = 0.0;
    print("datalist... ${jsonEncode(dataList)}");
    CalculatedParameters
        calculatedParams; //= await get_lastday_parentralcalulated_params(dataList);
    if (dataList.length != null && dataList.isNotEmpty) {
      calculatedParams = await get_lastday_parentralcalulated_params(dataList);
      if (calculatedParams != null) {
        a = infusedParenteral * double.parse(calculatedParams.protien_perML);
        print("a.k ${a}");
        b = infusedParenteral * double.parse(calculatedParams.kcl_perML);
      } else {
        print('calculated is nlul ');
      }
      // print("=== ptn amount in  parentral ${total_ptn}");
      // print("=== kacl amount in  parentral ${total_kacl}");
    }

    print("b.... ${b}");

    return Sum_of_ptn_kacl_needsData(sum_of_ptn: a, sum_of_kacl: b);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastDay_sum_of_proteinModule_data(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "Enteral Protein Module") {
          total_ptn = total_ptn + double.parse(dataList[i].plannedPtn);
          total_kacl = total_kacl + double.parse(dataList[i].plannedKcal);
        }
      }
      print("===amount of protein in protein module ${total_ptn}");
      print("===amount of kacl in protein module ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_achievedNonNutritional(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "non_nutritional") {
          total_ptn = total_ptn + double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl + double.parse(dataList[i].achievementKcal);
        }
      }
      print("===amount of protein in non nutrition ${total_ptn}");
      print("===amount of kacl in non nutrition ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_achieved_oralDiet(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "oral_acceptance") {
          total_ptn = total_ptn + double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl + double.parse(dataList[i].achievementKcal);
        }
      }
      print("===amount of protein in non nutrition ${total_ptn}");
      print("===amount of kacl in non nutrition ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastDay_sum_of_Ons_data(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "ons_acceptance") {
          total_ptn = total_ptn + double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl + double.parse(dataList[i].achievementKcal);
        }
      }
      print("===amount of protein in ons_acceptance ${total_ptn}");
      print("===amount of kacl in ons_acceptancee ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastDay_sum_of_oral_acceptance_data(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_ptn = 0.0;
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "oral_acceptance") {
          total_ptn = total_ptn + double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl + double.parse(dataList[i].achievementKcal);
        }
      }
      print("===amount of protein in ons_acceptance ${total_ptn}");
      print("===amount of kacl in ons_acceptancee ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: total_ptn, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastDay_sum_of_non_nutritional(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      List<Needs> dataList) async {
    double total_kacl = 0.0;

    if (dataList.length != null && dataList.isNotEmpty) {
      for (int i = 0; i < dataList.length; i++) {
        if (dataList[i].type == "non_nutritional") {
          total_kacl = total_kacl + double.parse(dataList[i].achievementKcal);
        }
      }

      print("===amount of kacl in non-nutritional ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: 0, sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_achieved_enteral(
      PatientDetailsData data,
      Sum_of_ptn_kacl_needsData ptn_kacl_of_eternal) async {
    DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastworkEnd = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, lastworkStart.add(Duration(days: 1)));

    var lastWorkDayInfused =
        await infuse_controller.getinfused_BetweenIntervals(
            data, "Enteral Nutrition", lastworkStart, lastworkEnd);
    // print("pppppp ${jsonEncode(lastWorkDayInfused)}");
    var a = await lastWorkDayInfused * ptn_kacl_of_eternal.sum_of_kacl;

    var b = await lastWorkDayInfused * ptn_kacl_of_eternal.sum_of_ptn;

    var kcl = await double.parse(a.toStringAsFixed(2));

    var ptn = await double.parse(b.toStringAsFixed(2));

    print("ppppppe ${kcl}");
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn, sum_of_kacl: kcl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_achieved_protienModule(
      PatientDetailsData data,
      Sum_of_ptn_kacl_needsData ptn_kacl_of_eternalModule) async {
    print('oo');
    var kcl = 0.0;
    var ptn = 0.0;
    if (ptn_kacl_of_eternalModule.sum_of_kacl != 0.0 &&
        ptn_kacl_of_eternalModule.sum_of_ptn != 0.0) {
      DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

      DateTime lastworkEnd = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, lastworkStart.add(Duration(days: 1)));

      var lastWorkDayInfused =
          await infuse_controller.getinfused_BetweenIntervals(
              data, "Enteral Protein Module", lastworkStart, lastworkEnd);

      print("iiipp... ${jsonEncode(lastWorkDayInfused)}");
      double g_perML = ptn_kacl_of_eternalModule.sum_of_ptn /
          ptn_kacl_of_eternalModule.sum_of_kacl;
      print("ptn_kacl_of_eternalModule.sum_of_ptn");
      print(ptn_kacl_of_eternalModule.sum_of_ptn);
      print(ptn_kacl_of_eternalModule.sum_of_kacl);
      var a = lastWorkDayInfused * g_perML * 4;
      print("uuuu3.. ${g_perML}");
      print("uuuu.. ${a}");
      var b = lastWorkDayInfused * g_perML;
      // print("pppppp ${jsonEncode(lastWorkDayInfused)}");

      kcl = double.parse(a.toStringAsFixed(2));

      ptn = double.parse(b.toStringAsFixed(2));

      print("dom.l, ${ptn}");
    }

    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn, sum_of_kacl: kcl);
  }

  Future<Sum_of_ptn_kacl_needsData> getSumofLastAndSinceAdmission(
      PatientDetailsData patientDetailsData,
      String hospitalId,
      String value) async {
    double final_ptn = 0.0;
    double final_kacl = 0.0;
    List<Needs> dataList = [];

    DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
        patientDetailsData.hospital.first.sId,
        DateTime.now().subtract(Duration(days: 1)));

    DateTime lastworkEnd = await getDateTimeWithWorkdayHosp(
        patientDetailsData.hospital.first.sId,
        lastworkStart.add(Duration(days: 1)));

    print("start.. ${lastworkStart}");
    print("endd.. ${lastworkEnd}");
    var lastWorkDayParenteralInfused =
        await infuse_controller.getinfused_BetweenIntervals(patientDetailsData,
            "Parenteral Nutrition", lastworkStart, lastworkEnd);
    print("iiilll... ${jsonEncode(lastWorkDayParenteralInfused)}");

    Sum_of_ptn_kacl_needsData ptn_kacl_of_oralDiet;
    Sum_of_ptn_kacl_needsData ptn_kacl_of_ons;
    Sum_of_ptn_kacl_needsData ptn_kacl_of_oral;
    Sum_of_ptn_kacl_needsData achieved_oraldiet;

    Needs_CurrentDay_List data =
        await getNeeds_achievementData(patientDetailsData, hospitalId);
    print('yyyyyyy${jsonEncode(data.allDayList)}');
    print('yyyyyyy${jsonEncode(data.lastDayList)}');
    if (value == "lastDay") {
      dataList = data.lastDayList;
    } else if (value == "sinceAdmission") {
      dataList = data.allDayList;
    }

    // Sum_of_ptn_kacl_needsData ptn_kacl_of_parental =  await get_lastday_sum_of_paternal_data(patientDetailsData, hospitalId,dataList);
    var lastDayParenteral =
        await get_lastday_parentraldata(dataList, lastWorkDayParenteralInfused);
    Sum_of_ptn_kacl_needsData ptn_kacl_of_eternal =
        await get_last_day_eternalData(
            patientDetailsData, hospitalId, dataList);

    Sum_of_ptn_kacl_needsData achieved_eneteral =
        await get_achieved_enteral(patientDetailsData, ptn_kacl_of_eternal);

    if (value == "lastDay") {
      ptn_kacl_of_oralDiet = await get_NtData_fasting_oral_filter_list(
          patientDetailsData.ntdata, value, hospitalId);
      achieved_oraldiet =
          await get_achieved_oralDiet(patientDetailsData, hospitalId, dataList);
    } else if (value == "sinceAdmission") {
      ptn_kacl_of_oralDiet = await get_NtData_fasting_oral_filter_list(
          patientDetailsData.ntdata, value, hospitalId);
      achieved_oraldiet =
          await get_achieved_oralDiet(patientDetailsData, hospitalId, dataList);
    }

    if (value == "lastDay") {
      // ptn_kacl_of_ons =  await get_NtData_Onsfilter_list(patientDetailsData.ntdata,value, hospitalId);
      ptn_kacl_of_ons = await get_lastDay_sum_of_Ons_data(
          patientDetailsData, hospitalId, dataList);
    } else if (value == "sinceAdmission") {
      // ptn_kacl_of_ons =  await get_NtData_Onsfilter_list(patientDetailsData.ntdata,value, hospitalId);
      ptn_kacl_of_ons = await get_lastDay_sum_of_Ons_data(
          patientDetailsData, hospitalId, dataList);
    }
    if (value == "lastDay") {
      ptn_kacl_of_oral = await get_lastDay_sum_of_oral_acceptance_data(
          patientDetailsData, hospitalId, dataList);
    } else if (value == "sinceAdmission") {
      ptn_kacl_of_oral = await get_lastDay_sum_of_oral_acceptance_data(
          patientDetailsData, hospitalId, dataList);
    }

    Sum_of_ptn_kacl_needsData ptn_kacl_of_protenModule =
        await get_lastDay_sum_of_proteinModule_data(
            patientDetailsData, hospitalId, dataList);
    Sum_of_ptn_kacl_needsData achieved_nonNutritional =
        await get_achievedNonNutritional(
            patientDetailsData, hospitalId, dataList);

    Sum_of_ptn_kacl_needsData achieved_protenModule =
        await get_achieved_protienModule(
            patientDetailsData, ptn_kacl_of_protenModule);

    print("...1  ${achieved_oraldiet.sum_of_kacl}");
    print("...2  ${achieved_oraldiet.sum_of_ptn}");

    print("...3  ${ptn_kacl_of_ons.sum_of_kacl}");
    print("...4  ${ptn_kacl_of_ons.sum_of_ptn}");

    print("...5  ${achieved_eneteral.sum_of_kacl}");
    print("...6  ${achieved_eneteral.sum_of_ptn}");

    print("...7  ${lastDayParenteral.sum_of_kacl}");
    print("...8  ${lastDayParenteral.sum_of_ptn}");

    print("...9  ${achieved_protenModule.sum_of_kacl}");
    print("...10  ${achieved_protenModule.sum_of_ptn}");

    print("...11  ${achieved_nonNutritional.sum_of_ptn}");
    print("...12  ${achieved_nonNutritional.sum_of_kacl}");

    Sum_of_ptn_kacl_needsData ptn_kacl_of_nonNutritional =
        await get_lastDay_sum_of_non_nutritional(
            patientDetailsData, hospitalId, dataList);
    print("jsonEncode(ptn_kacl_of_nonNutritionals)");
    // print(jsonEncode(achieved_protenModule));
    print(jsonEncode(achieved_protenModule.sum_of_kacl));

    if (lastDayParenteral.sum_of_ptn != null &&
        achieved_eneteral.sum_of_ptn != null &&
        achieved_oraldiet.sum_of_ptn != null &&
        ptn_kacl_of_ons.sum_of_ptn != null &&
        achieved_protenModule.sum_of_ptn != null &&
        achieved_nonNutritional.sum_of_ptn != null) {
      final_ptn = lastDayParenteral.sum_of_ptn +
          achieved_eneteral.sum_of_ptn +
          achieved_oraldiet.sum_of_ptn +
          ptn_kacl_of_ons.sum_of_ptn +
          achieved_protenModule.sum_of_ptn +
          achieved_nonNutritional.sum_of_ptn;
    }

    if (lastDayParenteral.sum_of_kacl != null &&
        achieved_eneteral.sum_of_kacl != null &&
        achieved_oraldiet.sum_of_kacl != null &&
        ptn_kacl_of_ons.sum_of_kacl != null &&
        achieved_protenModule.sum_of_kacl != null &&
        achieved_nonNutritional.sum_of_kacl != null) {
      final_kacl = lastDayParenteral.sum_of_kacl +
          achieved_eneteral.sum_of_kacl +
          achieved_oraldiet.sum_of_kacl +
          ptn_kacl_of_ons.sum_of_kacl +
          achieved_protenModule.sum_of_kacl +
          achieved_nonNutritional.sum_of_kacl;
    }

    print("===final protein ${final_ptn}");
    print("===final kacll ${final_kacl}");

    return Sum_of_ptn_kacl_needsData(
        sum_of_ptn: final_ptn, sum_of_kacl: final_kacl);
  }

  Future<Needs_Show_Data> getPercentOfNeedsLastData(
      PatientDetailsData patientDetailsData,
      String hostpitalId,
      String value) async {
    List<CutomizedData> customizedList = [];
    Sum_of_min_max_ptn_Kacl d2;
    Sum_of_ptn_kacl_needsData d1 = await getSumofLastAndSinceAdmission(
        patientDetailsData, patientDetailsData.hospital.first.sId, value);

    for (int i = 0; i < patientDetailsData.ntdata.length; i++) {
      if (patientDetailsData.ntdata[i].status == "customized" &&
          patientDetailsData.ntdata[i].type == "1") {
        customizedList =
            patientDetailsData.ntdata[i].result.first.conditionDetails;
      }
    }

    if (value == "lastDay") {
      d2 = await get_sorted_data_of_customized_details(
          customizedList, patientDetailsData.hospital.first.sId, value);
    } else if (value == "sinceAdmission") {
      d2 = await get_sorted_data_of_customized_details(
          customizedList, patientDetailsData.hospital.first.sId, value);
    }

    int get_min_kacl_per = getPercent(d1.sum_of_kacl, d2.min_kacl);
    int get_max_kaclPerc = getPercent(d1.sum_of_kacl, d2.max_kacl);
    int get_min_ptn_perc = getPercent(d1.sum_of_ptn, d2.min_ptn);
    int get_max_ptn_perc = getPercent(d1.sum_of_ptn, d2.max_ptn);

    print("=====perc of mininum kacl ${get_min_kacl_per}");
    print("=====perc of maximum kacl ${get_max_kaclPerc}");
    print("=====perc of mininum protein ${get_min_ptn_perc}");
    print("=====perc of maximum protein ${get_max_ptn_perc}");

    return Needs_Show_Data(
        customized_min_kacl: d2.min_kacl,
        customized_max_kacl: d2.max_kacl,
        customized_min_ptn: d2.min_ptn,
        customized_max_ptn: d2.max_ptn,
        min_kacl_perc: get_min_kacl_per,
        max_kacl_perc: get_max_kaclPerc,
        min_ptn_perc: get_min_ptn_perc,
        max_ptn_perc: get_max_ptn_perc);
  }
}

class Sum_of_ptn_kacl_needsData {
  double sum_of_ptn;
  double sum_of_kacl;

  Sum_of_ptn_kacl_needsData({this.sum_of_ptn, this.sum_of_kacl});
}

class Needs_CurrentDay_List {
  List<Needs> currentDayList;
  List<Needs> lastDayList;
  List<Needs> allDayList;

  Needs_CurrentDay_List(
      {this.currentDayList, this.lastDayList, this.allDayList});
}

class Sum_of_min_max_ptn_Kacl {
  double min_ptn;
  double max_ptn;
  double min_kacl;
  double max_kacl;

  Sum_of_min_max_ptn_Kacl(
      {this.min_ptn, this.max_ptn, this.min_kacl, this.max_kacl});
}

class Needs_Show_Data {
  double customized_min_kacl;
  double customized_max_kacl;
  double customized_min_ptn;
  double customized_max_ptn;
  int min_ptn_perc;
  int max_ptn_perc;
  int min_kacl_perc;
  int max_kacl_perc;

  Needs_Show_Data(
      {this.customized_min_kacl,
      this.customized_max_kacl,
      this.customized_min_ptn,
      this.customized_max_ptn,
      this.min_kacl_perc,
      this.max_kacl_perc,
      this.min_ptn_perc,
      this.max_ptn_perc});
}
