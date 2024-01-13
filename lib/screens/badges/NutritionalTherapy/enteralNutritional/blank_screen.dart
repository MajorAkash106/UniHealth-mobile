import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/EnteralNutritionScreen.dart';

class BlankScreenLoader extends StatefulWidget {
  final String userId;
  bool isParenteral;
  BlankScreenLoader({this.userId,this.isParenteral});
  @override
  _BlankScreenLoaderState createState() => _BlankScreenLoaderState();
}

class _BlankScreenLoaderState extends State<BlankScreenLoader> {

final PatientSlipController _patientSlipController = PatientSlipController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  getData() {
    Future.delayed(const Duration(milliseconds: 0), () {
      _patientSlipController
          .getDetails(widget.userId, 0)
          .then((val) {

            if(widget.isParenteral){
              Get.to(ParenteralNutritionScreen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
            }else{
              Get.to(EnteralNutritionScreen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
            }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: CircularProgressIndicator(),
      ),
    );
  }
}
