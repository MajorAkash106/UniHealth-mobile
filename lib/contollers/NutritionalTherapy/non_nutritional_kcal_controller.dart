import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_model.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class NonNutritionalKcal extends GetxController {


  Future<NonNutritional>getNonNutritionalData(PatientDetailsData pData)async{
    NonNutritional data;

    if (!pData.ntdata.isNullOrBlank) {
      Ntdata getNtData = await pData.ntdata.firstWhere(
              (element) =>
          element.type == NTBoxes.nonNutritional && element.status == 'non_nutritional_kcal',
          orElse: () => null);
      if(getNtData!=null){
        data = getNtData.result.first.nonNutritional;
      }

    }

    return data;

  }



  Future<Map>getData(String propofol,String glucose,String citrate,String total)async{
    Map data = {
      "non_nutritional" :  {
        "propofol": propofol,
        "glucose": glucose,
        "citrate": citrate,
        "total": total,
        "lastUpdate": '${DateTime.now()}',
      }
    };

    return data;
  }


  Future<String> saveNonNutritionalKcal(PatientDetailsData pData, String propofol,String glucose,String citrate,String total) async {
    // Get.dialog(Loader(), barrierDismissible: false);

    Map finalData = await getData(propofol, glucose, citrate, total);

    try {
      print(APIUrls.addNTResult);

      Request request = Request(url: APIUrls.addNTResult, body: {
        'userId': pData.sId,
        "type": NTBoxes.nonNutritional,
        "status": 'non_nutritional_kcal',
        'score': '0',
        'result': jsonEncode([finalData]),


      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse = CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        // Get.back();
        // if (commonResponse.success == true) {
        // } else {
        //   ShowMsg(commonResponse.message);
        // }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }

    return "success";
  }
}
