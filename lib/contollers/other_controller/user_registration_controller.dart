import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/hospitalListModel.dart';

class UserRegistrationController extends GetxController {
  var hospitalList = List<HospitalListData>().obs;
  var clientList = List<PatientData>().obs;

  Future<String> getHospital() async {
    try {
      print(APIUrls.gethospitalsList);
      showLoader();
      Request request = Request(url: APIUrls.gethospitalsList, body: {});
      await request.get().then((response) {
        HospitalsListDetails model =
            HospitalsListDetails.fromJson(json.decode(response.body));
        print(model.success);
        print(model.message);
        Get.back();
        hospitalList.clear();
        if (model.success == true) {
          hospitalList.addAll(model.data);
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      // Get.back();
      ServerError();
    }
    return 'success';
  }

  void getClientData() async {
    try {
      showLoader();
      var userid =
          await MySharedPreferences.instance.getStringValue(Session.userid);
      print(userid);
      print(APIUrls.getPatientList);
      Request request = Request(url: APIUrls.getPatientList, body: {
        'usertype': '1',
      });
      print(request.body);
      await request.post().then((value) {
        PatientList model = PatientList.fromJson(json.decode(value.body));
        print('patients list : ${model.success}');
        Get.back();
        if (model.success == true) {
          print(model.data.first.name);
          print("patients length: ${model.data.length}");
          print("patients length: ${model.data[0].updatedAt}");
          clientList.clear();
          clientList.addAll(model.data);
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {}
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

  onSaved(
      String name,
      String phone,
      String email,
      String cpnj,
      DateTime LED,
      String country,
      String state,
      String city,
      String street,
      String number,
      List hospitals,
      List clients,
      String password)async {
    print('name: ${name}');
    print('phone: ${phone}');
    print('email: ${email}');
    print('cpnj: ${cpnj}');
    print('LED: ${LED}');
    print('country: ${country}');
    print('state: ${state}');
    print('city: ${city}');
    print('street: ${street}');
    print('number: ${number}');
    print('hospitals: ${hospitals}');
    print('clients: ${clients}');
    validation(email);

    if (!name.isNullOrBlank) {
      if (!phone.isNullOrBlank) {
        if (!email.isNullOrBlank) {
          if (vaildEmail.value) {
            if (!cpnj.isNullOrBlank) {
              if (!LED.isNullOrBlank) {
                if (!country.isNullOrBlank) {
                  if (!state.isNullOrBlank) {
                    if (!city.isNullOrBlank) {
                      if (!street.isNullOrBlank) {
                        if (!number.isNullOrBlank) {
                          if (!hospitals.isNullOrBlank) {
                            if (!clients.isNullOrBlank) {
                              if (!password.isNullOrBlank) {

                                List hospitalList = [];
                                List clientList = [];
                                for (var a in hospitals) {
                                  print(a);
                                  var encoded = jsonEncode(a);
                                  var c = await HospitalListData.fromJson(jsonDecode(encoded));
                                  print(c.name);
                                  Map data = {
                                    "_id": c.sId,
                                    "name": c.name,
                                  };
                                  hospitalList.add(data);
                                }
                                for (var a in clients) {
                                  print(a);
                                  var encoded = jsonEncode(a);
                                  var c = await PatientData.fromJson(jsonDecode(encoded));
                                  print(c.name);
                                  Map data = {
                                    "_id": c.sId,
                                    "name": c.name,
                                  };
                                  clientList.add(data);
                                }

                                print(hospitalList);
                                print(clientList);

                               await apiCallSaved(name, phone, email, cpnj, LED, country, state, city, street, number, hospitalList, clientList, password);

                              } else {
                                ShowMsg('Password field is mandatory.');
                              }
                            } else {
                              ShowMsg('Client field is mandatory.');
                            }
                          } else {
                            ShowMsg('hospital field is mandatory.');
                          }
                        } else {
                          ShowMsg('Number field is mandatory.');
                        }
                      } else {
                        ShowMsg('Street field is mandatory.');
                      }
                    } else {
                      ShowMsg('City field is mandatory.');
                    }
                  } else {
                    ShowMsg('State field is mandatory.');
                  }
                } else {
                  ShowMsg('Country field is mandatory.');
                }
              } else {
                ShowMsg('L.E.D (License Expiration Date) field is mandatory.');
              }
            } else {
              ShowMsg('CPNJ field is mandatory.');
            }
          } else {
            ShowMsg('Please enter a valid email');
          }
        } else {
          ShowMsg('Email field is mandatory.');
        }
      } else {
        ShowMsg('Phone field is mandatory.');
      }
    } else {
      ShowMsg('Name field is mandatory.');
    }
  }

  apiCallSaved(
      String name,
      String phone,
      String email,
      String cpnj,
      DateTime LED,
      String country,
      String state,
      String city,
      String street,
      String number,
      List hospitals,
      List clients,
      String password) async {
    showLoader();
    print(APIUrls.addNewPatient);
    try {
      Request request = Request(url: APIUrls.addNewPatient, body: {
        "usertype": "2",
        "apptype": "0",
        "street": street,
        "state": state,
        "phone": phone,
        "password": password,
        "number": number,
        "name": name,
        "licenseExpDate": LED.toString(),
        "email": email,
        "cpnj": cpnj,
        "country": country,
        "city": city,
        "clients": jsonEncode(clients),
        "hospital": jsonEncode(hospitals)
      });

      print(request.body);

      await request.post().then((value) {
        CommonResponse response = CommonResponse.fromJson(json.decode(value.body));
        print(response);
        print(response.success);
        print(response.message);
        Get.back();

        if (response.success == true) {
          // }// ShowMsg(medicalDivision.message);
          Get.back();
          ShowMsg(response.message);

          // Get.to(Step1HospitalizationScreen(patientUserId: addPatient.data.sId,index: 0,));
        } else {
          ShowMsg(response.message);
        }
      });
    } catch (e) {
      // Get.back();
      // ServerError();
    }
  }
}

