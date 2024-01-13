import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';

Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    Get.snackbar(
      "Connection Failed !",
      'Please check internet connection !',
      snackPosition: SnackPosition.TOP,
      colorText: redTxt_color,
      backgroundColor: Colors.white,
    );
    print('no internet');

    //   Get.snackbar(null,'${text??"something went wrong"}',colorText: Colors.white,backgroundColor: Colors.black,
    //       snackPosition: SnackPosition.BOTTOM);
    //   // Get.snackbar(null,null,colorText: Colors.white,backgroundColor: Colors.black,
    //   //     // padding: EdgeInsets.only(bottom: 10),
    //   //     messageText: Text('${text??"something went wrong"}',style: TextStyle(color: Colors.white),),
    //   //     snackPosition: SnackPosition.BOTTOM);
    // }

    return false;
  }
}

Future<bool> checkConnectivityWihtoutMsg() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    // Get.snackbar("Connection Failed !",'Please check internet connection !',snackPosition: SnackPosition.TOP,colorText: redTxt_color,backgroundColor: Colors.white,);
    print('no internet');

    //   Get.snackbar(null,'${text??"something went wrong"}',colorText: Colors.white,backgroundColor: Colors.black,
    //       snackPosition: SnackPosition.BOTTOM);
    //   // Get.snackbar(null,null,colorText: Colors.white,backgroundColor: Colors.black,
    //   //     // padding: EdgeInsets.only(bottom: 10),
    //   //     messageText: Text('${text??"something went wrong"}',style: TextStyle(color: Colors.white),),
    //   //     snackPosition: SnackPosition.BOTTOM);
    // }

    return false;
  }
}

Future<bool> checkConnectivityWithToggle(String hospId) async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  bool isToggle = false;
  await isOfflineOnlineJourney(hospId).then((val) {
    print('val -  ${val}');
    isToggle = val ?? false;
    print('toggle: ${isToggle}');
  });

  if (isToggle) {
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      print('no internet');

      return false;
    }
  } else {
    return false;
  }
}

Future<String> getHospitalIdfrom(String patientId) async {
  final OfflineHandler _offlineHandler = OfflineHandler();
  String hospId;
  await _offlineHandler.getPatientData(patientId).then((value) {
    if (value != null) {
      hospId = value.hospital[0].sId;
    }
  });

  return hospId;
}
