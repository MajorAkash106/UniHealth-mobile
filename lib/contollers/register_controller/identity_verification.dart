import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';
import 'package:medical_app/screens/login&Sigup/registeration/verify_statusScreen.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';


class VerificationController extends GetxController {
  apiCall(String userId, String name,String pname,String country,String reg,String imagepath,String hospId,bool isFromLogin) async {
    if (name.isNotEmpty && pname.isNotEmpty && country.isNotEmpty && reg.isNotEmpty && imagepath.isNotEmpty) {
      try {
        print(APIUrls.addIdentity);
        print(imagepath);

        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        final mimeTypeData =
        lookupMimeType(imagepath??'', headerBytes: [0xFF, 0xD8])
            .split('/');

        // Intilize the multipart request
        final imageUploadRequest = http.MultipartRequest(
            'POST', Uri.parse(APIUrls.addIdentity));

        // Attach the file in the request
        final file = await http.MultipartFile.fromPath(
            'avatar', imagepath??'',
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

        imageUploadRequest.fields['ext'] = mimeTypeData[1];

        imageUploadRequest.files.add(file);
        // imageUploadRequest.fields['documenttype'] = '0';
        imageUploadRequest.fields['userId'] = userId;
        imageUploadRequest.fields['name'] = name;
        imageUploadRequest.fields['professionalNumber'] = pname;
        imageUploadRequest.fields['country'] = country;
        imageUploadRequest.fields['statereg'] = reg;
        // imageUploadRequest.fields['phone'] = '1234567890';
        // imageUploadRequest.fields['gender'] = 'male';


        final streamedResponse = await imageUploadRequest.send();

        final response =
        await http.Response.fromStream(streamedResponse);

        print(response.body);

        CommonResponse model = CommonResponse.fromJson(json.decode(response.body));
        print(model.success);
        print(model.message);
        Get.back();
        if(model.success==true){
          // Get.back();
          // ShowMsg(model.message);

         Get.to(VerifyStatus(userId: userId,isFromLogin: isFromLogin,hospId: hospId,));

        }else{
          ShowMsg(model.message);
        }

      } catch (e) {
        // Get.to(LoginScreen());
        print('exception occur : ${e}');
        Get.back();
        ServerError();
      }
    } else {
      ShowMsg('All fields are mandatory.');
    }
  }


  verifyStatus(String city,String state,String imagepath,bool isFromLogin,String hosp_id,bool term_conditon) async {
    String userId = await MySharedPreferences.instance.getStringValue(Session.userid);
    // if (name.isNotEmpty && pname.isNotEmpty && country.isNotEmpty && reg.isNotEmpty && imagepath.isNotEmpty) {
      try {
        print(APIUrls.addEmployee);
        print('userId: ${userId}');
        print(imagepath);

        Get.dialog(Center(child: CircularProgressIndicator()),
            barrierDismissible: false);

        final mimeTypeData = lookupMimeType(imagepath??'', headerBytes: [0xFF, 0xD8]).split('/');

        // Intilize the multipart request
        final imageUploadRequest = http.MultipartRequest(
            'POST', Uri.parse(APIUrls.addEmployee));

        // Attach the file in the request
        final file = await http.MultipartFile.fromPath(
            'avatar', imagepath??'',
            contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

        imageUploadRequest.fields['ext'] = mimeTypeData[1];

        imageUploadRequest.files.add(file);
        // imageUploadRequest.fields['documenttype'] = '1';
       imageUploadRequest.fields['userId'] = userId;
       imageUploadRequest.fields['hospitalId'] = hosp_id;
        imageUploadRequest.fields['city'] = city;
        imageUploadRequest.fields['state'] = state;
        imageUploadRequest.fields['termcondition'] = jsonEncode(term_conditon);
        // imageUploadRequest.fields['phone'] = '1234567890';
        // imageUploadRequest.fields['gender'] = 'male';


        final streamedResponse = await imageUploadRequest.send();

        final response =
        await http.Response.fromStream(streamedResponse);

        print(response.body);

        CommonResponse model = CommonResponse.fromJson(json.decode(response.body));
        print(model.success);
        print(model.message);
        Get.back();
        if(model.success==true){
          // Get.back();
          // ShowMsg('y');
          await ShowMsg('Your request has been received successfully. please wait for admin approval.');
          // if(isFromLogin) {
          //   Get.to(LoginScreen());
          // }else{
            Get.to(HomeScreen());
          // }

        }else{
          ShowMsg(model.message);
        }

      } catch (e) {
        // Get.to(LoginScreen());
        print('exception occur : ${e}');
        Get.back();
        ServerError();
      }
    // } else {
    //   ShowMsg('All fields are mandatory.');
    // }
  }
}
