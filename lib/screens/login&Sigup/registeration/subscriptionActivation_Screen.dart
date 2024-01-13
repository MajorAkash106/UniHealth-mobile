// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/route_manager.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:medical_app/config/cons/colors.dart';
// import 'package:medical_app/config/cons/images.dart';
// import 'package:medical_app/config/widgets/buttons.dart';
// import 'package:medical_app/config/widgets/initial_loader.dart';
// import 'package:medical_app/contollers/patient&hospital_controller/hospital_list_controller.dart';
// import 'package:medical_app/contollers/register_controller/allHospitals_Model.dart';
// import 'package:medical_app/contollers/register_controller/attribution_controller.dart';
// import 'package:medical_app/in_app_purchase/purchase_service.dart';
// import 'package:medical_app/in_app_purchase/purchase_service_2.dart';
// import 'package:medical_app/model/register_controller/attribution_model.dart';
//
// class SubscriptionActivation_Screen extends StatefulWidget {
//   final String userId;
//   final AllHoispitals hospdata;
//   final bool isFromLogin;
//   SubscriptionActivation_Screen({this.userId, this.hospdata, this.isFromLogin});
//
//   @override
//   _SubscriptionActivation_ScreenState createState() =>
//       _SubscriptionActivation_ScreenState();
// }
//
// class _SubscriptionActivation_ScreenState
//     extends State<SubscriptionActivation_Screen> {
//   final PurchaseServices2 _purchaseServices = PurchaseServices2();
//   AttributionController _attributionController = AttributionController();
//   HospitalController2 hospitalController2 = HospitalController2();
//
//   String selected_atribution;
//   @override
//   void initState() {
//     // TODO: implement initState
//     initFunc();
//     super.initState();
//   }
//
//   initFunc() {
//     _purchaseServices.init(
//       onErrorFun: (String err) {
//         print("error init $err");
//       },
//     );
//     getProduct();
//   }
//
//   List<AttributionData> _attributeData = [];
//   getData() async {
//     await Future.delayed(const Duration(milliseconds: 100), () {
//       _attributionController.getAttribution(widget.hospdata?.sId??null).then((val) {
//         _attributeData.clear();
//         _attributeData.addAll(_attributionController.attributionData);
//         for (var a in _attributionController.attributionData) {
//           String _string = a.attributionname.toLowerCase().replaceAll(" ", "_");
//           print('get attribution id : ${_string}');
//           print('product list : ${productIds}');
//           print(
//               'contains within product ids : ${productIds.contains(_string)}');
//           if (productIds.contains(_string) == false) {
//             //   print(_string);
//             _attributeData.remove(a);
//           }
//
//           setState(() {});
//         }
//       });
//     });
//   }
//
//   List<String> productIds = [];
//   getProduct() async {
//     await Future.delayed(const Duration(milliseconds: 100), () {
//       _purchaseServices.getAllProduct().then((value) {
//         productIds.clear();
//         for (var a in _purchaseServices.products) {
//           print('productId : ${a.id}');
//           productIds.add(a.id);
//         }
//         getData();
//         setState(() {});
//       });
//     });
//
//     // if (_purchaseServices.products.isEmpty) {
//     //   initFunc();
//     // }
//
//
//   }
//
//   ProductDetails productDetails;
//   AttributionData selectedAttribute;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _purchaseServices.products.isEmpty
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   children: [
//                     SafeArea(
//                       child: Container(
//                           height: 150,
//                           width: Get.width,
//                           color: primary_color,
//                           child: Center(
//                             child: Padding(
//                               padding: const EdgeInsets.all(5.0),
//                               child: Image.asset(
//                                 AppImages.SplashlogoUnihealth,
//                                 height: 100,
//                               ),
//                             ),
//                           )),
//                     ),
//                     Container(
//                       child: ListView(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         children: [
//                           Padding(
//                             padding:
//                                 const EdgeInsets.only(left: 8.0, right: 8.0),
//                             child: Column(
//                               children: [
//                                 // Text(
//                                 //   "product len : ${_purchaseServices.products.length}",
//                                 //   style: TextStyle(
//                                 //       fontWeight: FontWeight.bold,
//                                 //       fontSize: 15),
//                                 // ),
//                                 // Container(
//                                 //   height: 200,
//                                 //   child:ListView(children: _purchaseServices.productsPurchasedd.map((e) =>  Text(
//                                 //   "purchases len : ${e.productID}",
//                                 //   style: TextStyle(
//                                 //       fontWeight: FontWeight.bold,
//                                 //       fontSize: 15),
//                                 // ),).toList(),),),
//
//                                 Text(
//                                   "Work collaboratively with the entire team in your hospital (get faster access to information and optimize shift transfers) ",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 ),
//                                 SizedBox(
//                                   height: 10.0,
//                                 ),
//                                 Text(
//                                   "Save time collecting data and generating reports that will be inserted into android records",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 15),
//                                 ),
//                                 SizedBox(
//                                   height: 10.0,
//                                 ),
//                                 Text(
//                                     "Get access to multiple tools to monitor the evolution of your patients",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15)),
//                                 SizedBox(
//                                   height: 10.0,
//                                 ),
//                                 Text(
//                                     "Calculation and Scores performed in a simple and autoated way",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 15)),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Container(
//                       width: Get.width,
//                       margin: const EdgeInsets.only(left: 10.0, right: 10),
//                       padding: const EdgeInsets.only(left: 10.0, right: 10),
//                       decoration: BoxDecoration(
//                           color: Colors.black12,
//                           borderRadius: BorderRadius.circular(10.0)),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton(
//                             hint: Text('select'),
//                             value: selected_atribution,
//                             items: _attributeData.map((e) {
//                               return DropdownMenuItem<String>(
//                                 child: Text(e.attributionname),
//                                 value: e.attributionname,
//                               );
//                             }).toList(), //[DropdownMenuItem(child: Text(''),value: Text(''),)],
//                             // _purchaseServices.products.map((e) => DropdownMenuItem<String>(child: Text(e.id),value: e.id,)).toList(),
//
//                             onChanged: (String value) async {
//                               // setState(() {
//                               selected_atribution = value.toString();
//
//                               // });
//                               print('attribute : ${value.toLowerCase()}');
//                               String a = await value.toLowerCase().replaceAll(" ", "_");
//                               print(a);
//                               print(_purchaseServices.products.length);
//
//                               productDetails = await _purchaseServices.products.firstWhere((element) => element.id == a, orElse: () => null);
//                               selectedAttribute = await _attributeData.firstWhere((element) => element.attributionname == value, orElse: () => null);
//
//                               for (var a in _purchaseServices.products) {
//                                 print(a.id);
//                               }
//
//                               print(selected_atribution);
//                               print('encodedd data : ${jsonEncode(productDetails.id)}');
//                               print(productDetails.price);
//
//                               setState(() {});
//
//                             }),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     Column(
//                       children: [
//                         Text(
//                           "Price: R\$ ${productDetails?.price ?? '0'}/mes",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10.0, right: 10, bottom: 20),
//                       child: Container(
//                           width: Get.width,
//                           child: CustomButton(
//                             text: "Activate Subscription",
//                             myFunc: () {
//                               print(
//                                   'selected_attributed : ${jsonEncode(selectedAttribute)}');
//                               // print(productDetails?.skuDetail.title);
//                               // print(productDetails?.skuDetail.priceCurrencyCode);
//                               // print(productDetails?.skuDetail.subscriptionPeriod);
//                               // print(productDetails?);
//
//                               selectedAttribute.checked = true;
//                               // Map paymentData = {
//                               //   "amount": productDetails?.price.toString(),
//                               //   'status': 'purchased',
//                               //   'packageId': productDetails?.id,
//                               //   // 'period': productDetails?.skProduct.subscriptionPeriod,
//                               // };
//                               // Map hospData = {
//                               //   "_id": widget.hospdata.sId,
//                               //   'name': widget.hospdata.name,
//                               // };
//
//                               onPresssed();
//                               // _purchaseServices.userId = widget.userId;
//                               // _purchaseServices
//                               //     .buyProduct(
//                               //         productDetails, widget.userId,
//                               //     selectedAttribute,
//                               //     paymentData,
//                               //     hospData,
//                               //     widget.isFromLogin,productDetails?.price?.toString())
//                               //     .then((value) {
//                               //   print('get response : ${value}');
//                               // });
//
// //******
// //                               print(
// //                                   'selected_attributed : ${jsonEncode(selectedAttribute)}');
// //                               selectedAttribute.checked = true;
// //
// //                               Map paymentData = {
// //                                 "amount": productDetails?.price,
// //                                 'status': 'purchased',
// //                                 'packageId': productDetails?.id,
// //                               };
// //                               Map hospData = {
// //                                 "_id": widget.hospdata.sId,
// //                                 'name': widget.hospdata.name,
// //                               };
// //                               _attributionController
// //                                   .saveAttributeAndPaymentDetails(
// //                                       widget.userId,
// //                                       selectedAttribute,
// //                                       paymentData,
// //                                       hospData,
// //                                       widget.isFromLogin);
//
//                               // ******
//                             },
//                           )),
//                     )
//                   ],
//                 )
//               ],
//             ),
//     );
//   }
//
//   String orderId = '';
//   onPresssed() {
//     _purchaseServices.buyProductt(
//         onPurchased: (PurchaseDetails purchaseDetails) async {
//           print("purchased}");
//           // print("productID: ${purchaseDetails.productID}");
//           // print("purchaseToken: ${purchaseDetails.billingClientPurchase.purchaseToken}");
//
//           if (Platform.isIOS) {
//             print("Purchase successfully IOS");
//             // print("order Id already ${testID}");
//
//             orderId = purchaseDetails.skPaymentTransaction.transactionIdentifier;
//
//             //
//             // //    orderId = purchaseDetails.billingClientPurchase.orderId;
//             //
//             // request.inapp_purchase_order_id = orderId;
//             // // request.p = purchaseDetails.productID;
//             // request.transaction_id = orderId;
//             //
//             // ///price_amount_micros Price in micro-units, where 1,000,000 micro-units equal one unit of the currency.
//             // ///For example, if price is "€7.99", price_amount_micros is "7990000".
//             // ///This value represents the localized, rounded price for a particular currency.
//             // //
//             //
//             // request.amount = (double.parse(_purchaseServices.productToBuy.skProduct.price) / 1000000.0).toString();
//             // request.currency_type = _purchaseServices.productToBuy.skProduct.priceLocale.currencySymbol;
//             // request.payment_status = "paid";
//             //
//             // // productToBuy.skuDetail.price
//             // // productToBuy.skuDetail.priceCurrencyCode
//             //
//             //
//             // // print("Purchase_detail_productID: ${request.productID}");
//             // print("Purchase_detail_purchaseToken: ${request.transaction_id}");
//             // print("tokenId--: ${request.transaction_id}");
//             //
//             //
//             //
//             // await prefs.setString('purchasedTOKEN', '${request.transaction_id}');
//             //
//             //
//             //
//             // print("Purchase_detail_amount: ${request.amount}");
//             // print(
//             //     "Purchase_detail_data: ${purchaseDetails.verificationData
//             //         .serverVerificationData}");
//             // var am = getCoinCount(products[index].id);
//             // request.amount = am.toString();
//             //
//             // // testID = request.transaction_id;
//             // print(
//             //     'coin added heree akash------------$am----------------');
//             // // isLoading = true;
//             // CommonResponse response = await _repository.addCoinToWallet(
//             //     request);
//             // isLoading = false;
//             //
//             // print("response: ${response.toString()}");
//             //
//             // if (response?.success ?? false) {
//             //   DefaultCacheManager().emptyCache();
//             //   // int am = amount;
//             //   // am += (_purchaseServices
//             //   //     .productToBuy.skuDetail.priceAmountMicros
//             //   //     .toInt() /
//             //   //     1000000.0).toInt();
//             //
//             //   print("update ${amount} ${am}");
//             //   amount += am;
//             //   isOrderRequestSuccess = true;
//             //   SharedPref.getInstance().setPrice(
//             //       request.amount.toString());
//             // } else {
//             //   if (response.reason != null &&
//             //       response.reason == _repository.reason_block) {
//             //     Future.delayed(Duration(milliseconds: 100)).then((
//             //         value) {
//             //       FrequentUtils.blockedAccountDialog(
//             //           context: context,
//             //           message: response?.message ?? "");
//             //     });
//             //   } else {
//             //     errorMessage = response?.message ?? "";
//             //   }
//             // }
//
//           } else if (orderId != purchaseDetails.billingClientPurchase.orderId) {
//             print("Purchase successfully");
//             orderId = purchaseDetails.billingClientPurchase.orderId;
//             onPurchased(purchaseDetails);
//           }
//         },
//         productDetails: productDetails);
//   }
//
//   onPurchased(PurchaseDetails purchaseDetails)async {
//     selectedAttribute.checked = true;
//     int status = widget.hospdata!=null? await hospitalController2.employeddVerification(widget.hospdata.sId) ?? 0  : 0;
//
//     DateTime _purchaseTime = DateTime.fromMillisecondsSinceEpoch(purchaseDetails.billingClientPurchase.purchaseTime);
//     print('purchase time date -- ${_purchaseTime}');
//     print('expire time date -- ${_purchaseTime.add(Duration(days: 1))}');
//
//     Map paymentData = {
//       "amount": productDetails?.price,
//       'status': 'purchased',
//       'package_id': productDetails?.id,
//       'order_id': purchaseDetails.billingClientPurchase?.orderId??'',
//       'purchase_time': purchaseDetails.billingClientPurchase?.purchaseTime?.toString()??'',
//       // 'purchase_token': purchaseDetails.billingClientPurchase?.purchaseToken??'',
//       'product_id': purchaseDetails?.productID??"",
//       'attribute_id': selectedAttribute?.sId??"",
//       'hospital_id': widget.hospdata?.sId??"",
//       'subscribed_date': _purchaseTime?.toString(),
//       'expired_date': _purchaseTime.add(Duration(days: 1)).toString(),
//       // 'expired_date': _purchaseTime.toString(),
//     };
//
//     // Map hospData;
//     // if(widget.hospdata!=null) {
//     Map hospData = {
//         "_id": widget.hospdata?.sId??"",
//         'name': widget.hospdata?.name??'',
//         'verificationStatus': status??"",
//       };
//     // }
//     print(jsonEncode(paymentData));
//
//     if(widget.hospdata!=null) {
//       _attributionController.saveAttributeAndPaymentDetails(widget.userId,
//           selectedAttribute, paymentData, hospData, widget.isFromLogin);
//     }else{
//       _attributionController.saveAttributeAndPaymentDetailsWihoutHosp(widget.userId,
//           selectedAttribute, paymentData, widget.isFromLogin);
//     }
//   }
// }
