import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/oral_aaceptance_box/diet_report_screen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/fastingBox/history/condition_history.dart';


class OralAcceptanceBox extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  OralAcceptanceBox({this.patientDetailsData,this.access});
  @override
  _OralAcceptanceBoxState createState() => _OralAcceptanceBoxState();
}

class _OralAcceptanceBoxState extends State<OralAcceptanceBox> {
  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }


  @override
  Widget build(BuildContext context) {
    return
      Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: InkWell(
            onTap: () {
              if(widget.access) {
                Get.to(DietReport_Screen(
                  patientDetailsData: widget.patientDetailsData,));
              }
            },
            child: Card(
                color:widget.access? card_color:disable_color,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    side: BorderSide(width: 1, color: primary_color)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: primary_color,
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
                                  'acceptance_infusion'.tr,
                                  style: TextStyle(
                                    color: card_color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Get.to(NutrintionalScreening());
                                  // print('type0 dates: ${type0}');

                                  // Get.to(NutrintionalScreeningHistory(
                                  //   patientDetailsData:
                                  //   widget.patientDetailsData[0],
                                  // ));
                                  Get.to(conditionHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr,type: ConstConfig.ORALAcceptanceHistory,));
                                },
                                child: Container(
                                  //margin: EdgeInsets.only(right: 8.0,),
                                  //color: Colors.red,
                                  width: 60,
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
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 0,bottom: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: getORALDetailsToday(widget.patientDetailsData),
                                        initialData:null,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          OralData oraldata = snapshot.data;
                                          return oraldata==null?
                                          // Text(
                                          //   'ORAL Diet (today): missing',
                                          //   style: TextStyle(
                                          //       color: Colors.black,fontWeight: FontWeight.normal,
                                          //       fontSize: 15.0),
                                          // )
                                          SizedBox()
                                              : Text(
                                            '${'oral_diet'.tr} (${'today'.tr}): ${oraldata.average??'${'missing'.tr} '}%',
                                            style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          );

                                        }),
                                    FutureBuilder(
                                        future:
                                        getORALDetailsYesterday(widget.patientDetailsData),
                                        initialData: null,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          OralData oraldata = snapshot.data;
                                          return oraldata==null?
                                          // Text(
                                          //   'ORAL Diet (yesterday): missing',
                                          //   style: TextStyle(
                                          //       color: Colors.black,fontWeight: FontWeight.normal,
                                          //       fontSize: 15.0),
                                          // )
                                          SizedBox()
                                              : Text(
                                            '${'oral_diet'.tr} (${'yesterday'.tr}): ${oraldata.average??'${'missing'.tr} '}%',
                                            style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          );

                                        }),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder(
                                        future: getONS(widget.patientDetailsData),
                                        initialData: null,
                                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                                          Ntdata data = snapshot.data;

                                          List<Ons> onslist = data?.result?.first?.onsData;
                                          return data==null?SizedBox():  Column(
                                            mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                          ...onslist.map((e) =>

                                              calculateDifference(DateTime.parse(e.lastUpdate))==0 || calculateDifference(DateTime.parse(e.lastUpdate))==-1?
                                              Text(
                                            '${'ons'.tr} (${calculateDifference(DateTime.parse(e.lastUpdate))==0?'today'.tr:'yesterday'.tr}): ${e.per.isNullOrBlank?'missing'.tr:e.per}',
                                            style: TextStyle(
                                                color: Colors.black,fontWeight: FontWeight.normal,
                                                fontSize: 15.0),
                                          )
                                                  :SizedBox()).toList()
                                          ],);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "",
                          style: TextStyle(fontSize: 15),
                        ),
                        FutureBuilder(
                            future: getUpdatedDateONS_ORAL(widget.patientDetailsData),
                            initialData: "Loading text..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshota) {
                              return snapshota.data.isNullOrBlank
                                  ? SizedBox()
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 8),
                                child: Text(
                                  "${'last_update'.tr} - "
                                      '${snapshota.data}',
                                  style: TextStyle(
                                      color: primary_color,
                                      fontSize: 10),
                                ),
                              );
                            })
                      ],
                    ),
                  ],
                )),
          ),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
