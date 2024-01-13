import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/register_controller/allHospitals_Model.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/user_registration/state_cityModel.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/screens/login&Sigup/login_screen.dart';
import 'package:mime/mime.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class State_cityController extends GetxController {
  State_CityModel state_cityModel;
  List<States> state_list = [];
  List<Cities> cities_list = [];
  Future<State_CityModel> GetState_City() async {
    try {
      print('ttt');
      var data = await getJson(JsonFilePath.state_city_data);
      // print(data.toString());
      // print('data from json file: ${json.decode(data)}');
      state_cityModel = await State_CityModel.fromJson(jsonDecode(data));
      print(state_cityModel.cities[0].cITY);
      print(state_list.length);
      //state_list.addAll(state_cityModel.states);
      state_list.addAll(state_cityModel.states);
      // print(state_list[0].rO);
      cities_list.addAll(state_cityModel.cities.where((element) => element.sTATE == "MT"));
      print(cities_list.length);
      print('ct.....');

      return state_cityModel;
    } catch (e) {
      print(e.toString());
    }
  }

  var allHospitals = List<AllHoispitals>().obs;
  Future<String> getHospitalsData() async {
    try {
      print(APIUrls.gethospitalsList);
      showLoader();
      Request request = Request(url: APIUrls.gethospitalsList, body: {});

      await request.get().then((response) {
        AllHospitalModel model =
            AllHospitalModel.fromJson(json.decode(response.body));
        //
        print(model.success);
        // // print(hospitalsListDetails.data);
        print(model.message);

        Get.back();
        allHospitals.clear();
        if (model.success == true) {
          allHospitals.addAll(model.data);
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      Get.back();
      ServerError();
    }
    return 'success';
  }

  Future<String> addRequest(String userId,String attributionId,String imagepath, String state,String city,Map hospital) async {
    try {
      print(APIUrls.addRequest);
      print(userId);
      print(attributionId);
      print(imagepath);
      print(state);
      print(city);
      print(jsonEncode([hospital]));


      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final mimeTypeData =
      lookupMimeType(imagepath??'', headerBytes: [0xFF, 0xD8])
          .split('/');

      // Intilize the multipart request
      final imageUploadRequest = http.MultipartRequest(
          'POST', Uri.parse(APIUrls.addRequest));

      // Attach the file in the request
      final file = await http.MultipartFile.fromPath(
          'avatar', imagepath??'',
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

      imageUploadRequest.fields['ext'] = mimeTypeData[1];

      imageUploadRequest.files.add(file);
      imageUploadRequest.fields['apptype'] = '0';
      imageUploadRequest.fields['userId'] = userId;
      imageUploadRequest.fields['attributionId'] = attributionId;
      imageUploadRequest.fields['city'] = city;
      imageUploadRequest.fields['state'] = state;
      imageUploadRequest.fields['hospital'] = jsonEncode([hospital]);



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
        ShowMsg(model.message);

        Get.to(LoginScreen());
        // Get.to(EnterHospital(UserId: userId,attributionId: attributionId,));
        // Get.snackbar(editProfileDetails.message??'Something went wrong','',snackPosition: SnackPosition.BOTTOM);
      }else{
        ShowMsg(model.message);
      }

    } catch (e) {
      // Get.to(LoginScreen());
      print('exception occur : ${e}');
      Get.back();
      ServerError();
    }

    return "suceess";
  }
}
