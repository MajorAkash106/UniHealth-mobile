import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/ons_acceptance.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../config/Locale/locale_config.dart';
import '../../../config/cons/input_configuration.dart';

class ons_acceptance extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final Ntdata ntdata;
  final Ntdata ntdata2;

  ons_acceptance({this.patientDetailsData, this.ntdata, this.ntdata2});

  @override
  _ons_acceptanceState createState() => _ons_acceptanceState();
}

class _ons_acceptanceState extends State<ons_acceptance> {
  List<staticList> listOptionTab = <staticList>[];
  List<staticList> listOptionDropdown = <staticList>[];
  String _value;
  int type = 0;
  final ONSAcceptanceController _controller = ONSAcceptanceController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listOptionTab
        .add(staticList(optionText: 'nt_team_agree_ons'.tr, isSelected: false));
    listOptionTab.add(
        staticList(optionText: 'nt_team_disagree_ons'.tr, isSelected: false));

    apicall();
    // listOptionDropdown.add(staticList(optionText: 'Industrialized 1', isSelected: false));
    // listOptionDropdown.add(staticList(optionText: 'Industrialized 2', isSelected: false));
    // listOptionDropdown.add(staticList(optionText: 'Manipulated 1', isSelected: false));
    // listOptionDropdown.add(staticList(optionText: 'Manipulated 2', isSelected: false));
    getSelected();
  }

  var volume = TextEditingController();
  var times = TextEditingController();
  var kcal = TextEditingController();
  var ptn = TextEditingController();
  var fiber = TextEditingController();


  apicall() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _controller
          .getRouteForMode(widget.patientDetailsData.hospital[0].sId)
          .then((value) {


        // for(var a in fastingOralDietController.allData){
        //
        //
        //   setState(() {
        //     listOption.add(staticList(optionText: '${a.oraldietname} (${a.averagekcal}/${a.averageprotein})',
        //         isSelected: false,kcal: int.parse(a.averagekcal.toString()),ptn: int.parse(a.averageprotein.toString())));
        //   });
        //
        // }
        //
        // getSelected();
      });
    });
  }

  getSelected() {
    if (widget.ntdata != null) {
      print('both not null');

      String condition = widget.ntdata.result.first.condition;
      if (!condition.isNullOrBlank) {
        setState(() {
          _value = condition;
        });
      }
      //
      // for(var a in listOptionDropdown){
      //   if(a.optionText.contains(condition)){
      //     setState(() {
      //       a.isSelected = true;
      //       // selectedIndex = listOptionDropdown.indexOf(a);
      //       _value = a.optionText;
      //     });
      //     break;
      //   }
      // }

      if (widget.ntdata.result.first.teamAgree != null &&
          widget.ntdata.result.first.teamAgree) {
        selectedIndexTeam = 0;
        listOptionTab[0].isSelected = true;
        listOptionTab[1].isSelected = false;
      } else if (widget.ntdata.result.first.teamAgree != null &&
          widget.ntdata.result.first.teamAgree == false) {
        selectedIndexTeam = 1;
        listOptionTab[1].isSelected = true;
        listOptionTab[0].isSelected = false;
      } else {
        selectedIndexTeam = -1;
        listOptionTab[0].isSelected = false;
        listOptionTab[1].isSelected = false;
      }

      volume.text = widget.ntdata.result.first.volume == "0.0"
          ? ""
          : widget.ntdata.result.first.volume;
      times.text = widget.ntdata.result.first.times == "0"
          ? ""
          : widget.ntdata.result.first.times;
      kcal.text = widget.ntdata.result.first.kcal == "0.0"
          ? ""
          : widget.ntdata.result.first.kcal;
      ptn.text = widget.ntdata.result.first.ptn == "0.0"
          ? ""
          : widget.ntdata.result.first.ptn;
      fiber.text = widget.ntdata.result.first.fiber == "0.0"
          ? ""
          : widget.ntdata.result.first.fiber;
    }
  }

  int index = -1;

  timePerDay() async {
    print('times: ${times.text}');

    // volume.text = ;
    // times.text = widget.ntdata.result.first.times;
    kcal.clear();
    ptn.clear();
    fiber.clear();
    if (times.text.isNotEmpty &&
        return0IfEmpty(times.text.toString()) != 0.0 &&
        type == 1) {
      print('manipulated');

      var selectedData =
          _controller.allData.firstWhere((element) => element.title == _value);
      // volume.text = selectedData.valume;
      kcal.text = selectedData.kcal;
      ptn.text = selectedData.protein;
      fiber.text = selectedData.fiber;

      double a = return0IfEmpty(kcal.text.toString()) *
          return1ifBlank(volume.text.toString()) *
          return1ifBlank(times.text.toString());
      double b = return0IfEmpty(ptn.text.toString()) *
          return1ifBlank(volume.text.toString()) *
          return1ifBlank(times.text.toString());
      double c = return0IfEmpty(fiber.text.toString()) *
          return1ifBlank(volume.text.toString()) *
          return1ifBlank(times.text.toString());

      kcal.text = a.toStringAsFixed(2);
      ptn.text = b.toStringAsFixed(2);
      fiber.text = c.toStringAsFixed(2);
    } else if (times.text.isNotEmpty &&
        return0IfEmpty(times.text.toString()) != 0.0 &&
        return0IfEmpty(times.text.toString()) != 1.0 &&
        type == 0) {
      print('industrialized');

      var selectedData =
          _controller.allData.firstWhere((element) => element.title == _value);
      // volume.text = selectedData.valume;
      kcal.text = selectedData.kcal;
      ptn.text = selectedData.protein;
      fiber.text = selectedData.fiber;

      double a = return0IfEmpty(kcal.text.toString()) *
          return1ifBlank(times.text.toString());
      double b = return0IfEmpty(ptn.text.toString()) *
          return1ifBlank(times.text.toString());
      double c = return0IfEmpty(fiber.text.toString()) *
          return1ifBlank(times.text.toString());

      kcal.text = a.toStringAsFixed(2);
      ptn.text = b.toStringAsFixed(2);
      fiber.text = c.toStringAsFixed(2);
    } else {
      // index = _controller.allData.indexOf(selectedData);

      // print('selected index : $index');
      var selectedData =
          _controller.allData.firstWhere((element) => element.title == _value);
      // volume.text = selectedData.valume;
      kcal.text = selectedData.kcal;
      ptn.text = selectedData.protein;
      fiber.text = selectedData.fiber;
    }

    setState(() {});
    print('kcal: ${kcal.text}');
    print('ptn: ${ptn.text}');
    print('fiber: ${fiber.text}');
  }

  return0ifBlank(String text) {
    if (text == null || text == '') {
      return 0.0;
    } else {
      return double.parse(text);
    }
  }

  return1ifBlank(String text) {
    if (text == null || text == '') {
      return 1.0;
    } else {
      return double.parse(text);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: BaseAppbar("oral_nutritional_supplement".tr, null),
      body: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 10.0, bottom: 10.0, right: 20.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        _radioWidget(listOptionTab[0]),
                        _radioWidget(listOptionTab[1]),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'name'.tr,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('pressed');
                                _value = null;
                                selectedIndexTeam = -1;
                                listOptionTab[0].isSelected = false;
                                listOptionTab[1].isSelected = false;
                                // volume.text = '0.0';
                                volume.clear();
                                // times.text = '0';
                                times.clear();
                                // kcal.text = '0.0';
                                kcal.clear();
                                // ptn.text = '0.0';
                                ptn.clear();
                                // fiber.text= '0.0';
                                fiber.clear();
                                setState(() {});
                              },
                              child: Text(
                                'clear_all'.tr,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black26,
                                width: 1,
                              )),
                          height: 40.0,
                          width: MediaQuery.of(context).size.width,
                          child:
                              //Container(child: Center(child: _value==0?,),),
                              Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                  iconEnabledColor: Colors.black,
                                  // isExpanded: true,
                                  iconSize: 30.0,
                                  dropdownColor: Colors.white,
                                  hint: Text('select'.tr),
                                  value: _value,
                                  items: _controller.allData
                                      .map(
                                        (e) => DropdownMenuItem(
                                          child: Text('${e.title}'),
                                          value: '${e.title}',
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    times.clear();
                                    setState(() {
                                      _value = value;
                                      print(_value);

                                      var selectedData = _controller.allData
                                          .firstWhere((element) =>
                                              element.title == _value);
                                      print(
                                          'selected json: ${jsonEncode(selectedData)}');

                                      index = _controller.allData
                                          .indexOf(selectedData);

                                      // print('selected index : $index');

                                      volume.text = selectedData.valume;
                                      kcal.text = selectedData.kcal;
                                      ptn.text = selectedData.protein;
                                      fiber.text = selectedData.fiber;
                                      type = selectedData.type;
                                      print('type---- ${type}');
                                    });
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld(
                                    'volume',
                                    volume,
                                    timePerDay,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'mL',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld(
                                    'times'.tr,
                                    times,
                                    timePerDay,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  '${'times'.tr}/${'day'.tr}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                            // SizedBox(height: 10.0,),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'total'.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'kcal',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld(
                                    '',
                                    kcal,
                                    () {},
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'protein'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld(
                                    '',
                                    ptn,
                                    () {},
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'fiber'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld(
                                    '',
                                    fiber,
                                    () {},
                                  ),
                                ),
                              ],
                            )
                            // SizedBox(height: 10.0,),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'confirm'.tr,
                          myFunc: () async {
                            if (!_value.isNullOrBlank ||
                                selectedIndexTeam != -1 ||
                                times.text.isNotEmpty ||
                                volume.text.isNotEmpty ||
                                kcal.text.isNotEmpty ||
                                ptn.text.isNotEmpty ||
                                fiber.text.isNotEmpty) {
                              if (!_value.isNullOrBlank &&
                                  selectedIndexTeam != -1 &&
                                  times.text.isNotEmpty &&
                                  volume.text.isNotEmpty &&
                                  kcal.text.isNotEmpty &&
                                  ptn.text.isNotEmpty &&
                                  fiber.text.isNotEmpty) {
                                // if (return0IfEmpty(volume.text) == 0.0) {
                                //   ShowMsg(
                                //       "volume field value doesn't contain a valid input.");
                                // } else if (return0IfEmpty(times.text) == 0.0) {
                                //   ShowMsg(
                                //       "times/day field value doesn't contain a valid input.");
                                // } else {
                                // print(_value);
                                this.onConfirm();
                                // }
                              } else {
                                ShowMsg('all_mandatory'.tr);
                              }
                            } else {
                              // if (return0IfEmpty(volume.text) == 0.0) {
                              //   ShowMsg(
                              //       "volume field value doesn't contain a valid input.");
                              // } else if (return0IfEmpty(times.text) == 0.0) {
                              //   ShowMsg(
                              //       "times/day field value doesn't contain a valid input.");
                              // } else {
                              // print(_value);
                              this.onConfirm();
                              // }
                              // ShowMsg('All field are mandatory.');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _radioWidget(staticList e) {
    return Padding(
        padding: const EdgeInsets.only(right: 8, left: 8, top: 15),
        child: GestureDetector(
          onTap: () {
            // setState(() {
            //   for (var a in listOptionTab) {
            //     setState(() {
            //       a.isSelected = false;
            //     });
            //   }
            //   e.isSelected = true;
            // });

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

  int selectedIndexTeam = -1;

  return0IfEmpty(String text) {
    if (text.isNullOrBlank) {
      return 0.0;
    } else {
      return double.parse(text);
    }
  }

  onConfirm() async {
    List A = [];
    if (widget.ntdata != null) {
      print('ntData: ${widget.ntdata.result.first.onsData}');

      // for (var i in widget.ntdata.result.first.onsData) {
      //   Ons onsdata = i;
      //   Map onsData = {
      //     'team_agree': onsdata.teamAgree,
      //     'condition': onsdata.condition,
      //     'kcal': onsdata.kcal,
      //     'ptn': onsdata.ptn,
      //     'fiber': onsdata.fiber,
      //     'volume': onsdata.volume,
      //     'times': onsdata.times,
      //     'lastUpdate': onsdata.lastUpdate,
      //   };
      //   A.add(onsData);
      // }

      await updatedDataONS(widget.ntdata.result.first.onsData).then((v) {
        print('return filetered list: $v');

        A.addAll(v);
      });
    }

    Map onsDataUpdated = {
      'team_agree': selectedIndexTeam == 0
          ? true
          : selectedIndexTeam == 1
              ? false
              : null,
      'condition': _value,
      'kcal': kcal.text.isEmpty ? "0.0" : kcal.text,
      'ptn': ptn.text.isEmpty ? "0.0" : ptn.text,
      'fiber': fiber.text.isEmpty ? "0.0" : fiber.text,
      'total_kcal': "${return0IfEmpty(kcal.text) * return0IfEmpty(times.text)}",
      'total_ptn': "${return0IfEmpty(ptn.text) * return0IfEmpty(times.text)}",
      'total_fiber':
          "${return0IfEmpty(fiber.text) * return0IfEmpty(times.text)}",
      'volume': volume.text.isEmpty ? "0.0" : volume.text,
      'times': times.text.isEmpty ? "0" : times.text,
      'lastUpdate': '${DateTime.now()}',
    };

    A.add(onsDataUpdated);

    Map finalData = {
      'team_agree': selectedIndexTeam == 0
          ? true
          : selectedIndexTeam == 1
              ? false
              : null,
      'condition': _value,
      'kcal': kcal.text.isEmpty ? "0.0" : kcal.text,
      'ptn': ptn.text.isEmpty ? "0.0" : ptn.text,
      'fiber': fiber.text.isEmpty ? "0.0" : fiber.text,
      'total_kcal': "${return0IfEmpty(kcal.text) * return0IfEmpty(times.text)}",
      'total_ptn': "${return0IfEmpty(ptn.text) * return0IfEmpty(times.text)}",
      'total_fiber':
          "${return0IfEmpty(fiber.text) * return0IfEmpty(times.text)}",
      'volume': volume.text.isEmpty ? "0.0" : volume.text,
      'times': times.text.isEmpty ? "0" : times.text,
      'lastUpdate': '${DateTime.now()}',
      'ons': A
    };

    print('json data: ${jsonEncode(finalData)}');

    _controller.getRouteForModeSave(
        widget.patientDetailsData, finalData, ONSACCEPTANCE.OnsAccept, []);
  }
}

Widget texfld(
  String hint,
  TextEditingController controller,
  Function _fun,
) {
  return TextField(
    controller: controller,
    inputFormatters: InputConfiguration.formatDotOnly,
    // enabled: enable,
    //focusNode: focus,
    keyboardType: InputConfiguration.inputTypeWithDot,
    textInputAction: InputConfiguration.inputActionNext,
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
    ),
  );
}


Widget disableTextField(
    String hint,
    TextEditingController controller,
    Function _fun,
    ) {
  return TextField(
    controller: controller,
    textInputAction: TextInputAction.next,
    inputFormatters: [FilteringTextInputFormatter.deny(',')],
    enabled: false,
    //focusNode: focus,
    keyboardType: TextInputType.numberWithOptions(),
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
    ),
  );
}



class staticList {
  String optionText;
  bool isSelected;

  staticList({this.optionText, this.isSelected});
}
