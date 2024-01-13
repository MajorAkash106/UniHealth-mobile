// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:medical_app/config/Snackbars.dart';
// import 'package:medical_app/config/cons/colors.dart';
// import 'package:medical_app/config/funcs/vigilanceFunc.dart';
// import 'package:medical_app/config/widgets/buttons.dart';
// import 'package:medical_app/config/widgets/common_appbar.dart';
// import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
// import 'package:medical_app/contollers/vigilance/tempGlycemiaController.dart';
// import 'package:medical_app/model/patientDetailsModel.dart';
// import 'package:medical_app/model/vigilance/vigilance_model.dart';
// import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
// import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/temp_GlycemiaController.dart';
// import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
//
//
// class GlycemiaSheet extends StatefulWidget {
//   final PatientDetailsData patientDetailsData;
//   GlycemiaSheet({this.patientDetailsData});
//   @override
//   _GlycemiaSheetState createState() => _GlycemiaSheetState();
// }
//
// class _GlycemiaSheetState extends State<GlycemiaSheet> {
//   // final TempGlycemiaController _controller = TempGlycemiaController();
//   final Temp_GlycemiaController _temp_glycemiaController = Temp_GlycemiaController();
//   final PatientSlipController patientSlipController = PatientSlipController();
//   final String jsonSample =
//       '[{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"},{"Date": "10-8-1997","Time": "8:00","Value": "370"}]';
//   bool toggle = true;
//
//   List<String> heading_gly = ['Date', 'Time', 'Value(mg/dl)'];
//   // List<String> eventItem = ['NG Tube', 'IV Fluids', 'Urine', 'ENTERAL N'];
//
//   List<INOUT> inout = <INOUT>[
//     INOUT('In', false),
//     INOUT('Out', false),
//   ];
//   int selectedIndex = 0;
//
//   String _value;
//   var _date = TextEditingController();
//   Future<bool> _tapConfirm() {
//     Get.to(Step1HospitalizationScreen(
//       index: 3,
//       patientUserId: patientSlipController.patientDetailsData[0].sId,
//     ));
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//      getData();
//   }
//
//
//   getData() {
//     Future.delayed(const Duration(milliseconds: 0), () {
//       patientSlipController
//           .getDetails(widget.patientDetailsData.sId, 0)
//           .then((val) {
//             print('ddfad');
//             print(patientSlipController.patientDetailsData[0].name);
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List json = jsonDecode(jsonSample);
//     return Scaffold(
//         resizeToAvoidBottomPadding: false,
//         appBar: BaseAppbar('Glycemia Sheet', null),
//         body: Obx(()=>
//           //child:
//             patientSlipController.patientDetailsData.isNullOrBlank
//             ? SizedBox():
//           Column(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Align(
//                       alignment: Alignment.topLeft,
//                       child: Text(
//                         'Recent events',
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 17.0),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Container(
//
//                         height: Get.height/1.8,
//                         child: ListView(
//                           shrinkWrap: true,
//                           children: [
//                             Container(
//                               child:
//                               FutureBuilder(future: get_glycemiaData(patientSlipController.patientDetailsData[0]),
//                           initialData: null,
//
//                           builder: (context, AsyncSnapshot snapshot) {
//                             Vigilance vigilanceData =
//                                 snapshot.data;
//                             return vigilanceData == null ?
//                             Table(
//                               defaultColumnWidth:
//                               FixedColumnWidth(
//                                   Get.width /6.1),
//                               border: TableBorder.all(
//                                   color: Colors.black,
//                                   style:
//                                   BorderStyle.solid,
//                                   width: 1),
//                               children: [
//                                 TableRow(
//                                     children: heading_gly
//                                         .map((e) =>
//                                         Column(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                 EdgeInsets.all(8),
//                                                 child: Text(
//                                                     '$e',
//                                                     style: TextStyle(fontSize: 15.0,
//                                                         fontWeight: FontWeight
//                                                             .bold)),
//                                               )
//                                             ]))
//                                         .toList()),
//
//                                 // TableRow()
//                               ],
//                             ) :
//
//                             Table(
//                               defaultColumnWidth: FixedColumnWidth(Get.width / 3),
//                               border: TableBorder.all(
//                                   color: Colors.black,
//                                   style: BorderStyle.solid,
//                                   width: 1),
//                               children: [
//                                 TableRow(
//                                     children: heading_gly
//                                         .map((e) =>
//                                         Column(children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(8),
//                                             child: Text('$e',
//                                                 style: TextStyle(
//                                                     fontSize: 15.0,
//                                                     fontWeight:
//                                                     FontWeight.bold)),
//                                           )
//                                         ]))
//                                         .toList()),
//                                 ...vigilanceData
//                                     ?.result?.first?.glycemiaSheetData.glycemiaData
//                                     .map((e) =>
//                                 e == null
//                                     ? TableRow() : TableRow(
//                                     decoration: new BoxDecoration(
//                                       color: Colors.orange.shade50,
//                                     ),
//                                     children: [
//                                       InkWell(
//                                         onTap: () {
//                                           selectRow(e);
//                                           tempController= TextEditingController(text: e.value);
//                                         },
//                                         child: Column(children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(8),
//                                             child: Text(e.date ?? ""),
//                                           )
//                                         ]),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           selectRow(e);
//                                           tempController= TextEditingController(text: e.value);
//                                         },
//                                         child: Column(children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(8),
//                                             child: Text(e.time ?? ""),
//                                           )
//                                         ]),
//                                       ),
//                                       InkWell(
//                                         onTap: () {
//                                           selectRow(e);
//                                           tempController= TextEditingController(text: e.value);
//                                         },
//                                         child: Column(children: [
//                                           Padding(
//                                             padding: EdgeInsets.all(8),
//                                             child: Text(e.value ?? ""),
//                                           )
//                                         ]),
//                                       ),
//                                     ]))
//                                     .toList()
//                               ],
//                             );
//                           }
//
//                               )
//
//
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10,),
//
//
//                   ]),
//               Padding(padding: EdgeInsets.only(left: 15,right: 15,bottom: 10),child:  Container(
//                 // margin: ,
//                 child: Column(
//                   children: [
//                     Container(
//                       width: Get.width,
//                       child: CustomButton(
//                         text: "Add new",
//                         myFunc: () {
//                           if(tempController!=null){
//                             tempController.clear();
//                           }
//                           else{}
//                           bottomSheet_gly('Add events',false,null);
//                           // calenderWidget(context, _date, () {
//                           //   print('press');
//                           //   print('return date: ${_date.text}');
//                           // }, 'Cumulative fluid balance from');
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       width: Get.width,
//                       child: CustomButton(
//                         text: "Confirm",
//                         myFunc: () {
//                           _tapConfirm();
//                         },
//                       ),
//                     )
//                   ],
//                 ),
//               ),),
//
//               // SizedBox(height: 10,),
//             ],),
//         )
//     );
//   }
//
//   var tempController = TextEditingController();
//   var _dateController = TextEditingController();
//   var _timeController = TextEditingController();
//
//   Widget _addWidget_gly(String text) {
//     return Column(
//       children: [
//         Align(
//           alignment: Alignment.topLeft,
//           child: Text(
//             '$text',
//             style: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 17.0),
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text('Value',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17.0)),
//               ],
//             ),
//             SizedBox(
//               width: 110,
//             ),
//             Row(
//               children: [
//                 Container(
//                   width: Get.width / 3.2,
//                   height: 45.0,
//                   child: texfld("", tempController, () {
//                     print(tempController.text);
//                   }),
//                 ),
//                 SizedBox(
//                   width: 3.0,
//                 ),
//                 Text('mg/dl',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17.0)),
//               ],
//             )
//           ],
//         ),
//         // SizedBox(
//         //   height: 10,
//         // ),
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Row(
//         //       children: [
//         //         Text('Date  ',
//         //             style: TextStyle(
//         //                 color: Colors.black,
//         //                 fontWeight: FontWeight.bold,
//         //                 fontSize: 17.0)),
//         //       ],
//         //     ),
//         //     SizedBox(
//         //       width: 110,
//         //     ),
//         //     Row(
//         //       children: [
//         //         Container(
//         //           width: Get.width / 3.2,
//         //           height: 45.0,
//         //           child: texfld("", _dateController, () {
//         //             print(_dateController.text);
//         //           }),
//         //         ),
//         //         SizedBox(
//         //           width: 3.0,
//         //         ),
//         //         Text('    ',
//         //             style: TextStyle(
//         //                 color: Colors.black,
//         //                 fontWeight: FontWeight.bold,
//         //                 fontSize: 17.0)),
//         //       ],
//         //     )
//         //   ],
//         // ),
//         // SizedBox(
//         //   height: 10,
//         // ),
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.start,
//         //   children: [
//         //     Row(
//         //       children: [
//         //         Text('Time ',
//         //             style: TextStyle(
//         //                 color: Colors.black,
//         //                 fontWeight: FontWeight.bold,
//         //                 fontSize: 17.0)),
//         //       ],
//         //     ),
//         //     SizedBox(
//         //       width: 110,
//         //     ),
//         //     Row(
//         //       children: [
//         //         Container(
//         //           width: Get.width / 3.2,
//         //           height: 45.0,
//         //           child: texfld("", _timeController, () {
//         //             print(_timeController.text);
//         //           }),
//         //         ),
//         //         SizedBox(
//         //           width: 3.0,
//         //         ),
//         //         Text('   ',
//         //             style: TextStyle(
//         //                 color: Colors.black,
//         //                 fontWeight: FontWeight.bold,
//         //                 fontSize: 17.0)),
//         //       ],
//         //     )
//         //   ],
//         // ),
//       ],
//     );
//   }
//
//   selectRow(var data) {
//     print('tapped data : ${data}');
//     bottomSheet_gly('Edit events',true,data);
//   }
//
//   bottomSheet_gly(String text,bool isEdit, var previousData) {
//     return showModalBottomSheet(
//         isScrollControlled: true,
//         context: context,
//         builder: (BuildContext context) {
//           return StatefulBuilder(
//             // You need this, notice the parameters below:
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child:_addWidget_gly(text)
//                   ),
//                   SizedBox(
//                     height: 20,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom),
//                     child: Container(
//                       child: Column(
//                         children: [
//                           !isEdit? SizedBox() : Container(
//                               width: Get.width,
//                               child: RaisedButton(
//                                 // shape: RoundedRectangleBorder(
//                                 //   borderRadius: BorderRadius.circular(10.0),
//                                 // ),
//                                 padding: EdgeInsets.all(15.0),
//                                 elevation: 0,
//                                 onPressed: () {
//                                   Get.back();
//                                   _temp_glycemiaController.onEdit_glycemia(data: patientSlipController.patientDetailsData[0],previousData: previousData,tempVaue: tempController.text,delete: true).then((value) {
//                                     getData();
//                                     tempController.clear();
//                                   });
//
//                                 },
//                                 color: Colors.red.shade400,
//                                 textColor: Colors.white,
//                                 child: Text("Delete",
//                                     style: TextStyle(fontSize: 14)),
//                               )),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           Container(
//                               width: Get.width,
//                               child: RaisedButton(
//                                 // shape: RoundedRectangleBorder(
//                                 //   borderRadius: BorderRadius.circular(10.0),
//                                 // ),
//                                 padding: EdgeInsets.all(15.0),
//                                 elevation: 0,
//                                 onPressed: () {
//                                   Get.back();
//                                   if(tempController.text.isNotEmpty){
//                                     isEdit==false?
//                                     _temp_glycemiaController.onsaveGlycemia(data:  patientSlipController.patientDetailsData[0],tempValue: tempController.text).then((value) {
//                                       getData();
//                                       tempController.clear();
//                                     }):
//                                     _temp_glycemiaController.onEdit_glycemia(data: patientSlipController.patientDetailsData[0],previousData: previousData,tempVaue: tempController.text,delete: false).then((value) {
//                                       getData();
//                                     });
//                                   }else{
//                                     ShowMsg('Please enter temprature first');
//                                   }
//
//                                 },
//                                 color: primary_color,
//                                 textColor: Colors.white,
//                                 child: Text("Save",
//                                     style: TextStyle(fontSize: 14)),
//                               )),
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             },
//           );
//         });
//   }
// }
//
// class INOUT {
//   String text;
//   bool selected_prcnt;
//   INOUT(this.text, this.selected_prcnt);
// }
