import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/status_controller/anthropometryController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/EDEMA_screen.dart';
import 'package:medical_app/screens/badges/status/HumanBody.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../config/cons/input_configuration.dart';
import '../../../config/widgets/reference_screen.dart';
import '../../../contollers/other_controller/Refference_notes_Controller.dart';

class AnthropometeryKids extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool isfromStatus;
  AnthropometeryKids({this.patientDetailsData,this.isfromStatus});
  @override
  _AnthropometeryKidsState createState() => _AnthropometeryKidsState();
}

class _AnthropometeryKidsState extends State<AnthropometeryKids> {
  final AnthropometryController _controller = AnthropometryController();

  @override
  void initState() {
    print('rama');
    print(widget.isfromStatus.toString());
    // TODO: implement initState
    refUnitStatus();
    if(widget.patientDetailsData.anthropometry.isNotEmpty) {
      getSelected();
    }
    super.initState();
    
    print('patients data : ${jsonEncode(widget.patientDetailsData)}');
    
  }



  getSelected(){

    setState(() {
      // _heightValue = widget.patientDetailsData.anthropometry[0].heightType;
      // _weightValue = widget.patientDetailsData.anthropometry[0].weightType;


      weightMeasureController.text = widget.patientDetailsData.anthropometry[0].weightMeasuredReported;

      weightMeasureControllerLBS.text = widget.patientDetailsData.anthropometry[0].weightMeasuredReportedLBS;

      heightMeasureController.text = widget.patientDetailsData.anthropometry[0].heightMeasuredReported;
      heightMeasureControllerInches.text = widget.patientDetailsData.anthropometry[0].heightMeasuredReported_inch;

      // ChangeWeightStatus();ChangeHeightStatus()



    });

  }


  // double inchesTocm = 2.54;
  // double cmToinch = 0.393701;
  // double LbsTokg = 0.453592;
  // double kg1toLBS = 2.20462;


  double inchesTocm = 2.54;
  double cmToinch = 0.393701;
  double LbsTokg = 0.453592;
  double kg1toLBS = 2.20462;

  changeDataUnit(){

    if(refUnit!='1'){


      heightMeasureController.text = (double.parse(heightMeasureControllerInches.text.isEmpty?'0':heightMeasureControllerInches.text) * inchesTocm).toStringAsFixed(2);
      weightMeasureController.text = (double.parse(weightMeasureControllerLBS.text.isEmpty?'0':weightMeasureControllerLBS.text) * LbsTokg).toStringAsFixed(2);

      print('heightMeasureController: ${heightMeasureController.text}');
      print('weightMeasureController: ${weightMeasureController.text}');

    }else{


      heightMeasureControllerInches.text = (double.parse(heightMeasureController.text.isEmpty?'0':heightMeasureController.text) * cmToinch).toStringAsFixed(2);
      weightMeasureControllerLBS.text = (double.parse(weightMeasureController.text.isEmpty?'0':weightMeasureController.text) * kg1toLBS).toStringAsFixed(2);

      print('heightMeasureControllerInches: ${heightMeasureControllerInches.text}');
      print('weightMeasureControllerLBS: ${weightMeasureControllerLBS.text}');

    }

  }



  String _heightValue = '0';
  String _weightValue = '0';

  bool WieghtMeasureEnbale = true;

  bool HieghtMeasureEnbale = true;

  final HistoryController _historyController = HistoryController();
  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: BaseAppbar('anthropometry'.tr,
        //   null,
          IconButton(icon: Icon(Icons.info), onPressed: (){
        // select_unit();
            Get.to(ReferenceScreen(
              Ref_list: ref_controller.Anthropomatry_Ref_list,
            ));
        })
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Card(
                          color: card_color,
                          elevation: 1.6,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'weight'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.0,
                                        color: appbar_icon_color),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // width: 150.0,
                                    child: DropdownButton(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0),
                                        iconEnabledColor: primary_color,
                                        isExpanded: false,
                                        iconSize: 30.0,
                                        dropdownColor: Colors.white,
                                        hint: Text(
                                          "measured".tr,
                                        ),
                                        value: _weightValue,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('measured'.tr),
                                            value: '0',
                                          ),
                                          // DropdownMenuItem(
                                          //     child: Text('Reported'),
                                          //     value: '1'),
                                        ],
                                        onChanged: (value) {
                                          setState(() {
                                            _weightValue = value;
                                            print(_weightValue);
                                          });

                                          UnFocusAll();
                                        }),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  _widgetwith("$weightIn",
                                     refUnit == '1'? weightMeasureController:weightMeasureControllerLBS,
                                      changeDataUnit, WieghtMeasureEnbale, _focus1),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'height'.tr,
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18.0,
                                        color: appbar_icon_color),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    // width: 150.0,
                                    child: DropdownButton(
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0),
                                        iconEnabledColor: primary_color,
                                        isExpanded: false,
                                        iconSize: 30.0,
                                        dropdownColor: Colors.white,
                                        hint: Text(
                                          "measured".tr,
                                        ),
                                        value: _heightValue,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('measured'.tr),
                                            value: '0',
                                          ),
                                          // DropdownMenuItem(
                                          //     child: Text('Reported'),
                                          //     value: '1'),
                                        ],
                                        onChanged: (value) {
                                          UnFocusAll();
                                          setState(() {
                                            _heightValue = value;
                                            print(_heightValue);
                                          });
                                        }),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  _widgetwith('$heightIn',
                                      refUnit == '1'?
                                      heightMeasureController
                                      :heightMeasureControllerInches,
                                      changeDataUnit, HieghtMeasureEnbale, _focus2),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: Get.width / 1.2,
                  child: CustomButton(
                    text: 'save'.tr,
                    myFunc: () {

                      if(weightMeasureController.text.isNotEmpty && heightMeasureController.text.isNotEmpty) {
                        _focus1.unfocus();
                        _focus2.unfocus();
                        if(double.parse(heightMeasureController.text)>=45) {
                          onSaved();
                        }else{

                          if(refUnit =='1') {
                            onSaved();
                            // ShowMsg('Sorry!, Kid height is less 45 cm');
                          }else{
                            onSaved();
                            // ShowMsg('Sorry!, Kid height is less 17.7165 inch');
                          }
                        }
                      }else{
                        ShowMsg('all_mandatory'.tr);
                      }

                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _widgetwith(String measurementIn, TextEditingController controller,
      Function _fun, bool enable, FocusNode focus) {
    return Row(
      children: [
        // SizedBox(width: 30,),
        Container(
            height: 40,
            width: 100.0,
            child: texfld('', 'Kg', controller, _fun, enable, focus)),
        SizedBox(
          width: 5,
        ),
        Text(
          '$measurementIn',
          style: TextStyle(
            color: appbar_icon_color,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        )
      ],
    );
  }

  var weightMeasureController = TextEditingController();
  var weightMeasureControllerLBS = TextEditingController();
  var ACController = TextEditingController();
  var MUACController = TextEditingController();
  var CALFController = TextEditingController();
  var TSTController = TextEditingController();
  var EstimatedWeightController = TextEditingController();

  var EDEMAController = TextEditingController();
  var ASCITIESController = TextEditingController();
  var AMPUTATIONController = TextEditingController();
  var discountedWeightController = TextEditingController();

  var heightMeasureController = TextEditingController();
  var heightMeasureControllerInches = TextEditingController();
  var KneeHeightController = TextEditingController();
  var ArmSpanController = TextEditingController();
  var EstimatedHeightController = TextEditingController();

  FocusNode _focus1 = new FocusNode();
  FocusNode _focus2 = new FocusNode();

  Widget texfld(String hint, String suffix, TextEditingController controller,
      Function _fun, bool enable, FocusNode focus) {
    return TextField(
      controller: controller,
      enabled: enable,
      focusNode: focus,
      // keyboardType: InputConfiguration.inputTypeWithDot,
      keyboardType: TextInputType.numberWithOptions(decimal: true,),
      textInputAction: InputConfiguration.inputActionNext,
      inputFormatters: [ReplaceCommaFormatter()],
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
        // suffixIcon: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       '${suffix}',
        //       style: TextStyle(
        //         color: Colors.black54,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     SizedBox(
        //       height: 5.0,
        //     )
        //   ],
        // )
      ),
    );
  }

  Widget _button(String text, Function myFunc) {
    return Container(
      height: 40,
      width: 150,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        // padding: EdgeInsets.all(15.0),
        onPressed: myFunc,
        color: primary_color,
        textColor: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$text", style: TextStyle(fontSize: 14)),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
            )
          ],
        ),
      ),
    );
  }

  UnFocusAll() {
    _focus1.unfocus();
    _focus2.unfocus();
  }

  String BMIValue;

  getBMI() {
    print('PATIENTS WITH AMPUTATIONS AND ONLY WEIGHT ESTIMATED');
    print('WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)');
    // BMI = WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)

    double discountedWeight = double.parse(weightMeasureController.text);
    double height = double.parse(heightMeasureController.text)/100;
    double heightInMeter = height;

    print('$discountedWeight / ($heightInMeter * $heightInMeter)');
    double total = discountedWeight / (heightInMeter * heightInMeter);

    print('BMI : ${total.toStringAsFixed(2) + " kg/m2"}');

    setState(() {
      BMIValue = total.toStringAsFixed(2);
    });
  }
  // double kg1toLBS = 2.20462;

  void onSaved() async {
    await getBMI();


    // double measureWeightLBS;
    // double measureWeight;

    // if(refUnit == '1'){
    //   setState(() {
    //    measureWeightLBS = double.parse(weightMeasureController.text.isEmpty?'0':weightMeasureController.text) * kg1toLBS;
    //   measureWeight = double.parse(weightMeasureController.text);
    // });}else{
    //    measureWeightLBS = double.parse(weightMeasureControllerLBS.text);
    //    measureWeight = double.parse(weightMeasureControllerLBS.text)/kg1toLBS;
    // }

    Map data = {
      'weightType': weightMeasureController.text.isEmpty ? '1' : '0',
      'weightMeasuredReported': weightMeasureController.text,
      'weightMeasuredReportedLBS': weightMeasureControllerLBS.text,
      'ac': '',
      'MUAC': '',
      'CALF': '',
      'TST': '',
      'mamc': '',
      'mamcper': '',
      'estimatedWeight': '',
      'edema': '',
      'edemaData': [],
      'ascities': '',
      'ascitiesData': [],
      'amputation': '',
      'amputationPer': '',
      'amputationData': [],
      //for kid will be one weight
      'discountedWeight': weightMeasureController.text,
      'discountedWeightLBS': weightMeasureControllerLBS.text,
      'heightType': heightMeasureController.text.isEmpty ? '1' : '0',
      'heightMeasuredReported': heightMeasureController.text,
      'heightMeasuredReported_inch': heightMeasureControllerInches.text,
      'kneeHeight': '',
      'armSpan': '',
      'estimatedHeight': '',
      'bmi': BMIValue,
      'idealBodyWeight': '',
      'idealBodyWeightLBS': '',
      'adjustedBodyWeight': '',
      'adjustedBodyWeightLBS': '',
      'lastUpdate': '${DateTime.now()}',
    };

    print('data: ${data}');
    print('data: ${jsonEncode(data)}');


    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
      if(internet!=null && internet){

        _controller.saveData(widget.patientDetailsData, [data]).then((value){

          _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.anthroHistory, [data]).then((value){

            if(widget.isfromStatus) {
              Get.to(Step1HospitalizationScreen(
                    patientUserId: widget.patientDetailsData.sId, index: 2,));
            }else{
              Get.back();
            }
          });
        });

      }else{
        final OfflineHandler _offlineHandler = OfflineHandler();

        _offlineHandler.handleAnthroOffline(data, widget.patientDetailsData);
        ShowMsg('data_updated_successfully'.tr);
      }
    });



  }



  var ref_value;
  void select_unit() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      ref_value = 'LBS & INCHES';
                                      _radioValue = 0;
                                      changeRefUnit(0);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child:   Row(
                                    children: [
                                      new Radio(
                                        value: 0,
                                        groupValue: _radioValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            ref_value = 'LBS & INCHES';
                                            _radioValue = value;
                                            changeRefUnit(_radioValue);
                                            // Get.back();
                                            // select_unit();
                                          });
                                        },
                                      ),
                                      new Text(
                                        'LBS & INCHES',
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      ref_value = 'KG & METERS';
                                      _radioValue = 1;
                                      changeRefUnit(1);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child:   Row(
                                    children: [
                                      new Radio(
                                        value: 1,
                                        groupValue: _radioValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            ref_value = 'KG & METERS';
                                            _radioValue = value;
                                            changeRefUnit(_radioValue);
                                            // Get.back();
                                            // select_unit();
                                          });
                                        },
                                      ),
                                      new Text(
                                        'KG & METERS',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text: "Save",
                                      myFunc: () async{
                                       // Get.back();
                                        await changeRefUnit(_radioValue);
                                        await Get.back();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  int _radioValue = -1;


  void changeRefUnit(int refUnit){

    print('----------$refUnit------------');
    if(refUnit ==0){
      print('LBS & INCHES');
      MySharedPreferences.instance
          .setStringValue(Session.refUnit, '$refUnit');
    }else{
      print('KG & METERS');
      MySharedPreferences.instance
          .setStringValue(Session.refUnit, '$refUnit');
    }

    refUnitStatus();



  }

  String refUnit = '';
  String weightIn = '';
  String heightIn = '';

  refUnitStatus()async{
    String refU = await MySharedPreferences.instance.getStringValue(Session.refUnit);
    setState(() {
      refUnit = refU.isEmpty?'1':refU;

      weightIn = refUnit=='1'?'kg':'lbs';

      heightIn = refUnit=='1'?'cm':'inch';
    });
    print('reference unit: ${refUnit}');






    // if(refUnit =='0'){
    //
    //   EstimatedWeightControllerLBS.clear();
    //   discountedWeightControllerLBS.clear();
    //   EstimatedHeightControllerInches.clear();
    //
    // }

  }
}
