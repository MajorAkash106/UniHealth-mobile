import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/glimFunc.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/GLIMController.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../config/cons/string_keys.dart';


class SeverityScreen3 extends StatefulWidget {
  final List<GLIMData> phenotypicData;
  final List<GLIMData> etiologicData;
  final List<GLIMData> severityData;
  final List<GLIMData> selectedData;
  final PatientDetailsData patientDetailsData;
  final String title;
  SeverityScreen3(
      {this.phenotypicData,
      this.etiologicData,
      this.selectedData,
      this.severityData,
      this.title,
      this.patientDetailsData});

  @override
  _SeverityScreen3State createState() => _SeverityScreen3State();
}

class _SeverityScreen3State extends State<SeverityScreen3> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final GlimController _glimController = GlimController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    // getBMI();
    getMAMC();
    getSelectedData();
    ReducedSelected();
    selectedMAMC();
    super.initState();
  }



  selectedMAMC(){
    GETSEVERITY(widget.patientDetailsData).then((res){

      if(res!=null && res.severityData !=null){

        for(var a in res.severityData){

          if(a.question.toUpperCase().contains("% MAMC".toUpperCase()) ||
              // a.title.contains("REDUCED MUSCLE MASS")){
              a.createdAt.contains("REDUCED MUSCLE MASS")){


            GETOPTION(a.options).then((resp){

              print('resp mamac selcted previously : $resp');

              // if(resp.contains('70-90% (MILD TO MODERATE)')){

                for (var c in widget.phenotypicData){
                  print('resp mamac selcted previously2 : $resp');
                  print('ques: ${c.title}  ${c.question}');

                  if(c.question.toUpperCase().contains("% MAMC".toUpperCase())){
                  //   print('resp mamac selcted previously3 : $resp');
                    for(var d in c.options){

                      print('options--${d.optionname}');

                      if (d.optionname.contains(resp)){

                        setState(() {
                          d.isSelected =true;
                          c.selectedTitle = true;
                        });

                      }



                    }
                    break;
                  }



                }



              // }



            });


            break;
          }

        }

      }

    });
  }

  String weightlossText ='';
// phenotypic data in severity
  void getSelectedData() {
    // for(var a=0; a<widget.patientDetailsData.s)

    for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
      if (widget.patientDetailsData.status[a].type == statusType.nutritionalDiagnosis && widget.patientDetailsData.status[a].status.trim() == nutritionalDiagnosis.glim.trim()) {
        Result result = widget.patientDetailsData.status[a].result[0];
        if (result.phenotypic != null && result.phenotypic != '') {
          print('phenotypic data: ${jsonEncode(result.phenotypic.phenotypicData)}');

          List<EtiologicData> phenotypicc = result.phenotypic.phenotypicData;

          for (var b = 0; b < phenotypicc.length; b++) {
            if (phenotypicc[b].selectedTitle) {
              // if (phenotypicc[b].title.toLowerCase().trim().contains('weight loss'.toLowerCase().trim())
              if (phenotypicc[b].createdAt.toLowerCase().trim().contains('weight loss'.toLowerCase().trim())
                  && phenotypicc[b].selectedTitle) {
                print('yess weight loss exists in pheno');
                // List<Options> optionss =[];
                // options.addAll(phenotypicc[b].options);
                print(phenotypicc[b].options.length);

                //
                for (var c = 0; c < phenotypicc[b].options.length; c++) {
                  if (phenotypicc[b].options[c].isSelected) {
                    print(phenotypicc[b].options[c].optionname);

                    String weightText = phenotypicc[b].options[c].optionname;

                    for (var s = 0; s < widget.phenotypicData.length; s++) {
                      // if (widget.phenotypicData[s].title.toLowerCase().trim().contains('weight loss'.toLowerCase().trim())) {
                      if (widget.phenotypicData[s].createdAt.toLowerCase().trim().contains('weight loss'.toLowerCase().trim())) {
                        print('yess severity exist with loss');
                        for (var t = 0; t < widget.phenotypicData[s].options.length; t++) {
                          print(widget.phenotypicData[s].options[t].optionname.toUpperCase().removeAllWhitespace);
                          print('selected weight in pheno $weightText');
                          print(
                              'selected weight in pheno ${weightText.toUpperCase().removeAllWhitespace}');

                          if (widget.phenotypicData[s].options[t].optionname.toUpperCase().removeAllWhitespace.contains(weightText.toUpperCase().removeAllWhitespace)) {
                            print('please true');
                            setState(() {
                              // widget.phenotypicData[s].options[t].isSelected = true;
                              // widget.phenotypicData[s].selectedTitle = true;


                              weightlossText = "${widget.phenotypicData[s].question} : ${widget.phenotypicData[s].options[t].optionname}";
                              print('yeee: $weightlossText');

                            });

                            break;
                          }
                        }

                        // break;
                      }
                    }

                    break;
                  }
                }

                break;
              }
            }
          }

          //------------------------------------------------------------------

          for (var b = 0; b < phenotypicc.length; b++) {
            if (phenotypicc[b].selectedTitle) {
              if (phenotypicc[b]
                      .question
                      .toLowerCase()
                      .trim()
                      .contains('% MAMC'.toLowerCase().trim()) &&
                  phenotypicc[b].selectedTitle) {
                print('yess MAMC exists in pheno');
                // List<Options> optionss =[];
                // options.addAll(phenotypicc[b].options);
                print(phenotypicc[b].options.length);

                //
                for (var c = 0; c < phenotypicc[b].options.length; c++) {
                  if (phenotypicc[b].options[c].isSelected) {
                    print(phenotypicc[b].options[c].optionname);

                    String mamcText = phenotypicc[b].options[c].optionname;

                    for (var s = 0; s < widget.phenotypicData.length; s++) {
                      if (widget.phenotypicData[s].question
                          .toLowerCase()
                          .trim()
                          .contains('%MAMC'.toLowerCase().trim())) {
                        print('yess mamc exist with loss');
                        for (var t = 0;
                            t < widget.phenotypicData[s].options.length;
                            t++) {
                          // print(widget.phenotypicData[s].options[t].optionname.toUpperCase().removeAllWhitespace);
                          // print('selected weight in pheno $weightText');
                          // print('selected weight in pheno ${weightText.toUpperCase().removeAllWhitespace}');

                          if (widget.phenotypicData[s].options[t].optionname.toUpperCase().removeAllWhitespace.contains(mamcText.toUpperCase().removeAllWhitespace)) {
                            print('please true');
                            setState(() {
                              // widget.phenotypicData[s].options[t].isSelected = true;
                              // widget.phenotypicData[s].selectedTitle = true;
                            });

                            break;
                          }
                        }

                        // break;
                      }
                    }

                    break;
                  }
                }

                break;
              }
            }
          }

          //--------------------------------------------------

          //-------------------------------------------------------------------

          String patientType = result.phenotypic.patientType;
          bool condition = result.phenotypic.condition;
          if (patientType != '' && condition != null) {
            BMISelected(patientType, condition);
          }
        }

        break;
      }
    }
  }

  void BMISelected(String patientType, bool condition) {
    print('patient type: $patientType');
    print('condition: $condition');

    if (condition) {
      for (var a = 0; a < widget.phenotypicData.length; a++) {
        // if (widget.phenotypicData[a].title.toLowerCase().removeAllWhitespace.contains('low body mass index'.toLowerCase().removeAllWhitespace)) {
        if (widget.phenotypicData[a].sId == AppString.low_body_mass_index_glim) {
          print('yes enter in BMI low body mass');

          if (patientType == 'asian' &&
              // widget.phenotypicData[a].question.toLowerCase().removeAllWhitespace.contains('moderate malnutrition'.toLowerCase().removeAllWhitespace)) {
              widget.phenotypicData[a].sId == AppString.moderate_malnutrition_glim) {
            print('moderate malnutrition check');
            setState(() {
              widget.phenotypicData[a].selectedTitle = true;
              widget.phenotypicData[a].options[0].isSelected = true;
            });
          } else if (patientType != 'asian' &&
              // widget.phenotypicData[a].question.toLowerCase().removeAllWhitespace.contains('severe malnutrition'.toLowerCase().removeAllWhitespace)) {
              widget.phenotypicData[a].sId == AppString.severe_malnutrition_glim) {
            print('severe malnutrition check');
            setState(() {
              widget.phenotypicData[a].selectedTitle = true;
              widget.phenotypicData[a].options[0].isSelected = true;
            });
          }

          // break;
        }
      }
    }
  }



  String MAMC = '';
  String MAMCValue = '0';
  double MAMCPer = 0.0;
  getMAMC() {
    // print('mamc: ${widget.patientDetailsData.anthropometry[0].mamc}');

    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      setState(() {
        MAMC =widget.patientDetailsData.anthropometry[0].mamcper??"0" ;
        MAMCValue =widget.patientDetailsData.anthropometry[0].mamc.isNullOrBlank?"0": widget.patientDetailsData.anthropometry[0].mamc;
        print('MAMC: $MAMC');
        MAMC = MAMC.isEmpty?'0':MAMC;
        MAMCPer = double.parse(MAMC);
        print('MAMC per: $MAMCPer');
        print('MAMC val: $MAMCValue');
      });

      // for(var a =0; a<widget.phenotypicData.length; a++){
      //
      //   if(widget.phenotypicData[a].question.toLowerCase().contains('MAMC'.toLowerCase())){
      //
      //     print('mamc %');
      //
      //
      //     if(MAMCPer > 0 && MAMCPer <70){
      //       setState(() {
      //         widget.phenotypicData[a].options[1].isSelected = true;
      //         widget.phenotypicData[a].selectedTitle = true;
      //       });
      //     }else if(MAMCPer >=70 && MAMCPer <=90 ){
      //       setState(() {
      //         widget.phenotypicData[a].options[0].isSelected = true;
      //         widget.phenotypicData[a].selectedTitle = true;
      //       });
      //
      //     }else{
      //
      //
      //
      //     }
      //
      //
      //     break;
      //   }
      //
      // }

    }
  }

  ReducedSelected() {
    for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
      if (widget.patientDetailsData.status[a].type ==
              statusType.nutritionalDiagnosis &&
          widget.patientDetailsData.status[a].status.trim() ==
              nutritionalDiagnosis.glim.trim()) {
        Result result = widget.patientDetailsData.status[a].result[0];
        if (result.severity != null && result.severity != '') {
          print('severity data: ${jsonEncode(result.severity.severityData)}');

          List<EtiologicData> severirtyy = result.severity.severityData;

          for (var b = 0; b < severirtyy.length; b++) {
            if (severirtyy[b].selectedTitle &&
                severirtyy[b]
                    // .title
                    .createdAt
                    .toUpperCase()
                    .trim()
                    .contains('reduced muscle mass'.toUpperCase().trim())
                &&
                severirtyy[b].question == '') {
              // SelectedIdPheno.add(phenotypicc[b].sId);

              for (var c = 0; c < severirtyy[b].options.length; c++) {
                if (severirtyy[b].options[c].isSelected) {
                  print(
                      'seelcted reduce muscle mass :${severirtyy[b].options[c].sId}');
                  // SelectedIdPheno.add(phenotypicc[b].options[c].sId);

                  String sID = severirtyy[b].options[c].sId;

                  for (var c = 0; c < widget.phenotypicData.length; c++) {
                    for (var d = 0; d < widget.phenotypicData[c].options.length;
                        d++) {

                      if(widget.phenotypicData[c].selectedTitle ==false) {
                        if (widget.phenotypicData[c].options[d].sId == sID) {
                          setState(() {
                            widget.phenotypicData[c].options[d].isSelected =
                            true;
                            widget.phenotypicData[c].selectedTitle = true;
                          });
                        }
                      }

                    }
                  }

                  break;
                }
              }

              // break;
            }
          }
        }

        break;
      }
    }
  }

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;

  Future<bool> _willpopScope() {
    print('back press');
    // print(widget.phenotypicData.length);
    // if (_pageController.hasClients) {
    //   if (currentIndex != 0) {
    //     _pageController.animateToPage(
    //       currentIndex - 1,
    //       duration: const Duration(milliseconds: 400),
    //       curve: Curves.easeInOut,
    //     );
    //   } else {
    //     print('complete');
    //     Get.back();
    //   }
    // }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
          onWillPop: _willpopScope,
          child: Scaffold(
              appBar: BaseAppbar(
                  "${widget.title}",
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: card_color,
                    ),
                    onPressed: () {
                      Get.to(ReferenceScreen(Ref_list: ref_Controller.phenotypic_ref_list,));
                    },
                  )),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
                    child:Column(children: [
                      Text(
                        "${widget.phenotypicData.first.title}",
                        style: TextStyle(fontSize: 16, fontWeight: FontBold),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        // "${'patient_info'} - MAMC % : ${MAMCValue =='0'?'TST and MUAC are missing on anthropometry':MAMC}",
                        "${'patient_info'.tr} - ${'mamc'.tr} : ${MAMCValue == '0' ? 'tst_muac_missing_on_anthropometry'.tr : MAMC}",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                      ),
                    ],)
                  ),
                  ...widget.phenotypicData
                      .map((e) => _checkboxWidget(e))
                      .toList(),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25.0, right: 25.0, bottom: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50.0,
                            width: MediaQuery.of(context).size.width,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: primary_color,
                              child: Center(
                                child: Text(
                                  currentIndex !=
                                          widget.phenotypicData.length - 1
                                      ? "save".tr
                                      : "save".tr,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                print(widget.phenotypicData.length);
                                // if (_pageController.hasClients) {
                                //   if (currentIndex != widget.phenotypicData.length - 1) {
                                //     _pageController.animateToPage(
                                //       currentIndex + 1,
                                //       duration: const Duration(milliseconds: 400),
                                //       curve: Curves.easeInOut,
                                //     );
                                //
                                //     // if (e.selectedTitle == true) {
                                //     //   _pageController.animateToPage(
                                //     //     currentIndex + 1,
                                //     //     duration: const Duration(milliseconds: 400),
                                //     //     curve: Curves.easeInOut,
                                //     //   );
                                //     // } else {
                                //     //   ShowMsg('Please choose atleast one option');
                                //     // }
                                //   } else {
                                //     print('complete');
                                //
                                //     // Get.back();
                                //
                                //     // if (e.selectedTitle == true) {
                                //     //   print('complete');
                                //     onSaved();
                                //     // } else {
                                //     //   ShowMsg('Please choose atleast one option');
                                //     // }
                                //   }
                                // }

                                onSaved();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ));
  }

  Widget _checkboxWidget(GLIMData e) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
        SizedBox(
          height: 10,
        ),
        e.question.isEmpty
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
                child: Text(
                  "${e.question}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: e.options.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 20.0),
                child: Row(
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
                                            color: e.options[index].isSelected
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: e.options[index].isSelected
                                        ? Icon(Icons.check,
                                            size: 20.0, color: Colors.green)
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
                            // if ((e.title
                            //         .toLowerCase()
                            //         .removeAllWhitespace
                            //         .contains('reduced muscle mass'
                            //             .toLowerCase()
                            //             .removeAllWhitespace)) &&
                            //     e.question == '') {
                           if(!e.options[index].isSelected) {
                              setState(() {
                                for (var a in widget.phenotypicData) {
                                  a.selectedTitle = false;

                                  for (var b in a.options) {
                                    b.isSelected = false;
                                  }
                                }

                                for (var c = 0; c < e.options.length; c++) {
                                  if (e.options[c].sId !=
                                      e.options[index].sId) {
                                    e.options[c].isSelected = false;
                                    e.selectedTitle = false;
                                  }
                                }
                                e.options[index].isSelected =
                                    !e.options[index].isSelected;
                                e.selectedTitle = e.options[index].isSelected;
                              });

                              print(e.options[index].optionname);
                              // if (e.options[index].optionname
                              if (e.options[index].createdAt
                                      .contains('< 70% (SEVERE)') ||
                                  // e.options[index].optionname.contains('SEVERE DEFICIT ASSESSED BY DXA, BIA, CT OR MRI')) {
                                  e.options[index].sId == AppString.severe_deficit_assessed_glim) {
                                setState(() {
                                  stageType = 'SEVERE';
                                });
                              } else {
                                setState(() {
                                  stageType = 'MODERATE';
                                });
                              }
                            }else{
                             setState(() {
                               e.options[index].isSelected =
                               !e.options[index].isSelected;
                               e.selectedTitle = e.options[index].isSelected;
                             });
                           }
                            // }
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
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                e.options[index].optionname,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),

        // Spacer(),
        // SizedBox(height: 30.0,),

        // SizedBox(height: 30.0,),
      ],
    );
  }
  String stageType = 'MODERATE';
  onSaved() {
    List<GLIMData> selectedList = [];


    for(var r in widget.selectedData){
      // if(r.title.contains('WEIGHT LOSS (%)')
      if(r.createdAt.contains('WEIGHT LOSS (%)')
          // && r.question.contains('STAGE 2 / SEVERE MALNUTRITION')){
          && r.sId == AppString.severe_malnutrition_glim){

        setState(() {
          stageType = 'SEVERE';
        });


      }

      // if(r.title.contains('LOW BODY MASS INDEX - BMI (kg/m2)') && r.question.contains('STAGE 2 / SEVERE MALNUTRITION')){
      if(r.sId == AppString.severe_malnutrition_glim){

        setState(() {
          stageType = 'SEVERE';
        });


      }
    }

    selectedList.addAll(widget.selectedData);

    for (var a = 0; a < widget.phenotypicData.length; a++) {
      if (widget.phenotypicData[a].selectedTitle) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(widget.phenotypicData[a]);
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');
    print('stageType: ${stageType}');

    Map data = {
      'lastUpdate': '${DateTime.now()}',
      'severityStatus': selectedList.isEmpty ? 'Negative' : 'Positive',
      'SelectedStatus': selectedList.isEmpty ? '0' : '1',
      'severityData': selectedList,
      'stageType': stageType,
    };

    print('data json: ${jsonEncode(data)}');
    if (selectedList.isNotEmpty) {
      Etiologic etiologic;
      Phenotypic phenotypic;

      for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
        if (widget.patientDetailsData.status[a].type ==
                statusType.nutritionalDiagnosis &&
            widget.patientDetailsData.status[a].status.trim() ==
                nutritionalDiagnosis.glim.trim()) {
          Result result = widget.patientDetailsData.status[a].result[0];
          print('etiologic data: ${jsonEncode(result.etiologic)}');
          print('phenotypic data: ${jsonEncode(result.phenotypic)}');
          etiologic = result.etiologic;
          phenotypic = result.phenotypic;

          break;
        }
      }

      Severity severity;


      checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
        if(internet!=null && internet){
          _glimController.saveDataPheno2(widget.patientDetailsData, data, '2', etiologic,
              phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });
        }else{
          _glimController.saveDataOffline(widget.patientDetailsData, data, '2', etiologic,
              phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });
        }
      });





    } else {
      // Get.back();

      Etiologic etiologic;
      Phenotypic phenotypic;

      for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
        if (widget.patientDetailsData.status[a].type ==
            statusType.nutritionalDiagnosis &&
            widget.patientDetailsData.status[a].status.trim() ==
                nutritionalDiagnosis.glim.trim()) {
          Result result = widget.patientDetailsData.status[a].result[0];
          print('etiologic data: ${jsonEncode(result.etiologic)}');
          print('phenotypic data: ${jsonEncode(result.phenotypic)}');
          etiologic = result.etiologic;
          phenotypic = result.phenotypic;

          break;
        }
      }

      Severity severity;


      checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
        if(internet!=null && internet){
          _glimController.saveDataPheno2(widget.patientDetailsData, null, '2', etiologic,
              phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });
        }else{
          _glimController.saveDataOffline(widget.patientDetailsData, null, '2', etiologic,
              phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });
        }
      });



    }


  }
}
