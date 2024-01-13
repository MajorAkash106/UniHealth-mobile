import 'dart:convert';

import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/long_appbar.dart';
import 'package:medical_app/config/widgets/multi_text_fields.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/patient&hospital_controller/schdule_controller.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/schduleDataModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class ScheduledForToday extends StatefulWidget {
  final String patientId;
  final String hospName;
  final String patient_Name;
  final String gender;
  final String age;
  final String ward;
  final String bed;
  final bool isFromSlip;
  final int index;
  final PatientDetailsData patientDetailsData;
  ScheduledForToday(
      {this.patientId,
      this.hospName,
      this.gender,
      this.age,
      this.ward,
      this.bed,
      this.isFromSlip,this.index,
      this.patientDetailsData, this.patient_Name});
  @override
  _ScheduledForTodayState createState() => _ScheduledForTodayState();
}

class _ScheduledForTodayState extends State<ScheduledForToday> {
  final SchduleConroller _controller = SchduleConroller();
 // AgeDuration age;
  @override
  void initState() {
    // TODO: implement initState

    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getPatientDetails(widget.patientId).then((value) {
          getSchduleData();
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");
          print(_controller.patientDetailsData[0].dob);

          DateTime today = DateTime.now(); //2020/1/24

          // Find out your age
          // age = Age.dateDifference(
          //     fromDate: DateTime.parse(_controller.patientDetailsData[0].dob),
          //     toDate: today,
          //     includeToDate: false);

          //print('Your age is $age');
        });
        print('internet avialable');
      }else{
        final OfflineHandler _offlineHandler = OfflineHandler();
        _offlineHandler.getPatientData(widget.patientId).then((value) {
          _controller.patientDetailsData.clear();
          _controller.patientDetailsData.add(value);
          setState(() {});
          getSchduleData();
          DateFormat dateFormat = DateFormat("yyyy-MM-dd");
          var currentdate = dateFormat.format(DateTime.now());
          print("currentdate : $currentdate");



        });

      }
    });
    // checkConnectivity().then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     _controller.getData(widget.patientId);
    //     print('internet avialable');
    //   }
    // });
    super.initState();
  }

  Future getdata()async{
   var data_list = await _controller.patientDetailsData;

  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  StatusData NRSData;
  StatusData MUSTData;
  StatusData STRONGKID;

  getSchduleData() {
    for (var a = 0; a < _controller.patientDetailsData[0].status.length; a++) {
      var data = _controller.patientDetailsData[0].status[a];

      if (data.type == '0' && data.status.trim() == 'NRS - 2002'.trim()) {
        print('next schduleDate: ${data.result[0].nextSchdule}');
        setState(() {
          NRSData = data;
        });

        break;
      }
    }

    for (var a = 0; a < _controller.patientDetailsData[0].status.length; a++) {
      var data = _controller.patientDetailsData[0].status[a];

      if (data.type == '0' && data.status.trim() == 'MUST'.trim()) {
        print('next schduleDate: ${data.result[0].nextSchdule}');
        setState(() {
          MUSTData = data;
        });

        break;
      }
    }


    for (var a = 0; a < _controller.patientDetailsData[0].status.length; a++) {
      var data = _controller.patientDetailsData[0].status[a];

      print('data.status:${data.status}');
      if (data.type == '0' && data.status.removeAllWhitespace == 'STRONG-KIDS'.removeAllWhitespace) {
        print('strong next schduleDate: ${data.result[0].nextSchdule}');
        setState(() {
          STRONGKID = data;
        });

        break;
      }
    }

  }

  getNRS(int score) {
    if (score == 0) {
      return "no_nt_risk_detected".tr;
    } else if (score >= 3) {
      return "nt_risk".tr;
    } else {
      //ask to client
      return "no_nt_risk_detected".tr;
    }
  }

  Future<bool> _willpopscope() async{
    print('---------');
    if (widget.isFromSlip) {
      Get.to(Step1HospitalizationScreen(
        index: widget.index??0,statusIndex: widget.patientDetailsData.statusIndex??0,
        patientUserId: _controller.patientDetailsData[0].sId,
      ));
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
        child: Scaffold(
          appBar: _appbarcontent(),
          // bottomNavigationBar: CommonHomeButton(),
          body:
          // FutureBuilder(builder:(context , snapshot){
          //   // Checking if future is resolved or not
          //   if (snapshot.connectionState == ConnectionState.done) {
          //     // If we got an error
          //     if (snapshot.hasError) {
          //       return Center(
          //         child: Text(
          //           '${snapshot.error} occured',
          //           style: TextStyle(fontSize: 18),
          //         ),
          //       );
          //
          //       // if we got our data
          //     } else if (snapshot.hasData) {
          //       // Extracting data from snapshot object
          //       final data = snapshot.data as String;
          //       return Center(
          //         child: Text(
          //           '$data',
          //           style: TextStyle(fontSize: 18),
          //         ),
          //       );
          //     }
          //   }
          //   return Center(child: CircularProgressIndicator(),);
          //
          // },
          // future:  getdata(),
          //
          // )

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        "${'scheduled_for_today'.tr} ",
                        style:
                        TextStyle(color: appbar_icon_color, fontSize: 19),
                      ),
                      Text(
                        "(${dateFormat.format(DateTime.now())})",
                        style: TextStyle(color: primary_color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  (NRSData==null || NRSData.result[0].nextSchdule.isEmpty) && (MUSTData==null || MUSTData.result[0].nextSchdule.isEmpty)  && (STRONGKID==null || STRONGKID.result[0].nextSchdule.isEmpty)
                      ? SizedBox():
                  Text(
                    'status'.tr,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: appbar_icon_color),
                  ),
                  Expanded(
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0,),
                              Row(
                                children: [
                                  // SizedBox(
                                  //   width: 20.0,
                                  // ),
                                  // NRSData == null && MUSTData == null
                                  //     ? SizedBox()
                                  //     :
                                  //     // NRSData.result[0].nextSchdule.isEmpty &&    NRSData.result[0].nextSchdule.isEmpty? SizedBox() :
                                  //
                                  //     NRSData.result ==null && MUSTData.result==null
                                  //         ? SizedBox()
                                  //         :

                                  // (NRSData==null || NRSData.result[0].nextSchdule.isEmpty) && (MUSTData==null || MUSTData.result[0].nextSchdule.isEmpty)
                                  //     ? SizedBox():
                                  // Text(
                                  //         'Status',
                                  //         style: TextStyle(
                                  //             fontSize: 16,
                                  //             fontWeight: FontWeight.w500,
                                  //             color: appbar_icon_color),
                                  //       ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  // NRSData == null && MUSTData == null
                                  //     ? SizedBox()
                                  //     :
                                  //     // NRSData.result[0].nextSchdule.isEmpty &&    NRSData.result[0].nextSchdule.isEmpty? SizedBox() :
                                  //
                                  // NRSData.result ==null && MUSTData.result==null
                                  //         ? SizedBox()
                                  //         :

                                  (NRSData==null || NRSData.result[0].nextSchdule.isEmpty) //&& (MUSTData==null || MUSTData.result[0].nextSchdule.isEmpty)
                                      ? SizedBox():


                                  Container(
                                    height: 120.0,
                                    width: Get.width/1.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        border: Border.all()),

                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            NRSData == null
                                                ? SizedBox()
                                                : NRSData.result[0]
                                                .nextSchdule.isEmpty
                                                ? SizedBox()
                                                : NRS(),
                                            // MUSTData.result[0].nextSchdule
                                            //         .isNotEmpty
                                            //     ? SizedBox(
                                            //         height: 10,
                                            //       )
                                            //     : SizedBox(),
                                            // MUSTData == null
                                            //     ? SizedBox()
                                            //     : MUSTData.result[0]
                                            //             .nextSchdule.isEmpty
                                            //         ? SizedBox()
                                            //         : MUST()
                                          ],
                                        )),
                                  ),
                                  SizedBox(width: 10.0,),
                                  (MUSTData==null || MUSTData.result[0].nextSchdule.isEmpty)?SizedBox():
                                  Container(
                                    height: 120.0,
                                    width: Get.width/1.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        border: Border.all()),

                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // NRSData == null
                                            //     ? SizedBox()
                                            //     : NRSData.result[0]
                                            //     .nextSchdule.isEmpty
                                            //     ? SizedBox()
                                            //     : NRS(),
                                            MUSTData.result[0].nextSchdule
                                                .isNotEmpty
                                                ? SizedBox(
                                              //height: 10,
                                            )
                                                : SizedBox(),
                                            MUSTData == null
                                                ? SizedBox()
                                                : MUSTData.result[0]
                                                .nextSchdule.isEmpty
                                                ? SizedBox()
                                                : MUST()
                                          ],
                                        )),
                                  ),

                                  SizedBox(width: 10.0,),
                                  (STRONGKID==null || STRONGKID.result[0].nextSchdule.isEmpty)?SizedBox():
                                  Container(
                                    height: 120.0,
                                    width: Get.width/1.3,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                        border: Border.all()),

                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            // NRSData == null
                                            //     ? SizedBox()
                                            //     : NRSData.result[0]
                                            //     .nextSchdule.isEmpty
                                            //     ? SizedBox()
                                            //     : NRS(),
                                            STRONGKID.result[0].nextSchdule
                                                .isNotEmpty
                                                ? SizedBox(
                                              //height: 10,
                                            )
                                                : SizedBox(),
                                            STRONGKID == null
                                                ? SizedBox()
                                                : STRONGKID.result[0]
                                                .nextSchdule.isEmpty
                                                ? SizedBox()
                                                : STRONGKIDS()
                                          ],
                                        )),
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _willpopscope));
  }

  Widget NRS() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${NRSData.status} (${'last_update'.tr} ${dateFormat.format(DateTime.parse(NRSData.result[0].lastUpdate))})',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.0,),
        Text(
          '${'previous'.tr} ${NRSData.status} - ${getNRS(int.parse(NRSData.score))},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'new_screening_needed'.tr},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'scheduled_for'.tr} ${dateFormat.format(DateTime.parse(NRSData.result[0].nextSchdule))}',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }



  getMUST(int score){

    if(score == 0){
      return "low_risk".tr;
    }else if(score ==1){
      return "medium_risk".tr;
    }else if(score>=2){
      //ask to client
      return "high_risk".tr;
    }


  }


 getSTRONGKIDS(int score){

    if(score == 0){
      return "low_risk".tr;
    }else if(score <=3){
      return "medium_risk".tr;
    }else if(score>3 && score <=5){
      //ask to client
      return "high_risk".tr;
    }


  }

  Widget STRONGKIDS() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${STRONGKID.status} (${'last_update'.tr} ${dateFormat.format(DateTime.parse(STRONGKID.result[0].lastUpdate))})',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.0,),
        Text(
          '${'previous'.tr} ${STRONGKID.status} - ${getSTRONGKIDS(int.parse(STRONGKID.score))},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'new_screening_needed'.tr},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'scheduled_for'.tr} ${dateFormat.format(DateTime.parse(STRONGKID.result[0].nextSchdule))}',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget MUST() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${MUSTData.status} (${'last_update'.tr} ${dateFormat.format(DateTime.parse(MUSTData.result[0].lastUpdate))})',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 5.0,),
        Text(
          '${'previous'.tr} ${MUSTData.status} - ${getMUST(int.parse(MUSTData.score))},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'new_screening_needed'.tr},',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          '${'scheduled_for'.tr} ${dateFormat.format(DateTime.parse(MUSTData.result[0].nextSchdule))}',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _appbarcontent() {
    return AppBar(
        title: Text(widget.hospName.toString(),
         // "${_controller.patientDetailsData.isNotEmpty?_controller.patientDetailsData[0].hospital[0].name:''}",
          style: TextStyle(
              color: card_color, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: primary_color,
        iconTheme: IconThemeData(color: card_color),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.info_outline,
        //       color: card_color,
        //     ),
        //     onPressed: () {
        //       Get.to(ReferenceScreen());
        //       // print(_controller.patientDetailsData[0].dob);
        //       // getAgeFromDate(_controller.patientDetailsData[0].dob).then((value){
        //       //   print('return age: $value');
        //       // });
        //     },
        //   )
        // ],
        bottom: PreferredSize(
            //Here is the preferred height.
            preferredSize: Size.fromHeight(30.0),
            child: SafeArea(
                child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${widget.patient_Name.toString()}",
                     // "${_controller.patientDetailsData.isNotEmpty?_controller.patientDetailsData[0].name:''}, ${_controller.patientDetailsData.isNotEmpty?_controller.patientDetailsData[0].gender:''}, "

                     // "${age ==null?'':age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}",
                      style: TextStyle(color: card_color),
                    ),
                    SizedBox(width: 5,),
                    Text(widget.age.toString(),style: TextStyle(color: card_color),)
                    // Text(  "${widget.age ==null?'________':age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}",
                    // style: TextStyle(color: age==null?Colors.transparent:card_color),
                    // ),
                  ],
                ),
                Text(
                  "${_controller.patientDetailsData.isNotEmpty?_controller.patientDetailsData[0].wardId.wardname:''}, ${_controller.patientDetailsData.isNotEmpty?_controller.patientDetailsData[0].bedId.bedNumber:''}",
                  style: TextStyle(color:_controller.patientDetailsData.isEmpty?Colors.transparent:card_color),
                ),
                SizedBox(
                  height: 10,
                ),
                // SizedBox(height: 5,),
              ],
            ))));
  }
}
