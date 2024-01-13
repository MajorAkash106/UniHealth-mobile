import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/status_controller/espen_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

Future<String> getDateFormatFromString(String date) async {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  String output = await dateFormat.format(DateTime.parse(date));

  return output;
}

Future<String> getNRS(int score) async {
  if (score == 0) {
    return "no_nt_risk_detected".tr.toUpperCase();
  } else if (score >= 3) {
    return "nt_risk".tr.toUpperCase();
  } else {
    //ask to client
    return "no_nt_risk_detected".tr.toUpperCase();
  }
}

Future<String> getMNARESULT(int score) async {
  if (score == 0 || score <= 7) {
    return "malnourished".tr;
  } else if (score > 7 && score <= 11) {
    return "at_risk_of_malnutrition".tr;
  } else if (score > 11 && score <= 14) {
    //ask to client
    return "normal_nutritional_status".tr;
  }
}

Future<String> getSTRONGKIDS(int score) async {
  if (score == 0) {
    return "low_risk".tr;
  } else if (score <= 3) {
    return "medium_risk".tr;
  } else if (score > 3 && score <= 5) {
    //ask to client
    return "high_risk".tr;
  }
}

Future<String> getMUST(int score) async {
  if (score == 0) {
    return "low_risk".tr;
  } else if (score == 1) {
    return "medium_risk".tr;
  } else if (score >= 2) {
    //ask to client
    return "high_risk".tr;
  }
}

Future<String> getBMI(int score) async {}

Future<String> getGLIMResult(
    Phenotypic phenotypic, Etiologic etiologic, Severity severity) async {
  print('getGLIMResult--------------------------');

  print('phenotypic: ${jsonEncode(phenotypic)}');
  print('etiologic: ${jsonEncode(etiologic)}');
  print('severity: ${jsonEncode(severity)}');

  if (phenotypic != null && etiologic != null) {
    print('PERCEIVED:  ${etiologic.PERCEIVED}');

    if (phenotypic.phenotypicData.length >= 1 &&
        etiologic.etiologicData.length >= 1 &&
        (etiologic.PERCEIVED == '0' || etiologic.PERCEIVED == '1')) {
      return 'MALNUTRITION RELATED TO CHRONIC DISEASE WITH INFLAMMATION';
    } else if (phenotypic.phenotypicData.length >= 1 &&
        etiologic.etiologicData.length >= 1 &&
        etiologic.PERCEIVED == '-1') {
      return 'MALNUTRITION RELATED TO CHRONIC DISEASE WITH MINIMAL OR NO PERCEIVED INFLAMMATION';
    } else if (phenotypic.phenotypicData.length >= 1 &&
        etiologic.etiologicData.length == 1) {
      return 'MALNUTRITION RELATED TO STARVATION INCLUDING HUNGER/FOOD SHORTAGE ASSOCIATED WITH SOCIOECONOMIC OR ENVIRONMENTAL FACTORS';
    } else if (phenotypic.phenotypicData.length >= 1 &&
        etiologic.etiologicData.length >= 1 &&
        etiologic.PERCEIVED == '') {
      return 'MALNUTRITION RELATED TO ACUTE DISEASE OR INJURY WITH SEVERE INFLAMMATION';
    } else {
      return "NO MALNUTRITION";
    }
  }
}

String ENDOMAINOFTHENUTRITIONALSCREENING = '1';
String MUST = '0';

int countImparedScore;
int MUSTSCOREWEIGHTLOSS;

String isNRSBLANK = 'yes';
String isMUSTBLANK = 'yes';

Future<String> getESPENRESULT(PatientDetailsData patientDetailsData) async {
  // bool resultResturnORNOT = false;
  //
  // await ISNRSORMUST(patientDetailsData).then((value){
  //
  //    print('NRS OR MUST EXIST OR NOT : $value');
  //    resultResturnORNOT = value;
  //
  //  });

  countImparedScore = 0;
  MUSTSCOREWEIGHTLOSS = 0;
  bool UNINTENTIONALWEIGHT = false;

  for (var a = 0; a < patientDetailsData.status.length; a++) {
    if (patientDetailsData.status[a].type == '0' &&
        patientDetailsData.status[a].score == '0') {
      print('yess');

      ENDOMAINOFTHENUTRITIONALSCREENING = '0';
    }

    print('step1');

    if (patientDetailsData.status[a].type == '0' &&
        patientDetailsData.status[a].status
            .trim()
            .contains('NRS - 2002'.trim())) {
      print('step2');

      for (var d = 0;
          d < patientDetailsData.status[a].result[0].data.length;
          d++) {
        if (patientDetailsData.status[a].result[0].data[d].statusquestion
            .toLowerCase()
            .trim()
            .contains('Impaired Nutritional Status'.trim().toLowerCase())) {
          for (var e = 0;
              e < patientDetailsData.status[a].result[0].data[d].options.length;
              e++) {
            var f = patientDetailsData.status[a].result[0].data[d].options[e];
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

    if (patientDetailsData.status[a].type == '0' &&
        patientDetailsData.status[a].status.trim().contains('MUST'.trim())) {
      print('must');

      for (var d = 0;
          d < patientDetailsData.status[a].result[0].data.length;
          d++) {
        if (patientDetailsData.status[a].result[0].data[d].statusquestion
            .toLowerCase()
            .trim()
            .contains('WEIGHT LOSS'.trim().toLowerCase())) {
          for (var e = 0;
              e < patientDetailsData.status[a].result[0].data[d].options.length;
              e++) {
            var f = patientDetailsData.status[a].result[0].data[d].options[e];
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

    if (patientDetailsData.status[a].type == '2' &&
        patientDetailsData.status[a].status
            .trim()
            .contains(nutritionalDiagnosis.espen.trim())) {
      print('espen contains status');

      // for (var d = 0; d < patientDetailsData.status[a].result[0].data.length; d++) {
      //   if (patientDetailsData.status[a].result[0].data[d].statusquestion.toLowerCase().trim().contains('WEIGHT LOSS'.trim().toLowerCase())) {
      //     for (var e = 0; e < patientDetailsData.status[a].result[0].data[d].options.length; e++) {
      //       var f = patientDetailsData.status[a].result[0].data[d].options[e];
      //       if (f.isSelected) {
      //         int g = int.parse(f.score);
      //         MUSTSCOREWEIGHTLOSS = MUSTSCOREWEIGHTLOSS + g;
      //         print(MUSTSCOREWEIGHTLOSS);
      //       }
      //     }
      //
      //     break;
      //   }
      // }

      print(
          'UNINTENTIONALWEIGHT: ${patientDetailsData.status[a].result[0].uNINTENTIONALWEIGHT}');

      UNINTENTIONALWEIGHT =
          patientDetailsData.status[a].result[0].uNINTENTIONALWEIGHT;
    }
  }

  print('countImparedScore: ${countImparedScore}');
  print('MUSTSCOREWEIGHTLOSS: ${MUSTSCOREWEIGHTLOSS}');
  print('MUST: ${MUST}');
  print(
      'EN DOMAIN OF THE NUTRITIONAL SCREENING: ${ENDOMAINOFTHENUTRITIONALSCREENING}');
  print('is NRS blank: ${isNRSBLANK}');
  print('is MUST blank:: ${isMUSTBLANK}');

  String resultESPEN;
  if (patientDetailsData.anthropometry.isNotEmpty) {
    double bmi = double.parse(patientDetailsData.anthropometry[0].bmi == null ||
            patientDetailsData.anthropometry[0].bmi.isEmpty
        ? "0"
        : patientDetailsData.anthropometry[0].bmi);
    await getESPEN(bmi, patientDetailsData.dob, UNINTENTIONALWEIGHT)
        .then((value) {
      print('ESPEN RESULT : $value');
      resultESPEN = value;
    });
  } else {
    print('anthropometry null or blank');
  }

  print('return ESPEN from here $resultESPEN');
  String localEspen =
      await MySharedPreferences.instance.getStringValue(Session.espenKey);
  await GETESPEN(patientDetailsData).then((v) {
    print('local espen: $localEspen');
    print('resultESPEN: $resultESPEN');
    print('v: $v');

    if (v.isNullOrBlank || (!resultESPEN.removeAllWhitespace.contains(v))) {
      print('yeczxzvdcbzb');

      // if (localEspen == 'false' && resultESPEN!=null && resultResturnORNOT==true) {
      if (localEspen == 'false' && resultESPEN != null) {
        MySharedPreferences.instance.setStringValue(Session.espenKey, 'true');

        final HistoryController _historyController = HistoryController();
        final ESPENController _espenController = ESPENController();

        Map data = {
          'status': "ESPEN",
          'score': '0',
          'UNINTENTIONALWEIGHT': false,
          'espen_output': resultESPEN,
          'lastUpdate': '${DateTime.now()}',
        };

        print('data json: ${jsonEncode(data)}');

        _espenController.saveData(patientDetailsData, data).then((value) {
          print('updatedd');

          _historyController.saveHistoryWihtoutLoader(
              patientDetailsData.sId, ConstConfig.ESPENHistory, resultESPEN);
        });
      } else {
        print('check espen again locally');
      }
    } else {
      print('dfhgjskhfgdskjhgdjk');
    }
  });

  // return  resultResturnORNOT? resultESPEN: "";
  return resultESPEN;
}

Future<String> getESPEN(
    double BMI, String dob, bool UNINTENTIONALWEIGHT) async {
  print('BMI : $BMI');
// bool UNINTENTIONALWEIGHT = false;
  // print('BMI : ${widget.patientDetailsData.anthropometry[0].bmi}');
  int AGE;
  await getAgeYearsFromDate(dob).then((val) {
    AGE = val;
  });

  print('patients age : $AGE');
  // EUTRÓFICO (EUTROPHIC)
  // = AGE < 65 AND ≥ 18, PLUS BMI < 25 AND ≥ 18.5
  // OR
  // = AGE ≥ 65 PLUS BMI < 27 AND ≥ 22

  if ((AGE < 65 && AGE >= 18) && (BMI < 25 && BMI >= 18.5)) {
    print('EUTROPHIC');
    return 'eutrophic_'.tr;

    // AGE ≥ 65 PLUS BMI < 27 AND ≥ 22
  } else if (AGE >= 65 && BMI < 27 && BMI >= 22) {
    print('EUTROPHIC');
    return 'eutrophic_'.tr;

    //  BAIXO PESO (LOW WEIGHT)
    //  = AGE ≥ 65 PLUS BMI < 22 AND ≥ 18.5 PLUS “EN DOMAIN OF THE NUTRITIONAL SCREENING” = 0
  } else if (((AGE < 65) && (BMI >= 25 && BMI < 30)) ||
      ((AGE >= 65) && (BMI >= 27 && BMI < 30))) {
    print('OVERWEIGHT');
    return 'overweight'.tr;

    // OBESIDADE (OBESITY)
    // = BMI ≥ 30

  } else if (BMI >= 30) {
    print('OBESITY');

    return 'obesity'.tr;

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
    print("(BMI < 18.5)");

    return 'malnutrition'.tr;
  } else if ((AGE >= 70 &&
      BMI < 22 &&
      BMI >= 18.5 &&
      ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1
      // || ( UNINTENTIONALWEIGHT == true)

      ))) {
    print(
        "( AGE >= 70 && BMI < 22 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1 || ( UNINTENTIONALWEIGHT == true)) ) ");

    return 'malnutrition'.tr;
  } else if ((AGE < 70 &&
      BMI < 20 &&
      BMI >= 18.5 &&
      ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1
      // || ( UNINTENTIONALWEIGHT == true)
      ))) {
    print(
        " ( AGE < 70 && BMI < 20 && BMI >= 18.5 && ((countImparedScore >= 1 || MUST == '1') || MUSTSCOREWEIGHTLOSS >= 1 || ( UNINTENTIONALWEIGHT == true)) ) ");

    return 'malnutrition'.tr;
  } else if ((AGE >= 65) &&
      (BMI < 22 && BMI >= 18.5) &&
      (!(countImparedScore >= 1 || MUST == '1') || !(MUSTSCOREWEIGHTLOSS >= 1)
      // || !( UNINTENTIONALWEIGHT == true)
      )) {
    print('LOW WEIGHT');

    return 'low_weight'.tr;
    //  SOBREPESO (OVERWEIGHT)
    // = AGE < 65 PLUS BMI ≥ 25 AND < 30
    // OR
    // = AGE ≥ 65 PLUS BMI ≥ 27 AND < 30

  }
}

opendialogStrongKids(context, String SK, int score) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: Get.width / 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "STRONG - KIDS - ",
                      style: TextStyle(color: primary_color),
                    ),
                    Text(
                      "$SK".toUpperCase(),
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                SizedBox(
                  height: 10,
                ),
                getWidget(score),
                // Padding(
                //     padding: EdgeInsets.only(left: 30.0, right: 30.0),
                //     child: Column(children: [
                //       Text(
                //         '1. No nutritional intervention necessary',
                //         style: TextStyle(
                //             // color: primary_color,
                //             fontSize: 15),
                //       ),
                //       Text(
                //         '2. Check weight regularly (according to hospital policy)',
                //         style: TextStyle(
                //             // color: primary_color,
                //             fontSize: 15),
                //       ),
                //       Text(
                //         '3. Evaluate the nutritional risk weekly',
                //         style: TextStyle(
                //             // color: primary_color,
                //             fontSize: 15),
                //       ),
                //
                //     ],)
                // ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: primary_color,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

getWidget(int score) {
  if (score == 0) {
    //low risk
    return Padding(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. No nutritional intervention necessary',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '2. Check weight regularly (according to hospital policy)',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '3. Evaluate the nutritional risk weekly',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
          ],
        ));
  } else if (score <= 3) {
    // return "Medium Risk";
    return Padding(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Consider nutritional intervention',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '2. Check weight twice a week',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '3. Evaluate the nutritional risk weekly',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
          ],
        ));
  } else if (score > 3 && score <= 5) {
    //ask to client
    // return "High Risk";
    return Padding(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Consult doctor and dietician for full diagnosis and individual nutritional advice and follow-up',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '2. Check weight twice a week and evaluate nutritional advice',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
            Text(
              '3. Evaluate the nutritional risk weekly',
              style: TextStyle(
                  // color: primary_color,
                  fontSize: 15),
            ),
          ],
        ));
  }
}

ShowListONPopup(context, String title, List<Options> _list) {
  List<Options> p;
  p = _list;
//_list.map((e) => p.add(e.statusoption));
  print(p[0].statusoption);
//.map((e) => '${_list.indexOf(e)+1}. ${e.statusoption}').toList();
  print(_list.length);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: Get.width / 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    "$title",
                    style: TextStyle(color: primary_color),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Container(
                      height: _list.length < 5
                          ? Get.height / 2.5
                          : Get.height / 1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //  height: Get.height/1.5,
                            child: Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: p.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${index + 1}' + '.'),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Expanded(
                                              child: Text(
                                            p[index].statusoption,
                                            style: TextStyle(
                                              fontSize: 15.0,
                                            ),
                                          )),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          )

                          //   ListView(
                          //   shrinkWrap: true,
                          //   children:[Expanded(child: Wrap(
                          //
                          //     children:[
                          //     //  Expanded(child: Text('${d}'))
                          //     ]
                          //
                          //     // _list.map((e) =>
                          //     //   Text(
                          //     //     '${_list.indexOf(e)+1}. ${e.statusoption}',
                          //     //     style: TextStyle(
                          //     //       // color: primary_color,
                          //     //         fontSize: 15),
                          //     //   )
                          //     // ,).toList() ,
                          //
                          //
                          //
                          //   ))]
                          //
                          //
                          //
                          // )
                        ],
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: primary_color,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "close".tr,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

ShowTextONPopup(context, String title, String text) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: Get.width / 1.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    "$title",
                    style: TextStyle(color: primary_color),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SingleChildScrollView(
                      child: Text(
                        '$text',
                        style: TextStyle(
                            // color: primary_color,
                            fontSize: 15),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: primary_color,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "close".tr,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

showRiskPopup(context, int value, Function _fun) {
  return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            print("back button disabled");
            Get.back();
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Container(
                // color: Colors.red,
                //height: 100.0,

                child: Center(
                  // child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),

                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: Get.height / 1.5,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(color: primary_color, width: 7.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value == 0
                                      ? '0'
                                      : value == 1
                                          ? '1'
                                          : '2 ${'or_more'.tr}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  value == 0
                                      ? 'low_risk'.tr
                                      : value == 1
                                          ? 'medium_risk'.tr
                                          : 'high_risk'.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                value == 0
                                    ? Expanded(
                                        child: Text(
                                          'routine_clinical_care'.tr,
                                          maxLines: 2,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    : Text(
                                        value == 0
                                            ? 'routine_clinical_care'.tr
                                            : value == 1
                                                ? 'observe'.tr
                                                : 'treat*'.tr,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w400),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            value == 0
                                ? //value==1?'1':'2 or more',
                                Padding(
                                    padding: const EdgeInsets.only(left: 35.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 10.0,
                                            ),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              'repeat_screening'.tr,
                                              style: TextStyle(fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8.0,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.0),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              '${'hospital_weekly'.tr} ',
                                              style: TextStyle(fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.0),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '${'care_homes_monthly'.tr} ',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.0),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              '${'community_annually'.tr} ',
                                              style: TextStyle(fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.0),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              '${'for_special_groups'.tr}  ',
                                              style: TextStyle(fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 10.0),
                                            SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              '${'example_those_75_yrs'.tr}  ',
                                              style: TextStyle(fontSize: 15.0),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : value == 1
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'document_dietary_intake_for_3_days'.tr}',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'if_adequate_little_concern_and_repeat_screening'.tr}',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 8.0,
                                                        color: primary_color,
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        'hospital_weekly'.tr,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      )),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 8.0,
                                                        color: primary_color,
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        'care_home_at_least_monthly'
                                                            .tr,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      )),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    // mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 6.0),
                                                        child: Icon(
                                                          Icons.circle,
                                                          size: 8.0,
                                                          color: primary_color,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        'community_at_least_every_2_3_months'
                                                            .tr,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'if_inadequate_des'.tr}',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'refer_to_dietitian'.tr}',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'set_goals'.tr}',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 6.0),
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10.0,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5.0,
                                                ),
                                                Expanded(
                                                    child: Text(
                                                  ' ${'monitor_and_review_care_plan'.tr} ',
                                                  style:
                                                      TextStyle(fontSize: 15.0),
                                                )),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'hospital_weekly'.tr,
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                  Text(
                                                    'care_homes_monthly'.tr,
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                  Text(
                                                    'community_monthly'.tr,
                                                    style: TextStyle(
                                                        fontSize: 15.0),
                                                  ),
                                                  SizedBox(
                                                    height: 10.0,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '*',
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      ),
                                                      SizedBox(
                                                        width: 5.0,
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        'unless_detrimental_or_no_benefit'
                                                            .tr,
                                                        style: TextStyle(
                                                            fontSize: 15.0),
                                                      ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                            Spacer(),
                            Container(
                              width: 200.0,
                              child: MaterialButton(
                                elevation: 0.1,
                                onPressed: () {
                                  _fun();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primary_color,
                                child: Center(
                                  child: Text(
                                    'confirm'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            //SizedBox(height: 5.0,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // color: Colors.green,
                  // ),
                ),
              ),
            ),
          ),
        );
      });
}



showNutricPopup(context, int value,String scoreType, Function _fun) {
  List<String> _highScore = [
    "associated_with_worse_des".tr,
    "aggressive_nutrition_therapy_des".tr
  ];
  List<String> _lowScore = [
    "low_malnutrition_risk_des".tr
  ];



  List<String> _listItem = [];
  if(scoreType == 'low_score'){
    _listItem = _lowScore;
  }else{
    _listItem = _highScore;
  }

  return showDialog(
      context: context,
      // barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            print("back button disabled");
            Get.back();
            return true;
          },
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Container(
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      height: Get.height / 1.5,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(color: primary_color, width: 7.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  // value == 0
                                  //     ? '0'
                                  //     : value == 1
                                  //         ? '1'
                                  //         : '2 ${'or_more'.tr}',
                                  '$value',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  scoreType.tr,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: _listItem.map((e) => Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 6.0),
                                          child: Icon(
                                            Icons.circle,
                                            size: 10.0,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Expanded(
                                            child: Text(
                                              ' $e',
                                              style: TextStyle(fontSize: 15.0),
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 10,)
                                  ],
                                )).toList(),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 200.0,
                              child: MaterialButton(
                                elevation: 0.1,
                                onPressed: () {
                                  _fun();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                color: primary_color,
                                child: Center(
                                  child: Text(
                                    'confirm'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            //SizedBox(height: 5.0,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // color: Colors.green,
                  // ),
                ),
              ),
            ),
          ),
        );
      });
}
