
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

Future<Phenotypic>GETPHENOTYPIC(PatientDetailsData patientDetailsData)async{


  var data;
  for(var a in patientDetailsData.status){

    if(a.type == statusType.nutritionalDiagnosis && a.status == nutritionalDiagnosis.glim){

    data  = await a.result.first.phenotypic;

      break;
    }

  }
  print('phenotypic data : ${data}');
  return data;
}

Future<Etiologic>GETETIOLOGIC(PatientDetailsData patientDetailsData)async{


  var data;
  for(var a in patientDetailsData.status){

    if(a.type == statusType.nutritionalDiagnosis && a.status == nutritionalDiagnosis.glim){

      data  = await a.result.first.etiologic;

      break;
    }

  }
  print('phenotypic data : ${data}');
  return data;
}


Future<Severity>GETSEVERITY(PatientDetailsData patientDetailsData)async{


  var data;
  for(var a in patientDetailsData.status){

    if(a.type == statusType.nutritionalDiagnosis && a.status == nutritionalDiagnosis.glim){

      data  = await a.result.first.severity;

      break;
    }

  }
  print('phenotypic data : ${data}');
  return data;
}

Future<String>GETOPTION(List<EtioOptions> options)async{

  EtioOptions selectedData =  options.firstWhere((element) => element.isSelected ==true);

 print(selectedData.optionname);
 return selectedData.optionname;

}


Future<String>GETINFLAMTEXT(String Inflam,String perceived)async{
print('Inflam:$Inflam');
  String output = '';
  if(Inflam.contains('ACUTE DISEASE/INJURY') || Inflam.contains('DOENÇA AGUDA/LESÃO')){

    // output = await "ACUTE DISEASE/INJURY (1 POINT)";
    output = await "acute_disease_injury".tr;
  }else if(perceived == '0' ){
  //  yes
  //   output =await "CHRONIC DISEASE-RELATED WITH INFLAMMATION (1 POINT)";
    output =await "chronic_disease_related_with_inflammation".tr;
  }else if(perceived == '1' || perceived == '-1' ){
    //  no
    // output =await "CHRONIC DISEASE-RELATED (1 POINT)";
    output =await "chronic_disease_related".tr;
  }

  print('return INFLAMMATION here $output');
  return output;

}



Future<String>GETGLIMRESULT(PatientDetailsData patientDetailsData)async{
  for (var e in patientDetailsData.status) {
    if (e.type == '2' && e.status == nutritionalDiagnosis.glim)
    {Phenotypic phenotypic = e.result[0].phenotypic;
    Etiologic etiologic = e.result[0].etiologic;
    Severity severity = e.result[0].severity;

    if (phenotypic != null && etiologic != null) {
      print('PERCEIVED:  ${etiologic.PERCEIVED}');

      print('weightloss: ${phenotypic.weightlossStatus}');
      print('bmi: ${phenotypic.condition}');
      print('reduce muscle: ${phenotypic.reducedMassMuscle.length}');
      if(phenotypic.condition==null){
        phenotypic.condition = false;
      }

      String phenoScore = '1';
      String etioScore = '1';

      if (((phenotypic.weightlossStatus == null || phenotypic.weightlossStatus == '')  ||
          // phenotypic.weightlossStatus.contains('WEIGHT LOSS ABSENT'))
          (phenotypic.weightlossStatus.contains('WEIGHT LOSS ABSENT')) ||
          phenotypic.weightlossStatus.contains('NÃO HOUVE PERDA DE PESO'))
          && (phenotypic.condition == false) &&
          ((phenotypic.reducedMassMuscle == null || phenotypic.reducedMassMuscle.isEmpty))) {
        print('pheno points Zero');
        phenoScore = '0';
      }

      if (etiologic.etiologicData == null || etiologic.etiologicData == '') {
        print('etio points Zero');
        etioScore = '0';

      }

      // if(severity.)



      if(phenoScore == '0' || etioScore == '0'){
        //NO ONE OF THE PHENOTYPIC OR ETIOLOGIC CRITERIA
        // WERE FILLED - ZERO POINTS FOR BOTH

        print('NO MALNUTRITION');

        return "${'no_malnutrition'.tr} ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}";

      }else if(phenoScore != '0' && etioScore != '0' && etiologic.PERCEIVED == '0'){
        //  ONE OR MORE POINTS OF THE PHENOTYPIC + ONE OR MORE POINTS OF THE ETIOLOGIC
        // CRITERIA  (INFLAMMATION >
        // CHRONIC DISEASE-RELATED >
        // PERCEIVED INFLAMMATION)

        print('MALNUTRITION RELATED TO CHRONIC DISEASE WITH INFLAMMATION ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}');

        return '${'malnutrition_related_to_chronic_disease_with_inflammation'.tr} ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}';

      }else if(phenoScore != '0' &&
          // etiologic.iNFLAMMATIONText.contains('CHRONIC DISEASE-RELATED')
          (etiologic.iNFLAMMATIONText.contains('CHRONIC DISEASE-RELATED') || etiologic.iNFLAMMATIONText.contains('DOENÇA CRÔNICA RELATADA'))
          && etiologic.PERCEIVED != '0' ){
        //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
        // CRITERIA INFLAMMATION (INFLAMMATION >
        // CHRONIC DISEASE-RELATED) (IN THIS OPTION, THE PERCEIVED INFLAMMATION BOX WAS NOT CHECKED)

        print('MALNUTRITION RELATED TO CHRONIC DISEASE WITH MINIMAL OR NO PERCEIVED INFLAMMATION');

        return '${'malnutrition_related_to_chronic_disease_with_minimal_or_no_perceived_inflammation'.tr} ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}';

      }else if(phenoScore != '0' &&
          // etiologic.iNFLAMMATIONText.contains('ACUTE DISEASE/INJURY')
         (etiologic.iNFLAMMATIONText.contains('ACUTE DISEASE/INJURY') || etiologic.iNFLAMMATIONText.contains('DOENÇA AGUDA/LESÃO'))
      ){
        //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
        // CRITERIA INFLAMMATION  (INFLAMMATION >
        // ACUTE DISEASE/INJURY)
        print('MALNUTRITION RELATED TO ACUTE DISEASE OR INJURY WITH SEVERE INFLAMMATION');

        return '${'malnutrition_related_to_acute_disease_or_injury_with_severe_inflammation'.tr} ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}';

      }else if(phenoScore != '0' && etiologic.foodIntake.contains('YES')  && (etiologic.iNFLAMMATIONText == null || etiologic.iNFLAMMATIONText == '')){
        //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
        // CRITERIA REDUCED FOOD INTAKE
        // (IN THIS OPTION, INFLAMMATION WAS NOT CHECKED)

        print('MALNUTRITION RELATED TO STARVATION INCLUDING HUNGER/FOOD SHORTAGE ASSOCIATED WITH SOCIOECONOMIC OR ENVIRONMENTAL FACTORS');

        return '${'malnutrition_related_to_starvation_including_hunger_food_shortage_associated_with_socioeconomic_or_environmental_factors'.tr} ${severity?.stageType==null || severity?.stageType==''  ?"":"(${severity?.stageType?.toLowerCase().toString()?.tr?.toUpperCase()})"}';
      }





      break;
    }
    }

  }
}



Future<bool>GETSEVERITYACCESS(PatientDetailsData patientDetailsData)async{
  for (var e in patientDetailsData.status) {
    if (e.type == '2' && e.status == nutritionalDiagnosis.glim)
    {Phenotypic phenotypic = e.result[0].phenotypic;
    Etiologic etiologic = e.result[0].etiologic;
    Severity severity = e.result[0].severity;

    if (phenotypic != null && etiologic != null) {
      print('PERCEIVED:  ${etiologic.PERCEIVED}');

      print('weightloss: ${phenotypic.weightlossStatus}');
      print('bmi: ${phenotypic.condition}');
      print('reduce muscle: ${phenotypic.reducedMassMuscle.length}');

      if(phenotypic.condition==null){
        phenotypic.condition = false;
      }

      String phenoScore = '1';
      String etioScore = '1';

      if (((phenotypic.weightlossStatus ==null || phenotypic.weightlossStatus == '')
          || phenotypic.weightlossStatus.contains('WEIGHT LOSS ABSENT')
          || phenotypic.weightlossStatus.contains('NÃO HOUVE PERDA DE PESO')
      )
          && (phenotypic.condition == false)  && (phenotypic.reducedMassMuscle ==null || phenotypic.reducedMassMuscle.isEmpty)) {
        print('pheno points Zero');
        phenoScore = '0';
      }

      if (etiologic.etiologicData == null || etiologic.etiologicData == '' || etiologic.etiologicData.isEmpty) {
        print('etio points Zero');
        etioScore = '0';

      }

      // if(severity.)

      print('pheno status: ${phenoScore}');
      print('etio status: ${etioScore}');



      if(phenoScore == '0' || etioScore == '0'){
        //NO ONE OF THE PHENOTYPIC OR ETIOLOGIC CRITERIA
        // WERE FILLED - ZERO POINTS FOR BOTH

        print('NO MALNUTRITION');

        return false;;

      }else{

        return true;
      }





      break;
    }
    }

  }
}