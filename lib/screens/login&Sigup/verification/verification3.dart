import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/register_controller/identity_verification.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/select_screen.dart';
import 'package:medical_app/screens/login&Sigup/verification/verification_contoller.dart';

class Verification3 extends StatefulWidget {
  final String userId;
  final String state;
  final String city;
  final String image;

  Verification3({ this.userId, this.image,this.state,this.city});

  @override
  _Verification3State createState() => _Verification3State();
}

class _Verification3State extends State<Verification3> {
  final VerificationController1 controller = VerificationController1();
  bool value1 = false;
  bool value2 = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
        Brightness.dark //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  "Disclaimer and Terms of use",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ),


              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 5, bottom: 10),
                      child: Column(children: [
                        Text(
                          "If you wish to write a will, or amend an existing will to ensure your estate is distributed according to your wishes after you die, our expert will writing solicitors are here to help."
                              "Our award-winning solicitors based across Yorkshire are on hand to guide you through the will writing process, giving you the peace of mind that your family and loved ones will be provided for after you die. We are widely regarded for our high standards of service, and will do our utmost to ensure that your specific requirements are met."
                              "If a will is not drafted properly, the document can be deemed invalid and have no legal effect, which means your estate may not pass to who you want it to. We can provide practical legal guidance in simple terms, helping you to make sense of this often complicated legal process."
                              "Ramsdens ’ will writing solicitors are on hand to guide you every step of the way throughout this legal process. We will work tirelessly to ensure your will is as detailed and clear as possible, whilst complying with all of the necessary legal requirements.",
                          style: TextStyle(color: Colors.black45, fontSize: 16),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: this.value1,
                              onChanged: (bool value) {
                                setState(() {
                                  this.value1 = value;
                                });
                              },
                            ), //C
                            Text(
                              "Read and agree with all terms",
                              style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        // SizedBox(height: 10,),
                        Row(
                          children: [
                            Checkbox(
                              value: this.value2,
                              onChanged: (bool value) {
                                setState(() {
                                  this.value2 = value;
                                });
                              },
                            ), //C
                            Expanded(
                              child: Text(
                                "I take my responsibility for info inserted and conduct taken",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ],)
                  ),
                ),
              ),
              Column(
                children: [

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        Container(
                            width: Get.width,
                            child: CustomButton(
                              text: "Confirm",
                              myFunc: () {
                                print(value1);
                                print(value2);
                                if(value1 && value2){
                                  controller.verifyStatus(widget.city, widget.state, widget.image, widget.userId);
                                }else{
                                  ShowMsg('Please read All the content aof terms And accept please.');
                                }

                              },
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        // Container(
                        //     width: Get.width,
                        //     child: CustomButton(text: "Back",myFunc: (){
                        //       Get.back();
                        //     },))
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
