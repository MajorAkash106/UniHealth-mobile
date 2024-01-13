import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class conditionHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String type;
  final String HistorName;

  conditionHistory({this.patientDetailsData, this.type, this.HistorName});

  @override
  _conditionHistoryState createState() => _conditionHistoryState();
}

class _conditionHistoryState extends State<conditionHistory> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(milliseconds: 100), () {
      checkConnectivity().then((internet) {
        print('internet');
        if (internet != null && internet) {
          _controller.getMultipleHistory(
              widget.patientDetailsData.sId, widget.type);
          print('internet avialable');
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('${widget.HistorName}', null),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: _controller.getHistoryMultipleData.map((element) {
                  return mainWidget(element);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget mainWidget(MultipleMsgData e) {
    if (widget.type == ConstConfig.FastingOralHistory) {
      return _fastingWidget(e);
    } else if (widget.type == ConstConfig.ONSAcceptanceHistory) {
      return _ONSWidget(e);
    } else if (widget.type == ConstConfig.ORALAcceptanceHistory) {
      return _ORALWidget(e);
    } else {
      return _widget(e);
    }
  }

  Widget _widget(MultipleMsgData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e.multipalmessage[0].condition.isNullOrBlank ? "" : e.multipalmessage[0].condition.toLowerCase() == conditionNT.customized ? 'customized'.tr.toUpperCase() : e.multipalmessage[0].condition}',
                  style: TextStyle(
                      color: primary_color,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              ' kcal',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                            Text(
                              'ptn',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.0),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Min: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                    ),
                                    Text(
                                      '${e.multipalmessage[0].cutomizedData.minEnergy}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Min: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                    ),
                                    Text(
                                      '${e.multipalmessage[0].cutomizedData.minProtien}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Max: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                    ),
                                    Text(
                                      '${e.multipalmessage[0].cutomizedData.maxEnergy}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Max: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0),
                                    ),
                                    Text(
                                      '${e.multipalmessage[0].cutomizedData.maxProtien}',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13.0),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                // '${timeago.format(DateTime.parse(e.updatedAt))}',
                getTimeAgo(e.updatedAt),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _fastingWidget(MultipleMsgData e) {
    Multipalmessage data = e.multipalmessage.first;
    return data.fasting
        ? Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'patient_is_on_fasting'.tr,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${'fasting_reason'.tr} :',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0),
                ),
                Text(
                  '${data.fastingReason}'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      getTimeAgo(e.updatedAt),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: black40_color),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${data.condition}'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                Row(
                  children: [
                    Text(
                      ' ${'nt_team'.tr}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${data.teamAgree ? "agree".tr : "dis_agree".tr}',
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      ' kCal',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${data.kcal}',
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: [
                    Text(
                      ' Ptn',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${data.ptn} g',
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      getTimeAgo(e.updatedAt),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: black40_color),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          );
  }

  Widget _ONSWidget(MultipleMsgData e) {
    Multipalmessage data = e.multipalmessage.first;
    return data == null
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' ${data.condition}'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
                Row(
                  children: [
                    Text(
                      ' ${'nt_team'.tr}',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '${data.teamAgree ? "agree".tr : "dis_agree".tr}',
                      style: TextStyle(color: Colors.black, fontSize: 13.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  ' ${data.volume} ml ${data.times}x ${'per_day'.tr}',
                  style: TextStyle(color: Colors.black, fontSize: 13.0),
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Text(
                          ' kCal',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${data?.kcal}; ',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          ' Ptn',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${data?.ptn}; ',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Row(
                      children: [
                        Text(
                          ' ${'fiber'.tr}',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${data?.fiber};',
                          style: TextStyle(color: Colors.black, fontSize: 13.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      getTimeAgo(e.updatedAt),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: black40_color),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          );
  }

  Widget _ORALWidget(MultipleMsgData e) {
    Multipalmessage data = e.multipalmessage.first;
    return data == null
        ? SizedBox()
        : Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ...data.oralData.map((e) {
                      data.oralData
                          .sort((a, b) => a.lastUpdate.compareTo(b.lastUpdate));
                      return Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${'acceptance_avg'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '${e?.average ?? 'N/A'}%',
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'breakfast'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isBreakFast
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.breakFast}; ${e.data.breakFastPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'morning_snack'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isMorningSnack
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.morningSnack}; ${e.data.morningSnackPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'lunch'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isLunch
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.lunch}; ${e.data.lunchPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'afternoon_snack'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isNoon
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.noon}; ${e.data.noonPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'dinner'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isDinner
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.dinner}; ${e.data.dinnerPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'supper'.tr} ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                !e.data.isSupper
                                    ? Text(
                                        'missing_answer'.tr,
                                        style: TextStyle(fontSize: 13),
                                      )
                                    : Text(
                                        '${e.data.supper}; ${e.data.supperPer}%',
                                        style: TextStyle(fontSize: 13),
                                      ),
                              ],
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Row(
                              children: [
                                Text(
                                  '${'date'.tr}: ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                FutureBuilder(
                                    future: getDateFormatFromString(
                                        e.data.lastUpdate),
                                    initialData: "Loading text..",
                                    builder: (BuildContext context,
                                        AsyncSnapshot<String> snapshota) {
                                      return Text(
                                        '${snapshota.data}',
                                        style: TextStyle(fontSize: 13),
                                      );
                                    })
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    Text(
                      getTimeAgo(e.updatedAt),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: black40_color),
                    ),
                  ],
                ),
                Divider()
              ],
            ),
          );
  }
}
