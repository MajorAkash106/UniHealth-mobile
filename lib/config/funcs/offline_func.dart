import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/model/all_patient_id.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

Future<bool> IsOfflineDataAvailable(String id) async {
  SaveDataSqflite sqflite = SaveDataSqflite();

  bool output = false;
  // await sqflite.getData(id).then((res) {
  //   // print('patients antho data exist in sqlite : ${jsonEncode(res)}');
  //   if (res != null) {
  //     output = true;
  //   }
  // });
  await sqflite.getPatientIds().then((res) {
    if (res != null && res.allPatientIds.isNotEmpty) {
     var data =   res.allPatientIds.firstWhere((element) => element.patientId == id,orElse: ()=>null);
     if(data!=null){
       output = true;
     }
    }
  });

  return output;
}




Future<String> askToSendData(String patientId) async {

  return Get.dialog(WillPopScope(
      child: new AlertDialog(
        title: new Text(
          'do_you_want_sync_des'.tr,
          style: TextStyle(fontSize: 16),
        ),
        // content: new Text(
        //   'Anthropometry data is exist in offline storage',
        //   style: TextStyle(fontSize: 16),
        // ),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () async {
              Get.back(result: 'NO');
              // Get.back();
            },
            child: new Text('no'.tr.toUpperCase()),
          ),
          new ElevatedButton(
            onPressed: () async {
              Get.back(result: 'YES');
              // Get.back();

            },
            child: new Text('yes'.tr.toUpperCase()),
          ),
        ],
      ),
      onWillPop: willPopScope));
}

Future<bool> willPopScope() {
  print('popup value');
  Get.back();
  // Get.back();
}

Future<String> sendDataToServer(String patientId) async {
  SaveDataSqflite sqflite = SaveDataSqflite();
  OfflineHandler offlineHandler = OfflineHandler();
  PatientDetailsData patientDetailsData;
  await sqflite.getData(patientId).then((res) {
    print('patient data: ${res.name}');
    patientDetailsData = res;
  });

  String output;
  await offlineHandler.DataToServer(patientDetailsData).then((value) {
    print('return resp: $value');
    if (value == 'success') {
      // sqflite.clearData(patientDetailsData.sId);

      output = value;
    }
  });

 await output==null?(){} :sqflite.clearPatientId(patientDetailsData.sId);

  return output;
}
