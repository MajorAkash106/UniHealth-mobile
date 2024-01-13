// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
//
// import 'package:flutter/services.dart';
//
// class SubscriptionService{
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
//     'nurse_technician'
//         'physiotherapist',
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
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   initPlatformState();
//   // }
//
//   // @override
//   void dispose() {
//     if (_conectionSubscription != null) {
//       _conectionSubscription.cancel();
//       _conectionSubscription = null;
//     }
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     // String platformVersion;
//     // // Platform messages may fail, so we use a try/catch PlatformException.
//     // try {
//     //   platformVersion = await FlutterInappPurchase.instance.platformVersion;
//     // } on PlatformException {
//     //   platformVersion = 'Failed to get platform version.';
//     // }
//     //
//     // // prepare
//     // var result = await FlutterInappPurchase.instance.initConnection;
//     // print('result: $result');
//     //
//     // // If the widget was removed from the tree while the asynchronous platform
//     // // message was in flight, we want to discard the reply rather than calling
//     // // setState to update our non-existent appearance.
//     // if (!mounted) return;
//     //
//     // setState(() {
//     //   _platformVersion = platformVersion;
//     // });
//
//     // refresh items for android
//     try {
//       String msg = await FlutterInappPurchase.instance.consumeAllItems;
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
//         });
//
//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//           print('purchase-error: $purchaseError');
//         });
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
//       for (var item in items) {
//         print('${item.toString()}');
//         this._items.add(item);
//       }
//
//       setState(() {
//         this._items = items;
//         this._purchases = [];
//       });
//     } catch (e) {
//       print('eceptions on getting product : ${e}');
//     }
//   }
//
//   Future _getPurchases() async {
//     List<PurchasedItem> items =
//     await FlutterInappPurchase.instance.getAvailablePurchases();
//     for (var item in items) {
//       print('${item.toString()}');
//       this._purchases.add(item);
//     }
//
//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }
//
//   Future _getPurchaseHistory() async {
//     List<PurchasedItem> items =
//     await FlutterInappPurchase.instance.getPurchaseHistory();
//     for (var item in items) {
//       print('${item.toString()}');
//       this._purchases.add(item);
//     }
//
//     setState(() {
//       this._items = [];
//       this._purchases = items;
//     });
//   }
//
//
//
// }