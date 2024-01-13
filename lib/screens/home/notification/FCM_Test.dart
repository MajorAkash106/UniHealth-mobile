// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
//
// class FCM extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _FCMState();
//   }
// }
//
// class _FCMState extends State<FCM> {
//   String _message = '';
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   _register() {
//     _firebaseMessaging.getToken().then((token) => print('fcm--- $token'));
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var initializationSettingsIOS = IOSInitializationSettings();
//     var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//     getMessage();
//   }
//   Future onSelectNotification(String payload){
//     print('notification here $payload');
//   }
//
//   void getMessage(){
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print('msg-----------------------------');
//           print('on message $message');
//           showNotification(message);
//           setState(() => _message = message["notification"]["title"]);
//         }, onResume: (Map<String, dynamic> message) async {
//       print('resume-----------------------------');
//       print('on resume $message');
//       showNotification(message);
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('launch-----------------------------');
//       print('on launch $message');
//       showNotification(message);
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
//
//   void showNotification(Map<String, dynamic> message) {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'your channel id', 'your channel name', 'your channel description',
//         importance: Importance.max, priority: Priority.high, ticker: 'ticker');
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
//     flutterLocalNotificationsPlugin.show(0, message['notification']['title'],
//         message['notification']['body'], platformChannelSpecifics,
//         payload: message['data']['title']);
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: Center(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text("Message: $_message"),
//               OutlineButton(
//                 child: Text("Register My Device"),
//                 onPressed: () {
//                   _register();
//                 },
//               ),
//               // Text("Message: $message")
//             ]),
//       ),
//     );
//   }
// }