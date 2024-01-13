// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:medical_app/config/colors.dart';
// import 'package:medical_app/config/images.dart';
// import 'package:medical_app/config/widgets/buttons.dart';
// import 'package:medical_app/config/widgets/common_appbar.dart';
// import 'package:medical_app/screens/home/patients&hospitals/patients/follow_up/wards.dart';
// import 'package:medical_app/screens/home/patients&hospitals/patients/patients_list/patients_list.dart';
//
// import 'new_hospitalization/new_hospitalization.dart';
// class PatientScreen extends StatefulWidget {
//   @override
//   _PatientScreenState createState() => _PatientScreenState();
// }
//
// class _PatientScreenState extends State<PatientScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BaseAppbar('Patients', null),
//       bottomNavigationBar: CommonHomeButton(),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           child: ListView(children: [
//             SizedBox(height: 20,),
//             _cardwidget("Add new patients", AppImages.addPatient,  (){
//               Get.to(NewHospitalizationScreen(title: "Add new patients",));
//             },),
//             SizedBox(height: 20,),
//            _cardwidget("Patient's List", AppImages.listIcon,  (){
//              Get.to(PatientListScreen());
//            },),
//             SizedBox(height: 20,),
//             _cardwidget("Follow - Up", AppImages.followUpIcon,  (){
//               Get.to(WardScreen());
//             },),
//
//           ],),
//         ),
//       ),
//     );
//   }
//
//   Widget _cardwidget(String text,String path,Function _function){
//     return  InkWell(
//       onTap:_function,
//       child: Card(
//           color: primary_color,
//           shape: RoundedRectangleBorder(
//             borderRadius:BorderRadius.all(Radius.circular(15)),
//             // side: BorderSide(width: 5, color: Colors.green)
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(30.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text("$text",style: TextStyle(color: card_color,fontSize: 20,fontWeight: FontWeight.bold),),
//                 SvgPicture.asset(path,color: card_color,height: 40,),
//               ],),
//           )
//       ),
//     );
//   }
// }
