import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/vigilance/other_clinical_data.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';

class OtherCinicalData extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  OtherCinicalData({this.patientDetailsData, this.access});

  @override
  State<OtherCinicalData> createState() => _OtherCinicalDataState();
}

DateFormat dateFormat = DateFormat("yyyy-MM-dd");
var otherText = TextEditingController();
final OtherClinicalDataController controller = OtherClinicalDataController();

class _OtherCinicalDataState extends State<OtherCinicalData> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 200,
        width: Get.width,
        child: InkWell(
          onTap: () async {
            if (widget.access) {
              Vigilance data =
              await controller.getClinicalData(widget.patientDetailsData);

              Get.to(FreeTextScreen(
                text: "other_clinical_data".tr,
                fillValue: data?.result?.first?.output ?? '',
                function: () {
                  controller.onSaved(
                      widget.patientDetailsData, otherText.text.toString());
                },
                controller: otherText,
              ));
            }
          },
          child: Card(
            color: widget.access ? card_color : disable_color,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                side: BorderSide(width: 1, color: primary_color)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: primary_color,
                      // border: Border.all(
                      //   color: Colors.red[340],
                      // ),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8.0, left: 16.0),
                        child: Text(
                          'other_clinical_data'.tr,
                          style: TextStyle(
                            color: card_color,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.to(DiagnosisHistory(
                            patientDetailsData: widget.patientDetailsData,
                            HistorName: "${'history'.tr} - ${'other_clinical_data'.tr}",
                            type: ConstConfig.other_clinical_data,
                          ));
                        },
                        child: Container(
                          //margin: EdgeInsets.only(right: 8.0,),
                          //color: Colors.red,
                          width: 70,
                          height: 30.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SvgPicture.asset(
                                AppImages.historyClockIcon,
                                color: card_color,
                                height: 20,
                              ),
                              SizedBox(
                                width: 16.0,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                          child: Column(
                            children: [
                              FutureBuilder(
                                future: controller.getClinicalData(
                                    widget.patientDetailsData), // async work
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  Vigilance data = snapshot.data;
                                  return Text(
                                    "${data?.result?.first?.output ?? ''}",
                                    style: TextStyle(),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                      style: TextStyle(fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: FutureBuilder(
                        future: controller.getClinicalData(
                            widget.patientDetailsData), // async work
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          Vigilance data = snapshot.data;
                          return data == null
                              ? SizedBox()
                              : Text(
                            // "${data?.result?.first?.output ?? ''}",
                            "${'last_update'.tr} - ${dateFormat.format(DateTime.parse(data?.result?.first?.lastUpdate ?? '${DateTime.now()}'))}",
                            style: TextStyle(
                                color: primary_color, fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      )
    ],);
  }
}
