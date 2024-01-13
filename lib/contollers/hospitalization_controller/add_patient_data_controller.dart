import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/HospitalDetailsModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/medicalDivision.dart';


class AddPatientDataController extends GetxController {
 final LocaleConfig localeConfig = LocaleConfig();
 final hospListdata = List<Hospital>().obs;
 final wardListdata = List<WardData>().obs;
 final bedListdata = List<BedsData>().obs;
 final medicalListdata = List<MedicalDivisionData>().obs;
 final hospListdataDetails = List<HospitalAllDetails>().obs;

  Future<String> getHospitalData() async {
    Get.dialog(Loader(), barrierDismissible: false);
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
        Get.back();
        if (settingdetails.success == true) {
          hospListdata.clear();
          print("hospital data length: ${settingdetails.data.hospital.length}");

          hospListdata.addAll(settingdetails.data.hospital);

          // getMedicalData(settingdetails.data.hospital);
          getHospitalDetails(settingdetails.data.hospital);
        } else {
          ShowMsg(settingdetails.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

  Future<String> getWardData(String id) async {
    print(APIUrls.getWardList2);
    showLoader();
    try {
      Request request = Request(url: APIUrls.getWardList2, body: {
        'hospitalId': id,
        'type': '0',
      });

      debugPrint('request.body ==  ${request.body}');

      await request.post().then((value) {
        WardList wardList = WardList.fromJson(json.decode(value.body));

        HospitalSqflite sqflite = HospitalSqflite();
        sqflite.saveOnlyWards(wardList, id);


        print(wardList.success);
        print(wardList.message);
        Get.back();
        if (wardList.success == true) {
          wardListdata.clear();
          print(wardList.data);
          wardListdata.addAll(wardList.data);
          // getPatientListData(settingdetails.data.hospital);
        } else {
          if (wardList.message == 'Record not found.') {
            ShowMsg('No ward available, please select another hospital');
          } else {
            ShowMsg(wardList.message);
          }
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

  void getBedData(String id,) async {
    print(APIUrls.getBedList);
    showLoader();
    print('wardId: $id');
    try {
      Request request = Request(url: APIUrls.getBedList, body: {
        'wardId': id,
      });

      await request.post().then((value) {
        Beds beds = Beds.fromJson(json.decode(value.body));
        print(beds.success);
        print(beds.message);
        Get.back();
        if (beds.success == true) {
          print('doneeeee');
          print(beds.data);

          bedListdata.clear();
          // bedListdata.addAll(beds.data);
          for (var a = 0; a < beds.data.length; a++) {
            if (beds.data[a].isActive==false) {
              bedListdata.add(beds.data[a]);
            }
          }

          bedListdata.sort((a, b) {
            return a.bedNumber.toString().toLowerCase().compareTo(b.bedNumber.toString().toLowerCase());
          });

          // getPatientListData(settingdetails.data.hospital);
        } else {
          print('not');
          ShowMsg(beds.message);

        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  void getMedicalData(List<Hospital> _list) async {
    var getLocale  = await localeConfig.getLocale();
    print(APIUrls.getMedicalDivisionList);
    // showLoader();
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      print('userId: $userid');
      Request request = Request(url: APIUrls.getMedicalDivisionList, body: {
        // 'userId': userid,
        'hospitalId': jsonEncode(_list)
      });

      debugPrint('request.body == ${request.body}');

      await request.post().then((value) {
        MedicalDivision medicalDivision = MedicalDivision.fromJson(json.decode(value.body));
        print(medicalDivision.success);
        print(medicalDivision.message);

        HospitalSqflite sqflite = HospitalSqflite();
        sqflite.saveMedical(medicalDivision, _list[0].sId);


        // Get.back();
        if (medicalDivision.success == true) {
          medicalListdata.clear();
          print("android data: ${medicalDivision.data}");


          // debugPrint('a.countryCode ${a.languageCode}');

          // medicalListdata = medicalDivision.data.where((it) => it.availableIn.contains(getLocale.languageCode));
          //
          // debugPrint('medicalListdata :: $medicalListdata');

          for(var a in medicalDivision.data){

            debugPrint('getLocale.languageCode ${getLocale.languageCode}');
            debugPrint('a.availableIn.indexOf(getLocale.languageCode ${a.availableIn.indexOf(getLocale.languageCode)}');
            if(a.availableIn.indexOf(getLocale.languageCode) !=-1){
              medicalListdata.add(a);
            }

          }



          // for(var a=0; a<beds.data.length; a++){
          //   if(beds.data[a].isActive){
          //     bedListdata.add(beds.data[a]);
          //   }
          // }

          // getPatientListData(settingdetails.data.hospital);
        } else {
          ShowMsg(medicalDivision.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  void getHospitalDetails(List<Hospital> _list) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getHospitaldetails);
      Request request = Request(url: APIUrls.getHospitaldetails, body: {
        'hospitalId': jsonEncode(_list),
      });

      print('request:  ${request.body}');
      print('jsonEncode:  ${jsonEncode(_list)}');

      await request.post().then((value) {
        HospitalDetails hospitalDetails =
        HospitalDetails.fromJson(json.decode(value.body));
        print(hospitalDetails.success);
        print(hospitalDetails.message);
        // Get.back();
        if (hospitalDetails.success == true) {
          hospListdataDetails.clear();
          print("hospital Details data length: ${hospitalDetails.data.length}");

          hospListdataDetails.addAll(hospitalDetails.data);
          //
          // getMedicalData(hospitalDetails.data.hospital);
        } else {
          ShowMsg(hospitalDetails.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  Future<String> getWardDataOffline(String id) async {
    print(APIUrls.getWardList2);
    showLoader();
    try {

      HospitalSqflite sqflite = HospitalSqflite();
      sqflite.getOnlyWards(id).then((value) {
        WardList wardList = value;

        print(wardList.success);
        print(wardList.message);
        Get.back();
        if (wardList.success == true) {
          wardListdata.clear();
          print(wardList.data);
          wardListdata.addAll(wardList.data);
          // getPatientListData(settingdetails.data.hospital);
        } else {
          if (wardList.message == 'Record not found.') {
            ShowMsg('No ward available, please select another hospital');
          } else {
            ShowMsg(wardList.message);
          }
        }

      });

    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

  void getMedicalDataOffline(List<Hospital> _list) async {

    try {
      HospitalSqflite sqflite = HospitalSqflite();
      sqflite.getMedical(_list[0].sId).then((value) {

        MedicalDivision medicalDivision = value;
        print(medicalDivision.success);
        print(medicalDivision.message);
        if (medicalDivision.success == true) {
          medicalListdata.clear();
          print("android data: ${medicalDivision.data}");
          medicalListdata.addAll(medicalDivision.data);


        } else {
          ShowMsg(medicalDivision.message);
        }

      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }

  Future<String> getWardDataWithoutLoader(String id) async {
    print(APIUrls.getWardList2);
    // showLoader();
    try {
      Request request = Request(url: APIUrls.getWardList2, body: {
        'hospitalId': id,
        'type': '0',
      });

      await request.post().then((value) {
        WardList wardList = WardList.fromJson(json.decode(value.body));

        HospitalSqflite sqflite = HospitalSqflite();
        sqflite.saveOnlyWards(wardList, id);


        print(wardList.success);
        print(wardList.message);
        // Get.back();
        if (wardList.success == true) {
          wardListdata.clear();
          print(wardList.data);
          wardListdata.addAll(wardList.data);
          // getPatientListData(settingdetails.data.hospital);
        } else {
          if (wardList.message == 'Record not found.') {
            ShowMsg('No ward available, please select another hospital');
          } else {
            ShowMsg(wardList.message);
          }
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
    return 'success';
  }

}
