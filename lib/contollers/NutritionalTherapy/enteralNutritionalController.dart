import 'dart:convert';

import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusion_formula.dart';
import 'package:medical_app/contollers/NutritionalTherapy/non_nutritional_kcal_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusionReport_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_formula_model.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/enteral_History_Model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/numberOfDoses.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class EnteralNutritionalController extends GetxController {
  var industrialized = List<Industrialized>().obs;
  var manipulated = List<Industrialized>().obs;
  var allModuleData = List<ModuleData>().obs;
  Industrialized selectedData;
  HistoryController _historyController = HistoryController();
  BalanceSheetController balanceSheetController = BalanceSheetController();
  InfusionReportController infuse_controller = InfusionReportController();
  TextEditingController plan_ptn = TextEditingController();
  TextEditingController plan_kcal = TextEditingController();
  NonNutritionalKcal nonNutritionalKcal = NonNutritionalKcal();

  Future<String> getRouteFormulaForMode(String hospId) async {
    bool internet = await checkConnectivityWithToggle(hospId);

    if (internet != null && internet) {
      await getFormulaData(hospId);
      print('internet avialable');
    } else {
      await getFormulaFromSqlite(hospId);
    }

    return 'success';
  }





  Future<String> getRouteModuleForMode(String hospId) async {
    bool internet = await checkConnectivityWithToggle(hospId);

    if (internet != null && internet) {
      await getModuleData(hospId);
      print('internet avialable');
    } else {
      await getModuleFromSqlite(hospId);
    }

    return 'success';
  }

  LocaleConfig localeConfig = LocaleConfig();
  var getLocale;

  setLocale() async {
    getLocale = await localeConfig.getLocale();
  }
  Future<String> getFormulaData(String hospId) async {
    Get.dialog(Loader(), barrierDismissible: false);
    await setLocale();
    try {
      print(APIUrls.getEnteralFormula);
      Request request = Request(url: APIUrls.getEnteralFormula, body: {"hospitalId": hospId});

      // print(request.body);
      await request.post().then((value) {
        EnteralFormulaModel model =
            EnteralFormulaModel.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          print(model.industrialized.length);
          print(model.manipulated.length);
          industrialized.clear();

          for (var a in model.industrialized ) {
            if (a.isActive && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              industrialized.add(a);
            }
          }

          manipulated.clear();
          for (var a in model.manipulated) {
            if (a.isActive && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              manipulated.add(a);
            }
          }
        } else {
          adLog(model.message);
        }
      });
    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> getFormulaFromSqlite(String hospId) async {
    await setLocale();
    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {
          industrialized.clear();

          EnteralFormulaModel model = wardList.offline.ntPanel.enternalData;
          for (var a in model.industrialized) {
            if (a.isActive && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              industrialized.add(a);
            }
          }

          manipulated.clear();
          for (var a in model.manipulated) {
            if (a.isActive && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              manipulated.add(a);
            }
          }
        } else {
          adLog(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    // return 'success';
  }

  Future<String> getModuleData(String hospId) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getModuleFormula);
      Request request =
          Request(url: APIUrls.getModuleFormula, body: {"hospitalId": hospId});

      // print(request.body);
      await request.post().then((value) {
        print("vvvvv.. ${value.body}");
        ModuleModel model = ModuleModel.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        // Get.back();
        if (model.success == true) {
          print(model.industrialized.length);
          print(model.manipulated.length);
          allModuleData.clear();
          allModuleData.addAll(model.industrialized);
          allModuleData.addAll(model.manipulated);
        } else {
          adLog(model.message);
        }
      });
    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> getModuleFromSqlite(String hospId) async {
    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {
          ModuleModel model = wardList.offline.ntPanel.moduleData;

          allModuleData.clear();
          allModuleData.addAll(model.industrialized);
          allModuleData.addAll(model.manipulated);
        } else {
          adLog(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    // return 'success';
  }

  Future<String> getLastWorkDayDate(String hospId) async {
    String workday = await getWorkingDays(hospId);

    String priviousDate = await "${DateTime.now().subtract(Duration(days: 1))}";

    String lastDate = await getDateWithMonthName(priviousDate);
    String currentDate = await getDateWithMonthName('${DateTime.now()}');

    print("$lastDate - $workday");
    print("$currentDate - $workday");
    print("$lastDate - $workday" + ' > ' + "$currentDate - $workday");

    return "$lastDate - $workday" + ' > ' + "$currentDate - $workday";
  }

  Future<String> getCurrentNextWorkDayDate(String hospId) async {
    String workday = await getWorkingDays(hospId);

    String nextDate = await "${DateTime.now().add(Duration(days: 1))}";

    String tomorrowDate = await getDateWithMonthName(nextDate);
    String currentDate = await getDateWithMonthName('${DateTime.now()}');

    print("$tomorrowDate - $workday");
    print("$currentDate - $workday");
    print("$currentDate - $workday" + ' > ' + "$tomorrowDate - $workday");

    return "$currentDate - $workday" + ' > ' + "$tomorrowDate - $workday";
  }

  Future<String> getCurrentWorkday(
      TextEditingController ml_h,
      TextEditingController h_day,
      TextEditingController start_time,
      TextEditingController start_date,
      String workday) async {
    //= 20 mL/h x 20 h/day / 24 x 19 = 317 (19 is the number of hours between today ‘start time’ (12:00) and tomorrow ‘work day time’ (7:00)
    if (!ml_h.text.isNullOrBlank &&
        !h_day.text.isNullOrBlank &&
        !start_time.text.isNullOrBlank) {
      double totalHours = 0.0;
      await getHourDifference(workday, start_time.text,start_date.text).then((hr) {
        totalHours = hr;
      });

      double mlPerhour = double.parse(ml_h.text);
      double hourPerday = double.parse(h_day.text);
      // double start = double.parse('$totalHours');
      print('total hour : ${totalHours}');
      print('ml/hr: ${mlPerhour}');
      print('hr/day : ${hourPerday}');

      adLog('mlPerhour$mlPerhour * hourPerday$hourPerday / 24 * totalHours$totalHours');

      double total = mlPerhour * hourPerday / 24 * totalHours;

      print('total current work : ${total}');

      // print('${a.date} ${a.time}:00');
      // var dateTimee = '${a.date} ${a.time}:00';
      //
      // var today =
      //     '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
      // print('today --- ${today}');
      //
      // print(
      //     'sdad----------${DateTime.parse(dateTimee).isBefore(DateTime.parse(today))}');
      //
      // bool get = DateTime.parse(dateTimee).isBefore(DateTime.parse(today));

      return total.toStringAsFixed(2);
    }
  }

  Future<double> getHourDifference(String workday, String startTime,String startDate) async {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");

    var todayDate = dateFormat.format(DateTime.now());
    var tomorrowDate = dateFormat.format(DateTime.now().add(Duration(days: 1)));

    print('output: $todayDate');
    print('$startDate $startTime:00');

    print('output: $tomorrowDate');
    print('$tomorrowDate $workday:00');

    DateTime today = DateTime.parse('$startDate $startTime:00');
    DateTime tomorrow = DateTime.parse('$tomorrowDate $workday:00');

    print('today $today');
    print('tomorrow $tomorrow');
    print("${tomorrow.difference(today).inHours}");

    return tomorrow.difference(today).inMinutes/60;
  }

  Future<List<String>> getEN(String currentWork, Industrialized data) async {
    adLog('currentWork :: ${currentWork}  data.kcal :: ${data.kcal}');
    double enKcal = double.parse(currentWork) * double.parse(data.kcal);
    double enPtn = double.parse(currentWork) * double.parse(data.protein);
    double enFiber = double.parse(currentWork) * double.parse(data.fiber);

    print('Kcal : $enKcal');
    print('Ptn : $enPtn');
    print('Fiber : $enFiber');

    return [
      enKcal.toStringAsFixed(2),
      enPtn.toStringAsFixed(2),
      enFiber.toStringAsFixed(2)
    ];
  }

  Future<List<String>> getModuleTotalData(
      String timesPerDay, ModuleData data, String mass) async {
    double totalAmount;
    double totalVolume;

    if (!timesPerDay.isNullOrBlank && !data.isNullOrBlank) {
      if (data.type == 0) {
        totalAmount =
            await double.parse(timesPerDay) * double.parse(data.protein);
        totalVolume =
            await double.parse(timesPerDay) * double.parse(data.volume);
      } else {
        if (!mass.isNullOrBlank) {
          totalAmount = await double.parse(timesPerDay) * double.parse(mass);
          // adLog('double.parse($mass) * double.parse(${data.protein});');
          //changed formula here
          totalVolume = await totalAmount / double.parse(data.protein);
        } else {
          totalAmount = null;
          totalAmount = null;
        }
      }
    } else {
      totalAmount = null;
      totalAmount = null;
    }

    return [
      totalAmount?.toStringAsFixed(2) ?? null,
      totalVolume?.toStringAsFixed(2) ?? null
    ];
  }

  Future<List<workRecord>> getManiplatedCurrentWork(List<NumberOfDays> data,
      String mlPerDoses, String workday, double privous) async {
    List<workRecord> _record = [];
    double totalWork = 0.0;
    double totalWorkTommorow = 0.0;
    if (!data.isNullOrBlank && !mlPerDoses.isNullOrBlank) {
      var today_date = DateTime.parse(
          '${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
      var tommorrow_date = DateTime.parse(
          '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))} ${workday}:00');
      var tommorrowNext_date = DateTime.parse(
          '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 2)))} ${workday}:00');
      print('today --- ${today_date}');

      // List<DosesData> currentdoses = await getCurrentManipulatedML(patientDetailsData);
      // print('get current doses from prevoius decision : ${currentdoses.length}');

      for (var a in data) {
        var timess = DateTime.parse('${a.schdule_date} ${a.hour}:00');

        print('times : $timess');
        print('is after : ${timess.isAfter(today_date)}');
        print('is before : ${timess.isBefore(tommorrow_date)}');

        if (timess.isAfter(today_date) && timess.isBefore(tommorrow_date)) {
          totalWork = totalWork + double.parse(mlPerDoses);
        }

        if (timess.isAfter(tommorrow_date) &&
            timess.isBefore(tommorrowNext_date)) {
          totalWorkTommorow = totalWorkTommorow + double.parse(mlPerDoses);
        }
      }

      totalWork = totalWork + privous;
      print('total work today : ${totalWork}');
      print('total work tommorow : ${totalWorkTommorow}');

      await _record.add(workRecord(
          totalwork: totalWork.toStringAsFixed(2),
          date: '${DateFormat(commonDateFormat).format(DateTime.now())}'));

      await _record.add(workRecord(
          totalwork: totalWorkTommorow.toStringAsFixed(2),
          date:
              '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}'));
    }

    return _record;
  }

  Future<String> savedData(
      PatientDetailsData patientDetailsData,
      int index,
      int tabIndex,
      Map industData,
      Map manipulatedData,
      Reduced_options reducedOptions,
      String enKcal,
      String enPtn,
      String enFiber,
      ModuleDetail fiberModuledetail,
      ModuleDetail protienModuleDetail,
      String fiberModule,
      String proteinModule,
      double planProtien,
      double planCal,
      double expected_infuse,
      String propofol,
      String glucose,
      String citrate,
      String total) async {
    print('indust data : ${jsonEncode(industData)}');
    print('mani data : ${jsonEncode(manipulatedData)}');
    print('en kcal: $enKcal');
    print('en ptn: $enPtn');
    print('en fiber: $enFiber');
    print('fiber module: $fiberModule');
    print('protein module: $proteinModule');
    print('propofol: $propofol');
    print('glucose: $glucose');
    print('citrate: $citrate');
    print('total: $total');

    // if(!fiberModule.isNullOrBlank && !proteinModule.isNullOrBlank){
    //
    //   if(!propofol.isNullOrBlank && !glucose.isNullOrBlank && !citrate.isNullOrBlank && !total.isNullOrBlank){

    afterAuth(
        patientDetailsData,
        index,
        tabIndex,
        industData,
        manipulatedData,
        reducedOptions,
        enKcal,
        enPtn,
        enFiber,
        fiberModule,
        proteinModule,
        fiberModuledetail,
        protienModuleDetail,
        planProtien,
        planCal,
        expected_infuse,
        propofol,
        glucose,
        citrate,
        total);

    nonNutritionalKcal.saveNonNutritionalKcal(
        patientDetailsData, propofol, glucose, citrate, total);
    // List<IndustrializedData>Data = await getDataIndust(patientDetailsData, industData);
    // print('------- ${jsonEncode(Data)}');

    //   }else{
    //     ShowMsg('Please complete Non Nutritional Calories data.');
    //   }
    //
    // }else{
    //   ShowMsg('Please compute Fiber/Protein module.');
    // }

    // Map data_for_enteralHistory = {
    //   "lastUpdate":'${DateTime.now()}',
    //   "data":[
    //     {
    //       "date":"",
    //       "time":"",
    //       "tabIndex":"",
    //       "industData":industData,
    //       "manipulatedData":manipulatedData,
    //       "enKcal":enKcal,
    //       "enPtn":enPtn,
    //       "enFiber":enFiber,
    //       "fiberModule":fiberModule,
    //       "proteinModule":proteinModule,
    //       "propofol":propofol,
    //       "glucose":glucose,
    //       "citrate":citrate,
    //       "total":total
    //
    //
    //     }
    //   ]
    // };
  }

  Future<String> afterAuth(
      PatientDetailsData patientDetailsData,
      int index,
      int tabIndex,
      Map industData,
      Map manipulatedData,
      Reduced_options reduced_options,
      String enKcal,
      String enPtn,
      String enFiber,
      String fiberModule,
      String proteinModule,
      ModuleDetail fibremoduleDetail,
      ModuleDetail ptnmoduleDetail,
      double planProtien,
      double planCal,
      double expected_infuse,
      String propofol,
      String glucose,
      String citrate,
      String total) async {
    List<IndustrializedData> indust_data =
        await getDataIndust(patientDetailsData, industData,ptnmoduleDetail,fibremoduleDetail);
    List<ManipulatedData> mani_data =
        await getDataMani(patientDetailsData, manipulatedData,ptnmoduleDetail,fibremoduleDetail);
    List<LastSelected> selectedIndex =
        await getselectedIndex(tabIndex.toString(), patientDetailsData);
    print('indust_data len ${indust_data.length}');
    print('mani_data len ${mani_data.length}');
    // var getsurgery_opList=
    var surgery_postOpList = await get_reduced_justif(
        patientDetailsData,
        Surgery_postOpList(
            lastUpdate: DateTime.now().toString(),
            surgery_postOp: reduced_options.surgery_postOp,
            type: "justification"));

    Reducesed_justification reducesed_justification = Reducesed_justification(
        lastUpdate: DateTime.now().toString(),
        justification: reduced_options.selected_reason,
        surgery_postOp: reduced_options.surgery_postOp,
        surgery_postOpList: surgery_postOpList);
    // Surgery_postOpList(lastUpdate: DateTime.now().toString(),surgery_postOp: reduced_options.surgery_postOp,type: "justification")
    final Map data = {
      "lastUpdate": '${DateTime.now()}',
      "last_selected": selectedIndex,
      "team_index": index,
      "tab_index": tabIndex,
      "en_data": {
        "kcal": enKcal,
        "protein": enPtn,
        "fiber": enFiber,
        "fiber_module": fiberModule,
        "protein_module": proteinModule,
        "fiberModule_name": fibremoduleDetail.item,
        "proteinModule_name": ptnmoduleDetail.item,
        "proteinModuleDetail": ptnmoduleDetail,
        "fiberModuleDetail": fibremoduleDetail,
      },
      "calories_data": {
        "propofol": propofol,
        "glucose": glucose,
        "citrate": citrate,
        "total": total,
      },
      "reduced_justification": reducesed_justification,
      "industrialized_data": industData,
      "manipulated_data": manipulatedData,
      "indust_details_data": indust_data,
      "mani_details_data": mani_data,
    };

    final Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "enteral_data": data,
    };

    print('final data : ${jsonEncode(finalData)}');

    var calc_needData = await calculateNeedData(
        patientDetailsData,
        "Enteral Protein Module",
        planProtien,
        ptnmoduleDetail.total_vol != null
            ? double.parse(ptnmoduleDetail.total_vol)
            : 0.0,
        expected_infuse,
        proteinModule.isEmpty ? "0.0" : proteinModule);
    var non_nutri_kcal = await Needs(
        lastUpdate: DateTime.now().toString(),
        plannedKcal: "0.0",
        plannedPtn: "0.0",
        type: "non_nutritional",
        achievementProtein: "0.0",
        achievementKcal: total.isEmpty ? "0.0" : total);
    print("90dddd.. ${jsonEncode(calc_needData)}");

    List<Needs> getNeeds = await getNut(
        patientDetailsData,
        tabIndex == 0
            ? industData['current_work']
            : manipulatedData['current_work'],
        ptnmoduleDetail.total_vol != null ? calc_needData : null,
        non_nutri_kcal,
        tabIndex == 0 ? industData['id'] : manipulatedData['id'],
        tabIndex,selectedData);
    print('qqqqqq');

    double get_fiber_Infused = await balanceSheetController.getNutritional(
        patientDetailsData, "Enteral Fiber Module");

    var modules_interval; // = await getTimeInterval(patientDetailsData, industData["start_time"], 0);
    var first_interval_times; // = await getTimeInterval(patientDetailsData, industData["start_time"], 1);
    var second_interval_times; // = await getTimeInterval(patientDetailsData, industData["start_time"], 2);
    String secondMl = '0.0';
    double firstDayMl =0.0;
    if (tabIndex == 0) {
      modules_interval = await getTimeInterval(
          patientDetailsData, industData["start_time"],industData["start_date"], 0);
      first_interval_times = await getTimeInterval(
          patientDetailsData, industData["start_time"],industData["start_date"], 1);
      second_interval_times = await getTimeInterval(
          patientDetailsData, industData["start_time"], industData["start_date"],2);
    } else {

      var doses = manipulatedData["doses_data"] as List<NumberOfDays>;

      adLog('message doses == ${doses.first.toJson()}');

     String workday = await getWorkingDays(patientDetailsData.hospital.first.sId);

     var resp = await getManiplatedCurrentWork(doses, manipulatedData['ml_dose'], workday, 0.0);
     adLog('tomorrow == ${resp[1].totalwork}');
      secondMl = resp[1].totalwork;
      String _startTime = doses.first.hour;
      String _startDate =  DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: doses.first.istoday?0:1)));

      modules_interval = await getTimeInterval(
          patientDetailsData, _startTime, _startDate,1);

      first_interval_times = await getTimeInterval(
          patientDetailsData, _startTime,_startDate, 1);
      second_interval_times = await getTimeInterval(
          patientDetailsData, _startTime,_startDate,2);

      firstDayMl = await getCurrentManipulatedML(patientDetailsData);

     adLog('message previous $firstDayMl');

    }

    Map fiberModuleData = {
      "type": "Enteral Fiber Module",
      "start_interval": modules_interval[0].toString(),
      "end_interval": modules_interval[1].toString(),
      "date": DateFormat(commonDateFormat).format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "lastUpdate": '${DateTime.now()}',
      "formula_name": fibremoduleDetail.item,
      "expected_vol": fibremoduleDetail.total_vol, //fiberModule,
      "infused_vol": get_fiber_Infused.toString(),
    };

    double get_ptn_Infused = await balanceSheetController.getNutritional(
        patientDetailsData, "Enteral Protein Module");

    Map ptn_ModuleData = {
      "type": "Enteral Protein Module",
      "start_interval": modules_interval[0].toString(),
      "end_interval": modules_interval[1].toString(),
      "date": DateFormat(commonDateFormat).format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "lastUpdate": '${DateTime.now()}',
      "formula_name": ptnmoduleDetail.item,
      "expected_vol": ptnmoduleDetail.total_vol, //proteinModule,
      "infused_vol": get_ptn_Infused.toString(),
    };

    print('.......');
    double getInfused = await balanceSheetController.getNutritional(
        patientDetailsData, "Enteral Nutrition");
    print("inf.....${getInfused}");
    var times = await getHospital_start_endTime(patientDetailsData);

    Map first_interval = {
      "type": "Enteral Nutrition",
      "start_interval": first_interval_times == null
          ? ''
          : first_interval_times[0].toString(),
      "end_interval": tabIndex == 0
          ? first_interval_times[1].toString()
          : modules_interval[1].toString(),
      "date": DateFormat(commonDateFormat).format(DateTime.now()),
      "time": DateFormat('HH:mm').format(DateTime.now()),
      "lastUpdate": '${DateTime.now()}',
      "formula_name":
          tabIndex == 0 ? industData['title'] : manipulatedData['title'],
      "expected_vol": tabIndex == 0
          ? industData['first_interval_mlExpected']
          : firstDayMl!=0.0?firstDayMl.toString(): manipulatedData['current_work'],
      "infused_vol": getInfused.toString()
    };

    List fomulaModules = [first_interval, fiberModuleData, ptn_ModuleData];
    // if (tabIndex == 0) {
      Map second_interval = {
        "type": "Enteral Nutrition",
        "start_interval": second_interval_times[0].toString(),
        "end_interval": second_interval_times[1].toString(),
        "date": DateFormat(commonDateFormat).format(DateTime.now()),
        "time": DateFormat('HH:mm').format(DateTime.now()),
        "lastUpdate": '${DateTime.now()}',
        "formula_name":
            tabIndex == 0 ? industData['title'] : manipulatedData['title'],
        "expected_vol": tabIndex == 0?industData["second_interval_mlExpected"]:secondMl.toString(),
        //tabIndex == 0 ? industData['current_work'] : manipulatedData['current_work'],
        "infused_vol": getInfused.toString()
      };
      fomulaModules.insert(1, second_interval);
    // } else {}

    if (fibremoduleDetail.item.isNullOrBlank ||
        fiberModule.isNullOrBlank ||
        fiberModule == '0') {
      fomulaModules.remove(fiberModuleData);
    }
    if (ptnmoduleDetail.item.isNullOrBlank ||
        proteinModule.isNullOrBlank ||
        proteinModule == '0') {
      fomulaModules.remove(ptn_ModuleData);
    }
// if(industData["second_interval_mlExpected"]==null){
//   fomulaModules.remove(second_interval);
// }

    await getRouteForModeSave(
        patientDetailsData, finalData, getNeeds, fomulaModules, times); //akash

  }

  Future<String> getRouteForModeSave(PatientDetailsData data, Map dataa,
      List<Needs> needs, List formulaData, List<String> times) async {
    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {
      await apicall(data, dataa, needs, formulaData, times);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, needs, formulaData, times);
    }

    return 'success';
  }

  Future<String> apicall(PatientDetailsData data, Map dataa, List<Needs> needs,
      List formulaData, List<String> times) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.enteralFormula,
        "status": ENTERAL_STATUS.enteral_status,
        'score': '0',
        'apptype': '1',
        'needs': jsonEncode(needs),
        'result': jsonEncode([dataa]),
        'formula': jsonEncode(formulaData),
        // "currenttime":times[0],
        "currenttime": DateFormat('HH:mm').format(DateTime.now()),
        // "hospitaltime":times[1],
        "hospitaltime": DateFormat('HH:mm').format(DateTime.parse(times[1])),
        "date": DateFormat(commonDateFormat).format(DateTime.now()),
        "time": DateFormat('HH:mm').format(DateTime.now()),
        "currentdate": times[0],
        "hospitaldate": times[1],
        "formulastatus": "enteral",
        "hospitalId": data.hospital.first.sId
      });

      print(request.body["currentdate"]);
      print(request.body["hospitaldate"]);
      print("request.body['formula'] ::: ${request.body['formula']}");
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
            statusIndex: 4,
          ));

          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);

        } else {
          ShowMsg(commonResponse.message);
        }
      });

      _historyController.saveMultipleMsgHistory(
          data.sId, ConstConfig.enteralHistory, [dataa]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  void saveDataOffline(PatientDetailsData data, Map dataa, List<Needs> needs,
      List formulaData, List<String> times) async {
    // "type": NTBoxes.enteralFormula,
    // "status": ENTERAL_STATUS.enteral_status,

    List<Ntdata> getData = await data.ntdata;

    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Ntdata updatedData = await Ntdata(
        status: ENTERAL_STATUS.enteral_status,
        type: NTBoxes.enteralFormula,
        score: '0',
        userId: data.sId,
        result: [res]);

    print("updatedData::${updatedData}");

    if (getData.length != 0) {
      Ntdata conditionData;
      for (var a in getData) {
        if (a.type == NTBoxes.enteralFormula &&
            a.status == ENTERAL_STATUS.enteral_status) {
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
    InfusionReportFormula reportFormula = InfusionReportFormula();
    await reportFormula.updateEnteralFormulaInfusion(
        data, dataa, needs, formulaData, times);

    Get.offAll(Step1HospitalizationScreen(
      patientUserId: data.sId,
      index: 4,
      statusIndex: 4,
    ));
  }

  Future<String> getRouteForModeSaveInterupted(
      PatientDetailsData data, List<Needs> needs) async {
    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {
      await apicallInterupted(data, needs);
      print('internet avialable');
    } else {
      await saveDataOfflineInterupted(data, needs);
    }

    return 'success';
  }

  Future<String> apicallInterupted(
      PatientDetailsData data, List<Needs> needs) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.enteralFormula,
        "status": ENTERAL_STATUS.enteral_status,
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
            statusIndex: 4,
          ));

          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);

        } else {
          ShowMsg(commonResponse.message);
        }
      });

      // _historyController.saveMultipleMsgHistory(data.sId, ConstConfig.enteralHistory, [dataa]);

    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  void saveDataOfflineInterupted(
      PatientDetailsData data, List<Needs> needs) async {
    List<Ntdata> getData = await data.ntdata;

    Ntdata updatedData = await Ntdata(
        status: ENTERAL_STATUS.enteral_status,
        type: NTBoxes.enteralFormula,
        score: '0',
        userId: data.sId,
        result: []);

    print("updatedData::${updatedData}");

    if (getData.length != 0) {
      Ntdata conditionData;
      for (var a in getData) {
        if (a.type == NTBoxes.enteralFormula &&
            a.status == ENTERAL_STATUS.enteral_status) {
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
      statusIndex: 4,
    ));
  }

  Future<EnteralData> getEnternalData(PatientDetailsData data) async {
    EnteralData enteralData;
    if (!data.ntdata.isNullOrBlank) {
      var getdata = await data.ntdata.firstWhere(
          (element) =>
              element.type == NTBoxes.enteralFormula &&
              element.status == ENTERAL_STATUS.enteral_status,
          orElse: () => null);
      if (!getdata.isNullOrBlank && getdata.result.isNotEmpty) {
        enteralData = await getdata.result[0].enteralData;
      }
    }
    return enteralData;
  }

  // -------------------------------indust--------------------------------------------------

  Future<List<IndustrializedData>> industDataRemoveOldExceptLast(
      PatientDetailsData data, Map indust,ModuleDetail ptn,ModuleDetail fiber) async {
    List<IndustrializedData> industData = [];
    await getEnternalData(data).then((v) {
      if (v != null && !v.industDetailsData.isNullOrBlank) {
        industData.addAll(v.industDetailsData);
      }
    });
    await industData.add(IndustrializedData(
        title: indust['title'],
        currentWork: indust['current_work'],
        hrDay: indust['hr_day'],
        id: indust['id'],
        mlHr: indust['ml_hr'],
        startTime: indust['start_time'],
        startDate: indust['start_date'],
        lastUpdate: indust['lastUpdate'],
        enData: EnData(
          kcal: indust['en_data']['kcal'],
          fiber: indust['en_data']['fiber'],
          protein: indust['en_data']['protein'],
          proteinModule: indust['en_data']['protein_module'],
          fiberModule: indust['en_data']['fiber_module'],
          protienModluleDetail: ptn,
          fiberModluleDetail: fiber,
          plan_kcal: indust['en_data']['plan_kcal'],
         plan_ptn: indust['en_data']['plan_ptn'],
        )));

    print('indust details list len : ${industData.length}');
    print('indust details list : ${jsonEncode(industData)}');

    String workday;
    DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    print('lastWork time start from : ${lastworkStart}');

    List<IndustrializedData> ActiveIndustData = [];
    for (var a in industData) {
      print(
          "data is before last work time start or not : ${DateTime.parse(a.lastUpdate).isAfter(lastworkStart)}");

      if (DateTime.parse(a.lastUpdate).isAfter(lastworkStart)) {
        ActiveIndustData.add(a);
        print(a.lastUpdate);
      }
    }
    return ActiveIndustData;
  }

  Future<List<IndustrializedData>> getDataIndust(
      PatientDetailsData data, Map indust,ModuleDetail ptn,ModuleDetail fiber) async {
    List<IndustrializedData> getData =
        await industDataRemoveOldExceptLast(data, indust,ptn,fiber);

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    // DateTime currentEnd = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    List<IndustrializedData> lastday = [];
    List<IndustrializedData> currentday = [];

    for (var a in getData) {
      if (DateTime.parse(a.lastUpdate).isAfter(lastWorkStart) &&
          DateTime.parse(a.lastUpdate).isBefore(lastWorkEndCurrentStart)) {
        print('lastwork data');
        print('${a.lastUpdate}');
        lastday.add(a);
      } else {
        print('current work data');
        print('${a.lastUpdate}');
        currentday.add(a);
      }
    }

    // IndustrializedData lastwork = await updatedDate(lastday);
    // IndustrializedData currentwork = await updatedDate(currentday);
    //
    // print('updated last : ${lastwork.lastUpdate}');
    // print('updated current : ${currentwork.lastUpdate}');
    List<IndustrializedData> output = [];
    // output.add(lastwork);
    // output.add(currentwork);

    if (!lastday.isNullOrBlank) {
      IndustrializedData lastwork = await updatedDate(lastday);
      print('updated last : ${lastwork.lastUpdate}');
      output.add(lastwork);
    }
    if (!currentday.isNullOrBlank) {
      IndustrializedData currentwork = await updatedDate(currentday);
      print('updated current : ${currentwork.lastUpdate}');
      output.add(currentwork);
    }

    return output;
  }

  // --------------------------------manipulated-------------------------------------------------

  Future<List<ManipulatedData>> manipulatedDataRemoveOldExceptLast(
      PatientDetailsData data, Map manipulated,ModuleDetail ptn, ModuleDetail fiber) async {
    List<ManipulatedData> maniData = [];
    await getEnternalData(data).then((v) {
      if (v != null && !v.maniDetailsData.isNullOrBlank) {
        maniData.addAll(v.maniDetailsData);
      }
    });
    // await maniData.add(ManipulatedData(
    //     title: manipulated['title'],
    //     currentWork: manipulated['current_work'],
    //     mlDose: manipulated['ml_dose'],
    //     id: manipulated['id'],
    //     lastUpdate: manipulated['lastUpdate'],
    //     enData: EnData(
    //       kcal: manipulated['en_data']['kcal'],
    //       fiber: manipulated['en_data']['fiber'],
    //       protein: manipulated['en_data']['protein'],
    //       proteinModule: manipulated['en_data']['protein_module'],
    //       fiberModule: manipulated['en_data']['fiber_module'],
    //     )));

    ManipulatedData newAdded = ManipulatedData();
    List<NumberOfDays> newdoses = manipulated['doses_data'];
    print('doses list : ${newdoses}');
    List<DosesData> dosesData = [];
    for (var a in newdoses) {
      dosesData.add(DosesData(
        hour: a.hour,
        index: a.index,
        istoday: a.istoday,
        schduleDate: a.schdule_date,
        timePerday: a.timePerday,
      ));
    }

    newAdded.title = manipulated['title'];
    newAdded.currentWork = manipulated['current_work'];
    newAdded.mlDose = manipulated['ml_dose'];
    newAdded.id = manipulated['id'];
    newAdded.lastUpdate = manipulated['lastUpdate'];
    newAdded.dosesData = dosesData;
    newAdded.enData = EnData(
        kcal: manipulated['en_data']['kcal'],
        fiber: manipulated['en_data']['fiber'],
        protein: manipulated['en_data']['protein'],
        proteinModule: manipulated['en_data']['protein_module'],
        fiberModule: manipulated['en_data']['fiber_module'],
        protienModluleDetail: ptn,fiberModluleDetail: fiber
    );

    await maniData.add(newAdded);
    //

    print('indust details list len : ${maniData.length}');
    print('indust details list : ${jsonEncode(maniData)}');

    String workday;
    DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    print('lastWork time start from : ${lastworkStart}');

    List<ManipulatedData> ActiveManiData = [];
    for (var a in maniData) {
      print(
          "data is before last work time start or not : ${DateTime.parse(a.lastUpdate).isAfter(lastworkStart)}");

      if (DateTime.parse(a.lastUpdate).isAfter(lastworkStart)) {
        ActiveManiData.add(a);
        print(a.lastUpdate);
      }
    }
    return ActiveManiData;
  }

  Future<List<ManipulatedData>> getDataMani(
      PatientDetailsData data, Map manipuated,ModuleDetail ptn,ModuleDetail fiber) async {
    List<ManipulatedData> getData =
        await manipulatedDataRemoveOldExceptLast(data, manipuated,ptn,fiber);

    print('getData : ${getData.length}');

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    // DateTime currentEnd = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    List<ManipulatedData> lastday = [];
    List<ManipulatedData> currentday = [];

    for (var a in getData) {
      if (DateTime.parse(a.lastUpdate).isAfter(lastWorkStart) &&
          DateTime.parse(a.lastUpdate).isBefore(lastWorkEndCurrentStart)) {
        print('lastwork data');
        print('${a.lastUpdate}');
        lastday.add(a);
      } else {
        print('current work data');
        print('${a.lastUpdate}');
        currentday.add(a);
      }
    }
    List<ManipulatedData> output = [];
    if (!lastday.isNullOrBlank) {
      ManipulatedData lastwork = await updatedDateM(lastday);
      print('updated last : ${lastwork.lastUpdate}');
      output.add(lastwork);
    }
    if (!currentday.isNullOrBlank) {
      ManipulatedData currentwork = await updatedDateM(currentday);
      print('updated current : ${currentwork.lastUpdate}');
      output.add(currentwork);
    }

    return output;
  }

  Future<double> getCurrentManipulatedML(PatientDetailsData data) async {
    DateTime currentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    DateTime currentEnd = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    List<DosesData> currentDosesData = [];
    double total = 0.0;
    await getEnternalData(data).then((r) {
      if (r != null && r.maniDetailsData.isNotEmpty) {
        print(r.maniDetailsData[0].title);
        for (var a in r.maniDetailsData) {
          print('pp.${a.mlDose}');
          var val = a.mlDose;

          // var d = getDateFormatFromString(a.lastUpdate);
          var d1 = DateFormat(commonDateFormat)
              .format(DateTime.now().subtract(Duration(days: 1)));
          var d2 =
              DateFormat(commonDateFormat).format(DateTime.parse(a.lastUpdate));
          print('d2 : ${d2}');
          print('d1 : ${d1}');
          if ('$d1'.trim() == '$d2'.trim()) {
            print('yes equal to equal');
            for (var e in a.dosesData) {
              if (DateTime.parse('${e.schduleDate} ${e.hour}:00')
                      .isAfter(currentStart) &&
                  DateTime.parse('${e.schduleDate} ${e.hour}:00')
                      .isBefore(currentEnd)) {
                currentDosesData.add(e);
                total = total + double.parse(val);
              }
            }
            break;
          }
          print('last date = ${a.lastUpdate}');

          // List<DosesData> data = a.dosesData.where((e) => DateTime.parse('${e.schduleDate} ${e.hour}:00')
          //         .isAfter(currentStart) &&
          //     DateTime.parse('${e.schduleDate} ${e.hour}:00')
          //         .isBefore(currentEnd));
          //
          // if (!data.isNullOrBlank && data.isNotEmpty) {
          //   currentDosesData.addAll(data);
          // }
        }
      }
    });
    print('current doses scduled data : ${currentDosesData.length}');
    print('current doses total mL: ${total}');
    return total;
  }

  Future<double> getCurrentIndustML(PatientDetailsData data) async {
    EnteralData enteralData = await getEnternalData(data) ?? null;

    double total = 0.0;

    if (!enteralData.isNullOrBlank &&
        !enteralData.industDetailsData.isNullOrBlank &&
        enteralData.industDetailsData.isNotEmpty) {
      DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

      DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.now());

      print(enteralData.industDetailsData.length);

      if(enteralData.tabIndex==0){
        for (var a in enteralData.industDetailsData) {
          if (DateTime.parse(a.lastUpdate).isAfter(lastWorkStart) &&
              DateTime.parse(a.lastUpdate).isBefore(lastWorkEndCurrentStart)) {
            //
            print("a.startTime :: ${data.sId}");
            print(jsonEncode(a));


            DateTime startTime = DateTime.parse(
                '${DateFormat(commonDateFormat).format(DateTime.parse(a.startDate).add(Duration(days: 1)))} ${a.startTime}:00');

            double hour = startTime.difference(lastWorkEndCurrentStart).inMinutes/60;
            print('hour diff : ${hour}');

            double mlPerhour = double.parse(a.mlHr);
            double hourPerday = double.parse(a.hrDay);

            print('total hour : ${hour}');
            print('ml/hr: ${mlPerhour}');
            print('hr/day : ${hourPerday}');

            total = await mlPerhour * hourPerday / 24 * hour;

            print('total current work : ${total}');

            break;
          }
        }
      }


    }
    return total;
  }

  Future<List<Needs>> getneedsAfterInterpt(
      PatientDetailsData patientDetailsData,
      String currentWork,
      String id,
      int index,
      double planProtien,
      double planCal,
      double expected_infuse,
      String proteinModule) async {
    var calc_needData = await calculateNeedData(
        patientDetailsData,
        "Enteral Protein Module",
        planProtien,
        planCal,
        expected_infuse,
        proteinModule);
    var non_nutri_kcal = await Needs(
        lastUpdate: DateTime.now().toString(),
        plannedKcal: "0.0",
        plannedPtn: "0.0",
        type: "non_nutritional",
        achievementProtein: "0.0",
        achievementKcal: "0.0");
    print("90dddd.. ${jsonEncode(calc_needData)}");

    List<Needs> getNeeds = await getNut(patientDetailsData, currentWork,
        calc_needData, non_nutri_kcal, id, index,selectedData);
    print("jsonEncode(getNeeds)");
    print(jsonEncode(getNeeds));
    return getNeeds;
  }

  Future<double> nextdayInterval_ml_expected(PatientDetailsData data,
      String start_time,String startDate, String mlHr, String hrDay) async {
    // EnteralData enteralData = await getEnternalData(data) ?? null;
    print(mlHr);

    double total = 0.0;
    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    DateTime selectedTime = DateTime.parse(
        '${DateFormat(commonDateFormat).format(DateTime.parse(startDate).add(Duration(days: 1)))} ${start_time}:00');

    double hour = selectedTime.difference(lastWorkEndCurrentStart).inMinutes/60;

    print(DateTime.now().add(Duration(hours: 13)));
    print('hour diff : ${hour}');

    double mlPerhour = double.parse(mlHr);
    double hourPerday = double.parse(hrDay);

    print('total hour : ${hour}');
    print('ml/hr: ${mlPerhour}');
    print('hr/day : ${hourPerday}');

    total = await mlPerhour * hourPerday / 24 * hour;
    print(selectedTime);
    print(lastWorkEndCurrentStart);
    print('total current work : ${total.toStringAsFixed(2)}');

    return total;
  }

  Future<double> firstInterval_ml_expected(PatientDetailsData data,
      String start_time,String startDate, String mlHr, String hrDay) async {
    // EnteralData enteralData = await getEnternalData(data) ?? null;
    print(mlHr);

    double total = 0.0;
    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    DateTime selectedTime = DateTime.parse(
        '$startDate ${start_time}:00');

    double hour = lastWorkEndCurrentStart.difference(selectedTime).inMinutes/60;

    print(DateTime.now().add(Duration(hours: 13)));
    print('hour diff : ${hour}');

    double mlPerhour = double.parse(mlHr);
    double hourPerday = double.parse(hrDay);

    print('total hour : ${hour}');
    print('ml/hr: ${mlPerhour}');
    print('hr/day : ${hourPerday}');

    total = await mlPerhour * hourPerday / 24 * hour;
    print(selectedTime);
    print(lastWorkEndCurrentStart);
    print('total current work : ${total.toStringAsFixed(2)}');

    return total;
  }

  Future<List<DateTime>> getTimeInterval(
      PatientDetailsData data, String time_start,String startDate, int type) async {
    // EnteralData enteralData = await getEnternalData(data) ?? null;
    DateTime start_interval;
    DateTime end_interval;
    List<DateTime> intervals = [];
    // DateTime startTime;

  var workday =  await getWorkingDays(data.hospital.first.sId);
    var format = DateFormat("HH:mm");
    var start = format.parse(time_start);
    var hosp = format.parse(workday);
    adLog(" diff::: ${start.isBefore(hosp)}");

    var _start =  DateFormat(commonDateFormat).format(DateTime.parse(startDate));

    var _end =  DateFormat(commonDateFormat).format(DateTime.parse(_start)
        .add(Duration(days: start.isBefore(hosp)?0:1)));


    adLog('_start:$_start to _end:$_end');

    if (type == 0) {
      start_interval = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.now());
      intervals.add(start_interval);

      end_interval = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));
      intervals.add(end_interval);
    } else if (type == 1) {
      
      start_interval = DateTime.parse('$_start ${time_start}:00');

      intervals.add(start_interval);

      end_interval = await getDateTimeWithWorkdayHosp(
          data.hospital.first.sId, DateTime.parse(_end));

      intervals.add(end_interval);
    } else {

      var _start2 = _end;

      var _end2 = DateFormat(commonDateFormat).format(DateTime.parse(_start2).add(Duration(days: start.isBefore(hosp)?1:0)));

      adLog('_start2:$_start $workday to _end2:$_end $time_start');

      start_interval = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.parse(_start2));

      intervals.add(start_interval);

      end_interval = DateTime.parse('$_end2 ${time_start}:00');

      intervals.add(end_interval);
    }

    return intervals;
  }

  // ---------------------------------------------------------------------------------

  Future<List<LastSelected>> getselectedIndex(
      String index, PatientDetailsData data) async {
    List<LastSelected> lastSelected = [];

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    // DateTime CurrentWorkEnd= await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    await getEnternalData(data).then((r) {
      if (r != null && !r.lastSelected.isNullOrBlank) {
        for (var a in r.lastSelected) {
          if (DateTime.parse(a.date).isAfter(lastWorkStart)) {
            lastSelected.addAll(r.lastSelected);
          }
        }
      }
    });

    await lastSelected
        .add(LastSelected(index: index, date: DateTime.now().toString()));

    List<LastSelected> current = [];
    List<LastSelected> last = [];

    for (var a in lastSelected) {
      if (DateTime.parse(a.date).isAfter(lastWorkStart) &&
          DateTime.parse(a.date).isBefore(lastWorkEndCurrentStart)) {
        last.add(a);
      } else {
        current.add(a);
      }
    }

    List<LastSelected> output = [];
    if (last.isNotEmpty) {
      LastSelected lastwork = await updatedDateSelect(last);
      output.add(lastwork);
      print('last selcted : ${lastwork}');
    }
    if (current.isNotEmpty) {
      LastSelected currentwork = await updatedDateSelect(current);
      output.add(currentwork);
      print('current selcted : ${currentwork}');
    }

    return output;
  }

  // ---------------------------------------------------------------------------------

  Future<LastSelected> updatedDateSelect(List<LastSelected> list) async {
    list.sort(
        (b, a) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
    return list[0];
  }

  Future<IndustrializedData> updatedDate(List<IndustrializedData> list) async {
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  Future<ManipulatedData> updatedDateM(List<ManipulatedData> list) async {
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  var historyData = List<Data>().obs;

  Future<List<Data>> getEnteral_HistoryData(String patientId) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.enteralHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        Enteral_HistoryModel model =
            Enteral_HistoryModel.fromJson(json.decode(value.body));
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

  //get needs data from enteral formula (both indust & manipulated)
  //***********************************************************************
  Future<List<Needs>> getNut(PatientDetailsData data, String currentWork,
      Needs addItem2, Needs non_nutritional, String id, int index,Industrialized selected) async {
    double getInfused =
        await balanceSheetController.getNutritional(data, "Enteral Nutrition");
    print('getInfused : $getInfused');
    print('getCurrentWork : $currentWork');

    var getData;
    if (index == 0) {
      getData = await industrialized.firstWhere((element) => element.sId == id,
          orElse: () => null);
    } else {
      getData = await manipulated.firstWhere((element) => element.sId == id,
          orElse: () => null);
    }

    print('selected dropdown value : ${jsonEncode(getData)}');

    double getcurrentwork = double.parse(currentWork);
    // double protein = double.parse(getData.protein);
    // double kcal = double.parse(getData.kcal);
    double getPer;
    if (getcurrentwork != 0.0) {
      getPer = (getInfused * 100) / getcurrentwork;
    } else {
      getPer = 0.0;
    }
    // double getPer = (getInfused * 100) / getcurrentwork;

    print('enteral nutritional acceptance per : ${getPer}');

    double pkcal = ifBlankReturnZero(getData != null ? getData.kcal : "0.0");
    double pptn = ifBlankReturnZero(getData != null ? getData.protein : "0.0");
    double akcal = pkcal * getPer / 100;
    double aptn = pptn * getPer / 100;

    print('---------total----------');
    print('plan kcal : ${pkcal}');
    print('plan ptn : ${pptn}');

    print('Ach kcal : ${akcal}');
    print('Ach ptn : ${aptn}');
    //
    Needs addItem = Needs();

    addItem.lastUpdate = '${DateTime.now()}';
    addItem.type = ENTERAL_STATUS.enteral_status;

    addItem.plannedKcal = pkcal.toString();
    addItem.plannedPtn = pptn.toString();

    addItem.achievementKcal = akcal.toStringAsFixed(2);
    addItem.achievementProtein = aptn.toStringAsFixed(2);
    debugPrint('selected.protein :: ${selected.protein}');

    addItem.calculatedParameters = CalculatedParameters(
        protien_perML: selected.protein,
        kcl_perML: selected.kcal,
        curruntWork: currentWork);

    print('jsonEncode : ${jsonEncode(addItem)}');

    List<Needs> output =
        await getNeeds(addItem, addItem2, non_nutritional, data);

    return output;
  }

  Future<Needs> calculateNeedData(
      PatientDetailsData patientDetailsData,
      String type,
      double planProtien,
      double planCal,
      double expected_infuse,
      String proteinModule) async {
    List<Needs> data = [];
    double protien_acceptance = 0.0;
    double achieved_protien = 0.0;
    double achieved_cal = 0.0;
    var infused_protien = await infuse_controller.getInfusedVol(
      patientDetailsData,
      "Enteral Protein Module",
      DateFormat(commonDateFormat).format(DateTime.now()),
      DateFormat('HH:mm').format(DateTime.now()),
    );

    if (expected_infuse > 0.0) {
      protien_acceptance = infused_protien * 100 / expected_infuse;
      print("infused prot.. ${infused_protien}");
      print("protien acceptance.. ${protien_acceptance}");
      achieved_protien = planProtien * protien_acceptance / 100;
      achieved_cal = planCal * protien_acceptance / 100;
    }

    // data.add(Needs(lastUpdate: DateTime.now().toString(),type: type,plannedPtn: planProtien.toString(),plannedKcal: planCal.toString(),achievementProtein: achieved_protien.toStringAsFixed(2),achievementKcal: achieved_cal.toString()));
    data.add(Needs(
      lastUpdate: DateTime.now().toString(),
      type: type,
      plannedPtn: proteinModule,
      plannedKcal: planCal.toString(),
      achievementProtein: achieved_protien.toStringAsFixed(2),
      achievementKcal: achieved_cal.toString(),
    ));

    print(jsonEncode(data[0]));
    return data[0];
  }

  Future<List<Surgery_postOpList>> get_reduced_justif(
      PatientDetailsData data, Surgery_postOpList add_item) async {
    print('pp');
    EnteralData e_data = await getEnternalData(data);
    List<Surgery_postOpList> output = [];

    if (e_data != null && !e_data.isNullOrBlank) {
      for (var a in e_data.reducesed_justification.surgery_postOpList) {
        output.add(a);
      }
    } else {
      output = [];
    }
    output.add(add_item);
    print("iiiiii");
    print(jsonEncode(output));
    var final_list = await removeSameOb_forReducedJustification(
        output, data.hospital.first.sId, add_item.type);
    return final_list;
  }

  Future<List<Surgery_postOpList>> removeSameOb_forReducedJustification(
      List<Surgery_postOpList> data, String hospId, String type) async {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkdayStart =
        await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
    DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().add(Duration(days: 1)));
    List<Surgery_postOpList> output = [];
    print('www');
    if (data != null && data.isNotEmpty) {
      List<Surgery_postOpList> currentDay = [];
      List<Surgery_postOpList> lastDay = [];
      List<Surgery_postOpList> previousDay = [];
      for (var b in data) {
        DateTime _date = DateTime.parse(b.lastUpdate);
        if ((_date.isAfter(currentworkdayStart) &&
            _date.isBefore(currentworkdayEnd) &&
            b.type == type)) {
          currentDay.add(b);
        } else if ((_date.isAfter(lastworkday) &&
            _date.isBefore(currentworkdayStart) &&
            b.type == type)) {
          lastDay.add(b);
        } else {
          previousDay.add(b);
        }
      }

      print('current : ${currentDay.length}');

      if (currentDay != null && currentDay.isNotEmpty) {
        Surgery_postOpList current = await updatedDateSelected(currentDay);
        output.add(current);
      }
      if (lastDay != null && lastDay.isNotEmpty) {
        Surgery_postOpList last = await updatedDateSelected(lastDay);
        output.add(last);
      }

      output.addAll(previousDay);

      for (int a = 0; a < data.length; a++) {
        DateTime _date = DateTime.parse(data[a].lastUpdate);
        output.removeWhere((element) => DateTime.parse(element.lastUpdate)
            .isBefore(lastworkday.subtract(Duration(days: 1))));
        // if(_date.isBefore(lastworkday.subtract(Duration(days: 1))) && a.type== type){
        //   output.remove(a);
        // }
      }
    }

    return output;
  }

  Future<Surgery_postOpList> updatedDateSelected(
      List<Surgery_postOpList> list) async {
    // print('get all objects needs : ${list.length}');
    // print('get all objects needs 1 : ${jsonEncode(list[0])}');
    // print('get all objects needs 2 : ${jsonEncode(list[1])}');
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  Future<List<Needs>> getNeeds(Needs addItem, Needs addItem2,
      Needs non_nutritional, PatientDetailsData data) async {
    NeedsController needsController = NeedsController();

    List<Needs> output = [];
    if (data.needs != null && data.needs.isNotEmpty) {
      output.addAll(data.needs);
    }
    output.add(addItem);

    if (addItem2 != null) {
      output.add(addItem2);
    }

    output.add(non_nutritional);

    print('sending objects : ${jsonEncode(output)}');

    List<Needs> getFilteredData = await needsController.removeSameOb(
      output,
      data.hospital.first.sId,
      addItem.type,
    );
    print('getFiltered data : ${jsonEncode(getFilteredData)}');

    List<Needs> getFilterAfterNonNut = await needsController.removeSameOb(
      getFilteredData,
      data.hospital.first.sId,
      non_nutritional.type,
    );
    print('getFiltered data2222 : ${jsonEncode(getFilterAfterNonNut)}');

    List<Needs> getfinalFilteredData;
    if (addItem2 != null) {
      getfinalFilteredData = await needsController.removeSameOb(
        getFilterAfterNonNut,
        data.hospital.first.sId,
        addItem2.type,
      );
      print('getFiltered data2222 : ${jsonEncode(getfinalFilteredData)}');
    }

    // return getFilteredData;
    return getfinalFilteredData ?? getFilterAfterNonNut;
  }

  //***********************************************************************

  // Future<List<Needs>> getNutFromProtein(
  //     PatientDetailsData data, String currentWork, String id, int index) async {
  //   double getInfused = await balanceSheetController.getNutritional(data);
  //   print('getInfused : $getInfused');
  //   print('getCurrentWork : $currentWork');
  //
  //   var getData ;
  //   if(index==0){
  //     getData =  await industrialized.firstWhere((element) => element.sId == id, orElse: () => null);
  //   }else{
  //     getData =  await manipulated.firstWhere((element) => element.sId == id, orElse: () => null);
  //   }
  //
  //   print('selected dropdown value : ${jsonEncode(getData)}');
  //
  //   double getcurrentwork = double.parse(currentWork);
  //   // double protein = double.parse(getData.protein);
  //   // double kcal = double.parse(getData.kcal);
  //
  //   double getPer = (getInfused * 100) / getcurrentwork;
  //
  //   print('enteral nutritional acceptance per : ${getPer}');
  //
  //   double pkcal = ifBlankReturnZero(getData.kcal);
  //   double pptn = ifBlankReturnZero(getData.protein);
  //   double akcal = pkcal * getPer/100;
  //   double aptn = pptn  * getPer/100;
  //
  //   print('---------total----------');
  //   print('plan kcal : ${pkcal}');
  //   print('plan ptn : ${pptn}');
  //
  //   print('Ach kcal : ${akcal}');
  //   print('Ach ptn : ${aptn}');
  //   //
  //   Needs addItem = Needs();
  //
  //   addItem.lastUpdate = '${DateTime.now()}';
  //   addItem.type = ENTERAL_STATUS.enteral_status;
  //
  //   addItem.plannedKcal = pkcal.toString();
  //   addItem.plannedPtn = pptn.toString();
  //
  //   addItem.achievementKcal = akcal.toStringAsFixed(2);
  //   addItem.achievementProtein = aptn.toStringAsFixed(2);
  //
  //   print('jsonEncode : ${jsonEncode(addItem)}');
  //
  //   List<Needs> output  = await getNeeds(addItem, data);
  //
  //   return output;
  //
  // }

  Future<List<String>> getHospital_start_endTime(
      PatientDetailsData data) async {
    String start;
    String end;
    String workingday = await getWorkingDays(data.hospital[0].sId);

    var a =
        '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
    print(a.toString());

    if (DateTime.now().isBefore(DateTime.parse(a))) {
      start =
          '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
      end = DateTime.parse(start).add(Duration(days: 1)).toString();
    } else {
      start =
          '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
      end = DateTime.parse(start).add(Duration(days: 1)).toString();
    }
    print("lllll..");
    print([start, end]);
    return [start, end];
  }

  ifBlankReturnZero(String text) {
    if (text != null && text != '') {
      return double.parse(text);
    } else {
      return 0.0;
    }
  }
}

class workRecord {
  String totalwork;
  String date;

  workRecord({this.totalwork, this.date});
}
