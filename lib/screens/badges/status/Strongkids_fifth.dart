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
class SKDFifth extends StatefulWidget {
  @override
  _SKDFifthState createState() => _SKDFifthState();
}

class _SKDFifthState extends State<SKDFifth> {
  int _isBMI = 0;

   List <textcontent> _textcopntent = [
     textcontent('Psychiatric eating disorder'),
     textcontent('Burns'),
     textcontent('Bronchopulmonary dysplasia (up to age 2 years)'),
     textcontent('Celiac Disease (active)'),
     textcontent('Cystic Fibrosis'),
     textcontent('Dysmaturity/prematurity (until corrected age 6 months)'),
     textcontent('Infectious Disease'),
     textcontent('Inflammatory bowel disease'),
     textcontent('Cancer'),
     textcontent('Liver disease, chronic'),
     textcontent('Kidney disease, chronic'),
     textcontent('Pancreatitis'),
     textcontent('Short bowel syndrome'),
     textcontent('Muscle disease'),
     textcontent('Trauma'),
     textcontent('Mental handicap/retardation'),
     textcontent('Expected major surgery'),
     textcontent('Not specified (classified by doctor)'),
  ];

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("Strong Kid", IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diseases with risk of malnutrition  (list from item 1)",
                      style: TextStyle(fontSize: 16,fontWeight: FontBold),
                    ),
                  ],),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _textcopntent.length,
                  itemBuilder: (context,index)=> Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                    "${index+1}. ${_textcopntent[index].title}",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                    width: Get.width,
                    child: CustomButton(text: "Save",myFunc: (){
                      for (var i = 0; i < 5; i++) {
                        Get.back();
                      }
                    },)),
              )
            ],),
        ),
      ),
    );
  }


}

class textcontent{
  final String title;
  textcontent(this.title);
}