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
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';

import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/hospitalListModel.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';

class HospitalController2 extends GetxController {
  HospitalSqflite _hospitalSqflite = HospitalSqflite();

  var hospitalList = List<HospitalListData>().obs;

  void getData() async {
    try {
      print(APIUrls.gethospitalsList);
      showLoader();
      Request request = Request(url: APIUrls.gethospitalsList, body: {});

      await request.get().then((response) {
        HospitalsListDetails hospitalsListDetails =
            HospitalsListDetails.fromJson(json.decode(response.body));
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

  Future<String> getHospitalData() async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getUserdetails);
      Request request = Request(url: APIUrls.getUserdetails, body: {
        'userId': userid,
      });

      await request.post().then((value) {
        Settingdetails settingdetails =
            Settingdetails.fromJson(json.decode(value.body));
        print(settingdetails.success);
        print(settingdetails.message);
        // Get.back();
        if (settingdetails.success == true) {
          // getMedicalData(settingdetails.data.hospital);
          getHospitalDetails(settingdetails.data.hospital);
        } else {
          ShowMsg(settingdetails.message);
          Future.delayed(const Duration(seconds: 2), () {
            // logout here
            MySharedPreferences.instance.removeAll();
            print(
                'name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
            Get.to(LoginScreen());
          });
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

  void getHospitalDetails(List<Hospital> _list) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getHospitaldetails);
      Request request = Request(url: APIUrls.getHospitaldetails, body: {
        'hospitalId': jsonEncode(_list),
      });

      print('request:  ${request.body}');
      print('jsonEncode:  ${jsonEncode(_list)}');

      await request.post().then((value) {
        HospitalsListDetails hospitalDetails =
            HospitalsListDetails.fromJson(json.decode(value.body));

        //save in sqflite data
        _hospitalSqflite.saveHospitals(hospitalDetails);

        print(hospitalDetails.success);
        print(hospitalDetails.message);
        Get.back();
        if (hospitalDetails.success == true) {
          hospitalList.clear();
          print("hospital Details data length: ${hospitalDetails.data.length}");

          hospitalList.addAll(hospitalDetails.data);
          //
          // getMedicalData(hospitalDetails.data.hospital);
        } else {
          ShowMsg(hospitalDetails.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  Future<String> getHospitalDataWithoutLoader() async {
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getUserdetails);
      Request request = Request(url: APIUrls.getUserdetails, body: {
        'userId': userid,
      });

      await request.post().then((value) {
        Settingdetails settingdetails =
            Settingdetails.fromJson(json.decode(value.body));
        print(settingdetails.success);
        print(settingdetails.message);
        // Get.back();
        if (settingdetails.success == true) {
          // getMedicalData(settingdetails.data.hospital);
          getHospitalDetailsWithoutLoader(settingdetails.data.hospital);
        } else {
          ShowMsg(settingdetails.message);
          Future.delayed(const Duration(seconds: 2), () {
            // logout here
            MySharedPreferences.instance.removeAll();
            print(
                'name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
            Get.to(LoginScreen());
          });
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

  void getHospitalDetailsWithoutLoader(List<Hospital> _list) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getHospitaldetails);
      Request request = Request(url: APIUrls.getHospitaldetails, body: {
        'hospitalId': jsonEncode(_list),
      });

      print('request:  ${request.body}');
      print('jsonEncode:  ${jsonEncode(_list)}');

      await request.post().then((value) {
        HospitalsListDetails hospitalDetails =
            HospitalsListDetails.fromJson(json.decode(value.body));

        //save in sqflite data
        _hospitalSqflite.saveHospitals(hospitalDetails);

        print(hospitalDetails.success);
        print(hospitalDetails.message);
        if (hospitalDetails.success == true) {
          hospitalList.clear();
          print("hospital Details data length: ${hospitalDetails.data.length}");

          hospitalList.addAll(hospitalDetails.data);
          //
          // getMedicalData(hospitalDetails.data.hospital);
        } else {
          ShowMsg(hospitalDetails.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  Future<String> getFromSqflite() {
    _hospitalSqflite.getHospitals().then((res) {
      if (res != null) {
        HospitalsListDetails hospitalDetails = res;
        print(hospitalDetails.success);
        print(hospitalDetails.message);
        if (hospitalDetails.success == true) {
          hospitalList.clear();
          print("hospital Details data length: ${hospitalDetails.data.length}");

          hospitalList.addAll(hospitalDetails.data);
          //
          // getMedicalData(hospitalDetails.data.hospital);
        } else {
          ShowMsg(hospitalDetails.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
  }

  Future<bool> isExpiredSubscription(String hospId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);
    SaveDataSqflite dataSqflite = SaveDataSqflite();
    bool output = true;
    await dataSqflite.getUserDetails(userid).then((res) {
      if (!res.isNullOrBlank &&
          !res.data.isNullOrBlank &&
          !res.data.attributionInfo.isNullOrBlank) {
        var data = res.data.attributionInfo.firstWhere(
            (element) => element.hospital[0].sId == hospId,
            orElse: () => null);
        if (data != null) {
          output = false;
        }
      }
    });
    return output;
  }

  Future<int> isDocVerfied() async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    SaveDataSqflite dataSqflite = SaveDataSqflite();
    int output = 0;
    await dataSqflite.getUserDetails(userid).then((v) {
      // print('v.data.isdocVerifed : ${v.data.isdocVerifed}');
      // print('v.data.isdocStatus : ${v.data.isdocStatus}');
      if (v != null) {
        output = v.data.docVerification;
      }
    });
    return output;
  }

  Future<int> employeddVerification(String hospId) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    SaveDataSqflite dataSqflite = SaveDataSqflite();
    int output = 0;
    await dataSqflite.getUserDetails(userid).then((v) {
      // print('v.data.isdocVerifed : ${v.data.isdocVerifed}');
      // print('v.data.isdocStatus : ${v.data.isdocStatus}');
      if (v != null && v.data.hospital.isNotEmpty) {
        // output = v.data.docVerification;
        var data = v.data.hospital.firstWhere((element) => element.sId == hospId,orElse: ()=>null);

      if(data!=null){
        output = data.verificationStatus;
        print('verification status : ${data.verificationStatus}');
      }

      }
    });
    return output;
  }

}
