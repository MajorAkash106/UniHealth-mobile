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
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';

class PatientListController extends GetxController {
  HospitalSqflite _sqflite = HospitalSqflite();

  var patientslList = List<PatientData>().obs;

  void getHospitalData() async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getUserdetails);
      Request request = Request(url: APIUrls.getUserdetails, body: {
        'userId': userid,
      });

      await request.post().then((value) {
        Settingdetails settingdetails =
            Settingdetails.fromJson(json.decode(value.body));
        print(settingdetails.success);
        print(settingdetails.message);
        if (settingdetails.success == true) {
          print(settingdetails.data.hospital);
          getPatientListData(settingdetails.data.hospital);
        } else {
          ShowMsg(settingdetails.message);
        }
      });
    } catch (e) {
      ServerError();
    }
  }

  void getPatientListData(List<Hospital> hospitalId) async {
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getPatientList);
      Request request = Request(url: APIUrls.getPatientList, body: {
        'usertype': '4',
        'hospitalId': jsonEncode(hospitalId),
      });

      print(request.body);
      await request.post().then((value) {
        PatientList patientList = PatientList.fromJson(json.decode(value.body));

        //save to sqflite
        _sqflite.savePatients(patientList);

        print('patients list : ${patientList.success}');
        // print(patientList.message);
        Get.back();
        if (patientList.success == true) {
          print(patientList.data.first.name);
          print("patients length: ${patientList.data.length}");
          print("patients length: ${patientList.data[0].updatedAt}");
          patientslList.clear();
          patientslList.addAll(patientList.data);

          patientslList.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(patientList.message);
        }
      });
    } catch (e) {
      print(e);
      // ServerError();
    }
  }

  Future<String> getFromSqflite() {
    _sqflite.getPatients().then((response) {
      if (response != null) {
        PatientList patientList = response;
        print('patients list : ${patientList.success}');

        if (patientList.success == true) {
          print(patientList.data.first.name);
          print("patients length: ${patientList.data.length}");
          print("patients length: ${patientList.data[0].updatedAt}");
          patientslList.clear();
          patientslList.addAll(patientList.data);
        } else {
          ShowMsg(patientList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
  }
}
