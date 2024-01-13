import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/non_nutritional_kcal_controller.dart';
import 'package:medical_app/contollers/plan_for_today_suggestion.dart';
import 'package:medical_app/contollers/time_picker/time_picker.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_formula_model.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/needs_achievements_box.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/blank_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/en_part.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/last_work.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/non_nutritional.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/numberOfDoses.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import '../../../../config/widgets/calender_widget.dart';
import '../../../../contollers/NutritionalTherapy/getCurrentNeed.dart';
import '../ons.dart';

class EnteralNutritionScreen extends StatefulWidget {
  PatientDetailsData patientDetailsData;

  EnteralNutritionScreen({this.patientDetailsData});

  @override
  _EnteralNutritionScreenState createState() => _EnteralNutritionScreenState();
}

class _EnteralNutritionScreenState extends State<EnteralNutritionScreen> {
  final EnteralNutritionalController _controller =
      EnteralNutritionalController();
  final ParenteralNutrional_Controller _parenteralNutrional_Controller =
      ParenteralNutrional_Controller();
  final NonNutritionalKcal nonNutritionalKcalController = NonNutritionalKcal();
  final PlanForTodaySuggestion _sgController = PlanForTodaySuggestion();
  final CurrentNeed currentNeed = CurrentNeed();

  List<staticList> listOptionTab = <staticList>[];
  List<staticList> listOptionDrpDwn_ind = <staticList>[
    staticList(optionText: "industrialized 1"),
    staticList(optionText: "select industrialized"),
    staticList(optionText: "industrialized 2")
  ];
  List<staticList> listOptionDrpDwn_manipulated = <staticList>[
    staticList(optionText: "Manipulated 1"),
    staticList(optionText: "manipulated 2")
  ];
  TextEditingController mlPerHour = TextEditingController();
  TextEditingController hourPerDay = TextEditingController();
  TextEditingController mlCurrentWorkDay_indust = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController mlPerDose = TextEditingController();
  TextEditingController Num_Doses = TextEditingController();
  TextEditingController mlCurrentWorkDay_manipulated = TextEditingController();

  int selectedIndexTeam = -1;
  bool tab_industrialized = true;
  TextEditingController is_alertEnabled = TextEditingController(text: "no");

  String _value;
  String _value_manipulated;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOptionTab.add(staticList(
        optionText: 'nt_team_agree_with_enteral'.tr, isSelected: false));
    listOptionTab.add(staticList(
        optionText: 'nt_team_disagree_with_enteral'.tr, isSelected: false));

    print('ooooo');

    getFormualas();
    isLastPresent();
  }

  String workday;

  void getFormualas() async {
    await Future.delayed(const Duration(milliseconds: 100), () {
      _controller
          .getRouteFormulaForMode(widget.patientDetailsData.hospital.first.sId)
          .then((val) {
        _controller.getRouteModuleForMode(
            widget.patientDetailsData.hospital.first.sId);
        setAll();
      });
    });

    await getWorkingDays(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      workday = value;
    });

    // await showActiveItem();
  }

  String EnKcal;
  String EnKPtn;
  String EnFiber;
  String fiberModuleName;
  String ptnModuleName;

  FocusNode focus = FocusNode();
  TimeOfDay result;
  List<NumberOfDays> _numberOfDayList = [];

  var getfiberModule = TextEditingController();
  var getproteinModule = TextEditingController();
  var plan_ptn = TextEditingController(text: '0.0');
  var plan_kcal = TextEditingController(text: '0.0');
  var total_volume = TextEditingController(text: '0.0');
  var propofol = TextEditingController();
  var glucose = TextEditingController();
  var citrate = TextEditingController();
  var total = TextEditingController();
  ModuleDetail fiberModuleDetail = ModuleDetail();
  ModuleDetail proteinModuleDetail = ModuleDetail();

  var _infusedReason = TextEditingController();
  var surgery_op = TextEditingController();

  void currentWork() async {
    double previous =
        await _controller.getCurrentIndustML(widget.patientDetailsData);
    await _controller
        .getCurrentWorkday(mlPerHour, hourPerDay, startTime, startDate, workday)
        .then((res) {
      mlCurrentWorkDay_indust.clear();
      EnKcal = null;
      EnKPtn = null;
      EnFiber = null;
      if (res != null) {
        print("ooo..${res}");
        double total = double.parse(res) + previous;
        mlCurrentWorkDay_indust.text = total.toStringAsFixed(2);

        var a = _controller.industrialized
            .firstWhere((element) => element.sId == _value, orElse: () => null);
        if (a != null) {
          _controller.getEN(mlCurrentWorkDay_indust.text, a).then((en) {
            EnKcal = en[0];
            EnKPtn = en[1];
            EnFiber = en[2];
          });
          _controller.selectedData = a;
          print("uuuuuu...${jsonEncode(a)}");
        }
      }
    });

    setState(() {});
  }

  // {"title":"Glucerna 1.5® 1L - Abbott","type":0,"valume":"1000","kcal":"1.5","protein":"0.075","fiber":"0.017","cost":"0","isBlocked":false,
  // "isActive":true,"_id":"616ea6d639168d08edc142ff","hospitalId":"616d7457ab3b537880bc1523","createdAt":"2021-10-19T11:07:02.796Z","updatedAt":"2021-11-29T19:01:19.738Z","__v":0}

  void manipulatedEn() {
    if (_value_manipulated != null &&
        mlCurrentWorkDay_manipulated.text.isNotEmpty) {
      var a = _controller.manipulated.firstWhere(
          (element) => element.sId == _value_manipulated,
          orElse: () => null);
      if (a != null) {
        _controller.getEN(mlCurrentWorkDay_manipulated.text, a).then((en) {
          EnKcal = en[0];
          EnKPtn = en[1];
          EnFiber = en[2];
        });
        _controller.selectedData = a;
        print("uuuuuu...${jsonEncode(a)}");
        setState(() {});
      }

      onUpdateData();
    } else {
      EnKcal = null;
      EnKPtn = null;
      EnFiber = null;

      setState(() {});
    }
  }

  Future<bool> willPopscope() {
    Get.to(Step1HospitalizationScreen(
      patientUserId: widget.patientDetailsData.sId,
      index: 4,
      statusIndex: 4,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willPopscope,
        child: Scaffold(
            appBar: BaseAppbar(
                '${'enteral_nutrition'.tr}',
                IconButton(
                    onPressed: () {
                      var format = DateFormat("HH:mm");
                      var start = format.parse("12:30");
                      var hosp = format.parse("07:00");
                      adLog(" diff::: ${start.isBefore(hosp)}");
                    },
                    icon: Icon(Icons.info))),
            // resizeToAvoidBottomPadding: false,
            resizeToAvoidBottomInset: false,
            body: Obx(
              () => Padding(
                  padding: EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 8,
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Column(
                      // shrinkWrap: true,
                      children: [
                        _radioWidget(listOptionTab[0]),
                        _radioWidget(listOptionTab[1]),
                        SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                          onTap: () {
                            print(is_alertEnabled.text);
                            // _controller.get_reduced_justif(widget.patientDetailsData, Surgery_postOpList(lastUpdate: DateTime.now().toString(),surgery_postOp: "yes",type: 'justification')).then((value) => print("gggg.. ${jsonEncode(value)}"));
                          },
                          child: LastWork(
                            patientDetailsData: widget.patientDetailsData,
                            currentWork: tab_industrialized
                                ? mlCurrentWorkDay_indust
                                : mlCurrentWorkDay_manipulated,
                            infusedReason: _infusedReason,
                            surgery_postop: surgery_op,
                            accessFluid: () {
                              Get.to(BalanceFluid(
                                patientDetailsData: widget.patientDetailsData,
                                isFromEn: true,
                              )).then((val) {
                                print("val");
                                print(val);
                                if (val) {
                                  Get.to(BlankScreenLoader(
                                    userId: widget.patientDetailsData.sId,
                                    isParenteral: false,
                                  ));
                                }
                              });
                            },
                            is_alertEnabled: is_alertEnabled,
                          ),
                        ),
                        _currentWork(),
                        // NeedsAchievements(
                        //   patientDetailsData: widget.patientDetailsData,
                        // ),
                        InkWell(
                          onTap: () {
                            // currentWork();
                            print(total_volume.text);
                            // _controller.nextdayInterval_ml_expected(widget.patientDetailsData,startTime.text,mlPerHour.text,hourPerDay.text).then((value) => print("reere.. ${value}"));
                            // _controller.firstInterval_ml_expected(widget.patientDetailsData,startTime.text,mlPerHour.text,hourPerDay.text).then((value) => print("reere.. ${value}"));
                          },
                          child: ENPART(
                            onUpdate: onUpdateData,
                            onIsClearPtn: () async {
                              adLog('onIsClearPtn called!');

                              widget.patientDetailsData =
                                  await currentNeed.removeNeedObject(
                                      widget.patientDetailsData,
                                      'Enteral Protein Module');
                              Future.delayed(Duration(seconds: 1), () {
                                setState(() {});
                              });
                            },
                            enkCal: EnKcal,
                            fiber: EnFiber,
                            protein: EnKPtn,
                            fiberModule: getfiberModule,
                            proteinModule: getproteinModule,
                            moduleData: _controller.allModuleData,
                            plan_ptn: plan_ptn,
                            plan_kcal: plan_kcal,
                            total_volume: total_volume,
                            moduleDetail: fiberModuleDetail,
                            moduleDetail2: proteinModuleDetail,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            print(proteinModuleDetail.item);
                          },
                          child: NonNutritionalCalories(
                            propofol: propofol,
                            glucos: glucose,
                            citrate: citrate,
                            total: total,
                            onUpdate: onUpdateData,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        NeedsAchievements(
                          patientDetailsData: widget.patientDetailsData,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          width: Get.width,
                          child: CustomButton(
                            text: "confirm".tr,
                            myFunc: () async {
                              print(is_alertEnabled.text);
                              print("_infusedReason :: ${_infusedReason.text}");
                              print("surgery_op :: ${surgery_op.text}");
// print(is_alertEnabled.text =="true" && _infusedReason.text == "" && surgery_op.text == "");
                              if (is_alertEnabled.text == "true" &&
                                  _infusedReason.text == "" &&
                                  surgery_op.text == "") {
                                ShowMsgFor10sec("infused_volume_is_too_low".tr);
                              }

                              // print('scope at this point   data${_data}');

                              // if(!_data.isNullOrBlank) {
                              //  if(_data==null) {
                              //    print('scope at this point');
                              //
                              //  }
                              else {
                                if ((!_value.isNullOrBlank ||
                                        startTime.text.isNotEmpty ||
                                        startDate.text.isNotEmpty ||
                                        mlPerHour.text.isNotEmpty ||
                                        hourPerDay.text.isNotEmpty ||
                                        mlCurrentWorkDay_indust
                                            .text.isNotEmpty) ||
                                    (!_value_manipulated.isNullOrBlank ||
                                        mlPerDose.text.isNotEmpty ||
                                        mlCurrentWorkDay_manipulated
                                            .text.isNotEmpty ||
                                        !_numberOfDayList.isNullOrBlank)) {
                                  onConfirm();
                                  print('gooooooo!');
                                } else {
                                  if (interrupted) {
                                    print('yessssss!');
                                    List<Needs> getneeds =
                                        await _controller.getneedsAfterInterpt(
                                            widget.patientDetailsData,
                                            tab_industrialized
                                                ? mlCurrentWorkDay_indust
                                                        .text.isEmpty
                                                    ? "0.0"
                                                    : mlCurrentWorkDay_indust
                                                        .text
                                                : mlCurrentWorkDay_manipulated
                                                        .text.isEmpty
                                                    ? "0.0"
                                                    : mlCurrentWorkDay_manipulated
                                                        .text,
                                            tab_industrialized
                                                ? _value
                                                : _value_manipulated,
                                            tab_industrialized ? 0 : 1,
                                            double.parse(plan_ptn.text) ?? 0.0,
                                            double.parse(plan_kcal.text) ?? 0.0,
                                            double.parse(total_volume.text) ??
                                                0.0,
                                            getproteinModule.text.isEmpty
                                                ? "0.0"
                                                : getproteinModule.text);
                                    _controller.getRouteForModeSaveInterupted(
                                        widget.patientDetailsData, getneeds);
                                    // }else{
                                    //   print('noooooo!');
                                    //   onConfirm();
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  )),
            )));
  }

  goFun() async {
    print(is_alertEnabled.text);
    print(_infusedReason.text);
    print(surgery_op.text);
    print("confirm");
    if ((!_value.isNullOrBlank ||
            startTime.text.isNotEmpty ||
            startDate.text.isNotEmpty ||
            mlPerHour.text.isNotEmpty ||
            hourPerDay.text.isNotEmpty ||
            mlCurrentWorkDay_indust.text.isNotEmpty) ||
        (!_value_manipulated.isNullOrBlank ||
            mlPerDose.text.isNotEmpty ||
            mlCurrentWorkDay_manipulated.text.isNotEmpty ||
            !_numberOfDayList.isNullOrBlank)) {
      onConfirm();
      print('gooooooo!');
    } else {
      if (interrupted) {
        print('yessssss!');
        List<Needs> getneeds = await _controller.getneedsAfterInterpt(
            widget.patientDetailsData,
            tab_industrialized
                ? mlCurrentWorkDay_indust.text.isEmpty
                    ? "0.0"
                    : mlCurrentWorkDay_indust.text
                : mlCurrentWorkDay_manipulated.text.isEmpty
                    ? "0.0"
                    : mlCurrentWorkDay_manipulated.text,
            tab_industrialized ? _value : _value_manipulated,
            tab_industrialized ? 0 : 1,
            double.parse(plan_ptn.text) ?? 0.0,
            double.parse(plan_kcal.text) ?? 0.0,
            double.parse(total_volume.text) ?? 0.0,
            getproteinModule.text.isEmpty ? "0.0" : getproteinModule.text);

        _controller.getRouteForModeSaveInterupted(
            widget.patientDetailsData, getneeds);
        // }else{
        //   print('noooooo!');
        //   onConfirm();
      }
    }
  }

  onConfirm() async {
    if (selectedIndexTeam != -1) {
      if (tab_industrialized) {
        //Industrialized
        var first_interval_mlExpected;
        var second_interval_mlExpected;

        await _controller
            .nextdayInterval_ml_expected(widget.patientDetailsData,
                startTime.text, startDate.text, mlPerHour.text, hourPerDay.text)
            .then((value) {
          second_interval_mlExpected = value.toStringAsFixed(2);
        });
        await _controller
            .firstInterval_ml_expected(widget.patientDetailsData,
                startTime.text, startDate.text, mlPerHour.text, hourPerDay.text)
            .then((value) {
          first_interval_mlExpected = value.toStringAsFixed(2);
        });

        if (!_value.isNullOrBlank &&
            startTime.text.isNotEmpty &&
            startDate.text.isNotEmpty &&
            mlPerHour.text.isNotEmpty &&
            hourPerDay.text.isNotEmpty &&
            mlCurrentWorkDay_indust.text.isNotEmpty) {
          //  continue

          var data = _controller.industrialized.firstWhere(
              (element) => element.sId == _value,
              orElse: () => null);
          var data2 = _controller.manipulated.firstWhere(
              (element) => element.sId == _value_manipulated,
              orElse: () => null);

          Map industdata = {
            "id": _value ?? '',
            "title": data?.title ?? '',
            "start_time": startTime.text,
            "start_date": startDate.text,
            "ml_hr": mlPerHour.text,
            "hr_day": hourPerDay.text,
            "current_work": mlCurrentWorkDay_indust.text,
            "second_interval_mlExpected": '${second_interval_mlExpected}',
            "first_interval_mlExpected": _data.isNullOrBlank
                ? mlCurrentWorkDay_indust.text
                : '${first_interval_mlExpected}',
            "islastPresent": _data.isNullOrBlank ? false : true,
            // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
            "lastUpdate": '${DateTime.now()}',
            "en_data": {
              "kcal": EnKcal,
              "protein": EnKPtn,
              "fiber": EnFiber,
              "fiber_module": getfiberModule.text,
              "protein_module": getproteinModule.text,
              "plan_ptn": plan_ptn.text,
              "plan_kcal": plan_kcal.text,
              "total_volume": total_volume.text,
            },
          };

          Map manidata = {
            "id": _value_manipulated ?? '',
            "title": data2?.title ?? '',
            "ml_dose": mlPerDose.text,
            "current_work": mlCurrentWorkDay_manipulated.text,
            "doses_data": _numberOfDayList,
            // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
            "lastUpdate": '${DateTime.now()}',
            "en_data": {
              "kcal": EnKcal,
              "protein": EnKPtn,
              "fiber": EnFiber,
              "fiber_module": getfiberModule.text,
              "protein_module": getproteinModule.text,
              "plan_ptn": plan_ptn.text,
              "plan_kcal": plan_kcal.text,
              "total_volume": total_volume.text,
            },
          };

          Reduced_options reduced_options = Reduced_options(
              surgery_postOp: surgery_op.text,
              selected_reason: _infusedReason.text);

          saved(industdata, manidata, reduced_options, fiberModuleDetail,
              proteinModuleDetail);
        } else {
          print("1..${_value}");
          print("2..${startTime.text}");
          print("2..${startDate.text}");
          print("3..${mlPerHour.text}");
          print("4..${hourPerDay.text}");
          print("5..${mlCurrentWorkDay_indust.text}");

          ShowMsg('Please complete Industrialized data.');
        }
      } else {
        //Manipulated

        if (!_value_manipulated.isNullOrBlank &&
            mlPerDose.text.isNotEmpty &&
            mlCurrentWorkDay_manipulated.text.isNotEmpty &&
            !_numberOfDayList.isNullOrBlank) {
          //  continue

          var data = _controller.industrialized.firstWhere(
              (element) => element.sId == _value,
              orElse: () => null);
          var data2 = _controller.manipulated.firstWhere(
              (element) => element.sId == _value_manipulated,
              orElse: () => null);

          Map industdata = {
            "id": _value ?? '',
            "title": data?.title ?? '',
            "start_time": startTime.text,
            "start_date": startDate.text,
            "ml_hr": mlPerHour.text,
            "hr_day": hourPerDay.text,
            "current_work": mlCurrentWorkDay_indust.text,
            "second_interval_mlExpected": null,
            "first_interval_mlExpected": null,
            // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
            "lastUpdate": '${DateTime.now()}',
            "en_data": {
              "kcal": EnKcal,
              "protein": EnKPtn,
              "fiber": EnFiber,
              "fiber_module": getfiberModule.text,
              "protein_module": getproteinModule.text,
              "plan_ptn": plan_ptn.text,
              "plan_kcal": plan_kcal.text,
              "total_volume": total_volume.text,
            },
          };

          Map manidata = {
            "id": _value_manipulated ?? '',
            "title": data2?.title ?? '',
            "ml_dose": mlPerDose.text,
            "current_work": mlCurrentWorkDay_manipulated.text,
            "doses_data": _numberOfDayList,
            // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
            "lastUpdate": '${DateTime.now()}',
            "en_data": {
              "kcal": EnKcal,
              "protein": EnKPtn,
              "fiber": EnFiber,
              "fiber_module": getfiberModule.text,
              "protein_module": getproteinModule.text,
              "plan_ptn": plan_ptn.text,
              "plan_kcal": plan_kcal.text,
              "total_volume": total_volume.text,
            },
          };

          Reduced_options reduced_options = Reduced_options(
              surgery_postOp: surgery_op.text,
              selected_reason: _infusedReason.text);

          saved(industdata, manidata, reduced_options, fiberModuleDetail,
              proteinModuleDetail);
        } else {
          ShowMsg('please_complete_manipulated_data'.tr);
        }
      }
    } else {
      ShowMsg('please_choose_an_option_with_nt_team'.tr);
    }
  }

  void saved(Map indust, Map mani, Reduced_options reduced_options,
      ModuleDetail fiberModuleDetail, ModuleDetail ptnModuleDetail) {
    _controller.savedData(
        widget.patientDetailsData,
        selectedIndexTeam,
        tab_industrialized ? 0 : 1,
        indust,
        mani,
        reduced_options,
        EnKcal,
        EnKPtn,
        EnFiber,
        fiberModuleDetail,
        ptnModuleDetail,
        getfiberModule.text,
        getproteinModule.text,
        double.tryParse(plan_ptn.text) ?? 0.0,
        double.tryParse(plan_kcal.text) ?? 0.0,
        double.tryParse(total_volume.text) ?? 0.0,
        //expected infuse is total vollume
        propofol.text,
        glucose.text,
        citrate.text,
        total.text);
  }

  onUpdateData() async {
    if (tab_industrialized) {
      //Industrialized
      var first_interval_mlExpected;
      var second_interval_mlExpected;

      await _controller
          .nextdayInterval_ml_expected(widget.patientDetailsData,
              startTime.text, startDate.text, mlPerHour.text, hourPerDay.text)
          .then((value) {
        second_interval_mlExpected = value.toStringAsFixed(2);
      });
      await _controller
          .firstInterval_ml_expected(widget.patientDetailsData, startTime.text,
              startDate.text, mlPerHour.text, hourPerDay.text)
          .then((value) {
        first_interval_mlExpected = value.toStringAsFixed(2);
      });

      if (!_value.isNullOrBlank &&
          startTime.text.isNotEmpty &&
          startDate.text.isNotEmpty &&
          mlPerHour.text.isNotEmpty &&
          hourPerDay.text.isNotEmpty &&
          mlCurrentWorkDay_indust.text.isNotEmpty) {
        //  continue

        var data = _controller.industrialized
            .firstWhere((element) => element.sId == _value, orElse: () => null);
        var data2 = _controller.manipulated.firstWhere(
            (element) => element.sId == _value_manipulated,
            orElse: () => null);

        Map industdata = {
          "id": _value ?? '',
          "title": data?.title ?? '',
          "start_time": startTime.text,
          "start_date": startDate.text,
          "ml_hr": mlPerHour.text,
          "hr_day": hourPerDay.text,
          "current_work": mlCurrentWorkDay_indust.text,
          "second_interval_mlExpected": '${second_interval_mlExpected}',
          "first_interval_mlExpected": _data.isNullOrBlank
              ? mlCurrentWorkDay_indust.text
              : '${first_interval_mlExpected}',
          "islastPresent": _data.isNullOrBlank ? false : true,
          // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
          "lastUpdate": '${DateTime.now()}',
          "en_data": {
            "kcal": EnKcal,
            "protein": EnKPtn,
            "fiber": EnFiber,
            "fiber_module": getfiberModule.text,
            "protein_module": getproteinModule.text,
            "plan_ptn": plan_ptn.text,
            "plan_kcal": plan_kcal.text,
            "total_volume": total_volume.text,
          },
        };

        Map manidata = {
          "id": _value_manipulated ?? '',
          "title": data2?.title ?? '',
          "ml_dose": mlPerDose.text,
          "current_work": mlCurrentWorkDay_manipulated.text,
          "doses_data": _numberOfDayList,
          // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
          "lastUpdate": '${DateTime.now()}',
          "en_data": {
            "kcal": EnKcal,
            "protein": EnKPtn,
            "fiber": EnFiber,
            "fiber_module": getfiberModule.text,
            "protein_module": getproteinModule.text,
            "plan_ptn": plan_ptn.text,
            "plan_kcal": plan_kcal.text,
            "total_volume": total_volume.text,
          },
        };

        Reduced_options reduced_options = Reduced_options(
            surgery_postOp: surgery_op.text,
            selected_reason: _infusedReason.text);

        getUpdatedNeedsData(industdata, manidata, reduced_options,
            fiberModuleDetail, proteinModuleDetail);
      } else {
        print("1..${_value}");
        print("2..${startTime.text}");
        print("2..${startDate.text}");
        print("3..${mlPerHour.text}");
        print("4..${hourPerDay.text}");
        print("5..${mlCurrentWorkDay_indust.text}");

        // ShowMsg('Please complete Industrialized data.');
      }
    } else {
      //Manipulated

      if (!_value_manipulated.isNullOrBlank &&
          mlPerDose.text.isNotEmpty &&
          mlCurrentWorkDay_manipulated.text.isNotEmpty &&
          !_numberOfDayList.isNullOrBlank) {
        //  continue

        var data = _controller.industrialized
            .firstWhere((element) => element.sId == _value, orElse: () => null);
        var data2 = _controller.manipulated.firstWhere(
            (element) => element.sId == _value_manipulated,
            orElse: () => null);

        Map industdata = {
          "id": _value ?? '',
          "title": data?.title ?? '',
          "start_time": startTime.text,
          "start_date": startDate.text,
          "ml_hr": mlPerHour.text,
          "hr_day": hourPerDay.text,
          "current_work": mlCurrentWorkDay_indust.text,
          "second_interval_mlExpected": null,
          "first_interval_mlExpected": null,
          // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
          "lastUpdate": '${DateTime.now()}',
          "en_data": {
            "kcal": EnKcal,
            "protein": EnKPtn,
            "fiber": EnFiber,
            "fiber_module": getfiberModule.text,
            "protein_module": getproteinModule.text,
            "plan_ptn": plan_ptn.text,
            "plan_kcal": plan_kcal.text,
            "total_volume": total_volume.text,
          },
        };

        Map manidata = {
          "id": _value_manipulated ?? '',
          "title": data2?.title ?? '',
          "ml_dose": mlPerDose.text,
          "current_work": mlCurrentWorkDay_manipulated.text,
          "doses_data": _numberOfDayList,
          // "lastUpdate": '${DateTime.now().subtract(Duration(days: 1))}',
          "lastUpdate": '${DateTime.now()}',
          "en_data": {
            "kcal": EnKcal,
            "protein": EnKPtn,
            "fiber": EnFiber,
            "fiber_module": getfiberModule.text,
            "protein_module": getproteinModule.text,
            "plan_ptn": plan_ptn.text,
            "plan_kcal": plan_kcal.text,
            "total_volume": total_volume.text,
          },
        };

        Reduced_options reduced_options = Reduced_options(
            surgery_postOp: surgery_op.text,
            selected_reason: _infusedReason.text);

        getUpdatedNeedsData(industdata, manidata, reduced_options,
            fiberModuleDetail, proteinModuleDetail);
      } else {
        // ShowMsg('please_complete_manipulated_data'.tr);
      }
    }
  }

  getUpdatedNeedsData(Map indust, Map mani, Reduced_options reduced_options,
      ModuleDetail fiberModuleDetail, ModuleDetail ptnModuleDetail) async {
    // debugPrint('getUpdatedNeedsData fun calling');
    // print('indust data : ${jsonEncode(indust['current_work'])}');

    List<Needs> _needsData = await _sgController.savedData(
        widget.patientDetailsData,
        selectedIndexTeam,
        tab_industrialized ? 0 : 1,
        indust,
        mani,
        reduced_options,
        EnKcal,
        EnKPtn,
        EnFiber,
        fiberModuleDetail,
        ptnModuleDetail,
        getfiberModule.text,
        getproteinModule.text,
        double.tryParse(plan_ptn.text) ?? 0.0,
        double.tryParse(plan_kcal.text) ?? 0.0,
        double.tryParse(total_volume.text) ?? 0.0,
        //expected infuse is total vollume
        propofol.text,
        glucose.text,
        citrate.text,
        total.text,
        _controller.selectedData);

    widget.patientDetailsData.needs.clear();
    widget.patientDetailsData.needs.addAll(_needsData);
    setState(() {});
  }

  void clearAll() {
    selectedIndexTeam = -1;

    for (var a in listOptionTab) {
      setState(() {
        a.isSelected = false;
      });
    }

    _value = null;
    startTime.clear();
    startDate.clear();
    mlPerHour.clear();
    hourPerDay.clear();
    mlCurrentWorkDay_indust.clear();

    _value_manipulated = null;
    _numberOfDayList.clear();
    mlPerDose.clear();
    mlCurrentWorkDay_manipulated.clear();

    EnKcal = null;
    EnKPtn = null;
    EnFiber = null;

    getproteinModule.clear();
    getfiberModule.clear();

    propofol.clear();
    glucose.clear();
    citrate.clear();
    total.clear();
  }

  double previuosManipuatedMl = 0.0;

  void setAll() async {
    await _controller.getEnternalData(widget.patientDetailsData).then((res) {
      if (res != null) {
        selectedIndexTeam = res.teamIndex;
        res.tabIndex == 0
            ? tab_industrialized = true
            : tab_industrialized = false;
        if (res.teamIndex == 0) {
          listOptionTab[0].isSelected = true;
          listOptionTab[1].isSelected = false;
        } else {
          listOptionTab[0].isSelected = false;
          listOptionTab[1].isSelected = true;
        }

        if (!res.industrializedData.isNullOrBlank) {
          var dataa = _controller.industrialized.firstWhere(
              (element) => element.sId == res.industrializedData.id,
              orElse: () => null);
          _controller.selectedData = _controller.industrialized.firstWhere(
              (element) => element.sId == res.industrializedData.id,
              orElse: () => null);

          if (dataa != null) {
            _value = res.industrializedData.id.isNullOrBlank
                ? null
                : res.industrializedData.id;
            startTime.text = res.industrializedData.startTime;
            startDate.text = res.industrializedData.startDate;
            mlPerHour.text = res.industrializedData.mlHr;
            hourPerDay.text = res.industrializedData.hrDay;
            mlCurrentWorkDay_indust.text = res.industrializedData.currentWork;

            currentWork();
          }
        }

        if (!res.manipulatedData.isNullOrBlank) {
          var dataa = _controller.manipulated.firstWhere(
              (element) => element.sId == res.manipulatedData.id,
              orElse: () => null);

          if (dataa != null) {
            _value_manipulated = res.manipulatedData.id.isNullOrBlank
                ? null
                : res.manipulatedData.id;
            mlPerDose.text = res.manipulatedData.mlDose;
            // mlCurrentWorkDay_manipulated.text = res.manipulatedData.currentWork;

            if (!res.manipulatedData.dosesData.isNullOrBlank) {
              _numberOfDayList.clear();
              print('get doses number ${res.manipulatedData.dosesData.length}');
              for (var a in res.manipulatedData.dosesData) {
                NumberOfDays numberOfDays = NumberOfDays();
                numberOfDays.index = a.index;
                numberOfDays.hour = a.hour;
                numberOfDays.istoday = a.istoday;
                numberOfDays.timePerday = a.timePerday;
                numberOfDays.schdule_date = a.istoday
                    ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
                    : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

                _numberOfDayList.add(numberOfDays);
              }
            }
          }

          //  -----------------------------

          _controller
              .getCurrentManipulatedML(widget.patientDetailsData)
              .then((v) {
            previuosManipuatedMl = v;
            print('previously schduled mani mL : ${previuosManipuatedMl}');

            print(mlPerDose.text);
            print(v);

            _numberOfDayList.toSet();

            Future.delayed(const Duration(milliseconds: 500), () {
              _controller
                  .getManiplatedCurrentWork(_numberOfDayList, mlPerDose.text,
                      workday, previuosManipuatedMl)
                  .then((resp) {
                List<workRecord> data = [];
                data.addAll(resp);
                print('return : ${resp}');

                if (!resp.isNullOrBlank) {
                  mlCurrentWorkDay_manipulated.text = resp.first.totalwork;
                  manipulatedEn();
                } else {
                  mlCurrentWorkDay_manipulated.clear();
                  manipulatedEn();
                }

                setState(() {});
              });
            });
          });

          //  ------------------------------
        }

        if (!res.enData.isNullOrBlank) {
          print('scopee here');
          print('scopee here res.enData.kcal ${res.enData.kcal}');
          EnKcal = res.enData.kcal;
          EnKPtn = res.enData.protein;
          EnFiber = res.enData.fiber;
          fiberModuleDetail = res.enData.fiberModluleDetail;
          proteinModuleDetail = res.enData.protienModluleDetail;
          total_volume.text = res.enData.protienModluleDetail.total_vol;
          print("000.. ${total_volume.text}");

          getproteinModule.text = res.enData.proteinModule;
          getfiberModule.text = res.enData.fiberModule;
        }

        if (!res.reducesed_justification.isNullOrBlank) {
          _infusedReason.text = res.reducesed_justification.justification;
          surgery_op.text = res.reducesed_justification.surgery_postOp;
        }
      }
    });

    nonNutritionalKcalController
        .getNonNutritionalData(widget.patientDetailsData)
        .then((res) {
      if (!res.isNullOrBlank) {
        propofol.text = res.propofol;
        glucose.text = res.glucose;
        citrate.text = res.citrate;
        total.text = res.total;
      }
    });

    setState(() {});

    //  updated by akash on 25 May
    await Future.delayed(const Duration(seconds: 1), () {
      print('calling after 1 sec');
      currentWork();
    });
  }

  bool interrupted = false;

  Widget _currentWork() {
    return Column(
      children: [
        Center(
          child: Text(
            "current_work_day".tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Center(
            child: new FutureBuilder(
                future: _controller.getCurrentNextWorkDayDate(
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
        InkWell(
          onTap: () {
            _controller.calculateNeedData(
                widget.patientDetailsData,
                "type",
                double.parse(plan_ptn.text),
                double.parse(plan_kcal.text),
                double.parse(total_volume.text),
                getproteinModule.text);
          },
          child: Center(
            child: Text(
              "enteral_nutritional_formula".tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            text: "interrupt_enteral_nutrition".tr,
            myFunc: () async {
              interrupted = true;
              await clearAll();
              widget.patientDetailsData = await currentNeed.removeNeedObject(
                  widget.patientDetailsData, 'enteral');
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
                color:
                    tab_industrialized == true ? primary_color : Colors.white,
                child: Text("industrialized".tr,
                    style: TextStyle(
                        color: tab_industrialized == true
                            ? Colors.white
                            : primary_color)),
                onPressed: () {
                  setState(() {
                    tab_industrialized = true;
                    currentWork();
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
                color:
                    tab_industrialized == false ? primary_color : Colors.white,
                child: Text(
                  "manipulated".tr,
                  style: TextStyle(
                      color: tab_industrialized == false
                          ? Colors.white
                          : primary_color),
                ),
                onPressed: () {
                  setState(() {
                    tab_industrialized = false;
                    manipulatedEn();
                  });
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: 15.0,
        ),
        tab_industrialized == true
            ? Column(
                children: [
                  dropdownFormulas(_controller.industrialized, _value, (value) {
                    setState(() {
                      _value = value;
                      print('return value: $value');
                      currentWork();
                    });
                  }, context),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            startDateView(controller: startDate),
                            Spacer(),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "start_time".tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    print('hour: ${result?.hour}');
                                    print('min: ${result?.minute}');
                                    timePicker(context, result?.hour,
                                            result?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result = time;
                                      startTime.text =
                                          "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                                      print(result.minute);
                                      currentWork();
                                      Future.delayed(Duration(seconds: 1),
                                          () => onUpdateData());
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
                                        onChanged: (_value) {
                                          currentWork();
                                        },
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
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100.0,
                              height: 40.0,
                              child: texfld("mL/h", mlPerHour, () async {
                                print(mlPerHour);
                                await currentWork();
                                onUpdateData();
                              }),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'mL/h',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "volume".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 100.0,
                              height: 40.0,
                              child: texfld("hour_per_day".tr, hourPerDay,
                                  () async {
                                await currentWork();
                                onUpdateData();
                              }),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'hour_per_day'.tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "hours_of_infusion".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: mlCurrentWorkDay_indust,
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {
                                    print(mlCurrentWorkDay_indust);
                                  },
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'mL',
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
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'mL(${'current_work_day'.tr})',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            :

            //******************
            Column(
                children: [
                  dropdownFormulas(_controller.manipulated, _value_manipulated,
                      (value) {
                    setState(() {
                      _value_manipulated = value;
                      manipulatedEn();
                    });
                  }, context),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "volume".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              "number_of_doses".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 100.0,
                                  height: 40.0,
                                  child: texfld("mL/dose", mlPerDose, () {
                                    print(mlPerDose);
                                    _controller
                                        .getManiplatedCurrentWork(
                                            _numberOfDayList,
                                            mlPerDose.text,
                                            workday,
                                            previuosManipuatedMl)
                                        .then((resp) {
                                      List<workRecord> data = [];
                                      data.addAll(resp);
                                      print('return : ${resp}');

                                      if (!resp.isNullOrBlank) {
                                        mlCurrentWorkDay_manipulated.clear();
                                        mlCurrentWorkDay_manipulated.text =
                                            resp.first.totalwork;
                                        manipulatedEn();
                                      } else {
                                        mlCurrentWorkDay_manipulated.clear();
                                        manipulatedEn();
                                      }

                                      setState(() {});
                                    });
                                  }),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'mL/dose',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: Num_Doses,
                                  // enabled: enable,
                                  focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {},
                                  onTap: () {
                                    focus.unfocus();
                                    Get.to(NumberOfDoses(
                                      privousdata: _numberOfDayList,
                                    )).then((resp) {
                                      print('return number of doses : ${resp}');

                                      if (resp != null) {
                                        _numberOfDayList.clear();
                                        _numberOfDayList.addAll(resp);

                                        _controller
                                            .getManiplatedCurrentWork(
                                                _numberOfDayList,
                                                mlPerDose.text,
                                                workday,
                                                previuosManipuatedMl)
                                            .then((resp) {
                                          List<workRecord> data = [];
                                          data.addAll(resp);
                                          // print('return : ${resp[1].totalwork}');

                                          if (!resp.isNullOrBlank) {
                                            mlCurrentWorkDay_manipulated.text =
                                                resp.first.totalwork;
                                            manipulatedEn();
                                          } else {
                                            mlCurrentWorkDay_manipulated
                                                .clear();
                                            manipulatedEn();
                                          }

                                          setState(() {});
                                        });
                                      } else {
                                        mlCurrentWorkDay_manipulated.clear();
                                        manipulatedEn();
                                        setState(() {});
                                      }
                                    });
                                  },
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'number_of_doses'.tr,
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
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: mlCurrentWorkDay_manipulated,
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {
                                    print(mlCurrentWorkDay_manipulated);
                                  },
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'mL',
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
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              'mL(${'current_work_day'.tr})',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
      ],
    );
  }

  Widget startDateView({TextEditingController controller}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "start_date".tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        InkWell(
          onTap: () {
            var getDate = TextEditingController();
            getDate.text =
                '${DateFormat(commonDateFormat).format(DateTime.now())}';
            calenderWidget(context, getDate, () async {
              controller.text = getDate.text;

              currentWork();
              Future.delayed(Duration(seconds: 1), () => onUpdateData());
              setState(() {});
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

  EnteralData _data;
  IndustrializedData _IndustdataLast;
  ManipulatedData _ManidataLast;

  isLastPresent() async {
    var workday;
    await getWorkingDays(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      workday = value;
    });

    await _controller.getEnternalData(widget.patientDetailsData).then((resp) {
      if (resp != null) {
        for (var a in resp.industDetailsData) {
          var _todaydate = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
          var _yesterdaydate = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

          var _lastDate = DateTime.parse(a.lastUpdate);

          print('------------dates data-----------------');
          print(_todaydate);
          print(_yesterdaydate);
          print(_lastDate);
          print(_lastDate.isAfter(_yesterdaydate) &&
              _lastDate.isBefore(_todaydate));

          if (_lastDate.isAfter(_yesterdaydate) &&
              _lastDate.isBefore(_todaydate)) {
            _data = resp;
            _IndustdataLast = a;

            break;
          }
        }

        for (var a in resp.maniDetailsData) {
          var _todaydate = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
          var _yesterdaydate = DateTime.parse(
              '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

          var _lastDate = DateTime.parse(a.lastUpdate);

          print('------------dates data-----------------');
          print(_todaydate);
          print(_yesterdaydate);
          print(_lastDate);
          print(_lastDate.isAfter(_yesterdaydate) &&
              _lastDate.isBefore(_todaydate));

          if (_lastDate.isAfter(_yesterdaydate) &&
              _lastDate.isBefore(_todaydate)) {
            _data = resp;
            _ManidataLast = a;

            break;
          }
        }

        // for(var a in resp.lastSelected){
        //
        //   var _todaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
        //   var _yesterdaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');
        //
        //   if(DateTime.parse(a.date).isAfter(_yesterdaydate) && DateTime.parse(a.date).isBefore(_todaydate)){
        //
        //     lastIndex = int.parse(a.index);
        //
        //   }
        //
        // }
      }
      // _data = resp;
    });
  }
}

Widget dropdownFormulas(
    List<Industrialized> listofItems, var val, Function func, var context) {
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
              value: val,
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

//for another purpose
Widget dropdown(
    List<staticList> listofItems, var vlu, Function func, var context) {
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
              hint: Text('select_drug'.tr),
              value: vlu,
              items: listofItems
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text('${e.optionText}'),
                      value: '${e.optionText}',
                    ),
                  )
                  .toList(),
              onChanged: func),
        ),
      ),
    ),
  );
}
