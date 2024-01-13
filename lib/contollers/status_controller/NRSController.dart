import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';


class NRSController extends GetxController {
  var checkBoxData = List<NRSListData>().obs;
  var radioData = List<NRSListData>().obs;
  var allData = List<NRSListData>().obs;

  Future<String> getData(String id) async {
    try {
      var data = await getJson(id);
      print('data from json file: ${json.decode(data)}');
      NRSModel model = NRSModel.fromJson(json.decode(data));
      print(model.success);
      print(model.message);
      if (model.success == true) {
        radioData.clear();
        print(model.data);
        for (var a = 0; a < model.data.length; a++) {
          if (model.data[a].type == '0') {
            radioData.add(model.data[a]);
          }
        }
      } else {
        ShowMsg(model.message);
      }
    } catch (e) {
      ServerError();
    }

    return 'success';
  }

  Future<String> getDataPart2(String id) async {
    try {
      var data = await getJson(id);
      print('data from json file: ${json.decode(data)}');

      NRSModel model = NRSModel.fromJson(json.decode(data));
      print(model.success);
      print(model.message);
      // Get.back();
      if (model.success == true) {
        checkBoxData.clear();
        print(model.data);
        for (var a = 0; a < model.data.length; a++) {
          if (model.data[a].type == '1') {
            checkBoxData.insert(0, model.data[a]);
          }
        }
      } else {
        ShowMsg(model.message);
      }
    } catch (e) {
      ServerError();
    }

    return 'success';
  }

  Future<String> saveData(
      PatientDetailsData data,
      List<NRSListData> selectedList,
      int score,
      Map dataa,
      String status) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.PostStatus);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //

      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalScreening,
        "status": status,
        'score': score.toString(),
        'result': jsonEncode([dataa]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          // afterSaved(score,data);
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



  Future<String> saveDataOffline(
      PatientDetailsData data,
      List<NRSListData> selectedList,
      int score,
      Map dataa,
      String status) async {

    try {

      await  returnPatientDAtaFromNRS(data,score,dataa,status,statusType.nutritionalScreening).then((value){
        print('return patient ${jsonEncode(value)}');
        // print('return ${jsonEncode(value.status)}');
        // print('return ${jsonEncode(value.name)}');

        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.saveData(value);
        Get.to(Step1HospitalizationScreen(
          patientUserId: value.sId,
          index: 2,
        ));

      });

    } catch (e) {
      // Get.back();

      print('exception occur : $e');
      ServerError();
    }

    return "success";
  }



  void afterSaved(int score, PatientDetailsData data, context) async {
    if (score < 3) {
      print('show calender and schduledate');

      DateTime date = DateTime.now();
      var after7days = date.add(Duration(days: 7));
      print(after7days);
      // await  schduleNext(data, context,after7days);

      // await schduleNextFunc(data, context,after7days,(){}).then((value){
      //   print('return date: $value');
      // });

    } else {
      Get.to(Step1HospitalizationScreen(
        patientUserId: data.sId,
        index: 2,
      ));
    }
  }
}
