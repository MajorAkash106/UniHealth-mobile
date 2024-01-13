import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/fastingOralDietController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/oral_acceptance_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/diet_category.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../ons.dart';

class Oral_Food_Accptnc extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final OralData selectedItem;
  final String type;

  Oral_Food_Accptnc({this.patientDetailsData, this.type, this.selectedItem});

  @override
  _Oral_Food_AccptncState createState() => _Oral_Food_AccptncState();
}

class _Oral_Food_AccptncState extends State<Oral_Food_Accptnc> {
  final FastingOralDietController fastingOralDietController =
  FastingOralDietController();
  ORALDietAcceptanceController controller = ORALDietAcceptanceController();
  int selectedIndex = -1;
  bool selected = false;
  List<staticList> listOptionDropdown = <staticList>[];
  List<Percentages> prcnt_list = <Percentages>[
    Percentages('0', false),
    Percentages('25', false),
    Percentages('50', false),
    Percentages('75', false),
    Percentages('100', false),
  ];
  String _value;
  String value1;

  @override
  void initState() {
    // listOptionDropdown
    //     .add(staticList(optionText: 'Justify if <75%', isSelected: false));
    listOptionDropdown
        .add(staticList(optionText: 'justify_if_<_75'.tr, isSelected: false));
    listOptionDropdown
        .add(staticList(optionText: 'abdominal_surgery'.tr, isSelected: false));
    listOptionDropdown.add(staticList(
        optionText: 'other_procedures_surgery'.tr, isSelected: false));
    listOptionDropdown
        .add(staticList(optionText: 'patient_refuse'.tr, isSelected: false));
    listOptionDropdown
        .add(staticList(optionText: 'unknown_reason'.tr, isSelected: false));
    selectedIndex = 0;
    print(selectedIndex);
    // TODO: implement initState
    super.initState();
    apiCall();
  }

  apiCall() {
    fastingOralDietController
        .getRouteForMode(widget.patientDetailsData.hospital[0].sId)
        .then((value) {
      getSelected();
    });
  }

  getSelected() {
    if (widget.selectedItem != null) {
      breakFast = widget.selectedItem.data.breakFast;
      breakFast_i = retrunIndex(widget.selectedItem.data.breakFastPer);
      breakFast_r = widget.selectedItem.data.breakFastRes;
      // breakFast_p = widget.selectedItem.data.breakFast;
      morningSnack = widget.selectedItem.data.morningSnack;
      morningSnack_i = retrunIndex(widget.selectedItem.data.morningSnackPer);
      morningSnack_r = widget.selectedItem.data.morningSnackRes;

      lunch = widget.selectedItem.data.lunch;
      lunch_i = retrunIndex(widget.selectedItem.data.lunchPer);
      lunch_r = widget.selectedItem.data.lunchRes;

      afternoonSnack = widget.selectedItem.data.noon;
      afternoonSnack_i = retrunIndex(widget.selectedItem.data.noonPer);
      afternoonSnack_r = widget.selectedItem.data.noonRes;

      dinner = widget.selectedItem.data.dinner;
      dinner_i = retrunIndex(widget.selectedItem.data.dinnerPer);
      dinner_r = widget.selectedItem.data.dinnerRes;

      supper = widget.selectedItem.data.supper;
      supper_i = retrunIndex(widget.selectedItem.data.supperPer);
      supper_r = widget.selectedItem.data.supperRes;
    }
  }

  retrunIndex(String text) {
    if (text != null) {
      if (text == '0') {
        return 0;
      } else if (text == '25') {
        return 1;
      } else if (text == '50') {
        return 2;
      } else if (text == '75') {
        return 3;
      } else if (text == '100') {
        return 4;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }

  String breakFast;
  String morningSnack;
  String lunch;
  String afternoonSnack;
  String dinner;
  String supper;

  String breakFast_r;
  String morningSnack_r;
  String lunch_r;
  String afternoonSnack_r;
  String dinner_r;
  String supper_r;

  int breakFast_i = -1;
  int morningSnack_i = -1;
  int lunch_i = -1;
  int afternoonSnack_i = -1;
  int dinner_i = -1;
  int supper_i = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('oral_diet_acceptance'.tr, null),
        body: Obx(
              () =>
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          block('breakfast'.tr, 0),
                          block('morning_snack'.tr, 1),
                          InkWell(
                            child: block('lunch'.tr, 2),
                            onTap: () {
                              controller
                                  .getfiltered3daysData(
                                  widget.patientDetailsData,
                                  OralData(
                                      lastUpdate: DateTime.now().toString(),
                                      data: Data()))
                                  .then((value) =>
                                  print("ppppp..${jsonEncode(value)}"));
                            },
                          ),
                          block('afternoon_snack'.tr, 3),
                          block('dinner'.tr, 4),
                          block('supper'.tr, 5),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Container(
                        width: Get.width,
                        child: CustomButton(
                          text: "confirm".tr,
                          myFunc: () {
                            // Get.to(Pregnancy_Lagtation_page2());

                            this.onConfirm();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
        ));
  }

  Widget headindTxt(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
    );
  }

  Widget dropdwn1(int index) {
    return Container(
      // width: Get.width/2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(width: 1)),
      height: 40.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            style: TextStyle(color: Colors.black, fontSize: 16.0),
            iconEnabledColor: Colors.black,
            // isExpanded: true,
            iconSize: 30.0,
            dropdownColor: Colors.white,
            hint: Text('select'.tr),

            value: index == 0
                ? breakFast
                : index == 1
                ? morningSnack
                : index == 2
                ? lunch
                : index == 3
                ? afternoonSnack
                : index == 4
                ? dinner
                : index == 5
                ? supper
                : value1,
            items: [
              ...fastingOralDietController.allData.map(
                    (e) =>
                    DropdownMenuItem(
                      enabled: isEnable(index, e),
                      onTap: (){
                        print('onTaping');
                        if(!isEnable(index, e)){
                          ShowMsg('This field is not accessible for this Diet.');
                        }
                      },
                      child: Text('${e.oraldietname}', style: TextStyle(
                          color: isEnable(index, e) ? Colors.black :Colors.black12),),
                      value: "${e.oraldietname}",
                    ),
              )
            ],
            onChanged: (String value) {
              print('working on $index');
              print('value $value');

              if (index == 0) {
                breakFast = value;
                if (breakFast_i == -1) breakFast_i = 0;
              } else if (index == 1) {
                morningSnack = value;
                if (morningSnack_i == -1) morningSnack_i = 0;
              } else if (index == 2) {
                lunch = value;
                if (lunch_i == -1) lunch_i = 0;
              } else if (index == 3) {
                afternoonSnack = value;
                if (afternoonSnack_i == -1) afternoonSnack_i = 0;
              } else if (index == 4) {
                dinner = value;
                if (dinner_i == -1) dinner_i = 0;
              } else if (index == 5) {
                supper = value;
                if (supper_i == -1) supper_i = 0;
              }

              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  isEnable(int index, DataDietCategory d) {
    if (index == 0) {
      return d.breakfaststatus;
    } else if (index == 1) {
      return d.morningsnackstatus;
    } else if (index == 2) {
      return d.lunchstatus;
    } else if (index == 3) {
      return d.afternoonsnackstatus;
    } else if (index == 4) {
      return d.dinnerstatus;
    } else if (index == 5) {
      return d.supperstatus;
    }
  }

  Widget dropdwon(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            width: 1,
          )),
      height: 40.0,
      width: MediaQuery
          .of(context)
          .size
          .width,
      child:
      //Container(child: Center(child: _value==0?,),),
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              iconEnabledColor: Colors.black,
              // isExpanded: true,
              iconSize: 30.0,
              dropdownColor: Colors.white,
              hint: Text('justify_if_<_75'.tr),
              value: index == 0
                  ? breakFast_r
                  : index == 1
                  ? morningSnack_r
                  : index == 2
                  ? lunch_r
                  : index == 3
                  ? afternoonSnack_r
                  : index == 4
                  ? dinner_r
                  : index == 5
                  ? supper_r
                  : value1,
              items: listOptionDropdown
                  .map(
                    (e) =>
                    DropdownMenuItem(
                      child: Text('${e.optionText}'),
                      value: '${e.optionText}',
                    ),
              )
                  .toList(),
              onChanged: (value) {
                // setState(() {
                //   _value = value;
                //   print(value);
                // });

                print('working on $index');
                print('value $value');

                if (index == 0) {
                  breakFast_r = value;
                } else if (index == 1) {
                  morningSnack_r = value;
                } else if (index == 2) {
                  lunch_r = value;
                } else if (index == 3) {
                  afternoonSnack_r = value;
                } else if (index == 4) {
                  dinner_r = value;
                } else if (index == 5) {
                  supper_r = value;
                }

                setState(() {});
              }),
        ),
      ),
    );
  }

  Widget block(String txt, int indexx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.0,
        ),
        headindTxt(txt),
        SizedBox(
          height: 30.0,
        ),
        dropdwn1(indexx),
        SizedBox(
          height: 15.0,
        ),
        _perSliders(indexx),
        SizedBox(
          height: 15.0,
        ),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
          child: justification(indexx),
        ),
        SizedBox(
          height: 20.0,
        ),
        Divider(
          color: Colors.black26,
          height: 2.0,
          thickness: 2.0,
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget justification(int index) {
    if (index == 0 && (breakFast_i == 3 || breakFast_i == 4)) {
      return SizedBox();
    } else if (index == 1 && (morningSnack_i == 3 || morningSnack_i == 4)) {
      return SizedBox();
    } else if (index == 2 && (lunch_i == 3 || lunch_i == 4)) {
      return SizedBox();
    } else if (index == 3 && (afternoonSnack_i == 3 || afternoonSnack_i == 4)) {
      return SizedBox();
    } else if (index == 4 && (dinner_i == 3 || dinner_i == 4)) {
      return SizedBox();
    } else if (index == 5 && (supper_i == 3 || supper_i == 4)) {
      return SizedBox();
    } else {
      return dropdwon(index);
    }
  }

  Widget _perSliders(int index) {
    if (index == 0) {
      return _perSlider0();
    } else if (index == 1) {
      return _perSlider1();
    } else if (index == 2) {
      return _perSlider2();
    } else if (index == 3) {
      return _perSlider3();
    } else if (index == 4) {
      return _perSlider4();
    } else if (index == 5) {
      return _perSlider5();
    }
  }

  Widget _perSlider0() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: breakFast_i == index
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color: breakFast_i == index
                                ? Colors.blue
                                : Colors.black26),
                      )),
                ),
                onTap: () {
                  breakFast_i = index;
                  setState(() {});
                  //action
                },
              ),
            );
          }),
    );
  }

  Widget _perSlider1() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: morningSnack_i == index
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color: morningSnack_i == index
                                ? Colors.blue
                                : Colors.black26),
                      )),
                ),
                onTap: () {
                  morningSnack_i = index;
                  setState(() {});

                  //action
                },
              ),
            );
          }),
    );
  }

  Widget _perSlider2() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: lunch_i == index ? Colors.white : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color: lunch_i == index ? Colors.blue : Colors
                                .black26),
                      )),
                ),
                onTap: () {
                  lunch_i = index;
                  setState(() {});

                  //action
                },
              ),
            );
          }),
    );
  }

  Widget _perSlider3() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: afternoonSnack_i == index
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color: afternoonSnack_i == index
                                ? Colors.blue
                                : Colors.black26),
                      )),
                ),
                onTap: () {
                  afternoonSnack_i = index;
                  setState(() {});

                  //action
                },
              ),
            );
          }),
    );
  }

  Widget _perSlider4() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                    dinner_i == index ? Colors.white : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color:
                            dinner_i == index ? Colors.blue : Colors.black26),
                      )),
                ),
                onTap: () {
                  dinner_i = index;
                  setState(() {});

                  //action
                },
              ),
            );
          }),
    );
  }

  Widget _perSlider5() {
    return Container(
      height: 50.0,
      width: Get.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: prcnt_list.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                child: Container(
                  width: 62,
                  //color: prcnt_list[index].selected_prcnt?Colors.green :Colors.red ,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color:
                    supper_i == index ? Colors.white : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                        prcnt_list[index].prcnt_text + '%',
                        style: TextStyle(
                            color:
                            supper_i == index ? Colors.blue : Colors.black26),
                      )),
                ),
                onTap: () {
                  supper_i = index;
                  setState(() {});

                  //action
                },
              ),
            );
          }),
    );
  }

  getIsAvailable(int index, String reason_text) {
    if (index != -1) {
      int percentage = int.parse(prcnt_list[index].prcnt_text);

      if (percentage < 75 && reason_text.isNullOrBlank) {
        return true;
      } else if (percentage < 75 && !reason_text.isNullOrBlank) {
        return true;
      } else if (percentage >= 75) {
        return true;
      }
    } else {
      return false;
    }
  }

  ifBlankReturnZero(String text) {
    debugPrint('ifBlankReturnZero text :: $text');
    if (text == null) {
      text = '0';
    }

    if (text != null && text != '') {
      return double.parse(text);
    } else {
      return 0.0;
    }
  }

  Map needsData;
  Needs addItem = Needs();

  computeTotal() async {
    double plankcal = 0.0;
    double planptn = 0.0;
    double achkcal = 0.0;
    double achptn = 0.0;

    if (breakFast != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == breakFast,
          orElse: () => null);
      double pkcal = ifBlankReturnZero(data.breakfastkcal);
      double pptn = ifBlankReturnZero(data.breakfastprotein);
      double akcal =
          pkcal * int.parse(prcnt_list[breakFast_i].prcnt_text) / 100;
      double aptn = pptn * int.parse(prcnt_list[breakFast_i].prcnt_text) / 100;

      print('---------isBreakFast----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }
    if (morningSnack != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == morningSnack,
          orElse: () => null);

      debugPrint('data.morningsnackkcal ::${data.morningsnackkcal}');
      double pkcal = ifBlankReturnZero(data.morningsnackkcal);
      double pptn = ifBlankReturnZero(data.morningsnackprotein);
      double akcal =
          pkcal * int.parse(prcnt_list[morningSnack_i].prcnt_text) / 100;
      double aptn =
          pptn * int.parse(prcnt_list[morningSnack_i].prcnt_text) / 100;

      print('---------isMorningSnack----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }
    if (lunch != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == lunch,
          orElse: () => null);
      double pkcal = ifBlankReturnZero(data.lunchkcal);
      double pptn = ifBlankReturnZero(data.lunchprotein);
      double akcal = pkcal * int.parse(prcnt_list[lunch_i].prcnt_text) / 100;
      double aptn = pptn * int.parse(prcnt_list[lunch_i].prcnt_text) / 100;

      print('---------isLunch----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }
    if (afternoonSnack != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == afternoonSnack,
          orElse: () => null);
      double pkcal = ifBlankReturnZero(data.afternoonsnackkcal);
      double pptn = ifBlankReturnZero(data.afternoonsnackprotein);
      double akcal =
          pkcal * int.parse(prcnt_list[afternoonSnack_i].prcnt_text) / 100;
      double aptn =
          pptn * int.parse(prcnt_list[afternoonSnack_i].prcnt_text) / 100;

      print('---------isNoon----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }
    if (dinner != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == dinner,
          orElse: () => null);
      double pkcal = ifBlankReturnZero(data.dinnerkcal);
      double pptn = ifBlankReturnZero(data.dinnerprotein);
      double akcal = pkcal * int.parse(prcnt_list[dinner_i].prcnt_text) / 100;
      double aptn = pptn * int.parse(prcnt_list[dinner_i].prcnt_text) / 100;

      print('---------isDinner----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }
    if (supper != null) {
      var data = await fastingOralDietController.allData.firstWhere(
              (element) => element.oraldietname == supper,
          orElse: () => null);
      double pkcal = ifBlankReturnZero(data.supperkcal);
      double pptn = ifBlankReturnZero(data.supperprotein);
      double akcal = pkcal * int.parse(prcnt_list[supper_i].prcnt_text) / 100;
      double aptn = pptn * int.parse(prcnt_list[supper_i].prcnt_text) / 100;

      print('---------isSupper----------');
      print('plan kcal : ${pkcal}');
      print('plan ptn : ${pptn}');

      print('Ach kcal : ${akcal}');
      print('Ach ptn : ${aptn}');

      plankcal = plankcal + pkcal;
      planptn = planptn + pptn;
      achkcal = achkcal + akcal;
      achptn = achptn + aptn;
    }

    print('---------------total----------------');
    print('plan kcal : ${plankcal}');
    print('plan ptn : ${planptn}');

    print('Ach kcal : ${achkcal}');
    print('Ach ptn : ${achptn}');

    // Map data = {
    //   'lastUpdate': '${DateTime.now()}',
    //   "type": 'oral_acceptance',
    //   'planned_kcal': plankcal.toString(),
    //   'planned_ptn': planptn.toString(),
    //   'achievement_kcal': achkcal.toString(),
    //   'achievement_protein': achptn.toString(),
    // };

    addItem.lastUpdate = widget.type == '-1'
        ? '${DateTime.now().subtract(Duration(days: 1))}'
        : '${DateTime.now()}';
    addItem.type = 'oral_acceptance';
    addItem.plannedKcal = plankcal.toString();
    addItem.plannedPtn = planptn.toString();
    addItem.achievementKcal = achkcal.toString();
    addItem.achievementProtein = achptn.toString();

    // needsData = data;
    setState(() {});
  }

  onConfirm() async {
    await computeTotal();
    // print('breakfast');
    // print('category: $breakFast');
    // print('reason: $breakFast_r');
    // print('per: ${prcnt_list[breakFast_i].prcnt_text}');
    // print('-----------------------------------------');
    //
    // print('morning snack');
    // print('category: $morningSnack');
    // print('reason: $morningSnack_r');
    // print('per: ${prcnt_list[morningSnack_i].prcnt_text}');
    //
    // print('-----------------------------------------');
    //
    // print('Lunch');
    // print('category: $lunch');
    // print('reason: $lunch_r');
    // print('per: ${prcnt_list[lunch_i].prcnt_text}');
    // print('-----------------------------------------');
    //
    // print('After noon snack');
    // print('category: $afternoonSnack');
    // print('reason: $afternoonSnack_r');
    // print('per: ${prcnt_list[afternoonSnack_i].prcnt_text}');
    //
    // print('-----------------------------------------');
    //
    // print('Dinner');
    // print('category: $dinner');
    // print('reason: $dinner_r');
    // print('per: ${prcnt_list[dinner_i].prcnt_text}');
    //
    // print('-----------------------------------------');
    //
    // print('Supper');
    // print('category: $supper');
    // print('reason: $supper_r');
    // print('per: ${prcnt_list[supper_i].prcnt_text}');

    Map finalData = {
      'breakFast': breakFast,
      'breakFastRes': breakFast_r,
      'breakFastPer':
      breakFast_i == -1 ? null : prcnt_list[breakFast_i].prcnt_text,
      'isBreakFast': breakFast.isNullOrBlank || breakFast_i.isNullOrBlank
          ? false
          : getIsAvailable(breakFast_i, breakFast_r),
      // !breakFast_i.isNullOrBlank &&  int.parse(prcnt_list[breakFast_i].prcnt_text)<75? false:true,

      'morningSnack': morningSnack,
      'morningSnackRes': morningSnack_r,
      'morningSnackPer':
      morningSnack_i == -1 ? null : prcnt_list[morningSnack_i].prcnt_text,
      'isMorningSnack': morningSnack.isNullOrBlank ||
          morningSnack_i.isNullOrBlank
          ? false
          :
      // !morningSnack_i.isNullOrBlank &&  int.parse(prcnt_list[morningSnack_i].prcnt_text)<75? false:true,
      getIsAvailable(morningSnack_i, morningSnack_r),

      'lunch': lunch,
      'lunchRes': lunch_r,
      'lunchPer': lunch_i == -1 ? null : prcnt_list[lunch_i].prcnt_text,
      'isLunch':
      // lunch.isNullOrBlank || lunch_r.isNullOrBlank || lunch_i.isNullOrBlank?false:true,
      lunch.isNullOrBlank || lunch_i.isNullOrBlank
          ? false
          : getIsAvailable(lunch_i, lunch_r),

      'noon': afternoonSnack,
      'noonRes': afternoonSnack_r,
      'noonPer': afternoonSnack_i == -1
          ? null
          : prcnt_list[afternoonSnack_i].prcnt_text,
      'isNoon':
      // afternoonSnack.isNullOrBlank || afternoonSnack_r.isNullOrBlank || afternoonSnack_i.isNullOrBlank?false:true,
      afternoonSnack.isNullOrBlank || afternoonSnack_i.isNullOrBlank
          ? false
          : getIsAvailable(afternoonSnack_i, afternoonSnack_r),

      'dinner': dinner,
      'dinnerRes': dinner_r,
      'dinnerPer': dinner_i == -1 ? null : prcnt_list[dinner_i].prcnt_text,
      'isDinner':
      // dinner.isNullOrBlank || dinner_r.isNullOrBlank || dinner_i.isNullOrBlank?false:true,
      dinner.isNullOrBlank || dinner_i.isNullOrBlank
          ? false
          : getIsAvailable(dinner_i, dinner_r),

      'supper': supper,
      'supperRes': supper_r,
      'supperPer': supper_i == -1 ? null : prcnt_list[supper_i].prcnt_text,
      'isSupper':
      // supper.isNullOrBlank || supper_r.isNullOrBlank || supper_i.isNullOrBlank?false:true,
      supper.isNullOrBlank || supper_i.isNullOrBlank
          ? false
          : getIsAvailable(supper_i, supper_r),

      'lastUpdate': widget.type == '-1'
          ? '${DateTime.now().subtract(Duration(days: 1))}'
          : '${DateTime.now()}',
    };

    Data dd = Data(
      breakFast: breakFast,
      breakFastRes: breakFast_r,
      breakFastPer:
      breakFast_i == -1 ? null : prcnt_list[breakFast_i].prcnt_text,
      isBreakFast: breakFast.isNullOrBlank || breakFast_i.isNullOrBlank
          ? false
          : getIsAvailable(breakFast_i, breakFast_r),
      // !breakFast_i.isNullOrBlank &&  int.parse(prcnt_list[breakFast_i].prcnt_text)<75? false:true,

      morningSnack: morningSnack,
      morningSnackRes: morningSnack_r,
      morningSnackPer:
      morningSnack_i == -1 ? null : prcnt_list[morningSnack_i].prcnt_text,
      isMorningSnack: morningSnack.isNullOrBlank || morningSnack_i.isNullOrBlank
          ? false
          :
      // !morningSnack_i.isNullOrBlank &&  int.parse(prcnt_list[morningSnack_i].prcnt_text)<75? false:true,
      getIsAvailable(morningSnack_i, morningSnack_r),

      lunch: lunch,
      lunchRes: lunch_r,
      lunchPer: lunch_i == -1 ? null : prcnt_list[lunch_i].prcnt_text,
      isLunch:
      // lunch.isNullOrBlank || lunch_r.isNullOrBlank || lunch_i.isNullOrBlank?false:true,
      lunch.isNullOrBlank || lunch_i.isNullOrBlank
          ? false
          : getIsAvailable(lunch_i, lunch_r),

      noon: afternoonSnack,
      noonRes: afternoonSnack_r,
      noonPer: afternoonSnack_i == -1
          ? null
          : prcnt_list[afternoonSnack_i].prcnt_text,
      isNoon:
      // afternoonSnack.isNullOrBlank || afternoonSnack_r.isNullOrBlank || afternoonSnack_i.isNullOrBlank?false:true,
      afternoonSnack.isNullOrBlank || afternoonSnack_i.isNullOrBlank
          ? false
          : getIsAvailable(afternoonSnack_i, afternoonSnack_r),

      dinner: dinner,
      dinnerRes: dinner_r,
      dinnerPer: dinner_i == -1 ? null : prcnt_list[dinner_i].prcnt_text,
      isDinner:
      // dinner.isNullOrBlank || dinner_r.isNullOrBlank || dinner_i.isNullOrBlank?false:true,
      dinner.isNullOrBlank || dinner_i.isNullOrBlank
          ? false
          : getIsAvailable(dinner_i, dinner_r),

      supper: supper,
      supperRes: supper_r,
      supperPer: supper_i == -1 ? null : prcnt_list[supper_i].prcnt_text,
      isSupper:
      // supper.isNullOrBlank || supper_r.isNullOrBlank || supper_i.isNullOrBlank?false:true,
      supper.isNullOrBlank || supper_i.isNullOrBlank
          ? false
          : getIsAvailable(supper_i, supper_r),

      lastUpdate: widget.type == '-1'
          ? '${DateTime.now().subtract(Duration(days: 1))}'
          : '${DateTime.now()}',
    );

    print('json data: ${jsonEncode(finalData)}');

    int total = 0;
    int total_diet = 0;

    if (finalData['isBreakFast'] == true) {
      total = total + int.parse(prcnt_list[breakFast_i].prcnt_text);
      total_diet = total_diet + 1;
    }
    if (finalData['isMorningSnack'] == true) {
      total = total + int.parse(prcnt_list[morningSnack_i].prcnt_text);
      total_diet = total_diet + 1;
    }
    if (finalData['isLunch'] == true) {
      total = total + int.parse(prcnt_list[lunch_i].prcnt_text);
      total_diet = total_diet + 1;
    }
    if (finalData['isNoon'] == true) {
      total = total + int.parse(prcnt_list[afternoonSnack_i].prcnt_text);
      total_diet = total_diet + 1;
    }
    if (finalData['isDinner'] == true) {
      total = total + int.parse(prcnt_list[dinner_i].prcnt_text);
      total_diet = total_diet + 1;
    }
    if (finalData['isSupper'] == true) {
      total = total + int.parse(prcnt_list[supper_i].prcnt_text);
      total_diet = total_diet + 1;
    }

    print('total--$total');
    print('total diet--$total_diet');

    List A = [];

    Ntdata getData;
    await getORAL(widget.patientDetailsData).then((res) {
      getData = res;
    });

    if (getData != null) {
      await updatedDataORAL(getData.result.first.oralData, widget.type)
          .then((res) {
        if (res != null) {
          Map setData = {
            'lastUpdate': res.lastUpdate,
            'average': res.average,
            'data': res.data
          };
          A.add(setData);
        }
      });
    } else {
      print('previous oral data doesnt exist');
    }

    Map setData = {
      'lastUpdate': widget.type == '-1'
          ? '${DateTime.now().subtract(Duration(days: 1))}'
          : '${DateTime.now()}',
      'average': total == 0 && total_diet == 0
          ? null
          : (total / total_diet).toStringAsFixed(2),
      'data': finalData
    };
    A.add(setData);

    List<OralData> d = await controller.getfiltered3daysData(
        widget.patientDetailsData,
        OralData(
            lastUpdate: DateTime.now().toString(), average: "44.0", data: dd));
    Map dataa = {
      'lastUpdate': '${DateTime.now()}',
      'oral_data': A,
      'last3daysData': d
    };

    // print('json dataa: ${jsonEncode(dataa)}');

    await controller.getRouteForModeSave(widget.patientDetailsData, dataa,
        ORALACCEPTANCE.OralAccept, setData, addItem);
    //     .then((res){
    //   // Get.to(Step1HospitalizationScreen(
    //   //   patientUserId: widget.patientDetailsData.sId,
    //   //   index: 4,
    //   //   statusIndex: 3,
    //   // ));
    //
    // });
  }
}

class Percentages {
  String prcnt_text;
  bool selected_prcnt;

  Percentages(this.prcnt_text, this.selected_prcnt);
}
