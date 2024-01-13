import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/Log_out_model.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/Locale/languages.dart';

class Log_out_controller extends GetxController {
  final LocaleConfig localeConfig = LocaleConfig();

  void logout() {
    Get.dialog(
      new AlertDialog(
        title: new Text('are_you_sure'.tr),
        content: new Text('do_you_want_to_logout'.tr),
        actions: <Widget>[
          new ElevatedButton(
            onPressed: () => Get.back(),
            child: new Text('no'.tr),
          ),
          new ElevatedButton(
            onPressed: () => logOut(),
            child: new Text('yes'.tr),
          ),
        ],
      ),
    );
  }

  void logOut() async {
    print(APIUrls.logout);
    Request request = Request(url: APIUrls.logout, body: {
      "userId":
          await MySharedPreferences.instance.getStringValue(Session.userid)
    });
    request.post().then((response) {
      adLog('response:: $response');
    });

    clearAllAndGotoLogin();
  }

  void clearAllAndGotoLogin() async {
    String currentLan =
        await MySharedPreferences.instance.getStringValue('languageCode');
    await MySharedPreferences.instance.removeAll();
    adLog('saving currentLan : $currentLan');
    if (currentLan != 'en') {
      localeConfig.setLocale(Languages.PORTUGUESE);
    } else {
      localeConfig.setLocale(Languages.ENGLISH);
    }
    Get.offAll(LoginScreen());
    ShowMsg('user_logout_successfully'.tr);
  }
}
