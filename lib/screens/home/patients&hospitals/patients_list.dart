import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/patient&hospital_controller/PatientListController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/hospitalization_controller/re_admit_controller.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/screens/home/hospitalization/add_patient_screen.dart';
import 'package:medical_app/screens/home/hospitalization/auto_fill_hosp_details_add_patient.dart';
import 'package:medical_app/screens/home/hospitalization/new_hospitalization.dart';
import 'package:medical_app/screens/home/hospitalization/re_admit.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import '../../../config/cons/timeago_format.dart';

class PatientListScreen extends StatefulWidget {
  final String hospId;
  final String wardId;
  final String bedId;

  PatientListScreen({this.hospId, this.wardId, this.bedId});

  @override
  _PatientListScreenState createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final _key = GlobalKey();

  final PatientListController _controller = PatientListController();
  final PatientSlipController _patientSlipController = PatientSlipController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivityWihtoutMsg().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHospitalData();
        print('internet avialable');
      } else {
        _controller.getFromSqflite();
      }
    });
    super.initState();
  }

  final FocusNode _nodeText1 = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _nodeText1,
        ),
      ],
    );
  }

  List<PatientData> recentdata = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appbarwidget(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!

            // if (!widget.hospId.isNullOrBlank &&
            //     !widget.wardId.isNullOrBlank &&
            //     !widget.bedId.isNullOrBlank) {
            //   Get.to(AutoFillHospDetailsAddPatient(
            //     title: 'start_new_hospitalization'.tr,
            //     hospId: widget.hospId,
            //     wardId: widget.wardId,
            //     bedId: widget.bedId,
            //   ));
            // } else {
              // Get.to(NewHospitalizationScreen(
              //   title: "start_new_hospitalization".tr,
              // ));

              Get.to(AddPatientScreen(title: "start_new_hospitalization".tr,
                    hospId: widget.hospId,
                    wardId: widget.wardId,
                    bedId: widget.bedId,isEdit: false,
              ));
            // }
          },
          child: Icon(
            Icons.add,
            size: 40,
          ),
          // backgroundColor: Colors.green,
        ),
        bottomNavigationBar: CommonHomeButton(),
        body: Obx(() => Container(
              //height: Get.height,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.patientslList.length,
                    itemBuilder: (context, index) {
                      if (searchController.isEmpty) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                focusNode.unfocus();
                                // opendialog(_controller.patientslList[index]);

                                print(
                                    'patient id:${_controller.patientslList[index].sId}');
                                opendialogAsk(_controller.patientslList[index]);
                              },
                              child: Card(
                                color: card_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(
                                        width: 1, color: primary_color)),

                                child:
                                    //
                                    // Row(
                                    //   children: [
                                    Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //    child:

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${'patient_name'.tr} - ",
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          _controller.patientslList[index].name
                                                      .length >
                                                  22
                                              ? Expanded(
                                                  child: Text(
                                                  '${_controller.patientslList[index].name}',
                                                  style: TextStyle(
                                                      color: black40_color,
                                                      fontSize: 15),
                                                  //maxLines: 1,overflow: TextOverflow.ellipsis,
                                                ))
                                              : Expanded(
                                                  child: Text(
                                                    '${_controller.patientslList[index].name}',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                    // maxLines: 1,overflow: TextOverflow.ellipsis,
                                                  ),
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${'hospitalized_'.tr} - ',
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            getTimeAgo(_controller
                                                .patientslList[index]
                                                .admissionDate),
                                            style: TextStyle(
                                                color: black40_color,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${'status'.tr} - ',
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "${_controller.patientslList[index].discharge || _controller.patientslList[index].died ? "${_controller.patientslList[index].discharge ? "discharge".tr : 'died'.tr}" : 'active'.tr}",
                                            style: TextStyle(
                                                color: black40_color,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),

                                      //)
                                    ],
                                  ),
                                ),
                                //   ],
                                // ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      } else if (_controller.patientslList[index].name
                              .toLowerCase()
                              .contains(searchController) ||
                          _controller.patientslList[index].name
                              .toLowerCase()
                              .contains(searchController)) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                focusNode.unfocus();
                                // opendialog(_controller.patientslList[index]);

                                print(
                                    'patient id:${_controller.patientslList[index].sId}');
                                opendialogAsk(_controller.patientslList[index]);
                              },
                              child: Card(
                                color: card_color,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(
                                        width: 1, color: primary_color)),

                                child:
                                    //
                                    // Row(
                                    //   children: [
                                    Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 0, 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Container(
                                      //    child:

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Patient's name - ",
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          _controller.patientslList[index].name
                                                      .length >
                                                  22
                                              ? Expanded(
                                                  child: Text(
                                                  '${_controller.patientslList[index].name}',
                                                  style: TextStyle(
                                                      color: black40_color,
                                                      fontSize: 15),
                                                  //maxLines: 1,overflow: TextOverflow.ellipsis,
                                                ))
                                              : Expanded(
                                                  child: Text(
                                                    '${_controller.patientslList[index].name}',
                                                    style: TextStyle(
                                                        color: black40_color,
                                                        fontSize: 15),
                                                    // maxLines: 1,overflow: TextOverflow.ellipsis,
                                                  ),
                                                )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Hospitalized - ',
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            getTimeAgo(_controller
                                                .patientslList[index]
                                                .admissionDate),
                                            style: TextStyle(
                                                color: black40_color,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'status'.tr + ' - ',
                                            style: TextStyle(
                                                color: primary_color,
                                                fontSize: 15),
                                          ),
                                          Text(
                                            "${_controller.patientslList[index].discharge || _controller.patientslList[index].died ? "${_controller.patientslList[index].discharge ? "Dis-Charged" : "died".tr}" : 'active'.tr}",
                                            style: TextStyle(
                                                color: black40_color,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),

                                      //)
                                    ],
                                  ),
                                ),
                                //   ],
                                // ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),
            )));
  }

  Widget _appbarwidget() {
    return AppBar(
        title: Text(
          "patients_list".tr,
          style: TextStyle(color: card_color),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: primary_color,
        iconTheme: IconThemeData(color: card_color),
        bottom: PreferredSize(
            //Here is the preferred height.
            preferredSize: Size.fromHeight(70.0),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildSearchField()),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'sort_by'.tr,
                              style: TextStyle(color: card_color, fontSize: 15),
                            ),
                            PopupMenuButton<String>(
                              key: _key,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: card_color,
                                size: 30,
                              ),
                              itemBuilder: (context) {
                                return <PopupMenuEntry<String>>[
                                  PopupMenuItem(
                                    child: Text('abc'.tr),
                                    value: 'Abc',
                                  ),
                                  PopupMenuItem(
                                    child: Text('recent'.tr),
                                    value: 'Recent',
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                print(value);
                                if (value == 'Abc') {
                                  print('abc format');
                                  // _controller.patientslList
                                  _controller.patientslList.sort((a, b) {
                                    return a.name
                                        .toString()
                                        .toLowerCase()
                                        .compareTo(
                                            b.name.toString().toLowerCase());
                                  });
                                } else {
                                  _controller.patientslList.sort((a, b) {
                                    var adate = a
                                        .createdAt; //before -> var adate = a.expiry;
                                    var bdate = b
                                        .createdAt; //before -> var bdate = b.expiry;
                                    return bdate.compareTo(
                                        adate); //to get the order other way just switch `adate & bdate`
                                  });
                                  // _controller.getHospitalData();
                                  // _controller.patientslList.sort((a, b) => a.compareTo(b));
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            )));
  }

  String searchController = '';

  Widget _buildSearchField() {
    return Container(
        height: 40,
        decoration: BoxDecoration(
          color: card_color,
          borderRadius: new BorderRadius.circular(40.0),
        ),
        child: Padding(
            padding: EdgeInsets.only(left: 30, right: 10, top: 0),
            child: TextFormField(
              autofocus: false,
              focusNode: focusNode,
              // controller: searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'search'.tr,
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchController = val;
                });
                if (val.isNotEmpty) {
                  print('searching');
                } else {
                  print('search field empty');
                  focusNode.unfocus();
                }
              },
            )));
  }

  ReAdmit(String id) async {
    final ReAdmitController admitController = ReAdmitController();
    await admitController.getPatintsDetails(id).then((res) {
      print(
          'json encoded: ${jsonEncode(_patientSlipController.patientDetailsData)}');

      // Get.to(ReAdmitPatient(
      //   title: "start_new_hospitalization".tr,
      //   patientDetail: [res],
      //   selectedHospital: res.hospital[0].name,
      //   hospId: widget.hospId ?? res.hospital[0].sId,
      //   wardId: widget.wardId ?? res.wardId.sId,
      //   bedId: widget.bedId ?? res.bedId.sId,
      // ));
      Get.to(AddPatientScreen(
        title: "start_new_hospitalization".tr,
        pData: res,
        hospId: widget.hospId ?? res.hospital[0].sId,
        wardId: widget.wardId ?? res.wardId.sId,
        bedId: widget.bedId ?? res.bedId.sId,
        isEdit: true,
      ));
    });
  }

  opendialogAsk(PatientData patientInfo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "choose_one".tr,
                        style: TextStyle(color: primary_color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            child: RaisedButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      width: 1.0, color: primary_color)),
                              padding: EdgeInsets.all(15.0),
                              onPressed: () async {
                                if (patientInfo.discharge) {
                                  Get.back();
                                  ReAdmit(patientInfo.sId);
                                } else {
                                  ShowMsg(
                                      'only_Discharged_patients_can_access'.tr);
                                }
                                // Get.to(NewHospitalizationScreenSecond(
                                //   title: "Start New Hospitalization",patientData: patientInfo,
                                // ));
                              },
                              color: patientInfo.discharge
                                  ? Colors.white
                                  : Colors.white,
                              textColor: primary_color,
                              child: Text("start_new_hospitalization".tr,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: patientInfo.discharge
                                          ? primary_color
                                          : disable_color)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Get.width,
                            child: RaisedButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      width: 1.0, color: primary_color)),
                              padding: EdgeInsets.all(15.0),
                              onPressed: () {
                                Get.back();
                                opendialog(patientInfo);
                              },
                              color: primary_color,
                              textColor: primary_color,
                              child: Text("history".tr,
                                  style: TextStyle(fontSize: 14)),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: primary_color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "close".tr,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  opendialog(PatientData patientInfo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "patients_info".tr,
                        style: TextStyle(color: primary_color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 0.0),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${'name'.tr} - ",
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  '${patientInfo.name}',
                                  style: TextStyle(
                                      color: black40_color, fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'email'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                '${patientInfo.email ?? 'not_filled'.tr}',
                                // '${patientInfo.admissionDate}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${"phone".tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                '${patientInfo.phone ?? 'not_filled'.tr}',
                                // '${patientInfo.admissionDate}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'hospital'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                '${patientInfo.hospital.first.name ?? ''}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                "${'ward'.tr} - ",
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                '${patientInfo.wardId.wardname ?? ''}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'bed'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  '${patientInfo.bedId.bedNumber ?? ''}',
                                  style: TextStyle(
                                      color: black40_color, fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'medical'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Expanded(
                                child: Text(
                                  '${patientInfo.medicalId.division ?? ''}',
                                  style: TextStyle(
                                      color: black40_color, fontSize: 15),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'dob'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                '${patientInfo.dob}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'hospitalized'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                getTimeAgo(patientInfo.admissionDate),

                                // '${patientInfo.admissionDate}',
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'status'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                "${patientInfo.discharge || patientInfo.died ? "${patientInfo.discharge ? "discharge".tr : "died".tr}" : 'active'.tr}",
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text(
                                '${'created_at'.tr} - ',
                                style: TextStyle(
                                    color: primary_color, fontSize: 15),
                              ),
                              Text(
                                getTimeAgo(patientInfo.createdAt),
                                style: TextStyle(
                                    color: black40_color, fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: primary_color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "close".tr,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
