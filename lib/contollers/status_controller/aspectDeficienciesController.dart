import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/clinicalAspectModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';


class AspectDeficienciesController extends GetxController {





  Future<String> saveData(PatientDetailsData data, int score,String status,Map dataa) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.PostStatus);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.aspectDeficiencies,
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
          Get.to(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 2,statusIndex: 1,
          ));
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



  var historyData = List<AspectClinicalHistoryData>().obs;
  Future<String> getHistoryData(String patientId,String type) async {
    var userid =
    await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type":type,
        'loggedUserId': userid,

      });
      print(request.body);
      await request.post().then((value) {
        ClinicalAspectHistory model =
        ClinicalAspectHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if(model.success==true){
          historyData.clear();
          print(model.data);
          historyData.addAll(model.data.reversed);

          historyData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });

        }else{
          ShowMsg(model.message);
        }


      });

    }catch(e){
      print(e);
      ServerError();
    }
    return 'success';
  }


  Future<String> saveDataOffline(
      PatientDetailsData data,
      List<NRSListData> selectedList,
      int score,
      Map dataa,
      String status) async {

    try {

      await  returnPatientDAtaFromNRS(data,score,dataa,status,statusType.aspectDeficiencies).then((value){
        print('return patient ${jsonEncode(value)}');


        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.saveData(value);
        Get.to(Step1HospitalizationScreen(
          patientUserId: value.sId,
          index: 2,statusIndex: 1,
        ));

      });

    } catch (e) {
      // Get.back();

      print('exception occur : $e');
      ServerError();
    }

    return "success";
  }

}
