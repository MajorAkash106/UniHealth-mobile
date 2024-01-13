import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/MNA_forth.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/badges/status/Strongkid_forth.dart';
import 'package:medical_app/screens/badges/status/Strongkids_second.dart';
class SKDThird extends StatefulWidget {
  @override
  _SKDThirdState createState() => _SKDThirdState();
}

class _SKDThirdState extends State<SKDThird> {
  int _isBMI = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("Strong Kid", IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
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
                      "Is the patient in a poor nutritional status judged with subjective clinical assess-ment: loss of subcutaneous fat and/or loss of muscle mass and/or hollow face?",
                      style: TextStyle(fontSize: 16,fontWeight: FontBold),
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
                              style: new TextStyle(fontSize: 16.0,color: Colors.black54,),
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
                              style: new TextStyle(fontSize: 16.0,color: Colors.black54,),
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
                    child: CustomButton(text: "Next",myFunc: (){Get.to(SKDForth());},)),
              )
            ],),
        ),
      ),
    );
  }


}
