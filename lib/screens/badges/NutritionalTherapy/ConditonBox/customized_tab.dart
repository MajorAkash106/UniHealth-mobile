import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/customized_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../config/cons/input_configuration.dart';

class staticList {
  String optionText;
  bool isSelected;

  staticList({this.optionText, this.isSelected});
}

class Customized_screen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  Customized_screen({this.patientDetailsData});

  @override
  _Customized_screenState createState() => _Customized_screenState();
}

class _Customized_screenState extends State<Customized_screen> {
  var minEnergy = TextEditingController();

  var maxEnergy = TextEditingController();

  var minProtein = TextEditingController();
  var maxProtein = TextEditingController();

  final CustomizedController _controller = CustomizedController();
  List<staticList> listOptionDropdown = <staticList>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listOptionDropdown.add(staticList(
        optionText: 'weight_after_discount'.tr.toUpperCase(),
        isSelected: false));
    listOptionDropdown.add(staticList(
        optionText: 'ideal_body_weight'.tr.toUpperCase(), isSelected: false));
    listOptionDropdown.add(staticList(
        optionText: 'adjusted_body_weight'.tr.toUpperCase(),
        isSelected: false));

    getData();
    getCustomized(widget.patientDetailsData).then((value) {
      setState(() {
        minEnergy.text = value.minEnergyValue;
        maxEnergy.text = value.maxEnergyValue;
        minProtein.text = value.minProtienValue;
        maxProtein.text = value.manProtienValue;
      });
    });
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

  getData() {
    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      Anthropometry anthropometry = widget.patientDetailsData.anthropometry[0];

      // print('discounted weight: ${anthropometry.discountedWeight}');
      print('ideal weight: ${anthropometry.idealBodyWeight}');
      print('adjusted weight: ${anthropometry.adjustedBodyWeight}');

      // print('discounted weight: ${double.parse(anthropometry.discountedWeight)}');

      setState(() {
        discounted_weight =
            double.parse(ifEmptyReturn0(anthropometry.discountedWeight));
        ideal_weight =
            double.parse(ifEmptyReturn0(anthropometry.idealBodyWeight));
        adjusted_weight =
            double.parse(ifEmptyReturn0(anthropometry.adjustedBodyWeight));
      });

      if (discounted_weight == 0) {
        listOptionDropdown.removeAt(0);
      } else if (ideal_weight == 0) {
        listOptionDropdown.removeAt(1);
      } else if (adjusted_weight == 0) {
        listOptionDropdown.removeAt(2);
      }
      setState(() {});
    } else {
      print('anthropometry empty');
    }
  }

  String _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('conditions'.tr, null),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
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
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40.0,
                          ),
                          Center(
                              child: Text(
                            'customized_capital'.tr.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                          SizedBox(
                            height: 50.0,
                          ),
                          Card(
                            color: card_color,
                            elevation: 1.6,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          'energy'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              color: appbar_icon_color),
                                        ),
                                        Text(
                                          '(kcal/kg)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              color: appbar_icon_color),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Min',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          width: 100.0,
                                          height: 40.0,
                                          child: texfld(
                                            '',
                                            minEnergy,
                                            () {},
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Max',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                        Container(
                                          width: 100.0,
                                          height: 40.0,
                                          child: texfld(
                                            '',
                                            maxEnergy,
                                            () {},
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.0,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'protein'.tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              color: appbar_icon_color),
                                        ),
                                        Text(
                                          '(g/kg)',
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16.0,
                                              color: appbar_icon_color),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      width: 100.0,
                                      height: 40.0,
                                      child: texfld(
                                        '',
                                        minProtein,
                                        () {},
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15.0,
                                    ),
                                    Container(
                                      width: 100.0,
                                      height: 40.0,
                                      child: texfld(
                                        '',
                                        maxProtein,
                                        () {},
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'weight'.tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 16.0,
                                          color: appbar_icon_color),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          // color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          border: Border.all(
                                            color: Colors.black26,
                                            width: 1,
                                          )),
                                      height: 40.0,
                                      // width: MediaQuery.of(context).size.width,
                                      child:
                                          //Container(child: Center(child: _value==0?,),),
                                          Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0),
                                              iconEnabledColor: Colors.black,
                                              // isExpanded: true,
                                              iconSize: 30.0,
                                              dropdownColor: Colors.white,
                                              hint: Text('select'.tr),
                                              value: _value,
                                              items: listOptionDropdown
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      child: Text(
                                                        '${e.optionText}',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      value: '${e.optionText}',
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value;
                                                  print(_value);
                                                });
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Container(
                      width: Get.width,
                      child: CustomButton(
                        text: "confirm".tr,
                        myFunc: () {
                          onpress();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget texfld(
    String hint,
    TextEditingController controller,
    Function _fun,
  ) {
    return TextField(
      controller: controller,
      // enabled: enable,
      //focusNode: focus,
      keyboardType: InputConfiguration.inputTypeWithDot,
      textInputAction: InputConfiguration.inputActionNext,
      inputFormatters: InputConfiguration.formatDotOnly,
      onChanged: (_value) {
        _fun();
      },
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        border: new OutlineInputBorder(
            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            borderSide:
                BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
            ),
        hintStyle: TextStyle(
            color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  returnSelectedWeight() {
    if (_value == "weight_after_discount".tr.toUpperCase()) {
      return discounted_weight;
    } else if (_value == "ideal_body_weight".tr.toUpperCase()) {
      return ideal_weight;
    } else if (_value == "adjusted_body_weight".tr.toUpperCase()) {
      return adjusted_weight;
    }
  }

  onpress() async {
    print('energy min:${minEnergy.text}, max :${maxEnergy.text}');
    print('protien min:${minProtein.text}, max :${maxProtein.text}');

    if (minEnergy.text.isEmpty ||
        maxEnergy.text.isEmpty ||
        minProtein.text.isEmpty ||
        maxProtein.text.isEmpty ||
        _value == null) {
      ShowMsg('all_mandatory'.tr);
    } else {
      print('OK');

      double weight = returnSelectedWeight();
      print('weight with : $weight');

      // Map cutomizedData = {
      //   'min_energy': (double.parse(ifEmptyReturn0(minEnergy.text)) * weight).toStringAsFixed(2),
      //   'max_energy':  (double.parse(ifEmptyReturn0(maxEnergy.text)) * weight).toStringAsFixed(2),
      //   'min_protien':  (double.parse(ifEmptyReturn0(minProtein.text)) * weight).toStringAsFixed(2),
      //   'max_protien':  (double.parse(ifEmptyReturn0(maxProtein.text)) * weight).toStringAsFixed(2),
      //
      //   'min_energy_value': minEnergy.text,
      //   'max_energy_value': maxEnergy.text,
      //   'min_protien_value': minProtein.text,
      //   'man_protien_value': maxProtein.text,
      //   'lastUpdate': '${DateTime.now()}',
      //   'condition': "CUSTOMIZED",
      //
      // };

      CutomizedData addItem = CutomizedData();
      addItem.minEnergy =
          (double.parse(ifEmptyReturn0(minEnergy.text)) * weight)
              .toStringAsFixed(2);
      addItem.maxEnergy =
          (double.parse(ifEmptyReturn0(maxEnergy.text)) * weight)
              .toStringAsFixed(2);
      addItem.minProtien =
          (double.parse(ifEmptyReturn0(minProtein.text)) * weight)
              .toStringAsFixed(2);
      addItem.maxProtien =
          (double.parse(ifEmptyReturn0(maxProtein.text)) * weight)
              .toStringAsFixed(2);

      addItem.minEnergyValue = minEnergy.text;
      addItem.maxEnergyValue = maxEnergy.text;
      addItem.minProtienValue = minProtein.text;
      addItem.manProtienValue = maxProtein.text;

      addItem.lastUpdate = '${DateTime.now()}';
      addItem.condition = "CUSTOMIZED";

      List<CutomizedData> condition =
          await _controller.addCondition(widget.patientDetailsData, addItem);

      Map finalData = {
        'condition': "CUSTOMIZED",
        'lastUpdate': '${DateTime.now()}',
        'cutomized_data': addItem,
        'condition_details': condition
        // 'adults_data':"",
        // 'pediatrics':"",
        // 'pregnancy_lactation':"",
      };
      print('json: ${jsonEncode(finalData)}');

      _controller.getRouteForMode(
          widget.patientDetailsData, finalData, conditionNT.customized);
      //     .then((value) {
      //   Get.to(Step1HospitalizationScreen(
      //     patientUserId: widget.patientDetailsData.sId,
      //     index: 4,
      //     statusIndex: 0,
      //   ));
      // });
    }
  }
}
