import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/patient&hospital_controller/hospital_list_controller.dart';
import 'package:medical_app/contollers/register_controller/state_cityController.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/user_registration/state_cityModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/terms_of_useScreen.dart';

class VerifyStatus extends StatefulWidget {
  final String hospId;
  final String userId;
  final bool isFromLogin;
  VerifyStatus({this.userId, this.isFromLogin, this.hospId});

  @override
  _VerifyStatusState createState() => _VerifyStatusState();
}

class _VerifyStatusState extends State<VerifyStatus> {
  State_cityController state_cityController = State_cityController();
  HospitalController2 hospitalController2 = HospitalController2();

  String _value;
  String _City_value;
  List<Cities> cities = [];
  List<Cities> cities1 = [];

  File imageFile;

  @override
  void initState() {
    state_cityController.GetState_City().then((value) {
      setState(() {});
    });
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {

      if (widget.hospId == null || widget.hospId == "") {
        // Get.to(HomeScreen());
        // ShowMsg('Hospital not selcted');
        Get.to(HomeScreen());
      }else{
        // giveRoutes();
      }


    });
  }

  giveRoutes() async {
    await hospitalController2.employeddVerification(widget.hospId).then((status){
      if(status == 2 || status == 1){
        Get.to(HomeScreen());
      }
    });

  }

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
          padding: EdgeInsets.only(left: 10, right: 10, top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${'verify_status'.tr} ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "verify_des".tr,
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),

              // new FutureBuilder(
              //     future: isDocVerified(),
              //     builder: (context, snapshot) {
              //       final output = snapshot.data??false;
              //      return output? Padding(padding: EdgeInsets.only(top: 10,bottom: 10,right: 10),child:  Row(
              //        mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //        children: [
              //          SizedBox(),
              //          Column(
              //            children: [
              //              InkWell(
              //                onTap: (){
              //                  Get.to(HomeScreen());
              //                },
              //                child:   Row(
              //                  children: [
              //                    Text(
              //                      "Already Verified ? ",
              //                      style: TextStyle(
              //                        fontWeight: FontWeight.bold,
              //                        color: Colors.black45,
              //                        decoration: TextDecoration.underline,
              //                      ),
              //                    ),
              //                    Text(
              //                      "Skip",
              //                      style: TextStyle(
              //                        fontWeight: FontWeight.bold,
              //                        color: primary_color,
              //                        decoration: TextDecoration.underline,
              //                      ),
              //                    ),
              //                  ],
              //                ),)
              //            ],
              //          ),
              //        ],),):SizedBox();
              //     }),

              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 0, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "state".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        // dropDown(50,'state')
                        dropdwon(state_cityController.state_list, _value,
                            (value) {
                          setState(() {
                            _value = value;
                            print(_value);
                            _City_value = null;
                            cities.clear();
                            cities.addAll(state_cityController
                                .state_cityModel.cities
                                .where((element) => element.sTATE == _value));
                          });
                        })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "city".tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),

                        // dropDown(60,'city')
                        dropdwon_city(
                            cities.length == 0 ? cities1 : cities, _City_value,
                            (value) {
                          setState(() {
                            _City_value = value;
                            print(_City_value);
                            //   cities.addAll(state_cityController.state_cityModel.cities.where((element) => element.sTATE==_value));
                          });
                        })
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "add_photograph".tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    "id_doc_should_contain_photobadge".tr,
                    style: TextStyle(color: Colors.black45),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  dialougeBox();
                },
                child: Container(
                  height: 180,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.5, color: Colors.grey),
                  ),
                  child: imageFile == null
                      ? Icon(
                          Icons.add,
                          size: 60,
                          color: Colors.grey,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            children: [
                              Image.file(
                                imageFile,
                                fit: BoxFit.cover,
                                width: Get.width,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 5, top: 5),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            imageFile = null;
                                          });
                                        },
                                        child: Icon(
                                          Icons.clear,
                                          size: 20,
                                          color: Colors.white,
                                        ))),
                              )
                            ],
                          )),
                ),
              ),

              Spacer(),
              Column(
                children: [
                  Container(
                      width: Get.width,
                      child: CustomButton(
                        text: "next".tr,
                        myFunc: () {
                          if (imageFile != null &&
                              !_value.isNullOrBlank &&
                              !_City_value.isNullOrBlank) {
                            Get.to(TermsOfUse(
                              city: _City_value,
                              state: _value,
                              image: imageFile.path,
                              isFromLogin: widget.isFromLogin,
                              hospID: widget.hospId,
                            ));
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
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  dialougeBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      color: primary_color,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Center(
                      child: Text(
                    'choose_image'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none),
                  )),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _getImageFromCamera();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.camera_alt,
                        color: primary_color,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'image_from_camera'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    _getImageFromGallery();
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.photo,
                        color: primary_color,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'image_from_gallery'.tr,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _getImageFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    setState(() {});
  }

  _getImageFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    setState(() {});
  }

  Widget dropdwon(List data, String selected, Function _func) {
    return Expanded(
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(
              //   width: 1,
              // )
            ),
            //height: 40.0,
            width: MediaQuery.of(context).size.width,
            child:
                //Container(child: Center(child: _value==0?,),),
                Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 22,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                    iconEnabledColor: Colors.black,
                    // isExpanded: true,
                    iconSize: 30.0,
                    dropdownColor: Colors.white,
                    hint: Text('states'.tr),
                    value: selected,
                    items: data
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text('${e.rO}'),
                            value: '${e.rO}',
                          ),
                        )
                        .toList(),
                    onChanged: _func
                    //     (value) {
                    //
                    //   setState(() {
                    //     selected = value;
                    //     print(selected);
                    //
                    //
                    //   });
                    // }

                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdwon_city(List data, String selected, Function _func) {
    return Expanded(
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 62.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(
              //   width: 1,
              // )
            ),
            //height: 40.0,
            width: MediaQuery.of(context).size.width,
            child:
                //Container(child: Center(child: _value==0?,),),
                Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 22,
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                    iconEnabledColor: Colors.black,
                    // isExpanded: true,
                    iconSize: 30.0,
                    dropdownColor: Colors.white,
                    hint: Text('cities'.tr),
                    value: selected,
                    items: data
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text('${e.cITY}'),
                            value: '${e.cITY}',
                          ),
                        )
                        .toList(),
                    onChanged: _func
                    //     (value) {
                    //
                    //   setState(() {
                    //     selected = value;
                    //     print(selected);
                    //
                    //
                    //   });
                    // }

                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
