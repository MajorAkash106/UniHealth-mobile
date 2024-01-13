import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/glimFunc.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/percentileFunc.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/status_controller/additionalNutritionalController.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NutritionalDiagnosisHistory.dart';
import 'package:medical_app/screens/badges/status/NutritionalScreeningHistory.dart';
import 'package:medical_app/screens/badges/status/anthro_box.dart';
import 'package:medical_app/screens/badges/status/aspectHistory.dart';
import 'package:medical_app/screens/badges/status/aspects_deficiencies.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';
import 'package:medical_app/screens/badges/status/nutritional_diagnosis.dart';
import 'package:medical_app/screens/badges/status/nutritional_screening.dart';
import 'package:page_indicator/page_indicator.dart';

import '../../../contollers/status_controller/MNAController.dart';

DateFormat dateFormat = DateFormat("yyyy-MM-dd");

class Status extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  final int index;

  Status({this.patientDetailsData, this.index});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  final NutritionalScreenController _nutritionalScreenController =
      NutritionalScreenController();
  final MNAController _mnaController = MNAController();

  final GetResultWHO _getResultWHO = GetResultWHO();

  @override
  void initState() {
    // print('-------------------------${widget.patientDetailsData[0].statusIndex}----------------------------------');

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _isloading = false;
        // _controller.jumpToPage(widget.patientDetailsData[0].statusIndex ?? 0);
      });
      if (widget.patientDetailsData.isNotEmpty) {
        getData();
        getData1();
        getData3();
        getData2();
        getYear();

        SaveDataSqflite sqflite = SaveDataSqflite();
        int statuslastIndex = 0;
        sqflite.getLastBadge(widget.patientDetailsData[0].sId).then((res) {
          statuslastIndex = res?.statusIndex ?? 0;
          print('geeting index ${statuslastIndex}');
          setState(() {
            _isloading = false;
            _controller.jumpToPage(statuslastIndex ?? 0);
          });
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  String ESPENRESULT = '';

  int patientsAge = 0;

  String NRS = '';
  String lastUpdate;

  String MNA = '';
  int MNAScore = 0;
  String MNALastUpdate;

  String MUST = '';
  int MUSTScore = 0;
  String MUSTLastUpdate;

  String STRONGKIDS = '';
  int STRONGKIDSScore = 0;
  String STRONGKIDSLastUpdate;

  List<DateTime> type0 = [];

  getData() {
    type0.clear();
    print("status len: ${widget.patientDetailsData[0].status.length}");
    for (var a = 0; a < widget.patientDetailsData[0].status.length; a++) {
      if (widget.patientDetailsData[0].status[a].type == '0') {
        if (widget.patientDetailsData[0].status[a].status.trim() ==
            'NRS - 2002'.trim()) {
          int score = int.parse(widget.patientDetailsData[0].status[a].score);
          lastUpdate = widget.patientDetailsData[0].status[a].updatedAt;
          type0.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));

          print('score: ${score}');
          getNRS(score).then((value) {
            print('return NRS: $value');
            setState(() {
              NRS = value;
            });
          });
        }

        if (widget.patientDetailsData[0].status[a].status.trim() ==
            'MNA - NNI'.trim()) {
          int score = int.parse(widget.patientDetailsData[0].status[a].score);
          MNALastUpdate = widget.patientDetailsData[0].status[a].updatedAt;
          type0.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          print('score: ${score}');
          getMNARESULT(score).then((value) {
            print('return MNA: $value');
            setState(() {
              MNA = value;
              MNAScore = score;
            });
          });
        }

        if (widget.patientDetailsData[0].status[a].status.trim() ==
            'STRONG - KIDS'.trim()) {
          int score = int.parse(widget.patientDetailsData[0].status[a].score);
          MNALastUpdate = widget.patientDetailsData[0].status[a].updatedAt;
          type0.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          print('score: ${score}');
          getSTRONGKIDS(score).then((value) {
            print('return MNA: $value');
            setState(() {
              STRONGKIDS = value;
              STRONGKIDSScore = score;
            });
          });
        }

        if (widget.patientDetailsData[0].status[a].status.trim() ==
            'MUST'.trim()) {
          int score = int.parse(widget.patientDetailsData[0].status[a].score);
          type0.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          print('score: ${score}');
          getMUST(score).then((value) {
            print('return MNA: $value');
            // print('MUST return: ${widget.patientDetailsData[0].scheduleDate}');
            setState(() {
              MUST = value;
              MUSTScore = score;
              // MUSTLastUpdate = widget.patientDetailsData[0].scheduleDate;
              MUSTLastUpdate =
                  widget.patientDetailsData[0].status[a].result[0].nextSchdule;

              print(MUSTScore);
              // MUST = score;
            });
          });
        } // break;


        if (widget.patientDetailsData[0].status[a].status.trim() ==
            'NUTRIC - SCORE'.trim()) {
          int score = int.parse(widget.patientDetailsData[0].status[a].score);
          type0.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          setState(() {

          });
        } // break;


      }
    }
  }

  List<Options> definciesData = [];
  String deficencies;
  String foodAllegres;
  String foodPerefrence;
  List<DateTime> type1 = [];

  getData1() {
    type1.clear();
    print("status len: ${widget.patientDetailsData[0].status.length}");
    definciesData.clear();
    for (var a = 0; a < widget.patientDetailsData[0].status.length; a++) {
      if (widget.patientDetailsData[0].status[a].type == '1') {
        if (widget.patientDetailsData[0].status[a].status.trim() ==
            aspectDeficiencies.clinical.trim()) {
          type1.add(DateTime.parse(
              widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          for (var b = 0;
              b <
                  widget.patientDetailsData[0].status[a].result[0].data[0]
                      .options.length;
              b++) {
            if (widget.patientDetailsData[0].status[a].result[0].data[0]
                .options[b].isSelected) {
              definciesData.add(widget.patientDetailsData[0].status[a].result[0]
                  .data[0].options[b]);
            }
          }
        }

        if (widget.patientDetailsData[0].status[a].status.trim() ==
            aspectDeficiencies.foodPreference.trim()) {
          setState(() {
            foodPerefrence =
                widget.patientDetailsData[0].status[a].result[0].dataText;
            type1.add(DateTime.parse(
                widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          });
        }

        if (widget.patientDetailsData[0].status[a].status.trim() ==
            aspectDeficiencies.foodAllergies.trim()) {
          setState(() {
            foodAllegres =
                widget.patientDetailsData[0].status[a].result[0].dataText;
            type1.add(DateTime.parse(
                widget.patientDetailsData[0].status[a].result[0].lastUpdate));
          });
        }
      }
    }

    setState(() {
      deficencies =
          definciesData.isNotEmpty ? definciesData[0].statusoption : '';
    });
  }

  String additionData;
  String additionDataLastDate;
  List<DateTime> type2 = [];

  getData3() {
    print("status len: ${widget.patientDetailsData[0].status.length}");
    for (var a = 0; a < widget.patientDetailsData[0].status.length; a++) {
      if (widget.patientDetailsData[0].status[a].type == '3') {
        if (widget.patientDetailsData[0].status[a].status.trim() ==
            additionalDataClass.additionalNutritionalData.trim()) {
          print(
              'additional data: ${widget.patientDetailsData[0].status[a].result[0].dataText}');
          setState(() {
            additionData =
                widget.patientDetailsData[0].status[a].result[0].dataText;
            additionDataLastDate =
                widget.patientDetailsData[0].status[a].result[0].lastUpdate;
          });
        }
        break;
      }
    }
  }

  // int patientAge = 0;

  getYear() {
    getAgeYearsFromDate(widget.patientDetailsData[0].dob).then((year) {
      print('get years of age $year');
      setState(() {
        patientsAge = year;
      });
    });
  }

  String glimResult = 'No malnutrition';
  String glimLastUpdate = '';
  bool isglim = false;

  getData2() {
    print('akash is testing');
    print("status len: ${widget.patientDetailsData[0].status.length}");
    for (var a = 0; a < widget.patientDetailsData[0].status.length; a++) {
      if (widget.patientDetailsData[0].status[a].type ==
              statusType.nutritionalDiagnosis &&
          widget.patientDetailsData[0].status[a].status ==
              nutritionalDiagnosis.glim) {
        print('return GLIM result: NO MALNUTRITION');

        GETGLIMRESULT(widget.patientDetailsData[0]).then((value) {
          print('return GLIM result: ${value}');

          // backend need  glim result without calculation..
          // sendToBackendGLIM(widget.patientDetailsData[0], value??'');

          setState(() {
            glimResult = value ?? '';
            glimLastUpdate =
                widget.patientDetailsData[0].status[a].result[0].lastUpdate;
          });
        });

        setState(() {
          isglim = true;
        });
        break;
      }
    }
  }

  getMAMCPerTitle(String mamc) {
    double total = double.parse(mamc);

    if (total < 70.0) {
      return '< 70, SEVERE MALNUTRITION';
    } else if (total >= 70.0 && total < 80.0) {
      return '>= 70 & < 80, MODERATE MALNUTRITION';
    } else if (total >= 80.0 && total < 90.0) {
      return '>= 80 & < 90, MILD MALNUTRITION';
    } else if (total >= 90.0) {
      return '>= 90, EUTROPHIC';
    }
  }

  bool _isloading = true;

  final AdditionalController _additionalController = AdditionalController();
  final HistoryController _historyController = HistoryController();

  getTypeHeightWeight(String val) {
    if (val == '0') {
      return 'Measured'.toUpperCase();
    } else if (val == '1') {
      return 'Reported'.toUpperCase();
    } else if (val == '2') {
      return 'Assumption'.toUpperCase();
    } else if (val == '3') {
      return 'Estimated'.toUpperCase();
    }
  }

  getSTRONGKIDSColors(String score) {
    if (score.toLowerCase() == 'low_risk'.tr.toLowerCase()) {
      return greenTxt_color;
    } else if (score.toLowerCase() == 'medium_risk'.tr.toLowerCase()) {
      return Colors.orange;
    } else if (score.toLowerCase() == 'high_risk'.tr.toLowerCase()) {
      //ask to client
      return redTxt_color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.patientDetailsData.isEmpty
        ? SizedBox()
        : Stack(
            children: <Widget>[
              Opacity(
                opacity:
                    1, // You can reduce this when loading to give different effect
                child: AbsorbPointer(
                    absorbing: _isloading,
                    child: Column(
                      children: [
                        AnthroBox(
                          patientDetailsData: widget.patientDetailsData,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(height: 230, child: _slider())
                      ],
                    )),
              ),
              Opacity(
                opacity: _isloading ? 1.0 : 0,
                child: Container(
                  height: 200,
                  child: Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  )),
                ),
              ),
            ],
          );
  }

  int selectedIndex = 0;
  Accessibility accessibility = Accessibility();
  final _controller = PageController(initialPage: 0);

  Widget _slider() {
    return FutureBuilder(
        future: accessibility
            .getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? SizedBox()
              : PageIndicatorContainer(
                  child: PageView(
                    controller: _controller,
                    // pageSnapping: false,
                    allowImplicitScrolling: false,
                    onPageChanged: (int index) {
                      print(index);
                      widget.patientDetailsData[0].statusIndex = index;

                      SaveDataSqflite sqflite = SaveDataSqflite();
                      sqflite.saveLastBadge(
                          widget.patientDetailsData[0].sId, 2, index);
                      setState(() {});
                    },
                    reverse: false,
                    children: [
                      _widget(access.status),
                      _widget4(access.status),
                      _widget2(access.status),
                      _widget3(access.status)
                    ],
                  ),
                  align: IndicatorAlign.bottom,
                  length: 4,
                  indicatorSpace: 10.0,
                  padding: const EdgeInsets.only(top: 0),
                  indicatorColor: black40_color,
                  indicatorSelectorColor: primary_color,
                  shape: IndicatorShape.roundRectangleShape(
                      size: const Size(40, 5)),
                );
        });
  }

  Widget _widget(bool access) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if (access) {
                List<StatusData> type1 = [];

                for (var a = 0;
                    a < widget.patientDetailsData[0].status.length;
                    a++) {
                  if (widget.patientDetailsData[0].status[a].type ==
                      statusType.nutritionalScreening) {
                    type1.add(widget.patientDetailsData[0].status[a]);
                  }
                }

                print(widget.patientDetailsData[0].status.length);
                print('type1 len: ${type1.length}');

                Get.to(NutrintionalScreening(
                  patientDetailsData: widget.patientDetailsData[0],
                  type1: type1,
                ));
              }
            },
            child: Card(
                color: access ? card_color : disable_color,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 16.0),
                                child: Text(
                                  'nutritional_screening'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              clicktoResult(),
                              InkWell(
                                onTap: () {
                                  // Get.to(NutrintionalScreening());
                                  print('type0 dates: ${type0}');

                                  Get.to(NutrintionalScreeningHistory(
                                    patientDetailsData:
                                        widget.patientDetailsData[0],
                                  ));
                                },
                                child: Container(
                                  //margin: EdgeInsets.only(right: 8.0,),
                                  //color: Colors.red,
                                  width: 60,
                                  height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${'nrs'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "$NRS",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: NRS.toLowerCase() ==
                                                "nt_risk".tr.toLowerCase()
                                            ? redTxt_color
                                            : greenTxt_color),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'mna'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "$MNA".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MNAScore <= 11
                                            ? redTxt_color
                                            : greenTxt_color),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'must'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "$MUST".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: MUSTScore == 0
                                            ? greenTxt_color
                                            : redTxt_color),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  MUSTScore == 1 &&
                                          DateTime.parse(MUSTLastUpdate)
                                              .compareTo(DateTime.now())
                                              .isNegative
                                      ? InkWell(
                                          onTap: () {
                                            _nutritionalScreenController
                                                .dietaryIntake(
                                                    widget
                                                        .patientDetailsData[0],
                                                    context);
                                          },
                                          child: Icon(
                                            Icons.warning_amber_outlined,
                                            color: Colors.red,
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Row(
                                children: [
                                  Text(
                                    "${'strong_kids'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    "$STRONGKIDS".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: getSTRONGKIDSColors(STRONGKIDS)),
                                  ),
                                  // SizedBox(
                                  //   width: 10,
                                  // ),
                                  // STRONGKIDS.isNotEmpty
                                  //     ? InkWell(
                                  //   onTap: () {
                                  //     opendialogStrongKids(context,
                                  //         STRONGKIDS, STRONGKIDSScore);
                                  //   },
                                  //   child: Container(
                                  //     // height: 40.0,
                                  //     width: 70.0,
                                  //     //color: Colors.red,
                                  //     child: Column(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.center,
                                  //       children: [
                                  //         Text(
                                  //           "MORE".toUpperCase(),
                                  //           style: TextStyle(
                                  //               fontSize: 12,
                                  //               color: Colors.blue,
                                  //               fontWeight:
                                  //               FontWeight.bold),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                  //     : SizedBox(),
                                ],
                              ),

                              SizedBox(
                                height: 5,
                              ),

                              Row(
                                children: [
                                  Text(
                                    "NUTRIC Score - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  FutureBuilder<String>(
                                    initialData: '',
                                    future: _mnaController.getNutricResult(
                                        widget.patientDetailsData.first),
                                    // async work
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshot) {

                                      debugPrint('snapshot.data ::${snapshot.data}');
                                      if(snapshot.data ==null || snapshot.data ==''){
                                        return SizedBox();
                                      }

                                      return Text(
                                        snapshot.data.tr,
                                        style: TextStyle(
                                            fontSize: 12,
                                            // color: getSTRONGKIDSColors(STRONGKIDS)
                                            color: snapshot.data ==
                                                'low_score'
                                                ? greenTxt_color
                                                : redTxt_color),
                                      );
                                    },
                                  )
                                ],
                              ),
                              // SizedBox(
                              //   height: 5,
                              // ),

                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    type0.isEmpty
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "",
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, bottom: 8),
                                child: Text(
                                  "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(updatedDate(type0)))}",
                                  // '${updatedDate(type0)}',
                                  style: TextStyle(
                                      color: primary_color, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }

  Widget _widget2(bool access) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if (access) {
                Get.to(NutrintionalDiagnosis(
                    patientDetailsData: widget.patientDetailsData[0]));
              }
            },
            child: Card(
                color: access ? card_color : disable_color,
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
                              // border: Border.all(
                              //   color: Colors.red[340],
                              // ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  topRight: Radius.circular(15.0))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 16.0),
                                child: Text(
                                  'nutritional_diagnosis'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              clicktoResult(),
                              InkWell(
                                onTap: () {
                                  // Get.to(NutrintionalDiagnosis());
                                  Get.to(NutrintionalDiagnosisHistory(
                                    patientDetailsData:
                                        widget.patientDetailsData[0],
                                  ));
                                },
                                child: Container(
                                  //margin: EdgeInsets.only(right: 8.0,),
                                  // color: Colors.red,
                                  width: 60,
                                  height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${'based_on_bmi'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  // Text(
                                  //   patientsAge < 19 ? "" : "$ESPENRESULT",
                                  //   style: TextStyle(fontSize: 13),
                                  // ),

                                  FutureBuilder(
                                      future: getESPENRESULT(
                                          widget.patientDetailsData[0]),
                                      initialData: "",
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String> value) {
                                        return value.data != null
                                            ? Text(
                                                patientsAge < 19
                                                    ? ""
                                                    : "${value.data}",
                                                style: TextStyle(fontSize: 13),
                                              )
                                            : SizedBox();
                                      })
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'glim'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  isglim
                                      ? autoSizableText(
                                          glimResult, 'glim'.tr, glimResult)
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'who'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  patientsAge < 19
                                      ? Obx(() => FutureBuilder(
                                          future: GETWHORESULT(
                                              widget.patientDetailsData[0]),
                                          initialData: "",
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> value) {
                                            // return autoSizableText("${value.data}", 'WHO', value.data);

                                            return value.data.isNullOrBlank
                                                ? SizedBox()
                                                : Flexible(
                                                    child: AutoSizeText(
                                                    value.data.trim(),
                                                    maxLines: 1,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                    minFontSize: 13,
                                                    overflowReplacement: Stack(
                                                      // This widget will be replaced.
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 34.40),
                                                          child: Text(
                                                            value.data.trim(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Positioned(
                                                            right: 2,
                                                            child: InkWell(
                                                              onTap: () {
                                                                value.data.runtimeType ==
                                                                        String
                                                                    ? ShowTextONPopup(
                                                                        context,
                                                                        "who"
                                                                            .tr,
                                                                        value
                                                                            .data)
                                                                    : ShowListONPopup(
                                                                        context,
                                                                        "who"
                                                                            .tr,
                                                                        []);
                                                              },
                                                              child: Container(
                                                                //height: 40.0,
                                                                width: 40.0,
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "more"
                                                                          .tr
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .blue,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ));
                                          }))
                                      : Text(
                                          '',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'cdc'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  patientsAge < 19
                                      ? Obx(() => FutureBuilder(
                                          future: GETCDCRESULT(
                                              widget.patientDetailsData[0]),
                                          initialData: "",
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> value) {
                                            // return autoSizableText("${value.data}", 'WHO', value.data);

                                            return value.data.isNullOrBlank
                                                ? SizedBox()
                                                : Flexible(
                                                    child: AutoSizeText(
                                                    value.data.trim(),
                                                    maxLines: 1,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                    minFontSize: 13,
                                                    overflowReplacement: Stack(
                                                      // This widget will be replaced.
                                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 34.40),
                                                          child: Text(
                                                            value.data.trim(),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Positioned(
                                                            right: 2,
                                                            child: InkWell(
                                                              onTap: () {
                                                                value.data.runtimeType ==
                                                                        String
                                                                    ? ShowTextONPopup(
                                                                        context,
                                                                        "cdc"
                                                                            .tr,
                                                                        value
                                                                            .data)
                                                                    : ShowListONPopup(
                                                                        context,
                                                                        "cdc"
                                                                            .tr,
                                                                        []);
                                                              },
                                                              child: Container(
                                                                //height: 40.0,
                                                                width: 40.0,
                                                                // color: Colors.red,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                      "more"
                                                                          .tr
                                                                          .toUpperCase(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .blue,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  ));
                                          }))
                                      : Text(
                                          '',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    FutureBuilder(
                        future:
                            LASTUPDATEDIAGNOSIS(widget.patientDetailsData[0]),
                        initialData: "",
                        builder: (BuildContext context,
                            AsyncSnapshot<String> value) {
                          return value.data == null
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
                                        "${'last_update'.tr} - ${value.data}",
                                        style: TextStyle(
                                            color: primary_color, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                );
                        })
                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }

  Widget _widget3(bool access) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if (access) {
                var additionalDataa = TextEditingController();

                Get.to(FreeTextScreen(
                  text: "additional_nutritional_data".tr,
                  controller: additionalDataa,
                  fillValue: additionData ?? '',
                  function: () {
                    // Get.back();
                    Map data = {
                      'status': additionalDataClass.additionalNutritionalData,
                      'score': '0',
                      'lastUpdate': '${DateTime.now()}',
                      'dataText': additionalDataa.text
                    };

                    List a = [];
                    a.add(data);

                    print('List a: $a');

                    checkConnectivityWithToggle(
                            widget.patientDetailsData[0].hospital[0].sId)
                        .then((internet) {
                      if (internet != null && internet) {
                        _additionalController
                            .saveData(
                                widget.patientDetailsData[0],
                                0,
                                additionalDataClass.additionalNutritionalData,
                                data)
                            .then((value) {
                          _historyController.saveHistory(
                              widget.patientDetailsData[0].sId,
                              ConstConfig.additionalDataHistory,
                              additionalDataa.text);
                        });
                      } else {
                        _additionalController.saveDataOffline(
                            widget.patientDetailsData[0],
                            0,
                            data,
                            additionalDataClass.additionalNutritionalData);
                      }
                    });
                  },
                ));
              }
            },
            child: Card(
              color: access ? card_color : disable_color,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  side: BorderSide(width: 1, color: primary_color)),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 16.0),
                          child: Text(
                            'additional_nutritional_data'.tr,
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
                              patientDetailsData: widget.patientDetailsData[0],
                              HistorName: 'history'.tr,
                              type: ConstConfig.additionalDataHistory,
                            ));
                          },
                          child: Container(
                            //margin: EdgeInsets.only(right: 8.0,),
                            //color: Colors.red,
                            width: 60,
                            height: 30.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                  Expanded(
                      child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                        child: Text(
                          '${additionData ?? ''}',
                          style: TextStyle(),
                        )),
                  )),
                  additionDataLastDate != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "",
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(additionDataLastDate))}",
                                style: TextStyle(
                                    color: primary_color, fontSize: 10),
                              ),
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }

  updatedDate(List<DateTime> list) {
    list.sort((b, a) => a.compareTo(b));
    return '${list[0]}';
  }

  Widget _widget4(bool access) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if (access) {
                Get.to(AdpectsDeficiencies(
                  patientDetailsData: widget.patientDetailsData,
                  foodAllergies: foodAllegres ?? '',
                  foodPereference: foodPerefrence ?? '',
                  list: definciesData,
                ));
              }
            },
            child: Card(
                color: access ? card_color : disable_color,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8.0, left: 16.0),
                                child: Text(
                                  'aspect_def'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              clicktoResult(),
                              InkWell(
                                onTap: () {
                                  // print('type1 : ${type1}');
                                  // type1.sort((b,a) => a.compareTo(b));
                                  //
                                  // print(type1);

                                  Get.to(AspectsDeficienciesHistory(
                                    patientDetailsData:
                                        widget.patientDetailsData,
                                  ));
                                },
                                child: Container(
                                  //margin: EdgeInsets.only(right: 8.0,),
                                  //color: Colors.red,
                                  width: 40,
                                  height: 30.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${'food_allergies'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  autoSizableText(foodAllegres,
                                      'food_allergies'.tr, deficencies)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'food_pref'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  autoSizableText(foodPerefrence,
                                      'food_pref'.tr, foodPerefrence)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${'deficencies'.tr} - ",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  autoSizableText(deficencies, 'deficencies'.tr,
                                      definciesData)
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    type1.isEmpty
                        ? SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "",
                                style: TextStyle(fontSize: 15),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, bottom: 8),
                                child: Text(
                                  "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(updatedDate(type1)))}",
                                  // '${updatedDate(type1)}',
                                  style: TextStyle(
                                      color: primary_color, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
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
                              "more".tr.toUpperCase(),
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

  Widget clicktoResult() {
    // return BlinkText(
    //   'Click to calculate Result',
    //   style: TextStyle(
    //     color: card_color,
    //     fontSize: 10,decoration: TextDecoration.underline,
    //     fontWeight: FontWeight.bold,
    //
    //   ),
    //   maxLines: 1,overflow: TextOverflow.ellipsis,
    //   endColor: Colors.red,
    // );
    return SizedBox();
  }
}
