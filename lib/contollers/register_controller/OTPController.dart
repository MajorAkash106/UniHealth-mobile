import 'dart:convert';
import 'package:email_validator/email_validator.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/register_controller/otp_model.dart';
import 'package:medical_app/screens/login&Sigup/registeration/create_passwordScreen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/enter_hospital.dart';
import 'package:medical_app/screens/login&Sigup/registeration/registeration_otpScreen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/subscriptionActivation_Screen.dart';
import 'package:medical_app/screens/login&Sigup/splash_screen.dart';

import '../../screens/home/home_screen.dart';

class OTPController extends GetxController {
  // final HomeConroller _homeConroller = HomeConroller();
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

  void sendOTP(String cellphone, String email) async {

    if (email.isNotEmpty) {
      if (vaildEmail.value) {
        if (cellphone.isNotEmpty) {
          var token = 'fcm_token' ;

          //   await _firebaseMessaging.getToken().then((r) {
          //   print('fcm--- $r');
          //   token = r;
          // });

          DateFormat dateFormat = DateFormat(commonDateFormat);
          String LED = await dateFormat.format(DateTime.now().add(Duration(days: 30)));
          print('LED DATE : ${LED}');

          try {
            Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
            String uuid = await MySharedPreferences.instance.getStringValue(Session.device_id);
            print(APIUrls.userRegister);
            List splitedText = email.split("@");
            print('Splited name : ${splitedText[0]}');
            Request request = Request(url: APIUrls.userRegister, body: {
              "usertype": '2',
              "licenseExpDate": LED.toString(),
              "email": email,
              "name": splitedText[0],
              "phone": cellphone,
              "type": '1',
              "countryCode": '+91',
              "deviceId": uuid,
              "deviceToken": '$token',
              "isRegFromApp": jsonEncode(true),
            });
            print(request.body);
            await request.post().then((resp) {
              SENDOTPModel model = SENDOTPModel.fromJson(jsonDecode(resp  .body));
              print(jsonEncode(model.data));

              if (model.success == true) {
                Get.back();

                Get.to(Registeration_OtpScreen(
                  otpData: model.data,
                ));
              } else {
                Get.back();
                print(model.success);
                print(model.message);

                ShowMsg(model.message);
              }
            });
          } catch (e) {
            // Get.to(LoginScreen());
            Get.back();
            print('exception occur : ${e}');
            ServerError();
          }
        } else {
          ShowMsg('Please enter your password');
        }
      } else {
        ShowMsg('Please enter a valid email');
      }
    } else {
      ShowMsg('Please enter your email');
    }
  }

   verifyOTP(OTPData otpData, String OTP) async {
    if (OTP.isNotEmpty) {
      try {
        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        print(APIUrls.otpVerification);
        Request request = Request(url: APIUrls.otpVerification, body: {
          "otpId": otpData.otpId,
          "otp": OTP,
          "email": otpData.email,
          "phone": otpData.phone,
        });

        print(request.body);
        await request.post().then((respone) {
          SENDOTPModel model = SENDOTPModel.fromJson(jsonDecode(respone.body));
          print(jsonEncode(model.data));

          if (model.success == true) {
            Get.back();

            MySharedPreferences.instance.setStringValue(Session.userid, model.data.sId);
            Get.to(CreatePassword_Screen(userId: model.data.sId,));

          } else {
            Get.back();
            print(model.success);
            print(model.message);

            ShowMsg(model.message);
          }
        });
      } catch (e) {
        // Get.to(LoginScreen());
        Get.back();
        ServerError();
      }
    } else {
      ShowMsg('Please enter OTP');
    }
  }


  createPass(String id,String password,bool isFromLogin) async {
    if (password.isNotEmpty) {
      try {
        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        print(APIUrls.createPassword);
        Request request = Request(url: APIUrls.createPassword, body: {
          "userId": id,
          "password": password,
        });
        print(request.body);
        await request.post().then((respone) {
          SENDOTPModel model = SENDOTPModel.fromJson(jsonDecode(respone.body));
          print(jsonEncode(model.data));

          if (model.success == true) {
            Get.back();


            // Get.to(EnterHospital(userId: model.data.sId,isFromLogin: isFromLogin,));
            Get.to(HomeScreen());

          } else {
            Get.back();
            print(model.success);
            print(model.message);

            ShowMsg(model.message);
          }
        });
      } catch (e) {
        // Get.to(LoginScreen());
        Get.back();
        ServerError();
      }
    } else {
      ShowMsg('Please enter OTP');
    }
  }

  @override
  void onClose() {
    super.onClose();
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
