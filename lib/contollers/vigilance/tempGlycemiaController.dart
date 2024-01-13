// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:medical_app/config/cons.dart';
// import 'package:medical_app/config/vigilanceFunc.dart';
// import 'package:medical_app/contollers/save_history_controller.dart';
// import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
// import 'package:medical_app/model/patientDetailsModel.dart';
// import 'package:medical_app/model/vigilance/vigilance_model.dart';
//
// class TempGlycemiaController extends GetxController{
//
//   final VigilanceController vigilanceController = VigilanceController();
//
//   final HistoryController _historyController = HistoryController();
//
//
//   Future<String> onSaved(PatientDetailsData data,String temp,String date,String time,) async {
//     print('temp : ${temp}');
//     print('date : ${date}');
//     print('time : ${time}');
//
//
//     // List<Data> _getfluid = [];
//     // String balanceSheet;
//     // await getFluidBalanace(data)
//     //     .then((val) {
//     //   if (val != null) {
//     //     _getfluid.addAll(val.result[0].data);
//     //     balanceSheet = val.result[0].balanceSince;
//     //   }
//     // });
//     //
//     // _getfluid.add(Data(
//     //     date: DateFormat(commonDateFormat).format(DateTime.now()),
//     //     // date: '2021-09-29',
//     //     intOut: selectedIndex.toString(),
//     //     item: _value,
//     //     ml: ml.text,
//     //     time: DateFormat('HH:mm').format(DateTime.now())
//     //   // time: '04:15'
//     // ));
//
//     // Map finalData = {"lastUpdate": '${DateTime.now()}',"balance_since": balanceSheet??'', "data": _getfluid};
//
//     // print('final Data: ${jsonEncode(finalData)}');
//
//     // await vigilanceController.saveData(data, finalData, VigiLanceBoxes.fluidBalance_status,VigiLanceBoxes.fluidBalance);
//
//
//     return 'success';
//   }
//
//
//   Future<String> onEdit(PatientDetailsData data,String _value,TextEditingController _date,int selectedIndex,TextEditingController ml, Data previousData, bool delete) async {
//     print('item : ${_value}');
//     print('date : ${_date.text}');
//     print('in & out : ${selectedIndex}');
//     print('ml : ${ml.text}');
//
//     List<Data> _getfluid = [];
//     int index = 0;
//     String balanceSheet;
//     await getFluidBalanace(data)
//         .then((val) {
//       if (val != null) {
//
//         index = val.result[0].data.indexOf(previousData);
//         val.result[0].data.remove(previousData);
//
//         _getfluid.addAll(val.result[0].data);
//         balanceSheet = val.result[0].balanceSince;
//       }
//     });
//
//     if(!delete){
//       await  _getfluid.insert(index,Data(
//           intOut: selectedIndex.toString(),
//           item: _value,
//           ml: ml.text,
//           date: previousData.date,
//           time: previousData.time));
//     }
//
//     Map finalData = {"lastUpdate": '${DateTime.now()}',"balance_since": balanceSheet??'', "data": _getfluid};
//
//     print('final Data: ${jsonEncode(finalData)}');
//
//     await vigilanceController.saveData(data, finalData, VigiLanceBoxes.fluidBalance_status,VigiLanceBoxes.fluidBalance);
//
//
//     return 'success';
//   }
//
//
//
//   Future<String> onSetting(PatientDetailsData data,String balanceSince) async {
//
//     List<Data> _getfluid = [];
//
//     await getFluidBalanace(data)
//         .then((val) {
//       if (val != null) {
//
//         _getfluid.addAll(val.result[0].data);
//       }
//     });
//
//
//
//     Map finalData = {"lastUpdate": '${DateTime.now()}',"balance_since": balanceSince, "data": _getfluid};
//
//     print('final Data: ${jsonEncode(finalData)}');
//
//     await vigilanceController.saveData(data, finalData, VigiLanceBoxes.fluidBalance_status,VigiLanceBoxes.fluidBalance);
//
//
//     return 'success';
//   }
//
//
// }