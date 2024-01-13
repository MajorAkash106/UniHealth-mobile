import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/fasting1.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/history/condition_history.dart';


class FastingBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  FastingBox({this.patientDetailsData,this.access});
  @override
  _FastingBoxState createState() => _FastingBoxState();
}

class _FastingBoxState extends State<FastingBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: FutureBuilder(
              future: getFAsting(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Ntdata data = snapshot.data;



                return InkWell(
                  onTap: (){
                    if(widget.access) {
                      Get.to(Fasting1(
                        patientDetailsData: widget.patientDetailsData,
                        ntdata: data,
                      ));
                    }
                  },
                  child:  Card(
                      color: widget.access?card_color:disable_color,
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
                                        'fasting_oral_diet'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(conditionHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr,type: ConstConfig.FastingOralHistory,));
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
                              data == null || data.result.first.kcal == null
                                  ? SizedBox()
                                  :

                              data?.result?.first?.fasting==null?SizedBox():

                              data?.result?.first?.fasting
                                  ? Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'patient_is_on_fasting'.tr,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                    SizedBox(height: 5,),

                                    Text(
                                      '${'fasting_reason'.tr} :',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 15.0),
                                    ),
                                    Text(
                                      '${data?.result?.first?.fasting_reason}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.normal,
                                          fontSize: 15.0),
                                    ),
                                    Text(
                                      '${data?.result?.first?.description}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.normal,
                                          fontSize: 15.0),
                                    ),
                                  ],
                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' ${data?.result?.first?.condition}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.normal,
                                          fontSize: 15.0),
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          ' ${'nt_team'.tr}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${data?.result?.first?.teamAgree?"agree".tr:"dis_agree".tr}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' kCal',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${data?.result?.first?.kcal}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' Ptn',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize: 15.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${data?.result?.first?.ptn} g',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      padding: const EdgeInsets.only(
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
                      )),);
              }),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
