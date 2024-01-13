import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/EditProfileModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/schduleDataModel.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class SchduleConroller extends GetxController {

  var schduleListdata = List<SchduleDataDetails>().obs;

  void getData(String patientId) async {
    print(APIUrls.getSchduleData);
    showLoader();

    try {
      Request request = Request(url: APIUrls.getSchduleData, body: {
        'userId': patientId,
      });

      print(request.body);
      await request.post().then((value) {
        SchduleData schduleData =
        SchduleData.fromJson(json.decode(value.body));

          print(schduleData.data);
        Get.back();
        if (schduleData.success == true) {
          schduleListdata.clear();
          // Get.back();
          // ShowMsg(settingdetails.message);
          schduleListdata.addAll(schduleData.data);

          for(var i=0;i<schduleListdata.length;i++){
            schduleListdata[i].options[0].subtitleTc.text = schduleListdata[i].options[0].subtitle;
            schduleListdata[i].options[0].titleTc.text = schduleListdata[i].options[0].title;
          }



        } else {
          ShowMsg(schduleData.message);
        }
      });
    } catch (e) {
      Get.back();
      print('eception: $e');
      ServerError();
    }
  }


  void updateData(SchduleDataDetails dataDetails) async {
    print(APIUrls.updateSchduleData);
    // showLoader();

    try {
      Request request = Request(url: APIUrls.updateSchduleData, body: {
        'scheduleoptionId': dataDetails.options[0].sId,
        'title': dataDetails.options[0].title,
        'subtitle': dataDetails.options[0].subtitle,
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        // Get.back();
        if (commonResponse.success == true) {

          ShowMsg(commonResponse.message);


        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      // Get.back();
      print('eception: $e');
      ServerError();
    }
  }


  var patientDetailsData = List<PatientDetailsData>().obs;
  Future<String> getPatientDetails(String id) async {
    // Get.dialog(Loader(),
    //     barrierDismissible: false);
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
        if(patientDetails.success==true){
          patientDetailsData.clear();
          print(patientDetails.data);
          patientDetailsData.add(patientDetails.data);
        }else{
          ShowMsg(patientDetails.message);
        }


      });

    }catch(e){
      ServerError();
    }
    return 'success';
  }


}
