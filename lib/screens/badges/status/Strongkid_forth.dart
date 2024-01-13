import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';

import 'package:medical_app/screens/badges/status/Strongkids_fifth.dart';


class SKDForth extends StatefulWidget {
  @override
  _SKDForthState createState() => _SKDForthState();
}

class _SKDForthState extends State<SKDForth> {
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
                      "Is there weight loss (all ages) and/or noincrease in weight/height (infants <1year) during the last few week-months?",
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
                    child: CustomButton(text: "Next",myFunc: (){Get.to(SKDFifth());},)),
              )
            ],),
        ),
      ),
    );
  }


}
