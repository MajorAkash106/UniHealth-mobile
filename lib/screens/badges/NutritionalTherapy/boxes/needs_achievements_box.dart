import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/NutritionalTherapy/75LessNT.dart';
import 'package:medical_app/contollers/NutritionalTherapy/LastNeedData.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/lessAchieveNeeds.dart' as n;
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/sinceAdmision_Controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/contollers/NutritionalTherapy/getCurrentNeed.dart';

class NeedsAchievements extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  NeedsAchievements({this.patientDetailsData});
  @override
  _NeedsAchievementsState createState() => _NeedsAchievementsState();
}

class _NeedsAchievementsState extends State<NeedsAchievements> {
  AbdomenController abdomController = AbdomenController();
  n.LessAchieveNeeds lessAchieveNeeds_cntrlr = n.LessAchieveNeeds();
  final NeedsController controller = NeedsController();
  final ParenteralNutrional_Controller parenteralNutrional_Controller = ParenteralNutrional_Controller();
  SinceAdmisionController sinceAdmision_Controller = SinceAdmisionController();
  LastNeedData lastNeedController = LastNeedData();
  LessNeedsData lessNeedsData = LessNeedsData();

  Sum_Of_protein_kacl sum_data;
  Sum_Of_protein_kacl sumOfCurrentDay;
  Sum_Of_protein_kacl sumofLastDay;
  Sum_Of_protein_kacl sumofLastPreviousDay;
  @override
  Widget build(BuildContext context) {

    print("widget.patientDetailsData.needs :: ${widget.patientDetailsData.needs}");

    return Container(
        height: 250,
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 5.0, left: 16.0),
                                child: InkWell(
                                  onTap: () async {
                                    // lessNeedsData.get75LessData(widget.patientDetailsData);
                                    abdomController.GIF_result(widget.patientDetailsData).then((value) {
                                      print("final result... ${jsonEncode(value.gif_result)}");
                                      print("final result... ${jsonEncode(value.gif_score)}");
                                    }
                                    );

                                  },
                                  child: Text(
                                    'needs_achievements'.tr,
                                    style: TextStyle(
                                      color: card_color,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              // Container(
                              //   //margin: EdgeInsets.only(right: 8.0,),
                              //   // color: Colors.red,
                              //   width: 60,
                              //   height: 30.0,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.end,
                              //     children: [
                              //       InkWell(
                              //         child: SvgPicture.asset(
                              //           AppImages.historyClockIcon,
                              //           color: card_color,
                              //           height: 20,
                              //         ),
                              //         onTap: () {
                              //           CurrentNeed _controller = CurrentNeed();
                              //           _controller.getCurrentNeed(widget.patientDetailsData);
                              //
                              //         },
                              //       ),
                              //       SizedBox(
                              //         width: 16.0,
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                              height: 183,
                              padding: EdgeInsets.only(bottom: 0),
                              child: ListView(
                                children: [
                                
                                  FutureBuilder(
                                      future:parenteralNutrional_Controller.getPercentOfNeedsData(widget.patientDetailsData, widget.patientDetailsData.hospital.first.sId),
                                      builder: (context,  snapshot)    {
                                        Needs_Show_Data data = snapshot.data;
                                        return snapshot.data == null
                                            ? SizedBox()
                                            : returnWidget(data,'${'planned_for_today'.tr} :');
                                      }),



                                  FutureBuilder(
                                      // future:  parenteralNutrional_Controller.getPercentOfNeedsLastData(widget.patientDetailsData,widget.patientDetailsData.hospital.first.sId,"lastDay"),
                                      future:  lastNeedController.getDataa(widget.patientDetailsData),

                                      builder: (context,
                                          AsyncSnapshot snapshot) {
                                        Needs_Show_Data data = snapshot.data;
                                        return snapshot.data == null
                                            ? SizedBox()
                                            : returnWidget(data,'${'last_work_day'.tr} :');
                                      }),


                                  FutureBuilder(


                                      future:sinceAdmision_Controller.getAdSince(widget.patientDetailsData),
                                      builder: (context,  snapshot)    {
                                        Needs_Show_Data data = snapshot.data;

                                        print('Since Admission ::$data');
                                        return snapshot.data == null
                                            ? SizedBox()
                                            : returnWidget(data,'${'since_admission'.tr} :');
                                      }),

                                  FutureBuilder(


                                      future:lessNeedsData.get75LessData(widget.patientDetailsData),
                                      builder: (context,  snapshot)    {
                                        PerLow data = snapshot.data;
                                        print('less data $data');
                                        return snapshot.data == null
                                            ? SizedBox()
                                            : Column(
                                          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${'day_less_than75_needs'.tr} :',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13.0),
                                            ),
                                            Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      'kcal'.tr,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 13.0),
                                                    ),
                                                    Text(
                                                      'protein'.tr,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 13.0),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      ':',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    Text(
                                                      ':',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      'min/max:',
                                                      style: TextStyle(
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13.0,
                                                      ),
                                                    ),
                                                    Text(
                                                      'min/max:',
                                                      style: TextStyle(
                                                        color:
                                                        Colors.black,
                                                        fontSize: 13.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // Text(
                                                        //   '${data.customized_min_kacl.toStringAsFixed(2) ?? ""}',
                                                        //   style: TextStyle(
                                                        //       color: Colors
                                                        //           .black,
                                                        //       fontSize:
                                                        //       15.0),
                                                        // ),
                                                        Text(
                                                          " (${data.kcalPerMin??""}%) ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              10.0),
                                                        ),
                                                        Text(
                                                          "/",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              13.0),
                                                        ),
                                                        // Text(
                                                        //   '${data.customized_max_kacl.toStringAsFixed(2) ?? ""}',
                                                        //   style: TextStyle(
                                                        //       color: Colors
                                                        //           .black,
                                                        //       fontSize:
                                                        //       15.0),
                                                        // ),
                                                        Text(
                                                          "(${data.kcalPerMax ?? ""}%)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              10.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        // Text(
                                                        //   '${data.customized_min_ptn.toStringAsFixed(2) ?? ""}',
                                                        //   style: TextStyle(
                                                        //       color: Colors
                                                        //           .black,
                                                        //       fontSize:
                                                        //       15.0),
                                                        // ),
                                                        Text(
                                                          "(${data.ptnPerMin??""}%)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              10.0),
                                                        ),
                                                        Text(
                                                          "/",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              13.0),
                                                        ),
                                                        // Text(
                                                        //   '${data.customized_max_ptn.toStringAsFixed(2) ?? ""}',
                                                        //   style: TextStyle(
                                                        //       color: Colors
                                                        //           .black,
                                                        //       fontSize:
                                                        //       15.0),
                                                        // ),
                                                        Text(
                                                          "(${data.ptnPerMax}%)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              10.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],);
                                      }),

                                  SizedBox(
                                    height: 5,
                                  ),
                                  // Text(
                                  //   'Days(%) since admission is < 75% of needs:',
                                  //   style: TextStyle(
                                  //       color: Colors.black,
                                  //       fontWeight: FontWeight.bold,
                                  //       fontSize: 15.0),
                                  // ),
                                  // SizedBox(
                                  //   height: 3,
                                  // ),
                                  // FutureBuilder(
                                  //     // future: controller
                                  //     //     .checkAchievementPercent(
                                  //     //         widget.patientDetailsData)
                                  //     //     .then((value) async {
                                  //     //   if (value != null) {
                                  //     //     if (value.ptn_achievement_data
                                  //     //                 .length !=
                                  //     //             null &&
                                  //     //         value.kcal_achievement_data
                                  //     //                 .length !=
                                  //     //             null) {
                                  //     //       sum_data = controller.get_sum(
                                  //     //           proteinList: value
                                  //     //               .ptn_achievement_data,
                                  //     //           kaclList: value
                                  //     //               .ptn_achievement_data);
                                  //     //       print(
                                  //     //           "===sum1 ${sum_data.planned_ptn_total_sum}");
                                  //     //       print(
                                  //     //           "===sum2 ${sum_data.achievemnt_protein_total_sum}");
                                  //     //       print(
                                  //     //           "===sum3 ${sum_data.planned_kacl_total_sum}");
                                  //     //       print(
                                  //     //           "===sum4 ${sum_data.achievemnt_kacl_total_sum}");
                                  //     //     } else {
                                  //     //       return null;
                                  //     //     }
                                  //     //   }
                                  //     // }),
                                  //     builder: (context,
                                  //         AsyncSnapshot snapshot) {
                                  //       // int kcl_total_percent;
                                  //       // int ptn_total_percent;
                                  //       //
                                  //       // if (sum_data != null) {
                                  //       //   kcl_total_percent =
                                  //       //       controller.getPercent(
                                  //       //           sum_data
                                  //       //               .achievemnt_kacl_total_sum,
                                  //       //           sum_data
                                  //       //               .planned_kacl_total_sum);
                                  //       //   ptn_total_percent =
                                  //       //       controller.getPercent(
                                  //       //           sum_data
                                  //       //               .achievemnt_protein_total_sum,
                                  //       //           sum_data
                                  //       //               .planned_ptn_total_sum);
                                  //       // }
                                  //       return sum_data == null
                                  //           ? SizedBox()
                                  //           : Row(
                                  //               children: [
                                  //                 Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Text(
                                  //                       'kcl',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0),
                                  //                     ),
                                  //                     Text(
                                  //                       'Protein',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: 3,
                                  //                 ),
                                  //                 Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Text(
                                  //                       ':',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .bold),
                                  //                     ),
                                  //                     Text(
                                  //                       ':',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .bold),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: 3,
                                  //                 ),
                                  //                 Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Text(
                                  //                       'min/max:',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0),
                                  //                     ),
                                  //                     Text(
                                  //                       'min/max:',
                                  //                       style: TextStyle(
                                  //                           color: Colors
                                  //                               .black,
                                  //                           fontSize: 16.0),
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //                 SizedBox(
                                  //                   width: 5,
                                  //                 ),
                                  //                 Column(
                                  //                   crossAxisAlignment:
                                  //                       CrossAxisAlignment
                                  //                           .start,
                                  //                   children: [
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           '${ ""}',
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           " (100%) ",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   10.0),
                                  //                         ),
                                  //                         Text(
                                  //                           "/",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           '',
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           "(${""}%)",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   10.0),
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           '${ ""}',
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           " (100%) ",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   10.0),
                                  //                         ),
                                  //                         Text(
                                  //                           "/",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           '${""}',
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   15.0),
                                  //                         ),
                                  //                         Text(
                                  //                           "(${""}%)",
                                  //                           style: TextStyle(
                                  //                               color: Colors
                                  //                                   .black,
                                  //                               fontSize:
                                  //                                   10.0),
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ],
                                  //             );
                                  //     }),
                                ],
                              )),
                        ),
                        widget.patientDetailsData?.needs == null || widget.patientDetailsData?.needs?.isEmpty
                            ? SizedBox()
                            : FutureBuilder(builder: (context, snapshot) {
                          String lastUpdate = DateFormat('yyyy-MM-dd')
                              .format(DateTime.parse(widget
                              .patientDetailsData
                              ?.needs
                              ?.first
                              ?.lastUpdate));
                          return Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "",
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 0),
                                child: Text(
                                  "${'last_update'.tr} - ${lastUpdate ?? ""}",
                                  style: TextStyle(
                                      color: primary_color,
                                      fontSize: 10),
                                ),
                              ),
                            ],
                          );
                        })
                      ])
                ])));
  }
  
  
  Widget returnWidget(Needs_Show_Data data,String text){
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
        '$text',
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13.0),
      ),
      Row(
        children: [
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                'kcal'.tr,
                style: TextStyle(
                    color: Colors
                        .black,
                    fontSize: 13.0),
              ),
              Text(
                'protein'.tr,
                style: TextStyle(
                    color: Colors
                        .black,
                    fontSize: 13.0),
              ),
            ],
          ),
          SizedBox(
            width: 3,
          ),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                ':',
                style: TextStyle(
                    color: Colors
                        .black,
                    fontSize: 13.0,
                    fontWeight:
                    FontWeight
                        .bold),
              ),
              Text(
                ':',
                style: TextStyle(
                    color: Colors
                        .black,
                    fontSize: 13.0,
                    fontWeight:
                    FontWeight
                        .bold),
              ),
            ],
          ),
          SizedBox(
            width: 3,
          ),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Text(
                'min/max:',
                style: TextStyle(
                  color:
                  Colors.black,
                  fontSize: 13.0,
                ),
              ),
              Text(
                'min/max:',
                style: TextStyle(
                  color:
                  Colors.black,
                  fontSize: 13.0,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .start,
            children: [
              Row(
                children: [
                  Text(
                    '${data.customized_min_kacl.toStringAsFixed(2) ?? ""}',
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    " (${data.min_kacl_perc??""}%) ",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        10.0),
                  ),
                  Text(
                    "/",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    '${data.customized_max_kacl.toStringAsFixed(2) ?? ""}',
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    "(${data.max_kacl_perc ?? ""}%)",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        10.0),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${data.customized_min_ptn.toStringAsFixed(2) ?? ""}',
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    "(${data.min_ptn_perc??""}%)",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        10.0),
                  ),
                  Text(
                    "/",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    '${data.customized_max_ptn.toStringAsFixed(2) ?? ""}',
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        13.0),
                  ),
                  Text(
                    "(${data.max_ptn_perc}%)",
                    style: TextStyle(
                        color: Colors
                            .black,
                        fontSize:
                        10.0),
                  ),
                ],
              ),
            ],
          ),
        ],
      )
    ],);
  }
  
}
