import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:otp_screen/otp_screen.dart';

// ignore: must_be_immutable
class VerifyOtpScreen extends StatelessWidget {
  Function onValidate;
  String verificationCode;

  VerifyOtpScreen({this.onValidate, this.verificationCode});

  TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpScreen(
        // keyboardBackgroundColor: Colors.gr,
        otpLength: 6,
        validateOtp: validateOtp,
        icon: Icon(
          Icons.email_sharp,
          color: primary_color,
        ),
        routeCallback: moveToNextScreen,
        subTitle: "verification_code_description".tr,
        titleColor: primary_color,
        themeColor: primary_color,
      ),
    );
  }

  Future<String> validateOtp(String otp) async {
    adLog('otp :: $otp  --- ${verificationCode}');
    if (verificationCode == otp) {
      adLog('verified');
      this.onValidate();
    } else {
      ShowMsg('invalid_otp'.tr);
    }

    return '';
  }

  // action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    print('next');
  }
}
