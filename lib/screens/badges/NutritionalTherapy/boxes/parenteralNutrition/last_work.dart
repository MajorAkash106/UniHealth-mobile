import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/infusion_parenteral.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion_report_screen.dart';
import 'package:medical_app/screens/blank_screen_loader.dart';

class LastWorkP extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  // Function accessFluid;
  TextEditingController infusedReason;
  TextEditingController surgery_postop;
  Function accessFluid;
  TextEditingController is_alertEnabled = TextEditingController();
  TextEditingController is_lastPresent = TextEditingController();
  LastWorkP({this.patientDetailsData, /*this.accessFluid,*/ this.infusedReason,this.surgery_postop,this.accessFluid,this.is_alertEnabled,this.is_lastPresent});
  @override
  _LastWorkPState createState() => _LastWorkPState();
}

class _LastWorkPState extends State<LastWorkP> {
  final EnteralNutritionalController _encontroller =
      EnteralNutritionalController();
  final ParenteralNutrional_Controller parenteralNutrional_Controller =
      ParenteralNutrional_Controller();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.computeData();
    getInfusion();
  }

  String infusion;
  double per = 0.0;
  getInfusion() async {
    infusion = await parenteralNutrional_Controller
            .computeCurrentWorkPrevious(widget.patientDetailsData) ??
        null;

    if (infusion != null) {
      per = double.parse(infusion) * 80 / 100;
      widget.is_lastPresent.text = 'yes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return infusion == null
        ? SizedBox()
        : Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "last_work_day".tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      new FutureBuilder(
                          future: _encontroller.getLastWorkDayDate(
                              widget.patientDetailsData.hospital.first.sId),
                          initialData: '',
                          builder: (context, AsyncSnapshot<String> snapshot) {
                            String data = snapshot.data;
                            return Text(
                              "$data",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            );
                          })
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                  text:
                  "access_parenteral_nutrition_report".tr,
                  myFunc: () {
                    print('kk');
                    Get.to(InfusionReport(title: 'Parenteral Nutrition/Modules Infusion',patientDetailsData: widget.patientDetailsData,formula_status: "parenteral",isFromPn: true,type: "Parenteral Nutrition",isFromEn: false,)).then((value) {
                      print('activity ${value}');
                      if (value!=null&&value ) {

                        Get.to(BlankScreen(
                          function: () {
                            final PatientSlipController
                            _patientSlipController =
                            PatientSlipController();

                            _patientSlipController
                                .getDetails(
                                _patientSlipController.patientDetailsData[0].sId,
                                0)
                                .then((val) {
                              Get.to(ParenteralNutritionScreen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
                            });
                          },
                        ));
                      }
                    });
                    // Get.to(INFUSION());
                  },
                ),
              ),
              Text("Infused/Prescribed"),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Parenteral Nutrition',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 160,
                    child:  RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(15.0),
                      onPressed: () {
                        if (nutrition_in < per || nutrition_in == 0.0) {
                          Get.to(INFUSION(
                            selctedText: widget.infusedReason.text,
                            selected_surgery_op: widget.surgery_postop.text,
                          )).then((res) {
                            if (res != null) {
                              print('retuen INFUSION : $res');
                              Reduced_options d = res;
                              widget.infusedReason.text = d.selected_reason;
                              widget.surgery_postop.text = d.surgery_postOp;
                              setState(() {});
                            }
                          });
                        }
                      },
                      color: primary_color,
                      textColor: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Text("${nutrition_in}/${infusion} ml",
                            style: TextStyle(fontSize: 13)),
                        _infused()
                      ],),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              // Container(
              //     margin: EdgeInsets.only(top: 10),
              //     child: CustomButton(
              //       myFunc: () {
              //         widget.accessFluid();
              //       },
              //       text: 'Access Fluid Balance',
              //     )),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 3.0,
                color: Colors.black12,
                thickness: 2,
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          );
  }

  Widget _infused() {
    if (nutrition_in < per || nutrition_in == 0.0) {
      widget.is_alertEnabled.text ="true";
      return Icon(
        Icons.warning_amber_outlined,
        color: Colors.yellow,
        size: 18,
      );
    } else {
      widget.is_alertEnabled.text ="false";
      return SizedBox();
    }
  }

  void computeData() async {
    List<vigi_resultData> data = [];
    await getFluidBalanace(widget.patientDetailsData).then((resp) {
      if (resp != null) {
        for (var a in resp.result[0].data) {
          if (a.item.toLowerCase().contains('enteral'.toLowerCase())) {
            print('yre');

            data.add(a);
          }
        }
      }
    });
    print('enteral related list : ${jsonEncode(data)}');
    List<vigi_resultData> nutrition = [];

    for (var a in data) {
      if (a.item.toLowerCase().removeAllWhitespace == 'parenteralnutrition') {
        nutrition.add(a);
      }
    }

    print('nutrition : ${jsonEncode(nutrition)}');
    filterData(nutrition);
  }

  double nutrition_in = 0.0;
  double nutrition_out = 0.0;

  double ptn_in = 0.0;
  double ptn_out = 0.0;

  double fiber_in = 0.0;
  double fiber_out = 0.0;

  void filterData(
    List<vigi_resultData> nutritional,
    // List<Data> fiber,
    // List<Data> ptn,
  ) async {
    var workday;
    await getWorkingDays(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      workday = value;
    });

    var _todaydate = DateTime.parse(
        '${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
    var _yesterdaydate = DateTime.parse(
        '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

    //for nutritional
    for (var a in nutritional) {
      print('date :---------  ${a.date} ${a.time}:00');

      var eventDate = DateTime.parse("${a.date} ${a.time}:00");
      print(eventDate);

      print("${eventDate.isAfter(_yesterdaydate)}");

      if (eventDate.isAfter(_yesterdaydate) && eventDate.isBefore(_todaydate)) {
        if (a.intOut == '0') {
          print('nutrition in : ${a.ml}');
          nutrition_in = nutrition_in + double.parse(a.ml);
        } else {
          nutrition_out = nutrition_out + double.parse(a.ml);
        }
      }
    }

    print('nutrition in ${nutrition_in} nutrition out ${nutrition_out}');

    setState(() {});
  }

  // gettingLast(PatientDetailsData data)async{
  //
  //   List<ParenteralData> previous = await parenteralNutrional_Controller.getParenteralList(data);
  //   var _todaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
  //   var _yesterdaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');
  //   if(previous != null && previous.isNotEmpty){
  //
  //     for(var a in previous){
  //
  //
  //
  //     }
  //
  //   }
  //
  //
  // }

}
