import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import 'package:medical_app/config/cons/APIs.dart';

import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';

import 'package:medical_app/model/commonResponse.dart';

class OfflineHandler {
  final SaveDataSqflite sqfliteStroe = SaveDataSqflite();

  Future<String> handleAnthroOffline(
      var anthro, PatientDetailsData patientDetailsData) async {
    print('get offline from anthro:  ${anthro}');

    var encodeddata = jsonEncode(anthro);
    Anthropometry anthro_data =
        await Anthropometry.fromJson(jsonDecode(encodeddata));

    print('anthro from model: ${anthro_data.heightMeasuredReported_inch}');

    patientDetailsData.anthropometry.clear();
    patientDetailsData.anthropometry.add(anthro_data);

    print(
        'antho data form patient model:  ${patientDetailsData.anthropometry.first.heightMeasuredReported_inch}');

    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(patientDetailsData);

    Get.to(Step1HospitalizationScreen(
      patientUserId: patientDetailsData.sId,
      statusIndex: 0,
      index: 2,
    ));
  }

  Future<PatientDetailsData> getPatientData(String id) async {
    PatientDetailsData patientDetailsData = await sqfliteStroe.getData(id);

    return patientDetailsData;
  }

  Future<String> DataToServer(PatientDetailsData patientDetailsData) async {
    String output;
    try {
      print(APIUrls.UpdateDAta);

      print("patientDetailsData.enteralFormula :: ${patientDetailsData.enteralFormula}");

      Request request = Request(url: APIUrls.UpdateDAta, body: {
        'userId': patientDetailsData.sId,
        'data': jsonEncode(patientDetailsData)
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        if (commonResponse.success == true) {
          output = 'success';
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      // Get.back();
      ServerError();
    }
    return output;
  }

  Future<String> DataToServerMultiple(List<PatientDetailsData> dataList) async {
    String output;
    try {
      print(APIUrls.UpdateDAtaMultiple);

      print("patientDetailsData.first.enteralFormula :: ${dataList.first.enteralFormula}");
      print("patientDetailsData.first.parenteralFormula :: ${dataList.first.parenteralFormula}");

      Request request = Request(
          url: APIUrls.UpdateDAtaMultiple,
          body: {'data': jsonEncode(dataList)});

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        if (commonResponse.success == true) {
          output = 'success';
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      // Get.back();
      ServerError();
    }
    return output;
  }

  Future<bool> getFilterStatus(String id) async {
    HospitalSqflite sqflite = HospitalSqflite();
    bool output = true;

    if (id != null) {
      await sqflite.getFilteredStatus(id).then((value) {
        if (value != null) {
          output = value.staus;
        }
      });
    }

    return output;
  }
}
