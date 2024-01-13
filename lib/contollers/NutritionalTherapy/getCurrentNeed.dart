import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class CurrentNeed extends GetxController {
  ParenteralNutrional_Controller _controller = ParenteralNutrional_Controller();

  Future<List<double>> getCurrentNeed(PatientDetailsData data) async {
    Needs_CurrentDay_List getData = await _controller.getNeeds_achievementData(
        data, data.hospital.first.sId);

    List<Needs> currentData = [];
    await currentData.addAll(getData.currentDayList);

    print('currentData : ${currentData}');

    if (currentData.isNotEmpty) {
      var oralData = await getObjects(currentData, 'oral_fasting');
      // await currentData.firstWhere((e) => e.type == 'oral_acceptance', orElse: null);

      var onsData = await getObjects(currentData, 'ons_data');
      // await currentData.firstWhere((e) => e.type == 'ons_acceptance', orElse: null);
      var enteralData = await getObjects(currentData, 'enteral');
      // await currentData.firstWhere((e) => e.type == 'enteral', orElse: null);
      var parenteralData = await getObjects(currentData, 'parenteral');
      // await currentData.firstWhere((e) => e.type == 'parenteral', orElse: null);
      var nonNutritionalData = await getObjects(currentData, 'non_nutritional');
      // await currentData.firstWhere((e) => e.type == 'non_nutritional', orElse: null);
      var proteinModuleData =
          await getObjects(currentData, 'Enteral Protein Module');
      // await currentData.firstWhere((e) => e.type == 'Enteral Protein Module', orElse: null);

      double ptn = 0.0;
      double kcal = 0.0;

      if (oralData != null) {
        print('---------got-----------');
        ptn = ptn + double.parse(oralData.plannedPtn);
        kcal = kcal + double.parse(oralData.plannedKcal);

        print('---------------oralData------------------');
        print('ptn : ${double.parse(oralData.plannedPtn)}');
        print('kcal : ${double.parse(oralData.plannedKcal)}');
      }

      if (onsData != null) {
        ptn = ptn + double.parse(onsData.plannedPtn);
        kcal = kcal + double.parse(onsData.plannedKcal);

        print('---------------onsData------------------');
        print('ptn : ${double.parse(onsData.plannedPtn)}');
        print('kcal : ${double.parse(onsData.plannedKcal)}');
      }

      if (enteralData != null) {
        double p = double.parse(enteralData.calculatedParameters.curruntWork) *
            double.parse(enteralData.calculatedParameters.protien_perML);
        double k = double.parse(enteralData.calculatedParameters.curruntWork) *
            double.parse(enteralData.calculatedParameters.kcl_perML);

        ptn = ptn + p;
        kcal = kcal + k;

        print('---------------enteralData------------------');
        print('ptn : ${p}');
        print('kcal : ${k}');
      }

      if (parenteralData != null) {
        double p = 0.0;
        double k = 0.0;

        // adLog('parenteralData.plannedKcal :: ${parenteralData.plannedKcal}');
        // adLog('parenteralData.isSecond :: ${parenteralData.isSecond}');


        if (parenteralData.isSecond) {
          p = double.parse(parenteralData.plannedPtn);
          k = double.parse(parenteralData.plannedKcal);
        } else {
          p = double.parse(parenteralData.calculatedParameters.curruntWork) *
              double.parse(parenteralData.calculatedParameters.protien_perML);

          k = double.parse(parenteralData.calculatedParameters.curruntWork) *
              double.parse(parenteralData.calculatedParameters.kcl_perML);
        }

        ptn = ptn + p;
        kcal = kcal + k;

        print('---------------parenteralData------------------');
        print('ptn : ${p}');
        print('kcal : ${k}');
      }

      if (nonNutritionalData != null) {
        ptn = ptn + 0.0;
        kcal = kcal + double.parse(nonNutritionalData.achievementKcal);

        print('---------------nonNutritionalData------------------');
        print('ptn : ${0}');
        print('kcal : ${double.parse(nonNutritionalData.achievementKcal)}');
      }

      if (proteinModuleData != null) {
        ptn = ptn + double.parse(proteinModuleData.plannedPtn);
        kcal = kcal + (double.parse(proteinModuleData.plannedPtn) * 4);

        print('---------------proteinModuleData------------------');
        print('ptn : ${double.parse(proteinModuleData.plannedPtn)}');
        print('kcal : ${(double.parse(proteinModuleData.plannedPtn) * 4)}');
      }

      print('---------------total------------------');
      print('ptn : ${ptn}');
      print('kcal : ${kcal}');
      return [ptn, kcal];
    } else {
      return [0.0, 0.0];
    }
  }

  Future<Needs> getObjects(List<Needs> data, String type) async {
    Needs output;

    for (var a in data) {
      if (a.type == type) {
        output = a;
        break;
      }
    }
    return output;
  }

  Future<PatientDetailsData> removeNeedObject(
      PatientDetailsData pData, String type) async {
    List<Needs> needs = pData.needs;

    for (var a in needs) {
      if (a.type == type) {

        adLog('removing object of $type');
        needs.remove(a);
        break;
      }
    }

    pData.needs = needs;
    return pData;
  }
}
