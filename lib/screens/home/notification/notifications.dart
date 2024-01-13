import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/other_controller/fcmController.dart';
import 'package:medical_app/contollers/other_controller/notification_controller.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/home/notification/manage_my_notification.dart';
import 'package:swipe_to/swipe_to.dart';

class NotificationScreen extends StatefulWidget {
  final bool istoggle;
  final RxList notif_list;
  NotificationScreen({this.istoggle, this.notif_list, });
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  RxList<String> notification_list = <String>[].obs;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _switchValue = false;
  bool _switch1 = false;
  bool _switch2 = false;
  bool _switch3 = false;
  bool _switch4 = false;
  bool _switch5 = false;

  final NotificationConroller _conroller = NotificationConroller();
// Fcm_controller fcm_controller =Fcm_controller();
   @override
  void initState() {
    // TODO: implement initState
     setState(() {
       _switchValue = widget.istoggle;
     });
    super.initState();

     print('Callba');

    // print(widget.notif_list.length);
    // print(widget.notif_list.toString());
  }

  Future<bool>_willPopScope(){
     Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('notification'.tr,  IconButton(
          icon: SvgPicture.asset(AppImages.filterImageSvg,color: card_color,), onPressed: (){
        Get.to(ManageMyNotification());
      })
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Obx(()=>
            //child:
            Column(
              children: [
                // ListView(
                //   children: [
                    ListTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ignore_all'.tr,
                            style:
                                TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          Text(
                              'ignore_description'.tr, style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.normal))
                        ],
                      ),
                      trailing: CupertinoSwitch(
                        trackColor: switch_inactive_color,activeColor: switch_active_color,
                        value: _switchValue,
                        onChanged: (value) {
                          setState(() {

                            _switchValue = value;
                            _conroller.notificationOnOff(_switchValue);

                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.notif_list==null?0:widget.notif_list.length,
                          itemBuilder: (context, index){
                            return
                              widget.notif_list==null?
                              Center(child:Text("there is no notification")):

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: SwipeTo(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(AppImages.avtarImageUrl),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  title: Text(
                                      widget.notif_list[index],
                                     // 'Lorem ipsum is simply dummy text of the printing and typesetting.',
                                      style:
                                  TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                                  trailing: _switch1?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                                ),
                                onLeftSwipe: () {
                                  print('Callback from Swipe To Left');
                                  setState(() {
                                    _switch1 = !_switch1;
                                  });
                                },
                              ),
                            );

                      }),
                    )


                    // SizedBox(height: 20,),
                    // SwipeTo(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       radius: 25.0,
                    //       backgroundImage: NetworkImage(AppImages.avtarImageUrl),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     title: Text(
                    //         'Lorem ipsum is simply dummy text of the printing and typesetting.',style:
                    //     TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    //     trailing: _switch1?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                    //   ),
                    //   onLeftSwipe: () {
                    //     print('Callback from Swipe To Left');
                    //     setState(() {
                    //       _switch1 = !_switch1;
                    //     });
                    //   },
                    // ),
                    //
                    // SizedBox(height: 20,),
                    // SwipeTo(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       radius: 25.0,
                    //       backgroundImage:  NetworkImage(AppImages.avtarImageUrl),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     title: Text(
                    //         'Lorem ipsum is simply dummy text of the printing and typesetting.',style:
                    //     TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    //     trailing: _switch2?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                    //   ),
                    //   onLeftSwipe: () {
                    //     print('Callback from Swipe To Left');
                    //     setState(() {
                    //       _switch2 = !_switch2;
                    //     });
                    //   },
                    // ),
                    //
                    // SizedBox(height: 20,),
                    // SwipeTo(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       radius: 25.0,
                    //       backgroundImage:  NetworkImage(AppImages.avtarImageUrl),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     title: Text(
                    //         'Lorem ipsum is simply dummy text of the printing and typesetting.',style:
                    //     TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    //     trailing: _switch3?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                    //   ),
                    //   onLeftSwipe: () {
                    //     print('Callback from Swipe To Left');
                    //     setState(() {
                    //       _switch3 = !_switch3;
                    //     });
                    //   },
                    // ),
                    //
                    // SizedBox(height: 20,),
                    // SwipeTo(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       radius: 25.0,
                    //       backgroundImage:  NetworkImage(AppImages.avtarImageUrl),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     title: Text(
                    //         'Lorem ipsum is simply dummy text of the printing and typesetting.',style:
                    //     TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    //     trailing: _switch4?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                    //   ),
                    //   onLeftSwipe: () {
                    //     print('Callback from Swipe To Left');
                    //     setState(() {
                    //       _switch4 = !_switch4;
                    //     });
                    //   },
                    // ),
                    //
                    // SizedBox(height: 20,),
                    // SwipeTo(
                    //   child: ListTile(
                    //     leading: CircleAvatar(
                    //       radius: 25.0,
                    //       backgroundImage:  NetworkImage(AppImages.avtarImageUrl),
                    //       backgroundColor: Colors.transparent,
                    //     ),
                    //     title: Text(
                    //         'Lorem ipsum is simply dummy text of the printing and typesetting.',style:
                    //     TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    //     trailing: _switch5?SvgPicture.asset(AppImages.notificationDisable):SizedBox(),
                    //   ),
                    //   onLeftSwipe: () {
                    //     print('Callback from Swipe To Left');
                    //     setState(() {
                    //       _switch5 = !_switch5;
                    //     });
                    //   },
                    // ),

                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CommonHomeButton()
    );
  }
}
