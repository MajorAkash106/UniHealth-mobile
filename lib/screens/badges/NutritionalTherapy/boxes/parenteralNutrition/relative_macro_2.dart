import 'package:flutter/material.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';

class RelativeMacro2 extends StatefulWidget {
  TextEditingController liqid;
  TextEditingController glucose;
  RelativeMacro2({this.liqid,this.glucose});
  @override
  _RelativeMacro2State createState() => _RelativeMacro2State();
}

class _RelativeMacro2State extends State<RelativeMacro2> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          "Relative Macronutrients 2",
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
            Text("Lipids",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),

            Container(
              width: 70.0,
              height: 40.0,
              child: texfld("g/kg", widget.liqid, () {
                print(widget.liqid);
              }),
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
            Text("Glucose",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Spacer(),
            Container(
              width: 70.0,
              height: 40.0,
              child: texfld("mg/kg/min", widget.glucose, () {
                print(widget.glucose);
              }),
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
