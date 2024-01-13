// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:medical_app/config/Snackbars.dart';
// import 'package:medical_app/config/cons/colors.dart';
// import 'package:medical_app/config/cons/images.dart';
// import 'package:medical_app/config/widgets/buttons.dart';
// import 'package:medical_app/contollers/register_controller/allHospitals_Model.dart';
// import 'package:medical_app/contollers/register_controller/state_cityController.dart';
// import 'package:medical_app/screens/login&Sigup/registeration/activate_subscription.dart';
//
// class EnterHospital extends StatefulWidget {
//   final String userId;
//   final String hospId;
//   final bool isFromLogin;
//   EnterHospital({this.userId, this.isFromLogin, this.hospId});
//   @override
//   _EnterHospitalState createState() => _EnterHospitalState();
// }
//
// class _EnterHospitalState extends State<EnterHospital> {
//   State_cityController state_cityController = State_cityController();
//   // final PurchaseServices _purchaseServices = PurchaseServices();
//   @override
//   void initState() {
//     // _purchaseServices.init(
//     //   onErrorFun: (String err) {
//     //     print("error init $err");
//     //   },
//     // );
//     // getProduct();
//     getHospital();
//   }
//
//   getProduct() async {
//     // await Future.delayed(const Duration(milliseconds: 100), () {
//     //   _purchaseServices.getAllProduct().then((value) {
//     //     for (var a in _purchaseServices.products) {
//     //       print('productId : ${a.id}');
//     //     }
//     //   });
//     // });
//   }
//
//   getHospital() {
//     Future.delayed(const Duration(milliseconds: 100), () {
//       state_cityController.getHospitalsData().then((value) {
//         setState(() {});
//
//         if (widget.hospId != null) {
//           selectedHosp = state_cityController.allHospitals.firstWhere(
//               (element) => element.sId == widget.hospId,
//               orElse: () => null);
//
//
//
//           selectedHosp.isSelected = true;
//
//           for (var a in state_cityController.allHospitals) {
//            if(a.sId == widget.hospId){
//              a.isSelected = true;
//              break;
//            }
//
//           }
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: BaseAppbar('Hospital', null),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SafeArea(
//             child: Container(
//                 height: 150,
//                 width: Get.width,
//                 color: primary_color,
//                 child: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(5.0),
//                     child: Image.asset(
//                       AppImages.SplashlogoUnihealth,
//                       height: 100,
//                     ),
//                   ),
//                 )),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 10, right: 10, top: 10),
//             child: Text(
//               "choose_a_hospital".tr,
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.normal,
//                   fontSize: 16),
//             ),
//           ),
//           Expanded(
//               child: Padding(
//                   padding: EdgeInsets.only(left: 10, right: 10),
//                   child: ListView(
//                     children: state_cityController.allHospitals
//                         .map((e) => cardWidget(e))
//                         .toList(),
//                   ))),
//           widget.hospId != null ? SizedBox() :Container(
//             width: Get.width,
//             margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
//             child: CustomButton(text: 'hospital_not_listed'.tr, myFunc: notListed),
//           ),
//           Container(
//             width: Get.width,
//             margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
//             child: CustomButton(text: 'next'.tr, myFunc: onNext),
//           )
//         ],
//       ),
//     );
//   }
//
//   AllHoispitals selectedHosp;
//   Widget cardWidget(AllHoispitals e) {
//     return ListTile(
//       trailing: IconButton(
//         onPressed: () {
//           print(jsonEncode(e));
//           print(e.sId);
//
//           if (selectedHosp != null) {
//             selectedHosp.isSelected = false;
//             selectedHosp = null;
//           }
//           // for (var a in state_cityController.allHospitals) {
//           //   a.isSelected = false;
//           // }
//           selectedHosp = e;
//           e.isSelected = true;
//           setState(() {});
//         },
//         icon: e.isSelected
//             ? Icon(
//                 Icons.radio_button_checked,
//                 color: primary_color,
//               )
//             : Icon(
//                 Icons.radio_button_off,
//                 color: Colors.black87,
//               ),
//       ),
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${e.name}',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           Text('${e.city},${e.state},${e.country}'),
//         ],
//       ),
//       onTap: () {
//         print(jsonEncode(e));
//         print(e.sId);
//
//         if (selectedHosp != null) {
//           selectedHosp.isSelected = false;
//           selectedHosp = null;
//         }
//         // for (var a in state_cityController.allHospitals) {
//         //   a.isSelected = false;
//         // }
//         selectedHosp = e;
//         e.isSelected = true;
//         setState(() {});
//       },
//     );
//   }
//
//   onNext() {
//     var data = state_cityController.allHospitals.firstWhere(
//         (element) => element.isSelected == true,
//         orElse: () => null);
//     if (data != null) {
//       Get.to(ActivateSubscription(
//         userId: widget.userId,
//         hospdata: data,
//         isFromLogin: widget.isFromLogin,
//       ));
//     } else {
//       ShowMsg('please_choose_a_hospital'.tr);
//     }
//   }
//
//   notListed() {
//     Get.to(ActivateSubscription(
//       userId: widget.userId,
//       hospdata: null,
//       isFromLogin: widget.isFromLogin,
//     ));
//   }
// }
