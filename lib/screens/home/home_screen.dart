import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/offline_func.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/versioning/versioning.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/other_controller/fcmController.dart';
import 'package:medical_app/contollers/other_controller/home_contoller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/hospital_list_controller.dart';
import 'package:medical_app/contollers/other_controller/log_out_controller.dart';
import 'package:medical_app/contollers/sqflite/TestingSqflite.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/support_controller.dart';
import 'package:medical_app/in_app_purchase/subscription_service.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/indicators/choose_hospital.dart';
import 'package:medical_app/screens/home/notification/notifications.dart';
import 'package:medical_app/screens/home/patients&hospitals/hospitals.dart';
import 'package:medical_app/screens/home/settings.dart';
import 'package:medical_app/screens/home/webview.dart';
import 'package:medical_app/screens/login&Sigup/registeration/activate_subscription.dart';
import 'package:medical_app/screens/login&Sigup/registeration/enter_hospital.dart';
import 'package:medical_app/screens/login&Sigup/registeration/verify_statusScreen.dart';
import 'package:medical_app/screens/login&Sigup/verification/verification1.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../config/Locale/locale_config.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeConroller _conroller = HomeConroller();
  final HospitalController2 _hospitalController = HospitalController2();
  final Log_out_controller _log_out_controller = Log_out_controller();
  final AppVersionConfig versionController = AppVersionConfig();
  // Fcm_controller fcm_controller = Fcm_controller();
  RxList<String> notification_list = <String>[].obs;
  @override
  void initState() {
    checkConnectivityWihtoutMsg().then((internet) {
      if (internet != null && internet) {
        _conroller.getData();
        _hospitalController
            .getHospitalDataWithoutLoader()
            .then((value) => _conroller.checkLoginAuth());
      } else {
        _conroller
            .getDatafromSqlite()
            .then((value) => _conroller.checkLoginAuth());
      }
    });

    super.initState();
    // notification_list = fcm_controller.notification_list;
    // print(notification_list.length);
    // return 'Akash';
  }


  SaveDataSqflite sqlite = SaveDataSqflite();
  List<PatientDetailsData> initalList = [];
  bool imageloading = false;
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _conroller.willpop,
      child: Scaffold(
          bottomNavigationBar: Obx(
            () => _conroller.email.value.isNotEmpty
                ? FutureBuilder(
                    initialData: initalList,
                    future: sqlite.allOfflineData(),
                    builder: (context, AsyncSnapshot snapshot) {
                      List<PatientDetailsData> allData = snapshot?.data;

                      if (snapshot.data == null) {
                        return SizedBox();
                      }
                      return allData.isNullOrBlank
                          ? SizedBox()
                          : RaisedButton(
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(10.0),
                              // ),
                              padding: EdgeInsets.all(16.0),
                              onPressed: () async {
                                // var id = await MySharedPreferences.instance
                                //     .getStringValue(Session.userid);
                                // print(id);
                                // log_out();
                                // Get.to(LoginScreen());
                              },
                              color: Colors.white,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Text("".toUpperCase(),
                                      style: TextStyle(fontSize: 18)),
                                  // allData.isNullOrBlank
                                  //     ? SizedBox():
                                  InkWell(
                                      onTap: () {
                                        askToSendData('').then((value) {
                                          print('close popup with $value');
                                          if (value == "YES") {
                                            checkConnectivity()
                                                .then((internet) {
                                              if (internet != null &&
                                                  internet) {
                                                OfflineHandler _offlinehandler =
                                                    OfflineHandler();
                                                showLoader();
                                                _offlinehandler
                                                        .DataToServerMultiple(
                                                            allData)
                                                    .then((value) {
                                                  print('return res: $value');
                                                  // ShowMsg('Your offline data sink successfully.');
                                                  if (value == 'success') {
                                                    sqlite
                                                        .clearPatientIds()
                                                        .then((r) {
                                                      Get.back();
                                                      ShowMsg(
                                                          'data_sink_successfully'.tr);
                                                      setState(() {});
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          SvgPicture.asset(
                                            AppImages.redCloud,
                                            height: 25,
                                          ),
                                          Positioned(
                                              right: 0.0,
                                              left: 25.0,
                                              top: 0.0,
                                              bottom: 15.0,
                                              child: CircleAvatar(
                                                backgroundColor: primary_color,
                                                child: Center(
                                                  child: Text(
                                                    "${allData.length}",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                radius: 15,
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            );
                    })
                : SizedBox(),
          ),
          body: Obx(
            () => _conroller.email.value.isNotEmpty
                ? Container(
                    color: primary_color,
                    child: SafeArea(
                        child: Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          Container(
                            // color: primary_color,
                            // height: MediaQuery.of(context).size.height / 4,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 30, 0, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //   height: MediaQuery.of(context).size.height / 6,
                                      //   child: Card(
                                      //       clipBehavior: Clip.antiAlias,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius: BorderRadius.circular(8.0),
                                      //       ),
                                      //       child: ClipRRect(
                                      //           borderRadius: BorderRadius.circular(8.0),
                                      //           child: Image.asset(AppImages.defaultImage))),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Get.to(SettingsScreen())
                                              .then((value) {
                                            print('back here');
                                            print(value);
                                            _conroller.getData();
                                          });
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(200.0),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        200.0),
                                                // border:
                                                //     Border.all(color: card_color, width: 2.0),
                                                // border:
                                              ),
                                              child:
                                                  _conroller.image.value
                                                          .isNullOrBlank
                                                      ? Image.network(
                                                          AppImages
                                                              .avtarImageUrl,
                                                          fit: BoxFit.cover,
                                                          // height: 100,
                                                          // width: 100,
                                                          loadingBuilder:
                                                              (BuildContext ctx,
                                                                  Widget child,
                                                                  ImageChunkEvent
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            } else {
                                                              return Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            200.0),
                                                                    border: Border.all(
                                                                        color:
                                                                            card_color,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                    ),
                                                                  ));
                                                            }
                                                          },
                                                        )
                                                      : Image.network(
                                                          APIUrls.ImageUrl +
                                                              _conroller
                                                                  .image.value,
                                                          fit: BoxFit.cover,
                                                          // height: 100,
                                                          // width: 100,
                                                          loadingBuilder:
                                                              (BuildContext ctx,
                                                                  Widget child,
                                                                  ImageChunkEvent
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null) {
                                                              return child;
                                                            } else {
                                                              return Container(
                                                                  height: 100,
                                                                  width: 100,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            200.0),
                                                                    border: Border.all(
                                                                        color:
                                                                            card_color,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                    ),
                                                                  ));
                                                            }
                                                          },
                                                        ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(
                                              () => Text(
                                                '${_conroller.name.value ?? ''}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${_conroller.email.value}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              width: Get.width / 1.7,
                                              child: Text(
                                                'last_update'.tr +
                                                    ' - ${_conroller.lastUpdate.value}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            // _conroller.address.isNotEmpty
                                            //     ? Text(
                                            //         'Address - ${_conroller.address.value}',
                                            //         style: TextStyle(
                                            //             fontSize: 14,
                                            //             fontWeight:
                                            //                 FontWeight.normal,
                                            //             color: Colors.white),
                                            //       )
                                            //     : Text(''),
                                            // _identityStatus(),
                                            // Row(
                                            //   children: [
                                            //     _identityStatus(),
                                            //     IconButton(
                                            //         icon: Icon(
                                            //           Icons.refresh,
                                            //           color: Colors.white,
                                            //         ),
                                            //         onPressed: () async {
                                            //           print('start');
                                            //           await checkConnectivityWihtoutMsg()
                                            //               .then((internet) {
                                            //             if (internet != null &&
                                            //                 internet) {
                                            //               _conroller.getData();
                                            //               _hospitalController
                                            //                   .getHospitalDataWithoutLoader()
                                            //                   .then((value) =>
                                            //                       _conroller
                                            //                           .checkLoginAuth());
                                            //             } else {
                                            //               _conroller
                                            //                   .getDatafromSqlite()
                                            //                   .then((value) =>
                                            //                       _conroller
                                            //                           .checkLoginAuth());
                                            //             }
                                            //           });
                                            //           print('stop');
                                            //         }),
                                            //   ],
                                            // ),
                                            SizedBox(
                                              height: 35,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, bottom: 5.0),
                                        child: FutureBuilder<String>(
                                          future: versionController
                                              .returnVersion(), // async work
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            return Text(
                                              '${'version'.tr} - ${snapshot.data}',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.italic,
                                                  color: Colors.white),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: primary_color,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0))),
                          ),
                          // Obx(()=>Text(_conroller.image.value)),
                          ListTile(
                            leading: _imageWidget(AppImages.patients_hospital),
                            title: Text('patient_hospital'.tr),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                            onTap: () {
                              Get.to(HospitalScreen());
                            },
                          ),

                          // FutureBuilder(
                          //     initialData: initalList,
                          //     future: sqlite.allOfflineData(),
                          //     builder: (context, AsyncSnapshot snapshot) {
                          //       List<PatientDetailsData> allData = snapshot?.data;
                          //
                          //       if(snapshot.data==null){
                          //         return SizedBox();
                          //       }
                          //       return  allData.isNullOrBlank?SizedBox():  ListTile(
                          //         leading:
                          //             Icon(Icons.warning_amber_outlined,color: Colors.red,),
                          //         title: Text("Sink Data (patient - ${allData.length})"),
                          //         // trailing: IconButton(
                          //         //   icon: Icon(Icons.arrow_forward_ios),
                          //         // ),
                          //         onTap: () {
                          //
                          //
                          //           askToSendData('')
                          //               .then((value) {
                          //             print('close popup with $value');
                          //             if (value == "YES") {
                          //               checkConnectivity().then((internet) {
                          //                 if (internet != null && internet) {
                          //
                          //                   sqlite.allOfflineData().then((value){
                          //                     // print('return list: ${jsonEncode(value[0].status)}');
                          //                     // print('return len: ${value[0].status.length}');
                          //                     // print('return type: ${jsonEncode(value[0].status[0].type)}');
                          //                     // print('return status: ${jsonEncode(value[0].status[0].status)}');
                          //                     // print('return score: ${jsonEncode(value[0].status[0].score)}');
                          //
                          //                     OfflineHandler _offlinehandler = OfflineHandler();
                          //                     showLoader();
                          //                     _offlinehandler.DataToServerMultiple(value).then((value){
                          //                       print('return res: $value');
                          //                       // ShowMsg('Your offline data sink successfully.');
                          //                       if(value =='success'){
                          //                         sqlite.clearPatientIds().then((r){
                          //
                          //                           Get.back();
                          //                           ShowMsg('Your offline data sink successfully.');
                          //                           setState(() {});
                          //
                          //                         });
                          //                       }
                          //
                          //                     });
                          //
                          //                   });
                          //
                          //                 }
                          //               });
                          //             }
                          //           });
                          //
                          //
                          //
                          //
                          //         },
                          //       );
                          //     }),

                          ListTile(
                            leading: _imageWidget(AppImages.bellIcon),
                            title: Text('notification'.tr),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                            onTap: () {
                              // print(fcm_controller.notification_list1.toString());
                              // print(_conroller.notification_list.toString());

                              // print('a...${gnotification_list.toString()}');

                              Get.to(NotificationScreen(
                                istoggle: _conroller.notificationn.value,
                                notif_list: notification_list,
                                // notif_list: [],
                              )).then((value) => _conroller.getData());
                            },
                          ),
                          // ListTile(
                          //   leading: Icon(
                          //     Icons.monetization_on_outlined,
                          //     color: primary_color,
                          //   ),
                          //   title: Text('subscription'.tr),
                          //   // trailing: IconButton(
                          //   //   icon: Icon(Icons.arrow_forward_ios),
                          //   // ),
                          //   onTap: () async {
                          //     var userId = await MySharedPreferences.instance
                          //         .getStringValue(Session.userid);
                          //     Get.to(EnterHospital(
                          //       userId: userId,
                          //       isFromLogin: false,
                          //     ));
                          //   },
                          // ),
                          // ListTile(
                          //   leading: _imageWidget(AppImages.historyClockIcon),
                          //   title: Text('subscription_history'.tr),
                          //   onTap: () {
                          //     print('GGG');
                          //     Get.to(Subscription_HistoryScreen());
                          //   },
                          //   // trailing: IconButton(
                          //   //   icon: Icon(Icons.arrow_forward_ios),
                          //   // ),
                          // ),

                          // ListTile(
                          //   leading: _imageWidget(AppImages.recommIcon),
                          //   title: Text('recommendations'.tr),
                          //   onTap: () async {
                          //     // var userid = await MySharedPreferences.instance
                          //     //     .getStringValue(Session.userid);
                          //     // Get.to(ActivateSubscription(
                          //     //   userId: userid,
                          //     //   // hospdata: data,
                          //     //   isFromLogin: false,
                          //     // ));
                          //   },
                          //   // trailing: IconButton(
                          //   //   icon: Icon(Icons.arrow_forward_ios),
                          //   // ),
                          // ),
                          ListTile(
                            leading: _imageWidget(AppImages.statIco),
                            title: Text('indicator'.tr),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                            onTap: () async {


                              Get.to(ChooseHospital());

                            },
                          ),
                          ListTile(
                            leading: _imageWidget(AppImages.settingsIcon),
                            title: Text('settings'.tr),
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                            onTap: () {
                              Get.to(SettingsScreen()).then((value) {
                                print('back here');
                                print(value);
                                _conroller.getData();
                              });
                            },
                          ),
                          ListTile(
                            leading: _imageWidget(AppImages.supportsIcon),
                            title: Text('supports'.tr),
                            onTap: () async{

                              SupportController controller = SupportController();

                              controller.callSupportFn(context);

                            },
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                          ),

                          ListTile(
                            leading: _imageWidget(AppImages.termsIcon),
                            title: Text('terms_policy'.tr),
                            onTap: () {

                              Get.to(WebViewScreen(title: 'terms_policy'.tr,url: 'terms_policy_url'.tr,));
                            },
                            // trailing: IconButton(
                            //   icon: Icon(Icons.arrow_forward_ios),
                            // ),
                          ),
                        ],
                      ),
                    )))
                : Loader(),
          )),
    );
  }

  Widget _imageWidget(path) {
    return SvgPicture.asset(
      path,
      color: primary_color,
      height: 20.0,
      width: 20.0,
    );
  }

  Widget _identityStatus() {
    return FutureBuilder(
        future: _hospitalController.isDocVerfied(),
        builder: (context, AsyncSnapshot snapshot) {
          int output = snapshot.data ?? 0;
          if (output == 1) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              color: Colors.orange,
              onPressed: () async {
                ShowMsg(
                    'verification_pending_wait_for_approval'.tr);
              },
              child: Text(
                'verification_pending'.tr,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            );
          } else if (output == 3 || output == 0) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              color: Colors.red,
              onPressed: () async {
                var userId = await MySharedPreferences.instance
                    .getStringValue(Session.userid);
                Get.to(Verification1(
                  userId: userId,
                ));
              },
              child: Text(
                'send_documents'.tr,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            );
          } else if (output == 2) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              color: Colors.green,
              onPressed: () async {},
              child: Text(
                'verified'.tr,
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            );
          }
          return SizedBox();
        });
  }

  void log_out() {
    _log_out_controller.logout();
  }
}

Future<void> sendNotification(token) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  print('token : $token');

  final data = {
    "notification": {
      "body": "Notification testing",
      "title": "Notification test"
    },
    "priority": "high",
    "data": {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done"
    },
    "to": "$token"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        'key=AAAAD5fycuE:APA91bFa2s3sSqW2iYn0_5nuxkFLxiyDg0lDEFGN4wwSwmm0WA7WTgT-w_x1_TwHmerRo6m1tTmy7Lw64LG2mSl1GnYO8wgSEPcldqXNXN80B8PQHrKlIncUsf4IhZtEHUo6SpLGu_Ga'
  };

  BaseOptions options = new BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    headers: headers,
  );

  try {
    final response = await Dio(options).post(postUrl, data: data);

    if (response.statusCode == 200) {
// Fluttertoast.showToast(msg: 'Request Sent To Driver');
    } else {
      print('notification sending failed');
// on failure do sth
    }
  } catch (e) {
    print('exception $e');
  }
}


