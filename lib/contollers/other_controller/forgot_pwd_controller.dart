import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/model/forgot_pwd/Forgot_pwd_model.dart';

class ForgotPassController extends GetxController {
  TextEditingController emailText = TextEditingController();

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

  void apiCall() async {
    print(emailText.text);

    if (emailText.text.isNotEmpty) {
      if (vaildEmail.value) {
        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        try {
          Request request =
              Request(url: APIUrls.forgotpass, body: {"email": emailText.text});
          request.post().then((response) {
            ForgotDetails details =
                ForgotDetails.fromJson(jsonDecode(response.body));
            print(details.success);
            print(details.message);
            Get.back();
            if (details.success == true) {
              // Get.back();
              Get.back();
              ShowMsg(details.message);
            } else {
              ShowMsg(details.message);
            }
          });
        } catch (e) {
          ServerError();
        }
      } else {
        ShowMsg('Please enter a valid email !');
      }
    } else {
      ShowMsg('Please enter you email !');
    }
  }
}
