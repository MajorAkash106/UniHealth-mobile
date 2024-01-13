import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/patient&hospital_controller/WardListController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/hospital_list_controller.dart';
import 'package:medical_app/contollers/hospitalization_controller/newHospController.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/screens/home/patients&hospitals/patients_list.dart';
import 'package:medical_app/screens/home/patients&hospitals/wards.dart';
import 'package:medical_app/screens/login&Sigup/registeration/enter_hospital.dart';
import 'package:medical_app/screens/login&Sigup/registeration/verify_statusScreen.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../config/cons/timeago_format.dart';


class HospitalScreen extends StatefulWidget {
  @override
  _HospitalScreenState createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final HospitalController2 _hospitalController = HospitalController2();
  final HospitalSqflite sqflite = HospitalSqflite();
  bool isLoading = false;
  Future<bool> _willpopScope() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _hospitalController.getFromSqflite();
  }

  var pullToRefresh = GlobalKey<RefreshIndicatorState>();
  Future<String> onRefresh() async {
    pullToRefresh.currentState?.show();
    print('on refresh');
    await Future.delayed(Duration(
      seconds: 3,
    ));
    checkConnectivityWihtoutMsg().then((internet) {
      print('internet');
      if (internet != null && internet) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _hospitalController.getHospitalDataWithoutLoader();
        });

        print('internet avialable');
      } else {
        _hospitalController.getFromSqflite();
      }
    });

    return null;
  }
  //fegfgegert
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              leading: Icon(null),
            //   actions: [
            //     IconButton(icon: Icon(Icons.add), onPressed: ()async{
            //       var userId = await MySharedPreferences.instance.getStringValue(Session.userid);
            //       Get.to(EnterHospital(
            //         userId: userId,
            //         isFromLogin: false,
            //       ));
            //     })
            // ],
              title: Text(
                'hospitals'.tr,
                style: TextStyle(color: card_color),
              ),
              centerTitle: true,
              elevation: 1,
              backgroundColor: primary_color,
              iconTheme: IconThemeData(color: card_color),
            ),
            bottomNavigationBar: CommonHomeButton(),
            body: RefreshIndicator(
              key: pullToRefresh,
              onRefresh: onRefresh,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Obx(
                      () => Expanded(
                        child: Container(
                          child: ListView.builder(
                            itemCount: _hospitalController.hospitalList.length,
                            itemBuilder: (context, index) => Column(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    // print(_hospitalController
                                    //     .hospitalList[index].sId);
                                    //
                                    // int verify_status =
                                    //     await _hospitalController
                                    //             .employeddVerification(
                                    //                 _hospitalController
                                    //                     .hospitalList[index]
                                    //                     .sId) ??
                                    //         0;
                                    // int identityStatus = await _hospitalController.isDocVerfied() ?? 0;
                                    // bool isExpired = await _hospitalController.isExpiredSubscription(_hospitalController.hospitalList[index].sId) ?? true;
                                    // print(' is expired ${isExpired}');
                                    //
                                    //
                                    // if (!isExpired && verify_status == 2 && identityStatus == 2) {

                                      if (_hospitalController
                                          .hospitalList[index].istoggle) {
                                        checkConnectivity().then((internet) {
                                          if (internet != null && internet) {
                                            print('with internet');
                                            Get.to(WardScreen(
                                              id: _hospitalController
                                                  .hospitalList[index].sId,
                                              hospName: _hospitalController
                                                  .hospitalList[index].name,
                                              hospId: _hospitalController
                                                  .hospitalList[index].sId,
                                            ));
                                          }
                                        });
                                      } else {
                                        sqflite
                                            .getWards(_hospitalController
                                                .hospitalList[index].sId)
                                            .then((resp) {
                                          if (resp != null) {
                                            Get.to(WardScreen(
                                              id: _hospitalController
                                                  .hospitalList[index].sId,
                                              hospName: _hospitalController
                                                  .hospitalList[index].name,
                                              hospId: _hospitalController
                                                  .hospitalList[index].sId,
                                            ));
                                          } else {
                                            DATADOESNOTEXIST();
                                          }
                                        });
                                      }
                                    // } else {
                                    //   print('else condition executed');
                                    //   print('identityStatus condition ${identityStatus}');
                                    //   print('verify_status condition ${verify_status}');
                                    //
                                    //   if (identityStatus == 1) {
                                    //     ShowMsg('identity_verification_pending'.tr);
                                    //   } else if (identityStatus == 3) {
                                    //     ShowMsg('Sorry! Your Identity verification is rejected. please send again your documents');
                                    //   } else if (verify_status == 1) {
                                    //     ShowMsg('Sorry! Your Employee verification is in pending. please wait for approval.');
                                    //   } else if (verify_status == 3) {
                                    //     ShowMsg('Sorry! Your Employee verification is rejected. please send again yor documents');
                                    //   }
                                    // }
                                  },
                                  child: Card(
                                    color: card_color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        side: BorderSide(
                                            width: 1, color: primary_color)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: primary_color,
                                              // border: Border.all(
                                              //   color: Colors.red[340],
                                              // ),
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(15.0),
                                                  topRight:
                                                      Radius.circular(15.0))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                _hospitalController
                                                    .hospitalList[index].name,
                                                style: TextStyle(
                                                  color: card_color,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 0, 12),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'hospital_group'.tr +' - ',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      '${_hospitalController.hospitalList[index].hospitalgroup}',
                                                      style: TextStyle(
                                                          color: primary_color,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: (){
                                                      print("_hospitalController.hospitalList[index].istoggle :: ${_hospitalController.hospitalList[index].istoggle}");

                                                      bool get = _hospitalController.hospitalList[index].istoggle??false;
                                                      print("passing val from outside");
                                                      if(get){

                                                        onSwitch(index, false);
                                                      }else{
                                                        onSwitch(index, true);
                                                      }

                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 20,top: 0,),
                                                      // width: 50.0,
                                                      // height: 25.0,
                                                      // color: Colors.amber,
                                                      child: FlutterSwitch(
                                                      width: 50.0,
                                                      height: 25.0,
                                                      activeColor: primary_color,
                                                      valueFontSize: 12.0,
                                                      toggleSize: 18.0,
                                                      value: _hospitalController
                                                          .hospitalList[index]
                                                          .istoggle ??
                                                          false,
                                                      onToggle: (val) async {
                                                        print("passing val : $val");
                                                 await onSwitch(index, val);
                                                      },
                                                    ),),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'phone'.tr+' - ',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _hospitalController
                                                          .hospitalList[index]
                                                          .phone??'',
                                                      style: TextStyle(
                                                          color: primary_color,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                 InkWell(
                                                   onTap: (){
                                                     print("_hospitalController.hospitalList[index].istoggle :: ${_hospitalController.hospitalList[index].istoggle}");

                                                     bool get = _hospitalController.hospitalList[index].istoggle??false;
                                                     print("passing val from outside");
                                                     if(get){

                                                       onSwitch(index, false);
                                                     }else{
                                                       onSwitch(index, true);
                                                     }

                                                   },
                                                   child: Container(
                                                     padding: EdgeInsets.only(left: 20,top: 0,),
                                                     // width: 50.0,
                                                     // height: 25.0,
                                                     // color: Colors.amber,
                                                     child:  Text(
                                                     '${_hospitalController.hospitalList[index].istoggle ? "Online" : "Offline"}',
                                                     style: TextStyle(
                                                         color: _hospitalController
                                                             .hospitalList[
                                                         index]
                                                             .istoggle
                                                             ? primary_color
                                                             : black40_color,
                                                         fontSize: 15),
                                                   ),),
                                                 ),
                                                  SizedBox(
                                                    width: 10,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'number'.tr+' - ',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    _hospitalController
                                                        .hospitalList[index]
                                                        .number,
                                                    style: TextStyle(
                                                        color: primary_color,
                                                        fontSize: 15),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    'city_state'.tr+' - ',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "${_hospitalController.hospitalList[index].city},${_hospitalController.hospitalList[index].state}",
                                                      style: TextStyle(
                                                          color: primary_color,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'country'.tr+' - ',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      _hospitalController
                                                          .hospitalList[index]
                                                          .country,
                                                      style: TextStyle(
                                                          color: primary_color,
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        final NewHospController
                                                            _controller =
                                                            NewHospController();
                                                        print(_hospitalController
                                                                .hospitalList[
                                                            index]);

                                                        Hospital _hospital =
                                                            Hospital();
                                                        _hospital.sId =
                                                            _hospitalController
                                                                .hospitalList[
                                                                    index]
                                                                .sId;
                                                        _hospital.name =
                                                            _hospitalController
                                                                .hospitalList[
                                                                    index]
                                                                .name;

                                                        _controller
                                                            .getWardDataWithoutLoader(
                                                                _hospitalController
                                                                    .hospitalList[
                                                                        index]
                                                                    .sId);
                                                        _controller
                                                            .getMedicalData(
                                                                [_hospital]);

                                                        checkConnectivity()
                                                            .then((internet) {
                                                          if (internet !=
                                                                  null &&
                                                              internet) {
                                                            setState(() {
                                                              _hospitalController
                                                                  .hospitalList[
                                                                      index]
                                                                  .onTap = true;
                                                            });

                                                            final WardListController
                                                                _controller =
                                                                WardListController();
                                                            _controller
                                                                .getWardDataWithoutLoader(
                                                                    _hospitalController
                                                                        .hospitalList[
                                                                            index]
                                                                        .sId)
                                                                .then((value) {
                                                              _hospitalController
                                                                  .hospitalList[
                                                                      index]
                                                                  .onTap = false;
                                                              // ShowMsg("${_hospitalController.hospitalList[index].name}'s updated data synchronized with offline database.");
                                                              setState(() {});
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: Stack(
                                                        children: [
                                                          CircleAvatar(
                                                              radius: 18,
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              child: Center(
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .green,
                                                                  radius: 16,
                                                                  child:
                                                                      new Icon(
                                                                    Icons
                                                                        .file_download,
                                                                    // size: 50.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              )),
                                                          _hospitalController
                                                                  .hospitalList[
                                                                      index]
                                                                  .onTap
                                                              ? CircularProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .grey,
                                                                )
                                                              : SizedBox()
                                                        ],
                                                      )),
                                                  SizedBox(
                                                    width: 20,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  // reSubscribe(
                                                  //     _hospitalController
                                                  //         .hospitalList[index]
                                                  //         .sId),
                                                  SizedBox(),
                                                  FutureBuilder(
                                                      future: sqflite.getWards(
                                                          _hospitalController
                                                              .hospitalList[
                                                                  index]
                                                              .sId),
                                                      initialData: null,
                                                      builder: (context,
                                                          AsyncSnapshot
                                                              snapshot) {
                                                        WardList data =
                                                            snapshot?.data ??
                                                                null;
                                                        return data?.lastSync
                                                                .isNullOrBlank
                                                            ? SizedBox()
                                                            : Row(
                                                                children: [
                                                                  Text(
                                                                    'last_sync'.tr+' - ',
                                                                    style: TextStyle(
                                                                        color:
                                                                            black40_color,
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Text(

                                                                        getTimeAgo(data.lastSync)

                                                                        +
                                                                        '     ',
                                                                    style: TextStyle(
                                                                        color:
                                                                            primary_color,
                                                                        fontSize:
                                                                            12),
                                                                  )
                                                                ],
                                                              );
                                                      })
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        width: Get.width,
                        child: CustomButton(
                          text: "patient_list".tr,
                          myFunc: ()async {

                            // int identityStatus = await _hospitalController.isDocVerfied() ?? 0;
                            // if (identityStatus == 2) {
                              Get.to(PatientListScreen());
                            // } else {
                            //   if (identityStatus == 1) {
                            //     ShowMsg('identity_verification_pending'.tr);
                            //   } else if (identityStatus == 3) {
                            //     ShowMsg('verification_rejected_msg'.tr);
                            //   }
                            // }

                          },
                        )),
                    // SizedBox(height: 20,),
                  ],
                ),
              ),
            )),
        onWillPop: _willpopScope);
  }


  onSwitch(int index,bool val)async{
    _hospitalController
        .hospitalList[index]
        .istoggle = val;

    print(
        'user wants ${val ? 'online' : 'offline'} journey within ${_hospitalController.hospitalList[index].name}');

    await sqflite
        .getHospitals()
        .then((value) {
      print(
          'json resp: ${jsonEncode(value)}');

      // var selectedData = value.data.firstWhere((element) => element.sId == _hospitalController.hospitalList[index].sId,orElse: ()=>null);

      for (var a
      in value.data) {
        if (a.sId ==
            _hospitalController
                .hospitalList[
            index]
                .sId) {
          a.istoggle = val;

          print(
              'json data: ${jsonEncode(a)}');

          break;
        }
      }

      sqflite.saveHospitals(
          value);
    });

    setState(() {});
  }


  Widget reSubscribe(String HospId) {
    return FutureBuilder(
        future: _hospitalController.employeddVerification(HospId),
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
                // var userId = await MySharedPreferences.instance.getStringValue(Session.userid);
                // Get.to(VerifyStatus(
                //   userId: userId, isFromLogin: false, hospId:HospId,
                // ));
                // _hospitalController.employeddVerification(HospId);
              },
              child: Text(
                'Verification Pending',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            );
          } else if (output == 2) {
            //accepetd
            // return SizedBox();
            return FutureBuilder(
                future: _hospitalController.isExpiredSubscription(HospId),
                builder: (context, AsyncSnapshot snapshot) {
                  bool output = snapshot.data ?? true;
                  if (output) {
                    return RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 0,
                      color: Colors.red,
                      onPressed: () async {
                        var userId = await MySharedPreferences.instance
                            .getStringValue(Session.userid);
                        // Get.to(EnterHospital(
                        //   userId: userId,
                        //   isFromLogin: false,hospId:HospId ,
                        // ));
                      },
                      child: Text(
                        'Activate Subscription',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    );
                  }
                  return SizedBox();
                });
          } else if (output == 3 || output == 0) {
            return RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0,
              color: Colors.orange,
              onPressed: () async {
                var userId = await MySharedPreferences.instance
                    .getStringValue(Session.userid);
                Get.to(VerifyStatus(
                  userId: userId,
                  isFromLogin: false,
                  hospId: HospId,
                ));
              },
              child: Text(
                'Send Documents',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            );
          }
          return SizedBox();
        });
  }
}
