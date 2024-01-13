import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/status_controller/espen_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NRS_2002.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class ESPENSecondScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String title;
  final String result;
  final bool UNINTENTIONALWEIGHT;
  ESPENSecondScreen({this.patientDetailsData,this.title,this.result,this.UNINTENTIONALWEIGHT});
  @override
  _ESPENSecondScreenState createState() => _ESPENSecondScreenState();
}

class _ESPENSecondScreenState extends State<ESPENSecondScreen> {

Refference_Notes_Controller ref_controller = Refference_Notes_Controller();
ESPENController _espenController = ESPENController();
  Future<bool>willPopScope(){
    // Get.back();
    // Get.back();
    // SaveToServer();
    Get.to(Step1HospitalizationScreen(patientUserId: widget.patientDetailsData.sId, statusIndex: 2,index: 2,));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
      print('internet');
      if (internet != null && internet) {
        SaveToServer();

        print('internet avialable');
      }else{
        SaveToServer();
      }
    });


  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: BaseAppbar('${widget.title}',  IconButton(icon: Icon(Icons.info_outline), onPressed: (){
        Get.to(ReferenceScreen(Ref_list: ref_controller.ESPEN_Ref_list,));
        //select_unit();
      })),
      // bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
              SizedBox(height: 30,),
              Center(
                child: Text(
                  "result_given".tr,
                  style: TextStyle(
                      color: appbar_icon_color,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 70,),
              _cardwidget("${widget.result}".toUpperCase(), 'path'),
            ],
          ),
        ),
      ),
    ), onWillPop: willPopScope);
  }

  Widget _cardwidget(String text, String path,) {
    return Column(
      children: [
        Card(
            color: primary_color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              // side: BorderSide(width: 5, color: Colors.green)
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
              child: Center(
                  child: Text(
                    "$text",
                    style: TextStyle(
                        color: card_color,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  )),
            )),
      ],
    );
  }


final HistoryController _historyController = HistoryController();

SaveToServer()async{
  Map data = {
    'status': "ESPEN",
    'score': '0',
    'UNINTENTIONALWEIGHT': widget.UNINTENTIONALWEIGHT,
    'espen_output': widget.result,
    'lastUpdate': '${DateTime.now()}',
  };

  print('data json: ${jsonEncode(data)}');

  checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
    if(internet!=null && internet){

        _espenController.saveData(widget.patientDetailsData, data).then((value){

        print('updatedd');

        _historyController.saveHistoryWihtoutLoader(
            widget.patientDetailsData.sId,
            ConstConfig.ESPENHistory,
            widget.result);

      });

    }else{
      _espenController.saveDataOffline(widget.patientDetailsData, data);
    }

  });



}

}
