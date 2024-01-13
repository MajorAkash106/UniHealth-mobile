import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/other_controller/notification_controller.dart';

class ManageMyNotification extends StatefulWidget {
  @override
  _ManageMyNotificationState createState() => _ManageMyNotificationState();
}

class _ManageMyNotificationState extends State<ManageMyNotification> {
  bool _switch1 = false;
  bool _switch2 = false;
  bool _switch3 = false;
  bool _switch4 = false;
  bool _switch5 = false;
  bool _switch6 = false;
  bool _switch7 = false;
  bool _switch8 = false;

  final NotificationConroller _controller = NotificationConroller();

  @override
  void initState() {
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHospitalData();
        print('internet avialable');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('manage_my_notification'.tr, null),
      bottomNavigationBar: CommonHomeButton(),
      body: Obx(()=>Container(
        child: ListView(
            children: _controller.getNotificationWardList
                .map(
                  (e) => ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${e.wardname}',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                trailing: CupertinoSwitch(
                  trackColor: switch_inactive_color,
                  activeColor: switch_active_color,
                  value: e.isNotification,
                  onChanged: (value) {
                    setState(() {
                      e.isNotification = value;
                      _controller.wardNotificationOnOff(e.sId,value);
                    });
                  },
                ),
              ),
            )
                .toList()),
      ),)
    );
  }
}
