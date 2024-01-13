import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';

class GI_Disfuntion_Controller extends GetxController{


  var gi_Disfunction_Data = List<AKPSData>().obs;

  Future<String> get_Disfunction_Data() async {
    try {
      var data = await getJson(JsonFilePath.gi_dispunctionData);
      print('data from json file: ${json.decode(data)}');

      AkpsDataModel akpsDataModel = AkpsDataModel.fromJson(json.decode(data));
      print(akpsDataModel.success);
      print(akpsDataModel.message);
      if (akpsDataModel.success == true) {
        print(akpsDataModel.data.length);
        gi_Disfunction_Data.clear();
        gi_Disfunction_Data.addAll(akpsDataModel.data);
        print(gi_Disfunction_Data.length);
      } else {
        ShowMsg(akpsDataModel.message);
      }
    } catch (e) {
      // Get.back();
      print('exception occur: $e');
      // ServerError();
    }
    // return 'success';
  }


}