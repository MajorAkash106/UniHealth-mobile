import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/NutritionalTherapy/recommendation_controller/recomm_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';

class Recommendation extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  Recommendation({this.patientDetailsData, this.access});

  @override
  State<Recommendation> createState() => _RecommendationState();
}

DateFormat dateFormat = DateFormat("yyyy-MM-dd");
var otherText = TextEditingController();
final RecommendationController controller = RecommendationController();

class _RecommendationState extends State<Recommendation> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 200,
        width: Get.width,
        child: InkWell(
          onTap: () async {
            if (widget.access) {
              Ntdata data = await controller.getRecommData(widget.patientDetailsData);

              Get.to(FreeTextScreen(
                text: "Other recommendation data",
                fillValue:  data?.result?.first?.description ?? '',
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
                          'Other Recommendation',
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
                            HistorName: "Other recommendation history",
                            type: ConstConfig.other_recommendation_data,
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
                SizedBox(height: 10,),
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
                                future: controller.getRecommData(
                                    widget.patientDetailsData), // async work
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  Ntdata data = snapshot.data;
                                  return Text(
                                    "${data?.result?.first?.description ?? ''}",
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
                        future: controller.getRecommData(
                            widget.patientDetailsData), // async work
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          Ntdata data = snapshot.data;
                          return data == null
                              ? SizedBox()
                              : Text(
                            // "${data?.result?.first?.output ?? ''}",
                            "Last update - ${dateFormat.format(DateTime.parse(data?.result?.first?.lastUpdate ?? '${DateTime.now()}'))}",
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
