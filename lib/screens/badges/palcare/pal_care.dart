import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/palcare/akps_screen.dart';
import 'package:medical_app/screens/badges/palcare/goals_agreement.dart';

import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';
import 'package:medical_app/screens/badges/palcare/goal_history.dart';
import 'package:medical_app/screens/badges/palcare/Spict_Screen.dart';


class Pal_CareScreen extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  Pal_CareScreen({this.patientDetailsData});
  @override
  _Pal_CareScreenState createState() => _Pal_CareScreenState();
}

class _Pal_CareScreenState extends State<Pal_CareScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.patientDetailsData.isEmpty
        ? SizedBox()
        : page1(
            patientDetailsData: widget.patientDetailsData,
          );
  }
}

class page1 extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  page1({this.patientDetailsData});

  @override
  _page1State createState() => _page1State();
}

class _page1State extends State<page1> {
  String akpsPer;
  String lastUpdate;

  String spictStatus;
  String SpictlastUpdate;

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  List<AKPSData> goalData = [];
  String goalastupdate;
  @override
  void initState() {
    // TODO: implement initState

    if (widget.patientDetailsData[0]?.palcare.isEmpty) {
    } else {
      for (var i = 0; i < widget.patientDetailsData[0]?.palcare.length; i++) {
        if (widget.patientDetailsData[0]?.palcare[i].palcare == "goals") {
          setState(() {
            goalData = widget.patientDetailsData[0]?.palcare[i].goals;
            goalastupdate = widget.patientDetailsData[0]?.palcare[i].lastUpdate;
          });
          break;
        }
      }

      for (var i = 0; i < widget.patientDetailsData[0]?.palcare.length; i++) {
        if (widget.patientDetailsData[0]?.palcare[i].palcare == "akps") {
          setState(() {
            akpsPer = widget.patientDetailsData[0]?.palcare[i].akps.persentage;
            lastUpdate = widget.patientDetailsData[0]?.palcare[i].lastUpdate;
          });
          break;
        }
      }

      for (var i = 0; i < widget.patientDetailsData[0]?.palcare.length; i++) {
        if (widget.patientDetailsData[0]?.palcare[i].palcare == "spict") {
          setState(() {
            spictStatus = widget.patientDetailsData[0]?.palcare[i].status;
            SpictlastUpdate =
                widget.patientDetailsData[0]?.palcare[i].lastUpdate;
          });
          break;
        }
      }
    }

    super.initState();
  }

  Accessibility accessibility = Accessibility();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: accessibility.getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? Center(child: CircularProgressIndicator(),)
              : Column(
                  children: [
                    Container(
                      height: 200,
                      child: InkWell(
                        onTap: () {
                          if (access.palCare) {
                            Get.to(Goals_agreement(
                              patientDetailsData: widget.patientDetailsData,
                            ));
                          }
                        },
                        child: Card(
                          elevation: 0,
                          color: access.palCare ? card_color : disable_color,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(width: 1, color: primary_color)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary_color,
                                    // border: Border.all(
                                    //   color: Colors.red[340],
                                    // ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, top: 8.0, bottom: 8.0),
                                      child: Text(
                                        'goals'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(GoalHistoryScreen(
                                          patientDetailsData:
                                              widget.patientDetailsData[0],
                                          HistorName: "goals_history".tr,
                                          type: ConstConfig.goalHistory,
                                        ));
                                      },
                                      child: Container(
                                        //margin: EdgeInsets.only(right: 8.0,),
                                        //color: Colors.red,
                                        width: 70,
                                        height: 30.0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.historyClockIcon,
                                              color: card_color,
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: 16.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                  child: SingleChildScrollView(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: goalData
                                        .map(
                                          (e) => Text(
                                            "${goalData.indexOf(e) + 1}. ${e.optionname}"
                                                .trim(),
                                            style: TextStyle(),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              )),
                              goalastupdate != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Text(
                                            "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(goalastupdate))}",
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: Get.width / 1.9,
                            child: InkWell(
                              child: Card(
                                  color: akpsPer != null
                                      ? int.parse(akpsPer) > 40
                                          ? greenBG_color
                                          : redBG_color
                                      : card_color,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      side: BorderSide(
                                          width: 1, color: primary_color)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 10, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Get.to(AKPSHistory());
                                                      Get.to(DiagnosisHistory(
                                                        type: ConstConfig
                                                            .akpsHistory,
                                                        HistorName:
                                                            "akps_history".tr,
                                                        patientDetailsData: widget
                                                            .patientDetailsData[0],
                                                      ));
                                                    },
                                                    child: Container(
                                                      //margin: EdgeInsets.only(right: 8.0,),
                                                      // color: Colors.red,
                                                      width: 40,
                                                      height: 30.0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppImages
                                                                .historyClockIcon,
                                                            color:
                                                                black40_color,
                                                            height: 20,
                                                          ),
                                                          // SizedBox(width: 16.0,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: Get.height / 15,
                                            ),
                                            Center(
                                              child: Text(

                                                akpsPer==null?  "${'akps'.tr}" :

                                                "${'akps'.tr} - ${akpsPer ?? 0}%",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 18,
                                                    color: akpsPer != null
                                                        ? int.parse(akpsPer) > 40
                                                            ? greenTxt_color
                                                            : redTxt_color
                                                        : Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      lastUpdate != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, bottom: 8),
                                                  child: Text(
                                                    "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(lastUpdate))}",
                                                    style: TextStyle(
                                                        color: primary_color,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                      // SizedBox(height: 1,),
                                    ],
                                  )),
                              onTap: () {
                                if (access.palCare) {
                                  Get.to(Akps_screen(
                                    patientDetailsData:
                                        widget.patientDetailsData,
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                            height: Get.width / 1.9,
                            child: InkWell(
                              child: Card(
                                  color:
                                  spictStatus ==null?card_color:
                                  spictStatus == 'Negative'
                                      ? greenBG_color
                                      : redBG_color,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      side: BorderSide(
                                          width: 1, color: primary_color)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 5, 10, 0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      // Get.to(SpictHistory());
                                                      Get.to(GoalHistoryScreen(
                                                        patientDetailsData: widget
                                                            .patientDetailsData[0],
                                                        HistorName:
                                                            "spict_history".tr,
                                                        type: ConstConfig
                                                            .spictHistory,
                                                      ));

                                                      // Get.to(DiagnosisHistory(patientDetailsData: widget.patientDetailsData[0],HistorName: "SPICT History",type: ConstConfig.spictHistory,));
                                                    },
                                                    child: Container(
                                                      //margin: EdgeInsets.only(right: 8.0,),
                                                      //color: Colors.red,
                                                      width: 40,
                                                      height: 30.0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          SvgPicture.asset(
                                                            AppImages
                                                                .historyClockIcon,
                                                            color:
                                                                black40_color,
                                                            height: 20,
                                                          ),
                                                          // SizedBox(width: 16.0,)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: Get.height / 15,
                                            ),
                                            Center(
                                              child: Text(
          spictStatus ==null?"spict".tr:

                                                "${'spict'.tr} - ${"${spictStatus??'none'}".toLowerCase().tr ?? 'none'.tr}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16.5,
                                                    color:
                                                    spictStatus==null?Colors.black:
                                                    spictStatus == 'Negative'
                                                        ? greenTxt_color
                                                        : redTxt_color),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SpictlastUpdate != null
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, bottom: 8),
                                                  child: Text(
                                                    "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(SpictlastUpdate))}",
                                                    style: TextStyle(
                                                        color: primary_color,
                                                        fontSize: 10),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  )),
                              onTap: () {
                                if (access.palCare) {
                                  Get.to(SPICTScreen(
                                    patientDetailsData:
                                        widget.patientDetailsData[0],
                                  ));
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
        });
  }
}
