import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';

import '../contollers/navigation_service.dart';

Future<dynamic> ShowMsg(String text) async {
  Get.snackbar('notification_'.tr, '${text ?? "something went wrong"}',
      colorText: Colors.white,
      backgroundColor: Colors.black,
      snackPosition: SnackPosition.BOTTOM);

  // ScaffoldMessenger.of(NavigationService.appNav.currentContext).showSnackBar(SnackBar(
  //   content: Text(text),
  // ),);
}

Future<dynamic> ShowMsgFor10sec(String text) async {
  Get.snackbar('notification_'.tr, '${text ?? "something went wrong"}',
      colorText: Colors.white,
      backgroundColor: Colors.black,
      duration: Duration(seconds: 10),
      snackPosition: SnackPosition.BOTTOM);

  // ScaffoldMessenger.of(NavigationService.appNav.currentContext).showSnackBar(SnackBar(
  //   duration: Duration(seconds: 10),
  //   content: Text(text),
  // ));
}

Future<dynamic> ServerError() async {
  Get.snackbar('Server Error !', 'Some error occur on server side !',
      snackPosition: SnackPosition.TOP,
      colorText: redTxt_color,
      backgroundColor: Colors.white);
}
