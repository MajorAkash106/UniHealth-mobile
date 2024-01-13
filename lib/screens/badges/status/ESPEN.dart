import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/status_controller/espen_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/Anthropometry_screen.dart';
import 'package:medical_app/screens/badges/status/ESPEN_second.dart';
import 'package:medical_app/screens/badges/status/NRS_2002.dart';

class ESPENScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  ESPENScreen({this.patientDetailsData});
  @override
  _ESPENScreenState createState() => _ESPENScreenState();
}

class _ESPENScreenState extends State<ESPENScreen> {

  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();
  String BMIValue = '';

  final PatientSlipController _patientSlipController = PatientSlipController();

  @override
  void initState() {
    // TODO: implement initState
    // getData();
    // Future.delayed(const Duration(seconds: 1), () {
    //   onpress();
    //
    // });

  getDATA();
    super.initState();
  }

  getDATA(){
    // ISNRSORMUST(widget.patientDetailsData).then((value){
    //
    //   if(value){
        getData();
        Future.delayed(const Duration(seconds: 1), () {
          onpress();
        });
    //   }else{
    //     showAlertForEmptyData();
    //   }
    //
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('based_on_bmi'.tr,null),
      bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // child: ListView(
          //   children: [
          //     SizedBox(
          //       height: 30,
          //     ),
          //     Text(
          //       "NOTE : TO PERFORM THIS TEST BE SURE THAT ANTHROMOPOMETRY IS UP TO DATE",
          //       style: TextStyle(
          //           color: appbar_icon_color,
          //           fontSize: 16,
          //           fontWeight: FontWeight.normal),
          //     ),
          //     SizedBox(
          //       height: 70,
          //     ),
          //     _cardwidget("GO TO ANTHROMOPOMETRY", 'path', () {
          //       // Get.to(Anthropometery());
          //       print(widget.patientDetailsData);
          //       Get.to(Anthropometery(
          //         patientDetailsData:
          //             _patientSlipController.patientDetailsData[0],
          //         isFromAnthroTab: false,
          //       )).then((value) {
          //         print('return BMI : $value');
          //         setState(() {
          //           BMIValue = value ?? '';
          //         });
          //
          //         _patientSlipController.getDetails(
          //             widget.patientDetailsData.sId, 0);
          //       });
          //     }),
          //     SizedBox(
          //       height: 80,
          //     ),
          //     CustomButton(
          //       text: "Confirm",
          //       myFunc: () async {
          //         if (isNRSBLANK == 'yes' && isMUSTBLANK == 'yes') {
          //           showAlert();
          //         } else
          //           onpress();
          //       },
          //     )
          //   ],
          // ),
          child: Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }

  onpress() async {
    try {
      await getESPEN();
      Get.to(ESPENSecondScreen(
        // title: "ESPEN ${bmishow}",
        title: "based_on_bmi".tr,patientDetailsData: widget.patientDetailsData,UNINTENTIONALWEIGHT: UNINTENTIONALWEIGHT,
        result: result,
      ));
    } catch (e, s) {
      print(s);
      print('execpteion here:');
    //   Get.back();
    //   Get.back();
    // await  ShowMsgFor10sec(
    //       'ESPEN is depends on Anthropometry & Nutritional Screening, Please complete these first.');
      showAlertForEmptyData();
    }
  }

  Widget _cardwidget(String text, String path, Function _function) {
    return InkWell(
      onTap: _function,
      child: Column(
        children: [
          Card(
              color: primary_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                // side: BorderSide(width: 5, color: Colors.green)
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                    child: Text(
                  "$text",
                  style: TextStyle(
                      color: card_color,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                )),
              )),
          _patientSlipController.patientDetailsData.isEmpty
              ? SizedBox()
              : _patientSlipController.patientDetailsData[0].anthropometry.isEmpty
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "",
                          style: TextStyle(fontSize: 15),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 8),
                          child: Text(
                            "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(_patientSlipController.patientDetailsData[0].anthropometry[0].lastUpdate))}",
                            style:
                                TextStyle(color: primary_color, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String ENDOMAINOFTHENUTRITIONALSCREENING = '1';
  String MUST = '0';

  int countImparedScore;
  int MUSTSCOREWEIGHTLOSS;

  String isNRSBLANK = 'yes';
  String isMUSTBLANK = 'yes';


  Future<bool>willPopScope(){
    print('popup value');
    Get.back();
    Get.back();
  }


  bool UNINTENTIONALWEIGHT = false;

  showAlert() {
    return Get.dialog(
     WillPopScope(child:  new AlertDialog(
       title: new Text(
         'Please, Answer below to compute automatically malnutrition according to espen criteria'
             .toUpperCase(),
         style: TextStyle(fontSize: 16),
       ),
       content: new Text(
         'unintentional weight loss > 5% in the last three months or > 10% indefinite of time?'
             .toUpperCase(),
         style: TextStyle(fontSize: 14),
       ),
       actions: <Widget>[
         new ElevatedButton(
           onPressed: () async {
             Get.back();

             setState(() {
               isMUSTBLANK = 'no';
               isNRSBLANK = 'no';
               UNINTENTIONALWEIGHT = true;
             });

             print('is NRS blank: ${isNRSBLANK}');
             print('is MUST blank:: ${isMUSTBLANK}');

             // await getESPEN();
             onpress();
           },
           child: new Text('Yes'),
         ),
         new ElevatedButton(
           onPressed: () {
             Get.back();
             onpress();
           },
           child: new Text('No'),
         ),
       ],
     ), onWillPop: willPopScope)
    );
  }


  showAlertForEmptyData() {
    return Get.dialog(
        WillPopScope(child:  new AlertDialog(
          title: new Text(
            'espen_depends_on_anthro'.tr,
            style: TextStyle(fontSize: 16),
          ),
          // content: new Text(
          //   'unintentional weight loss > 5% in the last three months or > 10% indefinite of time?'
          //       .toUpperCase(),
          //   style: TextStyle(fontSize: 14),
          // ),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () async {
                Get.back();
                Get.back();
                Get.back();

              },
              child: new Text('ok'.tr.toUpperCase()),
            ),
            // new ElevatedButton(
            //   onPressed: () {
            //     Get.back();
            //     Get.back();
            //     Get.back();
            //   },
            //   child: new Text('No'),
            // ),
          ],
        ), onWillPop: willPopScope)
    );
  }

  getData() {
    countImparedScore = 0;
    MUSTSCOREWEIGHTLOSS = 0;

    for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
      if (widget.patientDetailsData.status[a].type == '0' && widget.patientDetailsData.status[a].score == '0') {
        print('yess');

        setState(() {
          ENDOMAINOFTHENUTRITIONALSCREENING = '0';
        });
      }

      print('step1');

      if (widget.patientDetailsData.status[a].type == '0' && widget.patientDetailsData.status[a].status.trim().contains('NRS - 2002'.trim())) {
        print('step2');
        setState(() {
          isNRSBLANK = 'no';
        });
        for (var d = 0; d < widget.patientDetailsData.status[a].result[0].data.length; d++) {
          if (widget.patientDetailsData.status[a].result[0].data[d].statusquestion.toLowerCase().trim().contains('Impaired Nutritional Status'.trim().toLowerCase())) {

            print('impaired count score');

            for (var e = 0; e < widget.patientDetailsData.status[a].result[0].data[d].options.length; e++) {
              var f = widget.patientDetailsData.status[a].result[0].data[d].options[e];
              if (f.isSelected) {
                int g = int.parse(f.score);
                countImparedScore = countImparedScore + g;
                print(countImparedScore);
              }
            }

            break;
          }
        }
      }

      if (widget.patientDetailsData.status[a].type == '0' && widget.patientDetailsData.status[a].status.trim().contains('MUST'.trim())) {
        print('must');

        setState(() {
          MUST = widget.patientDetailsData.status[a].score;
          isMUSTBLANK = 'no';
        });

        for (var d = 0; d < widget.patientDetailsData.status[a].result[0].data.length; d++) {
          if (widget.patientDetailsData.status[a].result[0].data[d].statusquestion.toLowerCase().trim().contains('WEIGHT LOSS'.trim().toLowerCase())) {
            for (var e = 0; e < widget.patientDetailsData.status[a].result[0].data[d].options.length; e++) {
              var f = widget.patientDetailsData.status[a].result[0].data[d].options[e];
              if (f.isSelected) {
                int g = int.parse(f.score);
                MUSTSCOREWEIGHTLOSS = MUSTSCOREWEIGHTLOSS + g;
                print(MUSTSCOREWEIGHTLOSS);
              }
            }

            break;
          }
        }
      }
    }

    print('countImparedScore: ${countImparedScore}');
    print('MUSTSCOREWEIGHTLOSS: ${MUSTSCOREWEIGHTLOSS}');
    print('MUST: ${MUST}');
    print('EN DOMAIN OF THE NUTRITIONAL SCREENING: ${ENDOMAINOFTHENUTRITIONALSCREENING}');
    print('is NRS blank: ${isNRSBLANK}');
    print('is MUST blank:: ${isMUSTBLANK}');
  }

  String result;

  String bmishow;

  getESPEN() async {

    print('countImparedScore: $countImparedScore');

    double BMI = double.parse(BMIValue.isEmpty
        ? '${widget.patientDetailsData.anthropometry[0].bmi.isEmpty ? '0' : widget.patientDetailsData.anthropometry[0].bmi}'
        : BMIValue);
    print('BMI : $BMI');

    setState(() {
      bmishow = BMI.toStringAsFixed(2);
    });
    // print('BMI : ${widget.patientDetailsData.anthropometry[0].bmi}');

    await getAgeYearsFromDate(widget.patientDetailsData.dob).then((AGE) {
      print('patients age : $AGE');
      // EUTRÓFICO (EUTROPHIC)
      // = AGE < 65 AND ≥ 18, PLUS BMI < 25 AND ≥ 18.5
      // OR
      // = AGE ≥ 65 PLUS BMI < 27 AND ≥ 22

      if ((AGE < 65 && AGE >= 18) && (BMI < 25 && BMI >= 18.5)) {
        print('EUTROPHIC');
        // return 'EUTROPHIC';

        setState(() {
          result = 'eutrophic_'.tr;
        });
        // AGE ≥ 65 PLUS BMI < 27 AND ≥ 22
      } else if (AGE >= 65 && BMI < 27 && BMI >= 22) {
        print('EUTROPHIC');

        setState(() {
          result = 'eutrophic_'.tr;
        });

        //  BAIXO PESO (LOW WEIGHT)
        //  = AGE ≥ 65 PLUS BMI < 22 AND ≥ 18.5 PLUS “EN DOMAIN OF THE NUTRITIONAL SCREENING” = 0
      } else if (((AGE < 65) && (BMI >= 25 && BMI < 30)) || ((AGE >= 65) && (BMI >= 27 && BMI < 30))) {
        print('OVERWEIGHT');
        setState(() {
          result = 'overweight'.tr;
        });

        // OBESIDADE (OBESITY)
        // = BMI ≥ 30

      } else if (BMI >= 30) {
        print('OBESITY');

        setState(() {
          result = 'obesity'.tr;
        });

        //  DESNUTRIÇÃO (MALNUTRITION)
        // = BMI < 18.5
        //
        // OR
        //
        // = AGE ≥ 70 PLUS BMI < 22 AND ≥ 18.5 + (ONE OF THE THREE CONDITIONS BELOW)
        // “Impaired nutritional status DOMAIN OF THE NRS 2002 or MUST”  ≥ 1 OR
        // STEP 2 ON MUST SCORE (WEIGHT LOSS)  ≥ 1
        //  “YES” TO THE QUESTION “UNINTENTIONAL WEIGHT LOSS > 5% IN THE LAST 3 MONTHS OR > 10 % INDEFINITE OF TIME?”
        //
        // OR
        //
        // = AGE < 70 PLUS BMI < 20 AND ≥ 18.5 + (ONE OF THE THREE CONDITIONS BELOW)
        // “Impaired nutritional status DOMAIN OF THE NRS 2002 or MUST”  ≥ 1 OR
        // STEP 2 ON MUST SCORE (WEIGHT LOSS)  ≥ 1
        // “YES” TO THE QUESTION “UNINTENTIONAL WEIGHT LOSS > 5% IN THE LAST 3 MONTHS OR > 10 % INDEFINITE OF TIME?”


      } else if ((BMI < 18.5)) {

        print('MALNUTRITION');
        print("(BMI < 18.5)" );
        setState(() {
          result = 'malnutrition'.tr;
        });

      } else if(( AGE >= 70 && BMI < 22 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1
          // || ( UNINTENTIONALWEIGHT == true)
      ) ) ) {

        print("( AGE >= 70 && BMI < 22 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1 || ( UNINTENTIONALWEIGHT == true)) ) ");
        setState(() {
          result = 'malnutrition'.tr;
        });

      }else if(( AGE < 70 && BMI < 20 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1
          // || ( UNINTENTIONALWEIGHT == true)
      ) ) ) {

        print(" ( AGE < 70 && BMI < 20 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1 || ( UNINTENTIONALWEIGHT == true)) ) ");
        setState(() {
          result = 'malnutrition'.tr;
        });

      } else if ((AGE >= 65) && (BMI < 22 && BMI >= 18.5)) {
        print('LOW WEIGHT');
        setState(() {
          result = 'low_weight'.tr;
        });

        //  SOBREPESO (OVERWEIGHT)
        // = AGE < 65 PLUS BMI ≥ 25 AND < 30
        // OR
        // = AGE ≥ 65 PLUS BMI ≥ 27 AND < 30

      }



    });
  }

  ESPENController _espenController = ESPENController();

  SaveToServer()async{
    Map data = {
      'status': "ESPEN",
      'score': '0',
      'UNINTENTIONALWEIGHT': UNINTENTIONALWEIGHT,
      'lastUpdate': '${DateTime.now()}',
    };

    print('data json: ${jsonEncode(data)}');

  await  _espenController.saveData(widget.patientDetailsData, data).then((value){



  });

  }


}
