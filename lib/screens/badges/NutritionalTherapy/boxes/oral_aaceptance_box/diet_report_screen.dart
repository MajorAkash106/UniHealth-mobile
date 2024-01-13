import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/oral_aaceptance_box/dietReport_Tabs/Oral_dt_acceptnc_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/oral_aaceptance_box/dietReport_Tabs/ons_acceptance.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion_report_screen.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../blank_screen_loader.dart';


class DietReport_Screen extends StatelessWidget {
  final PatientDetailsData patientDetailsData;
  DietReport_Screen({this.patientDetailsData});

  Future<bool> _willPopScope() {
    //  if (activity) {
    //   Get.back(result: activity);
    // } else {


    Get.off(Step1HospitalizationScreen(
      index: 4,
      patientUserId: patientDetailsData.sId,
    ));
    //  }
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope( onWillPop: _willPopScope,
      child: Scaffold(
        appBar: BaseAppbar("diet_report".tr, null),
        body: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: ListView(
                  children: [
                    // Text('data')
                    SizedBox(
                      height: 20.0,
                    ),
                    _cardwidget('oral_diet_acceptance'.tr, () {
                      Get.to(Oral_Dt_Acptnc_screen(patientDetailsData: patientDetailsData,));
                    }),
                    _cardwidget('obs_acceptance'.tr, () {

                      getONS(patientDetailsData).then((value){
                        if(value!=null){

                          Get.to(Ons_Acceptance_Screen(patientDetailsData: patientDetailsData,));
                        }else{
                          showAlertForEmptyData();
                        }
                      });


                    }),

                    _cardwidget('enteral_nutrition_modules'.tr, () {
                      print('enteral nutrition');
                      // ShowMsg("Under Development");
                       Get.to(InfusionReport(title: 'enteral_nutrition_modules'.tr,patientDetailsData: patientDetailsData,formula_status: "enteral",isFromEn: false,isFromPn:false,type: "Enteral Nutrition",)).then((value) {
                         print('activity ${value}');
                         if (value!=null&&value ) {

                           Get.to(BlankScreen(
                             function: () {
                               final PatientSlipController
                               _patientSlipController =
                               PatientSlipController();

                               _patientSlipController
                                   .getDetails(
                                  _patientSlipController.patientDetailsData[0].sId,
                                   0)
                                   .then((val) {
                                 Get.to(DietReport_Screen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
                               });
                             },
                           ));
                         }
                       });
                    }),

                    _cardwidget('parenteral_nutrition'.tr, () {
                      print('parenteral nutrition');
                       // ShowMsg("Under Development");
                       Get.to(InfusionReport(title: 'parenteral_nutrition_infusion'.tr,patientDetailsData: patientDetailsData,formula_status: "parenteral",isFromEn: false,isFromPn:false,type: "Parenteral Nutrition",)).then((value) {
                         print('activity ${value}');
                         if (value!=null && value) {

                           Get.to(BlankScreen(
                             function: () {
                               final PatientSlipController
                               _patientSlipController =
                               PatientSlipController();

                               _patientSlipController
                                   .getDetails(
                                   _patientSlipController.patientDetailsData[0].sId,
                                   0)
                                   .then((val) {
                                 Get.to(DietReport_Screen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
                               });
                             },
                           ));
                         }
                       });
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  showAlertForEmptyData() {
    return Get.dialog(
        WillPopScope(child:  new AlertDialog(
          title: new Text(
            'This is depends on Ons Acceptance Box data, Please complete these first from NT Badge.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () async {
                Get.back();
                Get.back();

              },
              child: new Text('OK'),
            ),
          ],
        ), onWillPop: willPopScope)
    );
  }
  Future<bool>willPopScope(){
    print('popup value');
    Get.back();
    Get.back();
  }

  Widget _cardwidget(String text, Function _funtion) {
    return InkWell(
      onTap: _funtion,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
        ],
      ),
    );
  }
}
