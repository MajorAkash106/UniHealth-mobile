import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/Phenotypic_third.dart';

class PenotypicSecondScreen extends StatefulWidget {
  @override
  _PenotypicSecondScreenState createState() => _PenotypicSecondScreenState();
}

class _PenotypicSecondScreenState extends State<PenotypicSecondScreen> {
  int _isBMI = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("Phenotypic Criteria", IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOW BODY MASS INDEX - BMI (kg/m2)",
                      style: TextStyle(fontSize: 16,color: Colors.black54),
                    ),
                    SizedBox(height: 30,),
                    Text(
                      "IS THE PATIENT ASIAN?",
                      style: TextStyle(fontSize: 16,color: Colors.black54),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            new Radio(
                              value: 0,
                              groupValue: _isBMI,
                              onChanged: (int value){
                                setState(() {
                                  _isBMI = value;
                                });
                              },
                            ),
                            new Text(
                              'Yes',
                              style: new TextStyle(fontSize: 16.0,color: Colors.black54),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            new Radio(
                              value: 1,
                              groupValue: _isBMI,
                              onChanged: (int value){
                                setState(() {
                                  _isBMI = value;
                                });
                              },
                            ),
                            new Text(
                              'No',
                              style: new TextStyle(fontSize: 16.0,color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],),
              ),
              // SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                    width: Get.width,
                    child: CustomButton(text: "Next",myFunc: (){
                    Get.to(PenotypicThirdScreen());
                    },)),
              )
            ],),
        ),
      ),
    );
  }


}
