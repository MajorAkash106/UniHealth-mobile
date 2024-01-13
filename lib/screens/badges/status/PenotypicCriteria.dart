import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/GLIMController.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/PhenotypicCriteria2.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class PhenotypicScreen extends StatefulWidget {
  final List<GLIMData> phenotypicData;
  final List<GLIMData> phenotypicData2;
  final PatientDetailsData patientDetailsData;
  final String title;
  PhenotypicScreen(
      {this.phenotypicData,
      this.phenotypicData2,
      this.title,
      this.patientDetailsData});

  @override
  _PhenotypicScreenState createState() => _PhenotypicScreenState();
}

class _PhenotypicScreenState extends State<PhenotypicScreen> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final GlimController _glimController = GlimController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    getBMI();
    getMAMC();
    getData();
    super.initState();
    checkedWeight();
    checkedLowBodyMass();
  }

  List SelectedId = [];




  checkedWeight() {
    for (var a in widget.patientDetailsData.status) {
      if (a.type == statusType.nutritionalDiagnosis && a.status == nutritionalDiagnosis.glim) {
        Phenotypic phenotypic = a.result[0].phenotypic;

        phenotypic.weightlossStatus;

     if(!phenotypic.weightlossStatus.isNullOrBlank){
       for(var b in  widget.phenotypicData){
         // if(b.title.contains('WEIGHT LOSS (%)')){
         if(b.sId == AppString.weight_loss_glim){

           for(var c in b.options){

             setState(() {

               if(c.optionname.contains(phenotypic.weightlossStatus)){


                 print('helo----------------');
                 setState(() {
                   c.isSelected = true;
                   b.selectedTitle = true;
                 });


               }

             });

           }

           break;
         }

       }
     }else{
       print('empty all----------------');
       for(var b in  widget.phenotypicData){
         // if(b.title.contains('WEIGHT LOSS (%)')){
         if(b.sId == AppString.weight_loss_glim){

           for(var c in b.options){

             print('helo----------------');
             setState(() {
               c.isSelected = false;
               b.selectedTitle = false;
             });


           }

           break;
         }

       }


     }

        break;
      }
    }
  }


  checkedLowBodyMass() {
    for (var a in widget.patientDetailsData.status) {
      if (a.type == statusType.nutritionalDiagnosis && a.status == nutritionalDiagnosis.glim) {
        Phenotypic phenotypic = a.result[0].phenotypic;

        print('selectedd data: ${phenotypic.patientType}');
        print('selectedd data: ${phenotypic.condition}');


        setState(() {
          patientType = phenotypic.patientType;
          condition = phenotypic.condition;
        });

        print('checking patient type');

       if(!patientType.isNullOrBlank) {
          for (var b in widget.phenotypicData) {
            // if (b.title.contains('LOW BODY MASS INDEX - BMI (kg/m2)')) {
            if (b.sId == AppString.low_body_mass_index_glim) {
              for (var c in b.options) {
                if (patientType == 'aisan') {
                  setState(() {
                    // if (c.optionname.contains('Yes')) {
                    if (c.optionname.toLowerCase().contains('Yes'.toLowerCase().toString().tr)) {
                      print('helo----------------');
                      setState(() {
                        c.isSelected = true;
                        b.selectedTitle = true;
                      });
                    }
                  });
                }

                if (patientType == 'non-aisan') {
                  setState(() {
                    if (c.optionname.toLowerCase().contains('No'.toLowerCase().toString().tr)) {
                      print('helo----------------');
                      setState(() {
                        c.isSelected = true;
                        b.selectedTitle = true;
                      });
                    }
                  });
                }
              }

              break;
            }
          }
        }

        break;
      }
    }
  }


  String BMI = '0';
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
  double MAMCPer = 0.0;
  getMAMC() {
    // print(widget.patientDetailsData.anthropometry[0].bmi);

    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      setState(() {
        MAMC = widget.patientDetailsData.anthropometry[0].weightType == '3'
            ? widget.patientDetailsData.anthropometry[0].mamcper ?? "0"
            : '0';
        print('MAMC: $MAMC');
        MAMC = MAMC.isEmpty ? '0' : MAMC;
        MAMCPer = double.parse(MAMC);
        print('MAMC per: $MAMCPer');
      });

      for (var a = 0; a < widget.phenotypicData.length; a++) {
        // if (widget.phenotypicData[a].question.toLowerCase().contains('MAMC'.toLowerCase())) {
        if (widget.phenotypicData[a].sId == AppString.mamc_glim) {
          print('mamc %');

          if (MAMCPer > 0 && MAMCPer < 70) {
            setState(() {
              widget.phenotypicData[a].options[1].isSelected = true;
              widget.phenotypicData[a].selectedTitle = true;
            });
          } else if (MAMCPer >= 70 && MAMCPer <= 90) {
            setState(() {
              widget.phenotypicData[a].options[0].isSelected = true;
              widget.phenotypicData[a].selectedTitle = true;
            });
          } else {}

          break;
        }
      }
    }
  }

  getData() {
    for (var x in widget.patientDetailsData.status) {
      if (x.type == '2' && x.status == nutritionalDiagnosis.glim) {
        print('yesss');
        Phenotypic phenotypic = x.result[0].phenotypic;

        if (!phenotypic.isNullOrBlank) {
          setState(() {
            patientType = phenotypic?.patientType;
          });
        }

        break;
      }
    }
  }

  String patientType = '';
  bool condition;

  getBmiStatus(String val) {


    getAgeYearsFromDate(widget.patientDetailsData.dob).then((AGE) {
      // //  NO ASIAN: BMI <20 IF <70 YEARS, OR <22 IF ≥70 YEARS
      //       // IF ASIAN: <18.5 IF <70 YEARS, OR <20 IF ≥70 YEARS

      if (val.toLowerCase() == 'yes'.tr) {
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
    print(widget.phenotypicData.length);
    if (_pageController.hasClients) {
      if (currentIndex != 0) {
        _pageController.animateToPage(
          currentIndex - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        print('complete');
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageView(
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            print(index);
            setState(() {
              currentIndex = index;
            });
          },
          children: widget.phenotypicData
              .map((e) => WillPopScope(
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
                        body: _checkboxWidget(e)),
                  ))
              .toList(),
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
          padding: const EdgeInsets.only(
              left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
          child: Text(
            "${e.title}",
            style: TextStyle(fontSize: 16, fontWeight: FontBold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        e.question.isEmpty
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${e.question}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.normal)),
                    // e.title.toLowerCase().removeAllWhitespace.contains('lowbodymassindex')
                    e.sId == AppString.low_body_mass_index_glim
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Text("criteria_for_low_bmi".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "no_asian_criteria".tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  "asian_criteria".tr,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal)),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: e.options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 20.0),
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
                                                  : Colors.black
                                                      .withAlpha(100)),
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

                              //Asian or not func here
                              // if (e.question.toLowerCase().trim().contains('is the patient asian'.trim())) {
                              // low_body_mass_index_glim OR is the patient asian has same sId
                              if (e.sId== AppString.low_body_mass_index_glim) {
                                print('aisan or not func');
                                // e.options[index].optionname.

                                print('selected---${e.selectedTitle}');

                                if (BMI.isNotEmpty && e.selectedTitle) {
                                  getBmiStatus(e.options[index].optionname.toString());
                                } else {
                                  print('BMI is not available or not selected anyone');
                                  print('BMI is not available or not selected dfssf: ${e.options[index].optionname.toString()}');


                                if(e.selectedTitle)  {

                                    if (e.options[index].optionname
                                            .toString()
                                            .toLowerCase() ==
                                        'yes'.tr.toString().toLowerCase()) {
                                      print('patient asian');

                                      setState(() {
                                        patientType = 'asian';
                                      });
                                    } else {
                                      setState(() {
                                        patientType = 'non-asian';
                                      });
                                    }

                                  }else{
                                  setState(() {
                                    patientType = '';
                                    condition = null;
                                  });
                                }

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
        ),

        // Spacer(),
        // SizedBox(height: 30.0,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30),
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
                        currentIndex != widget.phenotypicData.length - 1
                            ? "next".tr
                            : "next".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(widget.phenotypicData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != widget.phenotypicData.length - 1) {
                          _pageController.animateToPage(
                            currentIndex + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );

                          // if (e.selectedTitle == true) {
                          //   _pageController.animateToPage(
                          //     currentIndex + 1,
                          //     duration: const Duration(milliseconds: 400),
                          //     curve: Curves.easeInOut,
                          //   );
                          // } else {
                          //   ShowMsg('Please choose atleast one option');
                          // }
                        } else {
                          print('complete');

                          // Get.back();

                          // if (e.selectedTitle == true) {
                          //   print('complete');
                          onSaved();
                          // } else {
                          //   ShowMsg('Please choose atleast one option');
                          // }
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 30.0,),
      ],
    );
  }

  onSaved() {
    List<GLIMData> selectedList = [];

    for (var a = 0; a < widget.phenotypicData.length; a++) {
      if (widget.phenotypicData[a].selectedTitle) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(widget.phenotypicData[a]);
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    Map data = {
      'lastUpdate': '${DateTime.now()}',
      'phenoStatus': selectedList.isEmpty ? 'Negative' : 'Positive',
      'SelectedStatus': selectedList.isEmpty ? '0' : '1',
      'patientType': patientType,
      'condition': condition,
      'phenotypicData': selectedList,
    };

    print('data json: ${jsonEncode(data)}');


    Future.delayed(Duration(seconds: 1),(){
      Get.to(PhenotypicScreen2(
        phenotypicData: widget.phenotypicData2,
        selectedList: selectedList,
        patientType: patientType,
        condition: condition,
        // title: 'PHENOTYPIC CRITERIA',
        title: widget.title,
        patientDetailsData: widget.patientDetailsData,
      )).then((value) {
        if (value == '1') {
          Get.back(result: '1');
          // Get.back(result: '1');
        } else {
          // Get.back();
        }
      });
    });

  }
}
