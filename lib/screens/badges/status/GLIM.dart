import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/glimFunc.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/autoSizableText.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/status_controller/GLIMController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/Anthropometry_screen.dart';
import 'package:medical_app/screens/badges/status/ESPEN_second.dart';
import 'package:medical_app/screens/badges/status/EtiologicalCriteria.dart';
import 'package:medical_app/screens/badges/status/NRS_2002.dart';
import 'package:medical_app/screens/badges/status/PenotypicCriteria.dart';
import 'package:medical_app/screens/badges/status/SeverityScreen.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class GLIMScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  GLIMScreen({this.patientDetailsData});
  @override
  _GLIMScreenState createState() => _GLIMScreenState();
}

class _GLIMScreenState extends State<GLIMScreen> {
  final GlimController _controller = GlimController();
  final PatientSlipController _patientSlipController = PatientSlipController();

  @override
  void initState() {
    // TODO: implement initState
    // getselectedData();
    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
      print('internet');
      if (internet != null && internet) {
        getPatientsAndPheno();

        print('internet avialable');
      }else{
        //copy online func
        // getPatientsAndPheno();
        getPatientsAndPhenOffline();
      }
    });
    super.initState();
  }

  getPatientsAndPheno()async {
    showLoader();
  await  _patientSlipController
        .getDetails(widget.patientDetailsData.sId, 2)
        .then((value) {
          Get.back();
      getselectedData().then((value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller.getData().then((value) {
            for (var a = 0; a < _controller.phenotypicData.length; a++) {
              for (var b = 0;
                  b < _controller.phenotypicData[a].options.length;
                  b++) {
                if (SelectedIdPheno.contains(
                    _controller.phenotypicData[a].options[b].sId)) {
                  setState(() {
                    _controller.phenotypicData[a].options[b].isSelected = true;
                    _controller.phenotypicData[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.phenotypicData[a].options[b].isSelected = false;
                    _controller.phenotypicData[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.phenotypicData2.length; a++) {
              for (var b = 0;
                  b < _controller.phenotypicData2[a].options.length;
                  b++) {
                if (SelectedIdPheno.contains(
                    _controller.phenotypicData2[a].options[b].sId)) {
                  setState(() {
                    _controller.phenotypicData2[a].options[b].isSelected = true;
                    _controller.phenotypicData2[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.phenotypicData2[a].options[b].isSelected =
                        false;
                    _controller.phenotypicData2[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.etiologic.length; a++) {
              for (var b = 0;
                  b < _controller.etiologic[a].options.length;
                  b++) {
                if (SelectedIdEtio.contains(
                    _controller.etiologic[a].options[b].sId)) {
                  setState(() {
                    _controller.etiologic[a].options[b].isSelected = true;
                    _controller.etiologic[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.etiologic[a].options[b].isSelected = false;
                    _controller.etiologic[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.severity.length; a++) {
              for (var b = 0; b < _controller.severity[a].options.length; b++) {
                if (SelectedIdSeverity.contains(
                    _controller.severity[a].options[b].sId)) {
                  setState(() {
                    _controller.severity[a].options[b].isSelected = true;
                    _controller.severity[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.severity[a].options[b].isSelected = false;
                    _controller.severity[a].selectedTitle = false;
                  });
                }
              }
            }
            for (var a = 0; a < _controller.severity2.length; a++) {
              for (var b = 0;
                  b < _controller.severity2[a].options.length;
                  b++) {
                if (SelectedIdSeverity.contains(
                    _controller.severity2[a].options[b].sId)) {
                  setState(() {
                    _controller.severity2[a].options[b].isSelected = true;
                    _controller.severity2[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.severity2[a].options[b].isSelected = false;
                    _controller.severity2[a].selectedTitle = false;
                  });
                }
              }
            }
          });
        });
      });
    });


   await GETSEVERITYACCESS(_patientSlipController.patientDetailsData[0]).then((value){

      print('access severity: $value');
      setState(() {
        accessSeverity = value;
      });

    });

  }

  getPatientsAndPhenOffline()async {
  await  _patientSlipController
        .getDetailsOffline(widget.patientDetailsData.sId, 2)
        .then((value) {
      getselectedData().then((value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller.getData().then((value) {
            for (var a = 0; a < _controller.phenotypicData.length; a++) {
              for (var b = 0;
                  b < _controller.phenotypicData[a].options.length;
                  b++) {
                if (SelectedIdPheno.contains(
                    _controller.phenotypicData[a].options[b].sId)) {
                  setState(() {
                    _controller.phenotypicData[a].options[b].isSelected = true;
                    _controller.phenotypicData[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.phenotypicData[a].options[b].isSelected = false;
                    _controller.phenotypicData[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.phenotypicData2.length; a++) {
              for (var b = 0;
                  b < _controller.phenotypicData2[a].options.length;
                  b++) {
                if (SelectedIdPheno.contains(
                    _controller.phenotypicData2[a].options[b].sId)) {
                  setState(() {
                    _controller.phenotypicData2[a].options[b].isSelected = true;
                    _controller.phenotypicData2[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.phenotypicData2[a].options[b].isSelected =
                        false;
                    _controller.phenotypicData2[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.etiologic.length; a++) {
              for (var b = 0;
                  b < _controller.etiologic[a].options.length;
                  b++) {
                if (SelectedIdEtio.contains(
                    _controller.etiologic[a].options[b].sId)) {
                  setState(() {
                    _controller.etiologic[a].options[b].isSelected = true;
                    _controller.etiologic[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.etiologic[a].options[b].isSelected = false;
                    _controller.etiologic[a].selectedTitle = false;
                  });
                }
              }
            }

            for (var a = 0; a < _controller.severity.length; a++) {
              for (var b = 0; b < _controller.severity[a].options.length; b++) {
                if (SelectedIdSeverity.contains(
                    _controller.severity[a].options[b].sId)) {
                  setState(() {
                    _controller.severity[a].options[b].isSelected = true;
                    _controller.severity[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.severity[a].options[b].isSelected = false;
                    _controller.severity[a].selectedTitle = false;
                  });
                }
              }
            }
            for (var a = 0; a < _controller.severity2.length; a++) {
              for (var b = 0;
                  b < _controller.severity2[a].options.length;
                  b++) {
                if (SelectedIdSeverity.contains(
                    _controller.severity2[a].options[b].sId)) {
                  setState(() {
                    _controller.severity2[a].options[b].isSelected = true;
                    _controller.severity2[a].selectedTitle = true;
                  });
                } else {
                  setState(() {
                    _controller.severity2[a].options[b].isSelected = false;
                    _controller.severity2[a].selectedTitle = false;
                  });
                }
              }
            }
          });
        });
      });
    });


   await GETSEVERITYACCESS(_patientSlipController.patientDetailsData[0]).then((value){

      print('access severity: $value');
      setState(() {
        accessSeverity = value;
      });

    });

  }





  List SelectedIdEtio = [];
  List SelectedIdPheno = [];
  List SelectedIdSeverity = [];
  String PERCEIVED = '-1';
  Future<String> getselectedData() async {
    SelectedIdEtio.clear();
    SelectedIdPheno.clear();
    SelectedIdSeverity.clear();

    for (var a = 0;
        a < _patientSlipController.patientDetailsData[0].status.length;
        a++) {
      if (_patientSlipController.patientDetailsData[0].status[a].type ==
              statusType.nutritionalDiagnosis &&
          _patientSlipController.patientDetailsData[0].status[a].status
                  .trim() ==
              nutritionalDiagnosis.glim.trim()) {
        Result result =
            _patientSlipController.patientDetailsData[0].status[a].result[0];
        // print('etiologic data: ${jsonEncode(result.etiologic.etiologicData)}');
        PERCEIVED = result.etiologic?.PERCEIVED ?? '-1';
        List<EtiologicData> etiologicData =
            result.etiologic?.etiologicData ?? [];

        for (var b = 0; b < etiologicData.length; b++) {
          if (etiologicData[b].selectedTitle) {
            // SelectedIdEtio.add(etiologicData[b].sId);

            for (var c = 0; c < etiologicData[b].options.length; c++) {
              if (etiologicData[b].options[c].isSelected) {
                SelectedIdEtio.add(etiologicData[b].options[c].sId);
                break;
              }
            }

            // break;
          }
        }

        break;
      }
    }

    for (var a = 0;
        a < _patientSlipController.patientDetailsData[0].status.length;
        a++) {
      if (_patientSlipController.patientDetailsData[0].status[a].type ==
              statusType.nutritionalDiagnosis &&
          _patientSlipController.patientDetailsData[0].status[a].status
                  .trim() ==
              nutritionalDiagnosis.glim.trim()) {
        Result result =
            _patientSlipController.patientDetailsData[0].status[a].result[0];
        if (result.phenotypic != null && result.phenotypic != '') {
          print(
              'phenotypic data: ${jsonEncode(result.phenotypic.phenotypicData)}');

          List<EtiologicData> phenotypicc = result.phenotypic.phenotypicData;

          for (var b = 0; b < phenotypicc.length; b++) {
            if (phenotypicc[b].selectedTitle) {
              // SelectedIdPheno.add(phenotypicc[b].sId);

              for (var c = 0; c < phenotypicc[b].options.length; c++) {
                if (phenotypicc[b].options[c].isSelected) {
                  SelectedIdPheno.add(phenotypicc[b].options[c].sId);
                  break;
                }
              }

              // break;
            }
          }

          if (result.phenotypic.selectedStatus == '1' &&
              result?.etiologic?.selectedStatus == '1') {
            setState(() {
              pheno = true;
              etio = true;
              nextToSeverity = true;
            });
          }
        }

        break;
      }
    }

    for (var a = 0;
        a < _patientSlipController.patientDetailsData[0].status.length;
        a++) {
      if (_patientSlipController.patientDetailsData[0].status[a].type ==
              statusType.nutritionalDiagnosis &&
          _patientSlipController.patientDetailsData[0].status[a].status
                  .trim() ==
              nutritionalDiagnosis.glim.trim()) {
        Result result =
            _patientSlipController.patientDetailsData[0].status[a].result[0];
        // print('etiologic data: ${jsonEncode(result.etiologic.etiologicData)}');
        // PERCEIVED = result.etiologic?.PERCEIVED ?? '-1';
        List<EtiologicData> severity = result.severity?.severityData ?? [];

        for (var b = 0; b < severity.length; b++) {
          if (severity[b].selectedTitle) {
            // SelectedIdEtio.add(etiologicData[b].sId);

            for (var c = 0; c < severity[b].options.length; c++) {
              if (severity[b].options[c].isSelected) {
                SelectedIdSeverity.add(severity[b].options[c].sId);
                break;
              }
            }

            // break;
          }
        }

        break;
      }
    }

    for (var a = 0;
        a < _patientSlipController.patientDetailsData[0].status.length;
        a++) {
      if (_patientSlipController.patientDetailsData[0].status[a].type ==
              statusType.nutritionalDiagnosis &&
          _patientSlipController.patientDetailsData[0].status[a].status
                  .trim() ==
              nutritionalDiagnosis.glim.trim()) {
        Result result =
            _patientSlipController.patientDetailsData[0].status[a].result[0];

        print(
            'phenotypic selected status: ${jsonEncode(result.phenotypic?.selectedStatus ?? '0')}');
        print(
            'etiologic selected status: ${jsonEncode(result.etiologic?.selectedStatus ?? '0')}');
        if (result.etiologic != null && result.phenotypic != null) {
          if (result.phenotypic.selectedStatus == '1' &&
              result.etiologic.selectedStatus == '1') {
            setState(() {
              nextToSeverity = true;
            });
          }
        }

        break;
      }
    }

    print('selected etio: ${SelectedIdEtio}');
    print('selected pheno: ${SelectedIdPheno}');

    return 'success';
  }

  bool nextToSeverity = false;

  bool pheno = false;
  bool etio = false;

  final HistoryController _historyController = HistoryController();

  Future<bool> _willPopScope() {
    if (updateAny == true) {
      checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
        if(internet!=null && internet){
          getData2();
        }else{
          print('direct to slip screen');
          Get.to(Step1HospitalizationScreen(
            index: 2,
            statusIndex: 2,
            patientUserId: _patientSlipController.patientDetailsData[0].sId,
          ));
        }
      });

    }
    // else{
    //   Get.back();
    // }

    // _historyController.saveHistory(_patientSlipController.patientDetailsData[0].sId, ConstConfig.akpsHistory,'mesg');

    Get.to(Step1HospitalizationScreen(
      index: 2,
      statusIndex: 2,
      patientUserId: _patientSlipController.patientDetailsData[0].sId,
    ));
  }

  getData2() {
    print(
        "status len: ${_patientSlipController.patientDetailsData[0].status.length}");
    for (var a = 0;
        a < _patientSlipController.patientDetailsData[0].status.length;
        a++) {
      if (_patientSlipController.patientDetailsData[0].status[a].type ==
          statusType.nutritionalDiagnosis) {
        if (_patientSlipController.patientDetailsData[0].status[a].status
                .trim() ==
            nutritionalDiagnosis.glim.trim()) {
          print('nutritionalDiagnosis data--------------------}');


          // getGLIMResult(_patientSlipController.patientDetailsData[0].status[a].result[0].phenotypic, _patientSlipController.patientDetailsData[0].status[a].result[0].etiologic, _patientSlipController.patientDetailsData[0].status[a].result[0].severity)
          //     .then((value) {
          //   print('return GLIM result: ${value}');
          //
          //   value != null
          //       ? _historyController.saveHistory(
          //           _patientSlipController.patientDetailsData[0].sId,
          //           ConstConfig.GLIMHistory,
          //           value)
          //       : print('return null');
          // });

          GETGLIMRESULT(_patientSlipController.patientDetailsData[0]).then((value){

              print('return GLIM result: ${value}');

              value != null
                  ? _historyController.saveHistory(
                      _patientSlipController.patientDetailsData[0].sId,
                      ConstConfig.GLIMHistory,
                      value)
                  : print('return null');




          });



        }

        // print('return GLIM result: NO MALNUTRITION');

        break;
      }
    }
  }

  bool updateAny = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: BaseAppbar('glim'.tr, null),
          // bottomNavigationBar: CommonHomeButton(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "glim_req_text".tr,
                      style: TextStyle(
                          color: appbar_icon_color,
                          fontSize: 16,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _widgetPhenotypic(),
                  SizedBox(height: 10),
                  _widgetEtiologic(),
                  SizedBox(height: 10),
                  _widgetSeverity(),
                  // RaisedButton(
                  //   onPressed: () {
                  //     // for (var e in _patientSlipController.patientDetailsData[0].status) {
                  //     //   if (e.type == '2' && e.status == nutritionalDiagnosis.glim)
                  //     //   {Phenotypic phenotypic = e.result[0].phenotypic;
                  //     //   Etiologic etiologic = e.result[0].etiologic;
                  //     //     Severity severity = e.result[0].severity;
                  //     //
                  //     //     if (phenotypic != null && etiologic != null) {
                  //     //       print('PERCEIVED:  ${etiologic.PERCEIVED}');
                  //     //
                  //     //       print('weightloss: ${phenotypic.weightlossStatus}');
                  //     //       print('bmi: ${phenotypic.condition}');
                  //     //       print(
                  //     //           'reduce muscle: ${phenotypic.reducedMassMuscle.length}');
                  //     //
                  //     //       String phenoScore = '1';
                  //     //       String etioScore = '1';
                  //     //
                  //     //       if ((phenotypic.weightlossStatus.isNullOrBlank || phenotypic.weightlossStatus.contains('WEIGHT LOSS ABSENT')) && (phenotypic.condition == false) && phenotypic.reducedMassMuscle.isNullOrBlank) {
                  //     //         print('pheno points Zero');
                  //     //         phenoScore = '0';
                  //     //       }
                  //     //
                  //     //       if (etiologic.etiologicData.isNullOrBlank) {
                  //     //         print('etio points Zero');
                  //     //         etioScore = '0';
                  //     //
                  //     //       }
                  //     //
                  //     //       // if(severity.)
                  //     //
                  //     //
                  //     //
                  //     //       if(phenoScore == '0' || etioScore == '0'){
                  //     //         //NO ONE OF THE PHENOTYPIC OR ETIOLOGIC CRITERIA
                  //     //         // WERE FILLED - ZERO POINTS FOR BOTH
                  //     //
                  //     //         print('NO MALNUTRITION');
                  //     //         return "NO MALNUTRITION";
                  //     //
                  //     //       }else if(phenoScore != '0' && etioScore != '0' && etiologic.PERCEIVED == '0'){
                  //     //       //  ONE OR MORE POINTS OF THE PHENOTYPIC + ONE OR MORE POINTS OF THE ETIOLOGIC
                  //     //         // CRITERIA  (INFLAMMATION >
                  //     //         // CHRONIC DISEASE-RELATED >
                  //     //         // PERCEIVED INFLAMMATION)
                  //     //
                  //     //         print('MALNUTRITION RELATED TO CHRONIC DISEASE WITH INFLAMMATION ${severity?.stageType.isNullOrBlank?"":"(${severity?.stageType})"}');
                  //     //       }else if(phenoScore != '0' && etiologic.iNFLAMMATIONText.contains('CHRONIC DISEASE-RELATED') && etiologic.PERCEIVED != '0' ){
                  //     //       //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
                  //     //         // CRITERIA INFLAMMATION (INFLAMMATION >
                  //     //         // CHRONIC DISEASE-RELATED) (IN THIS OPTION, THE PERCEIVED INFLAMMATION BOX WAS NOT CHECKED)
                  //     //
                  //     //         print('MALNUTRITION RELATED TO CHRONIC DISEASE WITH MINIMAL OR NO PERCEIVED INFLAMMATION');
                  //     //
                  //     //       }else if(phenoScore != '0' && etiologic.iNFLAMMATIONText.contains('ACUTE DISEASE/INJURY')){
                  //     //       //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
                  //     //         // CRITERIA INFLAMMATION  (INFLAMMATION >
                  //     //         // ACUTE DISEASE/INJURY)
                  //     //         print('MALNUTRITION RELATED TO ACUTE DISEASE OR INJURY WITH SEVERE INFLAMMATION');
                  //     //       }else if(phenoScore != '0' && etiologic.foodIntake.contains('YES')  && etiologic.iNFLAMMATIONText.isNullOrBlank){
                  //     //       //  ONE OR MORE POINTS OF THE PHENOTYPIC + JUST THE ETIOLOGIC
                  //     //         // CRITERIA REDUCED FOOD INTAKE
                  //     //         // (IN THIS OPTION, INFLAMMATION WAS NOT CHECKED)
                  //     //
                  //     //         print('MALNUTRITION RELATED TO STARVATION INCLUDING HUNGER/FOOD SHORTAGE ASSOCIATED WITH SOCIOECONOMIC OR ENVIRONMENTAL FACTORS');
                  //     //       }
                  //     //
                  //     //
                  //     //
                  //     //
                  //     //
                  //     //       break;
                  //     //     }
                  //     //   }
                  //     //
                  //     // }
                  //     //
                  //
                  //
                  //     // GETSEVERITYACCESS(_patientSlipController.patientDetailsData[0]).then((value){
                  //     //
                  //     //   print('access severity: $value');
                  //     //   setState(() {
                  //     //     accessSeverity = value;
                  //     //   });
                  //     //
                  //     // });
                  //
                  //     GETGLIMRESULT(_patientSlipController.patientDetailsData[0]).then((value){
                  //
                  //       print('return GLIM result: ${value}');
                  //
                  //
                  //
                  //
                  //
                  //
                  //     });
                  //
                  //   },
                  //   child: Text('getResult'),
                  // ),
                ],
              ),
            ),
          ),
        ),
        onWillPop: _willPopScope);
  }

  bool accessSeverity = false;

  Widget _widgetPhenotypic() {
    return Column(
      children: [
        Container(
            width: Get.width,
            height: 210,
            child: InkWell(
              onTap: () {
                print('data for phenotypic : ${_controller.phenotypicData}');

                Get.to(PhenotypicScreen(
                  phenotypicData: _controller.phenotypicData,
                  phenotypicData2: _controller.phenotypicData2,
                  title: 'phenotypic_criteria'.tr.toUpperCase(),
                  patientDetailsData:
                      _patientSlipController.patientDetailsData[0],
                )).then((value) {
                  print('return: $value');
                  if (value != null) {
                    setState(() {
                      pheno = true;
                      updateAny = true;
                      if (pheno && etio) {
                        nextToSeverity = true;
                      }
                    });

                    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
                      print('internet');
                      if (internet != null && internet) {
                        getPatientsAndPheno();

                        print('internet avialable');
                      }else{
                        //copy online func
                        // getPatientsAndPheno();
                        print('scope here ------------------');
                        getPatientsAndPhenOffline();
                      }
                    });

                    // getPatientsAndPheno();
                  }


                });
              },
              child: Card(
                color: card_color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    side: BorderSide(width: 1, color: primary_color)),
                child: FutureBuilder(
                    future: GETPHENOTYPIC(
                        _patientSlipController.patientDetailsData[0]),
                    initialData: "Loading text..",
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('project snapshot data is: ${snapshot.data}');
                      if (snapshot.data == null) {
                        return missingInfo('phenotypic_criteria'.tr);
                      }
                      Phenotypic project = snapshot.data;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary_color,
                                    // border: Border.all(
                                    //   color: Colors.red[340],
                                    // ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 16.0),
                                      child: Text(
                                        'phenotypic_criteria'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    // clicktoResult(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "weight_loss_per:".tr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                   // SizedBox(height: 1,),
                                   Row(children: [
                                     autoSizableText(
                                         project.weightlossStatus
                                             .isNullOrBlank
                                             ? "missing_answer_zero_point".tr
                                             :
                                         "${
                                             project.weightlossStatus.contains('WEIGHT LOSS ABSENT')
                                         //    adding for BR version
                                         || project.weightlossStatus.contains('NÃO HOUVE PERDA DE PESO')

                                                 ? "${project.weightlossStatus} (${'zero_point'.tr})" : "${project.weightlossStatus} (${'one_point'.tr})"}",
                                         'phenotypic'.tr,
                                         project.weightlossStatus.contains('WEIGHT LOSS ABSENT')
                                       //  adding for BR version
                                             || project.weightlossStatus.contains('NÃO HOUVE PERDA DE PESO')
                                             ? "missing_answer_zero_point".tr
                                             :
                                         "${project.weightlossStatus.contains('WEIGHT LOSS ABSENT')
                                             //  adding for BR version
                                             || project.weightlossStatus.contains('NÃO HOUVE PERDA DE PESO')

                                             ? "${project.weightlossStatus} (${'zero_point'.tr})" : "${project.weightlossStatus} (${'one_point'.tr})"}",
                                         context),
                                   ],),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(
                                          "${'bmi'.tr}: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        project.condition==null?Text('missing_answer_zero_point'.tr,style: TextStyle(fontSize: 13),):
                                        autoSizableText(
                                            "${project.condition ? "low_bmi_one_point".tr : "bmi_not_low_zero_point".tr} ",
                                            'phenotypic'.tr,
                                            "${project.condition ? "low_bmi_one_point".tr : "bmi_not_low_zero_point".tr} ",
                                            context)
                                        // Text(
                                        //   "${project.condition?"LOW BMI (1 POINT)":"BMI NOT LOW (ZERO POINT)"} ",
                                        //   style: TextStyle(
                                        //       fontWeight: FontWeight.normal),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "PATIENT : ",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     autoSizableText(
                                    //         "${project.patientType}"
                                    //             .toUpperCase(),
                                    //         'Phenotypic',
                                    //         "${project.patientType}"
                                    //             .toUpperCase(),
                                    //         context)
                                    //     // Text(
                                    //     //   "${project.condition?"LOW BMI (1 POINT)":"BMI NOT LOW (ZERO POINT)"} ",
                                    //     //   style: TextStyle(
                                    //     //       fontWeight: FontWeight.normal),
                                    //     // ),
                                    //   ],
                                    // ),
                                    Text(
                                      "${'reduced_muscle_mass'.tr} ${project.reducedMassMuscle.isNullOrBlank ? '' : '(${'one_point'.tr})'}: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    project.reducedMassMuscle.isNullOrBlank
                                        ? Text(
                                            'missing_answer_zero_point'.tr,
                                            style: TextStyle(fontSize: 13),
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ...project.reducedMassMuscle
                                                  .map((r) {
                                                return Text(r.optionname);
                                              }).toList()
                                            ],
                                          )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "",
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, bottom: 8),
                                child: Text(
                                  "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(project.lastUpdate))}",
                                  style: TextStyle(
                                      color: primary_color, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
              ),
            ))

        // SizedBox(height: 20,)
      ],
    );
  }

  Widget _widgetEtiologic() {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              // Get.to(EtiologicalCriteria());
              Get.to(EtiologicScreen(
                EtiologicData: _controller.etiologic,
                title: 'etiologic_criteria'.tr.toUpperCase(),
                patientDetailsData:
                    _patientSlipController.patientDetailsData[0],
              )).then((value) {
                print('return: $value');
                if (value != null) {
                  setState(() {
                    etio = true;
                    updateAny = true;
                    if (pheno && etio) {
                      nextToSeverity = true;
                    }
                  });
                  // getPatientsAndPheno();
                  checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
                    print('internet');
                    if (internet != null && internet) {
                      getPatientsAndPheno();

                      print('internet avialable');
                    }else{
                      //copy online func
                      // getPatientsAndPheno();
                      print('scope here ------------------');
                      getPatientsAndPhenOffline();
                    }
                  });
                }

                GETSEVERITYACCESS(_patientSlipController.patientDetailsData[0]).then((value){

                  print('access severity: $value');
                  setState(() {
                    accessSeverity = value;
                  });

                });

              });
            },
            child: Card(
              color: card_color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(width: 1, color: primary_color)),
              child: FutureBuilder(
                  future: GETETIOLOGIC(
                      _patientSlipController.patientDetailsData[0]),
                  initialData: "Loading text..",
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print('project snapshot data is: ${snapshot.data}');
                    if (snapshot.data == null) {
                      return missingInfo('etiologic_criteria'.tr);
                    }
                    Etiologic project = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: primary_color,
                                  // border: Border.all(
                                  //   color: Colors.red[340],
                                  // ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, left: 16.0),
                                    child: Text(
                                      'etiologic_criteria'.tr,
                                      style: TextStyle(
                                        color: card_color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  // clicktoResult(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${'reduced_food__intake'.tr} : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                Row(children: [
                                  project.foodIntake.isNullOrBlank
                                      ? Text(
                                    'missing_answer_zero_point'.tr,
                                    style: TextStyle(fontSize: 13),
                                  )
                                      : Text(
                                    'yes_one_point'.tr,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],)

                                  // Text('${project.iNFLAMMATIONText} ${project.PERCEIVED == '0' ? } YES (1 POINT)',style: TextStyle(fontSize: 13),)
                                ],
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   "PERCEIVED INFLAMMATION",
                                  //   style: TextStyle(
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                  // Text(
                                  //     "${project.PERCEIVED == '0' ? 'Yes' : 'No'}")
                                  Text(
                                    "${'inflammation'.tr} : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                              Row(children: [
                                project.iNFLAMMATIONText.isNullOrBlank
                                    ? Text(
                                  'missing_answer_zero_point'.tr,
                                  style: TextStyle(fontSize: 13),
                                )
                                    : FutureBuilder(
                                    future: GETINFLAMTEXT(
                                        project.iNFLAMMATIONText,
                                        project.PERCEIVED),
                                    initialData: "Loading text..",
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> value) {
                                      return Expanded(child: Text(value.data, style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13),maxLines: 2,));
                                      // return autoSizableText(
                                      //     value.data,
                                      //     'Severity',
                                      //     value.data,
                                      //     context);
                                    })
                              ],)
                                ],
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 8),
                              child: Text(
                                "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(project.lastUpdate))}",
                                style: TextStyle(
                                    color: primary_color, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }

// GETINFLAMTEXT(String Inflam,String perceived){
//
//     // String output = '';
//     if(Inflam.contains('ACUTE DISEASE/INJURY')){
//
//       return  "ACUTE DISEASE/INJURY (1 POINT)";
//     }else if(perceived == '0' ){
//       //  yes
//       return "CHRONIC DISEASE-RELATED WITH INFLAMMATION (1 POINT)";
//     }else if(perceived == '1' || perceived == '-1' ){
//       //  no
//       return "CHRONIC DISEASE-RELATED (1 POINT)";
//     }
//
//     // print('return INFLAMMATION here $output');
//     // return output;
//
//   }

  Widget _widgetSeverity() {
    return Column(
      children: [
        Container(
          width: Get.width,
          // height: 200,
          child: InkWell(
            onTap: () {
              if (nextToSeverity && accessSeverity) {
                Get.to(SeverityScreen(
                  phenotypicData: _controller.severity,
                  severityData2: _controller.severity2,
                  severityData3: _controller.severity3,
                  etiologicData: _controller.etiologic,
                  severityData: _controller.phenotypicData,
                  title: 'severity_criteria'.tr.toUpperCase(),
                  patientDetailsData:
                      _patientSlipController.patientDetailsData[0],
                )).then((value) {
                  if (value != null) {
                    // getPatientsAndPheno();
                    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet) {
                      print('internet');
                      if (internet != null && internet) {
                        getPatientsAndPheno();

                        print('internet avialable');
                      }else{
                        //copy online func
                        // getPatientsAndPheno();
                        print('scope here ------------------');
                        getPatientsAndPhenOffline();
                      }
                    });
                  }
                });
              }
            },
            child: Card(
              color: nextToSeverity && accessSeverity ? card_color : Colors.black26,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(width: 1, color: primary_color)),
              child: FutureBuilder(
                  future:
                      GETSEVERITY(_patientSlipController.patientDetailsData[0]),
                  initialData: "Loading text..",
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print('project snapshot data is: ${snapshot.data}');
                    if (snapshot.data == null || !(nextToSeverity && accessSeverity)) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary_color,
                                    // border: Border.all(
                                    //   color: Colors.red[340],
                                    // ),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 16.0),
                                      child: Text(
                                        'severity_criteria'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    // clicktoResult(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    nextToSeverity && accessSeverity ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('missing_info'.tr),
                                              Text('click_to_answer'.tr)
                                            ],
                                          )
                                        : Text(
                                            'please_answer_phenotypic_etiologic_first'.tr),
                                    // Text('Click to Answer')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    Severity project = snapshot.data;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: primary_color,
                                  // border: Border.all(
                                  //   color: Colors.red[340],
                                  // ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0))),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, bottom: 8.0, left: 16.0),
                                    child: Text(
                                      'severity_criteria'.tr,
                                      style: TextStyle(
                                        color: card_color,
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                  // clicktoResult(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...project.severityData.map((e) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${
                                              e.question.toUpperCase().contains("% MAMC".toUpperCase())
                                                  || e.title.contains("REDUCED MUSCLE MASS")
                                                  //adding this line for BR version
                                                  || e.title.contains("REDUÇÃO MASSA MUSCULAR")

                                                  ? "reduced_muscle_mass".tr : e.title} :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                       Row(children: [
                                         FutureBuilder(
                                             future: GETOPTION(e.options),
                                             initialData: "Loading text..",
                                             builder: (BuildContext context,
                                                 AsyncSnapshot<String> value) {
                                               // return Text("${value.data}");
                                               return autoSizableText(
                                                   value.data,
                                                   'severity'.tr,
                                                   value.data,
                                                   context);
                                             })
                                       ],),
                                        SizedBox(height: 5,)
                                      ],
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 10, bottom: 8),
                              child: Text(
                                "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(project.lastUpdate))}",
                                style: TextStyle(
                                    color: primary_color, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }

  Widget missingInfo(String text) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: primary_color,
                  // border: Border.all(
                  //   color: Colors.red[340],
                  // ),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0),
                    child: Text(
                      '$text',
                      style: TextStyle(
                        color: card_color,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  // clicktoResult(),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('missing_info'.tr),
                  Text('click_to_answer'.tr)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
