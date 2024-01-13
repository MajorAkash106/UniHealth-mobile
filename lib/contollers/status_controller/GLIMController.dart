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
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';

class GlimController extends GetxController {
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   checkConnectivity().then((value){
  //     getData();
  //   });
  //
  //   super.onInit();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  var phenotypicData = List<GLIMData>().obs;
  var phenotypicData2 = List<GLIMData>().obs;
  var etiologic = List<GLIMData>().obs;
  var severity = List<GLIMData>().obs;
  var severity2 = List<GLIMData>().obs;
  var severity3 = List<GLIMData>().obs;

  Future<String> getData() async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      // print(APIUrls.getGlim);
      // Request request = Request(url: APIUrls.getGlim, body: {
      //   // 'categoryId': id,
      // });
      //
      // // print(request.body);
      // await request.post().then((value) {
      //   GlimModel glimModel = GlimModel.fromJson(json.decode(value.body));
      //   print(glimModel.success);
      //   print(glimModel.message);
      //   Get.back();
      //   if (glimModel.success == true) {
      //     print(glimModel.data.length);
      //     phenotypicData.clear();
      //     phenotypicData2.clear();
      //     etiologic.clear();
      //     severity.clear();
      //     severity2.clear();
      //     severity3.clear();
      //
      //     for (var a = 0; a < glimModel.data.length; a++) {
      //       if (glimModel.data[a].statustype == '0') {
      //         if (glimModel.data[a].title.removeAllWhitespace ==
      //             'REDUCED MUSCLE MASS'.removeAllWhitespace) {
      //           phenotypicData2.add(glimModel.data[a]);
      //         } else {
      //           phenotypicData.add(glimModel.data[a]);
      //         }
      //       }
      //
      //       if (glimModel.data[a].statustype == '1') {
      //         etiologic.add(glimModel.data[a]);
      //       }
      //       if (glimModel.data[a].statustype == '2') {
      //         if (glimModel.data[a].title.removeAllWhitespace ==
      //             'WEIGHT LOSS (%)'.removeAllWhitespace) {
      //           severity.add(glimModel.data[a]);
      //         } else if (glimModel.data[a].title.removeAllWhitespace ==
      //             'REDUCED MUSCLE MASS'.removeAllWhitespace) {
      //           severity3.add(glimModel.data[a]);
      //         } else {
      //           severity2.add(glimModel.data[a]);
      //         }
      //       }
      //     }
      //
      //     print('phenotypic criteria: ${phenotypicData.length}');
      //     print('etiologic criteria: ${etiologic.length}');
      //   } else {
      //     ShowMsg(glimModel.message);
      //   }
      // });

      var data = await getJson(JsonFilePath.glimData);
      print('data from json file: ${json.decode(data)}');

       GlimModel glimModel = GlimModel.fromJson(json.decode(data));
      print(glimModel.success);
      print(glimModel.message);

      if (glimModel.success == true) {
        print(glimModel.data.length);
        phenotypicData.clear();
        phenotypicData2.clear();
        etiologic.clear();
        severity.clear();
        severity2.clear();
        severity3.clear();

        for (var a = 0; a < glimModel.data.length; a++) {
          if (glimModel.data[a].statustype == '0') {
            // if (glimModel.data[a].title.removeAllWhitespace == 'REDUCED MUSCLE MASS'.removeAllWhitespace) {
            //assign title key val to createdAt for all lang
            if (glimModel.data[a].createdAt.removeAllWhitespace == 'REDUCED MUSCLE MASS'.removeAllWhitespace) {
              phenotypicData2.add(glimModel.data[a]);
            } else {
              phenotypicData.add(glimModel.data[a]);
            }
          }

          if (glimModel.data[a].statustype == '1') {
            etiologic.add(glimModel.data[a]);
          }
          if (glimModel.data[a].statustype == '2') {
            // if (glimModel.data[a].title.removeAllWhitespace == 'WEIGHT LOSS (%)'.removeAllWhitespace) {
            //assign title key val to createdAt for all lang

            if (glimModel.data[a].createdAt.removeAllWhitespace == 'WEIGHT LOSS (%)'.removeAllWhitespace) {
              severity.add(glimModel.data[a]);
            // } else if (glimModel.data[a].title.removeAllWhitespace == 'REDUCED MUSCLE MASS'.removeAllWhitespace) {
              // if (glimModel.data[a].title.removeAllWhitespace == 'REDUCED MUSCLE MASS'.removeAllWhitespace) {
              //assign title key val to createdAt for all lang
            } else if (glimModel.data[a].createdAt.removeAllWhitespace == 'REDUCED MUSCLE MASS'.removeAllWhitespace) {
              severity3.add(glimModel.data[a]);
            } else {
              severity2.add(glimModel.data[a]);
            }
          }
        }

        print('phenotypic criteria: ${phenotypicData.length}');
        print('etiologic criteria: ${etiologic.length}');
      } else {
        ShowMsg(glimModel.message);
      }

    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> saveData(PatientDetailsData data, Map AllData, String type,
      Etiologic etiologic, Phenotypic phenotypic, Severity severity) async {
    Get.dialog(Loader(), barrierDismissible: false);

    Map finaldata = {
      'lastUpdate': '${DateTime.now()}',
      'etiologic': type == '1' ? AllData : etiologic,
      'severity': type == '2' ? AllData : severity,
      'phenotypic': type == '0' ? AllData : phenotypic,
    };

    // calculateResult(finaldata);

    try {
      print(APIUrls.PostStatus);

      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalDiagnosis,
        "status": nutritionalDiagnosis.glim,
        'score': '0',
        'result': jsonEncode([finaldata]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
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

  // calculateResult(Map daata){
  //   print('daata  : $daata');
  //
  //   print('pheno: ${daata['etiologic']}');
  //   print('etiologic: ${daata['etiologic']}');
  //   print('severity: ${daata['severity']}');
  //
  // }

  Future<String> saveDataPheno2(
      PatientDetailsData data,
      Map AllData,
      String type,
      Etiologic etiologic,
      Phenotypic phenotypic,
      Severity severity) async {
    Get.dialog(Loader(), barrierDismissible: false);

    Map finaldata = {
      'lastUpdate': '${DateTime.now()}',
      'etiologic': type == '1' ? AllData : etiologic,
      'severity': type == '2' ? AllData : severity,
      'phenotypic': type == '0' ? AllData : phenotypic,
    };

    // calculateResult(finaldata);

    try {
      print(APIUrls.PostStatus);

      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalDiagnosis,
        "status": nutritionalDiagnosis.glim,
        'score': '0',
        'result': jsonEncode([finaldata]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();

        // Get.back(result: '1');
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



  Future<String> saveDataOffline( PatientDetailsData data,
      Map AllData,
      String type,
      Etiologic etiologic,
      Phenotypic phenotypic,
      Severity severity) async {


    Map finaldata = {
      'lastUpdate': '${DateTime.now()}',
      'etiologic': type == '1' ? AllData : etiologic,
      'severity': type == '2' ? AllData : severity,
      'phenotypic': type == '0' ? AllData : phenotypic,
    };

    try {
      await  returnPatientDAtaFromNRS(data,0,finaldata,nutritionalDiagnosis.glim,statusType.nutritionalDiagnosis).then((resp){
        print('return patient ${jsonEncode(resp)}');
        // print('return ${jsonEncode(resp.status)}');
        // var getdata = resp.status.firstWhere((element) => element.type=='2' && element.status == 'GLIM',orElse: ()=>null);
        // print('getdata--- ${jsonEncode(getdata)}');
        // print('return ${jsonEncode(value.name)}');

        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.saveData(resp);



      });

    } catch (e) {
      // Get.back();

      print('exception occur : $e');
      ServerError();
    }

    return "success";
  }

}
