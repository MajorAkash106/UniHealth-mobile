import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Locale/languages.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/sharedpref.dart';

class LocaleConfig extends GetxController {
  final Languages languages = Languages();

  var currentLan = ''.obs;

  Future<Locale> getLocale() async {
    String get =
        await MySharedPreferences.instance.getStringValue('languageCode');
    Locale locale = languages.locale(get == "" ? 'en' : get);
    Get.updateLocale(locale);
    return locale;
  }

  Future<void> setLocale(String languageCode) async {
    await MySharedPreferences.instance.setStringValue('languageCode', languageCode);
    Locale locale = languages.locale(languageCode);
    String currentLan = await MySharedPreferences.instance.getStringValue('languageCode');

    adLog('currentLan setup : $currentLan');

    Get.updateLocale(locale);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getLocale();
  }
}
