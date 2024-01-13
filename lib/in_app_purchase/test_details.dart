// import 'package:flutter/material.dart';
// import 'package:medical_app/in_app_purchase/purchase_service.dart';
//
//
//
//
// class INAPPTEST extends StatefulWidget {
//   @override
//   _INAPPTESTState createState() => _INAPPTESTState();
// }
//
// class _INAPPTESTState extends State<INAPPTEST> {
//
//
//   final PurchaseServices _purchaseServices = PurchaseServices();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     _purchaseServices.init(
//       onErrorFun: (String err) {
//         print("error init $err");
//       },
//     );
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: RaisedButton(child: Text('get products'),onPressed: (){
//                   // _purchaseServices.init(
//                   //   onErrorFun: (String err) {
//                   //     print("error init");
//                   //   },
//                   // );
//                   _purchaseServices.getAllProduct();
//                 },),
//               ),
//
//               Column(children: _purchaseServices.productsPurchasedd.map((e) =>Text(' ${e.productID} - ${e.status}')).toList(),),
//
//               Column(children: _purchaseServices.products.map((e){
//                 return  Center(
//                   child: RaisedButton(child: Text(' ${e.id} buy at ${e.price}'),onPressed: (){
//                     print(e);
//                     _purchaseServices.buyProduct(e);
//                   },),
//                 );
//               }).toList(),)
//
//             ],)
//       ),
//     );
//   }
// }
