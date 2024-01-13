import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/register_controller/OTPController.dart';
import 'package:medical_app/model/register_controller/otp_model.dart';
import 'package:otp_screen/otp_screen.dart';

import 'create_passwordScreen.dart';

class Registeration_OtpScreen extends StatefulWidget {
  OTPData otpData;
  Registeration_OtpScreen({this.otpData});

  @override
  _Registeration_OtpScreenState createState() => _Registeration_OtpScreenState();
}

class _Registeration_OtpScreenState extends State<Registeration_OtpScreen> {
  final OTPController _controller = OTPController();

  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OtpScreen(
        otpLength: 4,
        validateOtp: validateOtp,
        // icon: Icon(Icons.email_outlined),
        routeCallback: moveToNextScreen,subTitle: "verification_code_description".tr,
        titleColor: Colors.black,
        themeColor: Colors.black,
      ),
      // body: SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(12.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       children: [
      //         Container(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               SizedBox(
      //                 height: 100,
      //               ),
      //               Text(
      //                 'Please verify',
      //                 style:
      //                 TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      //               ),
      //               SizedBox(
      //                 height: 5,
      //               ),
      //               Row(children: [Expanded(child: Text("We've sent you verification code in your email, please check",style: TextStyle(
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.normal,
      //                   color: black40_color),))],),
      //               // Text(
      //               //   'Welcome',
      //               //   style:
      //               //   TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      //               // ),
      //               // Text(
      //               //   'Register new account',
      //               //   style: TextStyle(
      //               //       fontSize: 16,
      //               //       fontWeight: FontWeight.normal,
      //               //       color: black40_color),
      //               // ),
      //               SizedBox(
      //                 height: 80,
      //               ),
      //               TextField(
      //                 onChanged: (value){
      //                   //_loginController.validation(value);
      //                 },
      //                 style: TextStyle(color: Colors.black87),
      //                 keyboardType:  TextInputType.phone,
      //                 inputFormatters: [
      //                   LengthLimitingTextInputFormatter(4),
      //                 ],
      //                 obscureText:  false,
      //                 decoration: InputDecoration(
      //                   // hintText: hint,
      //                   labelText: 'Verification code',
      //                   // filled: true,
      //
      //                   fillColor: Colors.black87,
      //                 //  prefixIcon:  Icon(Icons.),
      //                   // suffixIcon: Obx(()=>_loginController.vaildEmail.value?Icon(Icons.check_circle,color: primary_color,):SizedBox())
      //                 ),
      //                 controller: otpController,
      //               ),
      //               SizedBox(
      //                 height: 50,
      //               ),
      //
      //
      //               SizedBox(
      //                 height: 30,
      //               ),
      //               Container(
      //                 width: Get.width,
      //                 child:  CustomButton(
      //                     text: 'Confirm',
      //                     myFunc:(){
      //
      //
      //                       _controller.verifyOTP(widget.otpData, otpController.text);
      //
      //                     }// onpresss,
      //                 ),
      //               ),
      //               // Container(
      //               //   width: Get.width,
      //               //   child: Padding(
      //               //     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      //               //     child: CustomButton(
      //               //       text: 'IN APP TEST',
      //               //       myFunc: (){
      //               //         Get.to(INAPPTEST());
      //               //       },
      //               //     ),
      //               //   ),
      //               // ),
      //               SizedBox(height: 10,),
      //
      //
      //             ],
      //           ),
      //         ),
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }


  Future<String> validateOtp(String otp) async {
    _controller.verifyOTP(widget.otpData, otp);
  }

  // action to be performed after OTP validation is success
  void moveToNextScreen(context) {
    print('next');
  }
}
