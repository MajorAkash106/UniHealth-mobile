import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
class NonNutritionalCaloriesP extends StatefulWidget {
  final TextEditingController propofol;
  final TextEditingController glucos;
  final TextEditingController citrate;
  final TextEditingController total;
  NonNutritionalCaloriesP({this.propofol,this.citrate,this.total,this.glucos});
  @override
  _NonNutritionalCaloriesPState createState() => _NonNutritionalCaloriesPState();
}

class _NonNutritionalCaloriesPState extends State<NonNutritionalCaloriesP> {




  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        height: 10.0,
      ),
      Divider(
        thickness: 3,
        color: Colors.black12,
      ),
      SizedBox(
        height: 20.0,
      ),
      Center(
        child: Text(
          "non_nutritional_calories".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'propofol'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 78,
          ),

          // CustomTextField('Phone/Email/Profile ID', IDforlogin,TextInputType.emailAddress,false,Icon(Icons.email),Icon(null),null),

          Container(
            width: 100.0,
            height: 40.0,
            child: texfld(
                "", widget.propofol,
                    () {
                  // print(propofol);
                      computeTotal();
                }),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'glucose'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 95,
          ),
          Container(
            width: 100.0,
            height: 40.0,
            child: texfld(
                "", widget.glucos,
                    () {
                  // print(glucose);
                      computeTotal();
                }),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'citrate'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 105,
          ),
          Container(
            width: 100.0,
            height: 40.0,
            child: texfld(
                "", widget.citrate,
                    () {
                  // print(citrate);
                      computeTotal();
                }),
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${'total'.tr} (kcal)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 128,
          ),
          Container(
            width: 100.0,
            height: 40.0,
            child: TextField(
              controller: widget.total,
              enabled: false,
              //focusNode: focus,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (_value) {
                // _fun();
              },
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: '',
                border: new OutlineInputBorder(
                  //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    borderSide:
                    BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                ),
                hintStyle: TextStyle(
                    color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
              ),
            )
          ),
        ],
      ),
      SizedBox(
        height: 10.0,
      ),
    ],);
  }

  void computeTotal(){
    if(widget.propofol.text.isNotEmpty || widget.glucos.text.isNotEmpty || widget.citrate.text.isNotEmpty){

      double a = double.parse(ifBlankReturnZero(widget.propofol.text));
      double b = double.parse(ifBlankReturnZero(widget.glucos.text));
      double c = double.parse(ifBlankReturnZero(widget.citrate.text));

      double total = (a * 1.1) + (b * 3.4) + (c * 3);

      widget.total.text = total.toStringAsFixed(2);


    }else{
      widget.total.clear();
    }
    setState(() {

    });
  }

  ifBlankReturnZero(String a){
    if(a.isNotEmpty){
      return a;
    }else{
      return '0';
    }
  }

}