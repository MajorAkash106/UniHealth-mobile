import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/other_controller/fcmController.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/in_app_purchase/subscription_service.dart';
import 'package:medical_app/model/EditProfileModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/model/hospitalListModel.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class HomeConroller extends GetxController {
  SaveDataSqflite dataSqflite = SaveDataSqflite();
  @override
  void onInit() {
    // this.getData();
    super.onInit();
  }

  var name = ''.obs;
  var email = ''.obs;
  var image = ''.obs;
  var lastUpdate = ''.obs;
  var notificationn = false.obs;
  var address = ''.obs;
  String lastupdate;
  // void getDetails() async {
  //   name.value =
  //       await MySharedPreferences.instance.getStringValue(Session.name);
  //   email.value =
  //       await MySharedPreferences.instance.getStringValue(Session.email);
  //   image.value =
  //       await MySharedPreferences.instance.getStringValue(Session.profilePic);
  //   lastUpdate.value =
  //   await MySharedPreferences.instance.getStringValue(Session.lastUpdate);
  //   address.value =
  //   await MySharedPreferences.instance.getStringValue(Session.address);
  //
  //   print(MySharedPreferences.instance.getStringValue(Session.userid));
  //   print(name);
  //   print(email);
  //   print(image.value.isBlank);
  //   if(image.value.isBlank){
  //     image.value = await AppImages.avtarImageUrl;
  //   }else{
  //     image.value = await APIUrls.ImageUrl + image.value;
  //   }
  //   print(image.value);
  //   print(lastUpdate.value);
  //   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  //   DateFormat dateFormat2 = DateFormat("HH:mm:ss");
  //   DateTime dateTime = DateTime.parse("2021-02-24T04:33:36.713Z").toLocal();
  //   print(dateFormat.format(dateTime));
  //   var a = dateFormat.format(dateTime);
  //   var b = dateFormat2.format(dateTime);
  //   // print(dateFormat2.format(dateTime));
  //   lastUpdate.value = b + ', '+ a;
  // }

  var hospitalList = List<HospitalListData>().obs;
  void getData() async {
    print(APIUrls.getUserdetails);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      Request request = Request(url: APIUrls.getUserdetails, body: {
        'userId': userid,
      });

      print(request.body);
      await request.post().then((value) {
        Settingdetails settingdetails = Settingdetails.fromJson(json.decode(value.body));


        dataSqflite.clearData(userid);
        dataSqflite.saveUserDetails(settingdetails);

        if (settingdetails.success == true) {
          name.value = settingdetails.data.name;
          email.value = settingdetails.data.email;
          image.value = settingdetails.data.avatar;
          address.value = settingdetails.data.address ?? '';
          lastUpdate.value = settingdetails.data.updatedAt;
          notificationn.value = settingdetails.data.isNotificationBlocked;


          MySharedPreferences.instance.setStringValue(Session.name, settingdetails.data?.name??'');
          MySharedPreferences.instance.setStringValue(Session.email, settingdetails.data?.email??'');
          MySharedPreferences.instance.setStringValue(Session.phone, settingdetails.data?.phone??'');
          MySharedPreferences.instance.setStringValue(Session.gender, settingdetails.data?.gender??'');
          MySharedPreferences.instance.setStringValue(Session.profilePic, settingdetails.data?.avatar??'');

          MySharedPreferences.instance.setStringValue(Session.lastUpdate, settingdetails.data?.updatedAt);
          MySharedPreferences.instance.setStringValue(Session.address, settingdetails.data?.address??'');

          print(settingdetails.success);
          print(settingdetails.message);
          print(settingdetails.data.avatar);
          // print(lastUpdate.value);
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          DateFormat dateFormat2 = DateFormat("HH:mm:ss");
          DateTime dateTime =
              DateTime.parse(settingdetails.data.updatedAt).toLocal();
          print(dateFormat.format(dateTime));
          var a = dateFormat.format(dateTime);
          var b = dateFormat2.format(dateTime);
          // print(dateFormat2.format(dateTime));
          lastUpdate.value = b + ', ' + a;

          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          ShowMsg(settingdetails.message);

          Future.delayed(const Duration(seconds: 2), () {
            MySharedPreferences.instance.removeAll();
            dataSqflite.clearUserDetails(userid);
            print(
                'name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
            Get.to(LoginScreen());
          });
        }
      });
    } catch (e) {
      print('eception occur : $e');
      ServerError();
      Future.delayed(const Duration(seconds: 2), () async{
        var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
        MySharedPreferences.instance.removeAll();
        dataSqflite.clearUserDetails(userid);
        print('name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
        Get.to(LoginScreen());
      });
    }
  }

  Future<String> getDatafromSqlite() async {
    print(APIUrls.getUserdetails);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      SaveDataSqflite dataSqflite = SaveDataSqflite();
      await dataSqflite.getUserDetails(userid).then((value) {
        if (value != null) {
          Settingdetails settingdetails = value;

          name.value = settingdetails.data.name;
          email.value = settingdetails.data.email;
          image.value = settingdetails.data.avatar;
          address.value = settingdetails.data.address ?? '';
          lastUpdate.value = settingdetails.data.updatedAt;
          notificationn.value = settingdetails.data.isNotificationBlocked;

          print(settingdetails.success);
          print(settingdetails.message);
          print(settingdetails.data.avatar);
          // print(lastUpdate.value);
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          DateFormat dateFormat2 = DateFormat("HH:mm:ss");
          DateTime dateTime =
              DateTime.parse(settingdetails.data.updatedAt).toLocal();
          print(dateFormat.format(dateTime));
          var a = dateFormat.format(dateTime);
          var b = dateFormat2.format(dateTime);
          // print(dateFormat2.format(dateTime));
          lastUpdate.value = b + ', ' + a;

          if (settingdetails.success == true) {
            // Get.back();
            // ShowMsg(settingdetails.message);
          } else {
            ShowMsg(settingdetails.message);

            Future.delayed(const Duration(seconds: 2), () {
              MySharedPreferences.instance.removeAll();
              print(
                  'name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
              Get.to(LoginScreen());
            });
          }
        } else {
          DATADOESNOTEXIST();
        }
      });
    } catch (e) {
      print('eception: $e');
      ServerError();
    }
    return 'success';
  }

  Future<bool> willpop() async {
    // return Get.dialog(
    //   new AlertDialog(
    //     title: new Text('Are you sure?'),
    //     content: new Text('Do you want to exit this App'),
    //     actions: <Widget>[
    //       new ElevatedButton(
    //         onPressed: () => Get.back(),4                                                                                                      55643
    //         child: new Text('No'),
    //       ),
    //       new ElevatedButton(
    //         onPressed: () => exit(0),
    //         child: new Text('Yes'),
    //       ),
    //     ],
    //   ),
    // ) ??
    //     false;
  }

  @override
  void onClose() {
    printInfo(info: 'Controller close');
    super.onClose();
  }

  Future<String> checkLoginAuth() async {
    SaveDataSqflite dataSqflite = SaveDataSqflite();
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    String uuid = await MySharedPreferences.instance.getStringValue(Session.device_id);
    await dataSqflite.getUserDetails(userid).then((v) {
      print('check login auth -- $uuid');
      if (v.data.deviceId.isNullOrBlank || v.data.deviceId != uuid) {
        MySharedPreferences.instance.removeAll();
        dataSqflite.clearUserDetails(userid);
        print('name,......${MySharedPreferences.instance.getStringValue(Session.name)}');
        Get.to(LoginScreen());
        // ShowMsg('So');
      }

    });
  }
}
