import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/palcare_controller/goals_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/adult_condition_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../../config/Locale/locale_config.dart';
import 'adult_icu.dart';

class AdultNonIcu extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  AdultNonIcu({this.patientDetailsData});
  @override
  _AdultNonIcuState createState() => _AdultNonIcuState();
}

class _AdultNonIcuState extends State<AdultNonIcu> {
  final AdultsContoller _contoller = AdultsContoller();
  final CustomizedController _customizedController = CustomizedController();

  List<staticList> listOption = <staticList>[];
  @override
  void initState() {
    super.initState();
    getData();
    setLocale();
    getSelectedData();

  }

  int selectedIndex;


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
  LocaleConfig localeConfig = LocaleConfig();
  var getLocale;

  setLocale()async{
    getLocale  = await localeConfig.getLocale();
  }

  getData(){

    if(widget.patientDetailsData.anthropometry.isNotEmpty){

      Anthropometry anthropometry =  widget.patientDetailsData.anthropometry[0];

      // print('discounted weight: ${anthropometry.discountedWeight}');
      // print('ideal weight: ${anthropometry.idealBodyWeight}');
      // print('adjusted weight: ${anthropometry.adjustedBodyWeight}');
      //
      // print('discounted weight: ${double.parse(anthropometry.discountedWeight)}');

      setState(() {
        discounted_weight = double.parse(ifEmptyReturn0(anthropometry.discountedWeight));
        ideal_weight = double.parse(ifEmptyReturn0(anthropometry.idealBodyWeight));
        adjusted_weight = double.parse(ifEmptyReturn0(anthropometry.adjustedBodyWeight));
      });

    }else{
      print('anthropometry empty');
    }
  }
  returnWeight(String weightType){

    if(weightType.toLowerCase().trim().contains('WEIGHT AFTER DISCOUNTS'.toLowerCase().trim())){

      return discounted_weight;

    }else if(weightType.toLowerCase().trim().contains('ideal body weight'.toLowerCase().trim())){

      return ideal_weight;
    }else if(weightType.toLowerCase().trim().contains('adjusted body weight'.toLowerCase().trim())){

      return adjusted_weight;
    }

  }



  getSelectedData()async{
    String conditionn = '';
    for (var a in widget.patientDetailsData.ntdata) {
      print('type: ${a.type},status: ${a.status}');
      if (a.type == NTBoxes.condition) {


        conditionn = await a.result.first.condition;


        print('yress');
        break;
      }
    }

    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        Future.delayed(const Duration(milliseconds: 100), () {

          _contoller.getRouteForMode('Adults-NON ICU', 'Adults',conditionn,widget.patientDetailsData.hospital[0].sId).then((value) {



            // setState(() {
            // ConditionData data =  _contoller.Adult_non_icu.last;
            //   _contoller.Adult_non_icu.removeLast();
            //   _contoller.Adult_non_icu.insert(2, data);
            // });

            for(var a in _contoller.Adult_non_icu){
              if(a.isSelected){
                setState(() {
                  selectedIndex = _contoller.Adult_non_icu.indexOf(a);
                });
              }
            }

          });
        });

        print('internet avialable');
      }
    });
  }


  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("conditions".tr,  IconButton(
        icon: Icon(
          Icons.info_outline,
        ),
        onPressed: () {
          Get.to(ReferenceScreen(Ref_list: ref_Controller.ADULT_NON_ICU,));

        },
      ),
      ),
      body: Obx(()=>ErrorHandler(
        visibility: _contoller.isError.value,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Container(
                child: Text(
                  'adult_non_icu'.tr,
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
                  BmiAgeWard(patientDetailsData: widget.patientDetailsData,)
                ],
              ),
            ),
            Expanded(
                child: Obx(()=>ListView.builder(
                    shrinkWrap: true,
                    itemCount: _contoller.Adult_non_icu.length,
                    itemBuilder: (context, index) {

                      if(_contoller.Adult_non_icu[index].availableIn.indexOf(getLocale.languageCode) !=-1) {
                        return Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0, bottom: 12.0, right: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Card(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: _contoller
                                                                .Adult_non_icu[index]
                                                                .isSelected
                                                                ? Colors.green
                                                                : Colors.black
                                                                .withAlpha(100)),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                    child: _contoller
                                                        .Adult_non_icu[index]
                                                        .isSelected
                                                        ? Icon(Icons.check,
                                                        size: 20.0,
                                                        color: Colors.green)
                                                        : Icon(
                                                      Icons.check,
                                                      size: 18.0,
                                                      color: Colors.transparent,
                                                    )),
                                                elevation: 4.0,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            setState(() {
                                              for (var i = 0; i <
                                                  _contoller.Adult_non_icu
                                                      .length; i++) {
                                                _contoller.Adult_non_icu[i]
                                                    .isSelected = false;
                                              }

                                              _contoller.Adult_non_icu[index]
                                                  .isSelected =
                                              !_contoller.Adult_non_icu[index]
                                                  .isSelected;


                                              selectedIndex = index;
                                            });
                                          },
                                        ),
                                        // SizedBox(height:15.0,)
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.only(top: 4.0),
                                              child: Text(
                                                _contoller.Adult_non_icu[index]
                                                    .condition
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: black40_color),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ));
                      }else{
                        return SizedBox();
                      }
                    }),)
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'confirm'.tr,
                      myFunc: () async {

                        ConditionData data = _contoller.Adult_non_icu[selectedIndex];

                        print('condition: ${data.condition}');
                        double kcalmin =0.0;
                        double kcalmax = 0.0;
                        double Ptnmin = 0.0;
                        double Ptnmax = 0.0;

                        if(data.valuekcalmin.isEmpty && data.valuekcalmax.isEmpty){

                          kcalmin = 1200.0;
                          kcalmax = (30 * discounted_weight) - 500;

                          Ptnmin = double.parse(ifEmptyReturn0(data.valueptnmin)) * returnWeight(data.ptnmin);
                          print('protien min: $Ptnmin');

                          Ptnmax = double.parse(ifEmptyReturn0(data.valueptnmax)) * returnWeight(data.ptnmax);
                          print('protien max: $Ptnmax');

                        }else{


                          kcalmin = double.parse(ifEmptyReturn0(data.valuekcalmin)) * returnWeight(data.kcalmin);
                          print('kcal min: $kcalmin');

                          kcalmax = double.parse(ifEmptyReturn0(data.valuekcalmax)) * returnWeight(data.kcalmax);
                          print('kcal max: $kcalmax');

                          Ptnmin = double.parse(ifEmptyReturn0(data.valueptnmin)) * returnWeight(data.ptnmin);
                          print('protien min: $Ptnmin');

                          Ptnmax = double.parse(ifEmptyReturn0(data.valueptnmax)) * returnWeight(data.ptnmax);
                          print('protien max: $Ptnmax');

                        }





                        // Map cutomizedData = {
                        //   'min_energy': kcalmin.toStringAsFixed(2),
                        //   'max_energy': kcalmax.toStringAsFixed(2),
                        //   'min_protien': Ptnmin.toStringAsFixed(2),
                        //   'max_protien': Ptnmax.toStringAsFixed(2),
                        //
                        //   'min_energy_value': ifEmptyReturn0(data.valuekcalmin),
                        //   'max_energy_value':ifEmptyReturn0(data.valuekcalmax),
                        //   'min_protien_value': ifEmptyReturn0(data.valueptnmin),
                        //   'man_protien_value': ifEmptyReturn0(data.valueptnmax),
                        //
                        // };


                        CutomizedData addItem = CutomizedData();
                        addItem.minEnergy =   kcalmin.toStringAsFixed(2);
                        addItem.maxEnergy =   kcalmax.toStringAsFixed(2);
                        addItem.minProtien =   Ptnmin.toStringAsFixed(2);
                        addItem.maxProtien =   Ptnmax.toStringAsFixed(2);

                        addItem.minEnergyValue = ifEmptyReturn0(data.valuekcalmin);
                        addItem.maxEnergyValue = ifEmptyReturn0(data.valuekcalmax);
                        addItem.minProtienValue = ifEmptyReturn0(data.valueptnmin);
                        addItem.manProtienValue = ifEmptyReturn0(data.valueptnmax);

                        addItem.lastUpdate =  '${DateTime.now()}';
                        addItem.condition = data.condition;

                        List<CutomizedData> condition = await _customizedController.addCondition(widget.patientDetailsData, addItem);



                        Map finalData = {
                          'condition':data.condition,
                          'info':data.info,
                          'lastUpdate': '${DateTime.now()}',
                          'cutomized_data': addItem,
                          'condition_details': condition



                        };




                        print('final data: ${jsonEncode(finalData)}');
                        // _customizedController.saveData(widget.patientDetailsData, finalData, conditionNT.customized).then((value){
                        //   Get.to(Step1HospitalizationScreen(patientUserId: widget.patientDetailsData.sId,index: 4,statusIndex: 0,));
                        // });
                        _customizedController.getRouteForMode(widget.patientDetailsData, finalData, conditionNT.customized);
                        // _customizedController.saveDataOffline(widget.patientDetailsData, finalData, conditionNT.customized);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),)
    );
  }

  var otherText = TextEditingController();
  Widget _textarea() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
      child: TextField(
        autofocus: false,
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
            hintText: 'Type here...',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
            // filled: true,
            fillColor: Colors.grey),
        maxLines: 2,
        controller: otherText,
      ),
    );
  }
}
