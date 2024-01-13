import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusionReport_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';

class SinceAdmisionController extends GetxController{
  InfusionReportController infuse_controller = InfusionReportController();
  ParenteralNutrional_Controller pController = ParenteralNutrional_Controller();


  Future <Needs_Show_Data> getAdSince(PatientDetailsData pdata ) async {


   var finalData = await get_needsList_SinceAdm(pdata.needs,pdata);

    print('getData for planned : $getData');
    int get_min_kacl_per =await  pController.getPercent(finalData.aKcal??0,finalData.minKcal);
    int get_max_kaclPerc =await pController.getPercent(finalData.aKcal??0,finalData.maxKcal);

    int get_min_ptn_perc =await  pController.getPercent(finalData.aPtn??0,finalData.minPtn);
    int get_max_ptn_perc =await  pController.getPercent(finalData.aPtn??0,finalData.maxPtn);


    print("==SS===perc of mininum kacl ${get_min_kacl_per}");
    print("=====perc of maximum kacl ${get_max_kaclPerc}");
    print("=====perc of mininum protein ${get_min_ptn_perc}");
    print("=====perc of maximum protein ${get_max_ptn_perc}");


    return Needs_Show_Data(
        customized_min_kacl: finalData.minKcal,
        customized_max_kacl: finalData.maxKcal,
        customized_min_ptn: finalData.minPtn,
        customized_max_ptn: finalData.maxPtn,
        min_kacl_perc: get_min_kacl_per,
        max_kacl_perc: get_max_kaclPerc,
        min_ptn_perc: get_min_ptn_perc,
        max_ptn_perc: get_max_ptn_perc


    );

  }


  Future<SinceAd> get_needsList_SinceAdm(List<Needs> all_needsData,PatientDetailsData pdata )async{
    // this function will return all needs data before current day

    List<Needs> needsSinceAdm = [];
    String workingday = await getWorkingDays(pdata.hospital.first.sId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    for(var a in all_needsData){
      if(DateTime.parse(a.lastUpdate).isBefore(LastWorkEndCurrentStart)) {
        needsSinceAdm.add(a);
      }
    }
    print("sinceadm list,, ${jsonEncode(needsSinceAdm)}");
    print("sinceadm list,, ${needsSinceAdm.length}");

   var SinceAd  = await  allData(needsSinceAdm, pdata);
    // print('all days data - $output');

    return SinceAd;
  }





  Future<SinceAd> allData(List<Needs> sinceData,PatientDetailsData pdata,)async{

   List<SinceAd> output = [];
    print("sinceData,, ${sinceData.length}");

    List<String> _dateee = [];

    for(var a in sinceData){
      // List<Needs> data = [];
      print('_date: ${a.lastUpdate}');
     String g = await getDateFormatFromString(a.lastUpdate);
     print('_date: $g');

     _dateee.add(g);
    }

    print('g : ${_dateee.toSet()}');


    for(var a in _dateee.toSet().toList()){

      List<Needs>dataa = [];
      for(var b in sinceData){

        String gg = await getDateFormatFromString(b.lastUpdate);
        if(a == gg){
          dataa.add(b);
        }

      }


      print('list particular : ${dataa.length}');

     var finalData =  await getData(dataa, pdata);
     print('finalData of one day - ptn: ${finalData.aPtn} kcal : ${finalData.aKcal}');


     await output.add(finalData);

    }




    var returnData = await getTotal(output);
    return returnData;
  }


  Future<SinceAd>getTotal(List<SinceAd> data)async{
    double minKcal = 0.0;
    double maxKcal = 0.0;
    double aKcal = 0.0;

    double minPtn = 0.0;
    double maxPtn = 0.0;
    double aPtn = 0.0;


    for(var a in data){
      minKcal = await minKcal + a.minKcal;
      maxKcal = await maxKcal + a.maxKcal;
      aKcal = await aKcal + a.aKcal;

      minPtn = await minPtn + a.minPtn;
      maxPtn = await maxPtn + a.maxPtn;
      aPtn = await aPtn + a.aPtn;
    }




  print('sss $minKcal,$maxKcal,$aKcal,$minPtn,$maxPtn,$aPtn');

    var output = await SinceAd(minKcal,maxKcal,aKcal,minPtn,maxPtn,aPtn);


    return output;

  }


  Future<SinceAd>getData(List<Needs> sinceData,PatientDetailsData pdata,)async{


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

    var oralData = await getoralDiet(sinceData);
    print('----------------oralData-------------------');
    print('ptn: ${oralData.sum_of_ptn}');
    print('kcal: ${oralData.sum_of_kacl}');
    ptn = ptn + oralData.sum_of_ptn;
    kcal = kcal + oralData.sum_of_kacl;


    var onsData = await getOns(sinceData);
    print('----------------onsData-------------------');
    print('ptn: ${onsData.sum_of_ptn}');
    print('kcal: ${onsData.sum_of_kacl}');
    ptn = ptn + onsData.sum_of_ptn;
    kcal = kcal + onsData.sum_of_kacl;

    //
    var enteralData = await getEnteral(sinceData,pdata,start,end);
    print('----------------enteralData-------------------');
    print('ptn: ${enteralData.sum_of_ptn}');
    print('kcal: ${enteralData.sum_of_kacl}');
    ptn = ptn + enteralData.sum_of_ptn;
    kcal = kcal + enteralData.sum_of_kacl;


    var parenteralData = await getParenteral(sinceData,pdata,start,end);
    print('----------------parenteralData-------------------');
    print('ptn: ${parenteralData.sum_of_ptn}');
    print('kcal: ${parenteralData.sum_of_kacl}');
    ptn = ptn + parenteralData.sum_of_ptn;
    kcal = kcal + parenteralData.sum_of_kacl;

    //
    var proteinModuleData = await getProteinModule(sinceData,pdata,start,end);
    print('----------------proteinModuleData-------------------');
    print('ptn: ${proteinModuleData.sum_of_ptn}');
    print('kcal: ${proteinModuleData.sum_of_kacl}');
    ptn = ptn + proteinModuleData.sum_of_ptn;
    kcal = kcal + proteinModuleData.sum_of_kacl;


    var NNData = await getNonNutritional(sinceData);

    print('----------------NNData-------------------');
    print('ptn: ${NNData.sum_of_ptn}');
    print('kcal: ${NNData.sum_of_kacl}');
    ptn = ptn + NNData.sum_of_ptn;
    kcal = kcal + NNData.sum_of_kacl;

    print('-----------------Total Data------------------');
    print('ptn: $ptn');
    print('kcal: $kcal');

    var conditionData = await getConditionData(pdata,start,end);
    print('----------------conditionData-------------------');
    print('ptn: ${jsonEncode(conditionData)}');


    print('getData for planned : $getData');
    int ptnPer = await  pController.getPercent(ptn??0,double.parse(conditionData.minProtien));
    int kcalPer = await  pController.getPercent(kcal??0,double.parse(conditionData.minEnergy));

    print('----------------getPercentageData-------------------');
    print('duration : $start to $end');
    print('ptn percentage: $ptnPer');
    print('kcal percentage: $kcalPer');

    var output = await getOneDayData(ReturnData(ptnPer,kcalPer,conditionData));
    // print('output of one day - ptn: ${output.aPtn} kcal : ${output.aKcal}');

   return output;


  }


 Future<SinceAd> getOneDayData(ReturnData data)async{

   double minKcal = await double.parse(data.conditionData.minEnergy);
   double maxKcal = await double.parse(data.conditionData.maxEnergy);
   double aKcal = await double.parse(data.conditionData.minEnergy) * (data.kcalPer/100);

   double minPtn = await double.parse(data.conditionData.minProtien);
   double maxPtn = await double.parse(data.conditionData.maxProtien);
   double aPtn = await double.parse(data.conditionData.minProtien) * (data.ptnPer/100);
   var output = await SinceAd(minKcal,maxKcal,aKcal,minPtn,maxPtn,aPtn);


   return output;
  }



  //getConditionData

  Future<CutomizedData>getConditionData(PatientDetailsData pdata,DateTime start,DateTime end)async{

    List<CutomizedData> conditionDetails = await getCondionDetailsFromNT(pdata);

    CutomizedData output;
if(conditionDetails !=null) {
  for (var a in conditionDetails) {
    DateTime _date = DateTime.parse(a.lastUpdate);

    if (_date.isAfter(start) && _date.isBefore(end)) {
      output = a;
      break;
    } else if (_date.isBefore(start)) {
      output = a;
      break;
    }
  }
}
    return output;
  }


  Future<List<CutomizedData>> getCondionDetailsFromNT(PatientDetailsData patientDetailsData) async {
    List<CutomizedData> conditionDetails;
    for (var a in patientDetailsData.ntdata) {
      print('type: ${a.type},status: ${a.status}');
      if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
        conditionDetails = a.result.first.conditionDetails;
        print('yress');
        break;
      }
    }
    print('return data: ${conditionDetails?.length}');
    return conditionDetails;
  }


  //oral
  Future <Sum_of_ptn_kacl_needsData> getoralDiet(List<Needs> dataList) async {
    double  total_ptn=0.0;
    double total_kacl=0.0;
    if( dataList.length!=null && dataList.isNotEmpty){
      for(int i=0;i<dataList.length;i++){
        if(dataList[i].type == "oral_acceptance"){
          total_ptn = total_ptn +double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl +double.parse(dataList[i].achievementKcal);
          break;
        }

      }
      print("===amount of protein in non nutrition ${total_ptn}");
      print("===amount of kacl in non nutrition ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: total_ptn,sum_of_kacl: total_kacl);
  }

  //ons
  Future <Sum_of_ptn_kacl_needsData> getOns(List<Needs> dataList) async {
    double  total_ptn=0.0;
    double total_kacl=0.0;

    if( dataList.length!=null && dataList.isNotEmpty){
      for(int i=0;i<dataList.length;i++){
        if(dataList[i].type == "ons_acceptance"){
          total_ptn = total_ptn + double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl +double.parse(dataList[i].achievementKcal);
          break;
        }
      }
      print("===amount of protein in ons_acceptance ${total_ptn}");
      print("===amount of kacl in ons_acceptancee ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: total_ptn,sum_of_kacl: total_kacl);
  }


//  enteral

  Future <Sum_of_ptn_kacl_needsData> getEnteral(List<Needs> dataList,PatientDetailsData pdata,DateTime start,DateTime end) async {

     var a = await   get_last_day_eternalData(dataList);
     var b = await   get_achieved_enteral(a,pdata,start,end);

    return b?? Sum_of_ptn_kacl_needsData(sum_of_ptn: 0.0,sum_of_kacl: 0.0);
  }

  Future <Sum_of_ptn_kacl_needsData> get_last_day_eternalData(List<Needs> dataList) async {
    double  total_ptn=0.0;
    double total_kacl=0.0;


    if(dataList.length!=null && dataList.isNotEmpty){
      for(int i=0;i<dataList.length;i++){

        if(dataList[i].type == "enteral"){
          total_ptn = total_ptn + double.parse(dataList[i].plannedPtn);
          total_kacl =total_kacl + double.parse(dataList[i].plannedKcal);
        }


      }
      print("===expected ptn amount enteral ${total_ptn}");
      print("===expected kcal amount enteral ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: total_ptn,sum_of_kacl: total_kacl);
  }

  Future<Sum_of_ptn_kacl_needsData> get_achieved_enteral( Sum_of_ptn_kacl_needsData ptn_kacl_of_eternal ,PatientDetailsData data,DateTime start,DateTime end)async{


    // DateTime lastworkStart = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    // //particular date of that day
    // DateTime lastworkEnd = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, lastworkStart.add(Duration(days: 1)));

    var lastWorkDayInfused = await infuse_controller.getinfused_BetweenIntervals(data,"Enteral Nutrition",start,end);
    // print("pppppp ${jsonEncode(lastWorkDayInfused)}");
    var a = await lastWorkDayInfused * ptn_kacl_of_eternal.sum_of_kacl;

    var b = await lastWorkDayInfused * ptn_kacl_of_eternal.sum_of_ptn;

    var kcl =await double.parse(a.toStringAsFixed(2));


    var ptn = await double.parse(b.toStringAsFixed(2));


    print("ppppppe ${kcl}");
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn,sum_of_kacl: kcl);

  }



//  parenteral

  Future <Sum_of_ptn_kacl_needsData> getParenteral(List<Needs> dataList,PatientDetailsData pdata,DateTime start,DateTime end) async {
    // DateTime lastworkStart;
    // DateTime lastworkEnd;
    var lastWorkDayParenteralInfused = await infuse_controller.getinfused_BetweenIntervals(pdata,"Parenteral Nutrition",start,end);

    adLog('lastWorkDayParenteralInfused :: ${lastWorkDayParenteralInfused}');
    adLog('dataList :: ${dataList}');

    var a = await   get_lastday_parentraldata(dataList,lastWorkDayParenteralInfused);

    return a?? Sum_of_ptn_kacl_needsData(sum_of_ptn: 0.0,sum_of_kacl: 0.0);
  }

  Future<Sum_of_ptn_kacl_needsData> get_lastday_parentraldata(List <Needs> dataList,double infusedParenteral)async{
    var retData;
    double a = 0.0 ;
    double b = 0.0 ;
    print("datalist... ${jsonEncode(dataList)}");
    CalculatedParameters calculatedParams ;//= await get_lastday_parentralcalulated_params(dataList);
    if(dataList.length!=null && dataList.isNotEmpty){
      calculatedParams = await get_lastday_parentralcalulated_params(dataList);




      if(calculatedParams !=null){

        // adLog('infusedParenteral :: ${infusedParenteral}  calculatedParams.protien_perML :: ${calculatedParams.protien_perML}');
        a = (infusedParenteral * double.parse(calculatedParams.protien_perML))/1000;
        print("a.k ${a}");
        b = (infusedParenteral * double.parse(calculatedParams.kcl_perML))/1000;
      }else{
        print('calculated is nlul ');
      }
      // print("=== ptn amount in  parentral ${total_ptn}");
      // print("=== kacl amount in  parentral ${total_kacl}");
    }


    print("b.... ${b}");

    return Sum_of_ptn_kacl_needsData(sum_of_ptn: a,sum_of_kacl: b);
  }

  Future<CalculatedParameters> get_lastday_parentralcalulated_params(List <Needs> dataList)async{
    var retData;
    if(dataList.length!=null && dataList.isNotEmpty){
      print("datalist... ${jsonEncode(dataList)}");
      for(int i=0;i<dataList.length;i++){

        if(dataList[i].type == "parenteral"){
          print("9999.. ${jsonEncode(dataList[i])}");

          // adLog('dataList[i].isSecond ::: ${dataList[i].isSecond}');
          // if(dataList[i].isSecond==true){
          //   // dataList[i].calculatedParameters.protien_perML = dataList[i].plannedPtn;
          //   // dataList[i].calculatedParameters.kcl_perML = dataList[i].plannedKcal;
          //
          //   retData = await CalculatedParameters(protien_perML:dataList[i].plannedPtn??'0.0',
          //       kcl_perML: dataList[i].plannedKcal??'0.0',
          //       curruntWork: dataList[i].calculatedParameters?.curruntWork??"0.0" ) ;
          // }else {
            retData = await CalculatedParameters(
                protien_perML: dataList[i].calculatedParameters
                    ?.protien_perML ?? '0.0',
                kcl_perML: dataList[i].calculatedParameters?.kcl_perML ?? '0.0',
                curruntWork: dataList[i].calculatedParameters?.curruntWork ??
                    "0.0");
          // }



          // print("9999.. ${jsonEncode(retData)}");
        }


      }
      // print("=== ptn amount in  parentral ${total_ptn}");
      // print("=== kacl amount in  parentral ${total_kacl}");
    }


    return retData;
  }


//  protein module

  Future <Sum_of_ptn_kacl_needsData> getProteinModule(List<Needs> dataList,PatientDetailsData pdata,DateTime start,DateTime end) async {

    var a  = await get_lastDay_sum_of_proteinModule_data(pdata,dataList);
    var b  = await get_achieved_protienModule(pdata,a,start,end);


    return b?? Sum_of_ptn_kacl_needsData(sum_of_ptn: 0.0,sum_of_kacl: 0.0);
  }

  Future <Sum_of_ptn_kacl_needsData> get_lastDay_sum_of_proteinModule_data(PatientDetailsData patientDetailsData,List<Needs> dataList) async {
    double  total_ptn=0.0;
    double total_kacl=0.0;


    if( dataList.length!=null && dataList.isNotEmpty){
      for(int i=0;i<dataList.length;i++){

        if(dataList[i].type == "Enteral Protein Module"){
          total_ptn = total_ptn +double.parse(dataList[i].plannedPtn);
          total_kacl = total_kacl +double.parse(dataList[i].plannedKcal);
break;
        }


      }
      print("===amount of protein in protein module ${total_ptn}");
      print("===amount of kacl in protein module ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: total_ptn,sum_of_kacl: total_kacl);
  }


  Future<Sum_of_ptn_kacl_needsData> get_achieved_protienModule(PatientDetailsData data, Sum_of_ptn_kacl_needsData ptn_kacl_of_eternalModule,DateTime start,DateTime end )async{

    print('oo');
    var kcl = 0.0;
    var ptn = 0.0;
    if(ptn_kacl_of_eternalModule.sum_of_kacl!=0.0 && ptn_kacl_of_eternalModule.sum_of_ptn !=0.0){
      // DateTime lastworkStart = await getDateTimeWithWorkdayHosp(
      //     data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
      //
      // DateTime lastworkEnd = await getDateTimeWithWorkdayHosp(
      //     data.hospital.first.sId, lastworkStart.add(Duration(days: 1)));

      var lastWorkDayInfused = await infuse_controller.getinfused_BetweenIntervals(data,"Enteral Protein Module",start,end);

      print("iiipp... ${jsonEncode(lastWorkDayInfused)}");
      double g_perML = ptn_kacl_of_eternalModule.sum_of_ptn/ptn_kacl_of_eternalModule.sum_of_kacl;
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

    return Sum_of_ptn_kacl_needsData(sum_of_ptn: ptn,sum_of_kacl: kcl);

  }


//non nutritional

  Future <Sum_of_ptn_kacl_needsData> getNonNutritional(List<Needs> dataList) async {
    double  total_ptn=0.0;
    double total_kacl=0.0;


    if( dataList.length!=null && dataList.isNotEmpty){
      for(int i=0;i<dataList.length;i++){

        if(dataList[i].type == "non_nutritional"){
          total_ptn = total_ptn +double.parse(dataList[i].achievementProtein);
          total_kacl = total_kacl +double.parse(dataList[i].achievementKcal);

          break;
        }


      }
      print("===amount of protein in non nutrition ${total_ptn}");
      print("===amount of kacl in non nutrition ${total_kacl}");
    }
    return Sum_of_ptn_kacl_needsData(sum_of_ptn: total_ptn,sum_of_kacl: total_kacl);
  }

}


class ReturnData{
  int ptnPer;
  int kcalPer;
  CutomizedData conditionData;
  ReturnData(this.ptnPer,this.kcalPer,this.conditionData);
}

class SinceAd{
  double minKcal;
  double maxKcal;
  double aKcal;

  double minPtn;
  double maxPtn;
  double aPtn;
  SinceAd(this.minKcal,this.maxKcal,this.aKcal, this.minPtn,this.maxPtn,this.aPtn);
}