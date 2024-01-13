import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/MNA_forth.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/badges/status/Strongkids_third.dart';

class SKDSecond extends StatefulWidget {
  @override
  _SKDSecondState createState() => _SKDSecondState();
}

class _SKDSecondState extends State<SKDSecond> {
  int _isBMI = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          "Strong Kid",
          IconButton(
              icon: Icon(
            Icons.info_outline,
            color: card_color,
          ),onPressed: (){Get.to(ReferenceScreen());},)),
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
                      "Is one of the following items present?",
                      style: TextStyle(fontSize: 16, fontWeight: FontBold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1. Excessive diarrhea (≥5 per day) and/ or vomiting(> 3 times/ day) during the last 1-3 days",
                      style: TextStyle(fontSize: 14, color: Colors.black54,),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "2. Reduced food intake during the last 1-3 days",
                      style: TextStyle(fontSize: 14, color: Colors.black54,),
                    ),
                    SizedBox(height: 10,),Text(
                      "3. Pre-existing nutritional intervention (e.g. ONS or tube feeding)",
                      style: TextStyle(fontSize: 14, color: Colors.black54,),
                    ),
                    SizedBox(height: 10,),Text(
                      "4. Inability to consume adequate nutritional intake because ofpain",
                      style: TextStyle(fontSize: 14, color: Colors.black54,),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Row(
                          children: [
                            new Radio(
                              value: 0,
                              groupValue: _isBMI,
                              onChanged: (int value) {
                                setState(() {
                                  _isBMI = value;
                                });
                              },
                            ),
                            new Text(
                              'Yes',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.black54,),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            new Radio(
                              value: 1,
                              groupValue: _isBMI,
                              onChanged: (int value) {
                                setState(() {
                                  _isBMI = value;
                                });
                              },
                            ),
                            new Text(
                              'No',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.black54,),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                    width: Get.width,
                    child: CustomButton(
                      text: "Next",
                      myFunc: () {
                        Get.to(SKDThird());
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
