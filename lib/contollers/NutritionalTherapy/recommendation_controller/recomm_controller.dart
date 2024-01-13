import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/oral_acceptance_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart' as r;

class RecommendationController extends GetxController {
  final HistoryController _historyController = HistoryController();
  final VigilanceController vigilanceController = VigilanceController();
  final ORALDietAcceptanceController controller = ORALDietAcceptanceController();
  final NeedsController needsController = NeedsController();

  void onSaved(PatientDetailsData data, String freeText) async {
    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "description": freeText,
    };

    print('final Data::: ${jsonEncode(finalData)}');

   await saveData(data, finalData,freeText);

  }


  Future<Ntdata> getRecommData(PatientDetailsData data) async {
    Ntdata _ntdata;

    if (!data.ntdata.isNullOrBlank) {
      _ntdata = await data.ntdata.firstWhere(
              (element) =>
          element.type == NTBoxes.otherRecommendation &&
              element.status == RECOMM_STATUS.recomm_status,
          orElse: () => null);
    }

    return _ntdata;
  }



  Future<String> saveData(PatientDetailsData data,Map dataa,String freeText) async {
    Get.dialog(Loader(), barrierDismissible: false);

    try {
      print(APIUrls.addNTResult);

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.otherRecommendation,
        "status": RECOMM_STATUS.recomm_status,
        'score': '0',
        'apptype': '1',
        'needs': jsonEncode(data.needs),
        'result': jsonEncode([dataa]),
      });

      print("saving here..");

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          Get.to(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 4,
            statusIndex: 4,
          ));



        } else {
          ShowMsg(commonResponse.message);
        }
      });

    saveHistory(data.sId, freeText, ConstConfig.other_clinical_data, data.hospital.first.sId);

    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }


  Future<String> saveHistory(
      String patientId, String data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();
    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      print('internet avialable');
      await _historyController.saveHistory(patientId, type, data);
    }
  }

  // Future<String> getRouteForModeSave(PatientDetailsData data,Map dataa,String status,Map historyData,Needs needsData)async{
  //
  //   bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);
  //
  //   if (internet != null && internet) {
  //
  //     await saveData(data, dataa, status, historyData, needsData);
  //     print('internet avialable');
  //   } else {
  //     await saveDataOffline(data, dataa, status, historyData, needsData);
  //   }
  //
  //   return 'success';
  // }

  // void saveDataOffline(PatientDetailsData data,Map dataa,Map historyData,Needs needsData)async{
  //
  //   List<Ntdata> getData = await data.ntdata;
  //
  //   var jsonData = jsonEncode(dataa);
  //   r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
  //   print("res::${res}");
  //   Ntdata updatedData = await Ntdata(status: RECOMM_STATUS.recomm_status,type: NTBoxes.otherRecommendation,score: '0',userId: data.sId,result: [res]);
  //
  //   print("updatedData::${updatedData}");
  //
  //   if(getData.length!=0){
  //     Ntdata conditionData;
  //     for(var a in getData){
  //       if(a.type == NTBoxes.otherRecommendation && a.status == RECOMM_STATUS.recomm_status){
  //         conditionData = a;
  //         break;
  //       }
  //     }
  //     getData.remove(conditionData);
  //     getData.add(updatedData);
  //   }else{
  //     getData.add(updatedData);
  //   }
  //
  //
  //
  //   print('getData :: ${getData}');
  //   data.ntdata = await getData;
  //
  //   // print('data :: ${data.ntdata[1].status}');
  //   // print('data :: ${data.ntdata[1].result.first.fasting}');
  //
  //   List<Needs>getNeedsData = data.needs;
  //
  //   print('getAllNeeds : ${getNeedsData}');
  //   // print('data.needs :: ${data.needs.length}');
  //
  //   data.needs = await getNeedsData;
  //   // print('data.needs :: ${data.needs.length}');
  //   print('data.ntdata :: ${data.ntdata}');
  //
  //
  //   final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
  //   await ShowMsg('data_updated_successfully'.tr);
  //   await sqfliteStroe.saveData(data);
  //
  //   Get.to(Step1HospitalizationScreen(
  //     patientUserId: data.sId,
  //     index: 4,
  //     statusIndex: 3,
  //   ));
  //
  // }

}
