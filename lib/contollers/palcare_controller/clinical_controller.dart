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
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';
import 'package:medical_app/model/spictModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class ClinicalController extends GetxController {
  var clinicalData = List<AKPSData>().obs;



  Future<String> getData() async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      print(APIUrls.getAkpsData);
      Request request = Request(url: APIUrls.getAkpsData,
          body: {
            // 'categoryId': id,
          });

      // print(request.body);
      // await request.post().then((value) {
      //   AkpsModel akpsModel = AkpsModel.fromJson(json.decode(value.body));
      //   print(akpsModel.success);
      //   print(akpsModel.message);
      //   Get.back();
      //   if (akpsModel.success == true) {
      //     print(akpsModel.data.length);
      //     // akpsData.clear();
      //     // akpsData.addAll(akpsModel.data);
      //     // print(akpsData.length);
      //     var selectedData =
      //     akpsModel.data.firstWhere((element) => element.question.toUpperCase() == "clinical".toUpperCase());
      //     print("akps data : ${selectedData.sId}");
      //     getOptionData(selectedData.sId);
      //     // patientDetailsData.add(patientDetails.data);
      //   } else {
      //     ShowMsg(akpsModel.message);
      //   }
      // });

      var questionsData = List<AkpsData>().obs;
      await request.post().then((value) {
        AkpsModel akpsModel = AkpsModel.fromJson(json.decode(value.body));
        print(akpsModel.success);
        print(akpsModel.message);
        Get.back();
        if (akpsModel.success == true) {
          print(akpsModel.data.length);
          questionsData.clear();
          questionsData.addAll(akpsModel.data);
          // print(akpsData.length);

          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(akpsModel.message);
        }
      });

      var selectedData =
      questionsData.firstWhere((element) => element.question.toUpperCase() == "clinical".toUpperCase());
      print("akps data : ${selectedData.sId}");
      await  getOptionData(selectedData.sId).then((value){
        print('return value from goal data : $value');
      });

    } catch (e) {
      Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }


  Future<String> getOptionData(String id) async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      print(APIUrls.getOption);
      Request request = Request(url: APIUrls.getOption,
          body: {
            'questionId': id,
          });

      // print(request.body);
      await request.post().then((value) {
        AkpsDataModel akpsDataModel = AkpsDataModel.fromJson(json.decode(value.body));
        print(akpsDataModel.success);
        print(akpsDataModel.message);
        Get.back();
        if (akpsDataModel.success == true) {
          print(akpsDataModel.data.length);
          clinicalData.clear();
          clinicalData.addAll(akpsDataModel.data);
          print(clinicalData.length);



        } else {
          ShowMsg(akpsDataModel.message);
        }
      });
    } catch (e) {
      Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }


  Future<String> saveData(PatientDetailsData data,Map spict) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
    // try {



    List palcareList = [];
    if(data.palcare.isEmpty){
      palcareList.add(spict);
    }else {


      for(var i = 0; i<data.palcare.length;i++){
        if(data.palcare[i].palcare == "goals"){
          palcareList.add(data.palcare[i]);
          break;
        }
      }

      for(var i = 0; i<data.palcare.length;i++){
        if(data.palcare[i].palcare == "akps"){
          palcareList.add(data.palcare[i]);

          break;
        }
      }


      palcareList.add(spict);
      // for(var i = 0; i<data.palcare.length;i++){
      //   if(data.palcare[i].palcare == "spict"){
      //     palcareList.add(data.palcare[i]);
      //     break;
      //   }
      // }

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

    // }catch(e){
    //   Get.back();
    //   ServerError();
    // }

    return "success";

  }

}
