import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/gly_HistoryScreen.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_HistoryScreen.dart';
class Temp_Gly_HistoryDash extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  const Temp_Gly_HistoryDash({Key key, this.patientDetailsData}) : super(key: key);

  @override
  _Temp_Gly_HistoryDashState createState() => _Temp_Gly_HistoryDashState();
}

class _Temp_Gly_HistoryDashState extends State<Temp_Gly_HistoryDash> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: BaseAppbar('history'.tr, null),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: ListView(
              children: [
                SizedBox(height: 20,),
                _cardwidget('temp_sheet_history'.tr, (){
                  Get.to(Temp_HistoryScreen(patientDetailsData:widget.patientDetailsData,HistoryName: "temp_sheet_history".tr,));
                  //Get.to(BloodPressure_HistoryScreen(patientDetailsData: widget.patientDetailsData,HistoryName: 'History'));

                }),
                SizedBox(height: 20,),
                _cardwidget('gly_sheet_history'.tr, (){
                  Get.to(Gly_HistoryScreen(patientDetailsData:widget.patientDetailsData,HistoryName: "gly_sheet_history".tr,));

                 /// Get.to(VasoPressure_HistoryScreen(patientDetailsData: widget.patientDetailsData,HistoryName: 'History',));
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
