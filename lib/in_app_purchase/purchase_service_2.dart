// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase/store_kit_wrappers.dart';
// import 'package:medical_app/config/Snackbars.dart';
//
// class PurchaseServices2 {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//
//   // static const String _kConsumableId = 'android.test.purchased';
//   // static const String _kConsumableId = 'ashu.consumable.product';
//
//   // static const List<String> _kProductIds = <String>['ashu.consumable.product','com.advisor.planfive'];
//   static const List<String> _kProductIds = <String>[
//     // 'com.pbs.one','com.pbs.two','com.pbs.ten','com.pbs.five'
//
//     'nurse_technician',
//     'palliative_care',
//     'pharmacist',
//     'palcare',
//     'physician',
//     'nurse_technician'
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
//
//   // static const List<String> _kProductIds = <String>[
//   //   'mysticall.package.5'
//   // ];
//
//   static const STORE_NOT_AVAILABLE =
//       "The store is unavailable at the moment. Please try again later or contact Help Support.";
//   static const PRODUCT_NOT_FOUND =
//       "In-App Product with id -  is not available in the store.";
//
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<ProductDetails> products = [];
//   List<PurchaseDetails> _purchases = [];
//   Function(String) onError;
//   Function onPurchaseComplete;
//   ProductDetails productToBuy;
//
//   bool isALready = false;
//
//   dispose() {
//     _subscription.cancel();
//   }
//
//   Future<void> init({@required Function(String) onErrorFun}) async {
//     onError = onErrorFun;
//     await _initStoreInfo(onError);
//   }
//
//   Future<String> getAllProduct() async {
//     try {
//       print('------------------get all products--------------------');
//       ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(_kProductIds.toSet());
//        products.clear();
//       print('sfsfsd ${productDetailResponse.productDetails.length}');
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       print("product count: " + products.length.toString());
//       print('product: ${products.first.id}');
//       print('product: ${products.first.title}');
//       print('product: ${products.first.price}');
//       // Future.delayed(const Duration(milliseconds: 200), () {
//       //
//       // });
//     } catch (e) {
//       print('exception occur : $e');
//     }
//     return '';
//   }
//   Future _initStoreInfo(Function onError) async {
//     final bool isAvailable = await _connection.isAvailable();
//     print('available store $isAvailable');
//     if (!isAvailable) {
//       onError(STORE_NOT_AVAILABLE);
//       return;
//     }
//
//     //listen for purchase updates
//     print("subscription   : ${_subscription == null}");
//     if(Platform.isIOS){
//       // final Stream<List<PurchaseDetails>> purchaseUpdates =
//       //     InAppPurchaseConnection.instance.purchaseUpdatedStream;
//       // purchaseUpdates.listen((event) {
//       //   print("purchase listener 3}");
//       // });
//       Stream purchaseUpdated = _connection.purchaseUpdatedStream;
//       _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//
//         print("purchase listener 2");
//
//         _listenToPurchaseUpdated(purchaseDetailsList);
//       },
//         onDone: () {
//           print("subscription done:");
//           _subscription.cancel();
//         },
//         onError: (error) {
//           print("Some _subscription error: ${error.toString()} ");
//           // handle error here.
//         },
//
//
//       );
//     }else {
//       Stream purchaseUpdated = _connection.purchaseUpdatedStream;
//       _subscription = purchaseUpdated.listen(
//
//
//             (purchaseDetailsList) {
//           _listenToPurchaseUpdated(purchaseDetailsList);
//         },
//         onDone: () {
//           print("subscription done:");
//           _subscription.cancel();
//         },
//         onError: (error) {
//           print("Some _subscription error: ${error.toString()} ");
//           // handle error here.
//         },
//
//
//       );
//     }
//     //getting all products
//     ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(_kProductIds.toSet());
//
//
//     //has error
//     if (productDetailResponse.error != null) {
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       print("product count" + products.length.toString());
//
//       onError(productDetailResponse.error.message);
//
//       return;
//     }
//
//
//     print('all Data: ${productDetailResponse.productDetails.length}');
//     //not found products
//     if (productDetailResponse.notFoundIDs.isNotEmpty) {
//       print('product here: ${productDetailResponse.productDetails}');
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       print("product not found");
//       print("product not found ${productDetailResponse.notFoundIDs}");
//       onError(PRODUCT_NOT_FOUND);
//       return;
//     }
//
//     // print(jsonEncode(productDetailResponse.productDetails[0]));
//
//
//     if(Platform.isIOS) {
//       products = productDetailResponse?.productDetails;
//
//     }else{
//       products = productDetailResponse?.productDetails
//           ?.where((element) => element.skuDetail.type == SkuType.inapp)
//           ?.toList() ??
//           List();
//     }
//     print(products.length.toString()+" length");
//
//
//     if (products != null && products.isNotEmpty) {
//       //finding product to buy
//       //  productToBuy = _initProductToBuy(products);
//     } else
//       onError(PRODUCT_NOT_FOUND);
//
//     //getting past purchases
//     final QueryPurchaseDetailsResponse purchaseResponse =
//     await _connection.queryPastPurchases();
//
//     if (purchaseResponse.error != null) {
//       print("queryPastPurchases err: ${purchaseResponse.error.message}");
//       onError(purchaseResponse.error.message);
//       // handle query past purchase error..
//     } else {
//       if (purchaseResponse.pastPurchases.isNotEmpty) {
//         _purchases = purchaseResponse.pastPurchases;
//         for (PurchaseDetails purchase in _purchases) {
//           await consumeProduct(purchase);
//         }
//       }
//     }
//     print("product count" + products.length.toString());
//     return;
//   }
//
//   // ProductDetails _initProductToBuy(List<ProductDetails> products) {
//   //   //assuming list is not null or empty
//   //   return products.firstWhere((element) => element.id == _kConsumableId,
//   //       orElse: () => null);
//   // }
//
//   consumeAllPurchased() async {
//     // IMPORTANT!! Always verify a purchase before delivering the product.
//     // For the purpose of an example, we directly return true.
//
//     print("_verifyPurchase");
//     final QueryPurchaseDetailsResponse response =
//     await InAppPurchaseConnection.instance.queryPastPurchases();
//     if (response.pastPurchases != null && response.pastPurchases.isNotEmpty) {
//       for (PurchaseDetails purchase in response.pastPurchases) {
//         await consumeProduct(purchase);
//       }
//     }
//
//     // return Future<bool>.value(true);
//   }
//
//   Future<bool> buyProduct({@required Function onPurchased}) async {
//     if (productToBuy != null) {
//       await consumeAllPurchased();
//       onPurchaseComplete = onPurchased;
//       PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: productToBuy,
//           applicationUserName: 'Akash tyagi',
//           sandboxTesting: true);
//       return await _connection.buyConsumable(
//           purchaseParam: purchaseParam, autoConsume: false);
//
//       // return Future.value(true); // TEST
//     } else {
//       onError("Cannot initiate purchase");
//       return Future.value(false);
//     }
//   }
//
//   Future<bool> buyProductt(
//       {@required Function onPurchased, ProductDetails productDetails}) async {
//     // await  _connection.refreshPurchaseVerificationData().then((value) {
//     //     print('valuee: $value');
//     //   });
//     print('exception here also');
//
//     productToBuy = productDetails;
//     if(Platform.isAndroid) {
//       if (!isALready) {
//
//         if (productToBuy != null) {
//
//           onPurchaseComplete = onPurchased;
//           PurchaseParam purchaseParam = PurchaseParam(
//               productDetails: productToBuy,
//               applicationUserName: 'Akash tyagi',
//               sandboxTesting: true);
//
//           return await _connection.buyNonConsumable(
//               purchaseParam: purchaseParam,);
//           // return Future.value(true); // TEST
//         } else {
//           onError("Cannot initiate purchase");
//           return Future.value(false);
//         }
//       } else {
//         onError(
//             "We are still initiating your purchase. Please have patience. You will be ready to make new purchase next time you come back here.");
//         ShowMsgFor10sec(
//             "We are still initiating your purchase. Please have patience. You will be ready to make new purchase next time you come back here.");
//       }
//     }else{
//
//       print("isALready: $isALready");
//       productToBuy = productDetails;
//       print('product details for purchasing: ${productDetails.id},${productDetails.title},${productDetails.price},${productDetails.description}');
//
//       onPurchaseComplete = onPurchased;
//
//
//       // final QueryPurchaseDetailsResponse response =
//       // await InAppPurchaseConnection.instance.queryPastPurchases();
//       // if (response.pastPurchases != null && response.pastPurchases.isNotEmpty) {
//       //   for (PurchaseDetails purchase in response.pastPurchases) {
//       //     print("completing");
//       //     await completePurchase(purchase);
//       //   }
//       // }
//
//       //  await consumeAllPurchased();
//
//       // print('A ${productDetails.skProduct.subscriptionPeriod}');
//       // print('productDetails.skuDetail.type ${productDetails.skuDetail.type}');
//       // print('SkuType.subs ${SkuType.subs}');
//       // print('B ${(Platform.isIOS && productDetails.skProduct.subscriptionPeriod == null) || (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)}');
//       //
//       final PurchaseParam purchaseParam = PurchaseParam(productDetails: productToBuy,sandboxTesting: false,);
//       // if ((Platform.isIOS && productDetails.skProduct.subscriptionPeriod == null) || (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
//       return await  InAppPurchaseConnection.instance.buyNonConsumable(purchaseParam: purchaseParam);
//
//       // }
//     }
//
//   }
//
//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     if(Platform.isIOS){
//       var v = purchaseDetailsList.last;
//
//       print('!isALready: ${!isALready}');
//
//       if (v != null) {
//         if (v.status == PurchaseStatus.pending) {
//           print("pending");
//           // onError("Your purchase is pending");
//         } else {
//           if (v.status == PurchaseStatus.error) {
//             print('exception here');
//             handleError(v.error);
//           } else if (v.status == PurchaseStatus.purchased) {
//             print('v-----${v.productID},${v.skPaymentTransaction},${v.transactionDate}');
//
//             print("purchased");
//             await _handlePurchase(v);
//           }
//         }
//       } else {
//         print("_listenToPurchaseUpdated: v null");
//         // onError("Something went wrong");
//       }
//     }else
//     if (!isALready) {
//       isALready = true;
//       var v = purchaseDetailsList.last;
//
//       if (v != null) {
//         if (v.status == PurchaseStatus.pending) {
//           print("pending");
//           //  onError("Your purchase is pending");
//         } else {
//           if (v.status == PurchaseStatus.error) {
//             handleError(v.error);
//           } else if (v.status == PurchaseStatus.purchased) {
//             print("purchased");
//             await _handlePurchase(v);
//           }
//         }
//       } else {
//         print("_listenToPurchaseUpdated: v null");
//         // onError("Something went wrong");
//       }
//     }else{
//       print("isALready else");
//     }
//
//     // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//     //
//     // });
//   }
//
//   void handleError(IAPError error) {
//     print("purchase error: ${error.message}");
//     if (error.message != "BillingResponse.userCanceled")
//       onError("${error.message}");
//   }
//
//   Future _handlePurchase(PurchaseDetails purchaseDetails) async {
//     await completePurchase(purchaseDetails);
//     await consumeProduct(purchaseDetails);
//     return;
//   }
//
//   completePurchase(PurchaseDetails purchaseDetails) async {
//     BillingResultWrapper _billingResultWrapper;
//
//     final pending = Platform.isIOS
//         ? purchaseDetails.pendingCompletePurchase
//         : !purchaseDetails.billingClientPurchase.isAcknowledged;
//
//     if (pending) {
//       print("completing Purchase");
//       _billingResultWrapper = Platform.isIOS
//           ? await InAppPurchaseConnection.instance
//           .completePurchase(purchaseDetails)
//           : await InAppPurchaseConnection.instance
//           .completePurchase(purchaseDetails);
//
//       if (_billingResultWrapper != null) {
//         print('resp----------- ${_billingResultWrapper.responseCode}');
//
//         if (_billingResultWrapper.responseCode == BillingResponse.ok || _billingResultWrapper.responseCode == BillingResponse.developerError) {
//           if (onPurchaseComplete != null) {
//
//             // if(productToBuy.id == purchaseDetails.)
//             print('onPurchaseComplete------------------');
//
//             // print("purchaseDetails.skPaymentTransaction.payment: ${purchaseDetails.skPaymentTransaction.payment.productIdentifier}");
//
//
//             // if(purchaseDetails.skPaymentTransaction.payment.productIdentifier == productToBuy.id){
//               print('gooddddddddd akashhhhhhhh');
//               onPurchaseComplete(purchaseDetails);
//             // }
//
//           }else{
//             print("onPurchaseComplete null");
//           }
//
//           print("purchase complete success");
//           // onError(_billingResultWrapper.debugMessage);
//         } else {
//           print(
//               "BillingResultWrapper.responseCode: ${_billingResultWrapper.responseCode}");
//           print("resp debugMessage: ${_billingResultWrapper.debugMessage}");
//           // onError(_billingResultWrapper.debugMessage);
//         }
//       } else {
//         print("purchase error: Something went wrong while processing payment.");
//         // onError("Something went wrong while processing payment.");
//       }
//     }else{
//
//       print("completing Purchase else");
//     }
//   }
//
//   Future consumeProduct(purchaseDetails) async {
//     BillingResultWrapper _billingResultWrapper;
//
//     //  if (Platform.isAndroid) {
//     print("isAndroid");
//     //  if (purchaseDetails.productID == _kConsumableId) {
//     print("consuming Purchase");
//
//     if(Platform.isIOS){
//       _billingResultWrapper = await InAppPurchaseConnection.instance.completePurchase(purchaseDetails);
//     }else
//       _billingResultWrapper = await InAppPurchaseConnection.instance.consumePurchase(purchaseDetails);
//
//
//     //  }
//     //   }
//
//     if (_billingResultWrapper != null && _billingResultWrapper.responseCode == BillingResponse.ok) {
//       print("-----------------");
//       print("Product Consumed");
//       print("BillingResultWrapper.responseCode: ${_billingResultWrapper.responseCode}");
//       print(
//           "BillingResultWrapper.debugMessage: ${_billingResultWrapper.debugMessage}");
//       // onError("Product Consumed");
//     } else {
//       print("consumeProduct: _billingResultWrapper null");
//       // onError("Something went wrong.");
//     }
//
//     return;
//   }
//
//   Future<void> reloadTransactions() async {
//     if (Platform.isIOS) {
//       SKPaymentQueueWrapper wrapper = SKPaymentQueueWrapper();
//       List<SKPaymentTransactionWrapper> transactions =
//       await wrapper.transactions();
//       transactions.forEach(
//             (transaction) {
//           if (transaction.transactionState ==
//               SKPaymentTransactionStateWrapper.purchased) {
//             wrapper.finishTransaction(transaction);
//           }
//         },
//       );
//     }
//   }
//
//   void purchaseItem(ProductDetails productDetails) {
//     final PurchaseParam purchaseParam =
//     PurchaseParam(productDetails: productDetails);
//     if ((Platform.isIOS &&
//         productDetails.skProduct.subscriptionPeriod == null) ||
//         (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
//       InAppPurchaseConnection.instance
//           .buyConsumable(purchaseParam: purchaseParam);
//     }
//   }
// }
