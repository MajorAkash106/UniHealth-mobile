import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/loop.dart';
import 'package:medical_app/model/AddPatientModel.dart';
import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/HospitalDetailsModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/medicalDivision.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class NewHospController extends GetxController {
  LocaleConfig localeConfig = LocaleConfig();

  var hospListdata = List<Hospital>().obs;
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





  var wardListdata = List<WardData>().obs;

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

  var bedListdata = List<BedsData>().obs;

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

  var medicalListdata = List<MedicalDivisionData>().obs;

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

  var vaildEmail = false.obs;
  void validation(value) {
    print(value);
    if (EmailValidator.validate(value)) {
      print('valid email');
      print(value);
      vaildEmail.value = true;
    } else {
      print(value);
      print('invalid email');
      vaildEmail.value = false;
    }
  }




  Future<String> getEditBedData(String id,String selectedBedId) async {
    print(APIUrls.getBedList);
    showLoader();
    print('wardId: $id');
    print('bedId selected: $selectedBedId');
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
          // for (var a = 0; a < beds.data.length; a++) {
          //   if (beds.data[a].sId == selectedBedId) {
          //     print('selectedbed id : ${beds.data[a].sId}');
          //     beds.data[a].isActive=false;
          //     break;
          //   }
          // }


          for (var a = 0; a < beds.data.length; a++) {
            if (beds.data[a].isActive==false) {
              bedListdata.add(beds.data[a]);
            }
            if (beds.data[a].sId==selectedBedId) {
              bedListdata.add(beds.data[a]);
            }
          }

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
    return 'success';
  }


  void editPatientDetails(
      String hospitalName,
      String patientsName,
      String phone,
      String email,
      String hospId,
      String rId,
      String gender,
      var dob,
      String ward,
      String bed,
      var admitDate,
      String mDivision,
      String insuranceCompany,
      String password,PatientDetailsData data) {
    print('hospital name: $hospitalName');
    print('patient name: $patientsName');
    print('phone: $phone');
    print('email: $email');
    print('hospId: $hospId');
    print('rId: $rId');
    print('gender: $gender');
    print('dob: $dob');

    print('ward: $ward');
    print('bed: $bed');
    print('admitdata: $admitDate');



    print('mdiv: $mDivision');
    print('Insurance: $insuranceCompany');
    print('pass: $password');
    validation(email);

    if (hospitalName != null) {
      if (patientsName != null && patientsName.isNotEmpty) {

        if (phone.isNotEmpty && phone != null) {

          if (phone.length == 11) {

            if (email.isNotEmpty && email != null) {
              if (vaildEmail.value) {
                // if (hospId.isNotEmpty && hospId != null) {
                  // if (rId.isNotEmpty && rId != null) {
                    if (gender.isNotEmpty && gender != null) {
                      if (dob != null) {
                        if (ward != null) {
                          if (bed != null) {
                            if (admitDate != null) {
                              if (mDivision != null) {
                                // if (insuranceCompany.isNotEmpty &&
                                //     insuranceCompany != null) {
                                  if (password.isNotEmpty && password != null) {


                                    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                                    String dobE = "${dateFormat.format(dob)}";
                                    String AdmitDate = "${dateFormat.format(admitDate)}";
                                    print('AdmitDate: $AdmitDate');
                                    print('dobE: $dobE');

                                    print('hosp data details: ${hospListdataDetails.length}');
                                    print(hospitalName);
                                    print(hospListdataDetails[0].toJson());

                                    var selectedData = hospListdataDetails.lastWhere((element) => element.sId == hospitalName);

                                    // var ct;
                                    // var st;
                                    // for(var i =0; i<hospListdataDetails.length;i++){
                                    //   if(hospListdataDetails[i].sId == hospId){
                                    //     ct = hospListdataDetails[i].city;
                                    //     st = hospListdataDetails[i].state;
                                    //    // var st = hospListdataDetails[i].state;
                                    //     print(hospListdataDetails[i].city);
                                    //     print(hospListdataDetails[i].state);
                                    //   }
                                    // }

                                    print(selectedData.city);
                                    print(selectedData.state);

                                    onSavedEdit(
                                        hospitalName,
                                        patientsName,
                                        phone,
                                        email,
                                        hospId,
                                        rId,
                                        gender,
                                        dobE,
                                        ward,
                                        bed,
                                        AdmitDate,
                                        mDivision,
                                        insuranceCompany,
                                        password,selectedData.city.toString(),selectedData.state.toString(),data);
                                  } else {
                                    ShowMsg('password_validation'.tr);
                                  }
                                // } else {
                                //   ShowMsg(
                                //       "Please enter your insurance company");
                                // }
                              } else {
                                ShowMsg('medical_div_validation'.tr);
                              }
                            } else {
                              ShowMsg('admit_date_validation'.tr);
                            }
                          } else {
                            ShowMsg('bed_validation'.tr);
                          }
                        } else {
                          ShowMsg('ward_validation'.tr);
                        }
                      } else {
                        ShowMsg('dob_validation'.tr);
                      }
                    } else {
                      ShowMsg('gender_validation'.tr);
                    }
                  // } else {
                  //   ShowMsg("Please enter R-Id");
                  // }
                // } else {
                //   ShowMsg("Please enter Hosp. Id");
                // }
              } else {
                ShowMsg('email_validation'.tr);
              }
            } else {
              // ShowMsg("Please enter patient's email");

              if (gender.isNotEmpty && gender != null) {
                if (dob != null) {
                  if (ward != null) {
                    if (bed != null) {
                      if (admitDate != null) {
                        if (mDivision != null) {
                          // if (insuranceCompany.isNotEmpty &&
                          //     insuranceCompany != null) {
                          if (password.isNotEmpty && password != null) {


                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dobE = "${dateFormat.format(dob)}";
                            String AdmitDate = "${dateFormat.format(admitDate)}";
                            print('AdmitDate: $AdmitDate');
                            print('dobE: $dobE');

                            print('hosp data details: ${hospListdataDetails.length}');
                            print(hospitalName);
                            print(hospListdataDetails[0].toJson());

                            var selectedData = hospListdataDetails.lastWhere((element) => element.sId == hospitalName);

                            // var ct;
                            // var st;
                            // for(var i =0; i<hospListdataDetails.length;i++){
                            //   if(hospListdataDetails[i].sId == hospId){
                            //     ct = hospListdataDetails[i].city;
                            //     st = hospListdataDetails[i].state;
                            //    // var st = hospListdataDetails[i].state;
                            //     print(hospListdataDetails[i].city);
                            //     print(hospListdataDetails[i].state);
                            //   }
                            // }

                            print(selectedData.city);
                            print(selectedData.state);

                            onSavedEdit(
                                hospitalName,
                                patientsName,
                                phone,
                                email,
                                hospId,
                                rId,
                                gender,
                                dobE,
                                ward,
                                bed,
                                AdmitDate,
                                mDivision,
                                insuranceCompany,
                                password,selectedData.city.toString(),selectedData.state.toString(),data);
                          } else {
                            ShowMsg('password_validation'.tr);
                          }
                          // } else {
                          //   ShowMsg(
                          //       "Please enter your insurance company");
                          // }
                        } else {
                          ShowMsg('medical_div_validation'.tr);
                        }
                      } else {
                        ShowMsg('admit_date_validation'.tr);
                      }
                    } else {
                      ShowMsg('bed_validation'.tr);
                    }
                  } else {
                    ShowMsg('ward_validation'.tr);
                  }
                } else {
                  ShowMsg('dob_validation'.tr);
                }
              } else {
                ShowMsg('gender_validation'.tr);
              }

            }

          } else {
            ShowMsg("Please_enter_11_digit_phone".tr);
          }

        } else {
          // ShowMsg("Please enter patient's phone");


          if (email.isNotEmpty && email != null) {
            if (vaildEmail.value) {
              // if (hospId.isNotEmpty && hospId != null) {
              // if (rId.isNotEmpty && rId != null) {
              if (gender.isNotEmpty && gender != null) {
                if (dob != null) {
                  if (ward != null) {
                    if (bed != null) {
                      if (admitDate != null) {
                        if (mDivision != null) {
                          // if (insuranceCompany.isNotEmpty &&
                          //     insuranceCompany != null) {
                          if (password.isNotEmpty && password != null) {


                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dobE = "${dateFormat.format(dob)}";
                            String AdmitDate = "${dateFormat.format(admitDate)}";
                            print('AdmitDate: $AdmitDate');
                            print('dobE: $dobE');

                            print('hosp data details: ${hospListdataDetails.length}');
                            print(hospitalName);
                            print(hospListdataDetails[0].toJson());

                            var selectedData = hospListdataDetails.lastWhere((element) => element.sId == hospitalName);

                            // var ct;
                            // var st;
                            // for(var i =0; i<hospListdataDetails.length;i++){
                            //   if(hospListdataDetails[i].sId == hospId){
                            //     ct = hospListdataDetails[i].city;
                            //     st = hospListdataDetails[i].state;
                            //    // var st = hospListdataDetails[i].state;
                            //     print(hospListdataDetails[i].city);
                            //     print(hospListdataDetails[i].state);
                            //   }
                            // }

                            print(selectedData.city);
                            print(selectedData.state);

                            onSavedEdit(
                                hospitalName,
                                patientsName,
                                phone,
                                email,
                                hospId,
                                rId,
                                gender,
                                dobE,
                                ward,
                                bed,
                                AdmitDate,
                                mDivision,
                                insuranceCompany,
                                password,selectedData.city.toString(),selectedData.state.toString(),data);
                          } else {
                            ShowMsg('password_validation'.tr);
                          }
                          // } else {
                          //   ShowMsg(
                          //       "Please enter your insurance company");
                          // }
                        } else {
                          ShowMsg('medical_div_validation'.tr);
                        }
                      } else {
                        ShowMsg('admit_date_validation'.tr);
                      }
                    } else {
                      ShowMsg('bed_validation'.tr);
                    }
                  } else {
                    ShowMsg('ward_validation'.tr);
                  }
                } else {
                  ShowMsg('dob_validation'.tr);
                }
              } else {
                ShowMsg('gender_validation'.tr);
              }
              // } else {
              //   ShowMsg("Please enter R-Id");
              // }
              // } else {
              //   ShowMsg("Please enter Hosp. Id");
              // }
            } else {
              ShowMsg('email_validation'.tr);
            }
          } else {
            // ShowMsg("Please enter patient's email");

            if (gender.isNotEmpty && gender != null) {
              if (dob != null) {
                if (ward != null) {
                  if (bed != null) {
                    if (admitDate != null) {
                      if (mDivision != null) {
                        // if (insuranceCompany.isNotEmpty &&
                        //     insuranceCompany != null) {
                        if (password.isNotEmpty && password != null) {


                          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                          String dobE = "${dateFormat.format(dob)}";
                          String AdmitDate = "${dateFormat.format(admitDate)}";
                          print('AdmitDate: $AdmitDate');
                          print('dobE: $dobE');

                          print('hosp data details: ${hospListdataDetails.length}');
                          print(hospitalName);
                          print(hospListdataDetails[0].toJson());

                          var selectedData = hospListdataDetails.lastWhere((element) => element.sId == hospitalName);

                          // var ct;
                          // var st;
                          // for(var i =0; i<hospListdataDetails.length;i++){
                          //   if(hospListdataDetails[i].sId == hospId){
                          //     ct = hospListdataDetails[i].city;
                          //     st = hospListdataDetails[i].state;
                          //    // var st = hospListdataDetails[i].state;
                          //     print(hospListdataDetails[i].city);
                          //     print(hospListdataDetails[i].state);
                          //   }
                          // }

                          print(selectedData.city);
                          print(selectedData.state);

                          onSavedEdit(
                              hospitalName,
                              patientsName,
                              phone,
                              email,
                              hospId,
                              rId,
                              gender,
                              dobE,
                              ward,
                              bed,
                              AdmitDate,
                              mDivision,
                              insuranceCompany,
                              password,selectedData.city.toString(),selectedData.state.toString(),data);
                        } else {
                          ShowMsg('password_validation'.tr);
                        }
                        // } else {
                        //   ShowMsg(
                        //       "Please enter your insurance company");
                        // }
                      } else {
                        ShowMsg('medical_div_validation'.tr);
                      }
                    } else {
                      ShowMsg('admit_date_validation'.tr);
                    }
                  } else {
                    ShowMsg('bed_validation'.tr);
                  }
                } else {
                  ShowMsg('ward_validation'.tr);
                }
              } else {
                ShowMsg('dob_validation'.tr);
              }
            } else {
              ShowMsg('gender_validation'.tr);
            }
          }

        }
      } else {
        ShowMsg("Please enter patient's name");
      }
    } else {
      ShowMsg('Please select hospital');
    }
  }



  void onSavedEdit(
      String hospitalName,
      String patientsName,
      String phone,
      String email,
      String hospId,
      String rId,
      String gender,
      String dob,
      String ward,
      String bed,
      String admitDate,
      String mDivision,
      String insuranceCompany,
      String password,
      String city,
      String state,PatientDetailsData data
      ) async {
    print('okay');

    var hospListdataObject = List<Hospital>().obs;
    var selectedData =
    hospListdata.firstWhere((element) => element.sId == hospitalName);

    selectedData.admissionDatee = "${DateTime.now()}";
    selectedData.diagnosis = '';
    selectedData.observation = data.hospital[0].observation;
    selectedData.observationLastUpdate = data.hospital[0].observationLastUpdate;
    print(selectedData);
    hospListdataObject.add(selectedData);
    print(APIUrls.editProfile);
    showLoader();
    try {
      var userid =
      await MySharedPreferences.instance.getStringValue(Session.userid);
      print('userId: $userid');


      Request request = Request(url: APIUrls.editProfile, body: {
        'name': patientsName,
        'email': email??'',
        'phone': phone??'',
        'city': city,
        'state': state,
        "gender":gender,
        // 'street': 'street',
        'rId': rId??'',
        'dob': dob,
        'wardId': ward,
        'bedId': bed,
        'medicalId': mDivision,
        'insurance': insuranceCompany??'',
          'admissionDate': admitDate,
        // 'password': data.,
        'userId': data.sId,
        // 'userUpdate': '1',
         'hospitalId': hospId??'',
         'changedob': '1',
         'updateInfo': '1',
        // "hospital": jsonEncode(hospListdataObject),
        // "apptype" : "0", "usertype": '4',
      });


      print(request.body);

      await request.post().then((value) {
        AddPatient addPatient =
        AddPatient.fromJson(json.decode(value.body));
        print(addPatient);
        print(addPatient.success);
        print(addPatient.message);
        Get.back();
        if (addPatient.success == true) {
          // }// ShowMsg(medicalDivision.message);

          // ShowMsg(addPatient.message);

          Get.to(Step1HospitalizationScreen(patientUserId: addPatient.data.sId,index: 0,));
        } else {
          ShowMsg(addPatient.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }


  void submitForm(
      String hospitalName,
      String patientsName,
      String phone,
      String email,
      String hospId,
      String rId,
      String gender,
      var dob,
      String ward,
      String bed,
      var admitDate,
      String mDivision,
      String insuranceCompany,
      String password) {
    print('hospital name: $hospitalName');
    print('patient name: $patientsName');
    print('phone: $phone');
    print('email: $email');
    print('hospId: $hospId');
    print('rId: $rId');
    print('gender: $gender');
    print('dob: $dob');

    print('ward: $ward');
    print('bed: $bed');
    print('admitdata: $admitDate');



    print('mdiv: $mDivision');
    print('Insurance: $insuranceCompany');
    print('pass: $password');
    validation(email);

    if (hospitalName != null) {
      if (patientsName != null && patientsName.isNotEmpty) {
        if (phone.isNotEmpty && phone != null) {
          if (phone.length == 11) {


            if (email.isNotEmpty && email != null) {
              if (vaildEmail.value) {
                // if (hospId.isNotEmpty && hospId != null) {
                  // if (rId.isNotEmpty && rId != null) {
                    if (gender.isNotEmpty && gender != null) {
                      if (dob != null) {
                        if (ward != null) {
                          if (bed != null) {
                            if (admitDate != null) {
                              if (mDivision != null) {
                                // if (insuranceCompany.isNotEmpty && insuranceCompany != null) {
                                  if (password.isNotEmpty && password != null) {


                                    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                                    String dobE = "${dateFormat.format(dob)}";
                                    String AdmitDate = "${dateFormat.format(admitDate)}";
                                    print('AdmitDate: $AdmitDate');
                                    print('dobE: $dobE');

                                    print('hosp data details: ${hospListdataDetails.length}');
                                    var selectedData = hospListdataDetails.firstWhere((element) => element.sId == hospitalName);

                                    // String city;
                                    // String state;


                                    // for(var i =0; i<hospListdataDetails.length;i++){
                                    //   if(hospListdataDetails[i].sId == hospId){
                                    //     print(hospListdataDetails[i].city);
                                    //     city=hospListdataDetails[i].city;
                                    //     state=hospListdataDetails[i].state;
                                    //     print(hospListdataDetails[i].state);
                                    //   }
                                    // }

                                    // print(selectedData.city);
                                    // print(selectedData.state);

                                    onSaved(
                                        hospitalName,
                                        patientsName,
                                        phone,
                                        email,
                                        hospId,
                                        rId,
                                        gender,
                                        dobE,
                                        ward,
                                        bed,
                                        AdmitDate,
                                        mDivision,
                                        insuranceCompany,
                                        password,selectedData.city,selectedData.state);
                                  } else {
                                    ShowMsg('password_validation'.tr);
                                  }
                                // } else {
                                //   ShowMsg(
                                //       "Please enter your insurance company");
                                // }
                              } else {
                                ShowMsg('medical_div_validation'.tr);
                              }
                            } else {
                              ShowMsg('admit_date_validation'.tr);
                            }
                          } else {
                            ShowMsg('bed_validation'.tr);
                          }
                        } else {
                          ShowMsg('ward_validation'.tr);
                        }
                      } else {
                        ShowMsg('dob_validation'.tr);
                      }
                    } else {
                      ShowMsg('gender_validation'.tr);
                    }
                  // } else {
                  //   ShowMsg("Please enter R-Id");
                  // }
                // } else {
                //   ShowMsg("Please enter Hosp. Id");
                // }
              } else {
                ShowMsg('email_validation'.tr);
              }
            } else {
              // ShowMsg("Please enter patient's email");

              if (gender.isNotEmpty && gender != null) {
                if (dob != null) {
                  if (ward != null) {
                    if (bed != null) {
                      if (admitDate != null) {
                        if (mDivision != null) {
                          // if (insuranceCompany.isNotEmpty && insuranceCompany != null) {
                          if (password.isNotEmpty && password != null) {


                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dobE = "${dateFormat.format(dob)}";
                            String AdmitDate = "${dateFormat.format(admitDate)}";
                            print('AdmitDate: $AdmitDate');
                            print('dobE: $dobE');

                            print('hosp data details: ${hospListdataDetails.length}');
                            var selectedData = hospListdataDetails.firstWhere((element) => element.sId == hospitalName);

                            // String city;
                            // String state;


                            // for(var i =0; i<hospListdataDetails.length;i++){
                            //   if(hospListdataDetails[i].sId == hospId){
                            //     print(hospListdataDetails[i].city);
                            //     city=hospListdataDetails[i].city;
                            //     state=hospListdataDetails[i].state;
                            //     print(hospListdataDetails[i].state);
                            //   }
                            // }

                            // print(selectedData.city);
                            // print(selectedData.state);

                            onSaved(
                                hospitalName,
                                patientsName,
                                phone,
                                email,
                                hospId,
                                rId,
                                gender,
                                dobE,
                                ward,
                                bed,
                                AdmitDate,
                                mDivision,
                                insuranceCompany,
                                password,selectedData.city,selectedData.state);
                          } else {
                            ShowMsg('password_validation'.tr);
                          }
                          // } else {
                          //   ShowMsg(
                          //       "Please enter your insurance company");
                          // }
                        } else {
                          ShowMsg('medical_div_validation'.tr);
                        }
                      } else {
                        ShowMsg('admit_date_validation'.tr);
                      }
                    } else {
                      ShowMsg('bed_validation'.tr);
                    }
                  } else {
                    ShowMsg('ward_validation'.tr);
                  }
                } else {
                  ShowMsg('dob_validation'.tr);
                }
              } else {
                ShowMsg('gender_validation'.tr);
              }

            }


          } else {
            ShowMsg("Please_enter_11_digit_phone".tr);




          }
        } else {
          debugPrint('-----------');
          // ShowMsg("Please enter patient's phone");


          if (email.isNotEmpty && email != null) {
            if (vaildEmail.value) {
              // if (hospId.isNotEmpty && hospId != null) {
              // if (rId.isNotEmpty && rId != null) {
              if (gender.isNotEmpty && gender != null) {
                if (dob != null) {
                  if (ward != null) {
                    if (bed != null) {
                      if (admitDate != null) {
                        if (mDivision != null) {
                          // if (insuranceCompany.isNotEmpty && insuranceCompany != null) {
                          if (password.isNotEmpty && password != null) {


                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dobE = "${dateFormat.format(dob)}";
                            String AdmitDate = "${dateFormat.format(admitDate)}";
                            print('AdmitDate: $AdmitDate');
                            print('dobE: $dobE');

                            print('hosp data details: ${hospListdataDetails.length}');
                            var selectedData = hospListdataDetails.firstWhere((element) => element.sId == hospitalName);

                            // String city;
                            // String state;


                            // for(var i =0; i<hospListdataDetails.length;i++){
                            //   if(hospListdataDetails[i].sId == hospId){
                            //     print(hospListdataDetails[i].city);
                            //     city=hospListdataDetails[i].city;
                            //     state=hospListdataDetails[i].state;
                            //     print(hospListdataDetails[i].state);
                            //   }
                            // }

                            // print(selectedData.city);
                            // print(selectedData.state);

                            onSaved(
                                hospitalName,
                                patientsName,
                                phone,
                                email,
                                hospId,
                                rId,
                                gender,
                                dobE,
                                ward,
                                bed,
                                AdmitDate,
                                mDivision,
                                insuranceCompany,
                                password,selectedData.city,selectedData.state);
                          } else {
                            ShowMsg('password_validation'.tr);
                          }
                          // } else {
                          //   ShowMsg(
                          //       "Please enter your insurance company");
                          // }
                        } else {
                          ShowMsg('medical_div_validation'.tr);
                        }
                      } else {
                        ShowMsg('admit_date_validation'.tr);
                      }
                    } else {
                      ShowMsg('bed_validation'.tr);
                    }
                  } else {
                    ShowMsg('ward_validation'.tr);
                  }
                } else {
                  ShowMsg('dob_validation'.tr);
                }
              } else {
                ShowMsg('gender_validation'.tr);
              }
              // } else {
              //   ShowMsg("Please enter R-Id");
              // }
              // } else {
              //   ShowMsg("Please enter Hosp. Id");
              // }
            } else {
              ShowMsg('email_validation'.tr);
            }
          } else {
            // ShowMsg("Please enter patient's email");


            if (gender!="" && gender != null) {
              if (dob != null) {
                if (ward != null) {
                  if (bed != null) {
                    if (admitDate != null) {
                      if (mDivision != null) {
                        // if (insuranceCompany.isNotEmpty && insuranceCompany != null) {
                        if (password.isNotEmpty && password != null) {


                          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                          String dobE = "${dateFormat.format(dob)}";
                          String AdmitDate = "${dateFormat.format(admitDate)}";
                          print('AdmitDate: $AdmitDate');
                          print('dobE: $dobE');

                          print('hosp data details: ${hospListdataDetails.length}');
                          var selectedData = hospListdataDetails.firstWhere((element) => element.sId == hospitalName);

                          // String city;
                          // String state;


                          // for(var i =0; i<hospListdataDetails.length;i++){
                          //   if(hospListdataDetails[i].sId == hospId){
                          //     print(hospListdataDetails[i].city);
                          //     city=hospListdataDetails[i].city;
                          //     state=hospListdataDetails[i].state;
                          //     print(hospListdataDetails[i].state);
                          //   }
                          // }

                          // print(selectedData.city);
                          // print(selectedData.state);

                          onSaved(
                              hospitalName,
                              patientsName,
                              phone,
                              email,
                              hospId,
                              rId,
                              gender,
                              dobE,
                              ward,
                              bed,
                              AdmitDate,
                              mDivision,
                              insuranceCompany,
                              password,selectedData.city,selectedData.state);
                        } else {
                          ShowMsg('password_validation'.tr);
                        }
                        // } else {
                        //   ShowMsg(
                        //       "Please enter your insurance company");
                        // }
                      } else {
                        ShowMsg('medical_div_validation'.tr);
                      }
                    } else {
                      ShowMsg('admit_date_validation'.tr);
                    }
                  } else {
                    ShowMsg('bed_validation'.tr);
                  }
                } else {
                  ShowMsg('ward_validation'.tr);
                }
              } else {
                ShowMsg('dob_validation'.tr);
              }
            } else {
              ShowMsg('gender_validation'.tr);
            }

          }


        }
      } else {
        ShowMsg("Please enter patient's name");
      }
    } else {
      ShowMsg('Please select hospital');
    }
  }

  void onSaved(
      String hospitalName,
      String patientsName,
      String phone,
      String email,
      String hospId,
      String rId,
      String gender,
      String dob,
      String ward,
      String bed,
      String admitDate,
      String mDivision,
      String insuranceCompany,
      String password,
      String city,
      String state,
      ) async {
    print('okay');

    var hospListdataObject = List<Hospital>().obs;
    var selectedData = hospListdata.firstWhere((element) => element.sId == hospitalName);
    selectedData.admissionDatee = "${DateTime.now()}";
    selectedData.diagnosis = '';
    print(selectedData);
    hospListdataObject.add(selectedData);
    print(APIUrls.addNewPatient);

    try {
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print('userId: $userid');
      Request request = Request(url: APIUrls.addNewPatient, body: {
        'name': patientsName,
        'email': email??'',
        'phone': phone??'',
        "gender":gender,
        'hospitalId': hospId??"",
        'city': city,
        'state': state,
        'street': 'street',
        'rId': rId??"",
        'dob': dob,
        'wardId': ward,
        'bedId': bed,
        'medicalId': mDivision,
        'insurance': insuranceCompany??"",
        'password': password,
        'userId': userid,
        'admissionDate': admitDate,
        "hospital": jsonEncode(hospListdataObject),
        "usertype": '4',
        "apptype" : "0"
      });
      print(request.body);
      showLoader();
      await request.post().then((value) {
        AddPatient addPatient =
        AddPatient.fromJson(json.decode(value.body));
        print(addPatient);
        print(addPatient.success);
        print(addPatient.message);
        Get.back();
        if (addPatient.success == true) {
          // }// ShowMsg(medicalDivision.message);

          setHospitalToggle toggle = setHospitalToggle();
          toggle.setHosp(selectedData.sId);
          // ShowMsg(addPatient.message);

          MySharedPreferences.instance.setStringValue(Session.espenKey, 'false');
          Get.to(Step1HospitalizationScreen(patientUserId: addPatient.data.sId,));
        } else {
          ShowMsg(addPatient.message);
        }
      });
    } catch (e) {
      print('e.toString()');
      throw(e);
      print(e);

      // Get.back();
      // ServerError();
    }
  }

  var hospListdataDetails = List<HospitalAllDetails>().obs;
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
