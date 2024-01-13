import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/glimFunc.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/GLIMController.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class PhenotypicScreen2 extends StatefulWidget {
  final List<GLIMData> phenotypicData;
  final List<GLIMData> selectedList;
  final PatientDetailsData patientDetailsData;
  final String title;
  final String patientType;
  final bool condition;
  PhenotypicScreen2(
      {this.phenotypicData,
      this.selectedList,
      this.title,
      this.patientDetailsData,
      this.patientType,
      this.condition});

  @override
  _PhenotypicScreen2State createState() => _PhenotypicScreen2State();
}

class _PhenotypicScreen2State extends State<PhenotypicScreen2> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final GlimController _glimController = GlimController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    getBMI();
    getMAMC();
    selectedItem();
    super.initState();
  }

  List SelectedId = [];

  // getselectedData() {
  //   for (var i = 0; i < widget.selectedLastTime.length; i++) {
  //     for (var b = 0; b < widget.selectedLastTime[i].options.length; b++) {
  //       if (widget.selectedLastTime[i].options[b].isSelected) {
  //         SelectedId.add(widget.selectedLastTime[i].options[b].sId);
  //       }
  //     }
  //   }
  // }

  String BMI = '';
  getBMI() {
    // print(widget.patientDetailsData.anthropometry[0].bmi);

    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      setState(() {
        BMI = widget.patientDetailsData.anthropometry[0].bmi ?? '';
        print('BMI: $BMI');
      });
    }
  }

  String MAMC = '';
  String MAMCValue = '0';
  double MAMCPer = 0.0;
  getMAMC() {
    // print('mamc: ${widget.patientDetailsData.anthropometry[0].mamc}');

    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      setState(() {
        MAMC = widget.patientDetailsData.anthropometry[0].mamcper ?? "0";
        MAMCValue =
            widget.patientDetailsData.anthropometry[0].mamc.isNullOrBlank
                ? "0"
                : widget.patientDetailsData.anthropometry[0].mamc;
        print('MAMC: $MAMC');
        MAMC = MAMC.isEmpty ? '0' : MAMC;
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

  String patientType = '';
  bool condition = false;

  getBmiStatus(String val) {
    getAgeYearsFromDate(widget.patientDetailsData.dob).then((AGE) {
      // //  NO ASIAN: BMI <20 IF <70 YEARS, OR <22 IF ≥70 YEARS
      //       // IF ASIAN: <18.5 IF <70 YEARS, OR <20 IF ≥70 YEARS

      if (val.toLowerCase() == 'yes'.tr.toLowerCase()) {
        print('patient asian');

        setState(() {
          patientType = 'asian';
        });

        if ((double.parse(BMI) < 18.5 && AGE < 70) ||
            (double.parse(BMI) < 20 && AGE >= 70)) {
          print('condition true');
          print('Low BMI');
          setState(() {
            condition = true;
          });
        } else {
          print('condition false');
          setState(() {
            condition = false;
          });
        }
      } else {
        print('patient not asian');
        setState(() {
          patientType = 'non-asian';
        });
        if ((double.parse(BMI) < 20 && AGE < 70) ||
            (double.parse(BMI) < 22 && AGE >= 70)) {
          print('condition true');
          print('Low BMI');
          setState(() {
            condition = true;
          });
        } else {
          print('condition false');
          setState(() {
            condition = false;
          });
        }
      }
    });

    print('patient Type : $patientType');
    print('condition : $condition');
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
  
  
  
  selectedItem(){
    GETPHENOTYPIC(widget.patientDetailsData).then((res){
      
      if(res!=null){
        
        for(var a in res.phenotypicData){
          
          // if(a.question.contains('% MAMC')){
          if(a.sId == AppString.mamc_glim){


            for(var b in a.options){

              if(b.isSelected){


                for(var x in widget.phenotypicData){

                  // if(x.question.contains('% MAMC')){
                  if(a.sId == AppString.mamc_glim){

                    for(var y in x.options){

                      if(y.optionname.contains(b.optionname)){

                        print('yahhooo');

                        setState(() {
                          y.isSelected = true;
                          x.selectedTitle = true;
                        });

                      }else{
                        setState(() {
                          y.isSelected = false;
                        });
                      }

                    }

                    break;
                  }

                }



                break;
              }

            }


            break;
          }
          
        }
        
      }
      
    });
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
                      Get.to(ReferenceScreen(
                        Ref_list: ref_Controller.phenotypic_ref_list,
                      ));
                    },
                  )),
              body: Container(
                height: Get.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 20, left: 20, top: 10),
                        child: Column(
                          children: [
                            Text(
                              "${widget.phenotypicData.first.title}",
                              style:
                                  TextStyle(fontSize: 16, fontWeight: FontBold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "${'patient_info'.tr} - ${'mamc'.tr} : ${MAMCValue == '0' ? 'tst_muac_missing_on_anthropometry'.tr : MAMC}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ],
                        )),
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
                                onPressed: () async {
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

                                  print('get privious selected: ${widget.selectedList}');

                                 await this.ISBMILOW(BMI.isNullOrBlank ? '0' : BMI);
                                await  onSaved();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Text("${e.question}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
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
                            setState(() {
                              for (var c = 0; c < e.options.length; c++) {
                                if (e.options[c].sId != e.options[index].sId) {
                                  e.options[c].isSelected = false;
                                  e.selectedTitle = false;
                                }
                              }
                              e.options[index].isSelected =
                                  !e.options[index].isSelected;
                              e.selectedTitle = e.options[index].isSelected;
                            });

                            //Asian or not func here
                            if (e.question
                                .toLowerCase()
                                .trim()
                                .contains('is the patient asian'.trim())) {
                              print('aisan or not func');
                              // e.options[index].optionname.
                              if (BMI.isNotEmpty && e.selectedTitle) {
                                getBmiStatus(
                                    e.options[index].optionname.toString());
                              } else {
                                print(
                                    'BMI is not available or not selected anyone');
                                print(
                                    'patient type: ${e.options[index].optionname.toString()}');
                                setState(() {
                                  patientType = '';
                                });
                              }
                            }
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
      ],
    );
  }

  ISBMILOW(String val) async {
    await getAgeYearsFromDate(widget.patientDetailsData.dob).then((AGE) {
      // //  NO ASIAN: BMI <20 IF <70 YEARS, OR <22 IF ≥70 YEARS
      //       // IF ASIAN: <18.5 IF <70 YEARS, OR <20 IF ≥70 YEARS

      print("BMI here akash: $val");

      if (double.parse(val) != 0) {


        print('patient_type: ${widget.patientType}');
        if ((double.parse(val) < 18.5 && AGE < 70) || (double.parse(val) < 20 && AGE >= 70)) {
          print('condition true');
          print('Low BMI');
          setState(() {
            condition = true;
          });



        } else if ((double.parse(val) < 20 && AGE < 70) || (double.parse(val) < 22 && AGE >= 70)) {
          print('condition true');
          print('Low BMI');
          setState(() {
            condition = true;
          });


        } else {
          print('condition false');
          setState(() {
            condition = false;
          });
        }


      } else {
        setState(() {
          condition = null;
        });
      }
    });


    print('condition : $condition');
  }

  onSaved() {
    List<GLIMData> selectedList = [];
    List reducedMassMuscle = [];

    String weightlossStatus = '';

    for (var g in widget.selectedList) {

      // if (g.title.contains('WEIGHT LOSS')) {
      //assign title val to createdAt key for both lang

      if (g.createdAt.contains('WEIGHT LOSS')) {
        for (var u in g.options) {
          if (u.isSelected) {
            print('weight loss : ${u.optionname}');
            weightlossStatus = u.optionname;
          }
        }

        break;
      }
    }

    selectedList.addAll(widget.selectedList);

    for (var a = 0; a < widget.phenotypicData.length; a++) {
      if (widget.phenotypicData[a].selectedTitle) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(widget.phenotypicData[a]);

        for (var b in widget.phenotypicData[a].options) {
          if (b.isSelected) {
            reducedMassMuscle.add(b);
          }
        }

        print('last page pheno ques: ${widget.phenotypicData[a].question}');
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    Map data = {
      'lastUpdate': '${DateTime.now()}',
      'phenoStatus': selectedList.isEmpty ? 'Negative' : 'Positive',
      'SelectedStatus': selectedList.isEmpty ? '0' : '1',
      'patientType': widget.patientType,
      'condition': widget.condition,
      'reducedMassMuscle': reducedMassMuscle,
      'weightlossStatus': weightlossStatus,
      'phenotypicData': selectedList,
    };

    print('final data json: ${jsonEncode(data)}');
    // if (selectedList.isNotEmpty) {
      Etiologic etiologic;
      Severity severity;
      for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
        if (widget.patientDetailsData.status[a].type ==
                statusType.nutritionalDiagnosis &&
            widget.patientDetailsData.status[a].status.trim() ==
                nutritionalDiagnosis.glim.trim()) {
          Result result = widget.patientDetailsData.status[a].result[0];
          print('etiologic data: ${jsonEncode(result.etiologic)}');
          etiologic = result.etiologic;
          severity = result.severity;

          break;
        }
      }
      Phenotypic phenotypic;


      checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){

        if(internet!=null && internet){

          _glimController
              .saveDataPheno2(widget.patientDetailsData, data, '0', etiologic,
                  phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });

        }else{
          _glimController
              .saveDataOffline(widget.patientDetailsData, data, '0', etiologic,
              phenotypic, severity)
              .then((value) {
            print('return from save: $value');
            Get.back(result: '1');
          });
        }

      });


    //commented for 24 Aug

    // } else {
    //
    // }
  }







}
