import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/AddPatientModel.dart';
import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/HospitalDetailsModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/medicalDivision.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class DiagnosisController extends GetxController {
  final HistoryController _historyController = HistoryController();

  Future<String> saveDiagnosis(PatientDetailsData data,String text) async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      print('userId: $userid');
      print(APIUrls.editProfile);
      data.hospital[0].diagnosis = text;
      data.hospital[0].diagnosisLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.editProfile, body: {
        // 'name': data.name,
        // 'email': data.email,
        // 'phone': data.phone,
        // 'hospitalId': data.hospitalId,
        'city': data.city,
        'state': data.state,
        // 'street': 'street',
        // 'rId': data.rId,
        // 'dob': data.dob,
        // 'wardId': data.ward,
        // 'bedId': data.bed,
        // 'medicalId': mDivision,
        // 'insurance': data.insurance,
        // 'password': data.,

        'userId': data.sId,
        // 'admissionDate': data.admissionDate,
        "hospital": jsonEncode(data.hospital),
        // "palcare": jsonEncode(data.palcare),
        // "usertype": '4',
        "apptype" : "0"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);

        Get.back();
        if(commonResponse.success==true){
          Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        }else{
          ShowMsg(commonResponse.message);
        }


      });

     await _historyController.saveHistory(data.sId, ConstConfig.diagnosisHistory, text);

    }catch(e){
      Get.back();
      // ServerError();
    }

    return "success";

  }

  Future<String> saveObservation(PatientDetailsData data,String text) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    try {

      print(APIUrls.editProfile);
      data.hospital[0].observation = text;
      data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.editProfile, body: {
        'city': data.city,
        'state': data.state,
        'userId': data.sId,
        "hospital": jsonEncode(data.hospital),
        "diagnosis":jsonEncode(data.diagnosis),
        "apptype" : "0"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        // Get.back();
        if(commonResponse.success==true){
          Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        }else{
          ShowMsg(commonResponse.message);
        }


      });
      await _historyController.saveHistory(data.sId, ConstConfig.obsHistory, text);

    }catch(e){
      print('exception: $e');
      // Get.back();
      // Get.back();
      // ServerError();
    }

    return "success";

  }

  Future<String> saveObservationOffline(PatientDetailsData data,String text) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    try {


      data.hospital[0].observation = text;
      data.hospital[0].observationLastUpdate = "${DateTime.now()}";


      print('patient data: ${jsonEncode(data)}');
      print('obs data: ${jsonEncode(data.hospital)}');

      SaveDataSqflite sqflite = SaveDataSqflite();
     await sqflite.saveData(data);

     Get.to(Step1HospitalizationScreen(patientUserId: data.sId,statusIndex: 0,index: 0,));


    }catch(e){
      print('exception: $e');

    }

    return "success";

  }

}
