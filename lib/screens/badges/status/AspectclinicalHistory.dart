import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/aspectDeficienciesController.dart';
import 'package:medical_app/model/clinicalAspectModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class AspectClinicalHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String HistorName;
  final String historyKey;

  AspectClinicalHistory(
      {this.patientDetailsData, this.HistorName, this.historyKey});

  @override
  _AspectClinicalHistoryState createState() => _AspectClinicalHistoryState();
}

class _AspectClinicalHistoryState extends State<AspectClinicalHistory> {
  final AspectDeficienciesController _controller =
      AspectDeficienciesController();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHistoryData(
            widget.patientDetailsData.sId, widget.historyKey);
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
                children: _controller.historyData.map((e) {
                  return _MUSTWidget(e);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget _MUSTWidget(AspectClinicalHistoryData e) {
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e2.options
                                    .map((e3) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            e3.isSelected
                                                ? Text(
                                                    "${e3.statusoption}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  )
                                                : SizedBox(),
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
            ]));
  }
}
