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
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/history/condition_history.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';


class OnsAcceptanceBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  OnsAcceptanceBox({this.patientDetailsData,this.access});
  @override
  _OnsAcceptanceBoxState createState() => _OnsAcceptanceBoxState();
}

class _OnsAcceptanceBoxState extends State<OnsAcceptanceBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,

          child: FutureBuilder(
              future: getONS(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Ntdata data = snapshot.data;



                return InkWell(
                  onTap: ()async{
                    if(widget.access) {
                      Get.to(ons_acceptance(
                          patientDetailsData: widget.patientDetailsData,
                          ntdata: data));
                    }
                  },
                  child:  Card(
                      color:widget.access? card_color : disable_color,
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
                                        'oral_nutritional_supplement'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(conditionHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr,type: ConstConfig.ONSAcceptanceHistory,));
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
                            data==null?SizedBox():  Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' ${data?.result?.first?.condition??""}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.normal,
                                          fontSize: 15.0),
                                    ),

                                    data?.result?.first?.teamAgree ==null? SizedBox():   Row(
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

                                    data?.result?.first?.teamAgree ==null? SizedBox():  Text(
                                      ' ${data?.result?.first?.volume} ml ${data?.result?.first?.times}x ${'per_day'.tr}',
                                      style: TextStyle(color: Colors.black, fontSize: 13.0),),


                                    data?.result?.first?.teamAgree !=null  ?    Row(children: [

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
                                          '${data?.result?.first?.kcal}; ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 2,
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
                                          '${data?.result?.first?.ptn}; ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          ' ${'fiber'.tr}',
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
                                          '${data?.result?.first?.fiber};',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),

                                  ],):SizedBox()
                                  ],
                                ),
                              ),
                            ],
                          ),
                          data==null?SizedBox():  Row(
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
