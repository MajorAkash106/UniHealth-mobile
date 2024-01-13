import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/NRSHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_history.dart';
import 'package:timeago/timeago.dart' as timeago;

class AbdomenHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String HistorName;

  AbdomenHistoryScreen({this.patientDetailsData, this.HistorName});
  @override
  _AbdomenHistoryScreenState createState() => _AbdomenHistoryScreenState();
}

class _AbdomenHistoryScreenState extends State<AbdomenHistoryScreen> {
  final AbdomenController _controller = AbdomenController();

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

  Widget mainWidget(AbdomenHistoryData e) {
    return _MUSTWidget(e);
  }

  Widget _MUSTWidget(AbdomenHistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "bowel_mov_short".tr +' : ',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.bowelMovement} ",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "${'bowel_sound'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.bowelSound == 0 ? "absent".tr : "present".tr}",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "${'vomiting'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.vomit == 0 ? "absent".tr : "present".tr}",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "${'abd_dist'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.abdominalDist}",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "${'ng_tube'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.ngTube} mL",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "${'mean_iap'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    " ${e.multipalmessage.first.abdomenData.meanLap} mmHg",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  Text(
                    "${'justificative_for_adverse_events'.tr} :",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    "",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: e.multipalmessage.first.adverseEventData
                    .map((e3) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                           Padding(
                             padding: const EdgeInsets.only(left: 10.0,top: 5.0),
                             child:  Text(
                             "${e.multipalmessage.first.adverseEventData.indexOf(e3)+1}. ${e3.optionname}",
                             style: TextStyle(
                               fontSize: 12,
                               fontWeight: FontWeight.normal,
                             ),
                           ),)
                          ],
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 5,
              ),
              //           Column(
              //               mainAxisAlignment: MainAxisAlignment.start,
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: e.multipalmessage
              //                   .map((e2) => ExpansionTile(
              //                         title:
              //                         // Text(
              //                         //   "Justificative GI for Disfunction",
              //                         //   style: TextStyle(fontSize: 15),
              //                         // ),
              //                     Column(children: [
              //
              // ],),
              //
              //                         children: [
              //                           Column(
              //                             mainAxisAlignment: MainAxisAlignment.start,
              //                             crossAxisAlignment: CrossAxisAlignment.start,
              //                             children: e2.adverseEventData
              //                                 .map((e3) => Column(
              //                                       mainAxisAlignment:
              //                                           MainAxisAlignment.start,
              //                                       crossAxisAlignment:
              //                                           CrossAxisAlignment.start,
              //                                       children: [
              //                                         SizedBox(
              //                                           height: 8,
              //                                         ),
              //                                         // e3.selectedQ?   Text(
              //                                         //   "${e3.statusquestion}",
              //                                         //   style: TextStyle(
              //                                         //     fontSize: 16,
              //                                         //     fontWeight: FontWeight.normal,),
              //                                         // ):SizedBox(),
              //                                         //
              //
              //                                         Text(
              //                                           "${e3.optionname}",
              //                                           style: TextStyle(
              //                                             fontSize: 12,
              //                                             fontWeight: FontWeight.normal,
              //                                           ),
              //                                         ),
              //                                         SizedBox(
              //                                           height: 10,
              //                                         ),
              //                                       ],
              //                                     ))
              //                                 .toList(),
              //                           ),
              //                           SizedBox(
              //                             height: 20,
              //                           )
              //                         ],
              //                       ))
              //                   .toList()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    getTimeAgo(e.multipalmessage.first.lastUpdate),
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
