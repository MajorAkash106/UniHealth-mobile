import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/vigilance/balance_sheet_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/fluid_history_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class BalanceSheetHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String HistorName;

  BalanceSheetHistory({this.patientDetailsData, this.HistorName});
  @override
  _BalanceSheetHistoryState createState() => _BalanceSheetHistoryState();
}

class _BalanceSheetHistoryState extends State<BalanceSheetHistory> {
  final BalanceSheetController _controller = BalanceSheetController();

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

  List<String> heading = ['item'.tr, 'date'.tr, 'time'.tr, 'ml'.tr];
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

  Widget mainWidget(FluidHistoryData e) {
    return _MUSTWidget(e);
  }

  Widget _MUSTWidget(FluidHistoryData e) {
    return Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage
                      .map((e2) => ExpansionTile(
                            title: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "${'event'.tr} :",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${'balance_since'.tr} :",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  Text(
                                    " ${e.multipalmessage.first?.balanceSince ?? ''}",
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Table(
                                defaultColumnWidth:
                                    FixedColumnWidth(Get.width / 4),
                                border: TableBorder.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1),
                                children: [
                                  TableRow(
                                      children: heading
                                          .map((l) => Column(children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text('$l',
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                )
                                              ]))
                                          .toList()),
                                  ...e2.data
                                      .map((e3) => e3 == null
                                          ? TableRow()
                                          : TableRow(
                                              decoration: new BoxDecoration(
                                                color: e3.intOut == '0'
                                                    ? Colors.green.shade100
                                                    : Colors.red.shade100,
                                              ),
                                              children: [
                                                  InkWell(
                                                    onTap: () {
                                                      // selectRow(e);
                                                    },
                                                    child: Column(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child:
                                                            Text(e3.item ?? ''),
                                                      )
                                                    ]),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      // selectRow(e);
                                                    },
                                                    child: Column(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child:
                                                            Text(e3.date ?? ""),
                                                      )
                                                    ]),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      // selectRow(e);
                                                    },
                                                    child: Column(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child:
                                                            Text(e3.time ?? ''),
                                                      )
                                                    ]),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      // selectRow(e);
                                                    },
                                                    child: Column(children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child:
                                                            Text(e3.ml ?? ''),
                                                      )
                                                    ]),
                                                  ),
                                                ]))
                                      .toList()
                                ],
                              ),
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
