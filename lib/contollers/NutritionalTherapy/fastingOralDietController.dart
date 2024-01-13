import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/diet_category.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';


class FastingOralDietController extends GetxController {
  final HistoryController _historyController = HistoryController();
  final NeedsController needsController = NeedsController();
  HospitalSqflite sqflite = HospitalSqflite();


  Future<String> getRouteForModeSave(PatientDetailsData data, Map dataa, String status)async{

    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {

      await saveData(data, dataa, status);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, status);
    }

    return 'success';
  }

  Future<String> saveData(PatientDetailsData data, Map dataa, String status) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addNTResult);


      List<Needs> getAllNeeds = await addNeeds(data, dataa);
      print('getAllNeeds : ${getAllNeeds}');



      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.fastingOralDiet,
        "status": status,
        'score': '0',
        'result': jsonEncode([dataa]),
        'apptype': '1',
        'needs': jsonEncode(getAllNeeds),
      //  dsfdfds
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(value.body));
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
          data.sId, ConstConfig.FastingOralHistory, [dataa]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  void saveDataOffline(PatientDetailsData data, Map dataa, String status)async{

    List<Ntdata> getData = await data.ntdata;

    print(status);
    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Ntdata updatedData = await Ntdata(status: status,type: NTBoxes.fastingOralDiet,score: '0',userId: data.sId,result: [res]);

    print("updatedData::${updatedData}");

    if(getData.length!=0){
      Ntdata conditionData;
      for(var a in getData){
        if(a.type == NTBoxes.fastingOralDiet && a.status == status){
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

    // print('data :: ${data.ntdata[1].status}');
    // print('data :: ${data.ntdata[1].result.first.fasting}');

    List<Needs> getAllNeeds = await addNeeds(data, dataa);
    print('getAllNeeds : ${getAllNeeds}');
    data.needs = await getAllNeeds;
    print('data.needs :: ${data.needs}');


    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

  }



Future<List<Needs>>addNeeds(PatientDetailsData data, Map dataa,)async{
    //
    // print('data : ${jsonEncode(dataa)}');
    // print('data : ${dataa['kcal']}');
    // print('data : ${dataa['ptn']}');
    Needs addItem = Needs();
    addItem.lastUpdate =  "${DateTime.now()}";
    addItem.type =  'oral_fasting';

  if(dataa!=null){
    addItem.plannedKcal = dataa['kcal']??'0';
    addItem.plannedPtn = dataa['ptn']??'0';
  }else{
    addItem.plannedKcal = '0';
    addItem.plannedPtn = '0';
  }

    addItem.achievementKcal = '0';
    addItem.achievementProtein = '0';
    List<Needs> output = await needsController.getNeedsData(data, addItem,'oral_fasting');

    return output;

}





  var allData = List<DataDietCategory>().obs;


  Future<String> getRouteForMode(String hospId)async{

    bool internet = await checkConnectivityWithToggle(hospId);

    if (internet != null && internet) {

     await getData(hospId);
      print('internet avialable');
    } else {
     await getDataFromSqlite(hospId);
    }

     return 'success';
  }


  Future<String> getData(String hospId) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getDietCategory);
      Request request = Request(url: APIUrls.getDietCategory, body: {
        'hospitalId': hospId,
      });

      print(request.body);
      await request.post().then((value) {
        DietCategory model = DietCategory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          print(model.data.length);
          allData.clear();
          allData.addAll(model.data);
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }


  Future<String> getDataFromSqlite(String hospId) async {


    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {

          allData.clear();
          allData.addAll(wardList.offline.ntPanel.fastingOral);
        } else {
          ShowMsg(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    // return 'success';
  }






}
