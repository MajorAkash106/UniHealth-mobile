
// import 'package:get/get.dart';
//
// class LessAchieveNeeds extends GetxController{
//
//
//
//
// }

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/sinceAdmision_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class LessAchieveNeeds extends GetxController {
  SinceAdmisionController sinceAdmisionController = SinceAdmisionController();
  ParenteralNutrional_Controller pController = ParenteralNutrional_Controller();
  NeedsController needsController = NeedsController();

  Future<LessData> getLessDatafrom(PatientDetailsData pdata,int lessFrom) async {

    List<Needs>threeDaysList = [];
  var getList = await  needsController.getNeeds_achievementData_less_than50Perc(pdata,pdata.hospital.first.sId);

  if(getList.current_day_needs_data.isNotEmpty) {
    await threeDaysList.addAll(getList.current_day_needs_data);
  }
  if(getList.last_day_needs_data.isNotEmpty) {
    await threeDaysList.addAll(getList.last_day_needs_data);
  }
  if(getList.last_previous_day_needs_data.isNotEmpty) {
   await threeDaysList.addAll(getList.last_previous_day_needs_data);
  }



    var output  = await allData(threeDaysList, pdata,lessFrom);
    // print('all days data - $output');

    return output;
  }

  Future<LessData> allData(List<Needs> sinceData, PatientDetailsData pdata,int lessFrom) async {

    List<String> _dateee = [];
    bool kcalLess = false;
    bool ptnLess = false;

    print('sinceData ------------------- : ${sinceData}');

    for (var a in sinceData) {
      // List<Needs> data = [];
      print('_date: ${a.lastUpdate}');
      String g = await getDateFormatFromString(a.lastUpdate);
      print('_date: $g');

      _dateee.add(g);
    }

    print('g : ${_dateee.toSet()}');

    for (var a in _dateee.toSet().toList()) {
      List<Needs> dataa = [];
      for (var b in sinceData) {
        String gg = await getDateFormatFromString(b.lastUpdate);
        if (a == gg) {
          dataa.add(b);
        }
      }

      print('list particular : ${dataa.length}');



      var getAllPer = await getData(dataa, pdata);

      if(getAllPer!=null){
        print('getAllPer-------${getAllPer}');
        print('getAllPer.ptnPerMax-------${getAllPer.ptnPerMax}');
        print('getAllPer.ptnPerMin-------${getAllPer.ptnPerMin}');
        print('getAllPer.kcalPerMax-------${getAllPer.kcalPerMax}');
        print('getAllPer.kcalPerMin-------${getAllPer.kcalPerMin}');

        if (getAllPer.kcalPerMin < lessFrom) {
          // kcalMin = await kcalMin + 1;
          kcalLess =  await true;
        }
        if (getAllPer.kcalPerMax < lessFrom) {
          // kcalMax = await kcalMax + 1;
          kcalLess =  await true;
        }
        if (getAllPer.ptnPerMin < lessFrom) {
          // ptnMin = await ptnMin + 1;
          ptnLess =  await true;
        }
        if (getAllPer.ptnPerMax < lessFrom) {
          // ptnMax = await ptnMax + 1;
          ptnLess =  await true;
        }
      }
    }






    return LessData(kcalLess, ptnLess);
    // var returnData = await getTotal(output);
    // return returnData;
  }

  Future<ReturnPer> getData(
      List<Needs> sinceData,
      PatientDetailsData pdata,
      ) async {
    print('sinceData : ${sinceData}');
    print('pdata : ${pdata}');

    String gg = await getDateFormatFromString(sinceData.first.lastUpdate);

    DateTime start = await getDateTimeWithWorkdayHosp(pdata.hospital.first.sId, DateTime.parse(gg));
    DateTime end = start.add(Duration(days: 1));

    print('start time : ${start}');
    print('end time : ${end}');
    //

    double ptn = 0.0;
    double kcal = 0.0;

    var oralData = await sinceAdmisionController.getoralDiet(sinceData);
    print('----------------oralData-------------------');
    print('ptn: ${oralData.sum_of_ptn}');
    print('kcal: ${oralData.sum_of_kacl}');
    ptn = ptn + oralData.sum_of_ptn;
    kcal = kcal + oralData.sum_of_kacl;

    var onsData = await sinceAdmisionController.getOns(sinceData);
    print('----------------onsData-------------------');
    print('ptn: ${onsData.sum_of_ptn}');
    print('kcal: ${onsData.sum_of_kacl}');
    ptn = ptn + onsData.sum_of_ptn;
    kcal = kcal + onsData.sum_of_kacl;

    //
    var enteralData =
    await sinceAdmisionController.getEnteral(sinceData, pdata, start, end);
    print('----------------enteralData-------------------');
    print('ptn: ${enteralData.sum_of_ptn}');
    print('kcal: ${enteralData.sum_of_kacl}');
    ptn = ptn + enteralData.sum_of_ptn;
    kcal = kcal + enteralData.sum_of_kacl;

    var parenteralData = await sinceAdmisionController.getParenteral(
        sinceData, pdata, start, end);
    print('----------------parenteralData-------------------');
    print('ptn: ${parenteralData.sum_of_ptn}');
    print('kcal: ${parenteralData.sum_of_kacl}');
    ptn = ptn + parenteralData.sum_of_ptn;
    kcal = kcal + parenteralData.sum_of_kacl;

    //
    var proteinModuleData = await sinceAdmisionController.getProteinModule(
        sinceData, pdata, start, end);
    print('----------------proteinModuleData-------------------');
    print('ptn: ${proteinModuleData.sum_of_ptn}');
    print('kcal: ${proteinModuleData.sum_of_kacl}');
    ptn = ptn + proteinModuleData.sum_of_ptn;
    kcal = kcal + proteinModuleData.sum_of_kacl;

    var NNData = await sinceAdmisionController.getNonNutritional(sinceData);

    print('----------------NNData-------------------');
    print('ptn: ${NNData.sum_of_ptn}');
    print('kcal: ${NNData.sum_of_kacl}');
    ptn = ptn + NNData.sum_of_ptn;
    kcal = kcal + NNData.sum_of_kacl;

    print('-----------------Total Data------------------');
    print('ptn: $ptn');
    print('kcal: $kcal');

    var conditionData = await sinceAdmisionController.getConditionData(pdata, start, end);
    print('----------------conditionData-------------------');

    int ptnPerMin = 0;
    int ptnPerMax = 0;
    int kcalPerMin = 0;
    int kcalPerMax = 0;

    if(conditionData!=null){
      print('ptn: ${jsonEncode(conditionData)}');

      // print('getData for planned : $getData');
       ptnPerMin = await pController.getPercent(
          ptn ?? 0, double.parse(conditionData.minProtien));
       ptnPerMax = await pController.getPercent(
          ptn ?? 0, double.parse(conditionData.maxProtien));

       kcalPerMin = await pController.getPercent(
          kcal ?? 0, double.parse(conditionData.minEnergy));
       kcalPerMax = await pController.getPercent(
          kcal ?? 0, double.parse(conditionData.maxEnergy));

      print('----------------getPercentageData-------------------');
      print('duration : $start to $end');
      print('ptn percentage: $ptnPerMin,$ptnPerMax');
      print('kcal percentage: $kcalPerMin, $kcalPerMax');

    }

    // var output = await getOneDayData(ReturnData(ptnPer,kcalPer,conditionData));
    // // print('output of one day - ptn: ${output.aPtn} kcal : ${output.aKcal}');
    //
    return ReturnPer(ptnPerMin, ptnPerMax, kcalPerMin, kcalPerMax);
  }
}

class ReturnPer {
  int ptnPerMin;
  int ptnPerMax;
  int kcalPerMin;
  int kcalPerMax;
  ReturnPer(this.ptnPerMin, this.ptnPerMax, this.kcalPerMin, this.kcalPerMax);
}


class PerLow {
  String ptnPerMin;
  String ptnPerMax;
  String kcalPerMin;
  String kcalPerMax;
  PerLow(this.ptnPerMin, this.ptnPerMax, this.kcalPerMin, this.kcalPerMax);
}


class LessData{
  bool kcalLess;
  bool ptnLess;
  LessData(this.kcalLess,this.ptnLess);
}