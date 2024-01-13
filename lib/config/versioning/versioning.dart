import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';

class AppVersionConfig extends GetxController {
  static const APP_STORE_URL = 'https://apps.apple.com/us/app/appname/idAPP-ID';
  static const PLAY_STORE_URL =
      'https://play.google.com/store/apps/details?id=APP-ID';

  void versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    print('currentVersion:: ${info.buildNumber}');

    // checkWithBackend(info.buildNumber);
    //Get Latest version info from server
  }

  Future<String> returnVersion() async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();

    print('currentVersion:: ${info.version}');

    String output = info.version;
    return output;
  }

//Show Dialog to force user to update
  void showVersionDialog(bool isSoft) async {
    await showDialog<String>(
      context: Get.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "There is a newer version of app available please update it now.";
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(APP_STORE_URL),
                      ),
                      isSoft == false
                          ? const SizedBox()
                          : ElevatedButton(
                              child: Text(btnLabelCancel),
                              onPressed: () => Navigator.pop(context),
                            ),
                    ],
                  )
                : AlertDialog(
                    title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text(btnLabel),
                        onPressed: () => _launchURL(PLAY_STORE_URL),
                      ),
                      isSoft == false
                          ? const SizedBox()
                          : ElevatedButton(
                              child: Text(btnLabelCancel),
                              onPressed: () => Navigator.pop(context),
                            ),
                    ],
                  ));
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // Future.delayed(const Duration(seconds: 3), () {
    //   versionCheck(Get.context!);
    // });
  }

  // void checkWithBackend(String version) async {
  //   String deviceType = Platform.isAndroid ? 'Android' : 'iphone';
  //
  //   Request request = Request(
  //       apiurl: ApiUrl.appVersion + '?DeviceType=$deviceType&version=$version');
  //
  //   await request.getMethodWithAuthNewWithoutLoader().then((value) {
  //     AppVersionModel model = AppVersionModel.fromJson(value?.data);
  //     print(value?.data);
  //     print(model);
  //     if (model.status == true && model.data != null) {
  //       showVersionDialog(model.data?.isSoftUpdate ?? true);
  //       // showVersionDialog(false);
  //
  //     }
  //   });
  // }
}
