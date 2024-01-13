// import 'package:flutter/material.dart';
// import 'package:medical_app/config/widgets/common_appbar.dart';
//
// class InfusionReport extends StatefulWidget {
//   final String title;
//   InfusionReport({this.title});
//   @override
//   _InfusionReportState createState() => _InfusionReportState();
// }
//
// class _InfusionReportState extends State<InfusionReport> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BaseAppbar('${widget.title}', null),
//       body: Container(),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/calender_widget.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusionReport_Controller.dart';
import 'package:medical_app/contollers/NutritionalTherapy/infusionSheet.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/oral_aaceptance_box/diet_report_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/EnteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusionReportModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusionReportModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';

import '../../../blank_screen_loader.dart';

// import 'infusionReportModel.dart';

class InfusionReport extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final formula_status;
  final String title;
  final String type;
  final bool isFromEn;
  final bool isFromPn;
  final bool activity;
  InfusionReport(
      {this.patientDetailsData,
      this.title,
      this.formula_status,
      this.isFromEn,
      this.type,
      this.activity,
      this.isFromPn});

  @override
  _InfusionReportState createState() => _InfusionReportState();
}

class _InfusionReportState extends State<InfusionReport> {
  InfusionReportController _controller = InfusionReportController();
  final BalanceSheetController balanceSheetController =
      BalanceSheetController();

  // final String jsonSample =
  //     '[{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"}]';
  bool toggle = true;

  List<String> heading = [
    'type'.tr,
    'name'.tr,
    'interval'.tr,
    'expected_vol'.tr,
    'infused_vol'.tr
  ];
  // List<String> eventItem = [
  //   // 'NG Tube',
  //   // 'IV Fluids',
  //   // 'Urine',
  //   // 'ENTERAL N',
  //   // 'ENTERAL P',
  //   // 'ENTERAL F',
  //   // 'Parenteral N',
  //   // 'Glucose 5%',
  //   // 'Glucose 10%',
  //   // 'Glucose 5% + NaCl 0,9%',
  //   // 'Propofol',
  //   // 'Drain',
  //   // 'Stoma'
  //   "Enteral Nutrition",
  //   "Parenteral Nutrition",
  //   "Enteral Protein Module",
  //   "Enteral Fiber Module",
  //   "Glucose 5%",
  //   "Glucose 10%",
  //   "Glucose 5% + NaCl 0,9%",
  //   "Propofol",
  //   "Other IV fluids",
  //   "Urine",
  //   "Nasogastric Tube",
  //   "Drain",
  //   "Stoma",
  // ];

  final PatientSlipController patientSlipController = PatientSlipController();
  // final BalanceSheetController balanceSheetController =
  // BalanceSheetController();

  List<INOUT> inout = <INOUT>[
    INOUT('In', false),
    INOUT('Out', false),
  ];
  int selectedIndex = 0;

  String _value;
  var _date = TextEditingController();
  DateTime startTime;

  @override
  void initState() {
    getDateTimeWithWorkdayHosp(widget.patientDetailsData.hospital.first.sId,
            DateTime.now().subtract(Duration(days: 1)))
        .then((value) => {startTime = value});
    super.initState();
  }

  // getData() {
  //   print("value.data[0].date");
  //   Future.delayed(const Duration(milliseconds: 0), () {
  //     patientSlipController.getDetails(widget.patientDetailsData.sId, 0)
  //         .then((val) {});
  //
  //     _controller.getInfusionReport(widget.patientDetailsData.sId,widget.formula_status,context).then((value) {
  //       print(value.data[0].date);
  //       print("value.data[0].date");
  //     });
  //   });
  // }

  bool activity = false;
  Future<bool> _willPopScope() {
    if (widget.isFromEn != null && widget.isFromEn) {
      Get.off(EnteralNutritionScreen(
        patientDetailsData: widget.patientDetailsData,
      ));
    } else if (widget.isFromPn != null && widget.isFromPn) {
      Get.off(ParenteralNutritionScreen(
        patientDetailsData: widget.patientDetailsData,
      ));
    } else {
      Get.off(DietReport_Screen(patientDetailsData: widget.patientDetailsData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: BaseAppbar('${widget.title}', null),
            body:
                // Obx(() => patientSlipController.patientDetailsData.isNullOrBlank
                //     ? SizedBox()
                //     :
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ListView(
                              // shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: FutureBuilder(
                                      future: _controller.getRouteForMode(
                                          widget.patientDetailsData.sId,
                                          widget.formula_status,
                                          context,
                                          widget.patientDetailsData.hospital
                                              .first.sId),
                                      initialData: null,
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        InfusionReportModel infusionData =
                                            snapshot.data;
                                        List<Formula> report_list = [];
                                        // List<Formula> reversed_report_list =[];
                                        if (infusionData != null) {
                                          for (int i = 0;
                                              i < infusionData.data.length;
                                              i++) {
                                            for (int j = 0;
                                                j <
                                                    infusionData
                                                        .data[i].formula.length;
                                                j++) {
                                              report_list.add(infusionData
                                                  .data[i].formula[j]);
                                            }
                                          }
                                          print("jsonEncode(report_list)");
                                          print(jsonEncode(report_list.length));

                                          // for (var a in report_list.reversed){
                                          //   reversed_report_list.add(a);
                                          // }
                                          //  report_list.sort((a,b) => DateTime.parse(a.start_interval).compareTo(DateTime.parse(b.start_interval)));
                                          // report_list.sort((a, b) {
                                          //   var adate = DateTime.parse(a
                                          //       .start_interval); //before -> var adate = a.expiry;
                                          //   var bdate = DateTime.parse(b
                                          //       .start_interval); //var bdate = b.expiry;
                                          //   return adate.compareTo(bdate);
                                          // });
                                        }

                                        return infusionData == null
                                            ? Container(
                                                height: Get.height / 2,
                                                width: Get.width,
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()))
                                            : infusionData.data.isEmpty
                                                ? Table(
                                                    defaultColumnWidth:
                                                        FixedColumnWidth(
                                                            Get.width / 6.1),
                                                    border: TableBorder.all(
                                                        color: Colors.black,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1),
                                                    children: [
                                                      TableRow(
                                                          children: heading
                                                              .map((e) =>
                                                                  Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          child: Text(
                                                                              '$e',
                                                                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                                                        )
                                                                      ]))
                                                              .toList()),

                                                      // TableRow()
                                                    ],
                                                  )
                                                : Table(
                                                    // defaultColumnWidth: FixedColumnWidth(Get.width / 5),
                                                    columnWidths: {
                                                      0: FlexColumnWidth(
                                                          Get.width / 8),
                                                      1: FlexColumnWidth(
                                                          Get.width / 7),
                                                      2: FlexColumnWidth(
                                                          Get.width / 7),
                                                      3: FlexColumnWidth(
                                                          Get.width / 10),
                                                      4: FlexColumnWidth(
                                                          Get.width / 10)
                                                    },
                                                    border: TableBorder.all(
                                                        color: Colors.black,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 1),
                                                    children: [
                                                      TableRow(
                                                          children: heading
                                                              .map((e) =>
                                                                  Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.all(8),
                                                                          child: Text(
                                                                              '$e',
                                                                              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                                                        )
                                                                      ]))
                                                              .toList()),
                                                      // ...infusionData
                                                      //     ?.data?.first.formula.
                                                      ...report_list
                                                          .map((e) => e == null
                                                              ? TableRow()
                                                              : TableRow(
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    // color: e.formula.first.infusedVol=="0.0"?Colors.red.shade100:Colors.orange.shade50,
                                                                    color: Colors
                                                                        .orange
                                                                        .shade50,
                                                                  ),
                                                                  children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          print(
                                                                              startTime);
                                                                          // selectRow(e.formula.first,edited_ml.text);
                                                                          // tempController= TextEditingController(text: e.value);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Container(height: 65, child: Center(child: Text(getType(e.type) ?? ""))),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          // selectRow(e.formula.first,edited_ml.text);
                                                                          // tempController= TextEditingController(text: e.value);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Container(height: 65, child: Center(child: Text(e.formulaName ?? ""))),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          // selectRow(e.formula.first,edited_ml.text);
                                                                          print(infusionData
                                                                              .data[0]
                                                                              .formula
                                                                              .length);

                                                                          // selectRow(e,0,tempController= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',initialValue: double.parse(e.value),precision: 1));
                                                                          // tempController= TextEditingController(text: e.value);
                                                                        },
                                                                        child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Container(
                                                                                    height: 75,
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                                                      children: [
                                                                                        Center(
                                                                                            child: Text(
                                                                                          '${DateFormat(commonDateFormat).format(DateTime.parse(e.start_interval))}  (${DateFormat('HH:mm').format(DateTime.parse(e.start_interval))})',
                                                                                          style: TextStyle(fontSize: 12),
                                                                                        )),
                                                                                        Text('to', style: TextStyle(fontSize: 12)),
                                                                                        Center(child: Text("${DateFormat(commonDateFormat).format(DateTime.parse(e.end_interval))} (${DateFormat('HH:mm').format(DateTime.parse(e.end_interval))})", style: TextStyle(fontSize: 12))),
                                                                                      ],
                                                                                    )),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      // InkWell(
                                                                      //   onTap: () {
                                                                      //     // selectRow(e.formula.first,edited_ml.text);
                                                                      //     print(infusionData.data[0].formula.length);
                                                                      //     // selectRow(e,0,tempController= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',initialValue: double.parse(e.value),precision: 1));
                                                                      //     // tempController= TextEditingController(text: e.value);
                                                                      //   },
                                                                      //   child: Column(children: [
                                                                      //     Padding(
                                                                      //       padding: EdgeInsets.all(8),
                                                                      //       child: Container(
                                                                      //           height: 40,
                                                                      //           child: Center(child: Text(e.formula.first.time??""))),
                                                                      //     )
                                                                      //   ]),
                                                                      // ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          // selectRow(e.formula.first,edited_ml.text);
                                                                          // selectRow(e,0,tempController= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',initialValue: double.parse(e.value),precision: 1));
                                                                          // print(tempController.text);

                                                                          // tempController= TextEditingController(text: e.value);
                                                                          // tempController= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',initialValue: double.parse(e.value));
                                                                          // print(tempController.text);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(padding: EdgeInsets.all(8), child: Container(height: 40, child: Center(child: Text(e.expectedVol ?? "")))
                                                                                  // Text( formatter.format( double.parse(e.value??"")))
                                                                                  // NumberFormat('#,##,000')

                                                                                  //Text(double.parse(e.value??"").toString()??""),
                                                                                  )
                                                                            ]),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          // selectRow(e.formula.first,edited_ml.text);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                  padding: EdgeInsets.all(8),
                                                                                  child: FutureBuilder(
                                                                                      initialData: null,
                                                                                      future: _controller.getinfused_BetweenIntervalsReport(widget.patientDetailsData, e.type, DateTime.parse(e.start_interval), DateTime.parse(e.end_interval)), //getInfusedVol(widget.patientDetailsData,e.type, e.date, e.time,),
                                                                                      builder: (context, AsyncSnapshot snapshot) {
                                                                                        edited_ml = TextEditingController(text: snapshot?.data?.toString());
                                                                                        // if (snapshot.data != null) {
                                                                                        adLog('snapshot.data :${snapshot.data}');

                                                                                          return InkWell(
                                                                                            child: Container(
                                                                                                height: 40,
                                                                                                // width:Get.width / 6,
                                                                                                // color: Colors.green,
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  snapshot.data == null ? "report".tr : snapshot.data.toString(),
                                                                                                  style: TextStyle(color: snapshot.data == null ? Colors.red : Colors.black, fontWeight: snapshot.data == null ? FontWeight.bold : null),
                                                                                                ))),
                                                                                            onTap: () {
                                                                                              snapshot.data== null ? selectRow(e, "0", 0) : selectRow(e, snapshot.data.toString(), 1);
                                                                                            },
                                                                                          );
                                                                                        // } else {
                                                                                        //   return SizedBox();
                                                                                        // }
                                                                                      })
                                                                                  // Text( e.formula.first.infusedVol=="0.0"?"report":e.formula.first.infusedVol??"")
                                                                                  // Text( formatter.format( double.parse(e.value??"")))
                                                                                  // NumberFormat('#,##,000')

                                                                                  //Text(double.parse(e.value??"").toString()??""),
                                                                                  )
                                                                            ]),
                                                                      ),
                                                                    ]))
                                                          .toList()
                                                    ],
                                                  );
                                      }),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   width: Get.width,
                        //   child: CustomButton(
                        //     text: "Confirm",
                        //     myFunc: () {
                        //
                        //       // if (!_value.isNullOrBlank &&
                        //       //     !ml.text.isNullOrBlank) {
                        //       //   focus.unfocus();
                        //       //   activity = true;
                        //       //   balanceSheetController
                        //       //       .onSaved(
                        //       //       patientSlipController
                        //       //           .patientDetailsData[0],
                        //       //       _value,
                        //       //       datee,
                        //       //       selectedIndex,
                        //       //       ml)
                        //       //       .then((value) {
                        //       //     refresh();
                        //       //   });
                        //       // } else {
                        //       //   ShowMsg('All fields are manedatory.');
                        //       // }
                        //     },
                        //   ),
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ))
            // )
            ),
        onWillPop: _willPopScope);
  }

  String getType(String type){
   return type.replaceAll(' ', '_').toLowerCase().tr;
  }

  var ml = TextEditingController();
  FocusNode focus = FocusNode();
  var datee = TextEditingController(
      text: '${DateFormat(commonDateFormat).format(DateTime.now())}');

  // Widget _addWidget(String text) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         Align(
  //           alignment: Alignment.topLeft,
  //           child: Text(
  //             '$text',
  //             style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 17.0),
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Container(
  //               decoration: BoxDecoration(
  //                 // color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   border: Border.all(
  //                     color: Colors.black26,
  //                     width: 1,
  //                   )),
  //               height: 45.0,
  //               width: Get.width / 2,
  //               child: Padding(
  //                 padding: const EdgeInsets.only(left: 15.0, right: 15.0),
  //                 child: DropdownButtonHideUnderline(
  //                   child: DropdownButton(
  //                       style: TextStyle(
  //                           color: Colors.black,
  //                           fontSize: 12.0,
  //                           fontWeight: FontWeight.normal),
  //                       iconEnabledColor: Colors.black,
  //                       // isExpanded: true,
  //                       iconSize: 18.0,
  //                       dropdownColor: Colors.white,
  //                       hint: Text('Select Item'),
  //                       value: _value,
  //                       items: eventItem
  //                           .map(
  //                             (e) => DropdownMenuItem(
  //                           child: Text('${e}'),
  //                           value: '${e}',
  //                         ),
  //                       )
  //                           .toList(),
  //                       onChanged: (value) {
  //                         // times.clear();
  //                         setState(() {
  //                           _value = value;
  //                           print(_value);
  //                         });
  //                       }),
  //                 ),
  //               ),
  //             ),
  //             Container(
  //                 width: Get.width / 3.2,
  //                 height: 45.0,
  //                 child: TextField(
  //                   controller: ml,
  //                   // enabled: enable,
  //                   focusNode: focus,
  //                   keyboardType: TextInputType.numberWithOptions(),
  //                   onChanged: (_value) {
  //                     // _fun();
  //                   },
  //                   style: TextStyle(fontSize: 12),
  //                   decoration: InputDecoration(
  //                     // hintText: hint,
  //                     border: new OutlineInputBorder(
  //                       //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
  //                         borderSide: BorderSide(
  //                             color: Colors.white,
  //                             width: 0.0) //This is Ignored,
  //                     ),
  //                     hintStyle: TextStyle(
  //                         color: black40_color,
  //                         fontSize: 9.0,
  //                         fontWeight: FontWeight.bold),
  //                   ),
  //                 )),
  //             Text('mL',
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 17.0)),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             // Container(
  //             //   height: 45.0,
  //             //   width: Get.width / 2,
  //             // ),
  //             InkWell(
  //               onTap: () {
  //                 var getDate = TextEditingController();
  //                 getDate.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
  //                 calenderWidget(
  //                   context,
  //                   getDate,
  //                       () async {
  //                     print('press');
  //                     print('return date: ${getDate.text}');
  //                     datee.text = getDate.text;
  //                     setState(() {});
  //                   },
  //                   'Cumulative fluid balance from',
  //                   '${DateFormat(commonDateFormat).format(DateTime.now())}',
  //                 );
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   // color: Colors.white,
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     border: Border.all(
  //                       color: Colors.black26,
  //                       width: 1,
  //                     )),
  //                 height: 45.0,
  //                 width: Get.width / 2,
  //                 child: Center(
  //                   child: Text('${datee.text}'),
  //                 ),
  //               ),
  //             ),
  //             slider_tab(),
  //             Text('     ',
  //                 style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 17.0)),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget slider_tab() {
  //   return Container(
  //     height: 45.0,
  //     width: Get.width / 3.0,
  //     decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
  //     child: ListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         shrinkWrap: true,
  //         itemCount: inout.length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //             padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 1.0),
  //             child: InkWell(
  //               child: Container(
  //                 width: 58,
  //                 height: 45.0,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   color: selectedIndex == index
  //                       ? Colors.white
  //                       : Colors.transparent,
  //                 ),
  //                 child: Center(
  //                     child: Text(
  //                       inout[index].text,
  //                       style: TextStyle(
  //                           color: selectedIndex == index
  //                               ? selectedIndex == 0
  //                               ? Colors.green
  //                               : Colors.red
  //                               : Colors.black26),
  //                     )),
  //               ),
  //               onTap: () {
  //                 // print('selected: ${data.seletecIndex}');
  //                 selectedIndex = index;
  //                 print(selectedIndex);
  //                 // data.per = prcnt_list[index].prcnt_text;
  //
  //                 // if()
  //
  //                 setState(() {});
  //               },
  //             ),
  //           );
  //         }),
  //   );
  // }

  selectRow(Formula data, String infused_vol, int add_editFlag) {
    print('tapped data : ${data}');
    focus.unfocus();

    // _value2 = data.data.first.formula;
    // edited_ml.text = data.infusedVol;
    if (infused_vol == '0.0') {
      edited_ml = TextEditingController(text: infused_vol);
      edited_ml.clear();
    } else {
      edited_ml = TextEditingController(text: infused_vol);
      // edited_ml.clear();
      // selectedIndex2 = int.parse(data.intOut);
    }
    onEdit(data, add_editFlag, infused_vol);
  }

  refresh() {
    patientSlipController
        .getDetails(widget.patientDetailsData.sId, 0)
        .then((value) {
      _value = null;
      ml.clear();
      selectedIndex = 0;
    });
  }

  var edited_ml = TextEditingController();
  String _value2;
  int selectedIndex2 = 0;

  onEdit(Formula data, int add_editFlag, String infusedVol) {
    // String datee = data.date;
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    // padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                ' ${'report'.tr} : ' + '${data.type}'.replaceAll(' ', '_').toLowerCase().toString().tr,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              ),
                            ),
                            //                       InkWell(
                            //                         child: Container(child: Row(
                            //                           children: [
                            //                             Text("Edit",style: TextStyle(color: Colors.blue,fontSize: 13),),
                            //                             Icon(Icons.arrow_forward_rounded,color: Colors.blue,)
                            //                           ],
                            //                         ),),
                            //                         onTap: () async{
                            //                           Get.back();
                            //                           Get.to(InfusionSheet(patientDetailsData: widget.patientDetailsData,isFromEn: widget.isFromEn==true?true:false,date: data.date,time: data.time,type: widget.type,isFromPn: widget.isFromPn==true?true:false,title: widget.type,)).then((value) {
                            //                             print('activity ${value}');
                            //                             if (value) {
                            //
                            //                               Get.to(BlankScreen(
                            //                                 function: () {
                            //                                   final PatientSlipController
                            //                                   _patientSlipController =
                            //                                   PatientSlipController();
                            //
                            //                                   _patientSlipController
                            //                                       .getDetails(
                            //                                       widget.patientDetailsData.sId,
                            //                                       0)
                            //                                       .then((val) {
                            //                                     Get.off(InfusionReport(title: widget.title,patientDetailsData: _patientSlipController.patientDetailsData[0],formula_status: widget.formula_status,isFromEn: widget.isFromEn?true:false,type: widget.type,isFromPn: widget.isFromPn?true:false));
                            //                                   });
                            //                                 },
                            //                               ));
                            //                             }
                            //                           });
                            // // await  _controller.getInfusionSheet(widget.patientDetailsData, "Enteral Nutrition", data.date,data.time);
                            //                         },
                            //                       ) ,
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data.formulaName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0))
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(data.date,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.0))
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("expected_vol".tr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                    SizedBox(
                                      width: 30.0,
                                    ),
                                    Text(data.expectedVol),
                                    Text('  mL',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("infused_vol".tr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                    SizedBox(
                                      width: 40.0,
                                    ),
                                    Container(
                                        width: Get.width / 3.2,
                                        height: 45.0,
                                        child: TextField(
                                          onTap: () {
                                            edited_ml.clear();
                                          },
                                          controller: edited_ml,
                                          readOnly: false,
                                          // enabled: false,
                                          //focusNode: focus,
                                          keyboardType:
                                              TextInputType.numberWithOptions(),
                                          onChanged: (_value) {
                                            print(edited_ml.text);
                                            // edited_ml = _value;
                                          },
                                          style: TextStyle(fontSize: 12),
                                          decoration: InputDecoration(
                                            hintText: '',
                                            border: new OutlineInputBorder(
                                                //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                                borderSide: BorderSide(
                                                    color: Colors.white,
                                                    width:
                                                        0.0) //This is Ignored,
                                                ),
                                            hintStyle: TextStyle(
                                                color: black40_color,
                                                fontSize: 9.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )),
                                    Text('  mL',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: Get.width / 1.5,
                            child: CustomButton(
                              text: "confirm".tr,
                              myFunc: () async {
                                Get.back();
                                if (widget.type == "Enteral Nutrition") {
                                  print(widget.type);
                                  print(data.date);
                                  print(edited_ml.text);
                                  var d =
                                      double.parse(edited_ml.text) * 75 / 100;
                                  print(DateTime.parse(data.date)
                                      .add(Duration(days: 1)));
                                  // print(DateFormat(commonDateFormat).format(DateTime.parse(data.date).add(Duration(days: 1))));
                                  if (edited_ml != null && edited_ml.text != '0.0') {
                                    if (add_editFlag == 0) {
                                      //********** if part is for add ******
                                      balanceSheetController
                                          .onSaved(
                                              widget.patientDetailsData,
                                              data.type,
                                              TextEditingController(
                                                  text: DateFormat(
                                                          commonDateFormat)
                                                      .format(DateTime.parse(
                                                          data.end_interval))),
                                              DateFormat('HH:mm').format(
                                                  DateTime.parse(
                                                          data.end_interval)
                                                      .subtract(Duration(
                                                          minutes: 1))),
                                              0,
                                              TextEditingController(
                                                  text: d.toString()))
                                          .then((value) //=> refresh()
                                              {
                                        Get.to(BlankScreen(
                                          function: () {
                                            // final PatientSlipController
                                            //     _patientSlipController =
                                            //     PatientSlipController();
                                            //
                                            // _patientSlipController.getDetails(widget.patientDetailsData.sId, 0).then((val) {
                                            //   Get.off(InfusionReport(
                                            //       title: widget.title,
                                            //       patientDetailsData:
                                            //           _patientSlipController
                                            //                   .patientDetailsData[
                                            //               0],
                                            //       formula_status:
                                            //           widget.formula_status,
                                            //       isFromEn: widget.isFromEn
                                            //           ? true
                                            //           : false,
                                            //       type: widget.type,
                                            //       isFromPn: widget.isFromPn
                                            //           ? true
                                            //           : false));
                                            // });

                                            balanceSheetController.refreshInfusionSheet(widget.patientDetailsData.sId, widget.title, widget.formula_status, widget.isFromEn, widget.isFromPn, widget.type,widget.patientDetailsData.hospital.first.sId);

                                          },
                                        ));
                                      });
                                    } else {
                                      //********** else part is for edit ******

                                      var v; //= double.parse(infusedVol)*75/100;
                                      var d; //= v;
                                      if (data.type == "Enteral Nutrition") {
                                        v = double.parse(infusedVol) * 75 / 100;
                                        d = v;
                                      } else {
                                        v = double.parse(infusedVol);
                                        d = v;
                                      }
                                      var old; // = vigi_resultData(item: data.type,date:  DateFormat(commonDateFormat).format(DateTime.parse(data.date).add(Duration(days: 1))).toString(),time: DateFormat('HH:mm').format(startTime.subtract(Duration(minutes: 1))).toString(),intOut:'0',ml: d.toInt().toString());
                                      print("flag... ${add_editFlag}");
                                      await getFluidBalanace(
                                              widget.patientDetailsData)
                                          .then((val) {
                                        if (val != null) {
                                          print(
                                              "alll... ${jsonEncode(val.result[0].data)}");
                                          var p_data = vigi_resultData(
                                              item: data.type,
                                              date: DateFormat(commonDateFormat)
                                                  .format(DateTime.parse(
                                                      data.end_interval)),
                                              time: DateFormat('HH:mm').format(
                                                  DateTime.parse(
                                                          data.end_interval)
                                                      .subtract(Duration(
                                                          minutes: 1))),
                                              intOut: '0',
                                              ml: d.toString());

                                          for (var a in val.result[0].data) {
                                            print(jsonEncode(a));
                                            print(jsonEncode(vigi_resultData(
                                                item: data.type,
                                                date: DateFormat(commonDateFormat).format(DateTime.parse(data.end_interval)),
                                                time: DateFormat('HH:mm').format(DateTime.parse(data.end_interval).subtract(Duration(
                                                            minutes: 1))),
                                                intOut: '0',
                                                ml: d.toString())));
                                            if (a.date == p_data.date &&
                                                a.time == p_data.time &&
                                                a.item == p_data.item &&
                                                double.parse(a.ml) ==
                                                    double.parse(p_data.ml) &&
                                                a.intOut == p_data.intOut) {
                                              print("mached");
                                              old = a;
                                            } else {
                                              print(" not mached");
                                            }
                                          }
                                        }
                                      });

                                      var editedvalue =
                                          double.parse(edited_ml.text) *
                                              75 /
                                              100;

                                      // vigi_resultData previous_data =  vigi_resultData(item: data.type,date:  DateFormat(commonDateFormat).format(DateTime.parse(data.end_interval)),time: DateFormat('HH:mm').format(DateTime.parse(data.end_interval).subtract(Duration(minutes: 1))),intOut:'0',ml: d.toString());
                                      // print("ppData>>${jsonEncode(previous_data)}");

                                      balanceSheetController
                                          .onEdit(
                                              widget.patientDetailsData,
                                              data.type,
                                              TextEditingController(
                                                  text: DateFormat(
                                                          commonDateFormat)
                                                      .format(DateTime.parse(
                                                          data.end_interval))),
                                              0,
                                              TextEditingController(
                                                  text: editedvalue.toString()),
                                              old,
                                              false)
                                          .then((value) //=> refresh()
                                              {
                                        Get.to(BlankScreen(
                                          function: () {
                                            // final PatientSlipController
                                            //     _patientSlipController =
                                            //     PatientSlipController();
                                            //
                                            // _patientSlipController.getDetails(widget.patientDetailsData.sId, 0).then((val) {
                                            //   Get.off(InfusionReport(
                                            //       title: widget.title,
                                            //       patientDetailsData:
                                            //           _patientSlipController
                                            //                   .patientDetailsData[
                                            //               0],
                                            //       formula_status:
                                            //           widget.formula_status,
                                            //       isFromEn: widget.isFromEn
                                            //           ? true
                                            //           : false,
                                            //       type: widget.type,
                                            //       isFromPn: widget.isFromPn
                                            //           ? true
                                            //           : false));
                                            // });

                                            balanceSheetController.refreshInfusionSheet(widget.patientDetailsData.sId, widget.title, widget.formula_status, widget.isFromEn, widget.isFromPn, widget.type,widget.patientDetailsData.hospital.first.sId);
                                          },
                                        ));
                                      });
                                    }
                                  } else {
                                    ShowMsg("Please insert infused volume");
                                  }
                                } else {
                                  print("this is parentral");
                                  print(widget.type);
                                  print(data.date);
                                  print(edited_ml.text);
                                  var d = double.parse(edited_ml.text);
                                  print(DateTime.parse(data.date)
                                      .add(Duration(days: 1)));
                                  // print(DateFormat(commonDateFormat).format(DateTime.parse(data.date).add(Duration(days: 1))));
                                  if (edited_ml != null &&
                                      edited_ml.text != '0.0') {
                                    if (add_editFlag == 0) {
                                      //********** if part is for add ******
                                      balanceSheetController
                                          .onSaved(
                                              widget.patientDetailsData,
                                              data.type,
                                              TextEditingController(
                                                  text: DateFormat(
                                                          commonDateFormat)
                                                      .format(DateTime.parse(
                                                          data.end_interval))),
                                              DateFormat('HH:mm').format(
                                                  DateTime.parse(
                                                          data.end_interval)
                                                      .subtract(Duration(
                                                          minutes: 1))),
                                              0,
                                              TextEditingController(
                                                  text: d.toString()))
                                          .then((value) //=> refresh()
                                              {
                                        Get.to(BlankScreen(
                                          function: () {
                                            // final PatientSlipController
                                            //     _patientSlipController =
                                            //     PatientSlipController();
                                            //
                                            // _patientSlipController.getDetails(widget.patientDetailsData.sId, 0).then((val) {
                                            //   Get.off(InfusionReport(
                                            //       title: widget.title,
                                            //       patientDetailsData:
                                            //           _patientSlipController
                                            //                   .patientDetailsData[
                                            //               0],
                                            //       formula_status:
                                            //           widget.formula_status,
                                            //       isFromEn: widget.isFromEn
                                            //           ? true
                                            //           : false,
                                            //       type: widget.type,
                                            //       isFromPn: widget.isFromPn
                                            //           ? true
                                            //           : false));
                                            // });

                                            balanceSheetController.refreshInfusionSheet(widget.patientDetailsData.sId, widget.title, widget.formula_status, widget.isFromEn, widget.isFromPn, widget.type,widget.patientDetailsData.hospital.first.sId);
                                          },
                                        ));
                                      });
                                    } else {
                                      //********** else part is for edit ******

                                      var v = double.parse(infusedVol);
                                      var d = v;

                                      var old; // = vigi_resultData(item: data.type,date:  DateFormat(commonDateFormat).format(DateTime.parse(data.date).add(Duration(days: 1))).toString(),time: DateFormat('HH:mm').format(startTime.subtract(Duration(minutes: 1))).toString(),intOut:'0',ml: d.toInt().toString());
                                      print("flag... ${add_editFlag}");
                                      await getFluidBalanace(
                                              widget.patientDetailsData)
                                          .then((val) {
                                        if (val != null) {
                                          print(
                                              "alll... ${jsonEncode(val.result[0].data)}");
                                          var p_data = vigi_resultData(
                                              item: data.type,
                                              date: DateFormat(commonDateFormat)
                                                  .format(DateTime.parse(
                                                      data.end_interval)),
                                              time: DateFormat('HH:mm').format(
                                                  DateTime.parse(
                                                          data.end_interval)
                                                      .subtract(Duration(
                                                          minutes: 1))),
                                              intOut: '0',
                                              ml: d.toString());

                                          for (var a in val.result[0].data) {
                                            print(jsonEncode(a));
                                            print(jsonEncode(vigi_resultData(
                                                item: data.type,
                                                date:
                                                    DateFormat(commonDateFormat)
                                                        .format(DateTime.parse(
                                                            data.end_interval)),
                                                time: DateFormat('HH:mm')
                                                    .format(DateTime.parse(
                                                            data.end_interval)
                                                        .subtract(Duration(
                                                            minutes: 1))),
                                                intOut: '0',
                                                ml: d.toString())));
                                            if (a.date == p_data.date &&
                                                a.time == p_data.time &&
                                                a.item == p_data.item &&
                                                double.parse(a.ml) ==
                                                    double.parse(p_data.ml) &&
                                                a.intOut == p_data.intOut) {
                                              print("mached");
                                              old = a;
                                            } else {
                                              print(" not mached");
                                            }
                                          }
                                        }
                                      });

                                      var editedvalue =
                                          double.parse(edited_ml.text);

                                      // vigi_resultData previous_data =  vigi_resultData(item: data.type,date:  DateFormat(commonDateFormat).format(DateTime.parse(data.date).add(Duration(days: 1))),time: DateFormat('HH:mm').format(startTime.subtract(Duration(minutes: 1))),intOut:'0',ml: d.toString());
                                      // print("ppData>>${jsonEncode(previous_data)}");

                                      balanceSheetController
                                          .onEdit(
                                              widget.patientDetailsData,
                                              data.type,
                                              TextEditingController(
                                                  text: DateFormat(
                                                          commonDateFormat)
                                                      .format(DateTime.parse(
                                                          data.end_interval))),
                                              0,
                                              TextEditingController(
                                                  text: editedvalue.toString()),
                                              old,
                                              false)
                                          .then((value) //=> refresh()
                                              {
                                        Get.to(BlankScreen(
                                          function: () {
                                            // final PatientSlipController
                                            //     _patientSlipController =
                                            //     PatientSlipController();
                                            //
                                            // _patientSlipController.getDetails(widget.patientDetailsData.sId, 0).then((val) {
                                            //   Get.off(InfusionReport(
                                            //       title: widget.title,
                                            //       patientDetailsData:
                                            //           _patientSlipController
                                            //                   .patientDetailsData[
                                            //               0],
                                            //       formula_status:
                                            //           widget.formula_status,
                                            //       isFromEn: widget.isFromEn
                                            //           ? true
                                            //           : false,
                                            //       type: widget.type,
                                            //       isFromPn: widget.isFromPn
                                            //           ? true
                                            //           : false));
                                            // });

                                            balanceSheetController.refreshInfusionSheet(widget.patientDetailsData.sId, widget.title, widget.formula_status, widget.isFromEn, widget.isFromPn, widget.type,widget.patientDetailsData.hospital.first.sId);
                                          },
                                        ));
                                      });
                                    }
                                  } else {
                                    ShowMsg("Please insert infused volume");
                                  }
                                }
                              },
                            )),

                        // SizedBox(
                        //   height: 15,
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       bottom: MediaQuery.of(context).viewInsets.bottom),
                  //   child: Container(
                  //     child: Column(
                  //       children: [
                  //         Container(
                  //             width: Get.width,
                  //             child: RaisedButton(
                  //               // shape: RoundedRectangleBorder(
                  //               //   borderRadius: BorderRadius.circular(10.0),
                  //               // ),
                  //               padding: EdgeInsets.all(15.0),
                  //               elevation: 0,
                  //               onPressed: () {
                  //                 if (!_value2.isNullOrBlank &&
                  //                     !edited_ml.text.isNullOrBlank) {
                  //                   Get.back();
                  //                   activity = true;
                  //
                  //                   balanceSheetController
                  //                       .onEdit(
                  //                       patientSlipController
                  //                           .patientDetailsData[0],
                  //                       _value2,
                  //                       _date,
                  //                       selectedIndex2,
                  //                       edited_ml,
                  //                       data,
                  //                       true)
                  //                       .then((value) {
                  //                     refresh();
                  //                   });
                  //                 } else {
                  //                   ShowMsg('All fields are manedatory.');
                  //                 }
                  //               },
                  //               color: Colors.red.shade400,
                  //               textColor: Colors.white,
                  //               child: Text("Delete",
                  //                   style: TextStyle(fontSize: 14)),
                  //             )),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         Container(
                  //             width: Get.width,
                  //             child: RaisedButton(
                  //               // shape: RoundedRectangleBorder(
                  //               //   borderRadius: BorderRadius.circular(10.0),
                  //               // ),
                  //               padding: EdgeInsets.all(15.0),
                  //               elevation: 0,
                  //               onPressed: () {
                  //                 if (!_value2.isNullOrBlank &&
                  //                     !edited_ml.text.isNullOrBlank) {
                  //                   Get.back();
                  //                   data.date = datee;
                  //                   activity = true;
                  //                   balanceSheetController
                  //                       .onEdit(
                  //                       patientSlipController
                  //                           .patientDetailsData[0],
                  //                       _value2,
                  //                       _date,
                  //                       selectedIndex2,
                  //                       edited_ml,
                  //                       data,
                  //                       false)
                  //                       .then((value) {
                  //                     refresh();
                  //                   });
                  //                 } else {
                  //                   ShowMsg('All fields are manedatory.');
                  //                 }
                  //               },
                  //               color: primary_color,
                  //               textColor: Colors.white,
                  //               child: Text("Save",
                  //                   style: TextStyle(fontSize: 14)),
                  //             )),
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              );
            },
          );
        });
  }

  // bottomSheet(String text,bool isEdit,var previousData,var tc) {
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return StatefulBuilder(
  //           // You need this, notice the parameters below:
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 SizedBox(
  //                   height: 10,
  //                 ),
  //                 Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child:_addWidget(/*text,tc*/"rrrr")
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(
  //                       bottom: MediaQuery.of(context).viewInsets.bottom),
  //                   child: Container(
  //                     child: Column(
  //                       children: [
  //                         !isEdit? SizedBox() : Container(
  //                             width: Get.width,
  //                             child: RaisedButton(
  //                               // shape: RoundedRectangleBorder(
  //                               //   borderRadius: BorderRadius.circular(10.0),
  //                               // ),
  //                               padding: EdgeInsets.all(15.0),
  //                               elevation: 0,
  //                               onPressed: () {
  //                                 // Get.back();
  //                                 // _temp_glycemiaController.onEditTemp(data: patientSlipController.patientDetailsData[0],previousData: previousData,tempVaue: tempController.text,delete: true).then((value) {
  //                                 //   getData();
  //                                 //   tempController.clear();
  //                                 // });
  //                                 //
  //                                 // // if (!_value2.isNullOrBlank &&
  //                                 // //     !edited_ml.text.isNullOrBlank) {
  //                                 // //   Get.back();
  //                                 // //   balanceSheetController
  //                                 // //       .onEdit(
  //                                 // //       patientSlipController
  //                                 // //           .patientDetailsData[0],
  //                                 // //       _value2,
  //                                 // //       _date,
  //                                 // //       selectedIndex2,
  //                                 // //       edited_ml,
  //                                 // //       data,
  //                                 // //       true)
  //                                 // //       .then((value) {
  //                                 // //     refresh();
  //                                 // //   });
  //                                 // // } else {
  //                                 // //   ShowMsg('All fields are manedatory.');
  //                                 // // }
  //                               },
  //                               color: Colors.red.shade400,
  //                               textColor: Colors.white,
  //                               child: Text("Delete",
  //                                   style: TextStyle(fontSize: 14)),
  //                             )),
  //                         SizedBox(
  //                           height: 5,
  //                         ),
  //                         Container(
  //                             width: Get.width,
  //                             child: RaisedButton(
  //                               // shape: RoundedRectangleBorder(
  //                               //   borderRadius: BorderRadius.circular(10.0),
  //                               // ),
  //                               padding: EdgeInsets.all(15.0),
  //                               elevation: 0,
  //                               onPressed: () {
  //                                 // // if (!_value2.isNullOrBlank &&
  //                                 // //     !edited_ml.text.isNullOrBlank) {
  //                                 // //   Get.back();
  //                                 // //   balanceSheetController
  //                                 // //       .onEdit(
  //                                 // //       patientSlipController
  //                                 // //           .patientDetailsData[0],
  //                                 // //       _value2,
  //                                 // //       _date,
  //                                 // //       selectedIndex2,
  //                                 // //       edited_ml,
  //                                 // //       data,
  //                                 // //       false)
  //                                 // //       .then((value) {
  //                                 // //     refresh();
  //                                 // //   });
  //                                 // // } else {
  //                                 // //   ShowMsg('All fields are manedatory.');
  //                                 // // }
  //                                 // Get.back();
  //                                 // if(tempController.text.isNotEmpty){
  //                                 //   isEdit==false?
  //                                 //   _temp_glycemiaController.onsaveTemp(data:  patientSlipController.patientDetailsData[0],tempValue: tempController.text).then((value) {
  //                                 //     getData();
  //                                 //     tempController.clear();
  //                                 //   }):
  //                                 //   _temp_glycemiaController.onEditTemp(data: patientSlipController.patientDetailsData[0],previousData: previousData,tempVaue: tempController.text,delete: false).then((value) {
  //                                 //     getData();
  //                                 //   });
  //                                 // }else{
  //                                 //   ShowMsg('Please enter temprature first');
  //                                 // }
  //                                 //
  //                                 // // _controller.onSaved(patientSlipController.patientDetailsData[0], tempController.text, _dateController.text, _timeController.text);
  //
  //                               },
  //                               color: primary_color,
  //                               textColor: Colors.white,
  //                               child: Text("Save",
  //                                   style: TextStyle(fontSize: 14)),
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             );
  //           },
  //         );
  //       });
  // }

  getTimea(PatientDetailsData data) async {
    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
  }



}

class INOUT {
  String text;
  bool selected_prcnt;
  INOUT(this.text, this.selected_prcnt);
}


