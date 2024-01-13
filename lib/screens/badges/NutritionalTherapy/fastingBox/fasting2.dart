import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/oral_diet.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/textfields.dart';
import 'package:medical_app/contollers/NutritionalTherapy/fastingOralDietController.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class Fasting2 extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String fastingReason;
  final String description;
  Fasting2({this.patientDetailsData, this.fastingReason, this.description});

  @override
  _Fasting2State createState() => _Fasting2State();
}

class _Fasting2State extends State<Fasting2> {
  List<staticList> listOption = <staticList>[];
  final FastingOralDietController fastingOralDietController =
      FastingOralDietController();
  TextEditingController fasting_reason = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listOption.add(staticList(
        optionText: 'fasting_after_abdominal_surgery'.tr, isSelected: false));
    listOption.add(staticList(
        optionText: 'fasting_for_surgery_procedures'.tr, isSelected: false));
    listOption
        .add(staticList(optionText: 'patient_refuses'.tr, isSelected: false));
    listOption
        .add(staticList(optionText: 'unknown_reason_other'.tr, isSelected: false));
    getSelected();
  }

  getSelected() {
    if (widget.fastingReason != null && widget.fastingReason.isNotEmpty) {
      for (var a in listOption) {
        if (a.optionText.trim().contains(widget.fastingReason.trim())) {
          setState(() {
            a.isSelected = true;
            selectedIndex = listOption.indexOf(a);
          });

          print('scope here');
          break;
        }
      }
    }
    if (widget.description != null) {
      fasting_reason.text = widget.description.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("fasting_oral_diet".tr, null),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            // Center(child:Container(child: Text('Name (kcal/g protein)',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17.0),),),),
            // SizedBox(height: 10.0,),
            Expanded(
              child: ListView(
                children: listOption.map((e) => _radioWidget(e)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'confirm'.tr,
                      myFunc: () async {
                        this.onConfirm();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;
  Widget _radioWidget(staticList e) {
    return Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var a in listOption) {
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;
              selectedIndex = listOption.indexOf(e);
            });
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    e.isSelected
                        ? Icon(
                            Icons.radio_button_checked,
                            size: 25,
                            color: primary_color,
                          )
                        : Icon(
                            Icons.radio_button_off,
                            size: 25,
                          ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: new Text(
                          '${e.optionText}',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                e.isSelected && selectedIndex == 3
                    ? Container(
                        height: 100.0,
                        width: Get.width,
                        child: TextField(
                          controller: fasting_reason,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: "description".tr,
                            hintStyle: TextStyle(
                                color: Colors.black45, fontSize: 13.0),
                          ),
                          maxLength: 30,
                          maxLines: 4,
                        ))
                    : SizedBox()
              ],
            ),
          ),
        ));
  }

  onConfirm() async{
    print('selectedData: ${listOption[selectedIndex].optionText}');

    Map item = {
      'fasting': true,
      'fasting_reason': listOption[selectedIndex].optionText,
      'description': selectedIndex == 3 && fasting_reason.text.trim().isNotEmpty
          ? fasting_reason.text
          : "",
      'lastUpdate': '${DateTime.now()}',
    };

    // List<FastingOralData> addItem = await addItemFASTING(widget.patientDetailsData,item,1);
    List<FastingOralData> addItem = await addItem_inLast3DaysData(widget.patientDetailsData,item,1);

    Map finalData = {
      'fasting': true,
      'fasting_reason': listOption[selectedIndex].optionText,
      'description': selectedIndex == 3 && fasting_reason.text.trim().isNotEmpty
          ? fasting_reason.text
          : "",
      'lastUpdate': '${DateTime.now()}',
      'fasting_oral_data': addItem,
    };




    print('json data: ${jsonEncode(finalData)}');
    if (selectedIndex == 3 && fasting_reason.text.trim().isEmpty) {
      ShowMsg("please_enter_description_first".tr);
    } else if (fasting_reason.text.length > 30) {
      ShowMsg("Description limit is exceeded");
    } else {
      print("all set");
      fastingOralDietController
          .getRouteForModeSave(
              widget.patientDetailsData, finalData, FastingOral.fastingOral)
          .then((value) {
        Get.to(Step1HospitalizationScreen(
          patientUserId: widget.patientDetailsData.sId,
          index: 4,
          statusIndex: 1,
        ));
      });
    }
  }
}

class staticList {
  String optionText;
  bool isSelected;
  staticList({this.optionText, this.isSelected});
}
