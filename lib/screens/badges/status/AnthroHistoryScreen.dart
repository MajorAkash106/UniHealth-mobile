import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/anthropometryController.dart';
import 'package:medical_app/model/AnthroHistoryModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class AnthroHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String type;
  final String HistorName;
  AnthroHistoryScreen({this.patientDetailsData, this.type, this.HistorName});
  @override
  _AnthroHistoryScreenState createState() => _AnthroHistoryScreenState();
}

class _AnthroHistoryScreenState extends State<AnthroHistoryScreen> {
  final AnthropometryController _controller = AnthropometryController();



  int Age;
  @override
  void initState() {
    // TODO: implement initState



    print(widget.patientDetailsData.dob);
    getAgeYearsFromDate(widget.patientDetailsData.dob).then((age){
      setState(() {
        Age = age;
      });
    });

    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHistory(
            widget.patientDetailsData.sId, widget.type);
        print('internet avialable');
      }
    });

    super.initState();
    refUnitStatus();
  }



  String refUnit = '';
  String weightIn = '';
  String heightIn = '';

  refUnitStatus() async {
    String refU = await MySharedPreferences.instance.getStringValue(Session.refUnit);
    setState(() {
      refUnit = refU.isNullOrBlank ? '1' : refU;

      weightIn = refUnit == '1' ? 'kg' : 'lbs';

      heightIn = refUnit == '1' ? 'm' : 'inch';
    });
    print('reference unit: ${refUnit}-${weightIn},${heightIn}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('${widget.HistorName}', null),
        body: Obx(
              () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: _controller.getHistoryData.map((element) {
                  return  refUnit =='1'?mainWidget(element):mainWidgetLBS(element);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget mainWidget(AnthroHistoryData e) {
    if(Age>=19) {
      return _widgetKG(e);
    }else{
      return _widgetForKidKG(e);
    }
  }

  Widget mainWidgetLBS(AnthroHistoryData e) {
    if(Age>=19) {
      return _widgetLBS(e);
    }else{
      return _widgetForKidLBS(e);
    }
  }



  getMAMCPerTitle(String mamc) {
    double total = double.parse(mamc);

    if (total < 70.0) {
      return 'severe_malnutrition'.tr;
    } else if (total >= 70.0 && total < 80.0) {
      return 'moderate_malnutrition'.tr;
    } else if (total >= 80.0 && total < 90.0) {
      return 'mild_malnutrition'.tr;
    } else if (total >= 90.0) {
      return 'eutrophic'.tr;
    }
  }


  getTypeHeightWeight(String val){
    if(val =='0'){
      return 'measured'.tr.toUpperCase();
    }else if (val == '1'){
      return 'reported'.tr.toUpperCase();
    }else if (val == '2'){
      return 'guessed'.tr.toUpperCase();
    }else if (val == '3'){
      return 'estimated'.tr.toUpperCase();
    }
  }

  Widget _widgetKG(AnthroHistoryData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.multipalmessage
                .map(
                    (e2) => Column(children: [
                      Row(
                        children: [
                          Text(
                            "${'weight'.tr.toUpperCase()} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.discountedWeight } kg (${getTypeHeightWeight(e2.weightType)}'
                                '${e2.edema =='' && e2.ascities=='' && e2.amputation==''?"":  '/${'after_discount'.tr.toUpperCase()}'})',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${'height'.tr.toUpperCase()} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            e2.heightType=='3'?     '${e2.estimatedHeight} cm (${getTypeHeightWeight(e2.heightType)})' : '${e2.heightMeasuredReported} cm (${getTypeHeightWeight(e2.heightType)})',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${'edema'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.edema.isNullOrBlank?0:e2.edema} kg',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${'ascites'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.ascities.isNullOrBlank?0:e2.ascities} kg',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${'amputation'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.amputation.isNullOrBlank?0:e2.amputation} kg',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "AMPUTATION  % - ",
                      //       style: TextStyle(fontSize: 15,color: primary_color),
                      //     ),
                      //     Text(
                      //       '${e2.amputationPer.isNullOrBlank?0:e2.amputation}%',
                      //       style: TextStyle(fontSize: 13),
                      //     ),
                      //   ],
                      // ),

                      Column(children: [
                        Row(
                          children: [
                            Text(
                              "${'ac'.tr} - ",
                              style: TextStyle(fontSize: 15,color: primary_color),
                            ),
                            Text(
                              '${e2.ac} cm',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${'muac'.tr} - ",
                              style: TextStyle(fontSize: 15,color: primary_color),
                            ),
                            Text(
                              e2.mUAC.isNullOrBlank?"missing".tr  :   '${e2.mUAC} cm',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${'calf_c'.tr} - ",
                              style: TextStyle(fontSize: 15,color: primary_color),
                            ),
                            Text(
                              '${e2.cALF} cm',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),

                      ],),
                      Column(children: [
                        Row(
                          children: [
                            Text(
                              "${'t_s_t'.tr}- ",
                              style: TextStyle(fontSize: 15,color: primary_color),
                            ),
                            Text(
                            e2.tST.isNullOrBlank?"missing".tr  :'${e2.tST} cm',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${'mamc_per'.tr} - ",
                              style: TextStyle(fontSize: 15,color: primary_color),
                            ),




                            e2.mamcper.isNull?SizedBox():

                            e2.tST.isNullOrBlank && e2.mUAC.isNullOrBlank?
                            Text(
                              "muac_tst_missing".tr,
                              // "(SWERE MALNUTRITION)",
                              style: TextStyle(fontSize: 13),
                            ):

                            e2.tST.isNullOrBlank?  Text(
                              "tst_missing".tr,
                              // "(SWERE MALNUTRITION)",
                              style: TextStyle(fontSize: 13),
                            ):
                            e2.mUAC.isNullOrBlank?  Text(
                              "muac_missing".tr,
                              // "(SWERE MALNUTRITION)",
                              style: TextStyle(fontSize: 13),
                            ):

                            getMAMCPerTitle(e2.mamcper).toString().length>25?
                            Row(children: [
                              Text(
                                "${e2.mamcper} (${getMAMCPerTitle(e2.mamcper).toString().substring(0,18)+'...'})",

                                style: TextStyle(
                                    fontSize:
                                    13),
                              ),
                              InkWell(
                                onTap: () {
                                  ShowTextONPopup(
                                      context, 'mamc_per'.tr, getMAMCPerTitle(e2.mamcper));
                                },
                                child: Container(
                                  // height: 15.0,
                                  width: 70.0,
                                  // color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "more".tr.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],)

                                :
                            Text(
                              "${e2.mamcper} (${getMAMCPerTitle(e2.mamcper)})",
                              // "(SWERE MALNUTRITION)",
                              style: TextStyle(fontSize: 13),
                            ),

                          ],
                        ),
                      ],),

                      e2.idealBodyWeight.isNullOrBlank?SizedBox():     Row(
                        children: [
                          Text(
                            "${'ideal_body_weight'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.idealBodyWeight} kg',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      e2.adjustedBodyWeight.isNullOrBlank?SizedBox():          Row(
                        children: [
                          Text(
                            "${'adjusted_body_weight'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.adjustedBodyWeight} kg',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),

                      e2.bmi.isNullOrBlank?   SizedBox() :    Row(
                        children: [
                          Text(
                            "${'bmi'.tr} - ",
                            style: TextStyle(fontSize: 15,color: primary_color),
                          ),
                          Text(
                            '${e2.bmi} kg/m\u{00B2}',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                  SizedBox(height: 5,)
                ],)
            )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                // '${timeago.format(DateTime.parse(e.updatedAt))}',
                getTimeAgo(e.updatedAt),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _widgetLBS(AnthroHistoryData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.multipalmessage
                .map(
                    (e2) => Column(children: [
                  Row(
                    children: [
                      Text(
                        "${'weight'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.discountedWeightLBS } lbs (${getTypeHeightWeight(e2.weightType)}'
                            '${e2.edema_LBS =='' && e2.ascities_LBS=='' && e2.amputation_LBS==''?"":  '/${'after_discount'.tr}'})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'height'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        e2.heightType=='3'?     '${e2.estimatedHeightInches} inches (${getTypeHeightWeight(e2.heightType)})' : '${e2.heightMeasuredReported_inch} m (${getTypeHeightWeight(e2.heightType)})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'edema'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.edema_LBS.isNullOrBlank?0:e2.edema_LBS} lbs',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'ascites'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.ascities_LBS.isNullOrBlank?0:e2.ascities_LBS} lbs',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'amputation'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.amputation_LBS.isNullOrBlank?0:e2.amputation_LBS} lbs',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "AMPUTATION  % - ",
                  //       style: TextStyle(fontSize: 15,color: primary_color),
                  //     ),
                  //     Text(
                  //       '${e2.amputationPer.isNullOrBlank?0:e2.amputation}%',
                  //       style: TextStyle(fontSize: 13),
                  //     ),
                  //   ],
                  // ),

                  Column(children: [
                    Row(
                      children: [
                        Text(
                          "${'ac'.tr} - ",
                          style: TextStyle(fontSize: 15,color: primary_color),
                        ),
                        Text(
                          '${e2.ac_inch} inches',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${'muac'.tr} - ",
                          style: TextStyle(fontSize: 15,color: primary_color),
                        ),
                        Text(
                          e2.MUAC_inch.isNullOrBlank?"missing".tr  :   '${e2.MUAC_inch} inches',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${'calf_c'.tr} - ",
                          style: TextStyle(fontSize: 15,color: primary_color),
                        ),
                        Text(
                          '${e2.CALF_inch} inches',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),

                  ],),
                  Column(children: [
                    Row(
                      children: [
                        Text(
                          "${'t_s_t'.tr}- ",
                          style: TextStyle(fontSize: 15,color: primary_color),
                        ),
                        Text(
                          e2.TST_inch.isNullOrBlank?"missing".tr  :'${e2.TST_inch} mm',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "${'mamc_per'.tr} - ",
                          style: TextStyle(fontSize: 15,color: primary_color),
                        ),




                        e2.mamcper.isNull?SizedBox():

                        e2.tST.isNullOrBlank && e2.mUAC.isNullOrBlank?
                        Text(
                          "muac_tst_missing".tr,
                          // "(SWERE MALNUTRITION)",
                          style: TextStyle(fontSize: 13),
                        ):

                        e2.tST.isNullOrBlank?  Text(
                          "tst_missing".tr,
                          // "(SWERE MALNUTRITION)",
                          style: TextStyle(fontSize: 13),
                        ):
                        e2.mUAC.isNullOrBlank?  Text(
                          "muac_missing".tr,
                          // "(SWERE MALNUTRITION)",
                          style: TextStyle(fontSize: 13),
                        ):

                        getMAMCPerTitle(e2.mamcper).toString().length>25?
                        Row(children: [
                          Text(
                            "${e2.mamcper} (${getMAMCPerTitle(e2.mamcper).toString().substring(0,18)+'...'})",

                            style: TextStyle(
                                fontSize:
                                13),
                          ),
                          InkWell(
                            onTap: () {
                              ShowTextONPopup(
                                  context, 'mamc_per'.tr, getMAMCPerTitle(e2.mamcper));
                            },
                            child: Container(
                              // height: 15.0,
                              width: 70.0,
                              // color: Colors.red,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "more".tr.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],)

                            :
                        Text(
                          "${e2.mamcper} (${getMAMCPerTitle(e2.mamcper)})",
                          // "(SWERE MALNUTRITION)",
                          style: TextStyle(fontSize: 13),
                        ),

                      ],
                    ),
                  ],),

                  e2.idealBodyWeightLBS.isNullOrBlank?SizedBox():     Row(
                    children: [
                      Text(
                        "${'ideal_body_weight'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.idealBodyWeightLBS} lbs',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  e2.adjustedBodyWeight.isNullOrBlank?SizedBox():          Row(
                    children: [
                      Text(
                        "${'adjusted_body_weight'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.adjustedBodyWeight} lbs',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  e2.bmi.isNullOrBlank?   SizedBox() :    Row(
                    children: [
                      Text(
                        "${'bmi'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.bmi} kg/m\u{00B2}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,)
                ],)
            )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                getTimeAgo(e.updatedAt),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }


  Widget _widgetForKidKG(AnthroHistoryData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.multipalmessage
                .map(
                    (e2) => Column(children: [
                  Row(
                    children: [
                      Text(
                        "${'weight'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        e2.weightType=='1'?     '${e2.estimatedWeight} kg (${'estimated'.tr})' : '${e2.weightMeasuredReported} kg (${'measured'.tr})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'height'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        e2.heightType=='1'?     '${e2.estimatedHeight} m (${'estimated'.tr})' : '${e2.heightMeasuredReported} m (${'measured'.tr})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),


                  e2.bmi.isNullOrBlank?   SizedBox() :    Row(
                    children: [
                      Text(
                        "${'bmi'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.bmi} kg/m',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,)
                ],)
            )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                getTimeAgo(e.updatedAt),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _widgetForKidLBS(AnthroHistoryData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.multipalmessage
                .map(
                    (e2) => Column(children: [
                  Row(
                    children: [
                      Text(
                        "${'weight'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        e2.weightType=='1'?     '${e2.estimatedWeightLBS} lbs (${'estimated'.tr})' : '${e2.weightMeasuredReportedLBS} lbs (${'measured'.tr})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "${'height'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        e2.heightType=='1'?     '${e2.estimatedHeightInches} inches (${'estimated'.tr})' : '${e2.heightMeasuredReported_inch} inches (${'measured'.tr})',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),


                  e2.bmi.isNullOrBlank?   SizedBox() :    Row(
                    children: [
                      Text(
                        "${'bmi'.tr} - ",
                        style: TextStyle(fontSize: 15,color: primary_color),
                      ),
                      Text(
                        '${e2.bmi} kg/m\u{00B2}',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,)
                ],)
            )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                getTimeAgo(e.updatedAt),

                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

}
