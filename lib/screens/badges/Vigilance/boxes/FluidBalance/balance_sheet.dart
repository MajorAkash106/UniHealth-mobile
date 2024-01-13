import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/input_configuration.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/calender_widget.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class BalanceFluid extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool isFromEn;

  BalanceFluid({this.patientDetailsData, this.isFromEn});

  @override
  _BalanceFluidState createState() => _BalanceFluidState();
}

class _BalanceFluidState extends State<BalanceFluid> {
  final String jsonSample =
      '[{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"},{"Item": "NG Tube","Date": "10-8-1997","Time": "8:00","ML": "370"}]';
  bool toggle = true;

  List<String> heading = ['item'.tr, 'date'.tr, 'time'.tr, 'ML'];
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

    // "Enteral Nutrition",
    // "Parenteral Nutrition",
    // "Enteral Protein Module",
    // "Enteral Fiber Module",
    "glucose_five_per".tr,
    "glucose_ten_per".tr,
    "glucose_five_per_nacl".tr,
    "propofol_key".tr,
    "iv_fluids".tr,
    "urine".tr,
    "nasogastric_tube".tr,
    "drain".tr,
    "stoma".tr,
    "oral_route".tr,
  ];

  final PatientSlipController patientSlipController = PatientSlipController();
  final BalanceSheetController balanceSheetController =
      BalanceSheetController();

  List<INOUT> inout = <INOUT>[
    INOUT('in'.tr, false),
    INOUT('out'.tr, false),
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
      bool mode = await balanceSheetController
          .getRoute(widget.patientDetailsData.hospital.first.sId);
      if (mode != null && mode) {
        await patientSlipController
            .getDetails(widget.patientDetailsData.sId, 0)
            .then((val) {});
        print('internet avialable');
      } else {
        await patientSlipController
            .getDetailsOffline(widget.patientDetailsData.sId, 0)
            .then((val) {});
      }
    });
  }

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
            appBar: BaseAppbar('balance_sheet'.tr, null),
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
                                          future: getFluidBalanace(
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
                                                      ...vigilanceData
                                                          ?.result?.first?.data
                                                          .map((e) => e == null
                                                              ? TableRow()
                                                              : TableRow(
                                                                  decoration:
                                                                      new BoxDecoration(
                                                                    color: e.intOut == '0'
                                                                        ? Colors
                                                                            .green
                                                                            .shade100
                                                                        : Colors
                                                                            .red
                                                                            .shade100,
                                                                  ),
                                                                  children: [
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
                                                                                child: Text(e.item ?? ''),
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
                                                                                child: Text(e.ml ?? ''),
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
                                  Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text:
                                          "adjust_cumulative_fluid_balance".tr,
                                      myFunc: () async {
                                        activity = true;
                                        focus.unfocus();

                                        String balanceSince;
                                        String initial_date;
                                        await getFluidBalanace(
                                                patientSlipController
                                                    .patientDetailsData[0])
                                            .then((val) {
                                          // print('return val: ${jsonEncode(val)}');
                                          if (val != null) {
                                            balanceSince =
                                                val.result[0].balanceSince;

                                            print(
                                                'get balance since : ${val.result[0].balanceSince}');
                                            // initial_date= patientSlipController.patientDetailsData[0].admissionDate.to
                                          }
                                        });

                                        calenderWidget(context, _date,
                                            () async {
                                          print('press');
                                          print('return date: ${_date.text}');
                                          await balanceSheetController
                                              .onSetting(
                                                  patientSlipController
                                                      .patientDetailsData[0],
                                                  _date.text)
                                              .then((value) {
                                            refresh();
                                          });
                                        },
                                            'Cumulative_fluid_balance_from'.tr,
                                            balanceSince.isNullOrBlank
                                                ? null
                                                : balanceSince,
                                            disableFutureDate: true);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text: "add_new".tr,
                                      myFunc: () {
                                        if (!_value.isNullOrBlank &&
                                            !ml.text.isNullOrBlank) {
                                          focus.unfocus();
                                          activity = true;
                                          balanceSheetController
                                              .onSaved(
                                                  patientSlipController
                                                      .patientDetailsData[0],
                                                  _value,
                                                  datee,
                                                  DateFormat('HH:mm')
                                                      .format(DateTime.now())
                                                      .toString(),
                                                  selectedIndex,
                                                  ml)
                                              .then((value) {
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

  TextEditingController ml = TextEditingController();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black26,
                      width: 1,
                    )),
                height: 45.0,
                width: Get.width / 2,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12.0,
                            fontWeight: FontWeight.normal),
                        iconEnabledColor: Colors.black,
                        // isExpanded: true,
                        iconSize: 18.0,
                        dropdownColor: Colors.white,
                        hint: Text('select_item'.tr),
                        value: _value,
                        items: eventItem
                            .map(
                              (e) => DropdownMenuItem(
                                child: Text('${e}'),
                                value: '${e}',
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          // times.clear();
                          setState(() {
                            _value = value;
                            print(_value);
                          });
                        }),
                  ),
                ),
              ),
              Container(
                  width: Get.width / 3.2,
                  height: 45.0,
                  child: TextField(
                    controller: ml,
                    // enabled: enable,
                    focusNode: focus,
                    keyboardType: InputConfiguration.inputTypeWithDot,
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
                      hintStyle: TextStyle(
                          color: black40_color,
                          fontSize: 9.0,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              Text('mL',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0)),
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
                  calenderWidget(context, getDate, () async {
                    print('press');
                    print('return date: ${getDate.text}');
                    datee.text = getDate.text;
                    setState(() {});
                  }, 'select_date_for_add_a_event'.tr,
                      '${DateFormat(commonDateFormat).format(DateTime.now())}',
                      disableFutureDate: true);
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
              slider_tab(),
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

  Widget slider_tab() {
    return Container(
      height: 45.0,
      width: Get.width / 3.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: inout.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 1.0),
              child: InkWell(
                child: Container(
                  width: 58,
                  height: 45.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: Center(
                      child: Text(
                    inout[index].text,
                    style: TextStyle(
                        color: selectedIndex == index
                            ? selectedIndex == 0
                                ? Colors.green
                                : Colors.red
                            : Colors.black26),
                  )),
                ),
                onTap: () {
                  // print('selected: ${data.seletecIndex}');
                  selectedIndex = index;
                  print(selectedIndex);
                  // data.per = prcnt_list[index].prcnt_text;

                  // if()

                  setState(() {});
                },
              ),
            );
          }),
    );
  }

  selectRow(vigi_resultData data) {
    print('tapped data : ${data.toJson()}');
    // print('tapped data : ${eventItem.contains(data.item)}');
    focus.unfocus();
    if (eventItem.contains(data.item)) {
      _value2 = data.item;
      edited_ml.text = data.ml;
      selectedIndex2 = int.parse(data.intOut);

      onEdit(data.item, data.ml, data.intOut, data);
    } else {
      ShowMsg('sorry_this_event_is_non_editable'.tr);
    }
  }

  refresh() async {
    // patientSlipController
    //     .getDetails(patientSlipController.patientDetailsData[0].sId, 0)
    //     .then((value) {
    //   _value = null;
    //   ml.clear();
    //   selectedIndex = 0;
    // });

    bool mode = await balanceSheetController.getRoute(
        patientSlipController.patientDetailsData[0].hospital.first.sId);
    if (mode != null && mode) {
      await patientSlipController
          .getDetails(patientSlipController.patientDetailsData[0].sId, 0)
          .then((val) {});
      print('internet avialable');
    } else {
      await patientSlipController
          .getDetailsOffline(patientSlipController.patientDetailsData[0].sId, 0)
          .then((val) {});
    }
    _value = null;
    ml.clear();
    selectedIndex = 0;
  }

  TextEditingController edited_ml = TextEditingController();
  String _value2;
  int selectedIndex2 = 0;

  onEdit(String item, String tc, String status, vigi_resultData data) {
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
                            Container(
                              decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 1,
                                  )),
                              height: 45.0,
                              width: Get.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.0),
                                      iconEnabledColor: Colors.black,
                                      // isExpanded: true,
                                      iconSize: 19.0,
                                      dropdownColor: Colors.white,
                                      hint: Text('select_item'.tr),
                                      value: _value2,
                                      items: eventItem
                                          .map(
                                            (e) => DropdownMenuItem(
                                              child: Text(
                                                '${e}',
                                              ),
                                              value: '${e}',
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        // times.clear();
                                        setState(() {
                                          _value2 = value;
                                          print(_value2);
                                        });
                                      }),
                                ),
                              ),
                            ),
                            Container(
                              width: Get.width / 3.2,
                              height: 45.0,
                              child: texfld("", edited_ml, () {
                                print(edited_ml);
                              }),
                            ),
                            Text('mL',
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
                                calenderWidget(context, _date, () async {
                                  print('press');
                                  print('return date: ${_date.text}');
                                  datee = _date.text;
                                  setState(() {});
                                }, 'select_date_for_edit_a_event'.tr,
                                    data.date.isNullOrBlank ? null : data.date,
                                    disableFutureDate: true);
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
                            Container(
                              height: 45.0,
                              width: Get.width / 3.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.black12),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: inout.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0, bottom: 4.0, left: 1.0),
                                      child: InkWell(
                                        child: Container(
                                          width: 58,
                                          height: 45.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: selectedIndex2 == index
                                                ? Colors.white
                                                : Colors.transparent,
                                          ),
                                          child: Center(
                                              child: Text(
                                            inout[index].text,
                                            style: TextStyle(
                                                color: selectedIndex2 == index
                                                    ? selectedIndex2 == 0
                                                        ? Colors.green
                                                        : Colors.red
                                                    : Colors.black26),
                                          )),
                                        ),
                                        onTap: () {
                                          selectedIndex2 = index;
                                          print(selectedIndex2);
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  }),
                            ),
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
                                  if (!_value2.isNullOrBlank &&
                                      !edited_ml.text.isNullOrBlank) {
                                    Get.back();
                                    activity = true;

                                    balanceSheetController
                                        .onEdit(
                                            patientSlipController
                                                .patientDetailsData[0],
                                            _value2,
                                            _date,
                                            selectedIndex2,
                                            edited_ml,
                                            data,
                                            true)
                                        .then((value) {
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
                                  if (!_value2.isNullOrBlank &&
                                      !edited_ml.text.isNullOrBlank) {
                                    Get.back();
                                    data.date = datee;
                                    activity = true;
                                    balanceSheetController
                                        .onEdit(
                                            patientSlipController
                                                .patientDetailsData[0],
                                            _value2,
                                            _date,
                                            selectedIndex2,
                                            edited_ml,
                                            data,
                                            false)
                                        .then((value) {
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
}

class INOUT {
  String text;
  bool selected_prcnt;

  INOUT(this.text, this.selected_prcnt);
}
