import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/offline_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/tempGlycemiaController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/Glycemia_sheet.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
// import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../../../config/cons/cons.dart';
import '../../../../../config/widgets/calender_widget.dart';
import '../../../../../contollers/time_picker/time_picker.dart';
import '../../../../../model/vigilance/glycamia_sheetModel.dart';
import '../../../../../model/vigilance/temp_sheetModel.dart';



class TempGlycemiaSheet extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  TempGlycemiaSheet({this.patientDetailsData});
  @override
  _TempGlycemiaSheetState createState() => _TempGlycemiaSheetState();
}

class _TempGlycemiaSheetState extends State<TempGlycemiaSheet> {
  // final TempGlycemiaController _controller = TempGlycemiaController();
  final Temp_GlycemiaController _temp_glycemiaController = Temp_GlycemiaController();
  final PatientSlipController patientSlipController = PatientSlipController();
  final String jsonSample =
      '[{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"}]';
  bool toggle = true;

  List<String> heading = ['date'.tr, 'time'.tr, '${'value'.tr}(°C/°F)'];
  List<String> heading_gly = ['date'.tr, 'time'.tr, '${'value'.tr}(mg/dL)'];
  NumberFormat formatter =   NumberFormat("#,##0.00", "en_US");



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getData();
  }


  getData() {
    Future.delayed(const Duration(milliseconds: 200), () async{
      bool mode = await patientSlipController.getRoute(widget.patientDetailsData.hospital.first.sId);
      if (mode != null && mode) {
        await patientSlipController.getDetails(widget.patientDetailsData.sId, 0);
        print('internet avialable');
      } else {
        await patientSlipController.getDetailsOffline(widget.patientDetailsData.sId, 0);
      }

    });
  }
  Future<bool> _willPopScope() {
    Get.to(Step1HospitalizationScreen(
      index: 3,
      patientUserId: patientSlipController.patientDetailsData[0].sId,
    ));
  }
  @override
  Widget build(BuildContext context) {
    List json = jsonDecode(jsonSample);
    return WillPopScope(
      onWillPop:_willPopScope ,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: BaseAppbar('temp_e_gly'.tr, null),
          body:

          Obx(()=>
            //child:
          patientSlipController.patientDetailsData.isNullOrBlank
              ? SizedBox():
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              SingleChildScrollView(child:  Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 8,right: 8,top: 8),child:  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${'recent_events'.tr} : ${'temp_sheet'.tr}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                    ),),

                    SizedBox(
                      height: 10,
                    ),
                   Padding(padding: EdgeInsets.only(left: 8,right: 8),child:  Container(
                     height: Get.height/3.9,
                     //color: Colors.red,
                     child: ListView(
                       shrinkWrap: true,
                       children: [
                         Container(
                           child:
                           FutureBuilder(
                         future:getTempData(patientSlipController.patientDetailsData[0]) ,
                         initialData: null,
                         builder: (context, AsyncSnapshot snapshot){
                           Vigilance vigilanceData = snapshot.data;
                           List<TempratureData> tpData =[];
                           if (vigilanceData != null) {
                             tpData = vigilanceData.result.first.tempratureSheetData.tempratureData??[];
                             tpData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                           }

                           return vigilanceData == null?
                           Table(
                             defaultColumnWidth:
                             FixedColumnWidth(
                                 Get.width / 6.1),
                             border: TableBorder.all(
                                 color: Colors.black,
                                 style:
                                 BorderStyle.solid,
                                 width: 1),
                             children: [
                               TableRow(
                                   children: heading
                                       .map((e) =>
                                       Column(
                                           children: [
                                             Padding(
                                               padding:
                                               EdgeInsets.all(8),
                                               child: Text(
                                                   '$e',
                                                   style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                                             )
                                           ]))
                                       .toList()),

                               // TableRow()
                             ],
                           ): Table(
                             defaultColumnWidth: FixedColumnWidth(Get.width / 3),
                             border: TableBorder.all(
                                 color: Colors.black,
                                 style: BorderStyle.solid,
                                 width: 1),
                             children: [
                               TableRow(
                                   children: heading
                                       .map((e) => Column(children: [
                                     Padding(
                                       padding: EdgeInsets.all(8),
                                       child: Text('$e',
                                           style: TextStyle(
                                               fontSize: 15.0,
                                               fontWeight:
                                               FontWeight.bold)),
                                     )
                                   ]))
                                       .toList()),
                               ...tpData
                                   .map((e) => e == null
                                   ? TableRow(): TableRow(
                                   decoration: new BoxDecoration(
                                     color: Colors.orange.shade50,
                                   ),
                                   children: [
                                     InkWell(
                                       onTap: () {
                                         tempController.text = e.value;
                                         selectRow(e,0,tempController);
                                         // tempController= TextEditingController(text: e.value);
                                       },
                                       child: Column(children: [
                                         Padding(
                                           padding: EdgeInsets.all(8),
                                           child: Text(e.date??""),
                                         )
                                       ]),
                                     ),
                                     InkWell(
                                       onTap: () {
                                         tempController.text= e.value;
                                         selectRow(e,0,tempController);
                                         // tempController= TextEditingController(text: e.value);
                                       },
                                       child: Column(children: [
                                         Padding(
                                           padding: EdgeInsets.all(8),
                                           child: Text(e.time??""),
                                         )
                                       ]),
                                     ),
                                     InkWell(
                                       onTap: () {
                                         tempController.text= e.value;
                                         selectRow(e,0,tempController);
                                         print(tempController.text);

                                         // tempController= TextEditingController(text: e.value);
                                        // tempController= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',initialValue: double.parse(e.value));
                                         print(tempController.text);

                                       },
                                       child: Column(children: [
                                         Padding(
                                           padding: EdgeInsets.all(8),
                                           child:  Text( e.value.replaceAll('.', ',')??"")
                                           // Text( formatter.format( double.parse(e.value??"")))
                           // NumberFormat('#,##,000')

                                           //Text(double.parse(e.value??"").toString()??""),
                                         )
                                       ]),
                                     ),
                                   ]))
                                   .toList()
                             ],
                           );
                         }
                         )


                         ),
                       ],
                     ),
                   ),),
                    SizedBox(height: 10,),

                    Padding(padding: EdgeInsets.only(left: 15,right: 15,bottom: 5,top: 5.0),child:  Container(
                      // margin: ,
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            child: CustomButton(
                              text: "add_new".tr,
                              myFunc: () {
                                if(tempController!=null){
                                  tempController.clear();
                                }
                                else{}
                                bottomSheet('add_event'.tr,false,null,tempController);

                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Container(
                          //   width: Get.width,
                          //   child: CustomButton(
                          //     text: "Next",
                          //     myFunc: () {
                          //
                          //       Get.to(GlycemiaSheet(patientDetailsData: widget.patientDetailsData,));
                          //
                          //     },
                          //   ),
                          // )
                        ],
                      ),
                    ),),

                    SizedBox(
                      height: 3,
                    ),
                    Divider(height: 3.0,color: Colors.black12,thickness: 2,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(padding: EdgeInsets.only(left: 8,right: 8,top: 0),child:  Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${'recent_events'.tr} : ${'glycemia_sheet'.tr}',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                    ),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        height: Get.height/3.9,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                                child:
                                FutureBuilder(future: get_glycemiaData(patientSlipController.patientDetailsData[0]),
                                    initialData: null,

                                    builder: (context, AsyncSnapshot snapshot) {
                                      Vigilance vigilanceData = snapshot.data;

                                      List<GlycemiaData> glyData = [];
                                      if (vigilanceData != null) {
                                        glyData = vigilanceData.result.first.glycemiaSheetData.glycemiaData??[];
                                        glyData.sort((a, b) => b.dateTime.compareTo(a.dateTime));
                                      }

                                      return vigilanceData == null ?
                                      Table(
                                        defaultColumnWidth:
                                        FixedColumnWidth(
                                            Get.width /6.1),
                                        border: TableBorder.all(
                                            color: Colors.black,
                                            style:
                                            BorderStyle.solid,
                                            width: 1),
                                        children: [
                                          TableRow(
                                              children: heading_gly
                                                  .map((e) =>
                                                  Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          EdgeInsets.all(8),
                                                          child: Text(
                                                              '$e',
                                                              style: TextStyle(fontSize: 15.0,
                                                                  fontWeight: FontWeight
                                                                      .bold)),
                                                        )
                                                      ]))
                                                  .toList()),

                                          // TableRow()
                                        ],
                                      ) :

                                      Table(
                                        defaultColumnWidth: FixedColumnWidth(Get.width / 3),
                                        border: TableBorder.all(
                                            color: Colors.black,
                                            style: BorderStyle.solid,
                                            width: 1),
                                        children: [
                                          TableRow(
                                              children: heading_gly
                                                  .map((e) =>
                                                  Column(children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Text('$e',
                                                          style: TextStyle(
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                              FontWeight.bold)),
                                                    )
                                                  ]))
                                                  .toList()),
                                          ...glyData
                                              .map((e) =>
                                          e == null
                                              ? TableRow() : TableRow(
                                              decoration: new BoxDecoration(
                                                color: Colors.orange.shade50,
                                              ),
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    gly_valueController.text = e.value;
                                                    selectRow(e,1,

                                                        //gly_valueController = TextEditingController(text: e.value)
                                                      gly_valueController
                                                    );
                                                    // tempController= TextEditingController(text: e.value);
                                                  },
                                                  child: Column(children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Text(e.date ?? ""),
                                                    )
                                                  ]),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    gly_valueController.text = e.value;
                                                    selectRow(e,1,
                                                        // gly_valueController = TextEditingController(text: e.value)

                                                        gly_valueController
                                                    );
                                                    // tempController= TextEditingController(text: e.value);
                                                  },
                                                  child: Column(children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Text(e.time ?? ""),
                                                    )
                                                  ]),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    gly_valueController.text = e.value;
                                                    selectRow(e,1,//gly_valueController = TextEditingController(text: e.value)
                                                        gly_valueController
                                                    );
                                                    // tempController= TextEditingController(text: e.value);
                                                  },
                                                  child: Column(children: [
                                                    Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child:
                                                      //Text( e.value.replaceAll('.', ',')??"")
                                                      Text(e.value??"")
                                                      //Text(double.parse(e.value??"").toString()??""),
                                                    )
                                                  ]),
                                                ),
                                              ]))
                                              .toList()
                                        ],
                                      );
                                    }

                                )


                            ),
                          ],
                        ),
                      ),
                    ),


                  ]),),


                // SizedBox(height: 10,),
            ],),
          ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:   Padding(padding: EdgeInsets.all(8),child:  Container(
          // margin: ,
          child: Container(
            width: Get.width,
            child: CustomButton(
              text: 'add_new'.tr,
              myFunc: () {
                if(gly_valueController!=null){
                  gly_valueController.clear();
                }
                else{}
                bottomSheet_gly('add_event'.tr,false,null,
                    //gly_valueController
                    gly_valueController 
                );

              },
            ),
          ),
        ),),
      ),
    );
  }

  var tempController = TextEditingController();
  var gly_valueController = TextEditingController();

  var _dateController = TextEditingController();
  var _timeController = TextEditingController();
  TimeOfDay result;

  Widget _addWidget(String text,var tempController,TempratureData previousData,StateSetter setState) {
    if(_dateController.text.isEmpty && _timeController.text.isEmpty) {
      _dateController.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
      _timeController.text =
      "${TimeOfDay.now().hour < 10 ? '0${TimeOfDay.now().hour}' : TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? '0${TimeOfDay.now().minute}' : TimeOfDay.now().minute}";
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '$text',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('temp'.tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),
            Row(
              children: [
                Container(
                  width: Get.width / 3.2,
                  height: 45.0,
                  child:


                  texfld("",tempController//= MoneyMaskedTextController( decimalSeparator: ',',thousandSeparator: '',)

                      , () {
                    // var price = int.parse(tempController.text);
                    // var comma = NumberFormat('###,###,###,###');
                    // tempController.text = comma.format(price).replaceAll(' ', '');

                    print(tempController.text);
                  }),

                ),
                SizedBox(
                  width: 3.0,
                ),
                Text('°C/°F',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(
              children: [
                Text('Date  ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),
            Row(
              children: [
                Container(
                  width: Get.width / 3.2,
                  height: 45.0,
                  child:
                  InkWell(
                    onTap: () {
                      var getDate = TextEditingController();
                      // getDate.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
                      // print('previousData :: ${previousData.date}');

                      String initialDate = previousData?.date??'${DateFormat(commonDateFormat).format(DateTime.now())}';
                      print('return date: ${getDate.text}');
                      calenderWidget(
                        context,
                        getDate,
                            () async {
                          print('press');
                          print('selected date: ${getDate.text}');
                          _dateController.text = await getDate.text;

                        await  setState(() {});
                        },
                        'select_date_for_add_a_event'.tr,
                        initialDate,
                        disableFutureDate: true
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: black40_color,
                            width: 1,
                          )),
                      // height: 45.0,
                      // width: Get.width / 2,
                      child: Center(
                        child: Text('${_dateController.text}'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text('    ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Time ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),

            Container(
              width: Get.width / 3.2,
              height: 45.0,
              child:
              InkWell(
                onTap: () {

                  if(previousData!=null){
                    debugPrint('previousData.time :: ${previousData.time}');
                    var output = previousData.time.split(':');
                    print(output);
                    result = TimeOfDay(hour: int.parse(output.first),
                        minute: int.parse(output.last));
                  }


                  print('hour: ${result?.hour}');
                  print('min: ${result?.minute}');
                  timePicker(
                      context, result?.hour, result?.minute)
                      .then((time) {
                    print('return time : $time');
                    result = time;
                    _timeController.text =
                    "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                    print(result.minute);



                    setState(() {});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: black40_color,
                        width: 1,
                      )),
                  // height: 45.0,
                  // width: Get.width / 2,
                  child: Center(
                    child: Text('${_timeController.text}'),
                  ),
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }
  Widget _addWidget_gly(String text,var gly_valueController,var previousData,StateSetter setState) {
    if(_dateController.text.isEmpty && _timeController.text.isEmpty) {
      _dateController.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
      _timeController.text =
      "${TimeOfDay.now().hour < 10 ? '0${TimeOfDay.now().hour}' : TimeOfDay.now().hour}:${TimeOfDay.now().minute < 10 ? '0${TimeOfDay.now().minute}' : TimeOfDay.now().minute}";
    }
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            '$text',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17.0),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('value'.tr,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),
            Row(
              children: [
                Container(
                  width: Get.width / 3.2,
                  height: 45.0,
                  child: texfld("", gly_valueController,

                          () {
                    print(gly_valueController.text);
                  }),
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text('mg/dL',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            )
          ],
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Row(
              children: [
                Text('Date  ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),
            Row(
              children: [
                Container(
                  width: Get.width / 3.2,
                  height: 45.0,
                  child:
                  InkWell(
                    onTap: () {
                      var getDate = TextEditingController();
                      // getDate.text = '${DateFormat(commonDateFormat).format(DateTime.now())}';
                      // print('previousData :: ${previousData.date}');

                      String initialDate = previousData?.date??'${DateFormat(commonDateFormat).format(DateTime.now())}';
                      print('return date: ${getDate.text}');
                      calenderWidget(
                        context,
                        getDate,
                            () async {
                          print('press');
                          print('selected date: ${getDate.text}');
                          _dateController.text = await getDate.text;

                          await  setState(() {});
                        },
                        'select_date_for_add_a_event'.tr,
                        initialDate,
                        disableFutureDate: true
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                            color: black40_color,
                            width: 1,
                          )),
                      // height: 45.0,
                      // width: Get.width / 2,
                      child: Center(
                        child: Text('${_dateController.text}'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 3.0,
                ),
                Text('    ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Time ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0)),
              ],
            ),
            SizedBox(
              width: 110,
            ),

            Container(
              width: Get.width / 3.2,
              height: 45.0,
              child:
              InkWell(
                onTap: () {

                  if(previousData!=null){
                    debugPrint('previousData.time :: ${previousData.time}');
                    var output = previousData.time.split(':');
                    print(output);
                    result = TimeOfDay(hour: int.parse(output.first),
                        minute: int.parse(output.last));
                  }


                  print('hour: ${result?.hour}');
                  print('min: ${result?.minute}');
                  timePicker(
                      context, result?.hour, result?.minute)
                      .then((time) {
                    print('return time : $time');
                    result = time;
                    _timeController.text =
                    "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";

                    print(result.minute);


                    setState(() {});
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: black40_color,
                        width: 1,
                      )),
                  // height: 45.0,
                  // width: Get.width / 2,
                  child: Center(
                    child: Text('${_timeController.text}'),
                  ),
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }

  selectRow(var data,int num,var tc) {
    print('tapped data : ${jsonEncode(data)}');
    if(num==0){
      bottomSheet('edit_event'.tr,true,data,tc);
    }
    else{
      bottomSheet_gly('edit_event'.tr,true,data,tc);
    }

  }

  bottomSheet(String text,bool isEdit,TempratureData previousData,var tc) {

    _dateController.text = previousData?.date??'';
    _timeController.text = previousData?.time??'';

    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:_addWidget(text,tc,previousData,setState)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: Column(
                        children: [
                          !isEdit? SizedBox() : Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {
                                  Get.back();
                                  _temp_glycemiaController.onEditTemp(data: patientSlipController.patientDetailsData[0],
                                      previousData: previousData,
                                      tempVaue: tempController.text,delete: true,
                                  date: _dateController.text,time: _timeController.text
                                  ).then((value) {
                                    getData();
                                    tempController.clear();
                                  });

                                  // if (!_value2.isNullOrBlank &&
                                  //     !edited_ml.text.isNullOrBlank) {
                                  //   Get.back();
                                  //   balanceSheetController
                                  //       .onEdit(
                                  //       patientSlipController
                                  //           .patientDetailsData[0],
                                  //       _value2,
                                  //       _date,
                                  //       selectedIndex2,
                                  //       edited_ml,
                                  //       data,
                                  //       true)
                                  //       .then((value) {
                                  //     refresh();
                                  //   });
                                  // } else {
                                  //   ShowMsg('All fields are manedatory.');
                                  // }
                                },
                                color: Colors.red.shade400,
                                textColor: Colors.white,
                                child: Text("delete".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {
                                  // if (!_value2.isNullOrBlank &&
                                  //     !edited_ml.text.isNullOrBlank) {
                                  //   Get.back();
                                  //   balanceSheetController
                                  //       .onEdit(
                                  //       patientSlipController
                                  //           .patientDetailsData[0],
                                  //       _value2,
                                  //       _date,
                                  //       selectedIndex2,
                                  //       edited_ml,
                                  //       data,
                                  //       false)
                                  //       .then((value) {
                                  //     refresh();
                                  //   });
                                  // } else {
                                  //   ShowMsg('All fields are manedatory.');
                                  // }

                                  if(tempController.text.isNotEmpty &&
                                      _dateController.text.isNotEmpty &&
                                      _timeController.text.isNotEmpty){
                                    Get.back();
                                    isEdit==false?
                                    _temp_glycemiaController.onsaveTemp(data:  patientSlipController.patientDetailsData[0],
                                        tempValue: tempController.text,date: _dateController.text,time: _timeController.text).then((value) {
                                      getData();
                                      tempController.clear();
                                    }):
                                    _temp_glycemiaController.onEditTemp(data: patientSlipController.patientDetailsData[0],
                                        previousData: previousData,tempVaue: tempController.text,delete: false,date: _dateController.text,
                                    time: _timeController.text
                                    ).then((value) {
                                      getData();
                                    });
                                  }else{
                                    ShowMsg('all_mandatory'.tr);
                                  }

                                 // _controller.onSaved(patientSlipController.patientDetailsData[0], tempController.text, _dateController.text, _timeController.text);

                                },
                                color: primary_color,
                                textColor: Colors.white,
                                child: Text("save".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }


  bottomSheet_gly(String text,bool isEdit, var previousData,var tc) {
    _dateController.text = previousData?.date??'';
    _timeController.text = previousData?.time??'';
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            // You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child:_addWidget_gly(text,tc,previousData,setState)
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      child: Column(
                        children: [
                          !isEdit? SizedBox() : Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {
                                  Get.back();
                                  _temp_glycemiaController.onEdit_glycemia(data: patientSlipController.patientDetailsData[0],previousData: previousData,tempVaue: gly_valueController.text,delete: true,
                                  date: _dateController.text,time: _timeController.text
                                  ).then((value) {
                                    getData();
                                    // tempController.clear();
                                    gly_valueController.clear();
                                  });

                                },
                                color: Colors.red.shade400,
                                textColor: Colors.white,
                                child: Text("delete".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              width: Get.width,
                              child: RaisedButton(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10.0),
                                // ),
                                padding: EdgeInsets.all(15.0),
                                elevation: 0,
                                onPressed: () {

                                  if(gly_valueController.text.isNotEmpty &&  _dateController.text.isNotEmpty &&
                                      _timeController.text.isNotEmpty){
                                    Get.back();
                                    isEdit==false?
                                    _temp_glycemiaController.onsaveGlycemia(data:  patientSlipController.patientDetailsData[0],
                                        tempValue: gly_valueController.text,date: _dateController.text,time: _timeController.text).then((value) {
                                      getData();
                                      // tempController.clear();
                                      gly_valueController.clear();
                                    }):
                                    _temp_glycemiaController.onEdit_glycemia(data: patientSlipController.patientDetailsData[0],
                                        previousData: previousData,tempVaue: gly_valueController.text,delete: false,
                                        date: _dateController.text,time: _timeController.text
                                    ).then((value) {
                                      getData();
                                    });
                                  }else{
                                    ShowMsg('all_mandatory'.tr);
                                  }

                                },
                                color: primary_color,
                                textColor: Colors.white,
                                child: Text("save".tr,
                                    style: TextStyle(fontSize: 14)),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        });
  }
}


