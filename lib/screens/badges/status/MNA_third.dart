import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/screens/badges/status/MNA_forth.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
class MNAThirdScreen extends StatefulWidget {
  @override
  _MNAThirdScreenState createState() => _MNAThirdScreenState();
}

class _MNAThirdScreenState extends State<MNAThirdScreen> {
  int _isBMI = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("MNA", IconButton(icon: Icon(Icons.info_outline,color: card_color,))),
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
                    SizedBox(height: 20,),
                    Center(child: NNILogo_CopyRightText()),
                    SizedBox(height: 20,),
                    Text(
                      "Has suffered psychological stress or acute disease in the past 3 months?",
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

              Column(
                children: [
                  Center(child: CopyRightText()),
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Container(
                        width: Get.width,
                        child: CustomButton(text: "Next",myFunc: (){Get.to(MNAForthScreen());},)),
                  ),
                ],
              )
            ],),
        ),
      ),
    );
  }


}
