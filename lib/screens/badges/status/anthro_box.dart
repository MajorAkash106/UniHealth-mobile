import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/AnthroHistoryScreen.dart';
import 'package:medical_app/screens/badges/status/Anthropometry_screen.dart';
import 'package:medical_app/screens/badges/status/Anthropometry_screen_kids.dart';

class AnthroBox extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  AnthroBox({this.patientDetailsData});

  @override
  _AnthroBoxState createState() => _AnthroBoxState();
}

class _AnthroBoxState extends State<AnthroBox> {
  final Accessibility accessibility = Accessibility();

  int patientsAge = 0;
  getYear() {
    getAgeYearsFromDate(widget.patientDetailsData[0].dob).then((year) {
      print('get years of age $year');
      setState(() {
        patientsAge = year;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getYear();
    refUnitStatus();
  }

  String refUnit = '';
  String weightIn = '';
  String heightIn = '';

  refUnitStatus() async {
    String refU =
        await MySharedPreferences.instance.getStringValue(Session.refUnit);
    setState(() {
      refUnit = refU.isEmpty ? '1' : refU;

      weightIn = refUnit == '1' ? 'kg' : 'lbs';

      heightIn = refUnit == '1' ? 'm' : 'inch';
    });
    print('reference unit: ${refUnit}-${weightIn},${heightIn}');
  }

  @override
  Widget build(BuildContext context) {
    return refUnit == '1' ? _KGS() : _LBS();
  }

  Widget _KGS() {
    return FutureBuilder(
        future: accessibility
            .getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : InkWell(
                  onTap: () {
                    if (access.anthro) {
                      print(widget.patientDetailsData[0].dob);
                      getAgeYearsFromDate(widget.patientDetailsData[0].dob)
                          .then((age) {
                        print('patients age: $age');
                        if (age >= 19) {
                          Get.to(Anthropometery(
                            patientDetailsData: widget.patientDetailsData[0],
                            isFromAnthroTab: true,
                          ));
                        } else {
                          Get.to(AnthropometeryKids(
                            patientDetailsData: widget.patientDetailsData[0],
                            isfromStatus: true,
                          ));
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 250,
                    child: Card(
                        color: access.anthro ? card_color : disable_color,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(width: 1, color: primary_color)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: primary_color,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0, left: 16.0),
                                        child: Text(
                                          'anthropometry'.tr,
                                          style: TextStyle(
                                            color: card_color,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Get.to(AnthropometryHistory());
                                          Get.to(AnthroHistoryScreen(
                                            patientDetailsData:
                                                widget.patientDetailsData[0],
                                            type: ConstConfig.anthroHistory,
                                            HistorName: 'history'.tr,
                                          ));
                                        },
                                        child: Container(
                                          //margin: EdgeInsets.only(right: 8.0,),
                                          // color: Colors.red,
                                          width: 60,
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
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${'weight'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData.isEmpty
                                              ? SizedBox()
                                              : widget.patientDetailsData[0]
                                                      .anthropometry.isEmpty
                                                  ? SizedBox()
                                                  : patientsAge < 19
                                                      ? Text(
                                                          "${widget.patientDetailsData[0].anthropometry[0].weightMeasuredReported} kg (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].weightType)})",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      : Text(
                                                          "${widget.patientDetailsData[0].anthropometry[0].discountedWeight} kg (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].weightType)}"
                                                          "${widget.patientDetailsData[0].anthropometry[0].edema == '' && widget.patientDetailsData[0].anthropometry[0].ascities == '' && widget.patientDetailsData[0].anthropometry[0].amputation == '' ? "" : '/${'after_discount'.tr}'})",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'height'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData.isEmpty
                                              ? SizedBox()
                                              : widget.patientDetailsData[0]
                                                      .anthropometry.isEmpty
                                                  ? SizedBox()
                                                  : Text(
                                                      "${widget.patientDetailsData[0].anthropometry[0].heightType == '3' ? widget.patientDetailsData[0].anthropometry[0].estimatedHeight : widget.patientDetailsData[0].anthropometry[0].heightMeasuredReported} ${widget.patientDetailsData[0].anthropometry[0].heightType == '3' ? 'cm' : 'cm'} (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].heightType)})",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'bmi'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData[0]
                                                  .anthropometry.isEmpty
                                              ? SizedBox()
                                              : Text(
                                                  "${widget.patientDetailsData[0].anthropometry[0].bmi} kg/m\u{00B2}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      patientsAge < 19
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                Text(
                                                  "${'mamc'.tr} - ",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                widget.patientDetailsData[0]
                                                        .anthropometry.isEmpty
                                                    ? SizedBox()
                                                    : widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .tST
                                                                .isNullOrBlank &&
                                                            widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .mUAC
                                                                .isNullOrBlank
                                                        ? Text(
                                                            "muac_tst_missing".tr,
                                                            // "(SWERE MALNUTRITION)",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        : widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .tST
                                                                .isNullOrBlank
                                                            ? Text(
                                                                "tst_missing".tr,
                                                                // "(SWERE MALNUTRITION)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              )
                                                            : widget
                                                                    .patientDetailsData[
                                                                        0]
                                                                    .anthropometry[
                                                                        0]
                                                                    .mUAC
                                                                    .isNullOrBlank
                                                                ? Text(
                                                                    "muac_missing".tr,
                                                                    // "(SWERE MALNUTRITION)",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                : autoSizableText(
                                                                    "${widget.patientDetailsData[0].anthropometry[0].mamcper} % (${getMAMCPerTitle(widget.patientDetailsData[0].anthropometry[0].mamcper).toString()})",
                                                                    'mamc_per'.tr,
                                                                    "${widget.patientDetailsData[0].anthropometry[0].mamcper} % (${getMAMCPerTitle(widget.patientDetailsData[0].anthropometry[0].mamcper).toString()})")
                                              ],
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      patientsAge < 19
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                Text(
                                                  "${'ideal_body_weight_max'.tr} - ",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                widget.patientDetailsData[0]
                                                        .anthropometry.isEmpty
                                                    ? SizedBox()
                                                    : widget
                                                            .patientDetailsData[
                                                                0]
                                                            .anthropometry[0]
                                                            .idealBodyWeight
                                                            .isEmpty
                                                        ? SizedBox()
                                                        : Text(
                                                            "${widget.patientDetailsData[0].anthropometry[0].idealBodyWeight} kg",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      widget.patientDetailsData[0].anthropometry
                                              .isEmpty
                                          ? SizedBox()
                                          : widget
                                                  .patientDetailsData[0]
                                                  .anthropometry[0]
                                                  .adjustedBodyWeight
                                                  .isEmpty
                                              ? SizedBox()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "${'adjusted_body_weight'.tr} - ",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "${widget.patientDetailsData[0].anthropometry[0].adjustedBodyWeight.isEmpty ? 0 : widget.patientDetailsData[0].anthropometry[0].adjustedBodyWeight} kg",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            widget.patientDetailsData[0].anthropometry.isEmpty
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 8),
                                        child: Text(
                                          "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(widget.patientDetailsData[0].anthropometry[0].lastUpdate))}",
                                          style: TextStyle(
                                              color: primary_color,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        )),
                  ));
        });
  }

  Widget _LBS() {
    return FutureBuilder(
        future: accessibility
            .getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )
              : InkWell(
                  onTap: () {
                    if (access.anthro) {
                      print(widget.patientDetailsData[0].dob);
                      getAgeYearsFromDate(widget.patientDetailsData[0].dob)
                          .then((age) {
                        print('patients age: $age');
                        if (age >= 19) {
                          Get.to(Anthropometery(
                            patientDetailsData: widget.patientDetailsData[0],
                            isFromAnthroTab: true,
                          ));
                        } else {
                          Get.to(AnthropometeryKids(
                            patientDetailsData: widget.patientDetailsData[0],
                            isfromStatus: true,
                          ));
                        }
                      });
                    }
                  },
                  child: Container(
                    height: 250,
                    child: Card(
                        color: card_color,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            side: BorderSide(width: 1, color: primary_color)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: primary_color,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15.0),
                                          topRight: Radius.circular(15.0))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0, left: 16.0),
                                        child: Text(
                                          'anthropometry'.tr,
                                          style: TextStyle(
                                            color: card_color,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // Get.to(AnthropometryHistory());
                                          Get.to(AnthroHistoryScreen(
                                            patientDetailsData:
                                                widget.patientDetailsData[0],
                                            type: ConstConfig.anthroHistory,
                                            HistorName: 'history'.tr,
                                          ));
                                        },
                                        child: Container(
                                          //margin: EdgeInsets.only(right: 8.0,),
                                          // color: Colors.red,
                                          width: 60,
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
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${'weight'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData.isEmpty
                                              ? SizedBox()
                                              : widget.patientDetailsData[0]
                                                      .anthropometry.isEmpty
                                                  ? SizedBox()
                                                  : patientsAge < 19
                                                      ? Text(
                                                          "${widget.patientDetailsData[0].anthropometry[0].weightMeasuredReportedLBS} lbs (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].weightType)})",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        )
                                                      : Text(
                                                          "${widget.patientDetailsData[0].anthropometry[0].discountedWeightLBS} lbs (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].weightType)}"
                                                          "${widget.patientDetailsData[0].anthropometry[0].edema == '' && widget.patientDetailsData[0].anthropometry[0].ascities == '' && widget.patientDetailsData[0].anthropometry[0].amputation == '' ? "" : '/${'after_discount'.tr}'})",
                                                          style: TextStyle(
                                                              fontSize: 13),
                                                        ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'height'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData.isEmpty
                                              ? SizedBox()
                                              : widget.patientDetailsData[0]
                                                      .anthropometry.isEmpty
                                                  ? SizedBox()
                                                  : Text(
                                                      "${widget.patientDetailsData[0].anthropometry[0].heightType == '3' ? widget.patientDetailsData[0].anthropometry[0].estimatedHeightInches : widget.patientDetailsData[0].anthropometry[0].heightMeasuredReported_inch} ${widget.patientDetailsData[0].anthropometry[0].heightType == '3' ? 'inches' : 'inches'} (${getTypeHeightWeight(widget.patientDetailsData[0].anthropometry[0].heightType)})",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${'bmi'.tr} - ",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          widget.patientDetailsData[0]
                                                  .anthropometry.isEmpty
                                              ? SizedBox()
                                              : Text(
                                                  "${widget.patientDetailsData[0].anthropometry[0].bmi} kg/m\u{00B2}",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      patientsAge < 19
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                Text(
                                                  "${'mamc_per'.tr} - ",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                widget.patientDetailsData[0]
                                                        .anthropometry.isEmpty
                                                    ? SizedBox()
                                                    : widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .tST
                                                                .isNullOrBlank &&
                                                            widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .mUAC
                                                                .isNullOrBlank
                                                        ? Text(
                                                            "muac_tst_missing".tr,
                                                            // "(SWERE MALNUTRITION)",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          )
                                                        : widget
                                                                .patientDetailsData[
                                                                    0]
                                                                .anthropometry[
                                                                    0]
                                                                .tST
                                                                .isNullOrBlank
                                                            ? Text(
                                                                "tst_missing".tr,
                                                                // "(SWERE MALNUTRITION)",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              )
                                                            : widget
                                                                    .patientDetailsData[
                                                                        0]
                                                                    .anthropometry[
                                                                        0]
                                                                    .mUAC
                                                                    .isNullOrBlank
                                                                ? Text(
                                                                    "muac_missing".tr,
                                                                    // "(SWERE MALNUTRITION)",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                : autoSizableText(
                                                                    "${widget.patientDetailsData[0].anthropometry[0].mamcper} % (${getMAMCPerTitle(widget.patientDetailsData[0].anthropometry[0].mamcper).toString()})",
                                                                    'mamc'.tr,
                                                                    "${widget.patientDetailsData[0].anthropometry[0].mamcper} % (${getMAMCPerTitle(widget.patientDetailsData[0].anthropometry[0].mamcper).toString()})")
                                              ],
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      patientsAge < 19
                                          ? SizedBox()
                                          : Row(
                                              children: [
                                                Text(
                                                  "${'ideal_body_weight_max'.tr} - ",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                ),
                                                widget.patientDetailsData[0]
                                                        .anthropometry.isEmpty
                                                    ? SizedBox()
                                                    : widget
                                                            .patientDetailsData[
                                                                0]
                                                            .anthropometry[0]
                                                            .idealBodyWeightLBS
                                                            .isEmpty
                                                        ? SizedBox()
                                                        : Text(
                                                            "${widget.patientDetailsData[0].anthropometry[0].idealBodyWeightLBS} lbs",
                                                            style: TextStyle(
                                                                fontSize: 13),
                                                          ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      widget.patientDetailsData[0].anthropometry
                                              .isEmpty
                                          ? SizedBox()
                                          : widget
                                                  .patientDetailsData[0]
                                                  .anthropometry[0]
                                                  .adjustedBodyWeightLBS
                                                  .isEmpty
                                              ? SizedBox()
                                              : Row(
                                                  children: [
                                                    Text(
                                                      "${'adjusted_body_weight'.tr} - ",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    Text(
                                                      "${widget.patientDetailsData[0].anthropometry[0].adjustedBodyWeightLBS.isEmpty ? 0 : widget.patientDetailsData[0].anthropometry[0].adjustedBodyWeightLBS} lbs",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            widget.patientDetailsData[0].anthropometry.isEmpty
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, bottom: 8),
                                        child: Text(
                                          "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(widget.patientDetailsData[0].anthropometry[0].lastUpdate))}",
                                          style: TextStyle(
                                              color: primary_color,
                                              fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        )),
                  ));
        });
  }

  getMAMCPerTitle(String mamc) {
    double total = double.parse(mamc);

    if (total < 70.0) {
      return 'severe_malnutrition'.tr;
    } else if (total >= 70.0 && total < 80.0) {
      return 'moderate_malnutrition'.tr;
    } else if (total >= 80.0 && total < 90.0) {
      return 'mild_malnutrition'.tr;
    } else if (total >= 90.0) {
      return 'eutrophic'.tr;
    }
  }

  getTypeHeightWeight(String val) {
    if (val == '0') {
      return 'measured'.tr.toUpperCase();
    } else if (val == '1') {
      return 'reported'.tr.toUpperCase();
    } else if (val == '2') {
      return 'assumption'.tr.toUpperCase();
    } else if (val == '3') {
      return 'estimated'.tr.toUpperCase();
    }
  }

  Widget autoSizableText(String text, String heading, var data) {
    return text.isNullOrBlank
        ? SizedBox()
        : Flexible(
            child: AutoSizeText(
            text.trim(),
            maxLines: 1,
            style: TextStyle(fontSize: 13),
            minFontSize: 13,
            overflowReplacement: Stack(
              // This widget will be replaced.
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 45),
                  child: Text(
                    text.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Positioned(
                    right: 2,
                    child: InkWell(
                      onTap: () {
                        data.runtimeType == String
                            ? ShowTextONPopup(context, heading, data)
                            : ShowListONPopup(context, heading, data);
                      },
                      child: Container(
                        //height: 40.0,
                        width: 40.0,
                        // color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "more".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          ));
  }
}
