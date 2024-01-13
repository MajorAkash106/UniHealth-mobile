import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
// <<<<<<< HEAD
// import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
// =======
// >>>>>>> 19472af973667e2b44ffbb69173710b9eda853ba
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/EnteralNutritionScreen.dart';

import 'Enteral_HistoryScreen.dart';

class EnteralNutritionBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  EnteralNutritionBox({this.patientDetailsData,this.access});

  @override
  _EnteralNutritionBoxState createState() => _EnteralNutritionBoxState();
}

class _EnteralNutritionBoxState extends State<EnteralNutritionBox> {
// <<<<<<< HEAD
//   final EnteralNutritionalController _controller =
//   EnteralNutritionalController();
// =======

  final EnteralNutritionalController _controller = EnteralNutritionalController();




// >>>>>>> 19472af973667e2b44ffbb69173710b9eda853ba
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
                Get.to(EnteralNutritionScreen(
                  patientDetailsData: widget.patientDetailsData,));
              }
            },
            child: Card(
                color:widget.access? card_color:disable_color,
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
                                  'enteral_nutrition'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(Enteral_histoyScreen(patientDetailsData: widget.patientDetailsData,));
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
                              Padding(
                                padding: const EdgeInsets.only(left: 0,bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // FutureBuilder(
                                    //     future:
                                    //     getORALDetailsToday(widget.patientDetailsData),
                                    //     initialData:null,
                                    //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    //       OralData oraldata = snapshot.data;
                                    //       return oraldata==null?
                                    //       // Text(
                                    //       //   'ORAL Diet (today): missing',
                                    //       //   style: TextStyle(
                                    //       //       color: Colors.black,fontWeight: FontWeight.normal,
                                    //       //       fontSize: 15.0),
                                    //       // )
                                    //       SizedBox()
                                    //           : Text(
                                    //         'ORAL Diet (today): ${oraldata.average??'missing '}%',
                                    //         style: TextStyle(
                                    //             color: Colors.black,fontWeight: FontWeight.normal,
                                    //             fontSize: 15.0),
                                    //       );
                                    //
                                    //     }),
                                    FutureBuilder(
                                        future:
                                       _controller.getEnternalData(widget.patientDetailsData),
                                        initialData: null,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          EnteralData eternaldata = snapshot.data;
                                          return eternaldata==null?
                                          // Text(
                                          //   'ORAL Diet (yesterday): missing',
                                          //   style: TextStyle(
                                          //       color: Colors.black,fontWeight: FontWeight.normal,
                                          //       fontSize: 15.0),
                                          // )
                                          SizedBox()
                                              : Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [eternaldata.tabIndex==0?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text(eternaldata.industrializedData.title),
                                                  SizedBox(height: 5.0,),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          '${'nt_team'.tr}',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15.0),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          '${eternaldata.teamIndex==0?"agree".tr:"dis_agree".tr}',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0),
                                                        ),
                                                      ],
                                                    ),
                                                 Row(
                                                    children: [
                                                      Text("${'volume'.tr}:"),
                                                      Text(eternaldata.industrializedData.mlHr+" mL/h, "??""),
                                                      // SizedBox(width: 5,),
                                                      Text(eternaldata.industrializedData.hrDay+" h, "??""),
                                                      // SizedBox(width: 5,),
                                                     // SizedBox(width: 30.0,),
                                                      Text("${'expected_vol'.tr}:"),
                                                      Text(
                                                          eternaldata.industrializedData.currentWork+" mL"??"",
                                                        style: TextStyle(),)
                                                    ],
                                                  )
                                                ],): Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(eternaldata.manipulatedData.title),
                                                  SizedBox(height: 5.0,),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${'nt_team'.tr}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        '${eternaldata.teamIndex==0?"agree".tr:"dis_agree".tr}',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 13.0),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("${'volume'.tr} : "),
                                                      Text(eternaldata.manipulatedData.mlDose+" mL/h, "??""),
                                                      // SizedBox(width: 5,),
                                                      Text(eternaldata.manipulatedData.dosesData.length.toString()+" x, "??""),
                                                      // SizedBox(width: 5,),

                                                     // SizedBox(width: 30.0,),
                                                      Text("${'expected_vol'.tr} : "),
                                                      Text(eternaldata.manipulatedData.currentWork+" mL"??"")
                                                    ],
                                                  )
                                                ],),
                                                SizedBox(height: 5.0,),

                                             eternaldata.enData.fiberModule.isEmpty&&eternaldata.enData.proteinModule.isEmpty?SizedBox():   Row(
                                                  children: [
                                                    Text("${'modules'.tr} : "),

                                                eternaldata.enData.fiberModule.isEmpty?SizedBox():    Row(
                                                      children: [
                                                        Text("${'fiber'.tr} : "),
                                                        Text(eternaldata.enData.fiberModule+"(g), "??""),
                                                      ],
                                                    ),
                                                    SizedBox(width: 5,),
                                                   eternaldata.enData.proteinModule.isEmpty?SizedBox(): Row(
                                                      children: [
                                                        Text("${'protein'.tr} : "),
                                                        Text(eternaldata.enData.proteinModule+"(g), "??"")
                                                      ],
                                                    ),

                                                  ],
                                                )



                                            ],),
                                          );

                                          // Text(
                                          //   'ORAL Diet (yesterday): ${oraldata.average??'missing '}%',
                                          //   style: TextStyle(
                                          //       color: Colors.black,fontWeight: FontWeight.normal,
                                          //       fontSize: 15.0),
                                          // );

                                        }),
                                  ],
                                ),
                              ),




                            ],
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future: _controller.getEnternalData(widget.patientDetailsData),
                        initialData: null,
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          EnteralData eternaldata = snapshot.data;
                          return eternaldata ==null?SizedBox(): Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "${'last_update'.tr} - ",
                                  style: TextStyle(
                                      color: primary_color,
                                      fontSize: 10),
                                ),

                                Text(
                                  "${DateFormat(commonDateFormat).format(  DateTime.parse(eternaldata.lastUpdate))}"
                                  ,style: TextStyle(color: primary_color,fontSize: 10.0),),
                              ],),
                          );
                        }),

                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
