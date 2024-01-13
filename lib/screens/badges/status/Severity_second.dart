import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/Penotypic_second.dart';
import 'package:medical_app/screens/badges/status/Severity_third.dart';

class SeveritySecondScreen extends StatefulWidget {
  @override
  _SeveritySecondScreenState createState() => _SeveritySecondScreenState();
}

class _SeveritySecondScreenState extends State<SeveritySecondScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("Severity",
        null
    ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                    child: Text(
                      "LOW BODY MASS INDEX - BMI (kg/m2)",
                      style: TextStyle(fontSize: 16,color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                    child: Text(
                      "STAGE 1 / MODERATE MALNUTRITION",
                      style: TextStyle(fontSize: 16,color: Colors.black54),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle,size: 13,),
                        SizedBox(width: 10,),
                        Text(
                          "BMI <20 IF <70 YEARS, OR <22 IF ≥70 YEARS",
                          style: TextStyle(fontSize: 12,color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                    child: Text(
                      "STAGE 2 / SEVERE MALNUTRITION",
                      style: TextStyle(fontSize: 16,color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                    child: Row(
                      children: [
                        Icon(Icons.circle,size: 13,),
                        SizedBox(width: 10,),
                        Text(
                          "<18.5 IF <70 YEARS, OR <20 IF ≥70 YEARS",
                          style: TextStyle(fontSize: 12,color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  //Spacer(),
                  // SizedBox(height: 30.0,),
                ],
              ),
            ),
           Padding(
             padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 30.0,right: 20.0),
             child: Container(
                 width: Get.width,
                 child: CustomButton(text: "Next",myFunc: (){ Get.to(SeverityThirdScreen());},)),
           ),
            // SizedBox(height: 10.0,),
          ],
        ),
      ),


    );
  }
}
