import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/oral_diet.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/fastingOralDietController.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/fasting2.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class Fasting1 extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final Ntdata ntdata;

  Fasting1({this.patientDetailsData, this.ntdata});

  @override
  _Fasting1State createState() => _Fasting1State();
}

class _Fasting1State extends State<Fasting1> {
  List<staticList> listOption = <staticList>[];
  List<staticList> listOptionTab = <staticList>[];

  final FastingOralDietController fastingOralDietController =
      FastingOralDietController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // listOption.add(staticList(optionText: 'General (2168/94)',isSelected: false,kcal: 2168,ptn: 94));
    // listOption.add(staticList(optionText: 'Mild (2025/83)',isSelected: false,kcal: 2025,ptn: 83));
    // listOption.add(staticList(optionText: 'Pasty - Liquid (1923/93)',isSelected: false,kcal: 1923,ptn: 93));
    // listOption.add(staticList(optionText: 'Light (1941/94)',isSelected: false,kcal: 1941,ptn: 94));
    // listOption.add(staticList(optionText: 'Liquid Restricted (600/11)',isSelected: false,kcal: 600,ptn: 11));
    // listOption.add(staticList(optionText: 'Hipossodic (2025/84)',isSelected: false,kcal: 2025,ptn: 84));
    // listOption.add(staticList(optionText: 'Hipossodic/Diabetes (1735/104)',isSelected: false,kcal: 1735,ptn: 104));
    //
    //
    listOptionTab.add(staticList(
      optionText: 'nt_team_agree_oral'.tr,
      isSelected: true,
    ));
    listOptionTab.add(staticList(
      optionText: 'nt_team_disagree_oral'.tr,
      isSelected: false,
    ));

    listOption.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      fastingOralDietController
          .getRouteForMode(widget.patientDetailsData.hospital[0].sId)
          .then((value) {
        for (var a in fastingOralDietController.allData) {
          setState(() {
            listOption.add(staticList(
                optionText:
                    '${a.oraldietname} (${a.averagekcal}/${a.averageprotein})',
                isSelected: false,
                kcal: a.averagekcal,
                ptn: a.averageprotein));
          });
        }

        getSelected();
      });
    });
  }

  getSelected() {
    if (widget.ntdata != null && !widget.ntdata.result.first.fasting) {
      String condition = widget.ntdata.result.first.condition;

      for (var a in listOption) {
        if (a.optionText.contains(condition)) {
          setState(() {
            a.isSelected = true;
            selectedIndex = listOption.indexOf(a);
          });
          break;
        }
      }

      if (widget.ntdata.result.first.teamAgree) {
        selectedIndexTeam = 0;
        listOptionTab[0].isSelected = true;
        listOptionTab[1].isSelected = false;
      } else {
        selectedIndexTeam = 1;
        listOptionTab[1].isSelected = true;
        listOptionTab[0].isSelected = false;
      }
    }
  }

  bool clearAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("fasting_oral_diet".tr, null),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            _radioWidgetTeam(listOptionTab[0]),
            _radioWidgetTeam(listOptionTab[1]),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      child: Text(
                        '${'name'.tr} (kcal/g protein)',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('pressed');
                      setState(() {
                        for (var a in listOptionTab) {
                          setState(() {
                            a.isSelected = false;
                          });
                        }
                        for (var a in listOption) {
                          setState(() {
                            a.isSelected = false;
                          });
                        }

                        selectedIndex = -1;
                        selectedIndexTeam = -1;
                      });
                    },
                    child: Text(
                      'clear_all'.tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: ListView(
                children: listOption.map((e) => _radioWidget(e)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'fasting'.tr,
                      myFunc: () async {
                        print(widget?.ntdata?.result?.first?.description);
                        Get.to(Fasting2(
                          patientDetailsData: widget.patientDetailsData,
                          fastingReason:
                              widget?.ntdata?.result?.first?.fasting_reason,
                          description:
                              widget?.ntdata?.result?.first?.description ?? "",
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'confirm'.tr,
                      myFunc: () async {
                        debugPrint('selectedIndexTeam :: ${selectedIndexTeam}');
                        if(selectedIndex !=-1 && selectedIndexTeam == -1){
                            ShowMsg('please_choose_an_option_with_nt_team'.tr);
                        }else{
                          this.onConfirm();
                        }

                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;
  int selectedIndexTeam = 0;

  Widget _radioWidget(staticList e) {
    return Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var a in listOption) {
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;

              selectedIndex = listOption.indexOf(e);
            });
          },
          child: Container(
            child: Row(
              children: [
                e.isSelected
                    ? Icon(
                        Icons.radio_button_checked,
                        size: 25,
                        color: primary_color,
                      )
                    : Icon(
                        Icons.radio_button_off,
                        size: 25,
                      ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(
                      '${e.optionText}',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _radioWidgetTeam(staticList e) {
    return Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (var a in listOptionTab) {
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;

              selectedIndexTeam = listOptionTab.indexOf(e);
            });
          },
          child: Container(
            child: Row(
              children: [
                e.isSelected
                    ? Icon(
                        Icons.radio_button_checked,
                        size: 25,
                        color: primary_color,
                      )
                    : Icon(
                        Icons.radio_button_off,
                        size: 25,
                      ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(
                      '${e.optionText}',
                      style: new TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
        ));
  }

  onConfirm() async {
    Map finalData;

    if (selectedIndex != -1) {
      staticList selectedData = listOption[selectedIndex];
      print('selected condition: ${selectedData.optionText}');
      print('selected kcal: ${selectedData.kcal}');
      print('selected ptn: ${selectedData.ptn}');

      Map item = {
        'team_agree': selectedIndexTeam == 0 ? true : false,
        'fasting': false,
        'fasting_reason': '',
        'condition': selectedData.optionText,
        'kcal': selectedData.kcal.toString(),
        'ptn': selectedData.ptn.toString(),
        'lastUpdate': '${DateTime.now()}',
      };

      // List<FastingOralData> addItem = await addItemFASTING(widget.patientDetailsData,item,0);
      List<FastingOralData> addItem =
          await addItem_inLast3DaysData(widget.patientDetailsData, item, 0);

      print('a list : ${addItem.length}');

      finalData = {
        'team_agree': selectedIndexTeam == 0 ? true : false,
        'fasting': false,
        'fasting_reason': '',
        'condition': selectedData.optionText,
        'kcal': selectedData.kcal.toString(),
        'ptn': selectedData.ptn.toString(),
        'lastUpdate': '${DateTime.now()}',
        'fasting_oral_data': addItem,
      };

      print('json data: ${jsonEncode(finalData)}');

      fastingOralDietController
          .getRouteForModeSave(
              widget.patientDetailsData, finalData, FastingOral.fastingOral)
          .then((value) {
        Get.to(Step1HospitalizationScreen(
          patientUserId: widget.patientDetailsData.sId,
          index: 4,
          statusIndex: 2,
        ));
      });
    } else {
      List<FastingOralData> addItem =
          await getPreviuos3Daysdata(widget.patientDetailsData);
      finalData = {
        'lastUpdate': '${DateTime.now()}',
        'fasting_oral_data': addItem,
      };
      fastingOralDietController
          .getRouteForModeSave(
              widget.patientDetailsData, finalData, FastingOral.fastingOral)
          .then((value) {
        Get.to(Step1HospitalizationScreen(
          patientUserId: widget.patientDetailsData.sId,
          index: 4,
          statusIndex: 2,
        ));
      });
    }
  }
}

class staticList {
  String optionText;
  bool isSelected;
  String kcal;
  String ptn;

  staticList({this.optionText, this.isSelected, this.kcal, this.ptn});
}
