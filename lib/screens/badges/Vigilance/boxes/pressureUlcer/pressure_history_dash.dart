import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/installed_history.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/risk_history.dart';



class PressureHistoryDash extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  PressureHistoryDash({this.patientDetailsData});
  @override
  _PressureHistoryDashState createState() => _PressureHistoryDashState();
}

class _PressureHistoryDashState extends State<PressureHistoryDash> {




  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('history'.tr, null),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: ListView(
                children: [
                  SizedBox(height: 20,),
                  _cardwidget('risk_braden'.tr, (){
                    Get.to(PressureRiskHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: '${'history'.tr} - ${'risk_braden'.tr}',));
                  }),
                  SizedBox(height: 20,),
                  _cardwidget('installed'.tr, (){
                    Get.to(PressureInstalledHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: '${'history'.tr} - ${'installed'.tr}',));
                  }),
                ]

            ),
          ),
        ),
    );
  }

  Widget _cardwidget(String text, Function _function) {
    return InkWell(
      onTap: _function,
      child: Card(
          color: primary_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // side: BorderSide(width: 5, color: Colors.green)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:ListTile(title: Text(
              "$text",
              style: TextStyle(
                  color: card_color,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),trailing: Icon(Icons.arrow_forward,color: Colors.white,),),
          )),
    );
  }
}
