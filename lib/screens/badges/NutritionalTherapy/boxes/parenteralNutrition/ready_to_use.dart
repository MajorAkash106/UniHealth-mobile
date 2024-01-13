// import 'package:flutter/material.dart';
//
// class ReadyToUse extends StatefulWidget {
//   @override
//   _ReadyToUseState createState() => _ReadyToUseState();
// }
//
// class _ReadyToUseState extends State<ReadyToUse> {
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Column(
//       children: [
//         dropdown(listOptionDrpDwn_readyToUse, _value, (value) {
//           setState(() {
//             _value = value;
//             _parenteraldata = listOptionDrpDwn_readyToUse.firstWhere(
//                     (element) => element.sId == value,
//                 orElse: () => null);
//             getTotalVol();
//           });
//         }, context),
//         SizedBox(
//           height: 15.0,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Number of bags per day",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Spacer(),
//               Container(
//                 width: 100.0,
//                 height: 40.0,
//                 child: texfld("bags per day", bagsPerDay, () {
//                   print(bagsPerDay);
//                   getTotalVol();
//                 }),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 15.0,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Start Time", style: TextStyle(fontWeight: FontWeight.bold)),
//               Spacer(),
//               InkWell(
//                 onTap: () {
//                   print('hour: ${result?.hour}');
//                   print('min: ${result?.minute}');
//                   timePicker(context, result?.hour, result?.minute)
//                       .then((time) {
//                     print('return time : $time');
//                     result = time;
//                     startTime.text =
//                     "${result.hour < 10 ? '0${result.hour}' : result.hour}:${result.minute < 10 ? '0${result.minute}' : result.minute}";
//
//                     print(result.minute);
//                     getTotalVol();
//                     setState(() {});
//                   });
//                 },
//                 child: Container(
//                     width: 100.0,
//                     height: 40.0,
//                     child:
//                     //     texfld("12:00", startTime, () {
//                     //       _controller.getCurrentWorkday(mlPerHour, hourPerDay, startTime, workday);
//                     // }),
//                     TextField(
//                       controller: startTime,
//                       enabled: false,
//                       //focusNode: focus,
//                       keyboardType: TextInputType.name,
//                       onChanged: (_value) {},
//                       style: TextStyle(fontSize: 12),
//                       decoration: InputDecoration(
//                         hintText: "12:00",
//                         border: new OutlineInputBorder(
//                           //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
//                             borderSide: BorderSide(
//                                 color: Colors.white,
//                                 width: 0.0) //This is Ignored,
//                         ),
//                         hintStyle: TextStyle(
//                             color: black40_color,
//                             fontSize: 9.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     )),
//               )
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 15.0,
//         ),
//         Padding(
//           padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text("Hours of Infusion",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//               Spacer(),
//               Container(
//                 width: 100.0,
//                 height: 40.0,
//                 child: texfld("h/day", hoursInfusion, () {
//                   print(hoursInfusion);
//                   getTotalVol();
//                 }),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 20.0,
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   "Total Volume",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Container(
//                   width: 100.0,
//                   height: 40.0,
//                   child: texfld("ml", totalVolumeMl, () {
//                     print(totalVolumeMl);
//                   }),
//                 ),
//               ],
//             ),
//             SizedBox(
//               width: 20.0,
//             ),
//             Column(
//               children: [
//                 Text("Total Calories",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Container(
//                   width: 100.0,
//                   height: 40.0,
//                   child: texfld("kcal", totalKcal, () {
//                     print(totalKcal);
//                   }),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         SizedBox(
//           height: 10.0,
//         ),
//       ],
//     );
//   }
//
//   getTotalVol() async {
//     totalVolumeMl.text = await parenteralNutrional_Controller.computeVolume(
//         _parenteraldata,
//         bagsPerDay.text,
//         startTime.text,
//         hoursInfusion.text) ??
//         '';
//     getTotalCal();
//   }
//
//   getTotalCal() async {
//     totalKcal.text = await parenteralNutrional_Controller.computeCalories(
//         _parenteraldata,
//         bagsPerDay.text,
//         startTime.text,
//         hoursInfusion.text) ??
//         '';
//   }
//
// }
