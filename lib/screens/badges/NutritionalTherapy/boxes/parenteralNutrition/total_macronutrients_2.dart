import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';

class TotalMacro2 extends StatefulWidget {
  TextEditingController protien;
  TextEditingController liqid;
  TextEditingController glucose;
  TextEditingController bagperday;
  PARENTERALDATA parenteraldata;
  Function onEnteredLipids;
  TotalMacro2({this.protien,this.liqid,this.glucose,this.bagperday,this.parenteraldata,this.onEnteredLipids});
  @override
  _TotalMacro2State createState() => _TotalMacro2State();
}

class _TotalMacro2State extends State<TotalMacro2> {
  ParenteralNutrional_Controller _controller = ParenteralNutrional_Controller();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          "${'total_macro'.tr}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("protein".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 10.0,
            ),
            Container(
              width: 70.0,
              height: 40.0,
              child: texfld("protein".tr, widget.protien, () {
                print(widget.protien);
              }),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("g", style: TextStyle(fontWeight: FontWeight.bold)),
            //SizedBox(width: 20.0,),
            Spacer(),
            Text("lipids".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 5.0,
            ),

            Container(
              width: 70.0,
              height: 40.0,
              child: texfld("lipids".tr, widget.liqid, () {
                print(widget.liqid);
                widget.onEnteredLipids();
              }),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("g", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      SizedBox(
        height: 10.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("glucose_".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              width: 5.0,
            ),
            Container(
              width: 70.0,
              height: 40.0,
              child: texfld("glucose_".tr, widget.glucose, () {
                print(widget.glucose);
                widget.onEnteredLipids();
              }),
            ),
            SizedBox(
              width: 5.0,
            ),
            Text("g", style: TextStyle(fontWeight: FontWeight.bold)),

            //SizedBox(width: 20.0,),
          ],
        ),
      ),
    ],);
  }


}
