import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/EditProfileModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class SettingController extends GetxController {
  File image;
  var imagepath = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var imageUrl = ''.obs;
  TextEditingController phoneController;
  TextEditingController nameController;
  TextEditingController emailController;

  void TapOnCamera() async {
    // var picture = await ImagePicker.pickImage(
    //     source: ImageSource.camera); //platform.pickImage(source: type);
    // image = picture;

    final ImagePicker _picker = ImagePicker();
    final XFile photo = await _picker.pickImage(source: ImageSource.camera);

    image = File(photo.path);
    imagepath.value = image.path;
  }

  void TapOnGallery() async {
    // var picture = await ImagePicker.pickImage(
    //     source: ImageSource.gallery); //platform.pickImage(source: type);

    final ImagePicker _picker = ImagePicker();
    final XFile photo = await _picker.pickImage(source: ImageSource.gallery);


    image = File(photo.path);
    imagepath.value = image.path;
  }

  @override
  void onInit() {
    // TODO: implement onInit

    checkConnectivityWihtoutMsg().then((internet){
      print('internet');
      if(internet!=null && internet){
        getData();
        print('internet avialable');
      }else{
        getFromSqflite();
      }
    });
    super.onInit();
  }

  var city = ''.obs;
  var state = ''.obs;

  void getData() async {

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

        SaveDataSqflite dataSqflite = SaveDataSqflite();
        dataSqflite.clearData(userid);
        dataSqflite.saveUserDetails(settingdetails);

        name.value = settingdetails.data.name??'';
        phone.value = settingdetails.data.phone??'';
        email.value = settingdetails.data.email??'';
        imageUrl.value = settingdetails.data.avatar??'';
        city.value = settingdetails.data.city??'';
        state.value = settingdetails.data.state??'';
        phoneController = TextEditingController(text: phone.value??"");
        nameController = TextEditingController(text: name.value??"");
        emailController = TextEditingController(text: email.value??'');
        print(settingdetails.success);
        print(settingdetails.message);


        if(settingdetails.success==true){
          // Get.back();
          // ShowMsg(settingdetails.message);
        }else{
          ShowMsg(settingdetails.message);
        }


      });

    }catch(e){
      ServerError();
    }

  }

  Future<String>getFromSqflite()async{


    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    print(userid);

    SaveDataSqflite dataSqflite = SaveDataSqflite();
    dataSqflite.getUserDetails(userid).then((response){


      Settingdetails settingdetails = response;



      name.value = settingdetails.data.name;
      phone.value = settingdetails.data.phone;
      email.value = settingdetails.data.email;
      imageUrl.value = settingdetails.data.avatar;
      city.value = settingdetails.data.city;
      state.value = settingdetails.data.state;
      phoneController = TextEditingController(text: phone.value);
      nameController = TextEditingController(text: name.value);
      emailController = TextEditingController(text: email.value);
      print(settingdetails.success);
      print(settingdetails.message);


      if(settingdetails.success==true){


      }else{
        ShowMsg(settingdetails.message);
      }



    });



  }


 void onSave()async{
   var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
   var gender = await MySharedPreferences.instance.getStringValue(Session.gender);

   print('userId: $userid');
   print('gender: $gender');
   print('name: ${nameController.text}');
   print('phone: $phone.value');



   print(APIUrls.editProfile);
   try {
     Get.dialog(Center(child: CircularProgressIndicator()),
         barrierDismissible: false);

     final mimeTypeData =
     lookupMimeType(imagepath.value??'', headerBytes: [0xFF, 0xD8])
         .split('/');

     // Intilize the multipart request
     final imageUploadRequest = http.MultipartRequest(
         'POST', Uri.parse(APIUrls.editProfile));

     // Attach the file in the request
     final file = await http.MultipartFile.fromPath(
         'avatar', imagepath.value??'',
         contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

     imageUploadRequest.fields['ext'] = mimeTypeData[1];

     imageUploadRequest.files.add(file);
     imageUploadRequest.fields['userId'] = userid;
     imageUploadRequest.fields['name'] = nameController.text;
     imageUploadRequest.fields['city'] = city.value;
     imageUploadRequest.fields['state'] = state.value;
     // imageUploadRequest.fields['phone'] = '1234567890';
     // imageUploadRequest.fields['gender'] = 'male';


     final streamedResponse = await imageUploadRequest.send();

     final response =
     await http.Response.fromStream(streamedResponse);

     print(response.body);

     EditProfileDetails editProfileDetails = EditProfileDetails.fromJson(json.decode(response.body));
     print(editProfileDetails.success);
     print(editProfileDetails.message);
     Get.back();
     if(editProfileDetails.success==true){
       // Get.back();
       ShowMsg(editProfileDetails.message);
       imageUrl.value = editProfileDetails.data.avatar;
       name.value = editProfileDetails.data.name;
       MySharedPreferences.instance
           .setStringValue(Session.name, editProfileDetails.data.name);
       MySharedPreferences.instance.setStringValue(
           Session.profilePic, editProfileDetails.data.avatar);
       MySharedPreferences.instance
           .setStringValue(Session.lastUpdate, editProfileDetails.data.updatedAt);
       // Get.snackbar(editProfileDetails.message??'Something went wrong','',snackPosition: SnackPosition.BOTTOM);
     }else{
       ShowMsg(editProfileDetails.message);
     }

   }catch(e){
     Get.back();
     ServerError();
   }


 }

 void onSaveName()async{
   if(nameController.text.isNotEmpty){
     try {
       Get.dialog(Center(child: CircularProgressIndicator()),
           barrierDismissible: false);
       var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
       Request request = Request(url: APIUrls.editProfile, body: {
         "name": nameController.text,
         "userId":userid,
         "city":city.value,
         "state":state.value,
       });
       print(request.body);
       request.post().then((response) {
         EditProfileDetails editProfileDetails = EditProfileDetails.fromJson(json.decode(response.body));

         print(editProfileDetails.success);
         print(editProfileDetails.message);

         if (editProfileDetails.success == true) {
           Get.back();
           ShowMsg(editProfileDetails.message);
           imageUrl.value = editProfileDetails.data.avatar;
           name.value = editProfileDetails.data.name;
           MySharedPreferences.instance
               .setStringValue(Session.name, editProfileDetails.data.name);
           MySharedPreferences.instance
               .setStringValue(Session.lastUpdate, editProfileDetails.data.updatedAt);

         } else {
           Get.back();
           ShowMsg(editProfileDetails.message);
         }
       });
     } catch (e) {
       Get.back();
       ServerError();
     }
   }else{
     ShowMsg('Please enter your name');
   }
 }



  @override
  void onClose() {
    phoneController?.dispose();
    nameController?.dispose();
    super.onClose();
  }

}
