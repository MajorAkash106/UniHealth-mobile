import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';





class WHOController extends GetxController{

  Future<String> saveData(
      PatientDetailsData data, Map AllData,) async {
    Get.dialog(Loader(), barrierDismissible: false);





    try {
      print(APIUrls.PostStatus);

      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalDiagnosis,
        "status": nutritionalDiagnosis.who,
        'score': '0',
        'result': jsonEncode([AllData]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back(result: '1');
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
      Map dataa) async {

    try {

      await  returnPatientDAtaFromNRS(data,0,dataa,nutritionalDiagnosis.who,statusType.nutritionalDiagnosis).then((value){
        print('return patient ${jsonEncode(value)}');
        // print('return ${jsonEncode(value.status)}');
        // print('return ${jsonEncode(value.name)}');

        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.saveData(value);
        // Get.to(Step1HospitalizationScreen(
        //   patientUserId: value.sId,
        //   index: 2,
        // ));

      });

    } catch (e) {
      // Get.back();

      print('exception occur : $e');
      ServerError();
    }

    return "success";
  }

}