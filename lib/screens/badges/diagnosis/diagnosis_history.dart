import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/HistoryModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import '../../../config/cons/timeago_format.dart';

class DiagnosisHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String type;
  final String HistorName;
  DiagnosisHistory({this.patientDetailsData, this.type, this.HistorName});

  @override
  _DiagnosisHistoryState createState() => _DiagnosisHistoryState();
}

class _DiagnosisHistoryState extends State<DiagnosisHistory> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHistory(widget.patientDetailsData.sId, widget.type);
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
                  children: _controller.getHistoryData.map((e) {
                return mainWidget(e);

              }).toList()),
            ),
          ),
        ));
  }

  Widget mainWidget(HistoryData e){
    if (widget.type == ConstConfig.akpsHistory){
      return _akpsWidget(e);
    }else if(widget.type == ConstConfig.spictHistory){
      return _spictWidget(e);
    }else{
      return _widget(e);
    }
  }

  Widget _widget(HistoryData e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "${e.updatedAt}",
          //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          // ),
          // SizedBox(
          //   height: 5,
          // ),
          Text(
            "${e.message}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
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

  Widget _akpsWidget(HistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AKPS - ${e.message} %",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: e.message != null
                        ? int.parse(e.message) > 40
                            ? greenTxt_color
                            : redTxt_color
                        : redTxt_color),
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
            ]));
  }

  Widget _spictWidget(HistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SPICT - ${e.message}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: e.message.toLowerCase() =="Positive".toLowerCase()
                        ? greenTxt_color
                        :
                    redTxt_color),
              ),

            Column(children: [
              Text(
                "SPICT - ${e.message}",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: e.message.toLowerCase() =="Positive".toLowerCase()
                        ? greenTxt_color
                        :
                    redTxt_color),
              ),
            ],),

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
