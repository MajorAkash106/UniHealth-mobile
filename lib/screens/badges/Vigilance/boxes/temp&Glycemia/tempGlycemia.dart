import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/Temp_gly_historyDash.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_glycemia_sheet.dart';


class tempGlycemia extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  tempGlycemia({this.patientDetailsData,this.access});
  @override
  _tempGlycemiaState createState() => _tempGlycemiaState();
}

class _tempGlycemiaState extends State<tempGlycemia> {

  final Temp_GlycemiaController temp_glycemiaController = Temp_GlycemiaController();
  Temp_glyShowData_onBox temp_glyShowData_onBox = Temp_glyShowData_onBox();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,

          child: FutureBuilder(
              future: temp_glycemiaController.current_last_workingDay_data(widget.patientDetailsData),//getONS(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Temp_glyShowData_onBox temp_glyShowData_onBox = snapshot.data;



                return InkWell(
                  onTap: ()async{
                    // if(widget.access) {
                    // Get.to(ons_acceptance(
                    //     patientDetailsData: widget.patientDetailsData,
                    //     ntdata: data));
                    // }

                    Get.to(TempGlycemiaSheet(patientDetailsData: widget.patientDetailsData,));

                  },
                  child:  Card(
                    // color:widget.access? card_color : disable_color,
                      color: card_color ,
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 16.0),
                                      child: Text(
                                        'temp_gly_box'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: ()async {
                                        Get.to(Temp_Gly_HistoryDash(patientDetailsData: widget.patientDetailsData,));
                                        // temp_glyShowData_onBox = await temp_glycemiaController.current_last_workingDay_data(widget.patientDetailsData);
                                        // Get.to(conditionHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'History',type: ConstConfig.ONSAcceptanceHistory,));
                                      },
                                      child: Container(
                                        //margin: EdgeInsets.only(right: 8.0,),
                                        //color: Colors.red,
                                        width: 60,
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
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              temp_glyShowData_onBox.isNullOrBlank|| temp_glyShowData_onBox.lastUpdate.isNullOrBlank?SizedBox():
                              Padding(padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${'last_work_day'.tr} : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // SizedBox(height: 5.0,),

                                    Row(
                                      children: [
                                        SizedBox(width: 5.0,),
                                        Text("∆"),
                                        SizedBox(width: 5.0,),
                                        Text('${'gly_'.tr} :'),SizedBox(width: 5.0,),
                                        temp_glyShowData_onBox.isNullOrBlank?Text('0'):    Text("${double.parse(temp_glyShowData_onBox.gly_min_last).toInt().toString()}",
                                          style: TextStyle(color:gly_color(double.parse(temp_glyShowData_onBox.gly_min_last).toInt())  ),),
                                        Text(' mg/dL',style: TextStyle(color: gly_color(double.parse(temp_glyShowData_onBox.gly_min_last).toInt())),),
                                        SizedBox(width: 3.0,),
                                        Text('min'),
                                        SizedBox(width: 2.0,),
                                        Text('/'),
                                        SizedBox(width: 2.0,),
                                        temp_glyShowData_onBox.isNullOrBlank?Text('0'):
                                        Text("${double.parse(temp_glyShowData_onBox.gly_max_last).toInt().toString()}",
                                          style: TextStyle(color:gly_color(double.parse(temp_glyShowData_onBox.gly_max_last).toInt())  ),),
                                        Text(' mg/dL',style: TextStyle(color: gly_color(double.parse(temp_glyShowData_onBox.gly_max_last).toInt())),),

                                        SizedBox(width: 3.0,),
                                        Text('max'),
                                       // SizedBox(width: 20.0,),


                                      ],
                                    ),
                                    SizedBox(height: 2.0,),
                                    Row(children: [
                                      SizedBox(width: 5.0,),
                                      Text("∆"),
                                      SizedBox(width: 5.0,),
                                      Text('Temp :'),SizedBox(width: 5.0,),
                                      temp_glyShowData_onBox.isNullOrBlank?Text('0'):    //Text(temp_glyShowData_onBox.temp_lastDay??"h"),Text('°C')
                                      Text(
                                        //double.parse(temp_glyShowData_onBox.temp_min_last??'0.0')==double.parse(temp_glyShowData_onBox.temp_max_last??'0.0')?'0':
                                          temp_glyShowData_onBox.temp_min_last??"0"),
                                      Text('°C'),
                                      SizedBox(width: 3.0,),
                                      Text('min'),
                                      SizedBox(width: 2.0,),
                                      Text('/'),
                                      SizedBox(width: 2.0,),
                                      temp_glyShowData_onBox.isNullOrBlank?Text('0'):Text(temp_glyShowData_onBox.temp_max_last??"0"),
                                      Text('°C'),
                                      SizedBox(width: 3.0,),
                                      Text('max'),
                                    ],),

                                    SizedBox(height: 5.0,),
                                    Text("${'current_work_day'.tr} : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                    // SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        SizedBox(width: 5.0,),
                                        Text("∆"),
                                        SizedBox(width: 5.0,),
                                        Text('${'gly_'.tr} :'),SizedBox(width: 5.0,),
                                        temp_glyShowData_onBox.isNullOrBlank?Text('0'):    Text("${double.parse(temp_glyShowData_onBox.gly_min_current).toInt().toString()}",
                                          style: TextStyle(color:gly_color(double.parse(temp_glyShowData_onBox.gly_min_current).toInt())  ),),
                                        Text(' mg/dL',style: TextStyle(color: gly_color(double.parse(temp_glyShowData_onBox.gly_min_current).toInt())),),
                                        SizedBox(width: 3.0,),
                                        Text('min'),
                                        SizedBox(width: 2.0,),
                                        Text('/'),
                                        SizedBox(width: 2.0,),
                                        temp_glyShowData_onBox.isNullOrBlank?Text('0'): Text("${double.parse(temp_glyShowData_onBox.gly_max_current).toInt().toString()}",
                                          style: TextStyle(color:gly_color(double.parse(temp_glyShowData_onBox.gly_max_current).toInt())  ),),
                                        Text(' mg/dL',style: TextStyle(color: gly_color(double.parse(temp_glyShowData_onBox.gly_max_current).toInt())),),

                                        SizedBox(width: 3.0,),
                                        Text('max'),
                                        // SizedBox(width: 20.0,),


                                      ],
                                    ),
                                    SizedBox(height: 2.0,),

                                    Row(children: [
                                      SizedBox(width: 5.0,),
                                      Text("∆"),
                                      SizedBox(width: 5.0,),
                                      Text('Temp :'),SizedBox(width: 5.0,),
                                      temp_glyShowData_onBox.isNullOrBlank?Text('0'):     //Text(temp_glyShowData_onBox.temp_currentDay??"h"),Text('°C'),
                                      Text(
                                        //double.parse(temp_glyShowData_onBox.temp_min_current??'0.0')==double.parse(temp_glyShowData_onBox.temp_max_current??'0.0')?'0':
                                          temp_glyShowData_onBox.temp_min_current??""),Text('°C'),
                                      SizedBox(width: 3.0,),
                                      Text('min'),
                                      SizedBox(width: 2.0,),
                                      Text('/'),
                                      SizedBox(width: 2.0,),
                                      temp_glyShowData_onBox.isNullOrBlank?Text('0'):Text(temp_glyShowData_onBox.temp_max_current??"") ,Text('°C'),
                                      SizedBox(width: 3.0,) ,
                                      Text('max'),

                                    ],)


                                  ],),
                              )
                              // data==null?SizedBox():  Padding(
                              //   padding:
                              //   const EdgeInsets.only(left: 10),
                              //   child: Column(
                              //     mainAxisAlignment:
                              //     MainAxisAlignment.start,
                              //     crossAxisAlignment:
                              //     CrossAxisAlignment.start,
                              //     children: [
                              //       Text(
                              //         ' ${data?.result?.first?.condition}'
                              //             .toUpperCase(),
                              //         style: TextStyle(
                              //             color: Colors.black,
                              //             fontWeight:
                              //             FontWeight.normal,
                              //             fontSize: 15.0),
                              //       ),
                              //
                              //       Row(
                              //         children: [
                              //           Text(
                              //             ' NT Team',
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontWeight:
                              //                 FontWeight.bold,
                              //                 fontSize: 15.0),
                              //           ),
                              //           SizedBox(
                              //             width: 10,
                              //           ),
                              //           Text(
                              //             '${data?.result?.first?.teamAgree?"Agree":"Dis-Agree"}',
                              //             style: TextStyle(
                              //                 color: Colors.black,
                              //                 fontSize: 13.0),
                              //           ),
                              //         ],
                              //       ),
                              //
                              //       SizedBox(
                              //         height: 5,
                              //       ),
                              //
                              //       Text(
                              //         ' ${data?.result?.first?.volume} ml ${data?.result?.first?.times}x per day',
                              //         style: TextStyle(color: Colors.black, fontSize: 13.0),),
                              //
                              //
                              //       Row(children: [
                              //
                              //         Row(
                              //           children: [
                              //             Text(
                              //               ' kCal',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight:
                              //                   FontWeight.bold,
                              //                   fontSize: 15.0),
                              //             ),
                              //             SizedBox(
                              //               width: 10,
                              //             ),
                              //             Text(
                              //               '${data?.result?.first?.kcal}; ',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 13.0),
                              //             ),
                              //           ],
                              //         ),
                              //         SizedBox(
                              //           width: 2,
                              //         ),
                              //         Row(
                              //           children: [
                              //             Text(
                              //               ' Ptn',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight:
                              //                   FontWeight.bold,
                              //                   fontSize: 15.0),
                              //             ),
                              //             SizedBox(
                              //               width: 10,
                              //             ),
                              //             Text(
                              //               '${data?.result?.first?.ptn}; ',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 13.0),
                              //             ),
                              //           ],
                              //         ),
                              //         SizedBox(
                              //           width: 2,
                              //         ),
                              //         Row(
                              //           children: [
                              //             Text(
                              //               ' Fiber',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontWeight:
                              //                   FontWeight.bold,
                              //                   fontSize: 15.0),
                              //             ),
                              //             SizedBox(
                              //               width: 10,
                              //             ),
                              //             Text(
                              //               '${data?.result?.first?.fiber};',
                              //               style: TextStyle(
                              //                   color: Colors.black,
                              //                   fontSize: 13.0),
                              //             ),
                              //           ],
                              //         ),
                              //
                              //       ],)
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          temp_glyShowData_onBox.isNullOrBlank||  temp_glyShowData_onBox.lastUpdate.isNullOrBlank?SizedBox():
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${'last_update'.tr} - "
                                      '${temp_glyShowData_onBox.lastUpdate??""}',
                                  style: TextStyle(
                                      color: primary_color,
                                      fontSize: 10),
                                ),
                              ],),
                          )
                          //
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       "",
                          //       style: TextStyle(fontSize: 15),
                          //     ),
                          //     FutureBuilder(
                          //         future: getDateFormatFromString(
                          //             temp_glyShowData_onBox.lastUpdate??""),
                          //         initialData: "Loading text..",
                          //         builder: (BuildContext context,
                          //             AsyncSnapshot<String> snapshota) {
                          //           return snapshota.data == null
                          //               ? SizedBox()
                          //               : Padding(
                          //             padding: const EdgeInsets.only(
                          //                 right: 10, bottom: 8),
                          //             child: Text(
                          //               "Last update - "
                          //                   '${snapshota.data}',
                          //               style: TextStyle(
                          //                   color: primary_color,
                          //                   fontSize: 10),
                          //             ),
                          //           );
                          //         })
                          //   ],
                          // ),
                        ],
                      )),);
              }),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }


  Color gly_color(int value){
    if(value>180||value<=70){
      return
        Colors.red;
    }
    else{
      return
        Colors.green;
    }
  }

}

