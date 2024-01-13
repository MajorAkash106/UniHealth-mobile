import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import 'need_achievement_controller.dart';

class CustomizedController extends GetxController {
  HistoryController _historyController = HistoryController();


  Future<String> getRouteForMode(PatientDetailsData data, Map dataa, String status)async{
    await checkConnectivityWithToggle(data.hospital.first.sId).then((internet) {
      print('internet $internet');

      if (internet != null && internet) {


       saveData(data, dataa, status).then((value){
         Get.to(Step1HospitalizationScreen(patientUserId: data.sId,index: 4,statusIndex: 0,));
       });
        print('internet avialable');
      } else {
       saveDataOffline(data, dataa, status);
      }
    });
    return 'success';
  }



  Future<String> saveData(
      PatientDetailsData data, Map dataa, String status) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //
      CutomizedData customesed_data = await dataa["cutomized_data"];

      List<Needs> needs = await calulateNeedsdata(
          data,
          customesed_data.maxProtien,
          customesed_data.maxEnergy,
          customesed_data.minProtien,
          customesed_data.minEnergy,
          "condtion");
      print("jsonEncode(needs)");
      print(jsonEncode(needs));
      print(jsonEncode(needs.length));

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.condition,
        "status": status,
        'score': '0',
        // 'apptype': '1',
        // 'needs': jsonEncode(needs),
        'result': jsonEncode([dataa]),
      });

      print('request.body :: ${request.body}');
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

      await _historyController.saveMultipleMsgHistory(
          data.sId, ConstConfig.ConditionHistory, [dataa]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future<List<Needs>> calulateNeedsdata(
    PatientDetailsData data,
    String max_ptn,
    String max_kcal,
    String min_ptn,
    String min_kcal,
    String type,
  ) async {
    Needs additem = await Needs(
        plannedPtn: max_ptn,
        plannedKcal: max_kcal,
        achievementProtein: min_ptn,
        achievementKcal: min_kcal,
        type: type,
        lastUpdate: DateTime.now().toString());
    var get_needs = await get_needsData(data, additem);
    return get_needs;
  }

  Future<List<Needs>> get_needsData(
      PatientDetailsData patientDetailsData, Needs addItem) async {
    NeedsController needsController = NeedsController();

    List<Needs> output = [];
    if (patientDetailsData.needs != null &&
        patientDetailsData.needs.isNotEmpty) {
      output.addAll(patientDetailsData.needs);
    }

    output.add(addItem);

    List<Needs> getFilteredData = await needsController.removeSameOb(
        output, patientDetailsData.hospital.first.sId, addItem.type);
    print('getFiltered data : ${jsonEncode(getFilteredData)}');

    return getFilteredData;
  }

  Future<List<CutomizedData>> getPrivious(PatientDetailsData data) async {
    List<CutomizedData> output = [];

    if (data.ntdata != null && data.ntdata.isNotEmpty) {
      var getCondition = await data.ntdata.firstWhere(
          (a) =>
              a.type == NTBoxes.condition && a.status == conditionNT.customized,
          orElse: () => null);

      if (getCondition != null) {
        output = await getCondition?.result?.first?.conditionDetails;
      }
    }

    return output;
  }

  Future<List<CutomizedData>> addCondition(
      PatientDetailsData data, CutomizedData addItem) async {
    List<CutomizedData> total = [];
    total.add(addItem);

    List<CutomizedData> output = await getPrivious(data);
    if (output != null && output.isNotEmpty) {
      List<CutomizedData> filterList = await replaceSameDays(output, data);

      total.addAll(filterList);
    }

    return total;
  }

  Future<List<CutomizedData>> replaceSameDays(
      List<CutomizedData> data, PatientDetailsData pdata) async {
    EnteralNutritionalController controller = EnteralNutritionalController();

    List<String> datesList = await controller.getHospital_start_endTime(pdata);

    List<CutomizedData> output = [];
    for (var a in data) {
      if (DateTime.parse(a.lastUpdate).isAfter(DateTime.parse(datesList[0])) && DateTime.parse(a.lastUpdate).isBefore(DateTime.parse(datesList[1]))) {

      }else{
        output.add(a);
      }
    }

    return output;
  }




  void saveDataOffline(PatientDetailsData data, Map dataa, String status)async{

   List<Ntdata> getData = await data.ntdata;

   print(status);
   var jsonData = jsonEncode(dataa);
   r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
   print("res::${res}");
   Ntdata updatedData = await Ntdata(status: status,type: NTBoxes.condition,score: '0',userId: data.sId,result: [res]);

   print("updatedData::${updatedData}");

   if(getData.length!=0){
     Ntdata conditionData;
     for(var a in getData){
       if(a.type == NTBoxes.condition && a.status == status){
          conditionData = a;
         break;
       }
     }
     getData.remove(conditionData);
      getData.add(updatedData);
   }else{
      getData.add(updatedData);
   }



   print('getData :: ${getData}');
    data.ntdata = await getData;

   print('data :: ${data.ntdata.first.status}');
   final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
   await ShowMsg('data_updated_successfully'.tr);
   await sqfliteStroe.saveData(data);
      Get.to(Step1HospitalizationScreen(patientUserId: data.sId,index: 4,statusIndex: 0,));
  }

}
