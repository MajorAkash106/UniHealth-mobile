import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/abdomen_summary_controller.dart';
import 'package:medical_app/contollers/vigilance/pressure_controller.dart';
import 'package:medical_app/contollers/vigilance/summary_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/circulation_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';

class VigiTitle extends StatefulWidget {
  final PatientDetailsData patientDetails;

  VigiTitle({this.patientDetails});

  @override
  _VigiTitleState createState() => _VigiTitleState();
}

class _VigiTitleState extends State<VigiTitle> {
  final Summary controller = Summary();
  final Temp_GlycemiaController temp_glycemiaController =
      Temp_GlycemiaController();
  final PressureController p_controller = PressureController();
  final AbdomenSummaryController abdomenSummary = AbdomenSummaryController();
  final AbdomenController _abdomenController = AbdomenController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // print(widget.patientDetailsData[0].dob);
          // getAgeYearsFromDate(
          //     widget.patientDetailsData[0].dob)
          //     .then((age) {
          //   print('patients age: $age');
          //   if (age >= 19) {
          //     Get.to(Anthropometery(
          //       patientDetailsData:
          //       widget.patientDetailsData[0],
          //       isFromAnthroTab: true,
          //     ));
          //   } else {
          //     Get.to(AnthropometeryKids(
          //       patientDetailsData:
          //       widget.patientDetailsData[0],
          //       isfromStatus: true,
          //     ));
          //   }
          // });
        },
        child: Container(
          height: 200,
          child: Card(
              color: card_color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(width: 1, color: primary_color)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, bottom: 8.0, left: 16.0),
                              child: Text(
                                'summary'.tr,
                                style: TextStyle(
                                  color: card_color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Get.to(AnthropometryHistory());
                                // Get.to(AnthroHistoryScreen(
                                //   patientDetailsData: widget
                                //       .patientDetailsData[0],
                                //   type: ConstConfig
                                //       .anthroHistory,
                                //   HistorName: 'History',
                                // ));
                              },
                              child: Container(
                                //margin: EdgeInsets.only(right: 8.0,),
                                // color: Colors.red,
                                width: 60,
                                height: 30.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        height: 130,
                        //color: Colors.red,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder(
                                    future: controller
                                        .getData(widget.patientDetails),
                                    initialData: null,
                                    builder: (context, snapshot) {
                                      List<String> data = snapshot.data;
                                      return data.isNullOrBlank
                                          ? SizedBox()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'fluid_balance'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15.0),
                                                ),
                                                Text(
                                                  '${data[0]}, ${data[1]}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12.0),
                                                )
                                              ],
                                            );
                                    },
                                  ),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  FutureBuilder(
                                    future: abdomenSummary.getResultSummary(
                                        widget.patientDetails),
                                    initialData: "",
                                    builder: (context, AsyncSnapshot snapshot) {
                                      print(
                                          'getting abdomenSummary ${snapshot.data}');

                                      String data = snapshot.data as String;
                                      return data == '' || data == null
                                          ? SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'abdomen'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15.0),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  '$data',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 12.0),
                                                )),
                                              ],
                                            );
                                    },
                                  ),
                                  SizedBox(
                                    height: 2.0,
                                  ),
                                  FutureBuilder(
                                    future: getCirculationData(
                                        widget.patientDetails),
                                    initialData: null,
                                    builder: (context, snapshot) {
                                      Vigilance data = snapshot?.data;
                                      CirculationData circulationdata =
                                          data == null
                                              ? null
                                              : data.result[0].circulaltiondata;

                                      if(circulationdata?.bloodPressor!=null){
                                        circulationdata.bloodPressor.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                                      }
                                      if(circulationdata?.vasopressor!=null){
                                        circulationdata.vasopressor.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                                      }

                                      return circulationdata.isNullOrBlank
                                          ? SizedBox()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'circulation'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15.0),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'last_map'.tr} : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                    circulationdata.bloodPressor
                                                            .isNullOrBlank
                                                        ? SizedBox()
                                                        : Text(
                                                            circulationdata
                                                                    .bloodPressor
                                                                    ?.first
                                                                    ?.map ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 12.0),
                                                          ),
                                                    Text(
                                                      " mmHg ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),

                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'vasopressors'.tr} : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                    circulationdata.vasopressor
                                                        .isNullOrBlank
                                                        ? SizedBox()
                                                        : Text(
                                                      circulationdata
                                                          .vasopressor ==
                                                          null
                                                          ? ""
                                                          :

                                                      circulationdata
                                                          .vasopressor.length>=2?'1_plus_drugs_in_use'.tr:    circulationdata
                                                          .vasopressor
                                                          .last
                                                          .drug

                                                          ??
                                                          "",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontWeight:
                                                          FontWeight
                                                              .normal,
                                                          fontSize: 12.0),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                    },
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  FutureBuilder(
                                    future: temp_glycemiaController
                                        .current_last_workingDay_data(
                                            widget.patientDetails),
                                    initialData: null,
                                    builder: (context, snapshot) {
                                      Temp_glyShowData_onBox data =
                                          snapshot.data;
                                      return data.isNullOrBlank ||
                                              data?.lastUpdate.isNullOrBlank
                                          ? SizedBox()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'temp_gly'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15.0),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'last_work_day'.tr} : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                    Text(
                                                      " Temp Δ (${data.temp_min_last ?? ""} min / ${data.temp_max_last ?? ""} max)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 85,
                                                    ),
                                                    Text(
                                                      "${'gly_'.tr} Δ (${data.gly_min_last ?? ""} min /${data.gly_max_last ?? ""} max)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'current_work_day'.tr} : ',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                    Text(
                                                      " Temp Δ (${data.temp_min_current ?? ""} min / ${data.temp_max_current ?? ""} max)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 85,
                                                    ),
                                                    Text(
                                                      "${'gly_'.tr} Δ (${data.gly_min_current ?? ""} min /${data.gly_max_current ?? ""} max)",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 12.0),
                                                    )
                                                  ],
                                                )
                                              ],
                                            );
                                    },
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  FutureBuilder(
                                    future: p_controller.getPressureUlcer(
                                        widget.patientDetails),
                                    initialData: null,
                                    builder: (context, snapshot) {
                                      Vigilance data = snapshot.data;
                                      var SUSPECTED = data
                                          ?.result?.first?.installedData
                                          ?.firstWhere(
                                              (element) =>
                                                  element.statusquestion ==
                                                  'SUSPECTED DEEP TISSUE INJURY',
                                              orElse: () => null);
                                      return data.isNullOrBlank
                                          ? SizedBox()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${'pressure_ulcer'.tr} : ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 15.0),
                                                ),
                                                data.isNullOrBlank
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: data
                                                                .result
                                                                .first
                                                                .installedData
                                                                .isNullOrBlank
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${'risk_braden'.tr}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${data.result.first.output}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        'installed'
                                                                            .tr,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                        '',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        '${data.result.first.output}',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.normal,
                                                                            fontSize: 12.0),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      )
                                                                    ],
                                                                  ),
                                                                  SUSPECTED
                                                                          .isNullOrBlank
                                                                      ? SizedBox()
                                                                      : Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 5),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                '${SUSPECTED.statusquestion}',
                                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 12.0),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                ],
                                                              ),
                                                      ),
                                              ],
                                            );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // widget.patientDetailsData[0].anthropometry
                  //     .isEmpty
                  //     ? SizedBox()
                  //     :
                  // Row(
                  //   mainAxisAlignment:
                  //   MainAxisAlignment
                  //       .spaceBetween,
                  //   children: [
                  //     Text(
                  //       "",
                  //       style:
                  //       TextStyle(fontSize: 15),
                  //     ),
                  //     Padding(
                  //       padding:
                  //       const EdgeInsets.only(
                  //           right: 10, bottom: 8),
                  //       child: Text(
                  //         "Last update - ",
                  //         style: TextStyle(
                  //             color: primary_color,
                  //             fontSize: 10),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              )),
        ));
  }
}
