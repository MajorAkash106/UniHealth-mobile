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
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';
import 'package:medical_app/model/spictModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class AkpsController extends GetxController {
  var akpsData = List<AKPSData>().obs;



  Future<String> getData() async {

    try {


      var data = await getJson(JsonFilePath.akpsData);
      print('data from json file: ${json.decode(data)}');
      AkpsDataModel akpsDataModel = AkpsDataModel.fromJson(json.decode(data));
      print(akpsDataModel.success);
      print(akpsDataModel.message);
      if (akpsDataModel.success == true) {
        print(akpsDataModel.data.length);
        akpsData.clear();
        akpsData.addAll(akpsDataModel.data);
        print(akpsData.length);


      } else {
        ShowMsg(akpsDataModel.message);
      }


    } catch (e) {

      print(e);
      // ServerError();
    }
    return 'success';
  }





  Future<String> saveData(PatientDetailsData data,Map akps) async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {

      List palcareList = [];
      if(data.palcare.isEmpty){
        palcareList.add(akps);
      }else {


        for(var i = 0; i<data.palcare.length;i++){
          if(data.palcare[i].palcare == "goals"){
            palcareList.add(data.palcare[i]);
            break;
          }
        }

        // for(var i = 0; i<data.palcare.length;i++){
        //   if(data.palcare[i].palcare == "akps"){
        //     palcareList.add(data.palcare[i]);
        palcareList.add(akps);
        //     break;
        //   }
        // }


        for(var i = 0; i<data.palcare.length;i++){
          if(data.palcare[i].palcare == "spict"){
            palcareList.add(data.palcare[i]);
            break;
          }
        }

      }



      print('palcare list : ${jsonEncode(palcareList)}');




      print(APIUrls.editProfile);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
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
        "apptype" : "1"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if(commonResponse.success==true){
          Get.to(Step1HospitalizationScreen(patientUserId: data.sId,index: 1,));
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        }else{
          ShowMsg(commonResponse.message);
        }


      });

    }catch(e){
      Get.back();
      ServerError();
    }

    return "success";

  }


  Future<String> saveDataOffline(PatientDetailsData data,Map akps) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    try {

      List palcareList = [];
      if(data.palcare.isEmpty){
        palcareList.add(akps);
      }else {


        for(var i = 0; i<data.palcare.length;i++){
          if(data.palcare[i].palcare == "goals"){
            palcareList.add(data.palcare[i]);
            break;
          }
        }

        palcareList.add(akps);

        for(var i = 0; i<data.palcare.length;i++){
          if(data.palcare[i].palcare == "spict"){
            palcareList.add(data.palcare[i]);
            break;
          }
        }

      }



      print('palcare list : ${jsonEncode(palcareList)}');

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




    }catch(e){
      // Get.back();
      ServerError();
    }

    return "success";

  }

}
