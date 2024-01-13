import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/error_widget.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/NutritionalTherapy/adult_contoller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/customized_controller.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/adult_condition_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../../config/Locale/locale_config.dart';

class AdultIcu extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  AdultIcu({
    this.patientDetailsData,
  });

  @override
  _AdultIcuState createState() => _AdultIcuState();
}

class _AdultIcuState extends State<AdultIcu> {
  final AdultsContoller _contoller = AdultsContoller();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    getData();
    setLocale();
    getSelectedData();
  }

  double discounted_weight = 0.0;
  double ideal_weight = 0.0;
  double adjusted_weight = 0.0;

  ifEmptyReturn0(String text) {
    if (text.isEmpty) {
      return '0';
    } else {
      return text;
    }
  }

  var getLocale;

  setLocale() async {
    getLocale = await localeConfig.getLocale();
  }

  getData() {
    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      Anthropometry anthropometry = widget.patientDetailsData.anthropometry[0];

      // print('discounted weight: ${anthropometry.discountedWeight}');
      // print('ideal weight: ${anthropometry.idealBodyWeight}');
      // print('adjusted weight: ${anthropometry.adjustedBodyWeight}');
      //
      // print('discounted weight: ${double.parse(anthropometry.discountedWeight)}');

      setState(() {
        discounted_weight =
            double.parse(ifEmptyReturn0(anthropometry.discountedWeight));
        ideal_weight =
            double.parse(ifEmptyReturn0(anthropometry.idealBodyWeight));
        adjusted_weight =
            double.parse(ifEmptyReturn0(anthropometry.adjustedBodyWeight));
      });
    } else {
      print('anthropometry empty');
    }
  }

  getSelectedData() async {
    String conditionn = '';
    for (var a in widget.patientDetailsData.ntdata) {
      print('type: ${a.type},status: ${a.status}');
      if (a.type == NTBoxes.condition) {
        conditionn = await a.result.first.condition;

        print('yress');
        break;
      }
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      _contoller
          .getRouteForMode('Adults-ICU', 'Adults', conditionn,
              widget.patientDetailsData.hospital[0].sId)
          .then((value) {
        setState(() {
          ConditionData data = _contoller.Adult_icu.last;
          _contoller.Adult_icu.removeLast();
          _contoller.Adult_icu.insert(0, data);
        });

        for (var a in _contoller.Adult_icu) {
          if (a.isSelected) {
            setState(() {
              seletedIndex = _contoller.Adult_icu.indexOf(a);
            });
          }
        }
      });
    });
  }

  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();
  final CustomizedController _controller = CustomizedController();
  LocaleConfig localeConfig = LocaleConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar(
          "conditions".tr,
          IconButton(
            icon: Icon(
              Icons.info_outline,
            ),
            onPressed: () {
              Get.to(ReferenceScreen(
                Ref_list: ref_Controller.ADULT_ICU,
              ));
            },
          ),
        ),
        body: Obx(() => ErrorHandler(
              visibility: _contoller.isError.value,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          'adult_icu'.tr,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'attention'.tr,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0),
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
                    ),
                    Expanded(
                        child: Obx(
                      () => ListView(
                        children:
                            _contoller.Adult_icu.map((e) => _radioWidget(e))
                                .toList(),
                      ),
                    )),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'confirm'.tr,
                              myFunc: () async {
                                onpress();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  int seletedIndex;

  Widget _radioWidget(ConditionData e) {
    if (e.availableIn.indexOf(getLocale.languageCode) != -1) {
      return Padding(
          padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
          child: GestureDetector(
            onTap: () {
              setState(() {
                for (var a in _contoller.Adult_icu) {
                  setState(() {
                    a.isSelected = false;
                  });
                }
                e.isSelected = true;
              });

              setState(() {
                seletedIndex = _contoller.Adult_icu.indexOf(e);
                print('selected index: $seletedIndex');
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
                        '${e.condition}',
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
    } else {
      return SizedBox();
    }
  }

  returnWeight(String weightType) {
    if (weightType
        .toLowerCase()
        .trim()
        .contains('WEIGHT AFTER DISCOUNTS'.toLowerCase().trim())) {
      return discounted_weight;
    } else if (weightType
        .toLowerCase()
        .trim()
        .contains('ideal body weight'.toLowerCase().trim())) {
      return ideal_weight;
    } else if (weightType
        .toLowerCase()
        .trim()
        .contains('adjusted body weight'.toLowerCase().trim())) {
      return adjusted_weight;
    }
  }

  onpress() async {
    ConditionData data = _contoller.Adult_icu[seletedIndex];

    print('condition: ${data.condition}');
    print('condition notes: ${data.info}');
    print('condition: ${jsonEncode(data)}');

    print(
        "${double.parse(ifEmptyReturn0(data.valuekcalmin))} * ${returnWeight(data.kcalmin)}");

    double kcalmin = await double.parse(ifEmptyReturn0(data.valuekcalmin)) *
        returnWeight(data.kcalmin);
    print('kcal min: $kcalmin');

    double kcalmax = await double.parse(ifEmptyReturn0(data.valuekcalmax)) *
        returnWeight(data.kcalmax);
    print('kcal max: $kcalmax');

    double Ptnmin = await double.parse(ifEmptyReturn0(data.valueptnmin)) *
        returnWeight(data.ptnmin);
    print('protien min: $Ptnmin');

    double Ptnmax = await double.parse(ifEmptyReturn0(data.valueptnmax)) *
        returnWeight(data.ptnmax);
    print('protien max: $Ptnmax');

    // Map cutomizedData = {
    //   'min_energy': kcalmin.toStringAsFixed(2),
    //   'max_energy': kcalmax.toStringAsFixed(2),
    //   'min_protien': Ptnmin.toStringAsFixed(2),
    //   'max_protien': Ptnmax.toStringAsFixed(2),
    //
    //   'min_energy_value': ifEmptyReturn0(data.valuekcalmin),
    //   'max_energy_value': ifEmptyReturn0(data.valuekcalmax),
    //   'min_protien_value': ifEmptyReturn0(data.valueptnmin),
    //   'man_protien_value': ifEmptyReturn0(data.valueptnmax),
    //
    // };

    CutomizedData addItem = CutomizedData();
    addItem.minEnergy = kcalmin.toStringAsFixed(2);
    addItem.maxEnergy = kcalmax.toStringAsFixed(2);
    addItem.minProtien = Ptnmin.toStringAsFixed(2);
    addItem.maxProtien = Ptnmax.toStringAsFixed(2);

    addItem.minEnergyValue = ifEmptyReturn0(data.valuekcalmin);
    addItem.maxEnergyValue = ifEmptyReturn0(data.valuekcalmax);
    addItem.minProtienValue = ifEmptyReturn0(data.valueptnmin);
    addItem.manProtienValue = ifEmptyReturn0(data.valueptnmax);

    addItem.lastUpdate = '${DateTime.now()}';
    addItem.condition = data.condition;

    List<CutomizedData> condition =
        await _controller.addCondition(widget.patientDetailsData, addItem);

    Map finalData = {
      'condition': data.condition,
      'info': data.info,
      'lastUpdate': '${DateTime.now()}',
      'cutomized_data': addItem,
      'condition_details': condition
    };

    print('final data: ${jsonEncode(finalData)}');

    _controller.getRouteForMode(
        widget.patientDetailsData, finalData, conditionNT.customized);
  }
}

class staticList {
  String optionText;
  bool isSelected;

  staticList({this.optionText, this.isSelected});
}
