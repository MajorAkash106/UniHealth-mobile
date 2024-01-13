import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/status.dart';

class PatientSlipController extends GetxController {
  List<PatientDetailsData> patientDetailsData = List<PatientDetailsData>().obs;

  // PatientDetailsData patientDetailsData;

  Future<bool> getRoute(String hosId) async {
    bool internet = await checkConnectivityWithToggle(hosId);
    return internet;
  }

  Future<String> getDetails(String id, int statusIndex) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    // showLoader();
    try {
      print(APIUrls.getPatientsdetails);
      Request request = Request(url: APIUrls.getPatientsdetails, body: {
        'userId': id,
      });

      print(request.body);

      await request.post().then((value) {
        PatientDetails patientDetails =
            PatientDetails.fromJson(json.decode(value.body));
        print(patientDetails.success);
        print(patientDetails.message);
        // Get.back();
        if (patientDetails.success == true) {
          //update data
          SaveDataSqflite sqflite = SaveDataSqflite();
          sqflite.savePatientDetails(patientDetails.data);

          patientDetailsData.clear();
          print(patientDetails.data);
          patientDetailsData.add(patientDetails.data);
          print('ppppuuuu${jsonEncode(patientDetails.data.needs)}');
          patientDetailsData[0].statusIndex = statusIndex;
          MySharedPreferences.instance
              .setStringValue(Session.espenKey, 'false');
        } else {
          ShowMsg(patientDetails.message);
        }
      });
    } catch (e) {
      ServerError();
    }
    return 'success';
  }

  Future<String> getDetailsOffline(String id, int statusIndex) async {
    try {
      PatientDetailsData patientDetails;

      SaveDataSqflite sqflite = SaveDataSqflite();
      await sqflite.getData(id).then((resp) {
        patientDetails = resp;
      });

      patientDetailsData.clear();
      print(patientDetails);
      patientDetailsData.add(patientDetails);
      patientDetailsData[0].statusIndex = statusIndex;
      MySharedPreferences.instance.setStringValue(Session.espenKey, 'false');
    } catch (e) {
      ServerError();
    }
    return 'success';
  }



  //return direct patient details from sqflite
  Future<PatientDetailsData> getReturnOffline(String id, int statusIndex) async {
    PatientDetailsData patientDetails;
    try {


      SaveDataSqflite sqflite = SaveDataSqflite();
      patientDetails =  await sqflite.getData(id);

      patientDetailsData.clear();
      print(patientDetails);
      patientDetailsData.add(patientDetails);
      patientDetailsData[0].statusIndex = statusIndex;
      MySharedPreferences.instance.setStringValue(Session.espenKey, 'false');
    } catch (e) {
      ServerError();
    }
    return patientDetails;
  }

}
