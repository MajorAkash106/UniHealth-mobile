import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/ons_acceptance_model.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart' as r;

class VigilanceController extends GetxController{

  final HistoryController _historyController = HistoryController();

  Future<String> saveDataVigilance(PatientDetailsData data,Map dataa,String status,String type) async {

    print('yhi h');
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.addVigiLance);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      //


      Request request = Request(url: APIUrls.addVigiLance, body: {
        'userId': data.sId,
        "type": type,
        "status": status,
        'score': '0',
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

      // await  _historyController.saveMultipleMsgHistory(data.sId, ConstConfig.ONSAcceptanceHistory, [dataa]);

    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }

  Future<String> saveData(PatientDetailsData data,Map dataa,String status,String type)async{
    final PatientSlipController controller = PatientSlipController();

    bool mode = await controller.getRoute(data.hospital.first.sId);
    if (mode != null && mode) {
      await saveDataVigilance(data, dataa, status, type);
      print('internet avialable');
    } else {
      await saveDataOffline(data, dataa, status, type);
    }

    return 'success';
  }

  Future<String> saveDataOffline(PatientDetailsData data,Map dataa,String status,String type)async{

    List<Vigilance> getData = await data.vigilance;

    print(status);
    var jsonData = jsonEncode(dataa);
    r.Result res = await r.Result.fromJson(jsonDecode(jsonData));
    print("res::${res}");
    Vigilance updatedData = await Vigilance(status: status,type: type,score: '0',userId: data.sId,result: [res]);

    print("updatedData::${updatedData}");

    if(getData.length!=0){
      Vigilance vigiData;
      for(var a in getData){
        if(a.type == type && a.status == status){
          vigiData = a;
          break;
        }
      }
      getData.remove(vigiData);
      getData.add(updatedData);
    }else{
      getData.add(updatedData);
    }



    print('getData :: ${getData}');
    data.vigilance = await getData;


    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

    return "success";
  }






}