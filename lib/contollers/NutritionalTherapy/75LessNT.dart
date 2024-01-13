import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/sinceAdmision_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class LessNeedsData extends GetxController {
  SinceAdmisionController sinceAdmisionController = SinceAdmisionController();
  ParenteralNutrional_Controller pController = ParenteralNutrional_Controller();

  Future<PerLow> get75LessData(PatientDetailsData pdata) async {
    // this function will return all needs data before current day

    List<Needs> needsSinceAdm = [];
    String workingday = await getWorkingDays(pdata.hospital.first.sId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for (var a in pdata.needs) {
      if (DateTime.parse(a.lastUpdate).isBefore(LastWorkEndCurrentStart)) {
        needsSinceAdm.add(a);
      }
    }
    print("sinceadm list,, ${jsonEncode(needsSinceAdm)}");
    print("sinceadm list,, ${needsSinceAdm.length}");

    var output  = await allData(needsSinceAdm, pdata);
    // print('all days data - $output');

    return output;
  }

  Future<PerLow> allData(List<Needs> sinceData, PatientDetailsData pdata,) async {
    double kcalMin = 0.0;
    double kcalMax = 0.0;

    double ptnMin = 0.0;
    double ptnMax = 0.0;

    List<String> _dateee = [];

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

      if (getAllPer.kcalPerMin < 75) {
        kcalMin = await kcalMin + 1;
      }
      if (getAllPer.kcalPerMax < 75) {
        kcalMax = await kcalMax + 1;
      }
      if (getAllPer.ptnPerMin < 75) {
        ptnMin = await ptnMin + 1;
      }
      if (getAllPer.ptnPerMax < 75) {
        ptnMax = await ptnMax + 1;
      }
    }


    print('------------less per count days---------------------');
    print('kcalMin : $kcalMin');
    print('kcalMax : $kcalMax');

    print('ptnMin : $ptnMin');
    print('ptnMax : $ptnMax');

    print('days - ${DateTime.now().difference(DateTime.parse(pdata.admissionDate)).inDays}');

    int days = await DateTime.now().difference(DateTime.parse(pdata.admissionDate)).inDays;
    if(days!=0){
      kcalMin = await (100/days) * kcalMin;
      kcalMax = await (100/days) * kcalMax;

      ptnMin = await (100/days) * ptnMin;
      ptnMax = await (100/days) * ptnMax;
    }



    print('------------less per---------------------');
    print('kcalMin : $kcalMin');
    print('kcalMax : $kcalMax');

    print('ptnMin : $ptnMin');
    print('ptnMax : $ptnMax');

    return PerLow(ptnMin.toStringAsFixed(0), ptnMax.toStringAsFixed(0), kcalMin.toStringAsFixed(0), kcalMax.toStringAsFixed(0));
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

    DateTime start = await getDateTimeWithWorkdayHosp(
        pdata.hospital.first.sId, DateTime.parse(gg));
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

    var conditionData =
        await sinceAdmisionController.getConditionData(pdata, start, end);
    print('----------------conditionData-------------------');
    print('ptn: ${jsonEncode(conditionData)}');

    print('getData for planned : $getData');
    int ptnPerMin = await pController.getPercent(
        ptn ?? 0, double.parse(conditionData.minProtien));
    int ptnPerMax = await pController.getPercent(
        ptn ?? 0, double.parse(conditionData.maxProtien));

    int kcalPerMin = await pController.getPercent(
        kcal ?? 0, double.parse(conditionData.minEnergy));
    int kcalPerMax = await pController.getPercent(
        kcal ?? 0, double.parse(conditionData.maxEnergy));

    print('----------------getPercentageData-------------------');
    print('duration : $start to $end');
    print('ptn percentage: $ptnPerMin,$ptnPerMax');
    print('kcal percentage: $kcalPerMin, $kcalPerMax');

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