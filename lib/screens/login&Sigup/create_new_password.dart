import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/textfields.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';

class CreateNewPassword extends StatefulWidget {
  @override
  _CreateNewPasswordState createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  var new_pass = TextEditingController();
  var confirm_pass = TextEditingController();
  bool _obscureText = false;
  bool _obscureText2 = false;

  void _toggle() {
    print('ok');
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggle2() {
    print('ok');
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: ListView(
            children: [
              SizedBox(
                height: 80,
              ),
              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.black12,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white24,
                //  child: SvgPicture.asset(AppImages.'Volkswagen''Volkswagen'keyImage),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Create new Password?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text(
                  'Please enter your email to reset your password',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: black40_color),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(
                  'New password',
                  new_pass,
                  TextInputType.emailAddress,
                  _obscureText,
                  Icon(Icons.security),
                  _obscureText == true
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  _toggle),
              SizedBox(
                height: 20,
              ),
              CustomTextField(
                  'Confirm password',
                  confirm_pass,
                  TextInputType.emailAddress,
                  _obscureText,
                  Icon(Icons.security),
                  _obscureText == true
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  _toggle),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: CustomButton(
                  text: "Save",
                  myFunc: onpresss,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onpresss() {
    Get.to(LoginScreen());
  }
}
