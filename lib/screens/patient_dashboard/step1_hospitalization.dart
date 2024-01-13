import 'dart:io';

import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/offline_func.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/config/widgets/schedule_next_evaluation.dart';
import 'package:medical_app/contollers/indicators/ns_config.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/WardListController.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/screens/home/hospitalization/add_patient_screen.dart';
import 'package:medical_app/screens/patient_dashboard/Update_PatientInfoScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/NT.dart';
import 'package:medical_app/screens/badges/Vigilance/vigiLance.dart';
import 'package:medical_app/screens/patient_dashboard/scheduled_for_today.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_item.dart';
import 'package:medical_app/screens/badges/palcare/pal_care.dart';
import 'package:medical_app/screens/badges/status/status.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../config/cons/timeago_format.dart';

class Step1HospitalizationScreen extends StatefulWidget {
  final String patientUserId;
  final int index;
  final int statusIndex;
  Step1HospitalizationScreen(
      {this.patientUserId, this.index, this.statusIndex});
  @override
  _Step1HospitalizationScreenState createState() =>
      _Step1HospitalizationScreenState();
}

class _Step1HospitalizationScreenState
    extends State<Step1HospitalizationScreen> {
  final PatientSlipController _controller = PatientSlipController();
  final Accessibility accessibility = Accessibility();
  int selectIndex = 0;
  List<Hospital> hospital = [];
  //RxList<PatientDetailsData> p_detail =[].obs;
  AgeDuration age;
  var actuala_age;
  bool isEditable = false;
  @override
  void initState() {
    setState(() {

      selectIndex = widget.index ?? 0;

    });
    // TODO: implement initState

    getHospitalIdfrom(widget.patientUserId).then((hospId) {
      if (hospId == null) {
        getData();
        print('getData running');
      } else {
        getData2(hospId);
        print('getData2 running');
      }
    });

    //  p_detail.assign(_controller.patientDetailsData[0]);

    super.initState();

    // getESPENRESULT(
    //     _controller.patientDetailsData[0]).then((value){
    //
    // });

  }





  getData() {
    final WardListController wardListController = WardListController();
    checkConnectivityWihtoutMsg().then((internet) {
      print('internet');

      if (internet != null && internet) {
        _controller
            .getDetails(widget.patientUserId, widget.statusIndex)
            .then((value) {

              DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");
          print(_controller.patientDetailsData[0].dob);
          // print('0077............>>>>${_controller.patientDetailsData[0].hospital[0].sId}');
          // print('0077............>>>>');

          DateTime today = DateTime.now(); //2020/1/24

          // Find out your age
          age = Age.dateDifference(
              fromDate: DateTime.parse(_controller.patientDetailsData[0].dob),
              toDate: today,
              includeToDate: false);

          print('Your age is $age');

          if (age.years < 19) {
            actuala_age =
                "${age.years} ${'years'.tr}, ${age.months} ${age.months > 1 ? "months".tr : 'month'.tr}";
          } else {
            actuala_age =
                "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} ${'years'.tr}" : "${age.years} ${'year'.tr}" : age.months != 0 ? age.months > 1 ? "${age.months} ${'months'.tr}" : "${age.months} ${'month'.tr}" : age.days > 1 ? "${age.days} ${'days'.tr}" : "${age.days} ${'day'.tr}"}";
          }

          //for new patient save wards beds
          wardListController.getWardDataWithoutLoader(_controller.patientDetailsData[0].hospital[0].sId);
        });
        print('internet avialable');
      } else {
        final OfflineHandler _offlineHandler = OfflineHandler();

        _offlineHandler.getPatientData(widget.patientUserId).then((value) {
          setState(() {
            _controller.patientDetailsData.clear();
            _controller.patientDetailsData.add(value);
            _controller.patientDetailsData[0].statusIndex =
                widget.statusIndex ?? 0;
            selectIndex = widget.index ?? 0;
          });

          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");
          print(_controller.patientDetailsData[0].dob);

          DateTime today = DateTime.now(); //2020/1/24

          // Find out your age
          age = Age.dateDifference(
              fromDate: DateTime.parse(_controller.patientDetailsData[0].dob),
              toDate: today,
              includeToDate: false);

          print('Your age is $age');

          if (age.years < 19) {
            actuala_age =
                "${age.years} ${'years'.tr}, ${age.months} ${age.months > 1 ? "months".tr : 'month'.tr}";
          } else {
            actuala_age =
                "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} ${'years'.tr}" : "${age.years} ${'year'.tr}" : age.months != 0 ? age.months > 1 ? "${age.months} ${'months'.tr}" : "${age.months} ${'month'.tr}" : age.days > 1 ? "${age.days} ${'days'.tr}" : "${age.days} ${'day'.tr}"}";
          }

          setState(() {});
        });
      }
    });
  }

  getData2(String hospId) async{
  await checkConnectivityWithToggle(hospId).then((internet) {
      print('internet === $internet');

      isEditable = internet;
      if (internet != null && internet) {
        _controller
            .getDetails(widget.patientUserId, widget.statusIndex)
            .then((value) {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");
          print(_controller.patientDetailsData[0].dob);

          DateTime today = DateTime.now(); //2020/1/24

          // Find out your age
          age = Age.dateDifference(
              fromDate: DateTime.parse(_controller.patientDetailsData[0].dob),
              toDate: today,
              includeToDate: false);

          print('Your age is $age');

          if (age.years < 19) {
            actuala_age =
                "${age.years} ${'years'.tr}, ${age.months} ${age.months > 1 ? "months".tr : 'month'.tr}";
          } else {
            actuala_age =
                "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} ${'years'.tr}" : "${age.years} ${'year'.tr}" : age.months != 0 ? age.months > 1 ? "${age.months} ${'months'.tr}" : "${age.months} ${'month'.tr}" : age.days > 1 ? "${age.days} ${'days'.tr}" : "${age.days} ${'day'.tr}"}";
          }
        });
        print('internet avialable');
      } else {
        final OfflineHandler _offlineHandler = OfflineHandler();
        _offlineHandler.getPatientData(widget.patientUserId).then((value) {
          setState(() {
            _controller.patientDetailsData.clear();
            _controller.patientDetailsData.add(value);
            _controller.patientDetailsData[0].statusIndex =
                widget.statusIndex ?? 0;
            selectIndex = widget.index ?? 0;
          });

          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");
          print(_controller.patientDetailsData[0].dob);

          DateTime today = DateTime.now(); //2020/1/24

          // Find out your age
          age = Age.dateDifference(
              fromDate: DateTime.parse(_controller.patientDetailsData[0].dob),
              toDate: today,
              includeToDate: false);

          print('Your age is $age');

          if (age.years < 19) {
            actuala_age =
                "${age.years} ${'years'.tr}, ${age.months} ${age.months > 1 ? "months".tr : 'month'.tr}";
          } else {
            actuala_age =
                "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} ${'years'.tr}" : "${age.years} ${'year'.tr}" : age.months != 0 ? age.months > 1 ? "${age.months} ${'months'.tr}" : "${age.months} ${'month'.tr}" : age.days > 1 ? "${age.days} ${'days'.tr}" : "${age.days} ${'day'.tr}"}";
          }

          setState(() {});
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: primary_color, // status bar color
    //   statusBarBrightness: Brightness.light,//status bar brightness
    //   statusBarIconBrightness:Brightness.light , //status barIcon Brightness
    // ));
    return WillPopScope(
        onWillPop: _willpopscope,
        child: Obx(
          () => _controller.patientDetailsData.isNullOrBlank?Scaffold(body: SizedBox(child: Center(child: CircularProgressIndicator(),),),): Scaffold(
            appBar: _appbarcontent(),
            // bottomNavigationBar: CommonHomeButton(),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                child: ListView(
                  children: [
                    Column(
                      children: [
                        // SizedBox(height: 20,),
                        Text(
                          _controller.patientDetailsData.isEmpty
                              ? ""
                              : "${_controller.patientDetailsData[0].name}, ${_controller.patientDetailsData[0].gender.toLowerCase().tr ?? ''}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        age == null
                            ? SizedBox()
                            : Text(
                                // age.years != 0
                                //     ? age.years > 1
                                //         ? "Age - ${age.years} years"
                                //         : "Age - ${age.years} year"
                                //     : age.months != 0
                                //         ? age.months > 1
                                //             ? "Age - ${age.months} months"
                                //             : "Age - ${age.months} month"
                                //         : age.days > 1
                                //             ? "Age - ${age.days} days"
                                //             : "Age - ${age.days} day",
                                "${'age'.tr} - $actuala_age",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _upperWidget(),
                    Container(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _tabcontentlist.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  print(index);
                                  setState(() {
                                    selectIndex = index;
                                    _controller
                                        .patientDetailsData[0].statusIndex = 0;
                                  });
                                },
                                child: new Column(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 26,
                                      backgroundColor: selectIndex != index
                                          ? black40_color
                                          : primary_color,
                                      child: CircleAvatar(
                                          radius: 25,
                                          backgroundColor: selectIndex != index
                                              ? card_color
                                              : primary_color,
                                          child: SvgPicture.asset(
                                            '${_tabcontentlist[index].imagepath}',height: _tabcontentlist[index].title.contains('Status')?30:22,
                                            color: selectIndex != index
                                                ? black40_color
                                                : selectIndex ==3?null :card_color,
                                          )),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    new Text(
                                      "${_tabcontentlist[index].title}"
                                          .toUpperCase(),
                                      style: new TextStyle(
                                          fontSize: 13,
                                          color: selectIndex != index
                                              ? black40_color
                                              : primary_color
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        )),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    _controller.patientDetailsData.isEmpty
                        ? SizedBox()
                        : Container(
                            // height: Get.height/1.9,
                            child: _selected_item[selectIndex](
                                _controller.patientDetailsData)),
                    // _selectedTabWidget(),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _appbarcontent() {
    return AppBar(
      brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
      title: InkWell( onTap: (){
        print('0077............>>>>${_controller.patientDetailsData[0].hospital[0].sId}');
      },
        child: Text(
          _controller.patientDetailsData.isEmpty
              ? ""
              : '${_controller.patientDetailsData[0].hospital[0].name}',
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: appbar_icon_color),
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: card_color,
      leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: _willpopscope,),

      iconTheme: IconThemeData(color: appbar_icon_color),
      actions: [
        // _controller.patientDetailsData.isNullOrBlank
        //     ? SizedBox()
        //     : FutureBuilder(
        //         future: IsOfflineDataAvailable(
        //             _controller.patientDetailsData[0].sId),
        //         builder: (context, AsyncSnapshot<bool> snapshot) {
        //           if (!snapshot.hasData) {
        //             return SizedBox();
        //           } else {
        //             return snapshot.data == null
        //                 ? SizedBox()
        //                 : !snapshot.data
        //                     ? SizedBox()
        //                     : Container(
        //                         //margin: EdgeInsets.only(right: 8.0,),
        //                         // color: Colors.red,
        //                         width: 60,
        //                         height: 30.0,
        //                         child: IconButton(
        //                           onPressed: () async {
        //                             askToSendData(_controller
        //                                     .patientDetailsData[0].sId)
        //                                 .then((value) {
        //                               print('close popup with $value');
        //                               if (value == "YES") {
        //                                 checkConnectivity().then((internet) {
        //                                   if (internet != null && internet) {
        //                                     // showLoader();
        //                                     // sendDataToServer(_controller.patientDetailsData[0].sId).then((value) {
        //                                     //   Get.back();
        //                                     //   print('updatedd');
        //                                     //   ShowMsg(
        //                                     //       'Your offline data sink successfully.');
        //                                     //   setState(() {});
        //                                     // });
        //
        //                                     SaveDataSqflite sqlite =
        //                                         SaveDataSqflite();
        //
        //                                     sqlite
        //                                         .allOfflineData()
        //                                         .then((value) {
        //                                       // print('return list: ${jsonEncode(value[0].status)}');
        //                                       // print('return len: ${value[0].status.length}');
        //                                       // print('return type: ${jsonEncode(value[0].status[0].type)}');
        //                                       // print('return status: ${jsonEncode(value[0].status[0].status)}');
        //                                       // print('return score: ${jsonEncode(value[0].status[0].score)}');
        //
        //                                       var data = value.firstWhere(
        //                                           (element) =>
        //                                               element.sId ==
        //                                               _controller
        //                                                   .patientDetailsData[0]
        //                                                   .sId);
        //
        //                                       print('particular data: $data');
        //
        //                                       OfflineHandler _offlinehandler =
        //                                           OfflineHandler();
        //                                       showLoader();
        //                                       _offlinehandler
        //                                           .DataToServerMultiple(
        //                                               [data]).then((value) {
        //                                         print('return res: $value');
        //                                         // ShowMsg('Your offline data sink successfully.');
        //                                         if (value == 'success') {
        //                                           sqlite
        //                                               .clearPatientId(data.sId)
        //                                               .then((r) {
        //                                             Get.back();
        //                                             ShowMsg(
        //                                                 'data_sink_successfully'.tr);
        //                                             setState(() {});
        //                                           });
        //                                         }
        //                                       });
        //                                     });
        //                                   }
        //                                 });
        //                               }
        //                             });
        //
        //                             // ShowMsg("This Patient's data exists in offline storage. wait for this, working on.");
        //                           },
        //                           icon: SvgPicture.asset(
        //                             AppImages.redCloud,
        //                             height: 25,
        //                           ),
        //                         ));
        //           }
        //         }),

        FutureBuilder(
            future: accessibility.getAccess(_controller.patientDetailsData[0].hospital[0].sId),
            initialData: null,
            builder: (context, snapshot) {
              AccessFeature access = snapshot?.data;

              access?.editPatient = isEditable;
              return access == null
                  ? SizedBox()
                  : IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: access?.editPatient ? Colors.black : disable_color,
                      ),
                      onPressed: () {
                        if (access.editPatient) {
                          // Get.to(Update_PatientInfo(
                          //   title: "Update_patient_info".tr,
                          //   patientDetail: _controller.patientDetailsData,
                          //   selectedHospital: _controller
                          //       .patientDetailsData[0].hospital[0].name,)
                          // );

                          Get.to(AddPatientScreen(
                            title:  "Update_patient_info".tr,
                            pData: _controller.patientDetailsData.first,
                            hospId: _controller.patientDetailsData.first.hospital[0].sId,
                            wardId: _controller.patientDetailsData.first.wardId.sId,
                            bedId: _controller.patientDetailsData.first.bedId.sId,
                            isEdit: true,
                          ));

                        }else{
                          ShowMsg('not_available_in_offline_mode'.tr);
                        }
                      });
            }),
        SizedBox(
          width: 10,
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.ac_unit,
        //   ),
        //   onPressed: () {
        //     SaveDataSqflite sqlite = SaveDataSqflite();
        //     sqlite.allOfflineData().then((value){
        //       print('return list: ${value}');
        //     });
        //   },
        // ),
      ],
      // bottom: PreferredSize(
      //   //Here is the preferred height.
      //     preferredSize: Size.fromHeight(30.0),
      //     child: SafeArea(
      //         child:Column(
      //           children: [
      //           Text(
      //             _controller.patientDetailsData.isEmpty?"":      "Patient's name - ${_controller.patientDetailsData[0].name}, ${_controller.patientDetailsData[0].gender??''}",
      //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      //         ),
      //             SizedBox(height: 5,),
      //        age==null?SizedBox():     Text(
      //               age.years!=0 ?
      //
      //               age.years>1?   "Age - ${age.years} years" : "Age - ${age.years} year"
      //                   :
      //               age.months!=0?
      //               age.months>1?      "Age - ${age.months} months":"Age - ${age.months} month"
      //                   :
      //               age.days>1?  "Age - ${age.days} days" : "Age - ${age.days} day"
      //               ,
      //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      //             ),
      //           ],
      //         )
      //     ))
    );
  }

  Widget _upperWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 5.0, right: 0.0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Flexible(
          //       flex: 3,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             side: BorderSide(width: 1, color: primary_color)),
          //         child: Padding(
          //           padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          //           child: Text(
          //             "${_controller.patientDetailsData[0].wardId.wardname??''}",
          //             style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14,color: primary_color),
          //           ),
          //         ),
          //       ),
          //     ),
          //
          //     Flexible(
          //       flex: 1,
          //       child: Card(
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.all(Radius.circular(10)),
          //             side: BorderSide(width: 1, color: primary_color)),
          //         child: Padding(
          //           padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          //           child: Text(
          //             "${_controller.patientDetailsData[0].bedId.bedNumber??''}",
          //             style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14,color: primary_color),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${'ward'.tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].wardId.wardname}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${'m__division'.tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].medicalId.division}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${'insurance'.tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].insurance ?? ''}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:(){
                            NSConfig config = NSConfig();
                            config.getPatientScreening(_controller.patientDetailsData[0]);
                          },
                          child: Text(
                            "${'hospitalized'.tr} - ",
                            style: TextStyle(color: primary_color, fontSize: 14),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                :
                                getTimeAgo(_controller.patientDetailsData[0].admissionDate),
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${'bed'.tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].bedId.bedNumber}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${'r_id'.tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].rId ?? ''}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${"hosp_id".tr} - ",
                          style: TextStyle(color: primary_color, fontSize: 14),
                        ),
                        Flexible(
                          child: Text(
                            _controller.patientDetailsData.isEmpty
                                ? ""
                                : '${_controller.patientDetailsData[0].hospitalId ?? ''}',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: InkWell(
                        child: SvgPicture.asset(
                          AppImages.calandar_blak,
                          color: primary_color,
                          height: 25,
                        ),
                        onTap: () {
                          print('index:${selectIndex}');
                          Get.to(ScheduledForToday(
                            patientId: _controller.patientDetailsData[0].sId,
                            patientDetailsData:
                                _controller.patientDetailsData[0],
                            isFromSlip: true,
                            index: selectIndex,
                            hospName: _controller
                                .patientDetailsData[0].hospital[0].name,
                            ward: _controller
                                .patientDetailsData[0].wardId.wardname,
                            //bed: _controller.patientDetailsData[0].bedId.bedNumber,
                            patient_Name:
                                _controller.patientDetailsData[0].name,
                            age: actuala_age.toString(),
                          ));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Future<bool> _willpopscope() async {
    // SaveDataSqflite sqflite = SaveDataSqflite();
    // sqflite.saveLastBadge(_controller.patientDetailsData[0].sId, selectIndex,_controller.patientDetailsData[0].statusIndex);
    next_evaluation(_controller.patientDetailsData, context);
  }

  List<Function> _selected_item = [
    (input) => DiagnosisItemScreen(
          patientDetailsData: input,
        ),
    (input) => Pal_CareScreen(
          patientDetailsData: input,
        ),
    (input) => Status(
          patientDetailsData: input,
        ),
        (input) => VIGILANCE(
      patientDetailsData: input,
    ),
    (input) => NT_TAB(
          patientDetailsData: input,

        ),

  ];

  List<tabcontent> _tabcontentlist = [
    tabcontent(title: 'diagnosis'.tr, imagepath: AppImages.diagnosisIcon),
    tabcontent(title: '${'pal_care'.tr} ', imagepath: AppImages.palcareIcon),
    tabcontent(title: '${'status'.tr}    ', imagepath: AppImages.human),
    tabcontent(title: 'vigilance'.tr, imagepath: AppImages.vigi2,),
    tabcontent(title: '${'n_t'.tr}            ', imagepath: AppImages.NTIcon),
  ];
}

class tabcontent {
  String title;
  String imagepath;
  tabcontent({this.title, this.imagepath});
}
