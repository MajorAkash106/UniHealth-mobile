import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/circulation_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/Circulation/circulationHistory_Dash.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/Circulation/circulation_sheet.dart';

class circulation extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;

  circulation({this.patientDetailsData, this.access});

  @override
  _circulationState createState() => _circulationState();
}

class _circulationState extends State<circulation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,

          child: FutureBuilder(
              future: getCirculationData(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Vigilance data = snapshot?.data;
                CirculationData circulationdata = data == null ? null : data.result[0].circulaltiondata;


                return InkWell(
                  onTap: () async {
                    // if(widget.access) {
                    // Get.to(ons_acceptance(
                    //     patientDetailsData: widget.patientDetailsData,
                    //     ntdata: data));
                    // }
                    Get.to(CirculationSheet(
                      patientDetailsData: widget.patientDetailsData,
                    ));
                  },
                  child: Card(
                      // color:widget.access? card_color : disable_color,
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
                                        'circulation'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(CirculationHistoryDash(
                                          patientDetailsData:
                                              widget.patientDetailsData,
                                        ));
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
                                height: 4,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, right: 10.0),
                                child: circulationdata.isNullOrBlank
                                    ? SizedBox(height: 145,)
                                    : Column(
                                        children: [
                                          circulationdata
                                                  .bloodPressor.isNullOrBlank
                                              ? SizedBox()
                                              : Row(
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${'blood_pressure'.tr} :",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Text('sbp'.tr),
                                                    SizedBox(
                                                      width: 2.0,
                                                    ),
                                                    circulationdata.bloodPressor
                                                            .isNullOrBlank
                                                        ? SizedBox()
                                                        : Text(circulationdata
                                                                .bloodPressor
                                                                ?.last
                                                                ?.sbp ??
                                                            ""),
                                                    SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Text('dbp'.tr),
                                                    SizedBox(
                                                      width: 2.0,
                                                    ),
                                                    circulationdata.bloodPressor
                                                            .isNullOrBlank
                                                        ? SizedBox()
                                                        : Text(circulationdata
                                                                .bloodPressor
                                                                ?.last
                                                                ?.dbp ??
                                                            ""),
                                                    SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Text('map'.tr),
                                                    SizedBox(
                                                      width: 2.0,
                                                    ),
                                                    circulationdata.bloodPressor
                                                            .isNullOrBlank
                                                        ? SizedBox()
                                                        : Text(circulationdata
                                                                .bloodPressor
                                                                ?.last
                                                                ?.map ??
                                                            ""),
                                                  ],
                                                ),
                                          // SizedBox(
                                          //   height: 5.0,
                                          // ),
                                          circulationdata
                                                  .vasopressor.isNullOrBlank
                                              ? SizedBox()
                                              : Column(
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${'vasopressors'.tr} : ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        // Text('DRUG - '),
                                                        // SizedBox(width: 5.0,),
                                                      ],
                                                    ),
                                                    // SizedBox(
                                                    //   height: 5.0,
                                                    // ),

                                                    circulationdata.vasopressor
                                                            .isNullOrBlank
                                                        ? SizedBox()
                                                        : Container(
                                                          height: 90,
                                                          child: ListView.builder(
                                                              // shrinkWrap: true,
                                                              itemCount: circulationdata.vasopressor.length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Row(
                                                                  children: [
                                                                    Text(circulationdata.vasopressor == null
                                                                        ? ""
                                                                        : circulationdata
                                                                                .vasopressor[index]
                                                                                .drug +
                                                                            ' : '),
                                                                    Text(circulationdata
                                                                            .vasopressor[
                                                                                index]
                                                                            .infusion +
                                                                        " mL/h,  "),
                                                                    Text(circulationdata
                                                                        .vasopressor[
                                                                            index]
                                                                        .dose),
                                                                    Text(
                                                                      "${circulationdata.vasopressor[index].unit_type == 'u' ? ' U/min' : ' mcg/kg/min'}",
                                                                    )
                                                                  ],
                                                                );
                                                              }),
                                                        ),

                                                    // Row(children: [
                                                    //   Column(
                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                    //     children: [
                                                    //       Text('Drug Amount - '),
                                                    //
                                                    //       // Text('Diluent - '),
                                                    //
                                                    //       Text('Concentration - '),
                                                    //
                                                    //       // Text('Infusion - '),
                                                    //
                                                    //       Text('Dose - '),
                                                    //
                                                    //     ],),
                                                    //   SizedBox(width: 10.0,),
                                                    //   circulationdata.vasopressor.isNullOrBlank?SizedBox():
                                                    //   Column(
                                                    //     crossAxisAlignment: CrossAxisAlignment.start,
                                                    //     children: [
                                                    //       Text(circulationdata.vasopressor?.last?.drug_amount??""),
                                                    //       // Text(circulationdata.vasopressor?.last?.diluent??""),
                                                    //       //  Text(circulationdata.vasopressor?.last?.diluent??""),
                                                    //       Text(circulationdata.vasopressor?.last?.concentration??""),
                                                    //       Text(circulationdata.vasopressor?.last?.dose??""),
                                                    //
                                                    //     ],),
                                                    //
                                                    //   //   Text('Drug Amount - '),
                                                    //   //   SizedBox(width: 5.0,),
                                                    //   //   Text(data?.result?.first?.circulaltiondata?.vasopressor?.first?.drug_amount),
                                                    //   // ],),
                                                    //   // Row(children: [
                                                    //   //
                                                    //   //   Text('Diluent - '),
                                                    //   //   SizedBox(width: 5.0,),
                                                    //   //   Text(data?.result?.first?.circulaltiondata?.vasopressor?.first?.diluent),
                                                    //   // ],),
                                                    //   // Row(children: [
                                                    //   //
                                                    //   //   Text('Concentration - '),
                                                    //   //   SizedBox(width: 5.0,),
                                                    //   //   Text(data?.result?.first?.circulaltiondata?.vasopressor?.first?.concentration),
                                                    //   // ],),
                                                    //   // Row(children: [
                                                    //   //
                                                    //   //   Text('Infusion - '),
                                                    //   //   SizedBox(width: 5.0,),
                                                    //   //   Text(data?.result?.first?.circulaltiondata?.vasopressor?.first?.infusion),
                                                    //   // ],),
                                                    //   // Row(children: [
                                                    //   //
                                                    //   //   Text('Dose - '),
                                                    //   //   SizedBox(width: 5.0,),
                                                    //   //   Text(data?.result?.first?.circulaltiondata?.vasopressor?.first?.dose),
                                                    // ],),
                                                  ],
                                                )
                                        ],
                                      ),
                              )
                            ],
                          ),
                          circulationdata.isNullOrBlank
                              ? SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(right: 8,bottom: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${'last_update'.tr} - ",
                                        style: TextStyle(
                                            color: primary_color, fontSize: 10),
                                      ),
                                      Text(
                                        "${DateFormat(commonDateFormat).format(DateTime.parse(circulationdata.lastUpdate ?? ""))}",
                                        style: TextStyle(
                                            color: primary_color,
                                            fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      )),
                );
              }),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
//text

//updated by raman at 14 oct 12:28
