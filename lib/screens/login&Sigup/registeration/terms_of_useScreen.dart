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

class TermsOfUse extends StatefulWidget {
  final String hospID;
  final String state;
  final String city;
  final String image;
  final bool isFromLogin;
  TermsOfUse({ this.image,this.state,this.city,this.isFromLogin,this.hospID});

  @override
  _TermsOfUseState createState() => _TermsOfUseState();
}

class _TermsOfUseState extends State<TermsOfUse> {
 final VerificationController controller = VerificationController();
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
                  "disclaimer_and_terms_of_use".tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ),

              // new FutureBuilder(
              //     future: isDocVerified(),
              //     builder: (context, snapshot) {
              //       final output = snapshot.data??false;
              //       return output? Padding(padding: EdgeInsets.only(top: 10,bottom: 10,right: 10),child:  Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           SizedBox(),
              //           Column(
              //             children: [
              //               InkWell(
              //                 onTap: (){
              //                   Get.to(HomeScreen());
              //                 },
              //                 child:   Row(
              //                   children: [
              //                     Text(
              //                       "Already Verified ? ",
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.black45,
              //                         decoration: TextDecoration.underline,
              //                       ),
              //                     ),
              //                     Text(
              //                       "Skip",
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color: primary_color,
              //                         decoration: TextDecoration.underline,
              //                       ),
              //                     ),
              //                   ],
              //                 ),)
              //             ],
              //           ),
              //         ],),):SizedBox();
              //     }),

              SizedBox(
                height: 20,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(left: 10, right: 5, bottom: 10),
                      child: Column(children: [
                        Text(
                          "disclaimer_and_terms_des".tr,
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
                              "read_and_agree_with_all_terms".tr,
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
                                "i_take_my_responsibility_for_info_inserted_and_conduct_taken".tr,
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
                              text: "confirm".tr,
                              myFunc: () {
                                print(value1);
                                print(value2);
                               if(value1 && value2){
                                  controller.verifyStatus(widget.city, widget.state, widget.image, widget.isFromLogin, widget.hospID, true);
                               }else{
                                 ShowMsg('read_all_content_accept_please.'.tr);
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
