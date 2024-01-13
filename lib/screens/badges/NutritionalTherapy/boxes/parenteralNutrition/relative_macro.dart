import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
class RelativeMacro extends StatefulWidget {
  TextEditingController liqid;
  TextEditingController glucose;
  RelativeMacro({this.liqid,this.glucose});
  @override
  _RelativeMacroState createState() => _RelativeMacroState();
}

class _RelativeMacroState extends State<RelativeMacro> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          "ralative_macro".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("lipids".tr,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),

            Container(
              width: 100.0,
              height: 40.0,
              // child: texfld("g/kg", widget.liqid, () {
              //   print(widget.liqid);
              // }),
              child: TextField(
                controller: widget.liqid,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                enabled: false,
                //focusNode: focus,
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (_value) {
                  print(widget.liqid);
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText:"g/kg",
                  border: new OutlineInputBorder(
                    //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                      BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                  ),
                  hintStyle: TextStyle(
                      color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            // Text("g/kg",style: TextStyle(fontWeight: FontWeight.bold)),

            //SizedBox(width: 20.0,),
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
            Spacer(),
            Container(
              width: 100.0,
              height: 40.0,
              // child: texfld("mg/kg/min", widget.glucose, () {
              //   print(widget.glucose);
              // }),
              child: TextField(
                controller: widget.glucose,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.deny(',')],
                enabled: false,
                //focusNode: focus,
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (_value) {
                  print(widget.glucose);
                },
                style: TextStyle(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "mg/kg/min",
                  border: new OutlineInputBorder(
                    //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                      borderSide:
                      BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                  ),
                  hintStyle: TextStyle(
                      color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            // Text("mg/kg/min",style: TextStyle(fontWeight: FontWeight.bold)),

            //SizedBox(width: 20.0,),
          ],
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
    ],);
  }
}
