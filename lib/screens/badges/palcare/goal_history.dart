import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
// import 'package:timeago/timeago.dart' as timeago;

import '../../../config/cons/timeago_format.dart';

class GoalHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String type;
  final String HistorName;

  GoalHistoryScreen({this.patientDetailsData, this.type, this.HistorName});

  @override
  _GoalHistoryScreenState createState() => _GoalHistoryScreenState();
}

class _GoalHistoryScreenState extends State<GoalHistoryScreen> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getMultipleHistory(
            widget.patientDetailsData.sId, widget.type);
        print('internet avialable');
      }
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
    if (widget.type == ConstConfig.spictHistory) {
      return _spictWidget(e);
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: e.multipalmessage
                .map((e2) => Column(
                      children: [
                        Text(
                          "${e.multipalmessage.indexOf(e2) + 1}. ${widget.type == ConstConfig.diagnosisHistoryMultiple ? e2.cidname : e2.optionname}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    ))
                .toList(),
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

  Widget _spictWidget(MultipleMsgData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage
                      .map((e2) => ExpansionTile(
                            title: Text(
                              "${'spict'.tr} - ${e2.status.toLowerCase().tr}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color: e2.status.toLowerCase() ==
                                          "Positive".toLowerCase()
                                      ? redTxt_color
                                      : greenTxt_color),
                            ),
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e2.spictData
                                    .map((e3) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "${e3.categoryname}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: e3.options
                                                    .map(
                                                      (e4) => e4.isSelected
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 5),
                                                              child: Text(
                                                                "${e4.subcategoryname}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    )
                                                    .toList()),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ))
                                    .toList(),
                              )
                            ],
                          ))
                      .toList()),
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
            ]));
  }
}
