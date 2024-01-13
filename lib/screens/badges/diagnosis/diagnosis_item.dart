import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/config/widgets/multi_text_fields.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/diagnosis_controller/diagnosisController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/diagnosis/CID.dart';
import 'package:medical_app/screens/badges/status/MNA.dart';
import 'package:medical_app/screens/badges/status/NRS_2002.dart';
import 'package:medical_app/screens/badges/status/Strongkids.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';
import 'package:medical_app/screens/badges/palcare/goal_history.dart';
import 'package:page_indicator/page_indicator.dart';
// import 'package:page_slider/page_slider.dart';

class DiagnosisItemScreen extends StatefulWidget {
  // final String patientId;
  // DiagnosisItemScreen({this.patientId});
  final List<PatientDetailsData> patientDetailsData;
  DiagnosisItemScreen({this.patientDetailsData});
  @override
  _DiagnosisItemScreenState createState() => _DiagnosisItemScreenState();
}

class _DiagnosisItemScreenState extends State<DiagnosisItemScreen> {
  // GlobalKey<PageSliderState> _sliderKey = GlobalKey();
  final DiagnosisController _controller = DiagnosisController();
  final PatientSlipController _patientSlipController = PatientSlipController();
  final Accessibility accessibility = Accessibility();

  var diagnosisText = TextEditingController();
  var observationText = TextEditingController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: accessibility
            .getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? Center(child: CircularProgressIndicator(),)
              : Column(
                  children: [
                    widget.patientDetailsData.isEmpty
                        ? Container()
                        : InkWell(
                            onTap: () {
                              if (access.diagnosis) {
                                Get.to(CIDs(
                                  patientDetailsData:
                                      widget.patientDetailsData[0],
                                ));
                              }
                            },
                            child: Container(
                              height: 200,
                              child: Card(
                                color: access.diagnosis
                                    ? card_color
                                    : disable_color,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(
                                        width: 1, color: primary_color)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primary_color,
                                          // border: Border.all(
                                          //   color: Colors.red[340],
                                          // ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8.0,
                                                left: 16.0),
                                            child: Text(
                                              'diagnosis'.tr,
                                              style: TextStyle(
                                                color: card_color,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            // radius: 50.0,
                                            onTap: () {
                                              Get.to(GoalHistoryScreen(
                                                patientDetailsData: widget
                                                    .patientDetailsData[0],
                                                type: ConstConfig
                                                    .diagnosisHistoryMultiple,
                                                HistorName: 'diagnosis_history'.tr,
                                              ));
                                            },
                                            child: Container(
                                              //margin: EdgeInsets.only(right: 8.0,),
                                              //color: Colors.red,
                                              width: 70,
                                              height: 30.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.historyClockIcon,
                                                    color: card_color,
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 16.0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: widget.patientDetailsData.isEmpty
                                            ? Container()
                                            : SingleChildScrollView(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 0, 0, 12),
                                                  child: widget
                                                          .patientDetailsData[0]
                                                          .diagnosis
                                                          .isNotEmpty
                                                      ? Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: widget
                                                              .patientDetailsData[
                                                                  0]
                                                              .diagnosis[0]
                                                              .cidData
                                                              .map(
                                                                (e) => Text(
                                                                  "${widget.patientDetailsData[0].diagnosis[0].cidData.indexOf(e) + 1}. ${e.cidname}"
                                                                      .trim(),
                                                                  style:
                                                                      TextStyle(),
                                                                ),
                                                              )
                                                              .toList(),
                                                        )
                                                      : SizedBox(),
                                                ),
                                              )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: widget.patientDetailsData[0]
                                                  .diagnosis.isNotEmpty
                                              ? Text(
                                                  "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(widget.patientDetailsData[0].diagnosis[0].lastUpdate ?? '${DateTime.now()}'))}",
                                                  style: TextStyle(
                                                      color: primary_color,
                                                      fontSize: 10),
                                                )
                                              : SizedBox(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    widget.patientDetailsData.isEmpty
                        ? Container()
                        : InkWell(
                            onTap: () {
                              if (access.diagnosis) {
                                Get.to(FreeTextScreen(
                                  text: "observations".tr,
                                  fillValue: widget.patientDetailsData[0]
                                          .hospital[0].observation ??
                                      '',
                                  function: () {
                                    print(widget.patientDetailsData.length);

                                    checkConnectivityWithToggle(widget
                                            .patientDetailsData[0]
                                            .hospital[0]
                                            .sId)
                                        .then((internet) {
                                      print('internet');
                                      if (internet != null && internet) {
                                        // observationText.text = widget.patientDetailsData[0].hospital[0].observation??'';
                                        _controller
                                            .saveObservation(
                                                widget.patientDetailsData[0],
                                                observationText.text)
                                            .then((value) {
                                          setState(() {});
                                          print("value: $value");
                                          if (value == 'success') {
                                            checkConnectivity()
                                                .then((internet) {
                                              print('internet');
                                              if (internet != null &&
                                                  internet) {
                                                _patientSlipController
                                                    .getDetails(
                                                        widget
                                                            .patientDetailsData[
                                                                0]
                                                            .sId,
                                                        0);
                                                print('internet avialable');
                                              }
                                            });
                                          }
                                        });
                                        print('internet avialable');
                                      } else {
                                        _controller.saveObservationOffline(
                                            widget.patientDetailsData[0],
                                            observationText.text);
                                      }
                                    });
                                  },
                                  controller: observationText,
                                ));
                              }
                            },
                            child: Container(
                              height: 200,
                              child: Card(
                                color: access.diagnosis
                                    ? card_color
                                    : disable_color,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    side: BorderSide(
                                        width: 1, color: primary_color)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: primary_color,
                                          // border: Border.all(
                                          //   color: Colors.red[340],
                                          // ),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8.0,
                                                left: 16.0),
                                            child: Text(
                                              'observations'.tr,
                                              style: TextStyle(
                                                color: card_color,
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(DiagnosisHistory(
                                                patientDetailsData: widget
                                                    .patientDetailsData[0],
                                                HistorName:
                                                    "observation_history".tr,
                                                type: ConstConfig.obsHistory,
                                              ));
                                            },
                                            child: Container(
                                              //margin: EdgeInsets.only(right: 8.0,),
                                              //color: Colors.red,
                                              width: 70,
                                              height: 30.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SvgPicture.asset(
                                                    AppImages.historyClockIcon,
                                                    color: card_color,
                                                    height: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 16.0,
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 0, 0, 12),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "${widget.patientDetailsData[0].hospital[0].observation ?? ''}",
                                                    style: TextStyle(),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: widget
                                                      .patientDetailsData[0]
                                                      .hospital[0]
                                                      ?.observationLastUpdate !=
                                                  null
                                              ? Text(
                                                  "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(widget.patientDetailsData[0].hospital[0]?.observationLastUpdate ?? '${DateTime.now()}'))}",
                                                  style: TextStyle(
                                                      color: primary_color,
                                                      fontSize: 10),
                                                )
                                              : SizedBox(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                  ],
                );
        });
  }
}
