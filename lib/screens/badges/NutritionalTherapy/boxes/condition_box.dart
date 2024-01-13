import 'dart:convert';

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
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/condition_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/history/condition_history.dart';


class ConditionBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  ConditionBox({this.patientDetailsData,this.access});
  @override
  _ConditionBoxState createState() => _ConditionBoxState();
}

class _ConditionBoxState extends State<ConditionBox> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('NT DATA: ${jsonEncode(widget.patientDetailsData.ntdata)}');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if(widget.access) {
                Get.to(Condition_Screen(
                  patientDetailsData: widget.patientDetailsData,
                ));
              }
            },
            child: Card(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 16.0),
                                child: Text(
                                  'condition'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Get.to(NutrintionalScreening());
                                  // print('type0 dates: ${type0}');

                                  // Get.to(NutrintionalScreeningHistory(
                                  //   patientDetailsData:
                                  //   widget.patientDetailsData[0],
                                  // ));
                                  Get.to(conditionHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr,type: ConstConfig.ConditionHistory,));
                                },
                                child: Container(
                                  //margin: EdgeInsets.only(right: 8.0,),
                                  //color: Colors.red,
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
                          height: 10,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                  future: getCondionFromNT(widget.patientDetailsData),
                                  initialData: "Loading text..",
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                    String data = snapshot.data;



                                    if(snapshot.data !=null && snapshot.data.toLowerCase() == conditionNT.customized){
                                      data = 'customized'.tr.toUpperCase();
                                    }
                                    return   Text(
                                      '${data??''}',
                                      style: TextStyle(
                                          color: Colors.black,fontWeight: FontWeight.normal,
                                          fontSize: 15.0),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                  future: getCustomized(widget.patientDetailsData),
                                  initialData: null,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    CutomizedData data = snapshot.data;
                                    return snapshot.data==null?SizedBox(): Column(

                                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                     Row(

                                       children: [
                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Text(
                                             '${'kcal'.tr}     ',
                                             style: TextStyle(
                                                 color: Colors.black,fontWeight: FontWeight.bold,
                                                 fontSize: 15.0),
                                           ),
                                           Text(
                                             'protein'.tr,
                                             style: TextStyle(
                                                 color: Colors.black,fontWeight: FontWeight.bold,
                                                 fontSize: 15.0),
                                           ),
                       ],
                                       ),
                                       SizedBox(width: 10,),

                                     Row(
                                       // mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [

                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             children: [
                                               Text(
                                                 'Min: ',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 15.0),
                                               ),
                                               Text(
                                                 '${data?.minEnergy??''}',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 13.0),
                                               ),
                                             ],
                                           ),
                                           Row(
                                             children: [
                                               Text(
                                                 'Min: ',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 15.0),
                                               ),
                                               Text(
                                                 '${data?.minProtien??''}',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 13.0),
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),

                                       SizedBox(width: 10,),

                                       Column(
                                         mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Row(
                                             children: [
                                               Text(
                                                 'Max: ',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 15.0),
                                               ),
                                               Text(
                                                 '${data?.maxEnergy??''}',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 13.0),
                                               ),
                                             ],
                                           ),
                                           Row(
                                             children: [
                                               Text(
                                                 'Max: ',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 15.0),
                                               ),
                                               Text(
                                                 '${data?.maxProtien??''}',
                                                 style: TextStyle(
                                                     color: Colors.black,
                                                     fontSize: 13.0),
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),

                                     ],)

                                     ],)

                                      ],
                                    );
                                  }),


                              Padding(
                                padding: const EdgeInsets.only(top: 5,right: 5),
                                child: FutureBuilder(
                                    future:
                                    getCondionInfoFromNT(widget.patientDetailsData),
                                    initialData: "Loading text..",
                                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {


                                      return  snapshot.data.isNullOrBlank?SizedBox(): Text(
                                        '${'notes'.tr}: ${snapshot.data??''}',
                                        style: TextStyle(
                                            color: Colors.black,fontWeight: FontWeight.normal,
                                            fontSize: 12.0),
                                      );
                                    }),
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
                            future:
                            getCondionUpdatedDate(widget.patientDetailsData),
                            initialData: "Loading text..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {

                              return snapshot.data==null?SizedBox(): FutureBuilder(
                                  future: getDateFormatFromString(snapshot.data),
                                  initialData: "Loading text..",
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshota) {

                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10, bottom: 8),
                                      child: Text(
                                        "${'last_update'.tr} - "
                                            '${snapshota.data}',
                                        style: TextStyle(color: primary_color, fontSize: 10),
                                      ),
                                    );
                                  });
                            }),

                      ],
                    ),
                  ],
                )
            ),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
