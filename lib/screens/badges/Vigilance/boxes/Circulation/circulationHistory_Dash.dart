import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/Circulation/bp_historyScreen.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/Circulation/vaso_pressure_HistoryScreen.dart';

class CirculationHistoryDash extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  const CirculationHistoryDash({Key key, this.patientDetailsData}) : super(key: key);

  @override
  _CirculationHistoryDashState createState() => _CirculationHistoryDashState();
}

class _CirculationHistoryDashState extends State<CirculationHistoryDash> {
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
                _cardwidget('blood_pressure'.tr, (){
                  Get.to(BloodPressure_HistoryScreen(patientDetailsData: widget.patientDetailsData,HistoryName: "${'history'.tr}-${'blood_pressure'.tr}"));

                }),
                SizedBox(height: 20,),
                _cardwidget('vasopressors'.tr, (){

                  Get.to(VasoPressure_HistoryScreen(patientDetailsData: widget.patientDetailsData,HistoryName: "${'history'.tr}-${'vasopressors'.tr}",));
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
