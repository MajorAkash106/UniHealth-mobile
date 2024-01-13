import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/status_controller/NRSController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../json_config/const/json_paths.dart';

class MNAScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String id;
  final String title;
  final String HistoryKey;
  final List<NRSListData> selectedLastTime;

  MNAScreen(
      {this.patientDetailsData,
      this.id,
      this.title,
      this.selectedLastTime,
      this.HistoryKey});

  @override
  _MNAScreenState createState() => _MNAScreenState();
}

class _MNAScreenState extends State<MNAScreen> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();
  final MNAController _controller = MNAController();
  final HistoryController _historyController = HistoryController();

  var bodyMass;
  var circumference;

  @override
  void initState() {
    // TODO: implement initState
    getBMI();
    getselectedData();
    dataInitiateStatic();
    _controller.getData(widget.id).then((value) {
      for (var a = 0; a < _controller.allData.length; a++) {
        for (var b = 0; b < _controller.allData[a].options.length; b++) {
          if (SelectedId.contains(_controller.allData[a].options[b].sId)) {
            setState(() {
              _controller.allData[a].options[b].isSelected = true;
              _controller.allData[a].selectedQ = true;
            });
          }
        }
      }

      if (widget.title.contains('MNA')) {
        print('MNA here akash');
        setState(() {
          var lastInex = _controller.allData.last;
          _controller.allData.removeLast();
          _controller.allData.insert(0, lastInex);
        });

        for (var q = 0; q < _controller.allData.length; q++) {
          if (_controller.allData[q].statusId == AppString.bogyMassIndex) {
            print('Body Mass Index');
            setState(() {
              bodyMass = _controller.allData[q];

              _controller.allData.remove(_controller.allData[q]);
            });

            break;
          }
        }

        for (var q = 0; q < _controller.allData.length; q++) {
          if (_controller.allData[q].statusId == AppString.circumference) {
            print('circumference');
            setState(() {
              circumference = _controller.allData[q];

              _controller.allData.remove(_controller.allData[q]);
            });

            break;
          }
        }

        setState(() {
          _controller.allData.add(bodyMass);
          if (SelectedId.contains(AppString.bmiNotAvailable)) {
            _controller.allData.add(circumference);
          }
        });

        // if(BMI.isNotEmpty){
        //   print('BMI available');
        //   setState(() {
        //     _controller.allData.add(bodyMass);
        //   });
        // }else{
        //   print('BMI not available');
        //   setState(() {
        //     _controller.allData.add(circumference);
        //   });
        // }

      }
    });

    super.initState();
  }

  List SelectedId = [];

  getselectedData() {
    for (var i = 0; i < widget.selectedLastTime.length; i++) {
      for (var b = 0; b < widget.selectedLastTime[i].options.length; b++) {
        if (widget.selectedLastTime[i].options[b].isSelected) {
          SelectedId.add(widget.selectedLastTime[i].options[b].sId);
        }
      }
    }
  }

  String BMI = '';
  String anthroDate = '';

  getBMI() {
    // print(widget.patientDetailsData.anthropometry[0].bmi);

    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      setState(() {
        BMI = widget.patientDetailsData.anthropometry[0].bmi ?? '';
        anthroDate =
            widget.patientDetailsData.anthropometry[0].lastUpdate ?? '';
        print('BMI: $BMI');
      });
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
    print(_controller.allData.length);
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
          children: _controller.allData
              .map((e) => WillPopScope(
                    onWillPop: _willpopScope,
                    child: Scaffold(
                        appBar: BaseAppbar(
                            "${widget.title}",
                            widget.title == "MUST"
                                ? null
                                : IconButton(
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: card_color,
                                    ),
                                    onPressed: () {
                                      Get.to(ReferenceScreen(
                                          Ref_list: widget.title ==
                                                  "STRONG - KIDS"
                                              ? ref_Controller
                                                  .StrongKid_Ref_list
                                              : widget.title == "MNA - NNI"
                                                  ? ref_Controller.MNA_Ref_list
                                                  : []));
                                    },
                                  )),
                        body: e?.type == null
                            ? SizedBox()
                            : e.type == '0'
                                ? _radioWidget(e)
                                : _checkboxWidget(e)),
                  ))
              .toList(),
        ));
  }

  Widget _radioWidget(NRSListData e) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title == "MNA - NNI"
                      ? Center(child: NNILogo_CopyRightText())
                      : SizedBox(),
                  widget.title == "MNA - NNI"
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(),

                  widget.title == "MNA - NNI" ||
                          widget.title.removeAllWhitespace
                              .contains('STRONG-KIDS')
                      ? SizedBox()
                      : Center(
                          child: Text(
                            "${'step'.tr} ${_controller.allData.indexOf(e) + 1}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontBold,
                                color: primary_color),
                          ),
                        ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${e.statusquestion}",
                    style: TextStyle(fontSize: 16, fontWeight: FontBold),
                  ),

                  // !e.statusquestion.contains('risk for Malnutrition')
                  e.statusId != AppString.risk_for_Malnutrition
                      ? SizedBox()
                      : ExpansionTile(
                          title: Text(
                            'see_list'.tr,
                            style:
                                TextStyle(fontSize: 16, fontWeight: FontBold),
                          ),
                          children: [
                              Container(
                                height: Get.height / 2,
                                child: ListView(
                                  children: dataStatic.map((e) {
                                    // return Container(
                                    //     child: ListTile(
                                    //   leading: Icon(
                                    //     Icons.circle,
                                    //     size: 15,
                                    //   ),
                                    //   title: Text(
                                    //     e.text,
                                    //   ),
                                    // ));
                                    return Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        '${dataStatic.indexOf(e) + 1}.  ${e.text}',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            ]),

                  // e.statusquestion.contains('Is one of the following items present')
                  e.statusId == AppString.I_one_of_the_following_items_present
                      ? Column(
                          children: dataStatic2.map((e) {
                            return Container(
                                child: Row(
                              children: [
                                // Icon(Icons.box,size: 15,),
                                // SizedBox(width: 10,),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    '${dataStatic2.indexOf(e) + 1}.  ${e.text}',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ))
                              ],
                            ));
                          }).toList(),
                        )
                      : SizedBox(),

                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         new Radio(
                  //           value: 0,
                  //           groupValue: _isBMI,
                  //           onChanged: (int value) {
                  //             setState(() {
                  //               _isBMI = value;
                  //             });
                  //           },
                  //         ),
                  //         new Text(
                  //           'Yes',
                  //           style: new TextStyle(fontSize: 16.0),
                  //         ),
                  //       ],
                  //     ),
                  //
                  //     Row(
                  //       children: [
                  //         new Radio(
                  //           value: 1,
                  //           groupValue: _isBMI,
                  //           onChanged: (int value) {
                  //             setState(() {
                  //               _isBMI = value;
                  //             });
                  //           },
                  //         ),
                  //         new Text(
                  //           'No',
                  //           style: new TextStyle(fontSize: 16.0),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,/**/
                      children: e.options
                          .map(
                            (e2) => GestureDetector(
                              onTap: () {
                                print('pree');

                                setState(() {
                                  for (var b = 0; b < e.options.length; b++) {
                                    e.options[b].isSelected = false;
                                  }
                                  e2.isSelected = true;
                                  e.selectedQ = true;
                                });
                              },
                              child: Row(
                                children: [
                                  e2.isSelected
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          size: 20,
                                          color: primary_color,
                                        )
                                      : Icon(
                                          Icons.radio_button_off,
                                          size: 20,
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Text(
                                    '${e2.statusoption}',
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()),
                ],
              ),
            ),
            // SizedBox(height: 50,),
            widget.title == "MNA - NNI"
                ? Center(child: CopyRightText())
                : SizedBox(),
            widget.title == "MNA - NNI"
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                  width: Get.width,
                  child: CustomButton(
                    text: currentIndex != _controller.allData.length - 1
                        ? "next".tr
                        : "save".tr,
                    myFunc: () {
                      print(_controller.allData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.allData.length - 1) {
                          if (e.selectedQ == true) {
                            // for(var a =0;a<e.)

                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('choose_one'.tr);
                          }
                        } else {
                          if (e.selectedQ == true) {
                            print('complete');
                            onSaved();
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
                        }
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  Widget _checkboxWidget(NRSListData e) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
        SizedBox(
          height: 10,
        ),
        widget.title == "MNA - NNI"
            ? Center(child: NNILogo_CopyRightText())
            : SizedBox(),
        widget.title == "MNA - NNI"
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),

        widget.title == "MNA - NNI" ||
                widget.title.removeAllWhitespace.contains('STRONG-KIDS')
            ? SizedBox()
            : Center(
                child: Text(
                  "${'step'.tr} ${_controller.allData.indexOf(e) + 1}",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontBold, color: primary_color),
                ),
              ),

        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
          child: Text(
            "${e.statusquestion}",
            style: TextStyle(fontSize: 16, fontWeight: FontBold),
          ),
        ),

        e.statusquestion.toLowerCase().removeAllWhitespace.contains(
                'Body Mass Index (BMI) (weight in kg) /(height in m)2'
                    .toLowerCase()
                    .removeAllWhitespace)
            ? Padding(
                padding: EdgeInsets.only(top: 8),
                child: Center(
                  child: BMI.isEmpty
                      ? Text(
                          "BMI = not available (go to anthropometory)",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        )
                      : Text(
                          "BMI = $BMI kg/m (${dateFormat.format(DateTime.parse(anthroDate))})",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                        ),
                ),
              )
            : SizedBox(),

        SizedBox(
          height: 10,
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
                                  // if(e.options[c].isSelected == true){
                                  e.options[c].isSelected = false;
                                  e.selectedQ = false;

                                  // }
                                }
                                e.options[index].isSelected =
                                    !e.options[index].isSelected;
                                e.selectedQ = e.options[index].isSelected;
                              });

                              // print('option: ${e.options[index].statusoption}');
                              if (e.statusId == AppString.bogyMassIndex) {
                                if (e.options[index].sId == AppString.bmiNotAvailable) {
                                  print('option: ${e.options[index].statusoption}');

                                  setState(() {
                                    // _controller.allData.add(bodyMass);
                                    _controller.allData.add(circumference);
                                  });
                                } else {
                                  print('exception here akash');
                                  setState(() {
                                    // _controller.allData.add(bodyMass);
                                    _controller.allData.remove(circumference);
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
                                  e.options[index].statusoption,
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
        widget.title == "MNA - NNI"
            ? Center(child: CopyRightText())
            : SizedBox(),
        widget.title == "MNA - NNI"
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),
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
                        currentIndex != _controller.allData.length - 1
                            ? "next".tr
                            : "save".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(_controller.allData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.allData.length - 1) {
                          if (e.selectedQ == true) {
                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
                        } else {
                          if (e.selectedQ == true) {
                            print('complete');
                            onSaved();
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
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
    List<NRSListData> selectedList = [];

    for (var a = 0; a < _controller.allData.length; a++) {
      if (_controller.allData[a].selectedQ) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(_controller.allData[a]);
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    int count = 0;

    for (var q = 0; q < selectedList.length; q++) {
      print(selectedList[q].options);

      for (var s = 0; s < selectedList[q].options.length; s++) {
        if (selectedList[q].options[s].isSelected == true) {
          // print('total score: ${count+ int.parse(selectedList[q].options[s].score)}');
          // print('int score: ${selectedList[q].options[s].score}');

          int a = int.parse(selectedList[q].options[s].score);
          setState(() {
            count = count + a;
          });
        }
      }
    }

    print('total score: $count');

    getAgeYearsFromDate(widget.patientDetailsData.dob).then((year) {
      if (widget.id == JsonFilePath.nrsData) {
        if (year > 70) {
          setState(() {
            count = count + 1;
          });
        }
      }

      Map data = {
        'status': widget.title,
        'score': count.toString(),
        'lastUpdate': '${DateTime.now()}',
        'data': selectedList
      };

      print('data json: ${jsonEncode(data)}');

      if (widget.HistoryKey == ConstConfig.MUSTHistory) {
        _controller.savedMustData(widget.patientDetailsData, selectedList,
            count, widget.title, context);
      } else if (widget.HistoryKey == ConstConfig.NutricHistory) {
        _controller.saveNutric(widget.patientDetailsData, selectedList, count,
            widget.title, context);
      } else if (widget.HistoryKey == ConstConfig.STRONGKIDHistory) {
        print(widget.HistoryKey);
        _controller.savedStrongKidData(widget.patientDetailsData, selectedList,
            count, widget.title, context);
      } else {
        print('else case here');

        checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId)
            .then((internet) {
          if (internet != null && internet) {
            _controller
                .saveData(widget.patientDetailsData, selectedList, count,
                    widget.title, data)
                .then((value) {
              print('return value: $value');
              _historyController.saveMultipleMsgHistory(
                  widget.patientDetailsData.sId,
                  widget.HistoryKey,
                  [data]).then((value) {
                if (widget.HistoryKey == ConstConfig.MUSTHistory) {
                  // _controller.afterSaved(count, widget.patientDetailsData, context);
                } else {
                  Get.to(Step1HospitalizationScreen(
                    patientUserId: widget.patientDetailsData.sId,
                    index: 2,
                  ));
                }
              });
            });
          } else {
            _controller.saveDataOffline(widget.patientDetailsData, selectedList,
                count, data, widget.title);
          }
        });
      }
    });

    // _controller.saveData(widget.patientDetailsData, selectedList, count);
  }

  //-----------------------------------------------------------------

  List<DiseasesWithRiskMalnutrition> dataStatic =
      <DiseasesWithRiskMalnutrition>[];
  List<StaticList> dataStatic2 = <StaticList>[];

  dataInitiateStatic() {
    dataStatic = <DiseasesWithRiskMalnutrition>[
      DiseasesWithRiskMalnutrition('psychiatric_eating_disorder'.tr),
      DiseasesWithRiskMalnutrition('burns'.tr),
      DiseasesWithRiskMalnutrition('bronchopulmonary_dysplasia'.tr),
      DiseasesWithRiskMalnutrition('celiac_disease_active'.tr),
      DiseasesWithRiskMalnutrition('cystic_fibrosis'.tr),
      DiseasesWithRiskMalnutrition('dysmaturity_prematurity'.tr),
      DiseasesWithRiskMalnutrition('cardiac_disease_chronic'.tr),
      DiseasesWithRiskMalnutrition('infectious_disease'.tr),
      DiseasesWithRiskMalnutrition('inflammatory_bowel_disease'.tr),
      DiseasesWithRiskMalnutrition('cancer'.tr),
      DiseasesWithRiskMalnutrition('liver_disease_chronic'.tr),
      DiseasesWithRiskMalnutrition('kidney_disease_chronic'.tr),
      DiseasesWithRiskMalnutrition('pancreatitis'.tr),
      DiseasesWithRiskMalnutrition('short_bowel_syndrome'.tr),
      DiseasesWithRiskMalnutrition('muscle_disease'.tr),
      DiseasesWithRiskMalnutrition('metabolic_disease'.tr),
      DiseasesWithRiskMalnutrition('trauma'.tr),
      DiseasesWithRiskMalnutrition('mental_handicap_retardation'.tr),
      DiseasesWithRiskMalnutrition('expected_major_surgery'.tr),
      DiseasesWithRiskMalnutrition('not_specified_classified_by_doctor'.tr),
    ];

    dataStatic2 = [
      StaticList('excessive_diarrhea'.tr),
      StaticList('reduced_food_intake'.tr),
      StaticList('pre_existing_nutritional_intervention'.tr),
      StaticList('Inability_to_consume_adequate_'.tr),
    ];
  }
}

class DiseasesWithRiskMalnutrition {
  String text;

  DiseasesWithRiskMalnutrition(this.text);
}

class StaticList {
  String text;

  StaticList(this.text);
}
