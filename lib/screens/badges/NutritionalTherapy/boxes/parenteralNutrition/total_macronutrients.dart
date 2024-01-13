import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';

class TotalMacro extends StatefulWidget {
  TextEditingController protien;
  TextEditingController liqid;
  TextEditingController glucose;
  TextEditingController bagperday;
  PARENTERALDATA parenteraldata;
  TotalMacro({this.protien,this.liqid,this.glucose,this.bagperday,this.parenteraldata});
  @override
  _TotalMacroState createState() => _TotalMacroState();
}

class _TotalMacroState extends State<TotalMacro> {
  ParenteralNutrional_Controller _controller = ParenteralNutrional_Controller();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          "total_macro".tr,
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
              child: TextField(
                controller: widget.protien,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                 enabled: false,
                //focusNode: focus,
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (_value) {
                  print(widget.protien.text);
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText:"protein".tr,
                  border: new OutlineInputBorder(
                    //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                      BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                  ),
                  hintStyle: TextStyle(
                      color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              )

              // texfld("protein", widget.protien, () {
              //   print(widget.protien);
              // }),
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
              child: TextField(
                controller: widget.liqid,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                enabled: false,
                //focusNode: focus,
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (_value) {
                  print(widget.liqid.text);
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "lipids".tr,
                  border: new OutlineInputBorder(
                    //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                      BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                  ),
                  hintStyle: TextStyle(
                      color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              )
              // texfld("Lipids", widget.liqid, () {
              //   print(widget.liqid);
              // }),
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
              child: TextField(
                controller: widget.glucose,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                enabled: false,
                //focusNode: focus,
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (_value) {
                  print(widget.glucose.text);
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText:"glucose_".tr,
                  border: new OutlineInputBorder(
                    //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                      BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                  ),
                  hintStyle: TextStyle(
                      color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              )
              // texfld("glucose", widget.glucose, () {
              //   print(widget.glucose);
              // }),
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
