import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';

import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/hospitalListModel.dart';

class HospitalController extends GetxController {

  var hospitalList = List<HospitalListData>().obs;

  @override
  void onInit() {
    // TODO: implement onInit

    checkConnectivity().then((internet){
      print('internet');
      if(internet!=null && internet){
        getData();
        print('internet avialable');
      }
    });
    super.onInit();
  }

  void getData() async {
    try {
      print(APIUrls.gethospitalsList);
     showLoader();
      Request request = Request(url: APIUrls.gethospitalsList, body: {});

        await request.get().then((response) {
        HospitalsListDetails hospitalsListDetails = HospitalsListDetails.fromJson(json.decode(response.body));
        //
        print(hospitalsListDetails.success);
        // // print(hospitalsListDetails.data);
        print(hospitalsListDetails.message);

        Get.back();
        hospitalList.clear();
        if (hospitalsListDetails.success == true) {
          hospitalList.addAll(hospitalsListDetails.data);
        } else {
          ShowMsg(hospitalsListDetails.message);
        }
      });
    } catch (e) {
      Get.back();
      ServerError();
    }
  }
}
