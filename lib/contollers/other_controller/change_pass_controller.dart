import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/model/ChangePasswordModel.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void apiCall() async {
    print(oldPassword.text);
    print(newPassword.text);
    print(confirmPassword.text);
    var userid =
    await MySharedPreferences.instance.getStringValue(Session.userid);

    print(userid);


    if(oldPassword.text.isNotEmpty){
      if(newPassword.text.isNotEmpty){
        if(confirmPassword.text.isNotEmpty){
          if(newPassword.text == confirmPassword.text){

          try{

            Request request = Request(url: APIUrls.changePassword, body: {
              'userId': '$userid',
              "password": oldPassword.text,
              "newPassword": newPassword.text
            });

            await request.post().then((response) {
              ChangePassDetails changePassDetails =
              ChangePassDetails.fromJson(jsonDecode(response.body));

              print(changePassDetails.data);
              print(changePassDetails.success);
              print(changePassDetails.message);
              print(changePassDetails.data);

              if(changePassDetails.success==true){
                Get.back();
                ShowMsg(changePassDetails.message);
              }else{
                ShowMsg(changePassDetails.message);
              }

            });

          }catch(e){
            ServerError();
          }

          }else{
          //  both pass should be same
            ShowMsg('New password & Confirm password should be same');
          }
        }else{
          ShowMsg('Please enter confirm password');
        }
      }else{
        ShowMsg('Please enter your new password');
      }
    }else{
      ShowMsg('Please enter your old password');
    }


  }
}
