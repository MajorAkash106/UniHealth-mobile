import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/calender_widget.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/contollers/vigilance/mean_iap_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../../../config/cons/input_configuration.dart';


class Mean_Iap_Screen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool isFromEn;
  Mean_Iap_Screen({this.patientDetailsData, this.isFromEn});

  @override
  _Mean_Iap_ScreenState createState() => _Mean_Iap_ScreenState();
}

class _Mean_Iap_ScreenState extends State<Mean_Iap_Screen> {
  AbdomenController abdomenController = AbdomenController();
  BalanceSheetController balanceSheetController = BalanceSheetController();
  final String jsonSample =
      '[{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"}]';
  bool toggle = true;

  List<String> heading = ['date'.tr, 'time'.tr, 'mmHg'];
  List<String> eventItem = [
    // 'NG Tube',
    // 'IV Fluids',
    // 'Urine',
    // 'ENTERAL N',
    // 'ENTERAL P',
    // 'ENTERAL F',
    // 'Parenteral N',
    // 'Glucose 5%',
    // 'Glucose 10%',
    // 'Glucose 5% + NaCl 0,9%',
    // 'Propofol',
    // 'Drain',
    // 'Stoma'
    "Enteral Nutrition",
    "Parenteral Nutrition",
    "Enteral Protein Module",
    "Enteral Fiber Module",
    "Glucose 5%",
    "Glucose 10%",
    "Glucose 5% + NaCl 0,9%",
    "Propofol",
    "Other IV fluids",
    "Urine",
    "Nasogastric Tube",
    "Drain",
    "Stoma",
  ];

  final PatientSlipController patientSlipController = PatientSlipController();
  // final BalanceSheetController balanceSheetController =
  // BalanceSheetController();
  final Mean_Iap_Controller mean_iap_controller = Mean_Iap_Controller();

  List<INOUT> inout = <INOUT>[
    INOUT('In', false),
    INOUT('Out', false),
  ];
  int selectedIndex = 0;

  String _value;
  var _date = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() {
    Future.delayed(const Duration(milliseconds: 0), () async {
      bool mode = await patientSlipController
          .getRoute(widget.patientDetailsData.hospital.first.sId);

      if (mode != null && mode) {
        patientSlipController
            .getDetails(widget.patientDetailsData.sId, 0)
            .then((val) {

        });
      } else {
        patientSlipController
            .getDetailsOffline(widget.patientDetailsData.sId, 0)
            .then((val) {

        });
      }
    });
  }

  //
  bool activity = false;
  Future<bool> _willPopScope() {
    if (!widget.isFromEn.isNullOrBlank && widget.isFromEn) {
      Get.back(result: activity);
    } else {
      Get.to(Step1HospitalizationScreen(
        index: 3,
        patientUserId: patientSlipController.patientDetailsData[0].sId,
      ));
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: BaseAppbar('mean_iap'.tr, IconButton(icon: Icon(Icons.refresh), onPressed: refresh)),
            body:
                Obx(() => patientSlipController.patientDetailsData.isNullOrBlank
                    ? SizedBox()
                    : Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ListView(
                                  // shrinkWrap: true,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'recent_events'.tr,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      child: FutureBuilder(
                                          future: get_mean_IapData(
                                              patientSlipController
                                                  .patientDetailsData[0]),
                                          builder: (context,
                                              AsyncSnapshot snapshot) {
                                            Vigilance vigilanceData =
                                                snapshot.data;

                                            return vigilanceData == null
                                                ? Table(
                                                    defaultColumnWidth:
                                                        FixedColumnWidth(
                                                            Get.width / 4),
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
                                                    defaultColumnWidth:
                                                        FixedColumnWidth(
                                                            Get.width / 4),
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
                                                      ...vigilanceData?.result
                                                          ?.first?.mean_data
                                                          .map((e) => e == null
                                                              ? TableRow()
                                                              : TableRow(
                                                                  //decoration:
                                                                  // new BoxDecoration(
                                                                  //   color: e.intOut == '0'
                                                                  //       ? Colors
                                                                  //       .green
                                                                  //       .shade100
                                                                  //       : Colors
                                                                  //       .red
                                                                  //       .shade100,
                                                                  // ),
                                                                  children: [
                                                                      // InkWell(
                                                                      //   onTap:
                                                                      //       () {
                                                                      //     selectRow(
                                                                      //         e);
                                                                      //   },
                                                                      //   child: Column(
                                                                      //       children: [
                                                                      //         Padding(
                                                                      //           padding: EdgeInsets.all(8),
                                                                      //           child: Text(e.item ?? ''),
                                                                      //         )
                                                                      //       ]),
                                                                      // ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          selectRow(
                                                                              e);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Text(e.date ?? ""),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          selectRow(
                                                                              e);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Text(e.time ?? ''),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          selectRow(
                                                                              e);
                                                                        },
                                                                        child: Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsets.all(8),
                                                                                child: Text(e.iap_value ?? ''),
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
                            _addWidget('add_new_events'.tr),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  // Container(
                                  //   width: Get.width,
                                  //   child: CustomButton(
                                  //     text: "Adjust Cumulative Fluid Balance",
                                  //     myFunc: () async {
                                  //      // activity = true;
                                  //       focus.unfocus();
                                  //
                                  //       String balanceSince;
                                  //       String initial_date;
                                  //       await getFluidBalanace(
                                  //           patientSlipController
                                  //               .patientDetailsData[0])
                                  //           .then((val) {
                                  //         // print('return val: ${jsonEncode(val)}');
                                  //         if (val != null) {
                                  //           balanceSince =
                                  //               val.result[0].balanceSince;
                                  //
                                  //           print(
                                  //               'get balance since : ${val.result[0].balanceSince}');
                                  //           // initial_date= patientSlipController.patientDetailsData[0].admissionDate.to
                                  //         }
                                  //       });
                                  //
                                  //       calenderWidget(
                                  //         context,
                                  //         _date,
                                  //             () async {
                                  //           // print('press');
                                  //           // print('return date: ${_date.text}');
                                  //           // await mean_iap_controller
                                  //           //     .onSetting(
                                  //           //     patientSlipController
                                  //           //         .patientDetailsData[0],
                                  //           //     _date.text)
                                  //           //     .then((value) {
                                  //           //   refresh();
                                  //           // });
                                  //         },
                                  //         'Cumulative fluid balance from',
                                  //         balanceSince.isNullOrBlank
                                  //             ? null
                                  //             : balanceSince,
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text: "add_new".tr,
                                      myFunc: () {
                                        // patientSlipController.patientDetailsData[0].vigilance[0].result[0].meaIapData.insert(0, MeanIapData(item: _value,date: datee.toString(),time: DateFormat('HH:mm').format(DateTime.now()),intOut: selectedIndex.toString(),ml: ml.text ));
                                        if ( //!_value.isNullOrBlank &&
                                            !ml.text.isNullOrBlank) {
                                          focus.unfocus();
                                          // activity = true;
                                          //balanceSheetController
                                          mean_iap_controller
                                              .onSaved(
                                                  patientSlipController
                                                      .patientDetailsData[0],
                                                  datee,
                                                  ml)
                                              .then((value) {
                                            activity = true;

                                            debugPrint('calling refresh fun');

                                            refresh();
                                          });
                                        } else {
                                          ShowMsg('all_mandatory'.tr);
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )))),
        onWillPop: _willPopScope);
  }

  var ml = TextEditingController();
  FocusNode focus = FocusNode();
  var datee = TextEditingController(
      text: '${DateFormat(commonDateFormat).format(DateTime.now())}');

  Widget _addWidget(String text) {
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '$text',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Container(
              //   decoration: BoxDecoration(
              //     // color: Colors.white,
              //       borderRadius: BorderRadius.circular(10.0),
              //       border: Border.all(
              //         color: Colors.black26,
              //         width: 1,
              //       )),
              //   height: 45.0,
              //   width: Get.width / 2,
              //   child: Padding(
              //     padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton(
              //           style: TextStyle(
              //               color: Colors.black,
              //               fontSize: 12.0,
              //               fontWeight: FontWeight.normal),
              //           iconEnabledColor: Colors.black,
              //           // isExpanded: true,
              //           iconSize: 18.0,
              //           dropdownColor: Colors.white,
              //           hint: Text('Select Item'),
              //           value: _value,
              //           items: eventItem
              //               .map(
              //                 (e) => DropdownMenuItem(
              //               child: Text('${e}'),
              //               value: '${e}',
              //             ),
              //           )
              //               .toList(),
              //           onChanged: (value) {
              //             // times.clear();
              //             setState(() {
              //               _value = value;
              //               print(_value);
              //             });
              //           }),
              //     ),
              //   ),
              // ),
              Container(
                  width: Get.width / 2,
                  height: 45.0,
                  child: TextField(
                    controller: ml,
                    // enabled: enable,
                    focusNode: focus,
                    keyboardType: InputConfiguration.inputTypeWithDot,
                    textInputAction: InputConfiguration.inputActionNext,
                    inputFormatters: InputConfiguration.formatDotOnly,
                    onChanged: (_value) {
                      // _fun();
                    },
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      // hintText: hint,
                      border: new OutlineInputBorder(
                          //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(
                              color: Colors.white,
                              width: 0.0) //This is Ignored,
                          ),
                      hintText: "mean_iap".tr,
                      hintStyle: TextStyle(
                          color: black40_color,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  mean_iap_controller.get_avg_MeanIap(
                      patientSlipController.patientDetailsData[0]);
                },
                child: Text('mmHg',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   height: 45.0,
              //   width: Get.width / 2,
              // ),
              InkWell(
                onTap: () {
                  var getDate = TextEditingController();
                  getDate.text =
                      '${DateFormat(commonDateFormat).format(DateTime.now())}';
                  calenderWidget(
                    context,
                    getDate,
                    () async {
                      print('press');
                      print('return date: ${getDate.text}');
                      datee.text = getDate.text;
                      setState(() {});
                    },
                    '${'select'.tr} ${'date'.tr}',
                    datee.text.isEmpty
                        ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
                        : datee.text,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black26,
                        width: 1,
                      )),
                  height: 45.0,
                  width: Get.width / 2,
                  child: Center(
                    child: Text('${datee.text}'),
                  ),
                ),
              ),
              // slider_tab(),
              Text('     ',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0)),
            ],
          ),
        ],
      ),
    );
  }

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

  selectRow(Mean_IAP_Data data) {
    print('tapped data : ${data}');
    focus.unfocus();

    _value2 = data.iap_value;
    edited_ml.text = data.iap_value;
    // selectedIndex2 = int.parse(data.intOut);

    onEdit(data.iap_value, data);
  }

  refresh() async {
    Future.delayed(Duration(seconds: 1), () async{
      bool mode = await patientSlipController.getRoute(
          patientSlipController.patientDetailsData[0].hospital.first.sId);

      if (mode != null && mode) {
        await patientSlipController
            .getDetails(patientSlipController.patientDetailsData[0].sId, 0)
            .then((value) {
          _value = null;
          ml.clear();
          selectedIndex = 0;
        });
      } else {
        await patientSlipController
            .getDetailsOffline(patientSlipController.patientDetailsData[0].sId, 0)
            .then((value) {
          _value = null;
          ml.clear();
          selectedIndex = 0;
        });
      }
    });


  }

  var edited_ml = TextEditingController();
  String _value2;
  int selectedIndex2 = 0;

  onEdit(String tc, Mean_IAP_Data data) {
    String datee = data.date;
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
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'edit_event'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Container(
                            //   decoration: BoxDecoration(
                            //     // color: Colors.white,
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       border: Border.all(
                            //         color: Colors.black26,
                            //         width: 1,
                            //       )),
                            //   height: 45.0,
                            //   width: Get.width / 2,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(
                            //         left: 15.0, right: 15.0),
                            //     child: DropdownButtonHideUnderline(
                            //       child: DropdownButton(
                            //           style: TextStyle(
                            //               color: Colors.black, fontSize: 12.0),
                            //           iconEnabledColor: Colors.black,
                            //           // isExpanded: true,
                            //           iconSize: 19.0,
                            //           dropdownColor: Colors.white,
                            //           hint: Text('Select Item'),
                            //           value: _value2,
                            //           items: eventItem
                            //               .map(
                            //                 (e) => DropdownMenuItem(
                            //               child: Text(
                            //                 '${e}',
                            //               ),
                            //               value: '${e}',
                            //             ),
                            //           )
                            //               .toList(),
                            //           onChanged: (value) {
                            //             // times.clear();
                            //             setState(() {
                            //               _value2 = value;
                            //               print(_value2);
                            //             });
                            //           }),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              width: Get.width / 2,
                              height: 45.0,
                              child: texfld("", edited_ml, () {
                                print(edited_ml);
                              }),
                            ),
                            Text('mmHg',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                calenderWidget(
                                  context,
                                  _date,
                                  () async {
                                    print('press');
                                    print('return date: ${_date.text}');
                                    datee = _date.text;
                                    setState(() {});
                                  },
                                  '${'select'.tr} ${'date'.tr}',
                                  data.date.isNullOrBlank ? null : data.date,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: 1,
                                    )),
                                height: 45.0,
                                width: Get.width / 2,
                                child: Center(
                                  child: Text('${datee}'),
                                ),
                              ),
                            ),
                            // Container(
                            //   height: 45.0,
                            //   width: Get.width / 3.0,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(10.0),
                            //       color: Colors.black12),
                            //   child: ListView.builder(
                            //       scrollDirection: Axis.horizontal,
                            //       shrinkWrap: true,
                            //       itemCount: inout.length,
                            //       itemBuilder: (context, index) {
                            //         return Padding(
                            //           padding: const EdgeInsets.only(
                            //               top: 4.0, bottom: 4.0, left: 1.0),
                            //           child: InkWell(
                            //             child: Container(
                            //               width: 58,
                            //               height: 45.0,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                 BorderRadius.circular(10.0),
                            //                 color: selectedIndex2 == index
                            //                     ? Colors.white
                            //                     : Colors.transparent,
                            //               ),
                            //               child: Center(
                            //                   child: Text(
                            //                     inout[index].text,
                            //                     style: TextStyle(
                            //                         color: selectedIndex2 == index
                            //                             ? selectedIndex2 == 0
                            //                             ? Colors.green
                            //                             : Colors.red
                            //                             : Colors.black26),
                            //                   )),
                            //             ),
                            //             onTap: () {
                            //               selectedIndex2 = index;
                            //               print(selectedIndex2);
                            //               setState(() {});
                            //             },
                            //           ),
                            //         );
                            //       }),
                            // ),
                            Text('     ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {
                                  if (!edited_ml.text.isNullOrBlank) {
                                    Get.back();
                                    //activity = true;

                                    mean_iap_controller
                                        .onEdit(
                                            patientSlipController
                                                .patientDetailsData[0],
                                            _date,
                                            edited_ml,
                                            data,
                                            true)
                                        .then((value) {
                                      activity = true;
                                      refresh();
                                    });
                                  } else {
                                    ShowMsg('all_mandatory'.tr);
                                  }
                                },
                                color: Colors.red.shade400,
                                textColor: Colors.white,
                                child: Text("delete".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {
                                  if (!edited_ml.text.isNullOrBlank) {
                                    Get.back();
                                    data.date = datee;
                                    // activity = true;
                                    mean_iap_controller
                                        .onEdit(
                                            patientSlipController
                                                .patientDetailsData[0],
                                            _date,
                                            edited_ml,
                                            data,
                                            false)
                                        .then((value) {
                                      activity = true;

                                      debugPrint('refresh calling on edit');
                                      refresh();
                                    });
                                  } else {
                                    ShowMsg('all_mandatory'.tr);
                                  }
                                },
                                color: primary_color,
                                textColor: Colors.white,
                                child: Text("save".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }

  Future getMeanIap() async {
    return jsonSample;
  }
}

class INOUT {
  String text;
  bool selected_prcnt;
  INOUT(this.text, this.selected_prcnt);
}
