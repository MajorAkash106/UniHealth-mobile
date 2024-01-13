import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class OtherClinicalDataController extends GetxController {
  final HistoryController _historyController = HistoryController();
  final VigilanceController vigilanceController = VigilanceController();

  void onSaved(PatientDetailsData data, String freeText) async {
    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "output": freeText,
    };

    print('final Data: ${jsonEncode(finalData)}');

    await saveHistory(data.sId, freeText, ConstConfig.other_clinical_data,
        data.hospital.first.sId);

    await vigilanceController
        .saveData(data, finalData, VigiLanceBoxes.otherClinicalDataStatus,
            VigiLanceBoxes.otherClinicalDataType)
        .then((value) {
      Get.to(Step1HospitalizationScreen(
          patientUserId: data.sId, index: 3, statusIndex: 0));
    });
  }

  Future<String> saveHistory(
      String patientId, String data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();
    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      print('internet avialable');
      await _historyController.saveHistory(patientId, type, data);
    }
  }

  Future<Vigilance> getClinicalData(PatientDetailsData data) async {
    Vigilance _vigilance;

    if (!data.vigilance.isNullOrBlank) {
      _vigilance = await data.vigilance.firstWhere(
          (element) =>
              element.type == VigiLanceBoxes.otherClinicalDataType &&
              element.status == VigiLanceBoxes.otherClinicalDataStatus,
          orElse: () => null);
    }

    return _vigilance;
  }
}
