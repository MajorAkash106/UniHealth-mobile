import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/NutritionalTherapy/customized_controller.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class Pregnancy_Lagtation_page2 extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final double PAC;
  final int indexPAC;
  Pregnancy_Lagtation_page2({this.patientDetailsData, this.PAC, this.indexPAC});

  @override
  _Pregnancy_Lagtation_page2State createState() =>
      _Pregnancy_Lagtation_page2State();
}

class _Pregnancy_Lagtation_page2State extends State<Pregnancy_Lagtation_page2> {
  final CustomizedController _controller = CustomizedController();
  List<pregnencyLac> listOption = <pregnencyLac>[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listOption.add(pregnencyLac(
        optionText: 'first_trimester'.tr, isSelected: false));
    listOption.add(pregnencyLac(
        optionText: 'second_trimester'.tr, isSelected: false));
    listOption.add(pregnencyLac(
        optionText: 'third_trimester'.tr, isSelected: false));
    listOption.add(pregnencyLac(
        optionText: 'first_semester'.tr, isSelected: false));
    listOption.add(pregnencyLac(
        optionText: 'second_semester'.tr, isSelected: false));

    getData();
    getSelected();
  }

  getSelected() async {
    String conditionn = '';
    for (var a in widget.patientDetailsData.ntdata) {
      print('type: ${a.type},status: ${a.status}');
      if (a.type == NTBoxes.condition) {
        conditionn = await a.result.first.condition;

        for (var b in listOption) {
          if (b.optionText.contains(conditionn)) {
            setState(() {
              b.isSelected = true;
              selectedIndex = listOption.indexOf(b);
            });

            break;
          }
        }

        print('yress');
        break;
      }
    }
  }

  double discounted_weight = 0.0;
  double ideal_weight = 0.0;
  double adjusted_weight = 0.0;
  double HEIGHT = 0.0;
  int AGE = 0;

  String heightType = '';

  ifEmptyReturn0(String text) {
    if (text.isEmpty) {
      return '0';
    } else {
      return text;
    }
  }

  getData() {
    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      Anthropometry anthropometry = widget.patientDetailsData.anthropometry[0];

      print('discounted weight: ${anthropometry.discountedWeight}');
      print('ideal weight: ${anthropometry.idealBodyWeight}');
      print('adjusted weight: ${anthropometry.adjustedBodyWeight}');



      setState(() {
        discounted_weight =
            double.parse(ifEmptyReturn0(anthropometry.discountedWeight));
        ideal_weight =
            double.parse(ifEmptyReturn0(anthropometry.idealBodyWeight));
        adjusted_weight =
            double.parse(ifEmptyReturn0(anthropometry.adjustedBodyWeight));

        HEIGHT = double.parse(ifEmptyReturn0(
            "${widget.patientDetailsData.anthropometry[0].heightType == '3' ? widget.patientDetailsData.anthropometry[0].estimatedHeight : widget.patientDetailsData.anthropometry[0].heightMeasuredReported}"));

        heightType = widget.patientDetailsData.anthropometry[0].heightType;
        // widget.patientDetailsData.anthropometry[0].heightType =='3'?
        //     HEIGHT = HEIGHT*100
        //     :  HEIGHT = HEIGHT*0;
      });
    } else {
      print('anthropometry empty');
    }

    getAgeYearsFromDate(widget.patientDetailsData.dob).then((age) {
      setState(() {
        AGE = age;
      });
    });
  }

  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          'conditions'.tr,
          IconButton(
            icon: Icon(
              Icons.info_outline,
            ),
            onPressed: () {
              Get.to(ReferenceScreen(
                Ref_list: ref_Controller.pregAndLac,
              ));
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Center(
                child: Text(
              'pregnancy_lactation'.tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
            )),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    '${'attention'.tr}:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                BmiAgeWard(
                  patientDetailsData: widget.patientDetailsData,
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: listOption.map((e) => _radioWidget(e)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Container(
                width: Get.width,
                child: CustomButton(
                  text: "confirm".tr,
                  myFunc: () {
                    if (selectedIndex != -1) {
                      onpress();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;

  Widget _radioWidget(pregnencyLac e) {
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

              setState(() {
                selectedIndex = listOption.indexOf(e);
                print('selected index : $selectedIndex');
              });
            });
          },
          child: Container(
            child: Row(
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
          ),
        ));
  }

  onpress() {
    pregnencyLac data = listOption[selectedIndex];

    print('selected: ${data.optionText}');
    print('index: ${selectedIndex}');

    print('PAC: ${widget.PAC}');
    print('discounted weight: ${discounted_weight}');
    print('HEIGHT: ${HEIGHT}');
    print('heightType: ${heightType}');
    print('AGE: ${AGE}');

    // if (heightType == '3') {
    //   setState(() {
    //     HEIGHT = HEIGHT * 100;
    //   });
    // }

    GETPRENENCYANDLAC(
            selectedIndex, widget.PAC, discounted_weight, HEIGHT / 100, AGE)
        .then((res) {
      print('res: ${jsonEncode(res)}');

      Map cutomizedData = {
        'min_energy': res.minEnergy,
        'max_energy': res.maxEnergy,
        'min_protien': res.minProtien,
        'max_protien': res.maxProtien,
        'min_energy_value': ifEmptyReturn0(res.minEnergyValue),
        'max_energy_value': ifEmptyReturn0(res.maxEnergyValue),
        'min_protien_value': ifEmptyReturn0(res.minProtienValue),
        'man_protien_value': ifEmptyReturn0(res.manProtienValue),
      };

      CutomizedData addItem = CutomizedData();
      addItem.minEnergy = res.minEnergy;
      addItem.maxEnergy = res.maxEnergy;
      addItem.minProtien = res.minProtien;
      addItem.maxProtien = res.maxProtien;

      addItem.minEnergyValue = ifEmptyReturn0(res.minEnergyValue);
      addItem.maxEnergyValue = ifEmptyReturn0(res.maxEnergyValue);
      addItem.minProtienValue = ifEmptyReturn0(res.minProtienValue);
      addItem.manProtienValue = ifEmptyReturn0(res.manProtienValue);

      addItem.lastUpdate = '${DateTime.now()}';
      addItem.condition =  data.optionText;

      List<CutomizedData> condition;
      _controller.addCondition(widget.patientDetailsData, addItem).then((value) {
        condition = value;
      });

      Map finalData = {
        'condition': data.optionText,
        'info': '',
        'indexPAC': widget.indexPAC,
        'lastUpdate': '${DateTime.now()}',
        'cutomized_data': addItem,
        'condition_details': condition

        // 'adults_data':"",
        // 'pediatrics':"",
        // 'pregnancy_lactation':"",
      };

      print('final data: ${jsonEncode(finalData)}');
      _controller
          .getRouteForMode(
              widget.patientDetailsData, finalData, conditionNT.customized);
      //     .then((value) {
      //   Get.to(Step1HospitalizationScreen(
      //     patientUserId: widget.patientDetailsData.sId,
      //     index: 4,
      //     statusIndex: 0,
      //   ));
      // });
    });
  }
}

class pregnencyLac {
  String optionText;
  bool isSelected;
  pregnencyLac({this.optionText, this.isSelected});
}
