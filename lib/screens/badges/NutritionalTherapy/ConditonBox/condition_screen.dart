import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/adults/adult_home.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/customized_tab.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/pediatrics_tab.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/pregnancy_lactation/pregnancy_lactation_tab.dart';


class Condition_Screen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  Condition_Screen({this.patientDetailsData});

  @override
  _Condition_ScreenState createState() => _Condition_ScreenState();
}

class _Condition_ScreenState extends State<Condition_Screen> {
  bool isPatientkid = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(
        'patients data on conditions screen: ${jsonEncode(widget.patientDetailsData)}');

    Future.delayed(const Duration(milliseconds: 100), () {
      if (widget.patientDetailsData.anthropometry.isEmpty) {
        showAlertForEmptyData();
      }
    });

    isPatientKid(widget.patientDetailsData.dob).then((value) {
      if (value != null) {
        isPatientkid = value;
        setState(() {});
      }
    });
  }

  showAlertForEmptyData() {
    return Get.dialog(WillPopScope(
        child: new AlertDialog(
          title: new Text(
            'condition_depends_on_anthro_data'.tr,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
             ElevatedButton(
              onPressed: () async {
                Get.back();
                Get.back();
              },
              child: new Text('close'.tr.toUpperCase()),
            ),
          ],
        ),
        onWillPop: willPopScope));
  }

  Future<bool> willPopScope() {
    print('popup value');
    Get.back();
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("conditions".tr, null),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'attention'.tr,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  BmiAgeWard(
                    patientDetailsData: widget.patientDetailsData,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  // Text('data')
                  SizedBox(
                    height: 20.0,
                  ),
                  _cardwidget('customized_capital'.tr.toUpperCase(), () {
                    Get.to(Customized_screen(
                      patientDetailsData: widget.patientDetailsData,
                    ));
                  }, primary_color),
                  _cardwidget('adults'.tr, () {
                    if (!isPatientkid) {
                      Get.to(AdultHome(
                        patientDetailsData: widget.patientDetailsData,
                      ));
                    } else {
                      ShowMsg("sorry_patient_age_is_less_than_19_years".tr);
                    }
                  }, !isPatientkid ? primary_color : Colors.grey),
                  _cardwidget('pediatrics'.tr, () {
                    if (isPatientkid) {
                      Get.to(Pediatrics(
                        patientDetailsData: widget.patientDetailsData,
                      ));
                    }else{
                      ShowMsg("sorry_patient_age_is_less_than_19_years".tr);
                    }
                  }, isPatientkid ? primary_color : Colors.grey),
                  _cardwidget('pregnancy_lactation'.tr, () {
                    Get.to(Pregnancy_Lactation(
                      patientDetailsData: widget.patientDetailsData,
                    ));
                  }, primary_color),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardwidget(String text, Function _funtion, Color colorCode) {
    return InkWell(
      onTap: _funtion,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Card(
                color: colorCode,
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
