import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/hospitalization_controller/newHospController.dart';
import 'package:medical_app/contollers/other_controller/notification_controller.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/model/filter_ward_medical.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/medicalDivision.dart';

class WardFilter extends StatefulWidget {
  final String hospiId;
  WardFilter({this.hospiId});
  @override
  _WardFilterState createState() => _WardFilterState();
}

class _WardFilterState extends State<WardFilter> {
  final NotificationConroller _controller = NotificationConroller();
  final NewHospController _wardMedicalcontroller = NewHospController();
  final HospitalSqflite sqflite = HospitalSqflite();
  final OfflineHandler offlineHandler = OfflineHandler();

  @override
  void initState() {
    checkConnectivityWithToggle(widget.hospiId).then((internet) {
      print('internet');
      if (internet != null && internet) {
        _wardMedicalcontroller.getWardData(widget.hospiId);
        Hospital hospital = Hospital();
        hospital.sId = widget.hospiId;
        _wardMedicalcontroller.getMedicalData([hospital]);

        print('internet avialable');
      } else {
        _wardMedicalcontroller.getWardDataOffline(widget.hospiId);
        Hospital hospital = Hospital();
        hospital.sId = widget.hospiId;
        _wardMedicalcontroller.getMedicalDataOffline([hospital]);
      }
    });
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'filter_ward_medical_division'.tr,
            style: TextStyle(color: card_color, fontSize: 15.0),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        index = 0;
                        setState(() {});
                      },
                      child: Container(
                          width: Get.width / 2.2,
                          height: 45,
                          decoration: BoxDecoration(
                            color: index == 0 ? primary_color : Colors.white,
                            border:
                                Border.all(color: primary_color, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              'wards'.tr,
                              style: TextStyle(
                                  color:
                                      index == 0 ? Colors.white : Colors.black),
                            ),
                          )),
                    ),
                    InkWell(
                      onTap: () {
                        index = 1;
                        setState(() {});
                      },
                      child: Container(
                          width: Get.width / 2.2,
                          height: 45,
                          decoration: BoxDecoration(
                            color: index == 1 ? primary_color : Colors.white,
                            border:
                                Border.all(color: primary_color, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              'medical_division'.tr,
                              style: TextStyle(
                                  color:
                                      index == 1 ? Colors.white : Colors.black),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(child: index == 0 ? _wardWidget() : _medicalWidget())
            ],
          ),
        ));
  }

  Widget _wardWidget() {
    return Container(
        child: Obx(
      () => Container(
        child: ListView(
            children: _wardMedicalcontroller.wardListdata
                .map((e) => Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${e.wardname}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          FutureBuilder(
                              initialData: false,
                              future: offlineHandler.getFilterStatus(e.sId??null),
                              builder: (context, snapshot) {
                                e.isBlocked = snapshot.data;
                                return FlutterSwitch(
                                  width: 50.0,
                                  height: 25.0,
                                  activeColor: primary_color,
                                  valueFontSize: 12.0,
                                  toggleSize: 18.0,
                                  value: e.isBlocked ?? false,
                                  onToggle: (val) async {
                                    setState(() {
                                      e.isBlocked = val;

                                      FilterWardMedical filterWardMedical =
                                          FilterWardMedical();

                                      filterWardMedical.id = e.sId;
                                      filterWardMedical.staus = val;

                                      sqflite.saveFilteredStatus(
                                          e.sId, filterWardMedical);
                                    });
                                  },
                                );
                              })
                        ],
                      ),
                    ))
                .toList()),
      ),
    ));
  }

  Widget _medicalWidget() {
    return Container(
        child: Obx(
      () => Container(
        child: ListView(
            children: _wardMedicalcontroller.medicalListdata
                .map((e) => Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${e.division}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                          ),
                          FutureBuilder(
                              initialData: false,
                              future: offlineHandler.getFilterStatus(e.sId??null),
                              builder: (context, snapshot) {
                                e.isBlocked = snapshot.data;
                                return FlutterSwitch(
                                  width: 50.0,
                                  height: 25.0,
                                  activeColor: primary_color,
                                  valueFontSize: 12.0,
                                  toggleSize: 18.0,
                                  value: e.isBlocked ?? false,
                                  onToggle: (val) async {
                                    setState(() {
                                      e.isBlocked = val;

                                      FilterWardMedical filterWardMedical =
                                          FilterWardMedical();

                                      filterWardMedical.id = e.sId;
                                      filterWardMedical.staus = val;

                                      sqflite.saveFilteredStatus(
                                          e.sId, filterWardMedical);
                                    });
                                  },
                                );

                                CupertinoSwitch(
                                  trackColor: switch_inactive_color,
                                  activeColor: switch_active_color,
                                  value: e.isBlocked,
                                  onChanged: (val) {
                                    setState(() {
                                      e.isBlocked = val;

                                      FilterWardMedical filterWardMedical =
                                          FilterWardMedical();

                                      filterWardMedical.id = e.sId;
                                      filterWardMedical.staus = val;

                                      sqflite.saveFilteredStatus(
                                          e.sId, filterWardMedical);
                                    });
                                  },
                                );
                              })
                        ],
                      ),
                    ))
                .toList()),
      ),
    ));
  }
}

class Percentages {
  String prcnt_text;
  bool selected_prcnt;
  Percentages(this.prcnt_text, this.selected_prcnt);
}
