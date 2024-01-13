import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/calender_widget.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/circulation_sheet_Controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/circulation_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/EnteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import '../../../../../config/cons/input_configuration.dart';
import '../../../../../contollers/time_picker/time_picker.dart';

// class staticList {
//   String optionText;
//   bool isSelected;
//   staticList({this.optionText, this.isSelected});
// }

class CirculationSheet extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  const CirculationSheet({Key key, this.patientDetailsData}) : super(key: key);

  @override
  _CirculationSheetState createState() => _CirculationSheetState();
}

class _CirculationSheetState extends State<CirculationSheet> {
  final PatientSlipController patientSlipController = PatientSlipController();
  final VigilanceController vigilanceController = VigilanceController();
  CirculationSheetController circulationSheetController =
      CirculationSheetController();
  final String jsonSample =
      '[{"Date": "10-8-1997","Time": "8:00","SBP": "150","MAP": "90","DBP": "110"},{"Date": "10-8-1997","Time": "8:00","SBP": "150","MAP": "90","DBP": "110"},{"Date": "10-8-1997","Time": "8:00","SBP": "150","MAP": "90","DBP": "110"},{"Date": "10-8-1997","Time": "8:00","SBP": "150","MAP": "90","DBP": "110"},{"Date": "10-8-1997","Time": "8:00","SBP": "150","MAP": "90","DBP": "110"}]';
  final String jsonVaso =
      '[{"Drug": "10-8-1997","Date": "8:00","Time":"5.00","Ml_HR": "150","DOSE": "90"},{"Drug": "10-8-1997","Date": "8:00","Ml_HR": "150","DOSE": "90"},{"Drug": "10-8-1997","Date": "8:00","Ml_HR": "150","DOSE": "90"},{"Drug": "10-8-1997","Date": "8:00","Ml_HR": "150","DOSE": "90"}]';

  List<String> heading = ['date'.tr, 'time'.tr, 'sbp'.tr, 'dbp'.tr, 'map'.tr];
  List<String> vaso = [
    'drug'.tr,
    'date'.tr,
    'time'.tr,
    'infusion_ml_h'.tr,
    'dose'.tr,
  ];
  List<String> eventItem = [
    'ng__tube'.tr,
    'iv_fluids'.tr,
    'urine'.tr,
    'enteral_n'.tr
  ];
  List<staticList> dropdwn_list = [
    staticList(optionText: "epinephrine".tr, isSelected: false),
    staticList(optionText: "norepinephrine".tr, isSelected: false),
    staticList(optionText: "dopamine".tr, isSelected: false),
    staticList(optionText: "dobutamine".tr, isSelected: false),
    staticList(optionText: "vasopressin".tr, isSelected: false)
  ];
  String dose;
  var focus1 = FocusNode();
  int selectedIndex = 0;

  var _date = TextEditingController();

  Future<bool> _willPopScope() {
    Get.to(Step1HospitalizationScreen(
      index: 3,
      patientUserId: patientSlipController.patientDetailsData[0].sId,
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopScope,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: BaseAppbar('circulation_sheet'.tr, null),
        body: Obx(
          () => patientSlipController.patientDetailsData.isNullOrBlank
              ? SizedBox()
              :
              //  child:
              Padding(
                  padding: EdgeInsets.all(4),
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    // color: Colors.red,
                                    height: Get.height / 2.4,
                                    child: _blood()),
                                SizedBox(
                                  height: 0,
                                ),
                                Divider(
                                  height: 3.0,
                                  color: Colors.black12,
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    // color: Colors.green,
                                    height: Get.height / 2.6,
                                    child: _vasopressors())
                              ],
                            ),
                          ),
                        )
                        // Expanded(
                        //   child: ListView(
                        //     physics: NeverScrollableScrollPhysics(),
                        //     shrinkWrap: true,
                        //     children: [
                        //       Column(children: [

                        //       ],),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: Get.width,
            child: CustomButton(
              text: "add_new".tr,
              myFunc: () {
                if (drpvalue != null) {
                  drpvalue = null;
                } else {}
                if (drug_amount != null) {
                  drug_amount.clear();
                } else {}
                if (concentration != null) {
                  concentration.clear();
                } else {}
                if (diluent != null) {
                  diluent.clear();
                } else {}
                if (infusion != null) {
                  infusion.clear();
                } else {}

                _dateController.clear();
                _timeController.clear();

                edit(edit: false, pressureType: true, contxt: context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _blood() {
    List json = jsonDecode(jsonSample);
    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: () async {
            try {
              print(patientSlipController.patientDetailsData[0].name
                  .toUpperCase());
            } catch (e) {
              print(e.toString());
            }
          },
          child: Text(
            'blood_pressure'.tr,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Expanded(
        child: Container(
          // height: Get.width / 2.2,
          child: ListView(
            shrinkWrap: true,
            children: [
              FutureBuilder(
                  future: getCirculationData(
                      patientSlipController.patientDetailsData[0]),
                  builder: (context, AsyncSnapshot snapshot) {
                    Vigilance vigilanceData = snapshot.data;

                    List<BloodPressor> bpData = [];
                    if (vigilanceData != null) {
                      bpData = vigilanceData
                              .result.first.circulaltiondata.bloodPressor ??
                          [];
                      bpData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                    }

                    return vigilanceData == null
                        ? Table(
                            defaultColumnWidth: FixedColumnWidth(Get.width / 5),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  children: heading
                                      .map((e) => Column(children: [
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text('$e',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ]))
                                      .toList()),

                              // TableRow()
                            ],
                          )
                        : Table(
                            defaultColumnWidth: FixedColumnWidth(Get.width / 5),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  children: heading
                                      .map((e) => Column(children: [
                                            Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text('$e',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ]))
                                      .toList()),
                              ...bpData
                                  .map((e) => e == null
                                      ? TableRow()
                                      : TableRow(
                                          decoration: new BoxDecoration(
                                            color: Colors.orange.shade50,
                                          ),
                                          children: [
                                              InkWell(
                                                onTap: () {
                                                  selectRow(e, false);
                                                  sbp = TextEditingController(
                                                      text: e.sbp);
                                                  dbp = TextEditingController(
                                                      text: e.dbp);
                                                  map = TextEditingController(
                                                      text: e.map);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.date ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectRow(e, false);
                                                  sbp = TextEditingController(
                                                      text: e.sbp);
                                                  dbp = TextEditingController(
                                                      text: e.dbp);
                                                  map = TextEditingController(
                                                      text: e.map);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.time ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectRow(e, false);
                                                  sbp = TextEditingController(
                                                      text: e.sbp);
                                                  dbp = TextEditingController(
                                                      text: e.dbp);
                                                  map = TextEditingController(
                                                      text: e.map);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.sbp ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectRow(e, false);
                                                  sbp = TextEditingController(
                                                      text: e.sbp);
                                                  dbp = TextEditingController(
                                                      text: e.dbp);
                                                  map = TextEditingController(
                                                      text: e.map);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.dbp ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  selectRow(e, false);
                                                  sbp = TextEditingController(
                                                      text: e.sbp);
                                                  dbp = TextEditingController(
                                                      text: e.dbp);
                                                  map = TextEditingController(
                                                      text: e.map);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.map ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                            ]))
                                  .toList()
                            ],
                          );
                  }),
            ],
          ),
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
            if (sbp != null) {
              sbp.clear();
            } else {}

            if (dbp != null) {
              dbp.clear();
            } else {}

            if (map != null) {
              map.clear();
            } else {}
            // sbp.clear();
            // dbp.clear();
            // map.clear();
            // // Map finalData = {
            //   "lastUpdate": "",
            //   "blood_pressor": [
            //     {
            //       "date": "",
            //       "time": "",
            //       "sbp": "",
            //       "dbp": "",
            //       "map": ""
            //     },
            //     {
            //       "date": "",
            //       "time": "",
            //       "sbp": "",
            //       "dbp": "",
            //       "map": ""
            //     }
            //   ],
            //   "vasopressor": []
            // };
            //vigilanceController.saveData(widget.patientDetailsData, finalData, VigiLanceBoxes.circulation_status, VigiLanceBoxes.circulation);
            _dateController.clear();
            _timeController.clear();

            edit(edit: false, pressureType: false, contxt: context);
          },
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ]);
  }

  Widget _vasopressors() {
    List json = jsonDecode(jsonVaso);
    return Column(children: [
      Align(
        alignment: Alignment.topLeft,
        child: Text(
          'vasopressors'.tr,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17.0),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
          //  color: Colors.red,
          height: Get.height / 3.6,
          child: ListView(
            shrinkWrap: true,
            children: [
              FutureBuilder(
                  future: getCirculationData(
                      patientSlipController.patientDetailsData[0]),
                  builder: (context, AsyncSnapshot snapshot) {
                    Vigilance vigilanceData = snapshot.data;
                    List<Vasopressor> vsData = [];
                    if (vigilanceData != null) {
                      vsData = vigilanceData.result.first.circulaltiondata.vasopressor ?? [];
                      vsData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                    }

                    return vigilanceData == null
                        ? Table(
                            defaultColumnWidth:
                                FixedColumnWidth(Get.width / 6.1),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  children: vaso
                                      .map((e) => Column(children: [
                                            Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text('$e',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ]))
                                      .toList()),

                              // TableRow()
                            ],
                          )
                        : Table(
                            defaultColumnWidth: FixedColumnWidth(Get.width / 5),
                            border: TableBorder.all(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1),
                            children: [
                              TableRow(
                                  children: vaso
                                      .map((e) => Column(children: [
                                            Padding(
                                              padding: EdgeInsets.all(4),
                                              child: Text('$e',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          ]))
                                      .toList()),
                              ...vsData
                                  .map((e) => e == null
                                      ? TableRow()
                                      : TableRow(
                                          decoration: new BoxDecoration(
                                            color: Colors.orange.shade50,
                                          ),
                                          children: [
                                              InkWell(
                                                onTap: () {
                                                  drpvalue = e.drug ?? "";
                                                  drug_amount =
                                                      TextEditingController(
                                                          text: e.drug_amount ??
                                                              "");
                                                  concentration =
                                                      TextEditingController(
                                                          text:
                                                              e.concentration ??
                                                                  "");
                                                  diluent =
                                                      TextEditingController(
                                                          text:
                                                              e.diluent ?? "");
                                                  infusion =
                                                      TextEditingController(
                                                          text:
                                                              e.infusion ?? "");
                                                  selectRow(e, true);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.drug ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  drpvalue = e.drug ?? "";
                                                  drug_amount =
                                                      TextEditingController(
                                                          text: e.drug_amount ??
                                                              "");
                                                  concentration =
                                                      TextEditingController(
                                                          text:
                                                              e.concentration ??
                                                                  "");
                                                  diluent =
                                                      TextEditingController(
                                                          text:
                                                              e.diluent ?? "");
                                                  infusion =
                                                      TextEditingController(
                                                          text:
                                                              e.infusion ?? "");
                                                  selectRow(e, true);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.date ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  drpvalue = e.drug;
                                                  drug_amount =
                                                      TextEditingController(
                                                          text: e.drug_amount ??
                                                              "");
                                                  concentration =
                                                      TextEditingController(
                                                          text:
                                                              e.concentration ??
                                                                  "");
                                                  diluent =
                                                      TextEditingController(
                                                          text:
                                                              e.diluent ?? "");
                                                  infusion =
                                                      TextEditingController(
                                                          text:
                                                              e.infusion ?? "");
                                                  selectRow(e, true);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.time ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     drpvalue = e.drug;
                                              //     drug_amount =
                                              //         TextEditingController(
                                              //             text: e.drug_amount ??
                                              //                 "");
                                              //     concentration =
                                              //         TextEditingController(
                                              //             text:
                                              //                 e.concentration ??
                                              //                     "");
                                              //     diluent =
                                              //         TextEditingController(
                                              //             text:
                                              //                 e.diluent ?? "");
                                              //     infusion =
                                              //         TextEditingController(
                                              //             text:
                                              //                 e.infusion ?? "");
                                              //     selectRow(e, true);
                                              //   },
                                              //   child: Column(children: [
                                              //     Padding(
                                              //       padding: EdgeInsets.all(8),
                                              //       child: Text(
                                              //         e.drug_amount ?? "",
                                              //         style: TextStyle(
                                              //             fontSize: 12),
                                              //       ),
                                              //     )
                                              //   ]),
                                              // ),
                                              InkWell(
                                                onTap: () {
                                                  drpvalue = e.drug;
                                                  drug_amount =
                                                      TextEditingController(
                                                          text: e.drug_amount ??
                                                              "");
                                                  concentration =
                                                      TextEditingController(
                                                          text:
                                                              e.concentration ??
                                                                  "");
                                                  diluent =
                                                      TextEditingController(
                                                          text:
                                                              e.diluent ?? "");
                                                  infusion =
                                                      TextEditingController(
                                                          text:
                                                              e.infusion ?? "");
                                                  selectRow(e, true);
                                                },
                                                child: Column(children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(4),
                                                    child: Text(
                                                      e.infusion ?? "",
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  )
                                                ]),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  drpvalue = e.drug ?? "";
                                                  drug_amount =
                                                      TextEditingController(
                                                          text: e.drug_amount ??
                                                              "");
                                                  concentration =
                                                      TextEditingController(
                                                          text:
                                                              e.concentration ??
                                                                  "");
                                                  diluent =
                                                      TextEditingController(
                                                          text:
                                                              e.diluent ?? "");
                                                  infusion =
                                                      TextEditingController(
                                                          text:
                                                              e.infusion ?? "");
                                                  selectRow(e, true);
                                                },
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 8,
                                                                right: 8.0,
                                                                left: 8.0),
                                                        child: Text(
                                                          "${"${e.dose} " ?? ""}",
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      Text(
                                                        "${e.unit_type == 'u' ? 'U/min' : 'mcg/kg/min'}",
                                                        style: TextStyle(
                                                            fontSize: 10.0),
                                                      )
                                                    ]),
                                              ),
                                            ]))
                                  .toList()
                            ],
                          );
                  }),
            ],
          )),
      SizedBox(
        height: 5,
      ),
      // Container(
      //   width: Get.width,
      //   child: CustomButton(
      //     text: "Add new",
      //     myFunc: () {
      //       if(drpvalue!=null){
      //         drpvalue =null;
      //       }else{}
      //       if(drug_amount!=null){
      //         drug_amount.clear();
      //       }else{}
      //       if(concentration!=null){
      //         concentration.clear();
      //       }else{}
      //       if(diluent!=null){
      //         diluent.clear();
      //       }else{}
      //       if(infusion!=null){
      //         infusion.clear();
      //       }else{}
      //
      //       edit(edit: false,pressureType: true,contxt: context);
      //     },
      //   ),
      // ),
      SizedBox(
        height: 5,
      ),
    ]);
  }

  var sbp = TextEditingController();
  var dbp = TextEditingController();
  var map = TextEditingController();
  var drug_amount = TextEditingController();
  var diluent = TextEditingController();
  var concentration = TextEditingController();
  var infusion = TextEditingController();
  var _dateController = TextEditingController();
  var _timeController = TextEditingController();
  TimeOfDay result;
  String drpvalue;

  Widget _addWidget(String text, bool pressureType, var context,
      StateSetter setState, var previousData) {
    if(_dateController.text.isEmpty && _timeController.text.isEmpty) {
      _dateController.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
      _timeController.text =
      "${TimeOfDay.now().hour < 10 ? '0${TimeOfDay.now().hour}' : TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? '0${TimeOfDay.now().minute}' : TimeOfDay.now().minute}";
    }
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
          pressureType == true
              ? SizedBox(
                  height: 10,
                )
              : SizedBox(),
          pressureType == true
              ? StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return dropdown(dropdwn_list, drpvalue, (value) {
                      setState(() {
                        drpvalue = value;
                        // drug_amount.clear();
                        // diluent.clear();
                        // concentration.clear();

                        print(drpvalue.toString());
                        concentration.text = //drpvalue !=null?
                            calculated_concenteration(
                                    drpvalue == "Vasopressin" ? 'U' : "MG",
                                    drug_amount,
                                    diluent)
                                .text;
                        FocusScope.of(context).previousFocus();
                        focus1.requestFocus();
                        //:calculated_concenteration(null,drug_amount,diluent);
                      });
                    }, context);
                  },
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          pressureType == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('drug_amount'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text(' (${drpvalue == "vasopressin".tr ? 'U' : 'mg'})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    ),
                    // SizedBox(
                    //   width: 60,
                    // ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: InkWell(
                              onTap: () {
                                concentration.text = drpvalue != null
                                    ? calculated_concenteration(
                                            drpvalue == "Vasopressin"
                                                ? 'U'
                                                : "MG",
                                            drug_amount,
                                            diluent)
                                        .text
                                    : calculated_concenteration(
                                            null, drug_amount, diluent)
                                        .text;
                              },
                              child: TextField(
                                controller: drug_amount,
                                // enabled: enable,
                                focusNode: focus1,
                                keyboardType: InputConfiguration.inputTypeWithDot,
                                textInputAction: InputConfiguration.inputActionNext,
                                inputFormatters: InputConfiguration.formatDotOnly,
                                onChanged: (_value) {
                                  print(drug_amount.text);
                                  concentration.text = drpvalue != null
                                      ? calculated_concenteration(
                                              drpvalue == "Vasopressin"
                                                  ? 'U'
                                                  : "MG",
                                              drug_amount,
                                              diluent)
                                          .text
                                      : calculated_concenteration(
                                              null, drug_amount, diluent)
                                          .text;
                                },
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: '',
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
                              )
                              // texfld("", drug_amount, () {
                              //   print(drug_amount.text);
                              //   concentration= drpvalue !=null? calculated_concenteration(drpvalue=="Vasopressin"?'U':"MG",drug_amount,diluent):calculated_concenteration(null,drug_amount,diluent);
                              // }),
                              ),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text('sbp'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text('(${'sbp_full_form'.tr})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: texfld("", sbp, () {
                            print(sbp.text);
                            if (sbp.text.isEmpty || dbp.text.isEmpty) {
                              map.clear();
                              //map=TextEditingController(text: '');
                            } else {
                              //  map.clear();
                              map.text = calculated_map().text;
                              print(map.text);
                            }
                            setState(() {});
                          }),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('mmHg',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          pressureType == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('diluent'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text(' (mL)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    ),
                    // SizedBox(
                    //   width: 110,
                    // ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: InkWell(
                            onTap: () {
                              concentration.text = drpvalue != null
                                  ? calculated_concenteration(
                                          drpvalue == "vasopressin".tr
                                              ? 'U'
                                              : "MG",
                                          drug_amount,
                                          diluent)
                                      .text
                                  : calculated_concenteration(
                                          null, drug_amount, diluent)
                                      .text;
                            },
                            child: texfld("", diluent, () {
                              print(diluent.text);
                              concentration.text = drpvalue != null
                                  ? calculated_concenteration(
                                          drpvalue == "vasopressin".tr
                                              ? 'U'
                                              : "MG",
                                          drug_amount,
                                          diluent)
                                      .text
                                  : calculated_concenteration(
                                          null, drug_amount, diluent)
                                      .text;
                            }),
                          ),
                        ),
                        // SizedBox(
                        //   width: 3.0,
                        // ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text('dbp'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text('(${'dbp_full_form'.tr})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: texfld(
                            "",
                            dbp,
                            () {
                              if (sbp.text.isEmpty || dbp.text.isEmpty) {
                                map.clear();
                                //map=TextEditingController(text: '');
                              } else {
                                // map.clear();
                                //map=TextEditingController(text: '');
                                print('getting : ${calculated_map().text}');

                                map.text = calculated_map().text;
                                print(dbp.text);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('mmHg',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    )
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          pressureType == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('concentration'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text(
                            ' (${drpvalue == "vasopressin".tr ? 'U' : 'mg'}/mL)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0))
                      ],
                    ),
                    // SizedBox(
                    //   width: Get.width / 8,
                    // ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: disableTextField(
                            "",
                            concentration,
                            () {
                              print(concentration.text);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Text('map'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text('(${'mbp_full_form'.tr})',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontSize: 10)),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: texfld("", map, () {
                            print(map.text);
                          }),
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('mmHg',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    )
                  ],
                ),
          pressureType == true
              ? SizedBox(
                  height: 10.0,
                )
              : SizedBox(),
          pressureType == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('infusion'.tr,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                        Text(' (mL/h)',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17.0)),
                      ],
                    ),
                    // SizedBox(
                    //   width: 100,
                    // ),
                    Row(
                      children: [
                        Container(
                          width: Get.width / 3.2,
                          height: 45.0,
                          child: texfld("", infusion, () {
                            print(infusion.text);
                          }),
                        ),
                        // SizedBox(
                        //   width: 3.0,
                        // ),
                      ],
                    )
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('Date  ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: Get.width / 3.2,
                    height: 45.0,
                    child: InkWell(
                      onTap: () {
                        var getDate = TextEditingController();
                        getDate.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
                        String initialDate = previousData?.date ??
                            '${DateFormat(commonDateFormat).format(DateTime.now())}';
                        print('return date: ${getDate.text}');
                        calenderWidget(
                          context,
                          getDate,
                          () async {
                            print('press');
                            print('return date: ${getDate.text}');
                            _dateController.text = await getDate.text;

                            await setState(() {});
                          },
                          'select_date_for_add_a_event'.tr,
                          initialDate,
                          disableFutureDate: true
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: black40_color,
                              width: 1,
                            )),
                        // height: 45.0,
                        // width: Get.width / 2,
                        child: Center(
                          child: Text('${_dateController.text}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Time  ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: Get.width / 3.2,
                    height: 45.0,
                    child: InkWell(
                      onTap: () {
                        if (previousData != null) {
                          debugPrint(
                              'previousData.time :: ${previousData.time}');
                          var output = previousData.time.split(':');
                          print(output);
                          result = TimeOfDay(
                              hour: int.parse(output.first),
                              minute: int.parse(output.last));
                        }

                        print('hour: ${result?.hour}');
                        print('min: ${result?.minute}');
                        timePicker(context, result?.hour, result?.minute)
                            .then((time) {
                          print('return time : $time');
                          result = time;
                          _timeController.text =
                              "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                          print(result.minute);

                          setState(() {});
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: black40_color,
                              width: 1,
                            )),
                        // height: 45.0,
                        // width: Get.width / 2,
                        child: Center(
                          child: Text('${_timeController.text}'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  selectRow(
    var data,
    bool pressortype,
  ) {
    print('tapped data : ${jsonEncode(data)}');
    if (data != null) {
      _dateController.text = data?.date ?? '';
      _timeController.text = data?.time ?? '';
    }
    edit(
        edit: true,
        pressureType: pressortype,
        contxt: context,
        previousData: data);
  }

  Widget edit({bool edit, bool pressureType, var contxt, var previousData}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: _addWidget(
                      edit == true ? "edit_event".tr : 'add_event'.tr,
                      pressureType,
                      contxt,
                      setState,
                      previousData),
                ),
                edit == true
                    ? Container(
                        width: Get.width,
                        child: RaisedButton(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10.0),
                          // ),
                          padding: EdgeInsets.all(15.0),
                          elevation: 0,
                          onPressed: () {
                            Get.back();
                            if (pressureType == false) {
//pressor type false means editing in blood presssor data
                              circulationSheetController
                                  .onEdit(
                                      data: patientSlipController
                                          .patientDetailsData[0],
                                      sbp: sbp.text,
                                      dbp: dbp.text,
                                      map: map.text,
                                      previousData: previousData,
                                      delete: true,
                                      tablenumber: 0,
                                      time: _timeController.text,
                                      date: _dateController.text)
                                  .then((value) {
                                refresh();
                              });
                            } else {
                              circulationSheetController
                                  .onEdit(
                                      data: patientSlipController
                                          .patientDetailsData[0],
                                      tablenumber: 1,
                                      drug: drpvalue,
                                      drug_amt: drug_amount.text,
                                      concenteratrion: concentration.text,
                                      dose: dose,
                                      diluent: diluent.text,
                                      infusion: infusion.text,
                                      unitType: drpvalue == "Vasopressin"
                                          ? 'u'
                                          : "mg",
                                      delete: true,
                                      previousData: previousData,
                                      time: _timeController.text,
                                      date: _dateController.text)
                                  .then((value) {
                                refresh();
                              });
                            }
                          },
                          color: Colors.red.shade400,
                          textColor: Colors.white,
                          child:
                              Text("delete".tr, style: TextStyle(fontSize: 14)),
                        ))
                    : SizedBox(),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      width: Get.width,
                      child: RaisedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        padding: EdgeInsets.all(15.0),
                        elevation: 0,
                        onPressed: () {
                          // Get.back();
                          print('ba');
                          if (pressureType == false) {
                            if (dbp.text.isNotEmpty &&
                                sbp.text.isNotEmpty &&
                                map.text.isNotEmpty &&
                                _dateController.text.isNotEmpty &&
                                _timeController.text.isNotEmpty
                            ) {
                              edit == false
                                  ? circulationSheetController
                                      .onSaved(
                                          data: patientSlipController
                                              .patientDetailsData[0],
                                          sbp: sbp.text,
                                          dbp: dbp.text,
                                          map: map.text,
                                          tablenumber: 0,
                                          date: _dateController.text,
                                          time: _timeController.text)
                                      .then((value) {
                                      refresh();
                                      sbp.clear();
                                      dbp.clear();
                                      map.clear();
                                    })
                                  : circulationSheetController
                                      .onEdit(
                                          data: patientSlipController
                                              .patientDetailsData[0],
                                          sbp: sbp.text,
                                          dbp: dbp.text,
                                          map: map.text,
                                          previousData: previousData,
                                          delete: false,
                                          tablenumber: 0,
                                          time: _timeController.text,
                                          date: _dateController.text)
                                      .then((value) {
                                      refresh();
                                    });
                            } else {
                              ShowMsg('all_mandatory'.tr);
                              print('all fields required');
                            }
                            ;
                          } else {
                            //************##### else block is for vasolpressor table *****************//
                            if (patientSlipController
                                    .patientDetailsData[0]
                                    ?.anthropometry
                                    .isNullOrBlank //?.first?.discountedWeight?.isNullOrBlank
                                ||
                                patientSlipController
                                    .patientDetailsData[0]
                                    ?.anthropometry
                                    ?.first
                                    ?.discountedWeight
                                    ?.isNullOrBlank) {
                              ShowMsg("${'depends_on_anthro_data'.tr}");
                            } else {
                              // patientSlipController.patientDetailsData[0].anthropometry[0].discountedWeight.isNullOrBlank?ShowMsg("This user doesn't have discounted weight"):

                              if (drug_amount.text.isNotEmpty &&
                                  drpvalue.isNotEmpty &&
                                  drug_amount.text.isNotEmpty &&
                                  concentration.text.isNotEmpty &&
                                  diluent.text.isNotEmpty &&
                                  infusion.text.isNotEmpty &&
                                  _dateController.text.isNotEmpty &&
                                  _timeController.text.isNotEmpty


                              ) {
                                if (drpvalue.isNotEmpty) {
                                  dose = calculateDose(
                                      infusion.text,
                                      concentration.text,
                                      patientSlipController
                                          .patientDetailsData[0]
                                          .anthropometry[0]
                                          .discountedWeight,drpvalue);
                                } else {
                                  print('Please select drug');
                                  ShowMsg('please_select_drug'.tr);
                                }

                                // dose = calculateDose(infusion.text, concentration.text, patientSlipController.patientDetailsData[0].anthropometry[0].discountedWeight);
                                print('all... ${dose}');
                                print('eeditdddd>> ${edit}');
                                //edit ==false?
                                if (edit == false) {
                                  print('save here');
                                  circulationSheetController
                                      .onSaved(
                                          data: patientSlipController
                                              .patientDetailsData[0],
                                          tablenumber: 1,
                                          drug: drpvalue,
                                          drug_amt: drug_amount.text,
                                          concenteratrion: concentration.text,
                                          dose: dose,
                                          diluent: diluent.text,
                                          infusion: infusion.text,
                                          unitType: drpvalue == "vasopressin".tr
                                              ? 'u'
                                              : "mg",
                                          time: _timeController.text,
                                          date: _dateController.text)
                                      .then((value) {
                                    refresh();
                                    drpvalue = null;
                                    drug_amount.clear();
                                    concentration.clear();
                                    diluent.clear();
                                    infusion.clear();
                                  });
                                } else {
                                  print('edit here');
                                  print('.....${edit}');
                                  circulationSheetController
                                      .onEdit(
                                          data: patientSlipController
                                              .patientDetailsData[0],
                                          tablenumber: 1,
                                          drug: drpvalue,
                                          drug_amt: drug_amount.text,
                                          concenteratrion: concentration.text,
                                          dose: dose,
                                          diluent: diluent.text,
                                          infusion: infusion.text,
                                          unitType: drpvalue == "Vasopressin"
                                              ? 'u'
                                              : "mg",
                                          delete: false,
                                          previousData: previousData,
                                          time: _timeController.text,
                                          date: _dateController.text)
                                      .then((value) {
                                    refresh();
                                  });
                                }
                              } else {
                                ShowMsg('all_mandatory'.tr);
                                print('all fields required');
                              }
                            }
                          }
                        },
                        color: primary_color,
                        textColor: Colors.white,
                        child: Text("save".tr, style: TextStyle(fontSize: 14)),
                      )),
                )
              ],
            );
          });
        });
  }

//
  TextEditingController calculated_map() {
    if (sbp.text.isEmpty || dbp.text.isEmpty) {
      print('else...');
      map.clear();
      setState(() {});

      // map.clear();
      print('.....m${map.text}');
      return TextEditingController(text: '');
    } else {
      print('calculated map');
      var a = 1 / 3 * double.parse(sbp.text) + 2 / 3 * double.parse(dbp.text);
      print('...mapcal......${a.toString()}');
      // var b = double.parse('${a}'.substring(0, '${a}'.indexOf('.') + 2 + 1));
      var b = double.parse((double.parse(a.toString())).toStringAsFixed(2));
      print('...mapcal__b......${b.toString()}');

      return TextEditingController(text: b.toString());
    }
  }

  TextEditingController calculated_concenteration(String unit,
      TextEditingController drugAmount, TextEditingController diluent) {
    print(';;calalalaa');
    if (drugAmount.text.isEmpty || diluent.text.isEmpty) {
      print('all fields are not there');
      return TextEditingController(text: '');
    } else {
      // getAgeYearsFromDate(widget.patientDetailsData.dob);
      // if(widget.patientDetailsData.)
      if (unit != null) {
        if (unit == 'MG') {
          var a =
              double.parse(drugAmount.text) * 1000 / double.parse(diluent.text);
          var b = double.parse((double.parse(a.toString())).toStringAsFixed(2));
          return TextEditingController(text: b.toString());
        } else if (unit == 'U') {
          var a = double.parse(drugAmount.text) / double.parse(diluent.text);
          var b = double.parse((double.parse(a.toString())).toStringAsFixed(2));
          print(';;calalalaa ${b.toString()}');

          return TextEditingController(text: b.toString());
        } else {
          print('undefined unit');
        }
      } else {
        ShowMsg('Please select drug first');
      }
    }
  }

  String calculateDose(
      String infusion, String concenteration, String weightAfter_Discount,String drug) {
    adLog('drug :: ${drug}');

//try{

    if(drug == 'vasopressin'.tr){
      var a = double.parse(infusion) * double.parse(concenteration) / 60;
      var b = double.parse((double.parse(a.toString())).toStringAsFixed(2));
      return b.toString();
    }else {
      var a = double.parse(infusion) * double.parse(concenteration) / 60 /
          double.parse(weightAfter_Discount);
      var b = double.parse((double.parse(a.toString())).toStringAsFixed(2));
      return b.toString();
    }

//    "vasopressin".tr

//}
//catch(e){
    // print(' it has exception.. ${e.toString()} ');
//}
  }

  refresh() async {
    bool mode = await patientSlipController
        .getRoute(widget.patientDetailsData.hospital.first.sId);
    if (mode != null && mode) {
      await patientSlipController.getDetails(widget.patientDetailsData.sId, 0);
      print('internet avialable');
    } else {
      await patientSlipController.getDetailsOffline(
          widget.patientDetailsData.sId, 0);
    }
    // print('....vlu...${value}');
    dbp.clear();
    sbp.clear();
    map.clear();
    selectedIndex = 0;
  }
}
//updated by raman at 14 oct 12:28
