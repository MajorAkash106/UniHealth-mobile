// import 'dart:async';
// import 'dart:convert';
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase/store_kit_wrappers.dart';
// import 'package:medical_app/config/Snackbars.dart';
// import 'package:medical_app/config/sharedpref.dart';
// import 'package:medical_app/config/widgets/initial_loader.dart';
// import 'package:medical_app/contollers/register_controller/attribution_controller.dart';
// import 'package:medical_app/model/register_controller/attribution_model.dart';
// import 'package:medical_app/screens/login&Sigup/registeration/Identity_verificationScreen.dart';
//
// class PurchaseServices {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//
//   static const List<String> _kProductIds = <String>[
//     // 'com.pbs.ten',
//     // 'com.pbs.five',
//     // 'com.pbs.one',
//     // 'com.pbs.weeks',
//     // 'com.pbs.onee',
//     // 'com.pbs.three',
//     // 'com.pbs.four',
//
//     'nurse_technician',
//     'palliative_care',
//     'pharmacist',
//     'palcare',
//     'physician',
//     'physiotherapist',
//     'registered_dietitian',
//     'registered_nurse',
//     'speech_voice_swallowing_therapist'
//
//     // 'strive_employee',
//     // 'strive_employer',
//     // 'com.pbs.two',
//   ];
//
//   static const STORE_NOT_AVAILABLE =
//       "The store is unavailable at the moment. Please try again later or contact Help Support.";
//   static const PRODUCT_NOT_FOUND =
//       "In-App Product with id -  is not available in the store.";
//
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<ProductDetails> products = [];
//   List<PurchaseDetails> productsPurchasedd = [];
//   List<PurchaseDetails> _purchases = [];
//   Function(String) onError;
//   Function onPurchaseComplete;
//   ProductDetails productToBuy;
//
//   bool isALready = false;
//
//   String userId;
//
//   dispose() {
//     _subscription.cancel();
//   }
//
//   Future<void> init({@required Function(String) onErrorFun}) async {
//     onError = onErrorFun;
//     await _initStoreInfo(onError);
//     _getPastPurchases();
//     verifyPurchase();
//   }
//
//   Future<String> getAllProduct() async {
//     try {
//       print('------------------get all products--------------------');
//       ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(_kProductIds.toSet());
//       products.clear();
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
//
//   Future _initStoreInfo(Function onError) async {
//     print('****************************************');
//     final bool isAvailable = await _connection.isAvailable();
//     if (!isAvailable) {
//       onError(STORE_NOT_AVAILABLE);
//       return;
//     }
//
//     //listen for purchase updates
//     print("subscription   : ${_subscription == null}");
//     if (Platform.isIOS) {
//       // final Stream<List<PurchaseDetails>> purchaseUpdates =
//       //     InAppPurchaseConnection.instance.purchaseUpdatedStream;
//       // purchaseUpdates.listen((event) {
//       //   print("purchase listener 3}");
//       // });
//
//       Stream purchaseUpdated = _connection.purchaseUpdatedStream;
//       _subscription = purchaseUpdated.listen(
//         (purchaseDetailsList) {
//           print("purchase listener 2");
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
//       );
//     } else {
//       Stream purchaseUpdated = _connection.purchaseUpdatedStream;
//       _subscription = purchaseUpdated.listen(
//         (purchaseDetailsList) {
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
//       );
//     }
//     //getting all products
//     ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(_kProductIds.toSet());
//
//     //has error
//     // if (productDetailResponse.error != null) {
//     //   products = productDetailResponse.productDetails;
//     //   _purchases = [];
//     //   print("product count: " + products.length.toString());
//     //
//     //   onError(productDetailResponse.error.message);
//     //
//     //   return;
//     // }
//
//     //not found products
//     if (productDetailResponse.productDetails.isEmpty) {
//       products = productDetailResponse.productDetails;
//       _purchases = [];
//       print("product not found");
//       onError(PRODUCT_NOT_FOUND);
//       return;
//     }
//
//     // print(jsonEncode(productDetailResponse.productDetails[0]));
//
//     if (Platform.isIOS) {
//       products = productDetailResponse?.productDetails;
//     } else {
//       products = productDetailResponse?.productDetails
//               ?.where((element) => element.skuDetail.type == SkuType.inapp)
//               ?.toList() ??
//           List();
//     }
//     print(products.length.toString() + " length");
//
//     if (products != null && products.isNotEmpty) {
//       //finding product to buy
//       //  productToBuy = _initProductToBuy(products);
//     } else
//       onError(PRODUCT_NOT_FOUND);
//
//     //getting past purchases
//     final QueryPurchaseDetailsResponse purchaseResponse = await _connection.queryPastPurchases();
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
//         await InAppPurchaseConnection.instance.queryPastPurchases();
//     if (response.pastPurchases != null && response.pastPurchases.isNotEmpty) {
//       for (PurchaseDetails purchase in response.pastPurchases) {
//         await consumeProduct(purchase);
//       }
//     }
//
//     // return Future<bool>.value(true);
//   }
//
//   void verifyPurchase() async {
//     productsPurchasedd.clear();
//     await hasPurchased(_kProductIds);
//
//     // if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//     //   if (purchase.pendingCompletePurchase) {
//     //     _connection.completePurchase(purchase);
//     //
//     //     if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//     //       // isPurchased = true;
//     //       print('purchaseddd   ${purchase.productID}');
//     //     }else{
//     //       print('purchaseddd status : ${ purchase.status}');
//     //     }
//     //   }
//     // }
//   }
//
//   Future<void> _getPastPurchases() async {
//     QueryPurchaseDetailsResponse response =
//         await _connection.queryPastPurchases();
//     for (PurchaseDetails purchase in response.pastPurchases) {
//       if (Platform.isIOS) {
//         print('--------------$purchase');
//         _connection.consumePurchase(purchase);
//       }
//     }
//     _purchases = response.pastPurchases;
//   }
//
//   Future<PurchaseDetails> hasPurchased(List productID) async {
//     PurchaseDetails data;
//     for (var a in productID) {
//       print('id: $a');
//       print('past purchases: ${_purchases.length}');
//
//       PurchaseDetails purchase = await _purchases.firstWhere(
//           (purchase) => purchase.productID == a,
//           orElse: () => null);
//       if (purchase != null) {
//         print('--------${purchase.productID}');
//
//         if (purchase != null && purchase.status == PurchaseStatus.purchased) {
//           if (purchase.pendingCompletePurchase) {
//             _connection.completePurchase(purchase);
//
//             if (purchase != null &&
//                 purchase.status == PurchaseStatus.purchased) {
//               // isPurchased = true;
//               print('purchaseddd   ${purchase.productID}');
//               productsPurchasedd.add(purchase);
//             } else {
//               print('purchaseddd status : ${purchase.status}');
//             }
//           }
//         }
//
//         data = await purchase;
//         // break;
//       }
//     }
//
//     // print('get product from past pusrchases :${_purchase.status}');
//     return data;
//   }
//
//   AttributionData badgedata;
//   Map paymentDetails;
//   Map hospData;
//   bool isFromLogin;
//   String user_Id;
//   String pricee;
//
//   Future<bool> buyProduct(
//       ProductDetails product,
//       String userid,
//       AttributionData badge,
//       Map paymentDetail,
//       Map hosp,
//       bool isFromLogins,
//       String price) async {
//     print('------------get all data-----------------');
//     paymentDetails = paymentDetail;
//     hospData = hosp;
//     badgedata = badge;
//     isFromLogin = isFromLogins;
//     user_Id = userid;
//     pricee = price;
//     productToBuy = product;
//     print(jsonEncode(paymentDetails));
//     print(jsonEncode(hospData));
//
//     // print(
//     //     'json data : ${productToBuy.skProduct.subscriptionPeriod.numberOfUnits}');
//     // print('json data : ${productToBuy.skProduct.subscriptionPeriod.unit}');
//
//     // showLoader()
//
//     // await reloadTransactions();
//
//     if (productToBuy != null) {
//       // await consumeAllPurchased();
//       // onPurchaseComplete = onPurchased;
//       PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: productToBuy,
//           applicationUserName: 'akash_testing',
//           sandboxTesting: false);
//
//       return await _connection
//           .buyNonConsumable(purchaseParam: purchaseParam)
//           .whenComplete(() => print('complete purchase func here'));
//
//       // return Future.value(true); // TEST
//     } else {
//       onError("Cannot initiate purchase");
//       return Future.value(false);
//     }
//   }
//
//   // Future<bool> buyProductCoin(
//   //     {@required Function onPurchased, ProductDetails productDetails}) async {
//   //
//   //   productToBuy = productDetails;
//   //   if(Platform.isAndroid) {
//   //     if (!isALready) {
//   //
//   //       if (productToBuy != null) {
//   //
//   //         onPurchaseComplete = onPurchased;
//   //         PurchaseParam purchaseParam = PurchaseParam(
//   //             productDetails: productToBuy,
//   //             applicationUserName: 'Akash_testing',
//   //             sandboxTesting: true);
//   //
//   //         return await _connection.buyConsumable(
//   //             purchaseParam: purchaseParam, autoConsume: Platform.isIOS);
//   //         // return Future.value(true); // TEST
//   //       } else {
//   //         onError("Cannot initiate purchase");
//   //         return Future.value(false);
//   //       }
//   //     } else {
//   //       onError(
//   //           "We are still initiating your purchase. Please have patience. You will be ready to make new purchase next time you come back here.");
//   //     }
//   //   }else{
//   //     productToBuy = productDetails;
//   //     onPurchaseComplete = onPurchased;
//   //
//   //     // final QueryPurchaseDetailsResponse response =
//   //     // await InAppPurchaseConnection.instance.queryPastPurchases();
//   //     // if (response.pastPurchases != null && response.pastPurchases.isNotEmpty) {
//   //     //   for (PurchaseDetails purchase in response.pastPurchases) {
//   //     //     print("completing");
//   //     //     await completePurchase(purchase);
//   //     //   }
//   //     // }
//   //
//   //     //  await consumeAllPurchased();
//   //     final PurchaseParam purchaseParam = PurchaseParam(productDetails: productToBuy);
//   //
//   //     if ((Platform.isIOS && productDetails.skProduct.subscriptionPeriod == null) || (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
//   //       return await  InAppPurchaseConnection.instance.buyConsumable(purchaseParam: purchaseParam);
//   //     }
//   //
//   //   }
//   //
//   // }
//
//   Future<void> _listenToPurchaseUpdated(
//       List<PurchaseDetails> purchaseDetailsList) async {
//     if (Platform.isIOS) {
//       var v = purchaseDetailsList.last;
//
//       if (v != null) {
//         if (v.status == PurchaseStatus.pending) {
//           print("pending");
//           // onError("Your purchase is pending");
//         } else {
//           if (v.status == PurchaseStatus.error) {
//             handleError(v.error);
//           } else if (v.status == PurchaseStatus.purchased) {
//             print("purchased");
//             // sucessfullyDone(v);
//             await _handlePurchase(v);
//           }
//         }
//       } else {
//         print("_listenToPurchaseUpdated: v null");
//         // onError("Something went wrong");
//       }
//       // } else if (!isALready) {
//       //   isALready = true;
//       //   var v = purchaseDetailsList.last;
//       //
//       //   if (v != null) {
//       //     if (v.status == PurchaseStatus.pending) {
//       //       print("pending");
//       //       //  onError("Your purchase is pending");
//       //     } else {
//       //       if (v.status == PurchaseStatus.error) {
//       //         handleError(v.error);
//       //       } else if (v.status == PurchaseStatus.purchased) {
//       //         print("purchased");
//       //         sucessfullyDone(v);
//       //         await _handlePurchase(v);
//       //       }
//       //     }
//       //   } else {
//       //     print("_listenToPurchaseUpdated: v null");
//       //     // onError("Something went wrong");
//       //   }
//     } else {
//       print("isALready else");
//       var v = purchaseDetailsList.last;
//       print('case : ${v.status}');
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
//             print("--------idsss--------- ${v.productID}");
//             // if(lastid==null || v.productID.toString() != lastid){
//             //   sucessfullyDone(v);
//               await _handlePurchase(v);
//               lastid = v.productID.toString();
//             // }
//
//           }
//         }
//       } else {
//         print("_listenToPurchaseUpdated: v null");
//         // onError("Something went wrong");
//       }
//     }
//
//     // purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//     //
//     // });
//   }
//
// String lastid;
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
//               .completePurchase(purchaseDetails)
//           : await InAppPurchaseConnection.instance
//               .completePurchase(purchaseDetails);
//
//       if (_billingResultWrapper != null) {
//         if (_billingResultWrapper.responseCode == BillingResponse.ok) {
//
//
//           // print('test -----${purchaseDetails.skPaymentTransaction.payment.productIdentifier}');
//           // print(' test -----${productToBuy.id}}');
//
//
//           print('----------yes akash goood job----${productToBuy.id}----');
//           // print('hhhhhhh----- ${purchaseDetails.skPaymentTransaction.payment.productIdentifier}');
//
//           // var v = purchaseDetailsList.last;
//           if(purchaseDetails.skPaymentTransaction.transactionIdentifier != purchaseDetails.billingClientPurchase.orderId) {
//             print('equal to equal');
//             sucessfullyDone(purchaseDetails);
//           }
//
//
//           if (onPurchaseComplete != null) {
//
//             // print('AT ${purchaseDetails.skPaymentTransaction.payment.productIdentifier} - ${productToBuy.id}');
//             //
//             // if (purchaseDetails.skPaymentTransaction.payment.productIdentifier == productToBuy.id) {
//             //   print('gooddddddddd akashhhhhhhh');
//             //   onPurchaseComplete(purchaseDetails);
//             // }
//             // onPurchaseComplete(purchaseDetails);
//
//             print('test -----${purchaseDetails.skPaymentTransaction.payment.productIdentifier}');
//             print(' test -----${productToBuy.id}}');
//
//             print('----------yes akash goood job--------');
//
//
//
//           } else {
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
//     } else {
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
//     if (Platform.isIOS) {
//       _billingResultWrapper = await InAppPurchaseConnection.instance
//           .completePurchase(purchaseDetails);
//     } else
//       _billingResultWrapper = await InAppPurchaseConnection.instance
//           .consumePurchase(purchaseDetails);
//
//     //  }
//     //   }
//
//     if (_billingResultWrapper != null &&
//         _billingResultWrapper.responseCode == BillingResponse.ok) {
//       print("-----------------");
//       print("Product Consumed");
//       print(
//           "BillingResultWrapper.responseCode: ${_billingResultWrapper.responseCode}");
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
//           await wrapper.transactions();
//       transactions.forEach(
//         (transaction) {
//           print(transaction.payment);
//           wrapper.finishTransaction(transaction);
//           // print('workingg');
//           // if (transaction.transactionState == SKPaymentTransactionStateWrapper.purchased) {
//           //   wrapper.finishTransaction(transaction);
//
//           // }
//         },
//       );
//       // print('finisheddd');
//     }
//   }
//
//   void purchaseItem(ProductDetails productDetails) {
//     final PurchaseParam purchaseParam =
//         PurchaseParam(productDetails: productDetails);
//     if ((Platform.isIOS &&
//             productDetails.skProduct.subscriptionPeriod == null) ||
//         (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
//       InAppPurchaseConnection.instance
//           .buyConsumable(purchaseParam: purchaseParam);
//     }
//   }
//
//   AttributionController _attributionController = AttributionController();
//   sucessfullyDone(PurchaseDetails purchaseDetails) async {
//     // ShowMsgFor10sec('successfully purchased...!');
//     // print('get userid : $userId');
//     // Get.to(Identity_VerificationScreen(userId: userId,));
//     print(
//         '---------------------save attribution data------------------------------');
//     print(user_Id);
//     print(jsonEncode(badgedata));
//     print(jsonEncode(paymentDetails));
//     print(jsonEncode(hospData));
//     print(isFromLogin);
//
//     print('details : ${purchaseDetails.productID}');
//     print('details : ${purchaseDetails.status}');
//     print('details : ${purchaseDetails.transactionDate}');
//     // print('details : ${purchaseDetails.billingClientPurchase.packageName}');
//     print('details : ${purchaseDetails.billingClientPurchase.purchaseState}');
//     // print('details : ${purchaseDetails.skPaymentTransaction.payment.applicationUsername}');
//     print('details : ${purchaseDetails.billingClientPurchase.purchaseTime}');
//     print('details : ${purchaseDetails.billingClientPurchase.purchaseToken}');
//     print('details : ${purchaseDetails.billingClientPurchase.isAutoRenewing}');
//     print('details : ${purchaseDetails.billingClientPurchase.orderId}');
//
//     Map data = {
//       "productId": purchaseDetails.productID.toString(),
//       "status": purchaseDetails.status.toString(),
//       "purchaseTime": purchaseDetails.transactionDate.toString(),
//       "purchaseToken":
//           purchaseDetails.billingClientPurchase.purchaseToken.toString(),
//       "isAutoRenew":
//           purchaseDetails.billingClientPurchase.isAutoRenewing.toString(),
//       "orderId": purchaseDetails.billingClientPurchase.orderId.toString(),
//       "amount": pricee.toString(),
//       // "status":paymentDetails['status'],
//     };
//
//     // data.addAll(paymentDetails);
//
//     print('final payment details : ${jsonEncode(data)}');
//     // print('badges sId: ${badgedata.sId}');
//
//     // print('details : ${purchaseDetails.billingClientPurchase.purchaseState.}');
//     // print('--------calling saving func');
//     Future.delayed(const Duration(milliseconds: 500), () async {
//       var getA =
//           await MySharedPreferences.instance.getStringValue("testt") ?? '';
//
//       if (getA.isNullOrBlank || getA != purchaseDetails.productID) {
//         print('--------calling saving func');
//         await MySharedPreferences.instance
//             .setStringValue('testt', purchaseDetails.productID);
//         onSavedData(user_Id, badgedata, data, hospData, isFromLogin);
//         // _attributionController.saveAttributeAndPaymentDetails(
//         //     user_Id, badgedata, data, hospData, isFromLogin);
//       }else{
//         print('else part');
//       }
//     });
//   }
//
//   String getPackageId;
//   String getPackageSubID;
//
//   onSavedData(String userId, AttributionData badge, Map paymentDetails,
//       Map hosp, bool isFromLogin) {
//     print('save data please.');
//     //
//     _attributionController.saveAttributeAndPaymentDetails(
//         user_Id, badgedata, paymentDetails, hospData, isFromLogin).then((value){
//           // break;
//       print('return from api func');
//     });
//   }
// }
