import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/Locale/translation.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/navigation_service.dart';
import 'package:medical_app/screens/login&Sigup/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'config/cons/Sessionkey.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  // FlutterLocalNotificationsPlugin notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // await notificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // InAppPurchaseConnection.enablePendingPurchases();

  runApp(MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );

}

// DateFormat dateFormat = DateFormat("yyyy-MM-dd");
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Fcm_controller fcm_controller = Fcm_controller();
  final LocaleConfig localeConfig = Get.put(LocaleConfig());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fcm_controller.fcm_config();
    getDeviceDetails();

  }

  static Future<String> getDeviceDetails() async {
    // String deviceName;
    // String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        // deviceName = build.model;
        // deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
        print("UUID_for android,,.......   ${identifier.toString()}");
        await MySharedPreferences.instance
            .setStringValue(Session.device_id, identifier);
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        // deviceName = data.name;
        // deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
        print("UUID_for IOS,,.......   ${identifier.toString()}");
        await MySharedPreferences.instance.setStringValue(Session.device_id, identifier);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return '';
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: primary_color, //or set color with: Color(0xFF0000FF)
    ));
    return OverlaySupport(
      child: GetMaterialApp(
        navigatorKey: NavigationService.appNav,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          // GlobalWidgetsLocalizations.delegate,
          // GlobalCupertinoLocalizations.delegate,

        ],
        // supportedLocales: [
        //   Locale('en' 'US'),
        //   Locale('pt', 'BR'),
        // ],
        debugShowCheckedModeBanner: false,
        title: 'UniHealth',
        defaultTransition: Transition.rightToLeft,
        // transitionDuration: Duration(seconds: 1),
        theme: ThemeData(
          primarySwatch: kPrimaryColor,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          // fontFamily:'Nunito',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        translations: Languages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('en', 'US'),
      ),
    );
  }
}
