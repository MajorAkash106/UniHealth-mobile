import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/config/widgets/schedule_next_evaluation.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';

import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/patients&hospitals/hospitals.dart';
import 'package:medical_app/screens/home/patients&hospitals/patients_list.dart';

class BedsController extends GetxController {
  HospitalSqflite _sqflite = HospitalSqflite();

  @override
  // TODO: implement isClosed
  bool get isClosed => super.isClosed;

  var bedListdata = List<BedsData>().obs;

  void getBedData(String id) async {
    print(APIUrls.getBedList);
    showLoader();
    try {
      Request request = Request(url: APIUrls.getBedList, body: {
        'wardId': id,
      });

      print(request.body);
      await request.post().then((value) {
        Beds beds = Beds.fromJson(json.decode(value.body));

        //save data to sqflite
        _sqflite.saveBeds(beds, id);

        print(beds.success);
        print(beds.message);
        Get.back();
        if (beds.success == true) {
          bedListdata.clear();
          print(beds.data);
          bedListdata.addAll(beds.data);
          bedListdata.sort((a, b) {
            return a.bedNumber
                .toString()
                .toLowerCase()
                .compareTo(b.bedNumber.toString().toLowerCase());
          });
          // getPatientListData(settingdetails.data.hospital);

        } else {
          ShowMsg(beds.message);
        }
      });
    } catch (e) {
      print(e);
      // Get.back();
      // ServerError();
    }
  }

  void getFromSqflite(String id) async {
    try {
      _sqflite.getBeds(id).then((res) {
        if (res != null) {
          Beds beds = res;

          print(beds.success);
          print(beds.message);

          if (beds.success == true) {
            bedListdata.clear();
            print(beds.data);
            bedListdata.addAll(beds.data);
            bedListdata.sort((a, b) {
              return a.bedNumber
                  .toString()
                  .toLowerCase()
                  .compareTo(b.bedNumber.toString().toLowerCase());
            });
          } else {
            ShowMsg(beds.message);
          }
        } else {
          DATADOESNOTEXIST();
        }
      });
    } catch (e) {
      print(e);
      // Get.back();
      // ServerError();
    }
  }

  Future<String> deleteBed(String id, context, String wardId) async {
    Get.dialog(Loader(),
        barrierDismissible: false);
    try {
      print(APIUrls.getPatientsdetails);
      Request request = Request(url: APIUrls.getPatientsdetails, body: {
        'userId': id,
      });

      print(request.body);
      await request.post().then((value) {
        PatientDetails patientDetails =
            PatientDetails.fromJson(json.decode(value.body));
        print(patientDetails.success);
        print(patientDetails.message);
        Get.back();
        if (patientDetails.success == true) {
          opendialog(patientDetails.data, context, wardId).then((value) {
            print('deletebed: $value');
          });
        } else {
          ShowMsg(patientDetails.message);
        }
      });
    } catch (e) {
      Get.back();
      ServerError();
    }
    return 'success';
  }

  int selctedradio = -1;

  Future<String> opendialog(
      PatientDetailsData patientDetailsData, context, String wardId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: Get.width / 1.1,
                padding:
                    EdgeInsets.only(top: 0, bottom: 20, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'why_are_you_deleting'.tr,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    Divider(),
                    ListTile(
                      leading: selctedradio == 0
                          ? Icon(
                              Icons.radio_button_checked,
                              color: primary_color,
                            )
                          : Icon(Icons.radio_button_off),
                      title: Text(
                        'discharged'.tr,
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selctedradio = 0;
                        });
                      },
                    ),
                    ListTile(
                      leading: selctedradio == 1
                          ? Icon(
                              Icons.radio_button_checked,
                              color: primary_color,
                            )
                          : Icon(Icons.radio_button_off),
                      title: Text(
                        'dead'.tr,
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selctedradio = 1;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 1,
                            child: CustomButton(
                                text: '  ${'skip'.tr}  ',
                                myFunc: () {
                                  Get.back();
                                })),
                        Flexible(
                            flex: 1,
                            child: CustomButton(
                                text: '    ${'confirm'.tr}    ',
                                myFunc: () async {
                                  Get.back();
                                  // SaveDataSqflite _controller = SaveDataSqflite();
                                  await DeadDischarge(patientDetailsData,
                                          selctedradio, wardId)
                                      .then((value) {
                                    print('yesssss deleterr');

                                    // Future.delayed(const Duration(milliseconds: 500), () {
                                    //
                                    //   Get.to(HospitalScreen());
                                    // });

                                    // _controller.clearData(patientDetailsData.sId);

                                    //clear data from local
                                    SaveDataSqflite sqflite = SaveDataSqflite();
                                    sqflite.clearData(patientDetailsData.sId);
                                    sqflite.clearPatientId(patientDetailsData.sId);


                                    getWardData2(patientDetailsData.hospital[0].sId,patientDetailsData.wardId.sId,patientDetailsData.hospital[0].name,true);


                                    return 'success';
                                  });
                                })),
                      ],
                    ),
                    // SizedBox(height: 10,),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<String> DeadDischarge(
      PatientDetailsData data, int selectRadio, String wardId) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print('userId: $userid');
      print(APIUrls.editProfile);
      // data.hospital[0].diagnosis = text;
      // data.hospital[0].diagnosisLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.editProfile, body: {
        // 'name': data.name,
        // 'email': data.email,
        // 'phone': data.phone,
        // 'hospitalId': data.hospitalId,
        'city': data.city,
        'state': data.state,
        // 'street': 'street',
        // 'rId': data.rId,
        // 'dob': data.dob,
        // 'wardId': data.ward,
        // 'bedId': data.bed,
        // 'medicalId': mDivision,
        // 'insurance': data.insurance,
        // 'password': data.,
        'userId': data.sId,
        'discharge': selctedradio == 0 ? jsonEncode(true) : jsonEncode(false),
        'died': selctedradio == 1 ? jsonEncode(true) : jsonEncode(false),
        // 'palcare':jsonEncode(data.palcare),
        // 'admissionDate': data.admissionDate,
        // "hospital": jsonEncode(data.hospital),
        // "usertype": '4',
        // "apptype" : "0"
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          // getBedData(wardId);
          // Get.to(HomeScreen());
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      Get.back();
      print(e);
      // ServerError();
    }

    return "success";
  }
}
