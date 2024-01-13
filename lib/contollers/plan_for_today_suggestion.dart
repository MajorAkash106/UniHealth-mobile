import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_formula_model.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/numberOfDoses.dart';
import '../model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import '../model/NutritionalTherapy/parenteral_model.dart';
import 'NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart' as enModel;

class PlanForTodaySuggestion {
  final EnteralNutritionalController _enController = EnteralNutritionalController();
  final ParenteralNutrional_Controller _pnController = ParenteralNutrional_Controller();

  Future<List<Needs>> savedData(
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
      String total,Industrialized selected) async {
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

   return afterAuth(
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
        total,selected);

  }

  Future<List<Needs>> afterAuth(
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
      String total,
      Industrialized selected
      ) async {
    List<IndustrializedData> indust_data =
    await _enController.getDataIndust(patientDetailsData, industData,ptnmoduleDetail,fibremoduleDetail);
    List<ManipulatedData> mani_data =
    await _enController.getDataMani(patientDetailsData, manipulatedData,ptnmoduleDetail,fibremoduleDetail);
    List<enModel.LastSelected> selectedIndex =
    await _enController.getselectedIndex(tabIndex.toString(), patientDetailsData);
    print('indust_data len ${indust_data.length}');
    print('mani_data len ${mani_data.length}');
    // var getsurgery_opList=
    var surgery_postOpList = await _enController.get_reduced_justif(
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

    var calc_needData = await _enController.calculateNeedData(
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

    List<Needs> getNeeds = await _enController.getNut(
        patientDetailsData,
        tabIndex == 0
            ? industData['current_work']
            : manipulatedData['current_work'],
        ptnmoduleDetail.total_vol != null ? calc_needData : null,
        non_nutri_kcal,
        tabIndex == 0 ? industData['id'] : manipulatedData['id'],
        tabIndex,selected);
    print('qqqqqq');

    double get_fiber_Infused = await _enController.balanceSheetController.getNutritional(
        patientDetailsData, "Enteral Fiber Module");

    var modules_interval; // = await getTimeInterval(patientDetailsData, industData["start_time"], 0);
    var first_interval_times; // = await getTimeInterval(patientDetailsData, industData["start_time"], 1);
    var second_interval_times; // = await getTimeInterval(patientDetailsData, industData["start_time"], 2);
    String secondMl = '0.0';
    double firstDayMl =0.0;
    if (tabIndex == 0) {
      modules_interval = await _enController.getTimeInterval(
          patientDetailsData, industData["start_time"],industData["start_date"], 0);
      first_interval_times = await _enController.getTimeInterval(
          patientDetailsData, industData["start_time"],industData["start_date"], 1);
      second_interval_times = await _enController.getTimeInterval(
          patientDetailsData, industData["start_time"], industData["start_date"],2);
    } else {

      var doses = manipulatedData["doses_data"] as List<NumberOfDays>;

      adLog('message doses == ${doses.first.toJson()}');

      String workday = await getWorkingDays(patientDetailsData.hospital.first.sId);

      var resp = await _enController.getManiplatedCurrentWork(doses, manipulatedData['ml_dose'], workday, 0.0);
      adLog('tomorrow == ${resp[1].totalwork}');
      secondMl = resp[1].totalwork;
      String _startTime = doses.first.hour;
      String _startDate =  DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: doses.first.istoday?0:1)));

      modules_interval = await _enController.getTimeInterval(
          patientDetailsData, _startTime, _startDate,1);

      first_interval_times = await _enController.getTimeInterval(
          patientDetailsData, _startTime,_startDate, 1);
      second_interval_times = await _enController.getTimeInterval(
          patientDetailsData, _startTime,_startDate,2);

      firstDayMl = await _enController.getCurrentManipulatedML(patientDetailsData);

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

    double get_ptn_Infused = await _enController.balanceSheetController.getNutritional(
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
    double getInfused = await _enController.balanceSheetController.getNutritional(
        patientDetailsData, "Enteral Nutrition");
    print("inf.....${getInfused}");
    var times = await _enController.getHospital_start_endTime(patientDetailsData);

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
          : manipulatedData['current_work'],
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

  // debugPrint('updated getNeeds :: $getNeeds');

    // for(var a in getNeeds){
    //   if(a.type == 'enteral'){
    //     debugPrint('updated getNeeds :: ${a.toJson()}');
    //   }
    // }

   return getNeeds;
    // await _enController.getRouteForModeSave(
    //     patientDetailsData, finalData, getNeeds, fomulaModules, times); //akash
    // await apicall(patientDetailsData, finalData,getNeeds,fomulaModules,times); //akash
    // await apicall(patientDetailsData, finalData,needData,formula_data,times); //raman
  }



  Future<List<Needs>> onUpdateParenteral(
      PatientDetailsData data,
      Map readyData,
      Reduced_options reducedOptions,
      int teamStatus,
      bool tabStatus,
      Map manipulated,
      Map nonNutritional,
      bool is_lastPresent,
  PARENTERALDATA parenteraldata,
      ) async {
    var surgery_postOpList = await _pnController.get_reduced_justif(
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
    await _pnController.addParenteralItem(data, finalData);
    Map output = {
      "lastUpdate": '${DateTime.now()}',
      "parenteral_data": finalData,
      "parenteral_details": getParenteral,
    };

    print('parenteral details : ${getParenteral.length}');
    print('final data on saved : ${jsonEncode(output)}');
    print(manipulated["total_macro"]);
    print(readyData["total_macro"]["protein"]);
    var calc_needData = await _pnController.calAchievement_PlannedProtein(
      tabStatus == true
          ? double.parse(readyData["total_macro"]["protein"].toString())
          : double.parse(manipulated["total_macro"]["protein"].toString()),
      tabStatus
          ? double.parse(readyData["total_vol"].toString())
          : double.parse(manipulated["total_vol"].toString()),
      tabStatus
          ? double.parse(readyData["current_work"].toString())
          : double.parse(manipulated["current_work"].toString()),
      tabStatus
          ? double.parse(readyData["total_cal"].toString())
          : double.parse(manipulated["total_cal"].toString()),
      data,
      "parenteral",parenteraldata
    );
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
      needsData = await _pnController.getNut(
        data,
        readyData['current_work'],
        calc_needData,
        non_nutritional_item,
        readyData['title_id'],
      );
    }else{
      needsData = await _pnController.getNut(
        data,
        manipulated['current_work'],
        calc_needData,
        non_nutritional_item,
        '',
      );
    }

    var first_interval_times;
    var second_interval_times;
    double getInfused = await _pnController.balanceSheetController.getNutritional(
        data, "Parenteral Nutrition");
    // var paternal_interval = await _enController.getTimeInterval(data, "", 0);

    first_interval_times = await _enController.getTimeInterval(data,
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
        1);
    second_interval_times = await _enController.getTimeInterval(data,
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
        2);
    var first_interval_ml_Expected = await _pnController.computeCurrentWorkFirstInterveral(
        data,
        tabStatus ? readyData["total_vol"] : manipulated["total_vol"],
        tabStatus ? readyData["start_time"] : manipulated["start_time"],
        tabStatus ? readyData["start_date"] : manipulated["start_date"],
    );
    var nextday_ml_Expected = await _pnController.computeCurrentWorkSecondInterveral(
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
      tabStatus
    );

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
      "expected_vol":
      nextday_ml_Expected, //tabStatus == true ? readyData['current_work'] : manipulated['current_work'],
      "infused_vol": getInfused.toString()
    };

    var times = await _enController.getHospital_start_endTime(data);

    List formula_data = [parenteral_firstInterval, parenteral_secondInterval];


    return needsData;
    // await getRouteForModeSave(data, output, needsData, formula_data, times);
  }



}
