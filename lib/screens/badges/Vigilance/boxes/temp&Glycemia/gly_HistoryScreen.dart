
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/vigilance/circulation_sheet_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/bloodpressure_HistoryModel.dart';
import 'package:medical_app/model/vigilance/temp_glycemia_HistoryModel.dart';
import 'package:medical_app/model/vigilance/vaso_pressureHistory.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';
import 'package:timeago/timeago.dart' as timeago;
class Gly_HistoryScreen extends StatefulWidget {
  final String HistoryName;
  final PatientDetailsData patientDetailsData;
  const Gly_HistoryScreen({Key key, this.HistoryName, this.patientDetailsData}) : super(key: key);

  @override
  _BloodPressure_HistoryScreenState createState() => _BloodPressure_HistoryScreenState();
}

class _BloodPressure_HistoryScreenState extends State<Gly_HistoryScreen> {
  final Temp_GlycemiaController temp_glycemiaController = Temp_GlycemiaController();
  List<String> heading = ['date'.tr, 'time'.tr, 'value'.tr,];

  @override
  void initState() {
    // TODO: implement initState

    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        temp_glycemiaController.get_Gly_HistoryData(
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
        appBar: BaseAppbar('${widget.HistoryName}', null),
        body: Obx(
              () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: temp_glycemiaController.gly_historyData.map((element) {
                  return mainWidget(element);
                }).toList(),
              ),
            ),
          ),
        ));
  }






  Widget mainWidget(Temp_Gly_HistoryData e) {
    return _MUSTWidget(e);
  }

  Widget _MUSTWidget(Temp_Gly_HistoryData e) {
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
                              "${'event'.tr} : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${e2.data.map((e) => e.flag)}'.replaceAll("(", '').toString().replaceAll(')', '').removeAllWhitespace.toString().toLowerCase().tr,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                    children: [
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Balance Since :",
                      //       style: TextStyle(fontSize: 15),
                      //     ),
                      //     Text(
                      //       " ${e.multipalmessage.first?.balanceSince ?? ''}",
                      //       style: TextStyle(
                      //         fontSize: 13,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Table(
                        defaultColumnWidth:
                        FixedColumnWidth(Get.width/3),
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
                                color:  //Colors.orange.shade50,
                                e3.flag == "add"||e3.flag=="Added"?Colors.green.shade100:e3.flag=="Edited"?Colors.deepOrangeAccent.shade100:e3.flag=="Deleted"?Colors.red.shade300:Colors.orange.shade50
                                // e3.flag == 'add'
                                //     ? Colors.green.shade100
                                //     : Colors.red.shade100,
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
                                      Text(e3.date ?? ''),
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
                                      Text(e3.time ?? ""),
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
                                      child:Text(e3.value??"")
                                      // Text(double.parse(e3.value??"").toString()??""),
                                    )
                                  ]),
                                ),
                                // InkWell(
                                //   onTap: () {
                                //     // selectRow(e);
                                //   },
                                //   child: Column(children: [
                                //     Padding(
                                //       padding:
                                //       EdgeInsets.all(8),
                                //       child:
                                //       Text(e3.drugAmount ?? ''),
                                //     )
                                //   ]),
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     // selectRow(e);
                                //   },
                                //   child: Column(children: [
                                //     Padding(
                                //       padding:
                                //       EdgeInsets.all(8),
                                //       child:
                                //       Text(e3.concentration ?? ''),
                                //     )
                                //   ]),
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     // selectRow(e);
                                //   },
                                //   child: Column(children: [
                                //     Padding(
                                //       padding:
                                //       EdgeInsets.all(8),
                                //       child:
                                //       Text(e3.dose ?? ''),
                                //     )
                                //   ]),
                                // ),
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