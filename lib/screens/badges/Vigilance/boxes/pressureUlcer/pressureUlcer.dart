import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/vigilance/pressure_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/pressure_risk_hitory_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/pressure_dash.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/pressure_history_dash.dart';

class pressureUlcer extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;

  pressureUlcer({this.patientDetailsData, this.access});

  @override
  _pressureUlcerState createState() => _pressureUlcerState();
}

class _pressureUlcerState extends State<pressureUlcer> {
  final PressureController controller = PressureController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: FutureBuilder(
              future: controller.getPressureUlcer(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Vigilance data = snapshot.data;
                var SUSPECTED = data?.result?.first?.installedData?.firstWhere(
                    (element) =>
                        // element.statusquestion == 'SUSPECTED DEEP TISSUE INJURY',
                        element.statusId == 'SUSPECTED DEEP TISSUE INJURY',
                    orElse: () => null);

                return InkWell(
                  onTap: () async {
                    // if(widget.access) {
                    // Get.to(ons_acceptance(
                    //     patientDetailsData: widget.patientDetailsData,
                    //     ntdata: data));
                    // }
                    Get.to(PressureDash(
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
                                        'pressure_ulcer'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(PressureHistoryDash(
                                            patientDetailsData:
                                                widget.patientDetailsData));
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
                                height: 10,
                              ),
                              data.isNullOrBlank
                                  ? SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: data.result.first.installedData
                                              .isNullOrBlank
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'risk_braden'.tr,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0),
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
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'pressure_ulcer'.tr} ${'installed'.tr}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      '',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15.0),
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
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.0),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
                                                SUSPECTED.isNullOrBlank
                                                    ? SizedBox()
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '${SUSPECTED.statusquestion}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize:
                                                                      16.0),
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
                          ),
                          data == null
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    FutureBuilder(
                                        future: getDateFormatFromString(
                                            data?.result?.first?.lastUpdate),
                                        initialData: "Loading text..",
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshota) {
                                          return snapshota.data == null
                                              ? SizedBox()
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10, bottom: 8),
                                                  child: Text(
                                                    "${'last_update'.tr} - "
                                                    '${snapshota.data}',
                                                    style: TextStyle(
                                                        color: primary_color,
                                                        fontSize: 10),
                                                  ),
                                                );
                                        })
                                  ],
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
