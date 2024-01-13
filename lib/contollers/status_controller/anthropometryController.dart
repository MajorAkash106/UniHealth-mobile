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
import 'package:medical_app/contollers/AnthropometryQuestionModel.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/AnthroHistoryModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';
import 'package:medical_app/model/spictModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class AnthropometryController extends GetxController {
  var edema = List<QuestionsData>().obs;
  var ascites = List<QuestionsData>().obs;


  Future<String> getDataEdema() async {
    try {

      var data = await getJson(JsonFilePath.edemaData);
      print('data from json file: ${json.decode(data)}');
      QuestionForCalculate model = QuestionForCalculate.fromJson(json.decode(data));
      print(model.success);
      print(model.message);
      // Get.back();
      if (model.success == true) {
        print(model.data.length);
        edema.clear();
        edema.addAll(model.data);
        print(edema.length);



      } else {
        ShowMsg(model.message);
      }


    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> getDataAscities() async {
    try {

      var data = await getJson(JsonFilePath.ascitesData);
      print('data from json file: ${json.decode(data)}');

      QuestionForCalculate model = QuestionForCalculate.fromJson(json.decode(data));
      print(model.success);
      print(model.message);

      if (model.success == true) {
        print(model.data.length);
        ascites.clear();
        ascites.addAll(model.data);
        print(ascites.length);

      } else {
        ShowMsg(model.message);
      }

    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> saveData(PatientDetailsData data,List anthro) async {
    showLoader();
    try{
      print(APIUrls.editProfile);
      Request request = Request(url: APIUrls.editProfile, body: {
        'city': data.city,
        'state': data.state,
        'userId': data.sId,
        'anthropometry': jsonEncode(anthro),
        "apptype": "3"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          // Get.to(
          //     Step1HospitalizationScreen(patientUserId: data.sId, index: 2,));
        } else {
          ShowMsg(commonResponse.message);
        }
      });

    }catch(e){
      Get.back();
      ServerError();
    }

    return "success";

  }


  var getHistoryData = List<AnthroHistoryData>().obs;

  void getHistory(String patientId,String type) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    print(APIUrls.getHistory);
    showLoader();

    try {
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        'type': type,
        'loggedUserId': userid,

      });

      print(request.body);
      await request.post().then((value) {
        AnthroHistoryModel msgHistory =
        AnthroHistoryModel.fromJson(json.decode(value.body));

        print(msgHistory.message);
        print(msgHistory.success);
        Get.back();
        if (msgHistory.success == true) {
          getHistoryData.clear();
          getHistoryData.addAll(msgHistory.data.reversed);

          getHistoryData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(msgHistory.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }


}
