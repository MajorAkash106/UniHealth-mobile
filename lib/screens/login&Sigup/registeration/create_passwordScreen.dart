import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/textfields.dart';
import 'package:medical_app/contollers/register_controller/OTPController.dart';
import 'package:medical_app/screens/login&Sigup/registeration/subscriptionActivation_Screen.dart';

class CreatePassword_Screen extends StatefulWidget {
  final String userId;


  CreatePassword_Screen({this.userId,});

  @override
  _CreatePassword_ScreenState createState() => _CreatePassword_ScreenState();
}

class _CreatePassword_ScreenState extends State<CreatePassword_Screen> {
  TextEditingController create_pwd_ctr = TextEditingController();
  TextEditingController confirm_pwd_ctr = TextEditingController();

  OTPController controller = OTPController();
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  bool _obscureText = true;
  bool _obscureText2 = true;

  Future<bool> willpopScope() {}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willpopScope,
        child: Scaffold(
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
                          'Create Password',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Row(children: [Expanded(child: Text("We've sent you verification code in your email, please check",style: TextStyle(

                        SizedBox(
                          height: 80,
                        ),
                        // CustomTextField(
                        //     'Password',
                        //     create_pwd_ctr,
                        //     TextInputType.emailAddress,
                        //     _obscureText,
                        //     Icon(Icons.security),
                        //     _obscureText == true
                        //         ? Icon(Icons.visibility)
                        //         : Icon(Icons.visibility_off),
                        //     _toggle),
                        TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          // maxLength: 5,
                          obscureText: _obscureText,
                          controller: create_pwd_ctr,
                          decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.security),
                              suffixIcon: _obscureText == true
                                  ? InkWell(
                                      child: Icon(Icons.visibility),
                                      onTap: () {
                                        _toggle();
                                      },
                                    )
                                  : InkWell(
                                      child: Icon(Icons.visibility_off),
                                      onTap: () {
                                        _toggle();
                                      },
                                    )

                              // suffixIcon: //confirm_pwd_ctr.isNullOrBlank||create_pwd_ctr.isNullOrBlank||
                              // confirm_pwd_ctr!=create_pwd_ctr?SizedBox():
                              // Icon(Icons.check_circle,),

                              ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {});
                          },
                          // maxLength: 5,
                          controller: confirm_pwd_ctr,
                          obscureText: _obscureText2,
                          // keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                            labelText: "Confirm password",
                            prefixIcon: Icon(Icons.security),
                            suffixIcon: //confirm_pwd_ctr.isNullOrBlank||create_pwd_ctr.isNullOrBlank||
                                (confirm_pwd_ctr.text.isEmpty ||
                                            create_pwd_ctr.text.isEmpty) ||
                                        (confirm_pwd_ctr.text !=
                                            create_pwd_ctr.text)
                                    ? _obscureText2 == true
                                        ? InkWell(
                                            child: Icon(Icons.visibility),
                                            onTap: () {
                                              _toggle2();
                                            },
                                          )
                                        : InkWell(
                                            child: Icon(Icons.visibility_off),
                                            onTap: () {
                                              _toggle2();
                                            },
                                          )
                                    : Icon(
                                        Icons.check_circle,
                                        color: primary_color,
                                      ),
                          ),
                        ),
                        //),

                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: Get.width,
                          child: CustomButton(
                              text: 'Confirm',
                              myFunc: () {
                                if (create_pwd_ctr.text ==
                                    confirm_pwd_ctr.text) {
                                  controller.createPass(widget.userId,
                                      confirm_pwd_ctr.text, true);
                                } else {
                                  ShowMsg('Both password must be same.');
                                }

                                // Get.to(SubscriptionActivation_Screen());
                              } // onpresss,
                              ),
                        ),
                        // Container(
                        //   width: Get.width,
                        //   child: Padding(
                        //     padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        //     child: CustomButton(
                        //       text: 'IN APP TEST',
                        //       myFunc: (){
                        //         Get.to(INAPPTEST());
                        //       },
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
