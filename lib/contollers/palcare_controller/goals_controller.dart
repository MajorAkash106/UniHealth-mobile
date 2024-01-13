import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';

import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';

import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';

import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class GoalsController extends GetxController {
  var goalData = List<AKPSData>().obs;

  Future<String> getData() async {
    try {
      var data = await getJson(JsonFilePath.goalData);
      print('data from json file: ${json.decode(data)}');

      AkpsDataModel akpsDataModel = AkpsDataModel.fromJson(json.decode(data));
      print(akpsDataModel.success);
      print(akpsDataModel.message);
      if (akpsDataModel.success == true) {
        print(akpsDataModel.data.length);
        goalData.clear();
        goalData.addAll(akpsDataModel.data);
        print(goalData.length);
      } else {
        ShowMsg(akpsDataModel.message);
      }
    } catch (e) {
      // Get.back();
      print('exception occur: $e');
      // ServerError();
    }
    // return 'success';
  }

  Future<String> saveData(PatientDetailsData data, Map goals) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      List palcareList = [];

      if (data.palcare.isEmpty) {
        palcareList.add(goals);
      } else {
        // for(var i = 0; i<data.palcare.length;i++){
        //   if(data.palcare[i].palcare == "goals"){
        palcareList.add(goals);
        //     break;
        //   }
        // }

        for (var i = 0; i < data.palcare.length; i++) {
          if (data.palcare[i].palcare == "akps") {
            palcareList.add(data.palcare[i]);
            break;
          }
        }

        for (var i = 0; i < data.palcare.length; i++) {
          if (data.palcare[i].palcare == "spict") {
            palcareList.add(data.palcare[i]);
            break;
          }
        }
      }

      print('palcare list : ${jsonEncode(palcareList)}');

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
        'palcare': jsonEncode(palcareList),
        // 'admissionDate': data.admissionDate,
        // "hospital": jsonEncode(data.hospital),
        // "usertype": '4',
        "apptype": "1"
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
            index: 1,
          ));
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
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


  Future<String> saveDataGoalsDataOffline(PatientDetailsData data, Map goals) async {

    try {
      List palcareList = [];

      if (data.palcare.isEmpty) {
        palcareList.add(goals);
      } else {

        palcareList.add(goals);


        for (var i = 0; i < data.palcare.length; i++) {
          if (data.palcare[i].palcare == "akps") {
            palcareList.add(data.palcare[i]);
            break;
          }
        }

        for (var i = 0; i < data.palcare.length; i++) {
          if (data.palcare[i].palcare == "spict") {
            palcareList.add(data.palcare[i]);
            break;
          }
        }
      }



      List<Palcare> updatedPalcare = [];
      for(var a in palcareList){
        var encodeddata = jsonEncode(a);
        Palcare palcare = await Palcare.fromJson(jsonDecode(encodeddata));
        updatedPalcare.add(palcare);

      }
      

      data.palcare.clear();
      data.palcare.addAll(updatedPalcare);

      print('-patients data---${data.palcare}');
      print('-patients data---${jsonEncode(updatedPalcare)}');



      SaveDataSqflite sqflite = SaveDataSqflite();
      await  sqflite.saveData(data);

      Get.to(Step1HospitalizationScreen(patientUserId: data.sId,index: 1,statusIndex: 0,));




    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

}
