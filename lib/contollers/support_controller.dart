import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class SupportController extends GetxController {
  void callSupportFn(BuildContext context) async {
    _showMyDialog(context);
  }

  void redirectToWhatsApp() async {
    String name =
        await MySharedPreferences.instance.getStringValue(Session.name);
    print('get name:$name');
    final link = WhatsAppUnilink(
      phoneNumber: '+55 16997016434 ',
      text: "Hey! I'm $name\nI've some queries.",
    );
    await launch('$link');
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('do_you_want_to_proceed'.tr),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                    "support_des".tr),
                // Text('Would you like to confirm this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('yes'.tr.toUpperCase()),
              onPressed: () {
                Get.back();
                redirectToWhatsApp();
              },
            ),
            TextButton(
              child: Text('no'.tr.toUpperCase()),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
