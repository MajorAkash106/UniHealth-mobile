import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/register_controller/identity_verification.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/verify_statusScreen.dart';
import 'package:medical_app/screens/login&Sigup/verification/verification_contoller.dart';

class Verification1 extends StatefulWidget {
  final String userId;
  Verification1({this.userId, });

  @override
  _Verification1State createState() =>
      _Verification1State();
}

class _Verification1State
    extends State<Verification1> {
  final VerificationController1 _verificationController = VerificationController1();
  TextEditingController name = TextEditingController();
  TextEditingController Prof_num = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state_of_reg = TextEditingController();
  File imageFile;

  Future<bool> _willPopScope() {}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  "identity_verification".tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
                ),

                SizedBox(
                  height: 25.0,
                ),
                Text(
                  "identity_verification_des".tr,
                  maxLines: 6,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),





                Column(
                  children: [
                    TextField(
                      controller: name,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "name".tr,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: Prof_num,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "professional_number".tr,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: country,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "country".tr,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: state_of_reg,
                      onChanged: (value) {},
                      decoration: InputDecoration(
                        hintText: "state_registration".tr,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "add_photo".tr,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(
                      height: 1,
                    ),
                    Text(
                      "id_document_should_contain_photo".tr,
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
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
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 5.0,
                ),
                // Spacer(),
                Column(
                  children: [
                    Container(
                        width: Get.width,
                        child: CustomButton(
                          text: "next".tr,
                          myFunc: () {
                            // Get.to(VerifyStatus());
                            _verificationController.apiCall(
                              widget.userId,
                              name.text,
                              Prof_num.text,
                              country.text,
                              state_of_reg.text,
                              imageFile?.path ?? '',);
                          },
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    // Container(
                    //     width: Get.width,
                    //     child: CustomButton(
                    //       text: "Back",
                    //       myFunc: () {
                    //         Get.back();
                    //       },
                    //     ))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),)
          )),
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
}
