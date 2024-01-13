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
import 'package:medical_app/model/CIDModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class CIDsController extends GetxController {
  var CIDList = List<CIDData>().obs;

  Future<String> getListData() async {
    // showLoader();

    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getCidOption);
      Request request = Request(url: APIUrls.getCidOption, body: {});

      await request.post().then((value) {
        CIDModel model = CIDModel.fromJson(json.decode(value.body));
        print('response : ${model.success}');
        print('cid len: ${model.data.length}');
        // Get.back();
        if (model.success == true) {
          CIDList.clear();
          CIDList.addAll(model.data);

        } else {
          // ShowMsg(model.message);

        }
      });
    } catch (e) {
      // ServerError();
    }

    return 'success';
  }

  Future<String> saveData(PatientDetailsData data, Map diagnosis) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      List dignosisList = [];

      dignosisList.add(diagnosis);

      print('diagnosis list : ${jsonEncode(dignosisList)}');

      Request request = Request(url: APIUrls.editProfile, body: {
        'city': data.city,
        'state': data.state,
        'userId': data.sId,
        "hospital": jsonEncode(data.hospital),
        "diagnosis": jsonEncode(dignosisList),
        "apptype": "0"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          Get.to(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 0,
          ));
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      Get.back();
      ServerError();
    }

    return "success";
  }

  Future<String> saveDataOffline(
      PatientDetailsData data, List<CIDData> selectedData) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    try {


      List<CidData> ciddata = [];
      for (var a in selectedData) {
        await ciddata.add(
            CidData(cidname: a.cidname, sId: a.sId, isSelected: a.isSelected,createdAt: '',isBlocked: false,updatedAt: '',iV: 0));
      }


      data.diagnosis.clear();
      data.diagnosis.add(Diagnosis(lastUpdate:'${DateTime.now()}', cidData: ciddata));

      print('cid data: ${jsonEncode(ciddata)}');
      print('patient data: ${jsonEncode(data)}');
      print('patient diagnosis: ${jsonEncode(data.diagnosis)}');


      SaveDataSqflite sqflite = SaveDataSqflite();
    await  sqflite.saveData(data);

    Get.to(Step1HospitalizationScreen(patientUserId: data.sId,index: 0,statusIndex: 0,));



    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }
}
