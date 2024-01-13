import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/non_nutritional_kcal_controller.dart';
import 'package:medical_app/contollers/plan_for_today_suggestion.dart';
import 'package:medical_app/contollers/time_picker/time_picker.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/needs_achievements_box.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/last_work.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/non_nutritional_p.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/relative_macro.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/total_macronutrients.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/total_macronutrients_2.dart';
import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/blank_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../../config/Locale/locale_config.dart';
import '../../../../../config/cons/cons.dart';
import '../../../../../config/widgets/calender_widget.dart';
import '../../../../../contollers/NutritionalTherapy/getCurrentNeed.dart';
import '../../../../../model/NutritionalTherapy/needs.dart';
import '../../ons.dart';

class ParenteralNutritionScreen extends StatefulWidget {
  PatientDetailsData patientDetailsData;

  ParenteralNutritionScreen({Key key, this.patientDetailsData})
      : super(key: key);

  @override
  _ParenteralNutritionScreenState createState() =>
      _ParenteralNutritionScreenState();
}

class _ParenteralNutritionScreenState extends State<ParenteralNutritionScreen> {
  ParenteralNutrional_Controller parenteralNutrional_Controller =
      ParenteralNutrional_Controller();
  final EnteralNutritionalController _encontroller =
      EnteralNutritionalController();
  final NonNutritionalKcal nonNutritionalKcalController = NonNutritionalKcal();
  final PlanForTodaySuggestion _sgController = PlanForTodaySuggestion();
  final CurrentNeed currentNeed = CurrentNeed();

  final NeedsController needsController = NeedsController();
  List<PARENTERALDATA> listOptionDrpDwn_readyToUse =
      []; //<staticList>[staticList(optionText: "industrialized 1"),staticList(optionText: "select industrialized"),staticList(optionText: "industrialized 2")];

  List<staticList> listOptionTab = <staticList>[];
  TextEditingController bagsPerDay = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController startDateE = TextEditingController();
  TextEditingController hoursInfusion = TextEditingController();
  TextEditingController totalVolumeMl = TextEditingController();
  TextEditingController totalKcal = TextEditingController();
  TextEditingController protein = TextEditingController();
  TextEditingController lipids = TextEditingController();
  TextEditingController glucose = TextEditingController();
  TextEditingController glucose2 = TextEditingController();
  TextEditingController lipids2 = TextEditingController();
  TextEditingController currentWork = TextEditingController();

  TextEditingController currentWorkManipulated = TextEditingController();
  TextEditingController startTimeManipulated = TextEditingController();
  TextEditingController startDateM = TextEditingController();
  TextEditingController hoursInfusionManip = TextEditingController();
  TextEditingController totalVolumeMl_Manipu = TextEditingController();
  TextEditingController totalKcal_Manipulated = TextEditingController();
  TextEditingController protien_Manipulated = TextEditingController();
  TextEditingController liquid_Manipulated = TextEditingController();
  TextEditingController liquid2_Manipulated = TextEditingController();
  TextEditingController glucose_Manipulated = TextEditingController();
  TextEditingController luiqid2_Manipulated = TextEditingController();
  TextEditingController glucose2_Manipulated = TextEditingController();

  TextEditingController surgery_op = TextEditingController();

  TextEditingController infusionReason = TextEditingController();
  TextEditingController is_lastPresent = TextEditingController(text: "no");

  int selectedIndexTeam = -1;
  bool ready_toUseTab = true;
  String _value;
  double sum = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    parenteralNutrional_Controller
        .getRouteModuleForMode(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      print(value.data.length);

      setLocale();
      setState(() {
        listOptionDrpDwn_readyToUse.addAll(value.data);
      });
      filterLIST();
      print(listOptionDrpDwn_readyToUse.length);
      setAll();
    });
    listOptionTab.add(staticList(
        optionText: 'nt_team_agree_with_parenteral'.tr, isSelected: false));
    listOptionTab.add(staticList(
        optionText: 'nt_team_disagree_with_parenteral'.tr, isSelected: false));

    super.initState();
  }

  filterLIST() {
    Future.delayed(Duration(milliseconds: 100), () {
      for (var a in listOptionDrpDwn_readyToUse) {
        if (!(
            // a.isActive &&
            (a.availableIn.indexOf(getLocale.languageCode) != -1))) {
          setState(() {
            listOptionDrpDwn_readyToUse.remove(a);
          });
          // setState(() {
          //   listOptionDrpDwn_readyToUse.add(a);
          // });
        }
      }
    });
  }

  LocaleConfig localeConfig = LocaleConfig();
  var getLocale;

  setLocale() async {
    getLocale = await localeConfig.getLocale();
  }

  Future<bool> willPopScope() {
    Get.offAll(Step1HospitalizationScreen(
      patientUserId: widget.patientDetailsData.sId,
      index: 4,
      statusIndex: 5,
    ));
  }

  TextEditingController is_alertEnabled = TextEditingController(text: "no");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(
        appBar: BaseAppbar("parenteral_nutrition".tr, null),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  _radioWidget(listOptionTab[0]),
                  _radioWidget(listOptionTab[1]),
                  InkWell(
                    onTap: () {
                      print("pinfuse.. ${is_lastPresent.text}");
                    },
                    child: LastWorkP(
                        patientDetailsData: widget.patientDetailsData,
                        surgery_postop: surgery_op,
                        accessFluid: () {
                          Get.to(BalanceFluid(
                            patientDetailsData: widget.patientDetailsData,
                            isFromEn: true,
                          )).then((val) {
                            print(val);
                            if (val) {
                              Get.to(BlankScreenLoader(
                                userId: widget.patientDetailsData.sId,
                                isParenteral: true,
                              ));
                            }
                          });
                        },
                        infusedReason: infusionReason,
                        is_alertEnabled: is_alertEnabled,
                        is_lastPresent: is_lastPresent),
                  ),
                  Center(
                    child: Text(
                      "current_work_day".tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                      child: new FutureBuilder(
                          future: _encontroller.getCurrentNextWorkDayDate(
                              widget.patientDetailsData.hospital.first.sId),
                          initialData: '',
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            String data = snapshot.data;
                            return Text(
                              "$data",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          })),
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      "parenteral_nutrition_formula".tr,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      text: "interrupt_parenteral_nutrition".tr,
                      myFunc: () async {
                        print('kk');
                        isInterrupred = true;
                        await clearAll();
                        widget.patientDetailsData =
                            await currentNeed.removeNeedObject(
                                widget.patientDetailsData, 'parenteral');
                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {});
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width / 2.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          //color: tab_industrialized==true?primary_color:null
                        ),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: ready_toUseTab == true
                              ? primary_color
                              : Colors.white,
                          child: Text("ready_to_use".tr,
                              style: TextStyle(
                                  color: ready_toUseTab == true
                                      ? Colors.white
                                      : primary_color)),
                          onPressed: () {
                            setState(() {
                              ready_toUseTab = true;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        width: Get.width / 2.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          // color: tab_industrialized==false?primary_color:null
                        ),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          color: ready_toUseTab == false
                              ? primary_color
                              : Colors.white,
                          child: Text(
                            "manipulated_parenteral".tr,
                            style: TextStyle(
                                color: ready_toUseTab == false
                                    ? Colors.white
                                    : primary_color),
                          ),
                          onPressed: () {
                            setState(() {
                              ready_toUseTab = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  ready_toUseTab == true ? _readyToUse() : _manipulated(),
                  NonNutritionalCaloriesP(
                    total: total_N,
                    citrate: citrate_N,
                    glucos: glucose_N,
                    propofol: propofol_N,
                  ),
                  NeedsAchievements(
                    patientDetailsData: widget.patientDetailsData,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                      text: "confirm".tr,
                      myFunc: () async {
                        if ((parenteraldata != null ||
                                bagsPerDay.text.isNotEmpty ||
                                startDateE.text.isNotEmpty ||
                                startTime.text.isNotEmpty ||
                                hoursInfusion.text.isNotEmpty) ||
                            (startTimeManipulated.text.isNotEmpty ||
                                startDateM.text.isNotEmpty ||
                                hoursInfusionManip.text.isNotEmpty ||
                                totalVolumeMl_Manipu.text.isNotEmpty ||
                                totalKcal_Manipulated.text.isNotEmpty) ||
                            (selectedIndexTeam != -1)) {
                          print('yesss saved!');
                          onConfirmed();
                        } else {
                          if (isInterrupred) {
                            print('yesss interrupted saved!');

                            var needsData = await parenteralNutrional_Controller
                                .getneedsAfterInterpt(
                                    widget.patientDetailsData,
                                    ready_toUseTab,
                                    protein.text.isEmpty ? "0.0" : protein.text,
                                    protien_Manipulated.text.isEmpty
                                        ? "0.0"
                                        : protien_Manipulated.text,
                                    totalVolumeMl.text.isEmpty
                                        ? "0.0"
                                        : totalVolumeMl.text,
                                    totalVolumeMl_Manipu.text.isEmpty
                                        ? "0.0"
                                        : totalVolumeMl_Manipu.text,
                                    currentWork.text.isEmpty
                                        ? "0.0"
                                        : currentWork.text,
                                    currentWorkManipulated.text.isEmpty
                                        ? "0.0"
                                        : currentWorkManipulated.text,
                                    totalKcal.text.isEmpty
                                        ? "0.0"
                                        : totalKcal.text,
                                    totalKcal_Manipulated.text.isEmpty
                                        ? "0.0"
                                        : totalKcal_Manipulated.text,
                                    parenteraldata?.sId ?? "");
                            print(jsonEncode(needsData));

                            parenteralNutrional_Controller
                                .getRouteForModeSaveInterupted(
                                    widget.patientDetailsData, needsData);
                          }
                        }
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  bool isInterrupred = false;

  onConfirmed() {
    if (selectedIndexTeam != -1) {
      if (ready_toUseTab) {
        authenticateReady();
      } else {
        authenticateMani();
      }
    } else {
      ShowMsg('please_choose_an_option_with_nt_team'.tr);
    }
  }

  var propofol_N = TextEditingController();
  var glucose_N = TextEditingController();
  var citrate_N = TextEditingController();
  var total_N = TextEditingController();

  TimeOfDay result;
  PARENTERALDATA parenteraldata;

  Widget _readyToUse() {
    listOptionDrpDwn_readyToUse.toSet().toList();
    return Column(
      children: [
        dropdown(listOptionDrpDwn_readyToUse, _value, (value) {
          setState(() {
            _value = value;
            parenteraldata = listOptionDrpDwn_readyToUse.firstWhere(
                (element) => element.sId == value,
                orElse: () => null);
            print("hep.. ${parenteraldata.kcal}");
            parenteralNutrional_Controller.parenteraldata = parenteraldata;

            getTotalVol();
          });
        }, context),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0,bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  parenteralNutrional_Controller.get_paternal_current_data(
                      widget.patientDetailsData,
                      widget.patientDetailsData.hospital.first.sId);
                },
                child: Text("number_of_bags_per_day".tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                child: texfld("bags_per_day".tr, bagsPerDay, () async {
                  print(bagsPerDay);
                  await getTotalVol();
                  await getTotalMacro();
                  await onUpdate();
                }),
              ),
            ],
          ),
        ),
        startDateView(controller: startDateE),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("start_time".tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              InkWell(
                onTap: () {
                  print('hour: ${result?.hour}');
                  print('min: ${result?.minute}');
                  timePicker(context, result?.hour, result?.minute)
                      .then((time) {
                    print('return time : $time');
                    result = time;
                    startTime.text =
                        "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                    print(result.minute);
                    getTotalVol();
                    setState(() {});
                  });
                },
                child: Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      controller: startTime,
                      enabled: false,
                      //focusNode: focus,
                      keyboardType: TextInputType.name,
                      onChanged: (_value) {},
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "12:00",
                        border: new OutlineInputBorder(
                            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0) //This is Ignored,
                            ),
                        hintStyle: TextStyle(
                            color: black40_color,
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("hours_of_infusion".tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                child: texfld("hour_per_day".tr, hoursInfusion, () async {
                  print(hoursInfusion);
                  await getTotalVol();
                  await getRelativeMacro();
                  await onUpdate();
                }),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "total_volume".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      controller: totalVolumeMl,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.deny(',')],
                      readOnly: ready_toUseTab ? true : false,
                      enabled: ready_toUseTab ? false : true,
                      //focusNode: focus,
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (_value) {
                        print(totalVolumeMl);
                        getCurrentWork();
                      },
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "mL",
                        border: new OutlineInputBorder(
                            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0) //This is Ignored,
                            ),
                        hintStyle: TextStyle(
                            color: black40_color,
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              children: [
                Text("total_cal".tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      controller: totalKcal,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.deny(',')],
                      readOnly: ready_toUseTab ? true : false,
                      enabled: ready_toUseTab ? false : true,
                      //focusNode: focus,
                      keyboardType: TextInputType.numberWithOptions(),
                      onChanged: (_value) {
                        print(totalKcal);
                        getCurrentWork();
                      },
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "kcal",
                        border: new OutlineInputBorder(
                            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0) //This is Ignored,
                            ),
                        hintStyle: TextStyle(
                            color: black40_color,
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text("${'current_work_day'.tr} (mL)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () async {
                  parenteralNutrional_Controller.calAchievement_PlannedProtein(
                      double.parse(protein.text),
                      double.parse(totalVolumeMl.text),
                      double.parse(currentWork.text),
                      double.parse(totalKcal.text),
                      widget.patientDetailsData,
                      "widget.patientDetailsData.hospital[0].sId,",
                      parenteralNutrional_Controller.parenteraldata);
                },
              ),
              Spacer(),
              Container(
                  width: 100.0,
                  height: 40.0,
                  child: TextField(
                    controller: currentWork,
                    enabled: false,
                    //focusNode: focus,
                    keyboardType: TextInputType.name,
                    onChanged: (_value) {},
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      // hintText: "12:00",
                      border: new OutlineInputBorder(
                          //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.0) //This is Ignored,
                          ),
                      hintStyle: TextStyle(
                          color: black40_color,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          height: 3.0,
          color: Colors.black12,
          thickness: 2,
        ),
        // NeedsAchievements(
        //   patientDetailsData: widget.patientDetailsData,
        // ),
        TotalMacro(
          protien: protein,
          liqid: lipids,
          glucose: glucose,
          bagperday: bagsPerDay,
          parenteraldata: parenteraldata,
        ),
        RelativeMacro(
          liqid: lipids2,
          glucose: glucose2,
        ),
      ],
    );
  }

  Widget startDateView({TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("start_date".tr, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          InkWell(
            onTap: () {
              var getDate = TextEditingController();
              getDate.text =
                  '${DateFormat(commonDateFormat).format(DateTime.now())}';
              calenderWidget(context, getDate, () async {
                controller.text = getDate.text;

                if(ready_toUseTab){
                  getCurrentWork();
                }else {
                  getCurrentWorkManipulated();
                }
                setState(() {});
              }, 'start_date'.tr,
                  '${DateFormat(commonDateFormat).format(DateTime.now())}',
                  disableFutureDate: false);
            },
            child: Container(
                width: 100.0,
                height: 40.0,
                child: TextField(
                  controller: controller,
                  enabled: false,
                  //focusNode: focus,
                  keyboardType: TextInputType.name,
                  onChanged: (_value) {},
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    // hintText: "12:00",
                    border: new OutlineInputBorder(
                        //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(
                            color: Colors.white, width: 0.0) //This is Ignored,
                        ),
                    hintStyle: TextStyle(
                        color: black40_color,
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _manipulated() {
    return Column(
      children: [
        startDateView(controller: startDateM),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("start_time".tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              InkWell(
                onTap: () {
                  print('hour: ${result?.hour}');
                  print('min: ${result?.minute}');
                  timePicker(context, result?.hour, result?.minute)
                      .then((time) {
                    print('return time : $time');
                    result = time;
                    startTimeManipulated.text =
                        "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                    print(result.minute);
                    getCurrentWorkManipulated();
                    setState(() {});
                  });
                },
                child: Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      controller: startTimeManipulated,
                      enabled: false,
                      //focusNode: focus,
                      keyboardType: TextInputType.name,
                      onChanged: (_value) {},
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "12:00",
                        border: new OutlineInputBorder(
                            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.white,
                                width: 0.0) //This is Ignored,
                            ),
                        hintStyle: TextStyle(
                            color: black40_color,
                            fontSize: 9.0,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            ],
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("hours_of_infusion".tr,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                child: texfld("hour_per_day".tr, hoursInfusionManip, () async {
                  print(hoursInfusionManip);
                  await getRelativeMacro2();
                  await getCurrentWorkManipulated();
                  await onUpdate();
                }),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "total_volume".tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: 100.0,
                  height: 40.0,
                  child: texfld("ml", totalVolumeMl_Manipu, () {
                    print(totalVolumeMl_Manipu);
                    getCurrentWorkManipulated();
                  }),
                ),
              ],
            ),
            SizedBox(
              width: 20.0,
            ),
            Column(
              children: [
                Text("total_cal".tr,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: 100.0,
                  height: 40.0,
                  child: texfld("kcal", totalKcal_Manipulated, () {
                    print(totalKcal_Manipulated);
                    getCurrentWorkManipulated();
                  }),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("${'current_work'.tr} (mL)",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                  width: 100.0,
                  height: 40.0,
                  child: TextField(
                    controller: currentWorkManipulated,
                    enabled: false,
                    //focusNode: focus,
                    keyboardType: TextInputType.name,
                    onChanged: (_value) {},
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      // hintText: "12:00",
                      border: new OutlineInputBorder(
                          //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.0) //This is Ignored,
                          ),
                      hintStyle: TextStyle(
                          color: black40_color,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Divider(
          height: 3.0,
          color: Colors.black12,
          thickness: 2,
        ),
        TotalMacro2(
          protien: protien_Manipulated,
          liqid: liquid_Manipulated,
          glucose: glucose_Manipulated,
          bagperday: bagsPerDay,
          parenteraldata: parenteraldata,
          onEnteredLipids: () {
            getRelativeMacro2();
            onUpdate();
          },
        ),
        RelativeMacro(
          liqid: liquid2_Manipulated,
          glucose: glucose2_Manipulated,
        ),
      ],
    );
  }

  getTotalVol() async {
    totalVolumeMl.text = await parenteralNutrional_Controller.computeVolume(
            parenteraldata,
            bagsPerDay.text,
            startTime.text,
            hoursInfusion.text) ??
        '';
    getCurrentWork();
    getTotalCal();
  }

  getCurrentWork() async {
    double previous = await parenteralNutrional_Controller
        .computeCurrentWorkPreviousSchduled(widget.patientDetailsData);

    if (totalVolumeMl.text.isNotEmpty && startTime.text.isNotEmpty && startDateE.text.isNotEmpty) {
      adLog('totalVolumeMl.text -- ${totalVolumeMl.text}');

      String current = await parenteralNutrional_Controller.computeCurrentWork(
              widget.patientDetailsData,
              totalVolumeMl.text,
              hoursInfusion.text,
              bagsPerDay.text,
              parenteralNutrional_Controller.parenteraldata.bag,
              startTime.text,
              startDateE.text,
              ready_toUseTab) ??
          '';

      adLog('currentWork = previous $previous + current $current');
      double total = previous + double.parse(current);
      currentWork.text = total.toStringAsFixed(1);
    } else {
      currentWork.clear();
    }

    onUpdate();
  }

  getCurrentWorkManipulated() async {
    double previous = await parenteralNutrional_Controller
        .computeCurrentWorkPreviousSchduled(widget.patientDetailsData);

    if (totalVolumeMl_Manipu.text.isNotEmpty &&
        startTimeManipulated.text.isNotEmpty && startDateM.text.isNotEmpty) {
      String current = await parenteralNutrional_Controller.computeCurrentWork(
              widget.patientDetailsData,
              totalVolumeMl_Manipu.text,
              hoursInfusionManip.text,
              '0.0',
              '0.0',
              startTimeManipulated.text,
              startDateM.text,
              ready_toUseTab) ??
          '';
      double total = previous + double.parse(current);

      adLog('total = previous $previous + current $current');

      currentWorkManipulated.text = total.toStringAsFixed(1);
    } else {
      currentWorkManipulated.clear();
    }

    onUpdate();
  }

  getTotalCal() async {
    totalKcal.text = await parenteralNutrional_Controller.computeCalories(
            parenteraldata,
            bagsPerDay.text,
            startTime.text,
            hoursInfusion.text) ??
        '';
  }

  getTotalMacro() async {
    List<double> getData = await parenteralNutrional_Controller.computeMacro(
        parenteraldata, bagsPerDay.text);

    if (getData.isNotEmpty) {
      protein.text = getData[0].toStringAsFixed(1);
      lipids.text = getData[1].toStringAsFixed(1);
      glucose.text = getData[2].toStringAsFixed(1);
    } else {
      protein.clear();
      lipids.clear();
      glucose.clear();
    }
    getRelativeMacro();
  }

  getRelativeMacro() async {
    //index 0 liquid
    //index 1 glucose

    List<double> getData =
        await parenteralNutrional_Controller.computeRelativeMcro(
            parenteraldata,
            bagsPerDay.text,
            widget.patientDetailsData,
            hoursInfusion.text,
            lipids.text,
            glucose.text);

    if (getData.isNotEmpty) {
      lipids2.text = getData[0].toStringAsFixed(5);
      glucose2.text = getData[1].toStringAsFixed(5);
    } else {
      lipids2.clear();
      glucose2.clear();
    }
  }

  getRelativeMacro2() async {
    //index 0 liquid
    //index 1 glucose

    List<double> getData =
        await parenteralNutrional_Controller.computeRelativeMcro(
            parenteraldata,
            bagsPerDay.text,
            widget.patientDetailsData,
            hoursInfusionManip.text,
            liquid_Manipulated.text,
            glucose_Manipulated.text);

    if (getData.isNotEmpty) {
      liquid2_Manipulated.text = getData[0].toStringAsFixed(5);
      glucose2_Manipulated.text = getData[1].toStringAsFixed(5);
    } else {
      liquid2_Manipulated.clear();
      glucose2_Manipulated.clear();
    }
  }

  Widget _radioWidget(staticList e) {
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

              debugPrint('selectedIndexTeam :: $selectedIndexTeam');
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

  Widget dropdown(
      List<PARENTERALDATA> listofItems, var vlu, Function func, var context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Container(
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
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                iconEnabledColor: Colors.black,
                // isExpanded: true,
                iconSize: 30.0,
                dropdownColor: Colors.white,
                hint: Text('select'.tr),
                value: vlu == '' ? null : vlu,
                items: listofItems
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text('${e.title}'),
                        value: '${e.sId}',
                      ),
                    )
                    .toList(),
                onChanged: func),
          ),
        ),
      ),
    );
  }

  setAll() async {
    var getprevious = await parenteralNutrional_Controller
        .getParenteral(widget.patientDetailsData);
    if (getprevious != null) {
      // if(getprevious.tabStatus){
      ready_toUseTab = getprevious.tabStatus;

      selectedIndexTeam = getprevious.teamStatus;

      getprevious.teamStatus == 0
          ? listOptionTab[0].isSelected = true
          : listOptionTab[1].isSelected = true;

      bagsPerDay.text = getprevious.readyToUse.bagPerDay;
      startTime.text = getprevious.readyToUse.startTime;
      startDateE.text = getprevious.readyToUse.startDate;
      hoursInfusion.text = getprevious.readyToUse.hrInfusion;
      totalVolumeMl.text = getprevious.readyToUse.totalVol;
      totalKcal.text = getprevious.readyToUse.totalCal;

      _value = getprevious.readyToUse.titleId;
      parenteraldata = listOptionDrpDwn_readyToUse.firstWhere(
          (element) => element.sId == getprevious.readyToUse.titleId,
          orElse: () => null);
      parenteralNutrional_Controller.parenteraldata =
          listOptionDrpDwn_readyToUse.firstWhere(
              (element) => element.sId == getprevious.readyToUse.titleId,
              orElse: () => null);

      protein.text = getprevious.readyToUse.totalMacro.protein;
      lipids.text = getprevious.readyToUse.totalMacro.liquid;
      glucose.text = getprevious.readyToUse.totalMacro.glucose;

      lipids2.text = getprevious.readyToUse.relativeMacro.liquid;
      glucose2.text = getprevious.readyToUse.relativeMacro.glucose;

      startTimeManipulated.text = getprevious.manipulated.startTime;
      startDateM.text = getprevious.manipulated.startDate;
      hoursInfusionManip.text = getprevious.manipulated.hrInfusion;
      totalVolumeMl_Manipu.text = getprevious.manipulated.totalVol;
      totalKcal_Manipulated.text = getprevious.manipulated.totalCal;

      protien_Manipulated.text = getprevious.manipulated.totalMacro.protein;
      liquid_Manipulated.text = getprevious.manipulated.totalMacro.liquid;
      glucose_Manipulated.text = getprevious.manipulated.totalMacro.glucose;

      lipids2.text = getprevious.manipulated.totalMacro.liquid;
      glucose2.text = getprevious.manipulated.totalMacro.glucose;

      if (getprevious.reducesed_justification != null) {
        infusionReason.text = getprevious.reducesed_justification.justification;
        surgery_op.text = getprevious.reducesed_justification.surgery_postOp;
      }

      getCurrentWork();
      getCurrentWorkManipulated();
    }

    nonNutritionalKcalController
        .getNonNutritionalData(widget.patientDetailsData)
        .then((res) {
      if (res != null) {
        propofol_N.text = res.propofol;
        glucose_N.text = res.glucose;
        citrate_N.text = res.citrate;
        total_N.text = res.total;
      }
    });
  }

  onConfirm() {
    Reduced_options reduced_options = Reduced_options(
        surgery_postOp: surgery_op.text, selected_reason: infusionReason.text);
    Map readyData = {
      "lastUpdate": '${DateTime.now()}',
      "title": parenteraldata?.title ?? "",
      "title_id": parenteraldata?.sId ?? "",
      "bag_per_day": bagsPerDay.text,
      "bags_from_admin": parenteraldata?.bag,
      "start_time": startTime.text,
      "start_date": startDateE.text,
      "hr_infusion": hoursInfusion.text,
      "total_vol": totalVolumeMl.text,
      "total_cal": totalKcal.text,
      "current_work": currentWork.text,
      "total_macro": {
        "protein": protein.text,
        "liquid": lipids.text,
        "glucose": glucose.text,
      },
      "relative_macro": {
        "liquid": lipids2.text,
        "glucose": glucose2.text,
      },
    };

    Map ManiData = {
      "lastUpdate": '${DateTime.now()}',
      "start_time": startTimeManipulated.text,
      "start_date": startDateM.text,
      "hr_infusion": hoursInfusionManip.text,
      "total_vol": totalVolumeMl_Manipu.text,
      "total_cal": totalKcal_Manipulated.text,
      "current_work": currentWorkManipulated.text,
      "total_macro": {
        "protein":
            protien_Manipulated.text.isEmpty ? '0.0' : protien_Manipulated.text,
        "liquid":
            liquid_Manipulated.text.isEmpty ? '0.0' : liquid_Manipulated.text,
        "glucose":
            glucose_Manipulated.text.isEmpty ? '0.0' : glucose_Manipulated.text,
      },
      "relative_macro": {
        "liquid": lipids2.text,
        "glucose": glucose2.text,
      },
    };
    Map nonNutritionalData = {
      "propofol": propofol_N.text,
      "glucose": glucose_N.text,
      "citrate": citrate_N.text,
      "total": total_N.text,
    };
    bool lastpresent = is_lastPresent.text == "yes" ? true : false;

    print('manipulated data  ${jsonEncode(ManiData)}');

    parenteralNutrional_Controller.onSavedParenteral(
        widget.patientDetailsData,
        readyData,
        reduced_options,
        selectedIndexTeam,
        ready_toUseTab,
        ManiData,
        nonNutritionalData,
        lastpresent);

    nonNutritionalKcalController.saveNonNutritionalKcal(
        widget.patientDetailsData,
        propofol_N.text,
        glucose_N.text,
        citrate_N.text,
        total_N.text);
  }

  authenticateMani() {
    if (startDateM.text.isNotEmpty) {
      if (startTimeManipulated.text.isNotEmpty) {
        if (hoursInfusionManip.text.isNotEmpty) {
          if (totalVolumeMl_Manipu.text.isNotEmpty) {
            if (totalKcal_Manipulated.text.isNotEmpty) {
              // onConfirm();
              justificationAuth();
            } else {
              ShowMsg('Total Calories field is mandatory.');
            }
          } else {
            ShowMsg('Total Volume field is mandatory.');
          }
          // onConfirm();
        } else {
          //  hr infusion
          ShowMsg('Hour of Infusion field is mandatory.');
        }
      } else {
        //  start time
        ShowMsg('Start Time field is mandatory.');
      }
    } else {
      //  start time
      ShowMsg('Start Date field is mandatory.');
    }
  }

  authenticateReady() {
    if (parenteraldata != null) {
      if (bagsPerDay.text.isNotEmpty) {
        if (startDateE.text.isNotEmpty) {
          if (startTime.text.isNotEmpty) {
            if (hoursInfusion.text.isNotEmpty) {
              justificationAuth();

              // onConfirm();
              print('tata : ${is_alertEnabled.text}');
            } else {
              //  hr infusion
              ShowMsg('Hour of Infusion field is mandatory.');
            }
          } else {
            //  start time
            ShowMsg('Start Time field is mandatory.');
          }
        }else {
          //  start time
          ShowMsg('Start Date field is mandatory.');
        }
      } else {
        ShowMsg('Bags per day field is mandatory.');
      }
    } else {
      //  select title
      ShowMsg('Dropdown field is mandatory.');
    }
  }

  justificationAuth() {
    if (is_alertEnabled.text == "true" &&
        (infusionReason.text.isNotEmpty && surgery_op.text.isNotEmpty)) {
      // goFun();
      print('onconfirm go');

      onConfirm();
    } else {
      if (is_alertEnabled.text == "true") {
        print(is_alertEnabled.text);
        print(infusionReason.text);
        print(surgery_op.text);
        ShowMsg("infused_volume_is_too_low".tr);
      } else {
        print('onconfirm go');
        // goFun();
        onConfirm();
      }
    }
  }

  onUpdate() async {
    Reduced_options reduced_options = Reduced_options(
        surgery_postOp: surgery_op.text, selected_reason: infusionReason.text);
    Map readyData = {
      "lastUpdate": '${DateTime.now()}',
      "title": parenteraldata?.title ?? "",
      "title_id": parenteraldata?.sId ?? "",
      "bag_per_day": bagsPerDay.text,
      "bags_from_admin": parenteraldata?.bag,
      "start_time": startTime.text,
      "start_date": startDateE.text,
      "hr_infusion": hoursInfusion.text,
      "total_vol": totalVolumeMl.text,
      "total_cal": totalKcal.text,
      "current_work": currentWork.text,
      "total_macro": {
        "protein": protein.text.isEmpty ? '0.0' : protein.text,
        "liquid": lipids.text.isEmpty ? '0.0' : lipids.text,
        "glucose": glucose.text.isEmpty ? '0.0' : glucose.text,
      },
      "relative_macro": {
        "liquid": lipids2.text,
        "glucose": glucose2.text,
      },
    };

    Map ManiData = {
      "lastUpdate": '${DateTime.now()}',
      "start_time": startTimeManipulated.text,
      "start_date": startDateM.text,
      "hr_infusion": hoursInfusionManip.text,
      "total_vol": totalVolumeMl_Manipu.text,
      "total_cal": totalKcal_Manipulated.text,
      "current_work": currentWorkManipulated.text,
      "total_macro": {
        "protein":
            protien_Manipulated.text.isEmpty ? '0.0' : protien_Manipulated.text,
        "liquid":
            liquid_Manipulated.text.isEmpty ? '0.0' : liquid_Manipulated.text,
        "glucose":
            glucose_Manipulated.text.isEmpty ? '0.0' : glucose_Manipulated.text,
      },
      "relative_macro": {
        "liquid": lipids2.text,
        "glucose": glucose2.text,
      },
    };
    Map nonNutritionalData = {
      "propofol": propofol_N.text,
      "glucose": glucose_N.text,
      "citrate": citrate_N.text,
      "total": total_N.text,
    };
    bool lastpresent = is_lastPresent.text == "yes" ? true : false;

    print('manipulated data  ${jsonEncode(ManiData)}');

    debugPrint('readyData["current_work"] :: ${readyData["current_work"]}');

    List<Needs> _needsData = await _sgController.onUpdateParenteral(
        widget.patientDetailsData,
        readyData,
        reduced_options,
        selectedIndexTeam,
        ready_toUseTab,
        ManiData,
        nonNutritionalData,
        lastpresent,
        parenteralNutrional_Controller.parenteraldata);

    for (var a in _needsData) {
      if (a.type == 'parenteral') {
        debugPrint('parenteral a : ${a.toJson()}');
      }
    }

    widget.patientDetailsData.needs.clear();
    widget.patientDetailsData.needs.addAll(_needsData);
    setState(() {});
  }

  clearAll() {
    listOptionTab[0].isSelected = false;
    listOptionTab[1].isSelected = false;
    selectedIndexTeam = -1;
    bagsPerDay.clear();
    startTime.clear();
    startDateE.clear();
    hoursInfusion.clear();
    totalVolumeMl.clear();
    totalKcal.clear();

    _value = null;
    parenteraldata = null;

    protein.clear();
    lipids.clear();
    glucose.clear();

    lipids2.clear();
    glucose2.clear();

    startTimeManipulated.clear();
    startDateM.clear();
    hoursInfusionManip.clear();
    totalVolumeMl_Manipu.clear();
    totalKcal_Manipulated.clear();

    protien_Manipulated.clear();
    liquid_Manipulated.clear();
    glucose_Manipulated.clear();

    lipids2.clear();
    glucose2.clear();

    propofol_N.clear();
    glucose_N.clear();
    citrate_N.clear();
    total_N.clear();
    currentWorkManipulated.clear();
    currentWork.clear();

    setState(() {});
  }
}
