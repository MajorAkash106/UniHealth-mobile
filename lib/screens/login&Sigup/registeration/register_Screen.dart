import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/other_controller/login_contoller.dart';
import 'package:medical_app/contollers/register_controller/OTPController.dart';


class Register_screen extends StatefulWidget {
  const Register_screen({Key key}) : super(key: key);

  @override
  _Register_screenState createState() => _Register_screenState();
}

class _Register_screenState extends State<Register_screen> {
  LoginController _loginController = LoginController();
  OTPController otpController = OTPController();
  TextEditingController cell_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      'welcome'.tr,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'register_new_account'.tr,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: black40_color),
                    ),
                    SizedBox(
                      height: 80,
                    ),

                    TextField(
                      onChanged: (value) {
                        otpController.validation(value);
                      },
                      style: TextStyle(color: Colors.black87),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      decoration: InputDecoration(
                          // hintText: hint,
                          labelText: 'email'.tr,
                          // filled: true,

                          fillColor: Colors.black87,
                          prefixIcon: Icon(Icons.email_outlined),
                          suffixIcon: Obx(() => otpController.vaildEmail.value
                              ? Icon(
                                  Icons.check_circle,
                                  color: primary_color,
                                )
                              : SizedBox())),
                      controller: email_controller,
                    ),
                    SizedBox(
                      height: 20,
                    ), TextField(
                      onChanged: (value) {
                        //_loginController.validation(value);
                      },
                      style: TextStyle(color: Colors.black87),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                      ],
                      obscureText: false,
                      decoration: InputDecoration(
                        // hintText: hint,
                        labelText: 'cell'.tr,
                        // filled: true,

                        fillColor: Colors.black87,
                        prefixIcon: Icon(Icons.ad_units),
                        // suffixIcon: Obx(()=>_loginController.vaildEmail.value?Icon(Icons.check_circle,color: primary_color,):SizedBox())
                      ),
                      controller: cell_controller,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: Get.width,
                      child: CustomButton(
                          text: 'register'.tr,
                          myFunc: () {
                            otpController.sendOTP(
                                cell_controller.text, email_controller.text);
                          } // onpresss,
                          ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          child: Text(
                            'already_registered'.tr,
                            style: new TextStyle(
                                fontSize: 16,
//                                decoration: TextDecoration.underline,
                                color: primary_color,
                                fontWeight: FontWeight.normal
//                      fontFamily: 'Times New Roman'
                                ),
                          ),
                          onTap: () {
                            Get.back();
                            // Get.to(EnterHospital());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
