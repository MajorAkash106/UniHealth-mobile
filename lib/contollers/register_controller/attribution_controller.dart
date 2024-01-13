import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/register_controller/requestModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/register_controller/attribution_model.dart';
import 'package:medical_app/model/register_controller/otp_model.dart';
import 'package:medical_app/screens/login&Sigup/registeration/Identity_verificationScreen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/subscriptionActivation_Screen.dart';

class AttributionController extends GetxController {
  List<AttributionData> attributionData = <AttributionData>[].obs;

  Future<String> getAttribution(String hospId) async {
    try {
      // Get.dialog(Center(child: CircularProgressIndicator()),
      //     barrierDismissible: false);

      final body = {'hospitalId': hospId};
      final userType = {
        "usertype": '0',
      };

      print(APIUrls.getAttribution);
      Request request = Request(
          url: APIUrls.getAttribution, body: hospId != null ? body : userType);
      print(request.body);
      await request.post().then((respone) {
        AttributionModel model =
            AttributionModel.fromJson(jsonDecode(respone.body));
        print(jsonEncode(model.data));

        if (model.success == true) {
          // Get.back();
          attributionData.clear();
          attributionData.addAll(model.data);
          print('attribution data : ${model.data.length}');
        } else {
          // Get.back();
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

    return "suceess";
  }

  Future<String> saveAttributeAndPaymentDetails(
      String userId,
      AttributionData badge,
      Map paymentDetails,
      Map hosp,
      bool isFromLogin) async {
    try {
      await MySharedPreferences.instance.removeValue('testt');
      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);
      print(APIUrls.addRequest);
      print('badge id here : ${badge.sId}');

      final bodyWithHosp = {
        "userId": userId,
        "attributionId": badge.sId,
        "badges": jsonEncode([badge]),
        "payments": jsonEncode([paymentDetails]),
        "hospital": jsonEncode([hosp]),
        // "assignHospital": jsonEncode(false),
      };
      // final bodyWithoutHosp = {
      //   "userId": userId,
      //   "attributionId": badge.sId,
      //   "badges": jsonEncode([badge]),
      //   "payments": jsonEncode([paymentDetails]),
      //   "hospital": "",
      //   "usertype": '1',
      //   "assignHospital": jsonEncode(true),
      // };

      Request request = Request(url: APIUrls.addRequest, body: bodyWithHosp);

      print(request.body);
      await request.post().then((respone) {
        RequestModel model = RequestModel.fromJson(jsonDecode(respone.body));
        print(model.success);
        print(model.message);
        print(jsonEncode(model.data));

        if (model.success == true) {
          Get.back();

          Get.to(Identity_VerificationScreen(
            userId: userId,
            hospId: hosp['_id'],
            isFromLogin: isFromLogin,
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
      print('exception occur : ${e}');
      Get.back();
      // ServerError();
    }

    return "suceess";
  }


  Future<String> saveAttributeAndPaymentDetailsWihoutHosp(
      String userId,
      AttributionData badge,
      Map paymentDetails,
      bool isFromLogin) async {
    try {
      await MySharedPreferences.instance.removeValue('testt');
      // Get.dialog(Center(child: CircularProgressIndicator()),
      //     barrierDismissible: false);
      print(APIUrls.assignHosp);
      print('badge id here : ${badge.sId}');
      print('payments list here : ${jsonEncode([paymentDetails])}');
      print('badges list here : ${jsonEncode([badge])}');

      final bodyWithoutHosp = {
        "userId": userId,
        "attributionId": badge.sId,
        "badges": jsonEncode([badge]),
        "payments": jsonEncode([paymentDetails]),
      };

      Request request = Request(url: APIUrls.assignHosp, body: bodyWithoutHosp);

      print(request.body);
      await request.post().then((respone) {
        RequestModel model = RequestModel.fromJson(jsonDecode(respone.body));
        print(model.success);
        print(model.message);
        print(jsonEncode(model.data));

        if (model.success == true) {
          // Get.back();

          Get.to(Identity_VerificationScreen(
            userId: userId,
            hospId: '',
            isFromLogin: isFromLogin,
          ));
        } else {
          // Get.back();
          print(model.success);
          print(model.message);

          ShowMsg(model.message);
        }
      });
    } catch (e) {
      // Get.to(LoginScreen());
      print('exception occur : ${e}');
      Get.back();
      // ServerError();
    }

    return "suceess";
  }

}
