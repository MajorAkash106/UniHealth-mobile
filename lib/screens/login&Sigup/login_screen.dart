import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/other_controller/home_contoller.dart';
import 'package:medical_app/contollers/other_controller/login_contoller.dart';
import 'package:medical_app/screens/home/webview.dart';

import '../../contollers/support_controller.dart';

class LoginScreen extends StatefulWidget {
  final bool isFromLangScreen;

  LoginScreen({this.isFromLangScreen});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final HomeConroller _homeConroller = HomeConroller();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureText = true;

  static Future<String> getDeviceDetails() async {
    // String deviceName;
    // String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        // deviceName = build.model;
        // deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
        print("UUID_for android,,.......   ${identifier.toString()}");
        await MySharedPreferences.instance
            .setStringValue(Session.device_id, identifier);
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        // deviceName = data.name;
        // deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
        print("UUID_for IOS,,.......   ${identifier.toString()}");
        await MySharedPreferences.instance
            .setStringValue(Session.device_id, identifier);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceDetails();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.isFromLangScreen != null &&
            widget.isFromLangScreen == true) {
          Get.back();
        }

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'welcome'.tr,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'sign_in_to_continue'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: black40_color),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    onChanged: (value) {
                      _controller.validation(value);
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
                        suffixIcon: Obx(() => _controller.vaildEmail.value
                            ? Icon(
                                Icons.check_circle,
                                color: primary_color,
                              )
                            : SizedBox())),
                    controller: _controller.emailTextController,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                      width: Get.width,
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(null),
                            Text(
                              "send_otp".tr,
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Icon(Icons.forward)
                          ],
                        ),
                        onPressed: onSendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary_color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(15.0),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  Get.to(WebViewScreen(
                                    title: 'about_us'.tr,
                                    url: 'about_us_url'.tr,
                                  ));
                                },
                                child: Text(
                                  'about_us'.tr,
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      // fontWeight: FontWeight.normal,
                                      color: black40_color),
                                ),
                              ),
                            ),
                            Text(
                              ' & ',
                              style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.normal,
                                  color: black40_color),
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  SupportController controller =
                                      SupportController();

                                  controller.callSupportFn(context);
                                },
                                child: Text(
                                  'supports'.tr,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16,
                                      // fontWeight: FontWeight.normal,
                                      color: black40_color),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Get.to(WebViewScreen(
                                title: 'terms_policy'.tr,
                                url: 'terms_policy_url'.tr,
                              ));
                            },
                            child: Text(
                              'terms_policy'.tr,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: black40_color),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void onSendOtp() {
    print(_controller.emailTextController.text);
    print(_controller.passwordTextContoller.text);

    getDeviceDetails();
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.apiLogin();
        print('internet avialable');
      }
    });
  }
}
