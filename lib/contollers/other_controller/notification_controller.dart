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
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/EditProfileModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/getNotificationWards.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:medical_app/model/SettingModel.dart';
class NotificationConroller extends GetxController {


  void notificationOnOff(bool status) async {
    print(APIUrls.notificationONOFF);
    showLoader();
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      Request request = Request(url: APIUrls.notificationONOFF, body: {
        'userId': userid,
        'isNotificationBlocked': jsonEncode(status),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        Get.back();
        if (commonResponse.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }

  Future<bool> willpop() async {
    // return Get.dialog(
    //   new AlertDialog(
    //     title: new Text('Are you sure?'),
    //     content: new Text('Do you want to exit this App'),
    //     actions: <Widget>[
    //       new ElevatedButton(
    //         onPressed: () => Get.back(),
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

  void getHospitalData() async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getUserdetails);
      Request request = Request(url: APIUrls.getUserdetails, body: {
        'userId': userid,
      });

      await request.post().then((value) {
        Settingdetails settingdetails =
        Settingdetails.fromJson(json.decode(value.body));
        print(settingdetails.success);
        print(settingdetails.message);
        if(settingdetails.success==true){

          // print(settingdetails.data.hospital);
          getNotificationWard(settingdetails.data.hospital);
        }else{
          ShowMsg(settingdetails.message);
        }


      });

    }catch(e){
      ServerError();
    }

  }


  var getNotificationWardList = List<GetNotificationData>().obs;

  void getNotificationWard(List<Hospital> hospitalId) async {
    print(APIUrls.getNotificationWard);
    // showLoader();
    print(jsonEncode(hospitalId));
    print(hospitalId);
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      Request request = Request(url: APIUrls.getNotificationWard, body: {
        'hospital': jsonEncode(hospitalId),
        'userId': userid,
      });

      print(request.body);
      await request.post().then((value) {
        GetNotificationWard getNotificationWard =
        GetNotificationWard.fromJson(json.decode(value.body));

        print(getNotificationWard.message);
        print(getNotificationWard.success);
        Get.back();
        if (getNotificationWard.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
          print(jsonEncode(getNotificationWard.data.first));
          getNotificationWardList.clear();
          getNotificationWardList.addAll(getNotificationWard.data);
        } else {
          ShowMsg(getNotificationWard.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }


  void wardNotificationOnOff(String wardId,bool ONOFF) async {
    print(APIUrls.wardNotificationOnOff);
    showLoader();
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      Request request = Request(url: APIUrls.wardNotificationOnOff, body: {
        'userId': userid,
        'wardId': wardId,
        'isBlocked': jsonEncode(ONOFF),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        Get.back();
        if (commonResponse.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }

}
// 66:9E:82:C4:8E:27:D2:DC:E0:CE:67:0C:4A:9A:98:5C:33:5A:F4:43:41:63:EF:32:32:70:C6:28:9D:C7:C8:85
// 78:CA:1A:BF:07:C5:FE:22:17:22:2F:7E:10:3F:FA:07:1D:9A:FC:FE