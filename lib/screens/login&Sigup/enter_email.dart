import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/textfields.dart';


import '../../contollers/other_controller/forgot_pwd_controller.dart';

class EnterEmail extends StatefulWidget {

  @override
  _EnterEmailState createState() => _EnterEmailState();
}

class _EnterEmailState extends State<EnterEmail> {
 final ForgotPassController _controller = ForgotPassController();


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
                  child: SvgPicture.asset(AppImages.lockImage),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Forgot your Password?',
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
                height: 20,
              ),
              TextField(
                onChanged: (value){
                  _controller.validation(value);
                },
                style: TextStyle(color: Colors.black87),
                keyboardType:  TextInputType.emailAddress,
                obscureText:  false,
                decoration: InputDecoration(
                  // hintText: hint,
                    labelText: 'Email',
                    // filled: true,

                    fillColor: Colors.black87,
                    prefixIcon:  Icon(Icons.email_outlined),
                    suffixIcon: Obx(()=>_controller.vaildEmail.value?Icon(Icons.check_circle,color: primary_color,):SizedBox())
                ),
                controller: _controller.emailText,
              ),
              // CustomTextField('Email', _controller.emailText, TextInputType.emailAddress, false,
              //     Icon(Icons.email_outlined), Icon(null), null),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: CustomButton(
                  text: "Submit",
                  myFunc: onpress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onpress() {
    checkConnectivity().then((value){
      if(value!=null && value){
        _controller.apiCall();
      }
    });


  }
}
