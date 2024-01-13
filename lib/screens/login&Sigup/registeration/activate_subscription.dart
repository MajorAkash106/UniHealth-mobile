// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:medical_app/config/Snackbars.dart';
// import 'package:medical_app/config/cons/colors.dart';
// import 'package:medical_app/config/cons/images.dart';
// import 'package:medical_app/config/widgets/buttons.dart';
// import 'package:medical_app/contollers/patient&hospital_controller/hospital_list_controller.dart';
// import 'package:medical_app/contollers/register_controller/allHospitals_Model.dart';
// import 'package:medical_app/contollers/register_controller/attribution_controller.dart';
// import 'package:medical_app/model/register_controller/attribution_model.dart';
// import 'dart:async';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
//
// class ActivateSubscription extends StatefulWidget {
//   final String userId;
//   final AllHoispitals hospdata;
//   final bool isFromLogin;
//   ActivateSubscription({this.userId, this.hospdata, this.isFromLogin});
//
//   @override
//   _ActivateSubscriptionState createState() => _ActivateSubscriptionState();
// }
//
// class _ActivateSubscriptionState extends State<ActivateSubscription> {
//   AttributionController _attributionController = AttributionController();
//   HospitalController2 hospitalController2 = HospitalController2();
//
//   String selected_atribution;
//   String selected_package;
//
//   List<AttributionData> _attributeData = [];
//   getData() async {
//     await Future.delayed(const Duration(milliseconds: 100), () {
//       _attributionController
//           .getAttribution(widget.hospdata?.sId ?? null)
//           .then((val) {
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
//
//
//   IAPItem _iapItem;
//   AttributionData selectedAttribute;
//
//   // **********************************************************************
//
//   StreamSubscription _purchaseUpdatedSubscription;
//   StreamSubscription _purchaseErrorSubscription;
//   StreamSubscription _conectionSubscription;
//   static const List<String> _kProductIds = <String>[
//     // 'com.pbs.one','com.pbs.two','com.pbs.ten','com.pbs.five'
//
//     'nurse_technician',
//     'palliative_care',
//     'pharmacist',
//     'palcare',
//     'physician',
//     'nurse_technician',
//     'physiotherapist',
//     'registered_dietitian',
//     'registered_nurse',
//     'speech_voice_swallowing_therapist',
//     'secretary',
//     'nt_coordinator',
//     'food_service',
//     'auditor',
//     'physiotherapist'
//   ];
//
//   String _platformVersion = 'Unknown';
//   List<IAPItem> _items = [];
//   List<PurchasedItem> _purchases = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   @override
//   void dispose() {
//     if (_conectionSubscription != null) {
//       _conectionSubscription.cancel();
//       _conectionSubscription = null;
//     }
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // try {
//     //   platformVersion = await FlutterInappPurchase.instance.platformVersion;
//     // } on PlatformException {
//     //   platformVersion = 'Failed to get platform version.';
//     // }
//
//     // prepare
//     var result = await FlutterInappPurchase.instance.initialize();
//     print('result: $result');
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       _platformVersion = platformVersion;
//     });
//
//     // refresh items for android
//     try {
//       String msg = await FlutterInappPurchase.instance.consumeAll();
//       print('consumeAllItems: $msg');
//     } catch (err) {
//       print('consumeAllItems error: $err');
//     }
//
//     _conectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//           print('connected: $connected');
//         });
//
//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((productItem) {
//           print('purchase-updated: ${productItem}');
//           getDetails(productItem);
//         });
//
//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//           print('purchase-error: $purchaseError');
//         });
//
//     _getProduct();
//   }
//
//   void _requestPurchase(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(item.productId);
//   }
//
//   Future _getProduct() async {
//     try {
//       List<IAPItem> items =
//       await FlutterInappPurchase.instance.getSubscriptions(_kProductIds);
//
//       print('get product : ${items}');
//
//       // for (var item in items) {
//       //   print('${item.toString()}');
//       //   this._items.add(item);
//       // }
//
//       productIds.clear();
//       for (var a in items) {
//         print('productId : ${a.productId}');
//         productIds.add(a.productId);
//       }
//
//       this._purchases = [];
//       setState(() {
//         this._items = items;
//       });
//       getData();
//     } catch (e) {
//       print('eceptions on getting product : ${e}');
//     }
//   }
//
//   // Future _getPurchases() async {
//   //   List<PurchasedItem> items =
//   //   await FlutterInappPurchase.instance.getAvailablePurchases();
//   //   for (var item in items) {
//   //     print('${item.toString()}');
//   //     this._purchases.add(item);
//   //   }
//   //
//   //   setState(() {
//   //     this._items = [];
//   //     this._purchases = items;
//   //   });
//   // }
//   //
//   // Future _getPurchaseHistory() async {
//   //   List<PurchasedItem> items =
//   //   await FlutterInappPurchase.instance.getPurchaseHistory();
//   //   for (var item in items) {
//   //     print('${item.toString()}');
//   //     this._purchases.add(item);
//   //   }
//   //
//   //   setState(() {
//   //     this._items = [];
//   //     this._purchases = items;
//   //   });
//   // }
//
//   //***********************************************************************
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             children: [
//               SafeArea(
//                 child: Container(
//                     height: 150,
//                     width: Get.width,
//                     color: primary_color,
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(5.0),
//                         child: Image.asset(
//                           AppImages.SplashlogoUnihealth,
//                           height: 100,
//                         ),
//                       ),
//                     )),
//               ),
//               Container(
//                 child: ListView(
//                   physics: NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                       child: Column(
//                         children: [
//
//                           Text(
//                             "subscription_des".tr,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 15),
//                           ),
//                           // SizedBox(
//                           //   height: 10.0,
//                           // ),
//                           // Text(
//                           //   "Save time collecting data and generating reports that will be inserted into medical records",
//                           //   style: TextStyle(
//                           //       fontWeight: FontWeight.bold, fontSize: 15),
//                           // ),
//                           // SizedBox(
//                           //   height: 10.0,
//                           // ),
//                           // Text(
//                           //     "Get access to multiple tools to monitor the evolution of your patients",
//                           //     style: TextStyle(
//                           //         fontWeight: FontWeight.bold, fontSize: 15)),
//                           // SizedBox(
//                           //   height: 10.0,
//                           // ),
//                           // Text(
//                           //     "Calculation and Scores performed in a simple and autoated way",
//                           //     style: TextStyle(
//                           //         fontWeight: FontWeight.bold, fontSize: 15)),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: Get.width,
//                 margin: const EdgeInsets.only(left: 10.0, right: 10),
//                 padding: const EdgeInsets.only(left: 10.0, right: 10),
//                 decoration: BoxDecoration(
//                     color: Colors.black12,
//                     borderRadius: BorderRadius.circular(10.0)),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton(
//                       hint: Text('select'.tr),
//                       value: selected_atribution,
//                       items: _attributeData.map((e) {
//                         return DropdownMenuItem<String>(
//                           child: Text(e.attributionname),
//                           value: e.attributionname,
//                         );
//                       }).toList(), //[DropdownMenuItem(child: Text(''),value: Text(''),)],
//                       // _purchaseServices.products.map((e) => DropdownMenuItem<String>(child: Text(e.id),value: e.id,)).toList(),
//
//                       onChanged: (String value) async {
//                         // setState(() {
//                         selected_atribution = value.toString();
//
//                         // });
//                         print('attribute : ${value.toLowerCase()}');
//                         String a = await value.toLowerCase().replaceAll(" ", "_");
//                         print(a);
//                         selected_package = a;
//                         print(_items.length);
//                         _iapItem = await _items.firstWhere((element) => element.productId == a, orElse: () => null);
//                         selectedAttribute = await _attributeData.firstWhere((element) => element.attributionname == value, orElse: () => null);
//
//
//
//                         print(selected_atribution);
//                         print('encodedd data : ${jsonEncode(_iapItem.productId)}');
//                         print(_iapItem.price);
//
//                         setState(() {});
//                       }),
//                 ),
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Column(
//                 children: [
//                   Text(
//                     "${'price'.tr}: R\$ ${_iapItem?.price ?? '0'}/mes",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 20.0,
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.only(left: 10.0, right: 10, bottom: 20),
//                 child: Container(
//                     width: Get.width,
//                     child: CustomButton(
//                       text: "activate_subscription".tr,
//                       myFunc: () async {
//                         print(
//                             'selected_attributed : ${jsonEncode(selectedAttribute)}');
//                         selectedAttribute.checked = true;
//                         // onPresssed();
//                         await _requestPurchase(_iapItem);
//                       },
//                     )),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   String orderId = '';
//   getDetails(PurchasedItem purchasedItem) {
//     if (purchasedItem != null) {
//       if (orderId != purchasedItem.transactionId) {
//         orderId = purchasedItem.transactionId;
//         print('productItem.transactionReceipt : ${purchasedItem.transactionReceipt}');
//         var decodedData = jsonDecode(purchasedItem.transactionReceipt);
//         print('purchaseState : ${decodedData['purchaseTime']}');
//
//         if (decodedData['purchaseState'] == 0) {
//
//           if(purchasedItem.productId == selected_package) {
//             print("Purchased successfully");
//             onPurchased(purchasedItem);
//           }
//         } else {
//           ShowMsg('Transaction Failed !, Something went wrong.');
//         }
//       }
//     }
//   }
//
//   onPurchased(PurchasedItem purchasedItem) async {
//     selectedAttribute.checked = true;
//     int status = widget.hospdata != null
//         ? await hospitalController2
//         .employeddVerification(widget.hospdata.sId) ??
//         0
//         : 0;
//
//     var decodedData = jsonDecode(purchasedItem.transactionReceipt);
//     print('purchaseTime : ${decodedData['purchaseTime']}');
//
//     DateTime _purchaseTime =
//     DateTime.fromMillisecondsSinceEpoch(decodedData['purchaseTime']);
//     print('purchase time date -- ${_purchaseTime}');
//     print('expire time date -- ${_purchaseTime.add(Duration(days: 1))}');
//
//     Map paymentData = {
//       "amount": _iapItem?.price ?? '',
//       'status': 'purchased',
//       'package_id': purchasedItem?.productId,
//       'order_id': purchasedItem?.transactionId ?? '',
//       'purchase_time': decodedData['purchaseTime'].toString() ?? '',
//       'purchase_token': purchasedItem?.purchaseToken ?? '',
//       'product_id': purchasedItem?.productId,
//       'attribute_id': selectedAttribute?.sId ?? "",
//       'hospital_id': widget.hospdata?.sId ?? "",
//       'subscribed_date': _purchaseTime?.toString(),
//       'expired_date': _purchaseTime.add(Duration(days: 1)).toString(),
//       // 'expired_date': _purchaseTime.toString(),
//     };
//
//     Map hospData = {
//       "_id": widget.hospdata?.sId ?? "",
//       'name': widget.hospdata?.name ?? '',
//       'verificationStatus': status ?? "",
//     };
//     // }
//     print(jsonEncode(paymentData));
//
//     if (widget.hospdata != null) {
//       print('api call with hosp');
//
//       _attributionController.saveAttributeAndPaymentDetails(widget.userId,
//           selectedAttribute, paymentData, hospData, widget.isFromLogin);
//     } else {
//       print('api call without hosp');
//       _attributionController.saveAttributeAndPaymentDetailsWihoutHosp(
//           widget.userId, selectedAttribute, paymentData, widget.isFromLogin);
//     }
//   }
// }
