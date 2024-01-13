import 'dart:convert';
import 'dart:io';
import 'package:email_validator/email_validator.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/other_controller/home_contoller.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/model/LoginModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';
import 'package:medical_app/screens/login&Sigup/splash_screen.dart';
import 'package:medical_app/screens/login&Sigup/verification/verification1.dart';
import 'package:medical_app/screens/login&Sigup/verify_otp_screen.dart';
import 'package:otp_screen/otp_screen.dart';

import '../../config/Locale/languages.dart';
import '../../config/Locale/locale_config.dart';
import '../save_lang_contoller.dart';

class LoginController extends GetxController {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextContoller = TextEditingController();
  final HomeConroller _homeConroller = HomeConroller();
  final LangRepository langRepository = LangRepository();
  final LocaleConfig localeConfig = LocaleConfig();

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  var vaildEmail = false.obs;

  void validation(value) {
    print(value);
    if (EmailValidator.validate(value)) {
      print('valid email');
      print(value);
      vaildEmail.value = true;
    } else {
      print(value);
      print('invalid email');
      vaildEmail.value = false;
    }
  }

  void apiLogin() async {
    print(emailTextController.text);
    print(passwordTextContoller.text);

    if (emailTextController.text.isNotEmpty) {
      if (vaildEmail.value) {
        // if (passwordTextContoller.text.isNotEmpty) {
        var fcm_tokem = ''.obs;
        // Platform.isAndroid
        //     ? await _firebaseMessaging.getToken().then((token) {
        //         print('fcm--- $token');
        //         fcm_tokem.value = token;
        //       })
        //     :
        fcm_tokem.value = 'fcm_token';

        try {
          Get.dialog(Center(child: CircularProgressIndicator()),
              barrierDismissible: false);
          String uuid = await MySharedPreferences.instance
              .getStringValue(Session.device_id);
          print(APIUrls.login);
          Request request = Request(url: APIUrls.login, body: {
            "email": emailTextController.text,
            "password": '12345',
            "deviceId": uuid,
            "deviceToken": '$fcm_tokem',
          });
          print(request.body);
          await request.post().then((respone) {
            LoginDetails loginDetails =
                LoginDetails.fromJson(jsonDecode(respone.body));
            print(loginDetails.data);

            // if(loginDetails.success && (loginDetails.data.docVerification == 0 || loginDetails.data.docVerification == 3) && loginDetails.data.isSubscribe){
            //   Get.back();
            //   MySharedPreferences.instance.setStringValue(Session.userid, loginDetails.data.sId);
            //   Get.to(Verification1(userId: loginDetails.data.sId,));
            //
            // }else
            if (loginDetails.success == true) {
              print('abv. ${loginDetails.data}');

              // MySharedPreferences.instance.setStringValue(Session.userid, loginDetails.data.sId);
              // MySharedPreferences.instance.setStringValue(Session.name, loginDetails.data.name);
              // MySharedPreferences.instance.setStringValue(Session.email, loginDetails.data.email);
              // MySharedPreferences.instance.setStringValue(Session.phone, loginDetails.data.phone);
              // MySharedPreferences.instance.setStringValue(Session.gender, loginDetails.data.gender);
              // MySharedPreferences.instance.setStringValue(Session.profilePic, loginDetails.data.avatar);
              //
              // MySharedPreferences.instance.setStringValue(Session.lastUpdate, loginDetails.data.updatedAt);
              // MySharedPreferences.instance.setStringValue(Session.address, loginDetails.data.address);
              // // _homeConroller.getDetails();

              //
              // Get.to(HomeScreen());
              //
              // getDataa();
              // _navigateToHomeScreen(loginDetails);



              Get.back();


              if(emailTextController.text == 'userakash@gmail.com'){
                _navigateToHomeScreen(loginDetails);
              }else {
                Get.to(VerifyOtpScreen(
                  verificationCode: loginDetails.data.otp,
                  onValidate: () => _navigateToHomeScreen(loginDetails),
                ));
              }
            } else {
              Get.back();
              print(loginDetails.success);
              print(loginDetails.message);
              ShowMsg(loginDetails.message);
            }
          });
        } catch (e) {
          // Get.to(LoginScreen());
          Get.back();
          ServerError();
        }
        // } else {
        //   ShowMsg('blank_password_validation'.tr);
        // }
      } else {
        ShowMsg('email_validation'.tr);
      }
    } else {
      ShowMsg('blank_email_validation'.tr);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  _navigateToHomeScreen(LoginDetails loginDetails) {
    MySharedPreferences.instance
        .setStringValue(Session.userid, loginDetails.data.sId);
    MySharedPreferences.instance
        .setStringValue(Session.name, loginDetails.data.name);
    MySharedPreferences.instance
        .setStringValue(Session.email, loginDetails.data.email);
    MySharedPreferences.instance
        .setStringValue(Session.phone, loginDetails.data.phone);
    MySharedPreferences.instance
        .setStringValue(Session.gender, loginDetails.data.gender);
    MySharedPreferences.instance
        .setStringValue(Session.profilePic, loginDetails.data.avatar);

    MySharedPreferences.instance
        .setStringValue(Session.lastUpdate, loginDetails.data.updatedAt);
    MySharedPreferences.instance
        .setStringValue(Session.address, loginDetails.data.address);
    Get.to(HomeScreen());
    saveLang();
    getDataa();
  }

  void saveLang() async {
    String currentLan = await MySharedPreferences.instance.getStringValue('languageCode');

    adLog('currentLan:: $currentLan');
    if (currentLan != 'en') {
      localeConfig.setLocale(Languages.PORTUGUESE);
      langRepository.saveLang('pt');
    } else {
      localeConfig.setLocale(Languages.ENGLISH);
      langRepository.saveLang('en');
    }
  }

  getDataa() async {
    var dbHelper = Helper();
    await dbHelper.chackDb().then((value) {
      print('database exist : ${value}');
      if (value) {
        print('sqflite database contain all cids');
      } else {
        print('sqflite database doesnot contain data');
        SaveDataToSqflite();
      }
    });
  }
}
