import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/pressure_controller.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/NRSHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_history.dart';
import 'package:medical_app/model/vigilance/pressure_risk_hitory_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PressureRiskHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String HistorName;

  PressureRiskHistoryScreen({this.patientDetailsData, this.HistorName});
  @override
  _PressureRiskHistoryScreenState createState() => _PressureRiskHistoryScreenState();
}

class _PressureRiskHistoryScreenState extends State<PressureRiskHistoryScreen> {
  final PressureController _controller = PressureController();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHistoryData(
          widget.patientDetailsData.sId,
        );
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
                children: _controller.historyData.map((element) {
                  return mainWidget(element);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget mainWidget(PressureRiskData e) {
    return _MUSTWidget(e);
  }

  Widget _MUSTWidget(PressureRiskData e) {
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
                                      title:
                                      Text(
                                        "${e.multipalmessage.first.output}",
                                        style: TextStyle(fontSize: 15),
                                      ),


                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: e2.riskBradenData
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
                                                        "${e3.statusquestion}",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),

                                                      Column(children:e3.options.map((e4) => !e4.isSelected?SizedBox() :Text(
                                                        "${e4.statusoption}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      ),).toList(),)

                                                    ],
                                                  ))
                                              .toList(),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        )
                                      ],
                                    ))
                                .toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    '${timeago.format(DateTime.parse(e.updatedAt))}',
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
