import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:medical_app/config/cons/input_configuration.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/mamcfunc.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/status_controller/anthropometryController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/Anthropometry_screen_kids.dart';
import 'package:medical_app/screens/badges/status/EDEMA_screen.dart';
import 'package:medical_app/screens/badges/status/HumanBody.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../config/widgets/reference_screen.dart';

class Anthropometery extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool isFromAnthroTab;
  Anthropometery({this.patientDetailsData, this.isFromAnthroTab});
  @override
  _AnthropometeryState createState() => _AnthropometeryState();
}

class _AnthropometeryState extends State<Anthropometery> {
  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();
  final AnthropometryController _controller = AnthropometryController();

  bool cal = false;

  @override
  void initState() {
    // TODO: implement initState
    print('rama');
    print(widget.isFromAnthroTab.toString());
    refUnitStatus();
    widget.patientDetailsData.anthropometry.isEmpty ? null : getSelected();
    // print('weightMeasuredReportedLBS---------------------: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReportedLBS}');

    _controller.getDataEdema();
    _controller.getDataAscities();
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        cal = true;
      });
    });
  }

  getSelected() async {
    setState(() {
      _heightValue = widget.patientDetailsData.anthropometry[0].heightType;
      _weightValue = widget.patientDetailsData.anthropometry[0].weightType;

      weightMeasureController.text =
          widget.patientDetailsData.anthropometry[0].weightMeasuredReported;
      weightMeasureControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].weightMeasuredReportedLBS;
      heightMeasureController.text =
          widget.patientDetailsData.anthropometry[0].heightMeasuredReported;
      heightMeasureControllerInches.text = widget
          .patientDetailsData.anthropometry[0].heightMeasuredReported_inch;
      ACController.text = widget.patientDetailsData.anthropometry[0].ac;
      ACControllerLBS.text = widget.patientDetailsData.anthropometry[0].ac_inch;
      MUACController.text = widget.patientDetailsData.anthropometry[0].mUAC;
      MUACControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].MUAC_inch;
      CALFController.text = widget.patientDetailsData.anthropometry[0].cALF;
      CALFControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].CALF_inch;
      TSTController.text = widget.patientDetailsData.anthropometry[0].tST;
      TSTControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].TST_inch;

      EstimatedWeightController.text =
          widget.patientDetailsData.anthropometry[0].estimatedWeight;
      EstimatedWeightControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].estimatedWeightLBS;
      EstimatedHeightController.text =
          widget.patientDetailsData.anthropometry[0].estimatedHeight;
      EstimatedHeightControllerInches.text =
          widget.patientDetailsData.anthropometry[0].estimatedHeightInches;
      EDEMAController.text = widget.patientDetailsData.anthropometry[0].edema;
      EDEMAControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].edema_LBS;
      ASCITIESController.text =
          widget.patientDetailsData.anthropometry[0].ascities;
      ASCITIESControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].ascities_LBS;
      AMPUTATIONControllerLBS.text =
          widget.patientDetailsData.anthropometry[0].amputation_LBS;
      discountedWeightController.text =
          widget.patientDetailsData.anthropometry[0].discountedWeight;
      KneeHeightController.text =
          widget.patientDetailsData.anthropometry[0].kneeHeight;
      KneeHeightControllerInches.text =
          widget.patientDetailsData.anthropometry[0].kneeHeight_inch;
      ArmSpanController.text =
          widget.patientDetailsData.anthropometry[0].armSpan;
      ArmSpanControllerInches.text =
          widget.patientDetailsData.anthropometry[0].armSpan_inch;
      _amputationPer = widget.patientDetailsData.anthropometry[0].amputationPer;
      wantDiscountOnWeightFromAmputation = widget.patientDetailsData
          .anthropometry[0].wantDiscountOnWeightFromAmputation;
      MAMCPer = widget.patientDetailsData.anthropometry[0].mamcper ?? '';

      ChangeWeightStatus();
      ChangeHeightStatus();

      print(
          'amputation % :${widget.patientDetailsData.anthropometry[0].amputationPer}');
      print(
          'arm span % :${widget.patientDetailsData.anthropometry[0].armSpan}');

      print(
          'json data : ${jsonEncode(widget.patientDetailsData.anthropometry[0].amputationData)}');

      AmputationDataa.clear();
      AmputationDataa.addAll(
          widget.patientDetailsData.anthropometry[0].amputationData);

      EstimatedWeight();
      discountedweight();

      if (widget.patientDetailsData.anthropometry[0].heightType == '1') {
        if (widget.patientDetailsData.anthropometry[0].armSpan.isNotEmpty) {
          EstimatedHeightFromArm();
        } else if (widget
            .patientDetailsData.anthropometry[0].estimatedHeight.isNotEmpty) {
          EstimatedHeight();
        }
      }

      // if(widget.patientDetailsData.anthropometry[0].weightType == '0'){
      //   EstimatedWeightController.clear();
      //   EstimatedWeightControllerLBS.clear();
      // }
    });
    clearDataIfZero();
  }

  ChangeWeightStatus() {
    setState(() {
      if (_weightValue == '3') {
        WieghtMeasureEnbale = false;

        weightMeasureController.clear();

        weightMeasureControllerLBS.clear();
      } else {
        WieghtMeasureEnbale = true;
      }

      // if (_weightValue == ''){
      //     ACEnbale = true;
      //     MUACEnbale = true;
      //     CALFEnbale = true;
      //     TSTFEnbale = true;
      //     EstimatedWeightEnbale = true;
      //     WieghtMeasureEnbale = false;
      //
      //     weightMeasureController.clear();
      //     weightMeasureControllerLBS.clear();
      //   }else{
      //     print('yeesss');
      //
      //     ACEnbale = false;
      //     MUACEnbale = false;
      //     CALFEnbale = false;
      //     TSTFEnbale = false;
      //     EstimatedWeightEnbale = false;
      //     ACController.clear();
      //     MUACController.clear();
      //     CALFController.clear();
      //     TSTController.clear();
      //     EstimatedWeightController.clear();
      //     EstimatedWeightControllerLBS.clear();
      //
      //     WieghtMeasureEnbale = true;
      //
      //
      //   }
    });
  }

  ChangeHeightStatus() {
    setState(() {
      if (_heightValue == '3') {
        KneeHeightEnbale = true;
        ArmEnbale = true;
        EstimatedHeightEnbale = true;

        HieghtMeasureEnbale = false;
        heightMeasureController.clear();
        heightMeasureControllerInches.clear();
      } else {
        // KneeHeightEnbale = false;
        // ArmEnbale = false;

        // KneeHeightEnbale = false;
        // ArmEnbale = false;
        EstimatedHeightEnbale = false;

        HieghtMeasureEnbale = true;
        // KneeHeightController.clear();
        // ArmSpanController.clear();
        // EstimatedHeightController.clear();
        // EstimatedHeightControllerInches.clear();
      }
    });
  }

  // void changeW

  String _heightValue = '0';
  String _weightValue = '0';

  bool WieghtMeasureEnbale = true;

  bool ACEnbale = true;
  bool MUACEnbale = true;
  bool CALFEnbale = true;
  bool TSTFEnbale = true;
  bool EstimatedWeightEnbale = true;

  bool HieghtMeasureEnbale = true;
  bool KneeHeightEnbale = true;
  bool ArmEnbale = true;
  bool EstimatedHeightEnbale = false;

  double kg1toLBS = 2.20462;
  double meter1toInches = 39.3701;

  double inchesTocm = 2.54;
  double cmToinch = 0.393701;

  double LbsTokg = 0.453592;

  // double cmToMilimeter = 10.0;
  // double cmToMilimeter = 1.0;
  double mmToInches = 0.0393701;
  // double MiliMeterToCm = 0.1;
  // double MiliMeterToCm = 1.0;
  double InchesTomilimeter= 25.4;



  upadtefromAnother() {
    if (refUnit != '1') {
      setState(() {
        EDEMAControllerLBS.text = (double.parse(EDEMAController.text.isEmpty ? '0' : EDEMAController.text) * kg1toLBS).toStringAsFixed(2);
        ASCITIESControllerLBS.text = (double.parse(ASCITIESController.text.isEmpty ? '0' : ASCITIESController.text) * kg1toLBS).toStringAsFixed(2);
        AMPUTATIONControllerLBS.text = (double.parse(AMPUTATIONController.text.isEmpty ? '0' : AMPUTATIONController.text) * kg1toLBS).toStringAsFixed(2);
      });
    }
  }

  changeUnitData() async {
    if (cal) {
      if (refUnit == '1') {
        setState(() {
          ACControllerLBS.text = (double.parse(ACController.text.isEmpty ? '0' : ACController.text) * cmToinch).toStringAsFixed(2);
          MUACControllerLBS.text = (double.parse(MUACController.text.isEmpty ? '0' : MUACController.text) * cmToinch).toStringAsFixed(2);
          CALFControllerLBS.text = (double.parse(CALFController.text.isEmpty ? '0' : CALFController.text) * cmToinch).toStringAsFixed(2);

          // TSTControllerLBS.text = (double.parse(TSTController.text.isEmpty ? '0' : TSTController.text) * cmToinch).toStringAsFixed(2);
          TSTControllerLBS.text = (double.parse(TSTController.text.isEmpty ? '0' : TSTController.text) * mmToInches).toStringAsFixed(2);

          EDEMAControllerLBS.text = (double.parse(EDEMAController.text.isEmpty ? '0' : EDEMAController.text) * kg1toLBS).toStringAsFixed(2);
          ASCITIESControllerLBS.text = (double.parse(ASCITIESController.text.isEmpty ? '0' : ASCITIESController.text) * kg1toLBS).toStringAsFixed(2);
          AMPUTATIONControllerLBS.text = (double.parse(AMPUTATIONController.text.isEmpty ? '0' : AMPUTATIONController.text) * kg1toLBS).toStringAsFixed(2);

          heightMeasureControllerInches.text = (double.parse(heightMeasureController.text.isEmpty ? '0' : heightMeasureController.text) * cmToinch).toStringAsFixed(2);
          KneeHeightControllerInches.text = (double.parse(KneeHeightController.text.isEmpty ? '0' : KneeHeightController.text) * cmToinch).toStringAsFixed(2);
          ArmSpanControllerInches.text = (double.parse(ArmSpanController.text.isEmpty ? '0' : ArmSpanController.text) * cmToinch).toStringAsFixed(2);

          weightMeasureControllerLBS.text = (double.parse(weightMeasureController.text.isEmpty ? '0' : weightMeasureController.text) * kg1toLBS).toStringAsFixed(2);

          clearDataIfZero();
        });
      } else {
        setState(() {
          ACController.text = (double.parse(ACControllerLBS.text.isEmpty ? '0' : ACControllerLBS.text) * inchesTocm).toStringAsFixed(2);
          MUACController.text = (double.parse(MUACControllerLBS.text.isEmpty ? '0' : MUACControllerLBS.text) * inchesTocm).toStringAsFixed(2);
          CALFController.text = (double.parse(CALFControllerLBS.text.isEmpty ? '0' : CALFControllerLBS.text) * inchesTocm).toStringAsFixed(2);

          // TSTController.text = (double.parse(TSTControllerLBS.text.isEmpty ? '0' : TSTControllerLBS.text) * inchesTocm).toStringAsFixed(2);
          TSTController.text = (double.parse(TSTControllerLBS.text.isEmpty ? '0' : TSTControllerLBS.text) * InchesTomilimeter).toStringAsFixed(2);

          EDEMAController.text = (double.parse(EDEMAControllerLBS.text.isEmpty ? '0' : EDEMAControllerLBS.text) * LbsTokg).toStringAsFixed(2);
          ASCITIESController.text = (double.parse(ASCITIESControllerLBS.text.isEmpty ? '0' : ASCITIESControllerLBS.text) * LbsTokg).toStringAsFixed(2);
          AMPUTATIONController.text = (double.parse(AMPUTATIONControllerLBS.text.isEmpty ? '0' : AMPUTATIONControllerLBS.text) * LbsTokg).toStringAsFixed(2);

          heightMeasureController.text = (double.parse(heightMeasureControllerInches.text.isEmpty ? '0' : heightMeasureControllerInches.text) * inchesTocm).toStringAsFixed(2);
          KneeHeightController.text = (double.parse(KneeHeightControllerInches.text.isEmpty ? '0' : KneeHeightControllerInches.text) * inchesTocm).toStringAsFixed(2);
          ArmSpanController.text = (double.parse(ArmSpanControllerInches.text.isEmpty ? '0' : ArmSpanControllerInches.text) * inchesTocm).toStringAsFixed(2);

          weightMeasureController.text = (double.parse(weightMeasureControllerLBS.text.isEmpty ? '0' : weightMeasureControllerLBS.text) * LbsTokg).toStringAsFixed(2);


          clearDataIfZero();
        });
      }
    }
  }

  ifEmptyReturn0(String text) {
    if (text.isEmpty) {
      return '0';
    } else {
      return text;
    }
  }

  clearDataIfZero() {
    print('CALF: ${CALFController.text} , ${CALFController.text}');
    print('TST: ${TSTController.text} , ${TSTControllerLBS.text}');

    setState(() {
      if (double.parse(ifEmptyReturn0(weightMeasureController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(weightMeasureController.text)) == 0.00) {
        weightMeasureController.clear();
        weightMeasureController.clear();
      }

      if (double.parse(ifEmptyReturn0(ACController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(ACControllerLBS.text)) == 0.00) {
        ACController.clear();
        ACControllerLBS.clear();
      }
      if (double.parse(ifEmptyReturn0(MUACController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(MUACControllerLBS.text)) == 0.0) {
        MUACController.clear();
        MUACControllerLBS.clear();
      }
      if (double.parse(ifEmptyReturn0(CALFController.text)) == 0.00 &&
          double.parse(ifEmptyReturn0(CALFControllerLBS.text)) == 0.00) {
        CALFController.clear();
        CALFControllerLBS.clear();
      }
      if (double.parse(ifEmptyReturn0(TSTController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(TSTControllerLBS.text)) == 0.00) {
        TSTController.clear();
        TSTControllerLBS.clear();
      }

      if (double.parse(ifEmptyReturn0(EstimatedWeightController.text)) ==
          0.00 ||
          double.parse(ifEmptyReturn0(EstimatedWeightControllerLBS.text)) ==
              0.00) {
        EstimatedWeightController.clear();
        EstimatedWeightControllerLBS.clear();
      }

      if (double.parse(ifEmptyReturn0(EDEMAController.text)) == 0.0 ||
          double.parse(ifEmptyReturn0(EDEMAControllerLBS.text)) == 0.0) {
        EDEMAControllerLBS.clear();
        EDEMAController.clear();
      }
      if (double.parse(ifEmptyReturn0(ASCITIESController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(ASCITIESControllerLBS.text)) == 0.00) {
        ASCITIESControllerLBS.clear();
        ASCITIESController.clear();
      }
      if (double.parse(ifEmptyReturn0(AMPUTATIONController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(AMPUTATIONControllerLBS.text)) == 0.00) {
        AMPUTATIONControllerLBS.clear();
        AMPUTATIONController.clear();
      }

      if (double.parse(ifEmptyReturn0(discountedWeightController.text)) ==
          0.00 ||
          double.parse(ifEmptyReturn0(discountedWeightControllerLBS.text)) ==
              0.00) {
        discountedWeightController.clear();
        discountedWeightControllerLBS.clear();
      }

      if (double.parse(ifEmptyReturn0(heightMeasureController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(heightMeasureControllerInches.text)) ==
              0.00) {
        heightMeasureController.clear();
        heightMeasureControllerInches.clear();
      }

      if (double.parse(ifEmptyReturn0(KneeHeightController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(KneeHeightControllerInches.text)) ==
              0.00) {
        KneeHeightController.clear();
        KneeHeightControllerInches.clear();
      }

      if (double.parse(ifEmptyReturn0(ArmSpanController.text)) == 0.00 ||
          double.parse(ifEmptyReturn0(ArmSpanControllerInches.text)) == 0.00) {
        ArmSpanController.clear();
        ArmSpanControllerInches.clear();
      }

      if (double.parse(ifEmptyReturn0(EstimatedHeightController.text)) ==
          0.00 ||
          double.parse(ifEmptyReturn0(EstimatedHeightControllerInches.text)) ==
              0.00) {
        EstimatedHeightController.clear();
        EstimatedHeightControllerInches.clear();
      }
    });
  }

  void EstimatedWeight() async {
    print('calcutaing..');
    print('AC: ${ACController.text}');
    print('MUAC: ${MUACController.text}');
    print('CALF: ${CALFController.text}');
    print('GENDER: ${widget.patientDetailsData.gender}');

    await changeUnitData();

    if (ACController.text.isNotEmpty &&
        MUACController.text.isNotEmpty &&
        CALFController.text.isNotEmpty) {
      double GENDER = 0.0;
      if (widget.patientDetailsData.gender.toLowerCase() ==
          'Male'.toLowerCase()) {
        setState(() {
          GENDER = 1.0;
        });
      } else {
        setState(() {
          GENDER = 2.0;
        });
      }

      double AC =
      double.parse(ACController.text.isEmpty ? '0' : ACController.text);
      double MUAC =
      double.parse(MUACController.text.isEmpty ? '0' : MUACController.text);
      double CALF =
      double.parse(CALFController.text.isEmpty ? '0' : CALFController.text);

      print('AC: ${AC}');
      print('MUAC: ${MUAC}');
      print('CALF: ${CALF}');
      print('GENDER: ${GENDER}');
      print(
          'estimated => (0.5759 * $MUAC) + (0.5263 * $AC) + (1.2452 * $CALF) - (4.8689 * $GENDER) - (32.9241)');
      double total = (0.5759 * (MUAC)) +
          (0.5263 * (AC)) +
          (1.2452 * (CALF)) -
          (4.8689 * (GENDER)) -
          (32.9241);

      print('total estimated weight: $total');

      double totalLBS = total * kg1toLBS;

      setState(() {
        EstimatedWeightController.text = total.toStringAsFixed(2);
        EstimatedWeightControllerLBS.text = totalLBS.toStringAsFixed(2);

        print('Estimated weight kg  ${EstimatedWeightController.text}');
        print('Estimated weight LBS  ${EstimatedWeightControllerLBS.text}');
      });

      // (0.5759 * MUACController.text) + (0.5263 X AC) + (1.2452 X CALF C) - (4.8689 X GENDER) - 32.9241
      //
      // GENDER: MALE = 1 FEMALE = 2

    } else {
      setState(() {
        EstimatedWeightController.clear();
        EstimatedWeightControllerLBS.clear();
      });
    }

    discountedweight();
  }

  void discountedweight() async {
    changeUnitData();
    print('calcutaing..');

    // print('EDEMA: ${EDEMAController.text}');
    // print('ASCITIES: ${ASCITIESController.text}');
    // print('AMPUTATION: ${AMPUTATIONController.text}');

    double EDEMA =
    double.parse(EDEMAController.text.isEmpty ? '0' : EDEMAController.text);
    double ASCITIES = double.parse(
        ASCITIESController.text.isEmpty ? '0' : ASCITIESController.text);
    double AMPUTATION = double.parse(
        AMPUTATIONController.text.isEmpty ? '0' : AMPUTATIONController.text);

    print('EDEMA: ${EDEMA}');
    print('ASCITIES: ${ASCITIES}');
    print('AMPUTATION: ${AMPUTATION}');

    double total = EDEMA + ASCITIES + AMPUTATION;

    print('total weight: $total');

    if (weightMeasureController.text.isNotEmpty) {
      print('measure weight');
      // weightMeasureControllerLBS.text = (double.parse(weightMeasureController.text) * kg1toLBS).toStringAsFixed(2);
      // WEIGHT MEASURED - (WEIGHT MEASURED X LIMB AMPUTATION) - EDEMA/ASCITES
      // double total = EDEMA+AMPUTATION;
      //ASCITIES not

      double total = 0.0;

      if (wantDiscountOnWeightFromAmputation == false) {
        setState(() {
          total = EDEMA + ASCITIES;
        });
      } else {
        print('else condition here');
        setState(() {
          total = EDEMA + ASCITIES + AMPUTATION;
        });
      }

      double finalWeight = double.parse(weightMeasureController.text) - total;
      print('final weight : $finalWeight');

      double finalWeightLBS =
          (double.parse(weightMeasureController.text) - total) * kg1toLBS;

      setState(() {
        discountedWeightController.text = finalWeight.toStringAsFixed(2);

        discountedWeightControllerLBS.text = finalWeightLBS.toStringAsFixed(2);

        print('discounted weight kg :${discountedWeightController.text}');
        print('discounted weight LBS :${discountedWeightControllerLBS.text}');
      });
    } else {
      if (EstimatedWeightController.text.isNotEmpty && _weightValue == '3') {
        print('estimated weight');

        // double total = EDEMA + AMPUTATION + ASCITIES;
        double total = 0.0;

        if (wantDiscountOnWeightFromAmputation == false) {
          setState(() {
            total = EDEMA + ASCITIES;
          });
        } else {
          print('else condition here');
          setState(() {
            total = EDEMA + ASCITIES + AMPUTATION;
          });
        }

        double finalWeight =
            double.parse(EstimatedWeightController.text) - total;
        print('final weight : $finalWeight');

        double finalWeightLBS =
            double.parse(EstimatedWeightControllerLBS.text) - total * kg1toLBS;

        setState(() {
          discountedWeightController.text = finalWeight.toStringAsFixed(2);

          discountedWeightControllerLBS.text =
              finalWeightLBS.toStringAsFixed(2);

          print('discounted weight kg :${discountedWeightController.text}');
          print('discounted weight LBS :${discountedWeightControllerLBS.text}');
        });
      } else {
        print('estimated weight is empty here');
        setState(() {
          discountedWeightController.clear();

          discountedWeightControllerLBS.clear();

          print('discounted weight kg :${discountedWeightController.text}');
          print('discounted weight LBS :${discountedWeightControllerLBS.text}');
        });
      }
    }
    // setState(() {
    //   EstimatedWeightController.text = total.toStringAsFixed(2);
    // });
  }

  void EstimatedHeight() async {
    ArmSpanController.clear();
    ArmSpanControllerInches.clear();
    EstimatedHeightController.clear();
    EstimatedHeightControllerInches.clear();

    await changeUnitData();

    print('calcutaing..');
    print('Knee height: ${KneeHeightController.text}');
    print('Arm span: ${ArmSpanController.text}');
    print('Age: ${widget.patientDetailsData.dob}');

    getAgeYearsFromDate(widget.patientDetailsData.dob).then((age) {
      print('retuen age in year : $age');

      double KNEE = double.parse(KneeHeightController.text.isEmpty ? '0' : KneeHeightController.text);

      double AGE = double.parse('$age');

      print('KNEE: ${KNEE}');

      if (widget.patientDetailsData.gender.toLowerCase() ==
          'Male'.toLowerCase()) {
        print('male total height');
        // HEIGHT (MALES) = (64.19 - (0.04 X AGE) + (2.02 X KNEE HEIGHT)) / 100
        print('(64.19 - (0.04 * $AGE) + (2.02 * $KNEE)) / 100');

        double total = (64.19 - (0.04 * AGE) + (2.02 * (KNEE)));

        print('total height estimated : $total');

        double totalInch = ((64.19 - (0.04 * AGE) + (2.02 * (KNEE)))) * cmToinch;

        if (KNEE == 0) {
          total = 0.0;

          print('total height estimated : $total');

          totalInch = 0.0;

          setState(() {
            EstimatedHeightController.clear();

            EstimatedHeightControllerInches.clear();
          });
        }

        setState(() {
          EstimatedHeightController.text = total.toStringAsFixed(2);

          EstimatedHeightControllerInches.text = totalInch.toStringAsFixed(2);

          print('height meter : ${EstimatedHeightController.text}');
          print('height inches : ${EstimatedHeightControllerInches.text}');
        });
      } else {
        print('female total height');
        // HEIGHT (FEMALES) = (84.88 - (0.24 X AGE)+(1.83 X KNEE HEIGHT)) / 100



        double total = (84.88 - (0.24 * AGE) + (1.83 * (KNEE)));

        print('total height estimated : $total');

        double totalInch = ((84.88 - (0.24 * AGE) + (1.83 * (KNEE)))) * cmToinch;



        if (KNEE == 0) {
          total = 0.0;

          print('total height estimated : $total');

          totalInch = 0.0;

          setState(() {
            EstimatedHeightController.clear();

            EstimatedHeightControllerInches.clear();
          });
        }


        setState(() {
          EstimatedHeightController.text = total.toStringAsFixed(2);

          EstimatedHeightControllerInches.text = totalInch.toStringAsFixed(2);

          print('height meter : ${EstimatedHeightController.text}');
          print('height inches : ${EstimatedHeightControllerInches.text}');
        });
      }
    });
  }

  void EstimatedHeightFromArm() async {
    KneeHeightController.clear();
    KneeHeightControllerInches.clear();
    EstimatedHeightController.clear();
    EstimatedHeightControllerInches.clear();
    await changeUnitData();

    print('calcutaing..');
    print('Knee height: ${KneeHeightController.text}');
    print('Arm span: ${ArmSpanController.text}');
    print('Age: ${widget.patientDetailsData.dob}');

    // double KNEE = double.parse(K.text.isEmpty ? '0' : ACController.text);
    double ARM = double.parse(ArmSpanController.text.isEmpty ? '0' : ArmSpanController.text);

    // print('KNEE: ${KNEE}');
    print('ARM: ${ARM}');

    // HEIGHT = 1/2 ENV X 2 / 100
    double total = ((ARM) * 2) ;

    print('total height estimated : $total');

    double totalInch = ((ARM * 2)) * cmToinch;

    setState(() {
      EstimatedHeightController.text = total.toStringAsFixed(2);

      EstimatedHeightControllerInches.text = totalInch.toStringAsFixed(2);

      print('height meter : ${EstimatedHeightController.text}');
      print('height inches : ${EstimatedHeightControllerInches.text}');
    });
  }

  String _amputationPer = '';

  List<AmputationData> AmputationDataa = [];

  Future<bool> _willpopScope() {
    UnfocusAll();
    Get.back();
  }

  String refUnit = '';
  String weightIn = '';
  String heightIn = '';

  refUnitStatus() async {
    String refU = await MySharedPreferences.instance.getStringValue(Session.refUnit);
    setState(() {
      refUnit = refU.isEmpty ? '1' : refU;

      weightIn = refUnit == '1' ? 'kg' : 'lbs';

      heightIn = refUnit == '1' ? 'cm ' : 'inch';
    });
    print('reference unit: ${refUnit}');

    // if(refUnit =='0'){
    //
    //   EstimatedWeightControllerLBS.clear();
    //   discountedWeightControllerLBS.clear();
    //   EstimatedHeightControllerInches.clear();
    //
    // }
    clearDataIfZero();
  }

  getAmputation() {
    double a = double.parse(ASCITIESController.text.isNullOrBlank
        ? '0'
        : ASCITIESController.text) +
        double.parse(
            EDEMAController.text.isNullOrBlank ? '0' : EDEMAController.text);

    print('ASCITIES + ADEMA : $a');

    if (EstimatedWeightController.text.isNotEmpty && _weightValue == '3') {
      print('Estimated weight');
      AMPUTATIONController.text = _amputationPer.isEmpty ? '0' : _amputationPer;

      double getper = ((double.parse(EstimatedWeightController.text) - a) *
          double.parse(_amputationPer)) /
          100;

      print('per : $getper');

      AMPUTATIONController.text = getper.toStringAsFixed(2);
      discountedweight();
    } else {
      print('measured weight');
      print(weightMeasureController.text);

      double getper = ((double.parse(weightMeasureController.text) - a) *
          double.parse(_amputationPer)) /
          100;

      print('per : $getper');

      AMPUTATIONController.text = getper.toStringAsFixed(2);
      discountedweight();
    }
  }

  bool wantDiscountOnWeightFromAmputation = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: BaseAppbar(
              'anthropometry'.tr,
              // null
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    Get.to(ReferenceScreen(
                      Ref_list: ref_controller.Anthropomatry_Ref_list,
                    ));

                    // select_unit();
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
                                              DropdownMenuItem(
                                                child: Text('estimated'.tr),
                                                value: '3',
                                              ),
                                              DropdownMenuItem(
                                                  child: Text('reported'.tr),
                                                  value: '1'),

                                              DropdownMenuItem(
                                                child: Text('guessed'.tr),
                                                value: '2',
                                              ),
                                              //  DropdownMenuItem(child: Text('item4'),value: '3'),
                                            ],
                                            onChanged: (value) {
                                              setState(() {
                                                _weightValue = value;
                                                print(_weightValue);

                                                if (_weightValue == '3') {
                                                  WieghtMeasureEnbale = false;

                                                  weightMeasureController
                                                      .clear();

                                                  weightMeasureControllerLBS
                                                      .clear();

                                                  discountedweight();
                                                } else {
                                                  WieghtMeasureEnbale = true;
                                                }

                                                // if (_weightValue == '3') {
                                                //   ACEnbale = true;
                                                //   MUACEnbale = true;
                                                //   CALFEnbale = true;
                                                //   TSTFEnbale = true;
                                                //   EstimatedWeightEnbale = true;
                                                //   WieghtMeasureEnbale = false;
                                                //
                                                //   weightMeasureController.clear();
                                                //
                                                //   weightMeasureControllerLBS.clear();
                                                // }else {
                                                //   ACEnbale = false;
                                                //   MUACEnbale = false;
                                                //   CALFEnbale = false;
                                                //   TSTFEnbale = false;
                                                //   EstimatedWeightEnbale = false;
                                                //   ACController.clear();
                                                //   MUACController.clear();
                                                //   CALFController.clear();
                                                //   TSTController.clear();
                                                //   EstimatedWeightController.clear();
                                                //   EstimatedWeightControllerLBS.clear();
                                                //
                                                //   WieghtMeasureEnbale = true;
                                                //
                                                // }
                                              });

                                              UnfocusAll();
                                            }),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _widgetwith(
                                          "$weightIn",
                                          refUnit == '1'
                                              ? weightMeasureController
                                              : weightMeasureControllerLBS, () {
                                        changeUnitData();
                                        discountedweight();
                                      }, WieghtMeasureEnbale, _focus1),
                                    ],
                                  ),

                                  Divider(
                                    height: 2.5,
                                    color: Colors.black,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'ac'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14.0,
                                                      color: appbar_icon_color),
                                                ),

                                            Text(
                                              'ca_full_form'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 10.0,
                                                      color: appbar_icon_color),
                                                ),
                                              ],
                                            ),


                                            _widgetwith(
                                                "$heightIn",
                                                refUnit == '1'
                                                    ? ACController
                                                    : ACControllerLBS,
                                                EstimatedWeight,
                                                ACEnbale,
                                                _focus2),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'muac'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14.0,
                                                      color: appbar_icon_color),
                                                ),

                                           Text(
                                                   'cb_full_form'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 10.0,
                                                      color: appbar_icon_color),
                                                ),
                                              ],
                                            ),


                                            _widgetwith(
                                                '$heightIn',
                                                refUnit == '1'
                                                    ? MUACController
                                                    : MUACControllerLBS,
                                                EstimatedWeight,
                                                MUACEnbale,
                                                _focus3),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'calf_c'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14.0,
                                                      color: appbar_icon_color),
                                                ),


                                                Text(
                                                    'cp_full_form'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 10.0,
                                                      color: appbar_icon_color),
                                                ),
                                              ],
                                            ),

                                            _widgetwith(
                                                '$heightIn',
                                                refUnit == '1'
                                                    ? CALFController
                                                    : CALFControllerLBS,
                                                EstimatedWeight,
                                                CALFEnbale,
                                                _focus4),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  't_s_t'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 14.0,
                                                      color: appbar_icon_color),
                                                ),

                                           Text(
                                                 'pct_full_form'.tr,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: 10.0,
                                                      color: appbar_icon_color),
                                                ),
                                              ],
                                            ),

                                            _widgetwith(
                                                // '$heightIn',
                                                refUnit == '0'
                                                    ? '$heightIn'
                                                    : 'mm',
                                                refUnit == '1'
                                                    ? TSTController
                                                    : TSTControllerLBS, () {
                                              changeUnitData();
                                            }, TSTFEnbale, _focus5),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'weight_estimated'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color: appbar_icon_color),
                                            ),
                                            _widgetwith(
                                                refUnit == '1'
                                                    ? "$weightIn   "
                                                    : "$weightIn  ",
                                                refUnit == '1'
                                                    ? EstimatedWeightController
                                                    : EstimatedWeightControllerLBS,
                                                    () {
                                                  changeUnitData();
                                                }, false, _focus6),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),

                                  Container(
                                    width: Get.width,
                                    child: Center(
                                      child: Text(
                                        'discounts'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18.0,
                                            color: appbar_icon_color),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Divider(
                                    height: 2.5,
                                    color: Colors.black,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            _button('edema'.tr, () {
                                              UnfocusAll();

                                              Get.to(EDEMAScreen(
                                                list: _controller.edema,
                                                title: 'edema'.tr,
                                                selected: EDEMAController.text,
                                              )).then((value) {
                                                print('return value : $value');
                                                setState(() {
                                                  EDEMAController.text = value;

                                                  upadtefromAnother();

                                                  discountedweight();
                                                  getAmputation();
                                                });
                                              });
                                            }),
                                            _widgetwith(
                                                '$weightIn ',
                                                refUnit == '1'
                                                    ? EDEMAController
                                                    : EDEMAControllerLBS,
                                                discountedweight,
                                                true,
                                                _focus7),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            _button('ascites'.tr, () {
                                              UnfocusAll();
                                              Get.to(EDEMAScreen(
                                                list: _controller.ascites,
                                                selected:
                                                ASCITIESController.text,
                                                title: 'ascites'.tr,
                                              )).then((value) {
                                                print('return value : $value');
                                                setState(() {
                                                  ASCITIESController.text =
                                                      value;
                                                  upadtefromAnother();
                                                  discountedweight();
                                                  getAmputation();
                                                });
                                              });
                                            }),
                                            _widgetwith(
                                                '$weightIn ',
                                                refUnit == '1'
                                                    ? ASCITIESController
                                                    : ASCITIESControllerLBS,
                                                discountedweight,
                                                true,
                                                _focus8),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            _button('amputation'.tr, () {
                                              UnfocusAll();
                                              Get.to(HumanBody(
                                                list: AmputationDataa,
                                                wantDiscount:
                                                wantDiscountOnWeightFromAmputation,
                                              )).then((value) {
                                                print('return data from human: ${jsonEncode(value)}');
                                                print('data: ${value['Data']}');
                                                print(
                                                    'count: ${value['count']}');
                                                print(
                                                    'wantDiscount: ${value['wantDiscount']}');

                                                setState(() {
                                                  _amputationPer =
                                                  value['count'];
                                                  wantDiscountOnWeightFromAmputation =
                                                  value['wantDiscount'];
                                                  AmputationDataa.clear();
                                                  AmputationDataa.addAll(
                                                      value['Data']);

                                                  print(
                                                      EstimatedWeightController
                                                          .text);
                                                  print(weightMeasureController
                                                      .text);
                                                  AMPUTATIONController.text =
                                                  _amputationPer.isEmpty
                                                      ? '0'
                                                      : _amputationPer;
                                                });

                                                if (double.parse(
                                                    _amputationPer) >
                                                    0) {
                                                  upadtefromAnother();
                                                  getAmputation();
                                                } else {
                                                  setState(() {
                                                    _amputationPer = '';
                                                    AmputationDataa.clear();
                                                    AMPUTATIONController
                                                        .clear();
                                                    AMPUTATIONControllerLBS
                                                        .clear();
                                                    wantDiscountOnWeightFromAmputation =
                                                    false;
                                                  });
                                                  discountedweight();
                                                }
                                                // getAmputation();
                                              });
                                            }),
                                            _widgetwith(
                                                '$weightIn ',
                                                refUnit == '1'
                                                    ? AMPUTATIONController
                                                    : AMPUTATIONControllerLBS,
                                                discountedweight,
                                                true,
                                                _focus9),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'weight_after_discount'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color: appbar_icon_color),
                                            ),
                                            _widgetwith(
                                                '$weightIn ',
                                                refUnit == '1'
                                                    ? discountedWeightController
                                                    : discountedWeightControllerLBS,
                                                    () {
                                                  changeUnitData();
                                                }, false, _focus10),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  // Divider(
                                  //   height: 2.5,
                                  //   color: Colors.black,
                                  // ),
                                  SizedBox(
                                    height: 10.0,
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
                                              DropdownMenuItem(
                                                  child: Text('estimated'.tr),
                                                  value: '3'),
                                              DropdownMenuItem(
                                                  child: Text('reported'.tr),
                                                  value: '1'),

                                              DropdownMenuItem(
                                                  child: Text('guessed'.tr),
                                                  value: '2'),

                                              //  DropdownMenuItem(child: Text('item4'),value: '3'),
                                            ],
                                            onChanged: (value) {
                                              UnfocusAll();
                                              setState(() {
                                                _heightValue = value;
                                                print(_heightValue);

                                                if (value == '3') {
                                                  KneeHeightEnbale = true;
                                                  ArmEnbale = true;
                                                  EstimatedHeightEnbale = true;

                                                  HieghtMeasureEnbale = false;
                                                  heightMeasureController
                                                      .clear();
                                                  heightMeasureControllerInches
                                                      .clear();
                                                } else {
                                                  // KneeHeightEnbale = false;
                                                  // ArmEnbale = false;
                                                  EstimatedHeightEnbale = false;

                                                  HieghtMeasureEnbale = true;
                                                  // KneeHeightController.clear();
                                                  // ArmSpanController.clear();
                                                  // EstimatedHeightController.clear();
                                                  // EstimatedHeightControllerInches.clear();
                                                }
                                              });
                                            }),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      _widgetwith(
                                          '$heightIn',
                                          refUnit == '1'
                                              ? heightMeasureController
                                              : heightMeasureControllerInches,
                                          changeUnitData,
                                          HieghtMeasureEnbale,
                                          _focus11),
                                    ],
                                  ),

                                  Divider(
                                    height: 2.5,
                                    color: Colors.black,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0, top: 20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'knee_height'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color: appbar_icon_color),
                                            ),
                                            _widgetwith(
                                                '$heightIn  ',
                                                refUnit == '1'
                                                    ? KneeHeightController
                                                    : KneeHeightControllerInches,
                                                EstimatedHeight,
                                                KneeHeightEnbale,
                                                _focus12),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'arm_span'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color: appbar_icon_color),
                                            ),
                                            _widgetwith(
                                                '$heightIn  ',
                                                refUnit == '1'
                                                    ? ArmSpanController
                                                    : ArmSpanControllerInches,
                                                EstimatedHeightFromArm,
                                                ArmEnbale,
                                                _focus13),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'height_estimated'.tr,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 14.0,
                                                  color: appbar_icon_color),
                                            ),
                                            _widgetwith(
                                                refUnit == '1'
                                                    ? '$heightIn  '
                                                    : '$heightIn  ',
                                                refUnit == '1'
                                                    ? EstimatedHeightController
                                                    : EstimatedHeightControllerInches,
                                                    () {
                                                  changeUnitData();
                                                }, false, _focus14),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
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
                          if (_weightValue == '3') {
                            if (EstimatedWeightController.text.isNotEmpty &&
                                EstimatedWeightControllerLBS.text.isNotEmpty) {
                              onTappp();
                            } else {
                              print('condion 1');
                              ShowMsg('weight_mandatory'.tr);
                            }
                          } else {
                            if (weightMeasureController.text.isNotEmpty &&
                                weightMeasureControllerLBS.text.isNotEmpty) {
                              onTappp();
                            } else {
                              print('condion 2');
                              ShowMsg('height_mandatory'.tr);
                            }
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: _willpopScope);
  }

  onTappp() {
    print(
        'discountedWeightController: ${discountedWeightController.text.isNotEmpty}');

    if (discountedWeightController.text.isNotEmpty) {
      print(_heightValue);

      if (_heightValue == '3') {
        if (EstimatedHeightController.text.isNotEmpty &&
            EstimatedHeightControllerInches.text.isNotEmpty) {
          if (AMPUTATIONController.text.isNotEmpty) {
            if (_amputationPer.isEmpty) {
              double a = double.parse(ASCITIESController.text.isNullOrBlank
                  ? '0'
                  : ASCITIESController.text) +
                  double.parse(EDEMAController.text.isNullOrBlank
                      ? '0'
                      : EDEMAController.text);

              print('ASCITIES + ADEMA : $a');

              double weightt = double.parse(_weightValue == '3'
                  ? EstimatedWeightController.text
                  : weightMeasureController.text) +
                  a;
              setState(() {
                _amputationPer =
                    (double.parse(AMPUTATIONController.text) / weightt)
                        .toStringAsFixed(2);
                print('_amputationPer: $_amputationPer');
              });

              getBMI();
            } else {
              getBMI();
            }
          } else {
            getBMI();
          }
        } else {
          ShowMsg('height_mandatory'.tr);
        }
      } else {
        if (heightMeasureController.text.isNotEmpty) {
          if (AMPUTATIONController.text.isNotEmpty) {
            if (_amputationPer.isEmpty) {
              double a = double.parse(ASCITIESController.text.isNullOrBlank
                  ? '0'
                  : ASCITIESController.text) +
                  double.parse(EDEMAController.text.isNullOrBlank
                      ? '0'
                      : EDEMAController.text);

              print('ASCITIES + ADEMA : $a');

              double weightt = double.parse(_weightValue == '3'
                  ? EstimatedWeightController.text
                  : weightMeasureController.text) +
                  a;
              setState(() {
                _amputationPer =
                    (double.parse(AMPUTATIONController.text) / weightt)
                        .toStringAsFixed(2);
                print('_amputationPer: $_amputationPer');
              });

              getBMI();
            } else {
              getBMI();
            }
          } else {
            getBMI();
          }
        } else {
          ShowMsg('height_mandatory'.tr);
        }
      }
    } else {
      ShowMsg('weight_mandatory'.tr);
    }
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

  var ACControllerLBS = TextEditingController();
  var MUACControllerLBS = TextEditingController();
  var CALFControllerLBS = TextEditingController();
  var TSTControllerLBS = TextEditingController();

  var EstimatedWeightController = TextEditingController();
  var EstimatedWeightControllerLBS = TextEditingController();

  var EDEMAController = TextEditingController();
  var ASCITIESController = TextEditingController();
  var AMPUTATIONController = TextEditingController();

  var EDEMAControllerLBS = TextEditingController();
  var ASCITIESControllerLBS = TextEditingController();
  var AMPUTATIONControllerLBS = TextEditingController();

  var discountedWeightController = TextEditingController();
  var discountedWeightControllerLBS = TextEditingController();

  var heightMeasureController = TextEditingController();
  var KneeHeightController = TextEditingController();
  var ArmSpanController = TextEditingController();

  var heightMeasureControllerInches = TextEditingController();
  var KneeHeightControllerInches = TextEditingController();
  var ArmSpanControllerInches = TextEditingController();

  var EstimatedHeightController = TextEditingController();

  var EstimatedHeightControllerInches = TextEditingController();

  FocusNode _focus1 = new FocusNode();
  FocusNode _focus2 = new FocusNode();
  FocusNode _focus3 = new FocusNode();
  FocusNode _focus4 = new FocusNode();
  FocusNode _focus5 = new FocusNode();
  FocusNode _focus6 = new FocusNode();
  FocusNode _focus7 = new FocusNode();
  FocusNode _focus8 = new FocusNode();
  FocusNode _focus9 = new FocusNode();
  FocusNode _focus10 = new FocusNode();
  FocusNode _focus11 = new FocusNode();
  FocusNode _focus12 = new FocusNode();
  FocusNode _focus13 = new FocusNode();
  FocusNode _focus14 = new FocusNode();

  Widget texfld(String hint, String suffix, TextEditingController controller,
      Function _fun, bool enable, FocusNode focus) {
    return TextField(
      controller: controller,
      enabled: enable,
      focusNode: focus,
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

  String BMIValue;
  getBMI() {
    if (AMPUTATIONController.text.isEmpty) {
      print('PATIENTS WITH NO LIMB AMPUTATIONS');
      print('WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)');
      // BMI = WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)

      double discountedWeight = double.parse(discountedWeightController.text);
      double height = double.parse(heightMeasureController.text.isEmpty
          ? EstimatedHeightController.text
          : "${double.parse(heightMeasureController.text)}")/100;

      print('$discountedWeight / ($height * $height)');
      double total = discountedWeight / (height * height);

      print('BMI : ${total.toStringAsFixed(2) + " kg/m2"}');

      setState(() {
        BMIValue = total.toStringAsFixed(2);
      });
    } else {
      print('PATIENTS WITH AMPUTATIONS AND WEIGHT MEASURED');
      print(
          '[(WEIGHT MEASURED X 100) / (100 - DISCOUNTS OF LIMB AMPUTATION)] /(HEIGHT X HEIGHT)');
      // BMI = [(WEIGHT MEASURED X 100) / (100 - DISCOUNTS OF LIMB AMPUTATION)] /(HEIGHT X HEIGHT)
      // EXAMPLE: WEIGHT MEASURED = 80 kg; HEIGHT = 1.8 m; LIMB AMPUTATION = 16%
      //
      //     BMI = [(80 X 100) / (100 - 16)] / (1.8 X 1.8)
      // BMI = 29.4 kg/m2

      double WEIGHTMEASURED = double.parse(discountedWeightController.text);
      double amputaionPer = double.parse(_amputationPer);
      double height = double.parse(heightMeasureController.text.isEmpty
          ? EstimatedHeightController.text
          : "${double.parse(heightMeasureController.text)}")/100;

      print('[($WEIGHTMEASURED X 100) / (100 - $_amputationPer)] /($height X $height)');
      double total = ((WEIGHTMEASURED * 100) / (100 - amputaionPer)) / (height * height);

      print('BMI : ${total.toStringAsFixed(2) + " kg/m2"}');
      setState(() {
        BMIValue = total.toStringAsFixed(2);
      });
    }

    // else if (AMPUTATIONController.text.isNotEmpty && weightMeasureController.text.isNotEmpty) {
    //   print('PATIENTS WITH AMPUTATIONS AND WEIGHT MEASURED');
    //   print(
    //       '[(WEIGHT MEASURED X 100) / (100 - DISCOUNTS OF LIMB AMPUTATION)] /(HEIGHT X HEIGHT)');
    //   // BMI = [(WEIGHT MEASURED X 100) / (100 - DISCOUNTS OF LIMB AMPUTATION)] /(HEIGHT X HEIGHT)
    //   // EXAMPLE: WEIGHT MEASURED = 80 kg; HEIGHT = 1.8 m; LIMB AMPUTATION = 16%
    //   //
    //   //     BMI = [(80 X 100) / (100 - 16)] / (1.8 X 1.8)
    //   // BMI = 29.4 kg/m2
    //
    //   double WEIGHTMEASURED = double.parse(weightMeasureController.text);
    //   double amputaionPer = double.parse(_amputationPer);
    //   double height = double.parse(heightMeasureController.text.isEmpty
    //       ? EstimatedHeightController.text
    //       : "${double.parse(heightMeasureController.text) / 100}");
    //
    //   print(
    //       '[($WEIGHTMEASURED X 100) / (100 - $_amputationPer)] /($height X $height)');
    //   double total =
    //       ((WEIGHTMEASURED * 100) / (100 - amputaionPer)) / (height * height);
    //
    //   print('BMI : ${total.toStringAsFixed(2) + " kg/m2"}');
    //   setState(() {
    //     BMIValue = total.toStringAsFixed(2);
    //   });
    // } else if (AMPUTATIONController.text.isNotEmpty && EstimatedWeightController.text.isNotEmpty) {
    //   print('PATIENTS WITH AMPUTATIONS AND ONLY WEIGHT ESTIMATED');
    //   print('WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)');
    //   // BMI = WEIGHT AFTER DISCOUNTS / (HEIGHT X HEIGHT)
    //
    //   double discountedWeight = double.parse(discountedWeightController.text);
    //   double height = double.parse(heightMeasureController.text.isEmpty
    //       ? EstimatedHeightController.text
    //       : "${double.parse(heightMeasureController.text) / 100}");
    //
    //   print('$discountedWeight / ($height * $height)');
    //   double total = discountedWeight / (height * height);
    //
    //   print('BMI : ${total.toStringAsFixed(2) + " kg/m2"}');
    //
    //   setState(() {
    //     BMIValue = total.toStringAsFixed(2);
    //   });
    // }

    getIdealBodyWeight();
  }

  String idealBodyWeight = '';
  String idealBodyWeightLBS = '';
  getIdealBodyWeight() {
    // IDEAL BODY WEIGHT (kg) = HEIGHT X HEIGHT X 25 (CONVERT TO lbs if necessary)
    //
    // info: IBW BASED ON BMI = 25KG/M2. (Singer P et al. Clin Nutr. 2019 Feb;38(1):48-79. doi: 10.1016/j.clnu.2018.08.037)

    print('IDEAL BODY WEIGHT = HEIGHT X HEIGHT X 25');
    double height = double.parse(heightMeasureController.text.isEmpty
        ? EstimatedHeightController.text
        : "${double.parse(heightMeasureController.text)}")/100;
    print('$height * $height * 25');
    double total = height * height * 25;

    print('IDEAL BODY WEIGHT : ${total.toStringAsFixed(2)}');
    setState(() {
      idealBodyWeight = total.toStringAsFixed(2);
      idealBodyWeightLBS = (total * kg1toLBS).toStringAsFixed(2);
    });
    getAdjustedBodyWeight();
  }

  String adjustedBodyWeight = '';
  String adjustedBodyWeightLBS = '';
  getAdjustedBodyWeight() {
    // ADJUSTED BODY WEIGHT (kg) (ATTENTION: ONLY IF BMI > 30) = 0.33 X (WEIGHT AFTER DISCOUNTS - IDEAL BODY WEIGHT) + IDEAL BODY WEIGHT (convert to lbs inf necessary)
    print('ADJUSTED BODY WEIGHT');
    double BMI = double.parse(BMIValue);
    if (BMI > 30.0) {
      print('BMI > 30');
      print(
          'ADJUSTED BODY WEIGHT =  0.33 X (WEIGHT AFTER DISCOUNTS - IDEAL BODY WEIGHT) + IDEAL BODY WEIGHT ');
      double idealWeight = double.parse(idealBodyWeight);
      double discountedWeight = double.parse(discountedWeightController.text);
      double total = 0.33 * (discountedWeight - idealWeight) + idealWeight;
      print('ADJUSTED BODY WEIGHT  : ${total.toStringAsFixed(2)}');

      setState(() {
        adjustedBodyWeight = total.toStringAsFixed(2);
        adjustedBodyWeightLBS = (total * kg1toLBS).toStringAsFixed(2);
      });
    }
    getMAMC();
  }

  String MAMCValue = '';
  String MAMCPer = '';
  void getMAMC() async {
    // MAMC (PORTUGUESE = CMB) = MUAC - (0.314 x TST) (MAMC = mid-arm muscle circumference) (MUAC = mid-upper-arm circumference)
    print('(MAMC = MUAC - (0.314 x TST))');
    if (TSTController.text.isNotEmpty && MUACController.text.isNotEmpty) {
      double MUAC = double.parse(MUACController.text);
      double TST = double.parse(TSTController.text);

      print('$MUAC - (0.314 * $TST)');
      double total = MUAC - (0.314 * TST);

      print('MAMC : ${total.toStringAsFixed(2)}');
      setState(() {
        MAMCValue = total.toStringAsFixed(2);
        getExactAge(widget.patientDetailsData.dob).then((value) {
          print('age return in double: $value');
          if (widget.patientDetailsData.gender.toLowerCase() == 'male') {
            getPercentileMale(value).then((per) {
              print('return percentile: ${per}');

              // getMAMCPer(MAMCValue, per);
              getMAMCPer(total, per).then((mamcper) {
                print('return MAMC % : $mamcper');

                MAMCPer = mamcper;
              });
            });
          } else {
            getPercentileFemale(value).then((per) {
              print('return percentile: ${per}');

              getMAMCPer(total, per).then((mamcper) {
                print('return MAMC % : $mamcper');
                MAMCPer = mamcper;
              });
            });
          }
        });
      });
    } else {
      print('TST & MUAC is empty');
      // getExactAge(widget.patientDetailsData.dob);
    }

    // showLoader();
    Future.delayed(new Duration(milliseconds: 100), () {
      onSaved();
    });
  }

  final HistoryController _historyController = HistoryController();

  ifZeroReturnBlank(String text) {
    if (text == '0.00') {
      return '';
    } else {
      return text;
    }
  }

  void onSaved() {
    UnfocusAll();

    // double measureWeightLBS = double.parse(weightMeasureController.text.isEmpty?'0':weightMeasureController.text) * kg1toLBS;
    // double measureHeight = double.parse(heightMeasureController.text.isEmpty?'0':heightMeasureController.text) /meter1toInches;

    // double measureWeightLBS;
    // double measureWeight;
    //
    // if (refUnit == '1') {
    //   setState(() {
    //     measureWeightLBS = double.parse(weightMeasureController.text.isEmpty
    //             ? '0'
    //             : weightMeasureController.text) *
    //         kg1toLBS;
    //     measureWeight = double.parse(weightMeasureController.text.isEmpty
    //         ? '0'
    //         : weightMeasureController.text);
    //   });
    // } else {
    //   measureWeightLBS = double.parse(weightMeasureControllerLBS.text.isEmpty
    //       ? '0'
    //       : weightMeasureControllerLBS.text);
    //   measureWeight = double.parse(weightMeasureControllerLBS.text.isEmpty
    //           ? '0'
    //           : weightMeasureControllerLBS.text) /
    //       kg1toLBS;
    // }

    // if (discountedWeightController.text.isNotEmpty &&
    //     AMPUTATIONController.text.isNotEmpty) {
    //   if (heightMeasureController.text.isNotEmpty ||
    //       EstimatedHeightController.text.isNotEmpty) {
    Map data = {
      // 'weightType': weightMeasureController.text.isEmpty?'1':'0',
      'weightType': _weightValue,
      'weightMeasuredReported': ifZeroReturnBlank(weightMeasureController.text),
      'weightMeasuredReportedLBS':
      ifZeroReturnBlank(weightMeasureControllerLBS.text),

      'ac': ifZeroReturnBlank(ACController.text),
      'ac_inch': ifZeroReturnBlank(ACControllerLBS.text),
      'MUAC': ifZeroReturnBlank(MUACController.text),
      'MUAC_inch': ifZeroReturnBlank(MUACControllerLBS.text),
      'CALF': ifZeroReturnBlank(CALFController.text),
      'CALF_inch': ifZeroReturnBlank(CALFControllerLBS.text),
      'TST': ifZeroReturnBlank(TSTController.text),
      'TST_inch': ifZeroReturnBlank(TSTControllerLBS.text),
      'mamc': MAMCValue,
      'mamcper': MAMCPer,

      'estimatedWeight': ifZeroReturnBlank(EstimatedWeightController.text),
      'estimatedWeightLBS':
      ifZeroReturnBlank(EstimatedWeightControllerLBS.text),

      'edema': ifZeroReturnBlank(EDEMAController.text),
      'edema_LBS': ifZeroReturnBlank(EDEMAControllerLBS.text),
      'edemaData': [],
      'ascities': ifZeroReturnBlank(ASCITIESController.text),
      'ascities_LBS': ifZeroReturnBlank(ASCITIESControllerLBS.text),
      'ascitiesData': [],
      'amputation': ifZeroReturnBlank(AMPUTATIONController.text),
      'amputation_LBS': ifZeroReturnBlank(AMPUTATIONControllerLBS.text),
      'wantDiscountOnWeightFromAmputation': wantDiscountOnWeightFromAmputation,
      'amputationPer': ifZeroReturnBlank(_amputationPer),
      'amputationData': AmputationDataa,
      'discountedWeight': ifZeroReturnBlank(discountedWeightController.text),
      'discountedWeightLBS':
      ifZeroReturnBlank(discountedWeightControllerLBS.text),

      // 'heightType':  heightMeasureController.text.isEmpty?'1':'0',
      'heightType': _heightValue,
      'heightMeasuredReported': ifZeroReturnBlank(heightMeasureController.text),
      'heightMeasuredReported_inch':
      ifZeroReturnBlank(heightMeasureControllerInches.text),
      'heightMeasuredReportedMeter': double.parse(
          heightMeasureController.text.isEmpty
              ? '0'
              : heightMeasureController.text) /
          100,
      // 'heightMeasuredReportedInches': heightMeasureController.text,
      'kneeHeight': ifZeroReturnBlank(KneeHeightController.text),
      'kneeHeight_inch': ifZeroReturnBlank(KneeHeightControllerInches.text),
      'armSpan': ifZeroReturnBlank(ArmSpanController.text),
      'armSpan_inch': ifZeroReturnBlank(ArmSpanControllerInches.text),
      'estimatedHeight': ifZeroReturnBlank(EstimatedHeightController.text),
      'estimatedHeightInches':
      ifZeroReturnBlank(EstimatedHeightControllerInches.text),

      'bmi': BMIValue,

      'idealBodyWeight': ifZeroReturnBlank(idealBodyWeight),
      'idealBodyWeightLBS': ifZeroReturnBlank(idealBodyWeightLBS),
      'adjustedBodyWeight': ifZeroReturnBlank(adjustedBodyWeight),
      'adjustedBodyWeightLBS': ifZeroReturnBlank(adjustedBodyWeightLBS),
      'lastUpdate': '${DateTime.now()}',
    };

    print('data: ${data}');
    print('data: ${jsonEncode(data)}');

    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
      print('internet: $internet');

      if (internet != null && internet) {
        _controller.saveData(widget.patientDetailsData, [data]).then((value) {
          _historyController.saveMultipleMsgHistory(
              widget.patientDetailsData.sId,
              ConstConfig.anthroHistory,
              [data]).then((value) {
            if (widget.isFromAnthroTab) {
              Get.to(Step1HospitalizationScreen(
                patientUserId: widget.patientDetailsData.sId,
                index: 2,
              ));
            } else {
              Get.back(result: BMIValue);
            }
          });
        });
      }else {
        final OfflineHandler _offlineHandler = OfflineHandler();

        _offlineHandler.handleAnthroOffline(data, widget.patientDetailsData);
        ShowMsg('data_updated_successfully'.tr);
      }

    });
  }

  void UnfocusAll() {
    _focus1.unfocus();
    _focus2.unfocus();
    _focus3.unfocus();
    _focus4.unfocus();
    _focus5.unfocus();
    _focus6.unfocus();
    _focus7.unfocus();
    _focus8.unfocus();
    _focus9.unfocus();
    _focus10.unfocus();
    _focus11.unfocus();
    _focus12.unfocus();
    _focus13.unfocus();
    _focus14.unfocus();
  }

/**************************************************************/
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
                                  onTap: () {
                                    setState(() {
                                      ref_value = 'LBS & INCHES';
                                      _radioValue = 0;
                                      changeRefUnit(0);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child: Row(
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
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ref_value = 'KG & METERS';
                                      _radioValue = 1;
                                      changeRefUnit(1);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child: Row(
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
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text: "save".tr,
                                      myFunc: () {
                                        Get.back();
                                        changeRefUnit(_radioValue);
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

  void changeRefUnit(int refUnit) {
    print('----------$refUnit------------');
    if (refUnit == 0) {
      print('LBS & INCHES');
      MySharedPreferences.instance.setStringValue(Session.refUnit, '$refUnit');
    } else {
      print('KG & METERS');
      MySharedPreferences.instance.setStringValue(Session.refUnit, '$refUnit');
    }

    refUnitStatus();
  }
}
