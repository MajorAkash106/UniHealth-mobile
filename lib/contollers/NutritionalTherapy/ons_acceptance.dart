import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/NutritionalTherapy/ons_acceptance_model.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;

import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../config/Locale/locale_config.dart';

class ONSAcceptanceController extends GetxController {
  final HistoryController _historyController = HistoryController();
  final NeedsController needsController = NeedsController();
  HospitalSqflite sqflite = HospitalSqflite();


  Future<String> getRouteForModeSave(PatientDetailsData data, Map dataa, String status,
      List<Needs> computeNeed)async{

    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {

      await saveData(data, dataa, status, computeNeed);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, status, computeNeed);
    }

    return 'success';
  }



  Future<String> saveData(PatientDetailsData data, Map dataa, String status,
      List<Needs> computeNeed) async {
    Get.dialog(Loader(), barrierDismissible: false);

    List<Needs> getNeedsDataTotal = [];
    if (computeNeed.isNotEmpty) {
      print('compute achievement : ${jsonEncode(computeNeed)}');

       getNeedsDataTotal = await getNeeds(computeNeed, data);

    }

    try {
      print(APIUrls.addNTResult);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //
      List<Needs> getAllNeeds = await addNeeds(data, dataa);

      final needUpdate = {
        'userId': data.sId,
        "type": NTBoxes.onsAccept,
        "status": status,
        'score': '0',
        'apptype': '1',
        'needs': jsonEncode(getNeedsDataTotal),
        'result': jsonEncode([dataa]),
      };
      final onsData = {
        'userId': data.sId,
        "type": NTBoxes.onsAccept,
        "status": status,
        'score': '0',
        'result': jsonEncode([dataa]),
        'apptype': '1',
        'needs': jsonEncode(getAllNeeds),
      };



      Request request = Request(
          url: APIUrls.addNTResult,
          body: computeNeed.isNotEmpty ? needUpdate : onsData);

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

          Get.offAll(Step1HospitalizationScreen(
              patientUserId: data.sId, index: 4, statusIndex: 0));
        } else {
          ShowMsg(commonResponse.message);
        }
      });

      await _historyController.saveMultipleMsgHistory(
          data.sId, ConstConfig.ONSAcceptanceHistory, [dataa]);
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future<String> saveDataOffline(PatientDetailsData data, Map dataa, String status,
      List<Needs> computeNeed)async{

    List<Ntdata> getData = await data.ntdata;
    List<Needs> getNeedsDataTotal = [];
    if (computeNeed.isNotEmpty) {
      print('compute achievement : ${jsonEncode(computeNeed)}');

      getNeedsDataTotal = await getNeeds(computeNeed, data);

    }


    print(status);
    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Ntdata updatedData = await Ntdata(status: status,type: NTBoxes.onsAccept,score: '0',userId: data.sId,result: [res]);

    print("updatedData::${updatedData}");

    if(getData.length!=0){
      Ntdata conditionData;
      for(var a in getData){
        if(a.type == NTBoxes.onsAccept && a.status == status){
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
    data.needs = computeNeed.isNotEmpty ? await getNeedsDataTotal : await getAllNeeds;
    print('data.needs :: ${data.needs}');


    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);
    Get.offAll(Step1HospitalizationScreen(
      patientUserId:data.sId,
      index: 4,
      statusIndex: 2,
    ));
    // return "success";

    // Get.to(Step1HospitalizationScreen(
    //     patientUserId: data.sId, index: 4, statusIndex: 0));

  }



  Future<List<Needs>>addNeeds(PatientDetailsData data, Map dataa,)async{

    print('data : ${jsonEncode(dataa)}');
    print('data : ${dataa['kcal']}');
    print('data : ${dataa['ptn']}');
    Needs addItem = Needs();
    addItem.lastUpdate =  "${DateTime.now()}";
    addItem.type =  'ons_data';
    addItem.plannedKcal = dataa['kcal']??'0';
    addItem.plannedPtn = dataa['ptn']??'0';
    addItem.achievementKcal = '0';
    addItem.achievementProtein = '0';
    List<Needs> output = await needsController.getNeedsData(data, addItem,'ons_data');

    return output;

  }


  var allData = List<Industrialized>().obs;


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

  LocaleConfig localeConfig = LocaleConfig();
  var getLocale;

  setLocale() async {
    getLocale = await localeConfig.getLocale();
  }

  Future<String> getData(String hospId) async {
    Get.dialog(Loader(), barrierDismissible: false);
   await setLocale();
    try {
      print(APIUrls.getONSDATA);
      Request request =
          Request(url: APIUrls.getONSDATA, body: {"hospitalId": hospId});

      print(request.body);
      await request.post().then((value) {
        ONSDATA model = ONSDATA.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          print(model.industrialized.length);
          print(model.manipulated.length);
          allData.clear();

          for (var a in model.industrialized) {
            if (a.isBlocked && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              allData.add(a);
            }
          }
          for (var a in model.manipulated) {
            if (a.isBlocked &&  (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              allData.add(a);
            }
          }
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

    await setLocale();
    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {

          print(wardList.offline.ntPanel.onsdata.industrialized.length);
          ONSDATA onsdata = wardList.offline.ntPanel.onsdata;
          print(onsdata.manipulated.length);
          allData.clear();

          for (var a in onsdata.industrialized) {
            if (a.isBlocked && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              allData.add(a);
            }
          }
          for (var a in onsdata.manipulated) {
            if (a.isBlocked && (a.availableIn.indexOf(getLocale.languageCode) !=-1)) {
              allData.add(a);
            }
          }

        } else {
          ShowMsg(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    // return 'success';
  }


  Future<List<Needs>> getNeeds(List<Needs> addItems, PatientDetailsData data) async{
    List<String> _timeStamps = [];
    for (var a in addItems) {
      _timeStamps.add(a.lastUpdate);
    }

    List<Needs> output = [];
    if (data.needs != null && data.needs.isNotEmpty) {
      for (var b in data.needs) {
        if (b.type == 'ons_acceptance' && _timeStamps.contains(b.lastUpdate)) {
        } else {
          output.add(b);
        }
      }
    }

    output.addAll(addItems);
return output;
  }
}
