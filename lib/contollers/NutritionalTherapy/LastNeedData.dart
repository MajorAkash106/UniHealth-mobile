
import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/sinceAdmision_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class LastNeedData extends GetxController{
  SinceAdmisionController sinceAdmisionController = SinceAdmisionController();
  ParenteralNutrional_Controller pController = ParenteralNutrional_Controller();


  Future<Needs_Show_Data>getDataa(PatientDetailsData pdata,)async{

    Needs_CurrentDay_List getData = await pController.getNeeds_achievementData(pdata, pdata.hospital.first.sId);

    List<Needs> sinceData = [];
    await sinceData.addAll(getData.lastDayList);

    print('LastNeedData currentDataaaaaaaa : ${sinceData}');

   if(sinceData.isNotEmpty){
     String gg = await getDateFormatFromString(sinceData.first.lastUpdate);

     DateTime start = await getDateTimeWithWorkdayHosp(pdata.hospital.first.sId, DateTime.parse(gg));
     DateTime end = start.add(Duration(days: 1));

     print('start time : ${start} gg $gg');
     print('end time : ${end}');
     //

     double ptn = 0.0;
     double kcal = 0.0;

     var oralData = await sinceAdmisionController.getoralDiet(sinceData);
     print('----------------oralData------------N-------');
     print('ptn: ${oralData.sum_of_ptn}');
     print('kcal: ${oralData.sum_of_kacl}');
     ptn = ptn + oralData.sum_of_ptn;
     kcal = kcal + oralData.sum_of_kacl;


     var onsData = await sinceAdmisionController.getOns(sinceData);
     print('----------------onsData--------------N-----');
     print('ptn: ${onsData.sum_of_ptn}');
     print('kcal: ${onsData.sum_of_kacl}');
     ptn = ptn + onsData.sum_of_ptn;
     kcal = kcal + onsData.sum_of_kacl;

     //
     var enteralData = await sinceAdmisionController.getEnteral(sinceData,pdata,start,end);
     print('----------------enteralData--------------N-----');
     print('ptn: ${enteralData.sum_of_ptn}');
     print('kcal: ${enteralData.sum_of_kacl}');
     ptn = ptn + enteralData.sum_of_ptn;
     kcal = kcal + enteralData.sum_of_kacl;


     var parenteralData = await sinceAdmisionController.getParenteral(sinceData,pdata,start,end);
     print('----------------parenteralData-------------N------');
     print('ptn: ${parenteralData.sum_of_ptn}');
     print('kcal: ${parenteralData.sum_of_kacl}');
     ptn = ptn + parenteralData.sum_of_ptn;
     kcal = kcal + parenteralData.sum_of_kacl;

     //
     var proteinModuleData = await sinceAdmisionController.getProteinModule(sinceData,pdata,start,end);
     print('----------------proteinModuleData-------------N------');
     print('ptn: ${proteinModuleData.sum_of_ptn}');
     print('kcal: ${proteinModuleData.sum_of_kacl}');
     ptn = ptn + proteinModuleData.sum_of_ptn;
     kcal = kcal + proteinModuleData.sum_of_kacl;


     var NNData = await sinceAdmisionController.getNonNutritional(sinceData);

     print('----------------NNData-------------N------');
     print('ptn: ${NNData.sum_of_ptn}');
     print('kcal: ${NNData.sum_of_kacl}');
     ptn = ptn + NNData.sum_of_ptn;
     kcal = kcal + NNData.sum_of_kacl;

     print('-----------------Total Data-------------N-----');
     print('ptn: $ptn');
     print('kcal: $kcal');

     var finalData = await sinceAdmisionController.getConditionData(pdata,start,end);
     print('----------------conditionData---------------N----');
     print('ptn: ${jsonEncode(finalData)}');


     // print('getData for planned : $getData');
     // int ptnPermin = await  pController.getPercent(ptn??0,double.parse(finalData.minProtien));
     // int ptnPermax = await  pController.getPercent(ptn??0,double.parse(finalData.maxProtien));
     //
     // int kcalPermin = await  pController.getPercent(kcal??0,double.parse(finalData.minEnergy));
     // int kcalPermax = await  pController.getPercent(kcal??0,double.parse(finalData.maxEnergy));



     // print('getData for planned : $getData');
     int get_min_kacl_per =await  pController.getPercent(kcal??0,double.parse(finalData.minEnergy));
     int get_max_kaclPerc =await pController.getPercent(kcal??0,double.parse(finalData.maxEnergy));

     int get_min_ptn_perc =await  pController.getPercent(ptn??0,double.parse(finalData.minProtien));
     int get_max_ptn_perc =await  pController.getPercent(ptn??0,double.parse(finalData.maxProtien));

     print('----------------last Daya dataa--------------N-----');
     print("=====perc of mininum kacl ${get_min_kacl_per}");
     print("=====perc of maximum kacl ${get_max_kaclPerc}");
     print("=====perc of mininum protein ${get_min_ptn_perc}");
     print("=====perc of maximum protein ${get_max_ptn_perc}");


     return Needs_Show_Data(
         customized_min_kacl: double.parse(finalData.minEnergy),
         customized_max_kacl: double.parse(finalData.maxEnergy),
         customized_min_ptn: double.parse(finalData.minProtien),
         customized_max_ptn: double.parse(finalData.maxProtien),
         min_kacl_perc: get_min_kacl_per,
         max_kacl_perc: get_max_kaclPerc,
         min_ptn_perc: get_min_ptn_perc,
         max_ptn_perc: get_max_ptn_perc


     );
   }else{
     return Needs_Show_Data(
         customized_min_kacl: 0.00,
         customized_max_kacl: 0.00,
         customized_min_ptn:  0.00,
         customized_max_ptn: 0.00,
         min_kacl_perc: 0,
         max_kacl_perc: 0,
         min_ptn_perc: 0,
         max_ptn_perc: 0


     );
   }


  }

}