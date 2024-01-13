
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/adult_contoller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/adults/adult_icu.dart';


import 'adult_non_icu.dart';

class AdultHome extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  AdultHome({this.patientDetailsData});

  @override
  _AdultHomeState createState() => _AdultHomeState();
}

class _AdultHomeState extends State<AdultHome> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: BaseAppbar("conditions".tr,null),
      body: Padding(
        padding: const EdgeInsets.only(left :20.0,top: 10.0,bottom: 10.0,right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.only(left:10.0,right: 10.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Container(child: Text('adults'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17.0),),),
                  SizedBox(width: 10.0,),
                  // Container(child: Expanded(child: Text('BMI: 25: 32 years old Intensive Care, Kidney allert',style: TextStyle(color: Colors.black,fontSize: 17.0),)),),
                ],
              ),
            ),

            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '${'attention'.tr}:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                BmiAgeWard(patientDetailsData: widget.patientDetailsData,),
              ],
            ),

            _cardwidget('icu'.tr,(){
              Get.to(AdultIcu(patientDetailsData: widget.patientDetailsData));
            }),
            SizedBox(height: 20.0,),
            _cardwidget('non_icu'.tr,(){
              Get.to(AdultNonIcu(patientDetailsData: widget.patientDetailsData,));
            }),

            Spacer(),
            Spacer(),
            Spacer(),
          ],
        ),
      ),

    );
  }

  Widget _cardwidget(String text, Function _funtion ) {
    return InkWell(
      onTap:_funtion,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
            child: Card(
                color: primary_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  // side: BorderSide(width: 5, color: Colors.green)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Center(
                      child: Text(
                        "$text",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: card_color,
                            fontSize: 20,
                            fontWeight: FontWeight.normal),
                      )),
                )),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         "Last update - 02/02/2020",
          //         style: TextStyle(color: black40_color, fontSize: 13),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
