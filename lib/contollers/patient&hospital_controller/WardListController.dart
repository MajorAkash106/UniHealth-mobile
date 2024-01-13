import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class WardListController extends GetxController {
  HospitalSqflite sqflite = HospitalSqflite();

  var wardListdata = List<WardData>().obs;
  var isError = false.obs;

  Future<String> getWardData(String id) async {
    print(APIUrls.getWardList);
    print(id);
    print("api calling ${APIUrls.getWardList}");

    showLoader();
    try {
      Request request = Request(url: APIUrls.getWardList, body: {
        'hospitalId': id,
        'type': '0',
      });

      print(request.body);

      await request.post().then((value) {
        WardList wardList = WardList.fromJson(json.decode(value.body));

        //save to sqlite
        sqflite.saveWard(wardList, id);

        adLog('wardList.patients :: ${wardList.patients.length}');
        saveAllPatients(wardList.patients);

        print(wardList.success);
        print(wardList.message);
        Get.back();
        if (wardList.success == true) {
          wardListdata.addAll(wardList.data);
          wardListdata.sort((a, b) {
            return a.wardname
                .toString()
                .toLowerCase()
                .compareTo(b.wardname.toString().toLowerCase());
          });
        } else {
          isError.value = true;
          // ShowMsg(wardList.message);
        }
      });
    } catch (e) {
      print('exception occur : ${e}');
      Get.back();
      isError.value = true;
      // ServerError();
    }

    return "success";
  }

  Future<String> getWardDataWithoutLoader(String id) async {
    print(APIUrls.getWardList);
    print(id);

    // showLoader();
    try {
      Request request = Request(url: APIUrls.getWardList, body: {
        'hospitalId': id,
        'type': '0',
      });

      print(request.body);

      await request.post().then((value) {
        WardList wardList = WardList.fromJson(json.decode(value.body));

        //save to sqlite
        sqflite.saveWard(wardList, id);
        saveAllPatients(wardList.patients);

        print(wardList.success);
        print(wardList.message);
        // Get.back();
        if (wardList.success == true) {
          wardListdata.addAll(wardList.data);



          wardListdata.sort((a, b) {
            return a.wardname
                .toString()
                .toLowerCase()
                .compareTo(b.wardname.toString().toLowerCase());
          });
        } else {
          isError.value = true;
          // ShowMsg(wardList.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future getFromSqflite(String id) async {
    await sqflite.getWards(id).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {
          print(wardList.data);
          wardListdata.addAll(wardList.data);
          wardListdata.sort((a, b) {
            return a.wardname
                .toString()
                .toLowerCase()
                .compareTo(b.wardname.toString().toLowerCase());
          });
        } else {
          ShowMsg(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });

    return 'success';
  }
}

Future<String> saveAllPatients(List<PatientDetailsData> data) async {
  for (var a in data) {
    SaveDataSqflite sqflite = SaveDataSqflite();
    await sqflite.savePatientDetails(a);
  }
}
