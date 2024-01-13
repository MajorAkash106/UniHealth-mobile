import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import '../oral_food_Acptnc.dart';

class Oral_Dt_Acptnc_screen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  Oral_Dt_Acptnc_screen({this.patientDetailsData});

  @override
  _Oral_Dt_Acptnc_screenState createState() => _Oral_Dt_Acptnc_screenState();
}

class _Oral_Dt_Acptnc_screenState extends State<Oral_Dt_Acptnc_screen> {


  bool showYesterday = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if(DateTime.parse(widget.patientDetailsData.admissionDate).isBefore(DateTime.now()))
    getData();
  }

  getData()async{
    // print('date admission : ${DateTime.parse(widget.patientDetailsData.admissionDate).isBefore(DateTime.now())}');

    String getDate = await getDateFormatFromString(DateTime.now().toString());
    // print('date admission : ${DateTime.parse(widget.patientDetailsData.admissionDate).isBefore(DateTime.parse(getDate))}');
    // print('getDate : ${getDate}');
    if(DateTime.parse(widget.patientDetailsData.admissionDate).isBefore(DateTime.parse(getDate))){
      showYesterday = true;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('oral_diet_acceptance'.tr, null),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10.0),
        child: Column(
          children: [
            // Center(
            //   child: Text(
            //     '(needs response)',
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            //   ),
            // ),
            SizedBox(
              height: 20.0,
            ),
            FutureBuilder(
                future: getORAL(widget.patientDetailsData),
                initialData: "Loading text..",
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Ntdata ntdata = snapshot?.data??null;
                  List<OralData>_oralData = ntdata?.result?.first?.oralData;
                  return ntdata==null || _oralData==null || _oralData.isEmpty?Expanded(
                    child: ListView(
                      children: [
                        carditemMiSS('1'),
                       !showYesterday? SizedBox(): carditemMiSS('-1'),
                      ],
                    ),
                  ) :Expanded(
                    child: _mainWidget(_oralData)
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _mainWidget(List<OralData>_list){
   var today =  _list.firstWhere((element) => calculateDifference(DateTime.parse(element.lastUpdate))==0 ,orElse: () => null);
   var yesterday =  _list.firstWhere((element) => calculateDifference(DateTime.parse(element.lastUpdate))== -1 ,orElse: () => null);

   return ListView(
     children: [


       today==null?carditemMiSS('1'):  carditemToday(today,'1'),
       !showYesterday? SizedBox():   yesterday==null?carditemMiSS('-1'):   carditemToday(yesterday,'-1'),

     ],
   );

  }

  Widget carditemMiSS(String type) {
    return Container(
      //height: 200,
      width: Get.width,
      child: InkWell(
        onTap: (){
          Get.to(Oral_Food_Accptnc(
            patientDetailsData: widget.patientDetailsData,
            type: type,selectedItem: null,
          ));
        },
        child:  Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getDateFormatFromString(
                          '${type == '1' ? DateTime.now() : DateTime.now().subtract(Duration(days: 1))}'
                      ),
                      initialData: "Loading text..",
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Text(
                          '${snapshot.data ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        );
                      }),
                  Text(
                      '(${type=='1'?'today'.tr:'yesterday'.tr})',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0)),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'acceptance_avg'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'N/A',
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        '${'breakfast'.tr}: ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'morning_snack'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        '${'lunch'.tr} ',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'afternoon_snack'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'dinner'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'supper'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'missing_answer'.tr,
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              child: Center(
                child: Text(
                  'click_here_to_answer'.tr,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
              ),
              onTap: () {
                Get.to(Oral_Food_Accptnc(
                  patientDetailsData: widget.patientDetailsData,
                  type: type,selectedItem: null,
                ));
              },
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),)
    );
  }

  Widget carditemToday(OralData data,String type) {
    return data?.data == null
        ? carditemMiSS('1')
        :
    // calculateDifference(DateTime.parse(data?.lastUpdate))!=0?carditemMiSS('1'):
    Container(
            //height: 200,
            width: Get.width,
            child: InkWell(
              onTap: (){
                Get.to(Oral_Food_Accptnc(
                  patientDetailsData: widget.patientDetailsData,
                  type: type,selectedItem: data,
                ));
              },
              child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Column(
                      children: [
                        // Text('08/04/2021',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0) ,)

                        FutureBuilder(
                            future: getDateFormatFromString(
                              // '${DateTime.now()}'
                                '${type == '1' ? DateTime.now() : DateTime.now().subtract(Duration(days: 1))}'
                            ),
                            initialData: "Loading text..",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              return Text(
                                '${snapshot.data ?? ''}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.0),
                              );
                            }),

                        Text(
                            '(${type=='1'?'today':'yesterday'})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0)),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Acceptance (avg): ',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${data?.average ?? 'N/A'}${data.average==null?'': "%"}',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Breakfast: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isBreakFast
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.breakFast}; ${data.data.breakFastPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Morning Snack: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isMorningSnack
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.morningSnack}; ${data.data.morningSnackPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Lunch: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isLunch
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.lunch}; ${data.data.lunchPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Afternoon Snack: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isNoon
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.noon}; ${data.data.noonPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Dinner: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isDinner
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.dinner}; ${data.data.dinnerPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            Text(
                              'Supper: ',
                              style: TextStyle(fontSize: 15),
                            ),
                            !data.data.isSupper
                                ? Text(
                              'Missing Answer',
                              style: TextStyle(fontSize: 13),
                            )
                                : Text(
                              '${data.data.supper}; ${data.data.supperPer}%',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  InkWell(
                    child: Center(
                      child: Text(
                        'Click here to answer',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17.0),
                      ),
                    ),
                    onTap: () {
                      Get.to(Oral_Food_Accptnc(
                        patientDetailsData: widget.patientDetailsData,
                        type: type,selectedItem: data,
                      ));
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),)
          );
  }



  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

}
