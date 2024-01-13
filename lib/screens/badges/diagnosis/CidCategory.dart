import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class DiagnosisHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String type;
  final String HistorName;
  DiagnosisHistoryScreen({this.patientDetailsData, this.type, this.HistorName});
  @override
  _DiagnosisHistoryScreenState createState() => _DiagnosisHistoryScreenState();
}

class _DiagnosisHistoryScreenState extends State<DiagnosisHistoryScreen> {
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
    return _widget(e);
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
                .map(
                    (e2) => Column(children: [
                  Text(
                    "${e.multipalmessage.indexOf(e2)+1}. ${e2.optionname}",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  ),
                  SizedBox(height: 5,)
                ],)
            )
                .toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                '${timeago.format(DateTime.parse(e.updatedAt))}',
                // 'nsdkjjk',
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
