import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/MNA_forth.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/badges/status/Strongkids_second.dart';
class SKDFirst extends StatefulWidget {
  @override
  _SKDFirstState createState() => _SKDFirstState();
}

class _SKDFirstState extends State<SKDFirst> {
  int _isBMI = 0;
  int indexc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("Strong Kid", IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
    Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Is there an underlying illness with risk for Malnutrition (see list - clickable->show list, shown below) or expectedmajor surgery?",
                      style: TextStyle(fontSize: 16,fontWeight: FontBold),),
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
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                    width: Get.width,
                    child: CustomButton(text: "Next",myFunc: (){
                      Get.to(SKDSecond());

                      },)),
              )
            ],),
        ),
      )
    );
  }




}
