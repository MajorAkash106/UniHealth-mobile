//
//
// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:medical_app/config/cons/images.dart';
// import 'package:medical_app/screens/home/home_screen.dart';
// import 'package:medical_app/screens/home/notification/notifications.dart';
// import 'package:overlay_support/overlay_support.dart';
//
// import 'home_contoller.dart';
//
// RxList<String> gnotification_list = <String>[].obs;
//
// class Fcm_controller extends GetxController{
//
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
//
//   final HomeConroller _conroller = HomeConroller();
//
//
//   String messageTitle = "Empty";
//   String notificationAlert = "alert";
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging();
//
//   RxList<String> notification_list = <String>[].obs;
//
//
//
//   Future displayNotification(Map<String, dynamic> message) async{
//
//     final AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('first_aid_kit');
//     final IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings(
//         requestSoundPermission: true,
//         requestBadgePermission: true,
//         requestAlertPermission: true,
//         defaultPresentSound: true,
//         onDidReceiveLocalNotification:onrecieve(message)
//     );
//
//     final InitializationSettings initializationSettings =
//     InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//
//         macOS: null);
//
//
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,//);
//         onSelectNotification:selectnotification);
//
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//         '1', 'flutterfcm', 'your channel description',priority: Priority.high,importance: Importance.max,playSound: true,channelShowBadge: true,
//         sound: RawResourceAndroidNotificationSound('notiflysound'),
//     );
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails(presentBadge: true);
//     var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics,);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       message['notification']['title'],
//       message['notification']['body'],
//       platformChannelSpecifics,
//       payload: 'hello',);
//
//   }
//   Future fcm_config(){
//
//     firebaseMessaging.configure(
//         onMessage: (message) async{
//
//           //  setState(() async{
//           await   print('abc................');
//
//           print('............${message}');
//           await print('123');
//           messageTitle = message["notification"]["title"];
//           await print('1234');
//           notificationAlert = message["notification"]["body"];
//           await print("onmsg $messageTitle");
//
//           await displayNotification(message);
//
//
//          // await print('lenth:.........${notification_list.length}');
//           //await print('value:${notification_list.toString()}');
//           // Get.to(()=>Notification_screen(notif: notification_list,));
//
//           // notification();
//
//           // showSimpleNotification(
//           //   //leading:SvgPicture.asset(AppImages.logo_image),
//           //
//           //   Text(messageTitle,style: TextStyle(color: Colors.black),),
//           //   leading:Container(height:25.0,width:25.0,child: SvgPicture.asset(AppImages.Splashlogo)),
//           //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
//           //
//           //   subtitle: Text(notificationAlert,style: TextStyle(color: Colors.black),),
//           //   background: Colors.white,//Colors.cyan[700],
//           //   foreground: Colors.white
//           //
//           // );
//            //}),;
//          // Get.to(NotificationScreen(notif: notification_list,));
//
//         },
//         onBackgroundMessage: myBackgroundMessageHandler,
//
//         onResume: (message) async{
//         //myBackgroundMessageHandler(message);
//           //  setState(()async {
//           await print('onresume');
//           //_navigateToDetail(message);
//           await print('onresume:.... ${message}');
//           await print('a');
//           //await displayNotification(message);
//           await print('b');
//          // await notification_list.insert(0,message["data"]["value"]);//assignAll(message["data"]["value"]);
//           await print('c');
//          // await print('lenth:.........${notification_list.length}');
//           await print('d');
//          // await print('value:${notification_list[0]}');
//           await print('e');
//
//           notification_list.insert(0,message["data"]["body"]);
//           gnotification_list.assignAll(notification_list);
//
//           print(gnotification_list.toString());
//         await   Get.to(NotificationScreen(istoggle: _conroller.notificationn.value,notif_list: gnotification_list,)).then((value) =>
//             _conroller.getData());
//
//
//         },
//
//         onLaunch:(message)async{
//
//           print('onlaunch');
//
//           await print('onlaunch:.... ${message}');
//           notification_list.insert(0,message["data"]["body"]);
//
//           gnotification_list.assignAll(notification_list);
//
//
//           await   Get.to(NotificationScreen(istoggle: _conroller.notificationn.value,notif_list: gnotification_list,)).then((value) =>
//               _conroller.getData());
//         }
//     );
//   }
//
//
//   Future selectnotification(message)async{
//     print('selected');
//     print(gnotification_list.toString());
//    // await flutterLocalNotificationsPlugin.cancelAll();
//     await   Get.to(NotificationScreen(istoggle: _conroller.notificationn.value,notif_list: gnotification_list,)).then((value) =>
//         _conroller.getData());
//
//   }
//
//   onrecieve(message){
//     print('recieved');
//     print('recieved msg....${message}');
//      print('f...lenth:.........${notification_list.length}');
//      notification_list.insert(0,message["data"]["body"]);
//
//
//
//      gnotification_list.assignAll(notification_list);
//
//      print('r');
//      print(gnotification_list.toString());
//
//
//      print(notification_list.toString());
//      print('lenth:.........${notification_list.length}');
//
//     //notification();
//     // Get.to(Notification_screen());
//     // showSimpleNotification(
//     //   //leading:SvgPicture.asset(AppImages.logo_image),
//     //
//     //   Text(messageTitle),
//     //   leading:SvgPicture.asset(AppImages.logo_image),
//     //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
//     //   subtitle: Text(notificationAlert),
//     //   background: Colors.cyan[700],
//     //
//     // );
//   }
//
// }
//
//  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
//
//   print('on background $message');
//   if (message['data'] != null) {
//     final data = message['data'];
//
//     final title = data['title'];
//     final body = data['message'];
// print(gnotification_list.toString());
//
//    // Get.to(NotificationScreen(notif_list: gnotification_list,));
//
//    // await _showNotificationWithDefaultSound(title, message);
//   }
//   //return Future<void>.value();
//
//   // showSimpleNotification(
//   //   //leading:SvgPicture.asset(AppImages.logo_image),
//   //
//   //   Text('messageTitle'),
//   //   leading:SvgPicture.asset(AppImages.bellIcon),
//   //   // leading: NotificationBadge(totalNotifications: _totalNotifications),
//   //   subtitle: Text('notificationAlert'),
//   //   background: Colors.transparent,
//   //
//   // );
//   //Get.to(NotificationScreen());
// }
// const AndroidNotificationChannel channel
// = AndroidNotificationChannel('High_performance_channel', 'High importance notification', 'This is description',importance:  Importance.high,playSound: true);