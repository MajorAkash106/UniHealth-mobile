import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/NutritionalTherapy/ons_acceptance_model.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart' as r;
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';


class ORALDietAcceptanceController extends GetxController{

  final HistoryController _historyController = HistoryController();
  final NeedsController needsController = NeedsController();

  Future<String> saveData(PatientDetailsData data,Map dataa,String status,Map historyData,Needs needsData) async {
    Get.dialog(Loader(), barrierDismissible: false);

    List<Needs>getNeedsData = await needsController.getNeedsData(data, needsData,status);
    print("getNeedsData :: ${getNeedsData}");

    try {
      print(APIUrls.addNTResult);

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': data.sId,
        "type": NTBoxes.oralAccept,
        "status": status,
        'score': '0',
        'apptype': '1',
        'needs': jsonEncode(getNeedsData),
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
            statusIndex: 3,
          ));



        } else {
          ShowMsg(commonResponse.message);
        }
      });


      Map Hdataa = {

        'lastUpdate': '${DateTime.now()}',

        'oral_data':[historyData]


      };
      await  _historyController.saveMultipleMsgHistory(data.sId, ConstConfig.ORALAcceptanceHistory, [Hdataa]);

    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }


  Future<String> getRouteForModeSave(PatientDetailsData data,Map dataa,String status,Map historyData,Needs needsData)async{

    bool internet = await checkConnectivityWithToggle(data.hospital.first.sId);

    if (internet != null && internet) {

      await saveData(data, dataa, status, historyData, needsData);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, status, historyData, needsData);
    }

    return 'success';
  }

  void saveDataOffline(PatientDetailsData data,Map dataa,String status,Map historyData,Needs needsData)async{

    List<Ntdata> getData = await data.ntdata;

    print(status);
    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Ntdata updatedData = await Ntdata(status: status,type: NTBoxes.oralAccept,score: '0',userId: data.sId,result: [res]);

    print("updatedData::${updatedData}");

    if(getData.length!=0){
      Ntdata conditionData;
      for(var a in getData){
        if(a.type == NTBoxes.oralAccept && a.status == status){
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

    List<Needs>getNeedsData = await needsController.getNeedsData(data, needsData,status);

    print('getAllNeeds : ${getNeedsData}');
    // print('data.needs :: ${data.needs.length}');

    data.needs = await getNeedsData;
    // print('data.needs :: ${data.needs.length}');
    print('data.ntdata :: ${data.ntdata}');


    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

      Get.to(Step1HospitalizationScreen(
        patientUserId: data.sId,
        index: 4,
        statusIndex: 3,
      ));

  }




  Future<List<OralData>> getfiltered3daysData(PatientDetailsData data,OralData additem)async{
    List<OralData> output = [];
    Ntdata getData;
    await getORAL(data).then((res){
      getData = res;
    });

    if(getData!=null && getData.result.first.last3daysData != null){
 for(var a in getData.result.first.last3daysData){
   output.add(a);
 }
 print('iiiiii');
 output.add(additem);
    }else{

      print('previous oral data doesnt exist');
      output.add(additem);
    }

var filterredData = await filterlast3DaysData(output, data.hospital.first.sId, );

    return filterredData;

  }
/////////
  Future<List<OralData>> filterlast3DaysData(
      List<OralData> data, String hospId,) async {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkdayStart =
    await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
    DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().add(Duration(days: 1)));
    List<OralData> output = [];
    print("ykyyyyyy.. ${jsonEncode(data)}");
    print('www');
    if (data != null && data.isNotEmpty) {
      List<OralData> currentDay = [];
      List<OralData> lastDay = [];
      List<OralData> previousDay = [];
      for (var b in data) {
        DateTime _date = DateTime.parse(b.lastUpdate);
        if ((_date.isAfter(currentworkdayStart) &&
            _date.isBefore(currentworkdayEnd))) {
          currentDay.add(b);
        } else if ((_date.isAfter(lastworkday) &&
            _date.isBefore(currentworkdayStart) )) {
          lastDay.add(b);
        }
        else {
          previousDay.add(b);
        }
      }

      print('current : ${currentDay.length}');

      if (currentDay != null && currentDay.isNotEmpty) {
        OralData current = await updatedDateSelected(currentDay);
        output.add(current);
      }
      if (lastDay != null && lastDay.isNotEmpty) {
        OralData last = await updatedDateSelected(lastDay);
        output.add(last);
      }

      output.addAll(previousDay);

      for(int a =0; a<data.length;a++){
        DateTime _date = DateTime.parse(data[a].lastUpdate);
        output.removeWhere((element) => DateTime.parse(element.lastUpdate).isBefore(lastworkday.subtract(Duration(days: 1))));
        // if(_date.isBefore(lastworkday.subtract(Duration(days: 1))) && a.type== type){
        //   output.remove(a);
        // }
      }

    }

    return output;
  }


  Future<OralData> updatedDateSelected(List<OralData> list) async {
    // print('get all objects needs : ${list.length}');
    // print('get all objects needs 1 : ${jsonEncode(list[0])}');
    // print('get all objects needs 2 : ${jsonEncode(list[1])}');
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  ///////////






  var allData = List<Industrialized>().obs;

  Future<String> getData() async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getONSDATA);
      Request request = Request(url: APIUrls.getONSDATA, body: {});

      // print(request.body);
      await request.post().then((value) {
        ONSDATA model = ONSDATA.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          print(model.industrialized.length);
          print(model.manipulated.length);
          allData.clear();
          allData.addAll(model.industrialized);
          allData.addAll(model.manipulated);
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



}