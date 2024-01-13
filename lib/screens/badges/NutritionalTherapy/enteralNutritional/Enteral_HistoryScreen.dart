import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class Enteral_histoyScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  const Enteral_histoyScreen({Key key, this.patientDetailsData})
      : super(key: key);

  @override
  _Enteral_histoyScreenState createState() => _Enteral_histoyScreenState();
}

class _Enteral_histoyScreenState extends State<Enteral_histoyScreen> {
  EnteralNutritionalController _controller = EnteralNutritionalController();

  @override
  void initState() {
    // TODO: implement initState

    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller
            .getEnteral_HistoryData(
          widget.patientDetailsData.sId,
        )
            .then((value) {
          setState(() {});
        });

        print('internet avialable');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("${'history'.tr} - ${'enteral_nutrition'.tr}", null),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _controller.historyData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        children: [
                          Container(
                            //height: 100.0,
                            width: Get.width,
                            child: _controller
                                        .historyData[index]
                                        .multipalmessage[0]
                                        .enteralData
                                        .tabIndex ==
                                    0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_controller
                                          .historyData[index]
                                          .multipalmessage[0]
                                          .enteralData
                                          .industrializedData
                                          .title),
                                      Row(
                                        children: [
                                          Text("${'volume'.tr} : "),
                                          Text(_controller
                                                      .historyData[index]
                                                      .multipalmessage[0]
                                                      .enteralData
                                                      .industrializedData
                                                      .mlHr +
                                                  " mL/h, " ??
                                              ""),
                                        ],
                                      ),
                                      Text(_controller
                                                  .historyData[index]
                                                  .multipalmessage[0]
                                                  .enteralData
                                                  .industrializedData
                                                  .hrDay +
                                              " h, " ??
                                          ""),
                                      Row(
                                        children: [
                                          Text("${'expected_vol'.tr} : "),
                                          Text(_controller
                                                      .historyData[index]
                                                      .multipalmessage[0]
                                                      .enteralData
                                                      .industrializedData
                                                      .currentWork +
                                                  " mL" ??
                                              "")
                                        ],
                                      )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(_controller
                                          .historyData[index]
                                          .multipalmessage[0]
                                          .enteralData
                                          .manipulatedData
                                          .title),
                                      Row(
                                        children: [
                                          Text("${'volume'.tr} : "),
                                          Text(_controller
                                                      .historyData[index]
                                                      .multipalmessage[0]
                                                      .enteralData
                                                      .manipulatedData
                                                      .mlDose +
                                                  " mL/h, " ??
                                              "")
                                        ],
                                      ),
                                      Text(_controller
                                                  .historyData[index]
                                                  .multipalmessage[0]
                                                  .enteralData
                                                  .manipulatedData
                                                  .dosesData
                                                  .length
                                                  .toString() +
                                              " x, " ??
                                          ""),
                                      Row(
                                        children: [
                                          Text("${'expected_vol'.tr} : "),
                                          Text(_controller
                                                      .historyData[index]
                                                      .multipalmessage[0]
                                                      .enteralData
                                                      .manipulatedData
                                                      .currentWork +
                                                  " mL" ??
                                              "")
                                        ],
                                      )
                                    ],
                                  ),
                          ),
                          Row(
                            children: [
                              Text("${'modules'.tr} : "),
                              _controller.historyData[index].multipalmessage[0]
                                      .enteralData.enData.fiberModule.isEmpty
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Text("${'fiber'.tr} : "),
                                        Text(_controller
                                                    .historyData[index]
                                                    .multipalmessage[0]
                                                    .enteralData
                                                    .enData
                                                    .fiberModule +
                                                "(g), " ??
                                            ""),
                                      ],
                                    ),
                              SizedBox(
                                width: 5,
                              ),
                              _controller.historyData[index].multipalmessage[0]
                                      .enteralData.enData.proteinModule.isEmpty
                                  ? SizedBox()
                                  : Row(
                                      children: [
                                        Text("${'protein'.tr} : "),
                                        Text(_controller
                                                    .historyData[index]
                                                    .multipalmessage[0]
                                                    .enteralData
                                                    .enData
                                                    .proteinModule +
                                                "(g), " ??
                                            "")
                                      ],
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(),
                              Text(
                                // '${timeago.format(DateTime.parse(_controller.historyData[index].updatedAt))}',
                                getTimeAgo(
                                    _controller.historyData[index].updatedAt),
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: black40_color),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.black12,
                            thickness: 2,
                          )
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
