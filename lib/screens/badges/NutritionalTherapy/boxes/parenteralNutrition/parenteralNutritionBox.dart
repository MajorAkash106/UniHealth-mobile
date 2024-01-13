import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteral_historyScreen.dart';

class ParenteralNutritionBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  const ParenteralNutritionBox({Key key, this.patientDetailsData, this.access}) : super(key: key);

  @override
  _ParenteralNutritionBoxState createState() => _ParenteralNutritionBoxState();
}

class _ParenteralNutritionBoxState extends State<ParenteralNutritionBox> {
  ParenteralNutrional_Controller _par_nt_controlller = ParenteralNutrional_Controller();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          // height: 200,
          child: InkWell(
            onTap: () {
              if(widget.access) {
                Get.to(ParenteralNutritionScreen(
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
                                  'parenteral_nutrition'.tr,
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
                                   Get.to(Parenteral_histoyScreen(patientDetailsData: widget.patientDetailsData,));
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
                          height: 7.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0,bottom: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future:
                                        _par_nt_controlller.getParenteral(widget.patientDetailsData),
                                        initialData:null,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          ParenteralData parenteralData = snapshot.data;
                                          return parenteralData==null?
                                          // Text(
                                          //   'ORAL Diet (today): missing',
                                          //   style: TextStyle(
                                          //       color: Colors.black,fontWeight: FontWeight.normal,
                                          //       fontSize: 15.0),
                                          // )
                                          SizedBox(height: 130,)
                                              : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                                parenteralData.tabStatus==true?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                  Text(parenteralData?.readyToUse?.title??"0",style: TextStyle(fontWeight: FontWeight.bold),),


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
                                                          '${parenteralData.teamStatus==0?"agree".tr:"dis_agree".tr}',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0),
                                                        ),
                                                      ],
                                                    ),
                                                  Row(
                                                    children: [
                                                      Text("Total vol:"),Text(parenteralData?.readyToUse?.totalVol??"0"),Text(' ml,') ,
                                                      SizedBox(width: 5,),
                                                      Text("Total cal:"),Text(parenteralData?.readyToUse?.totalCal??"0"),Text(' kcal')
                                                    ],
                                                  ),
                                                    // SizedBox(height: 5.0,),
                                                    Row(children: [
                                                      Text("${'current_work_day'.tr} : ") ,Text(parenteralData?.readyToUse?.currentWork??"0") ,Text(' ml') ,
                                                    ],),
                                                    // SizedBox(height: 5.0,),

                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("total_macro_short".tr,style: TextStyle(fontWeight: FontWeight.bold)) ,
                                                            Text("${'protein'.tr} : ${parenteralData?.readyToUse?.totalMacro?.protein??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("${'lipids'.tr} : ${parenteralData?.readyToUse?.totalMacro?.liquid??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("${'glucose_'.tr} : ${parenteralData?.readyToUse?.totalMacro?.glucose??"0"} g"),
                                                          ],
                                                        ),
                                                        SizedBox(width: 30.0,),
                                                       parenteralData.readyToUse.relativeMacro.liquid.isNullOrBlank?SizedBox():
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("ralative_macro_short".tr,style: TextStyle(fontWeight: FontWeight.bold)) ,
                                                            Text("${'lipids'.tr} : ${parenteralData?.readyToUse?.relativeMacro?.liquid??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("${'glucose_'.tr} : ${parenteralData?.readyToUse?.relativeMacro?.glucose??"0"} g"),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                ],):Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("manipulated_parenteral".tr,style: TextStyle(fontWeight: FontWeight.bold)),
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
                                                          '${parenteralData.teamStatus==0?"agree".tr:"dis_agree".tr}',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Total vol : "),Text(parenteralData?.manipulated?.totalVol??"0"),Text(' ml,') ,
                                                        SizedBox(width: 10,),
                                                        Text("Total cal : "),Text(parenteralData?.manipulated?.totalCal??"0"),Text(' kcal')
                                                      ],
                                                    ),
                                                    // SizedBox(height: 5.0,),
                                                    Row(children: [
                                                      Text("Current work day : ") ,Text(parenteralData?.manipulated?.currentWork??"0") ,Text(' ml') ,
                                                    ],),
                                                    // SizedBox(height: 5.0,),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Total Macronutrients",style: TextStyle(fontWeight: FontWeight.bold)) ,
                                                            Text("Protien : ${parenteralData?.manipulated?.totalMacro?.protein??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("Lipids : ${parenteralData?.manipulated?.totalMacro?.liquid??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("Glucose : ${parenteralData?.manipulated?.totalMacro?.glucose??"0"} g"),
                                                          ],
                                                        ),
                                                        SizedBox(width: 30.0,),
                                                        parenteralData.manipulated.relativeMacro.liquid.isNullOrBlank?SizedBox():
                                                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text("Relative Macronutrients",style: TextStyle(fontWeight: FontWeight.bold)) ,
                                                            Text("Lipids : ${parenteralData?.manipulated?.relativeMacro?.liquid??"0"} g"),
                                                            SizedBox(width: 5.0,),
                                                            Text("Glucose : ${parenteralData?.manipulated?.relativeMacro?.glucose??"0"} g"),
                                                          ],
                                                        ),
                                                      ],
                                                    )

                                                  ],
                                                )
                                          ],);

                                        }),

                                  ],
                                ),
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
                            _par_nt_controlller.getParenteral(widget.patientDetailsData),
                            initialData:null,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              ParenteralData parenteralData = snapshot.data;
                              return parenteralData==null
                                  ? SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 5),
                                child: Row(
                                  children: [
                                    Text(
                                      "${'last_update'.tr} - ",
                                      style: TextStyle(
                                          color: primary_color,
                                          fontSize: 10),
                                    ),
                                    Text(
                                      "${DateFormat(commonDateFormat).format(  DateTime.parse(parenteralData.lastUpdate))}"
                                      ,style: TextStyle(color: primary_color,fontSize: 10.0),),
                                  ],
                                ),

                              );
                            })
                      ],
                    ),
                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
