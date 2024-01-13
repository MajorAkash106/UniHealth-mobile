import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/error_widget.dart';
import 'package:medical_app/contollers/patient&hospital_controller/WardListController.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/screens/home/patients&hospitals/beds.dart';

import 'package:medical_app/screens/home/patients&hospitals/wards_filter.dart';

class WardScreen extends StatefulWidget {
  final String id;
  final String hospName;
  final String hospId;

  WardScreen({this.id, this.hospName, this.hospId});

  @override
  _WardScreenState createState() => _WardScreenState();
}

class _WardScreenState extends State<WardScreen> {
  final WardListController _controller = WardListController();
  final OfflineHandler _offlineHandler = OfflineHandler();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivityWithToggle(widget.hospId).then((internet) {
      print('internet');
      print(widget.id);
      if (internet != null && internet) {
        _controller.getWardData(widget.id);
        print('internet avialable');
      } else {
        _controller.getFromSqflite(widget.id);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          "wards".tr,
          // null
          IconButton(
              icon: SvgPicture.asset(
                AppImages.filterImageSvg,
                color: card_color,
              ),
              onPressed: () {
                Get.to(WardFilter(
                  hospiId: widget.hospId,
                )).then((value) {
                  setState(() {});
                });
              })),
      bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(()=> ErrorHandler(
          visibility: _controller.isError.value,
          child: Container(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "${widget.hospName}",
                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Obx(() =>
                    Expanded(
                      child: ListView.builder(
                        itemCount: _controller.wardListdata.length,
                        itemBuilder: (context, index) => _wardwidget(
                            '${_controller.wardListdata[index].wardname}',
                            "${_controller.wardListdata[index].bedsCount}",
                            '${_controller.wardListdata[index].sId}',
                            "${_controller.wardListdata[index].activeBeds}",
                            "${_controller.wardListdata[index].todayschedule}",
                            _controller.wardListdata[index]),
                      ),
                    ))
              ],
            ),
          ),
        ),)
      ),
    );
  }

  Widget _wardwidget(wardName, count, wardId, total_Patients, today_Schedule,
      WardData wardData) {
    return FutureBuilder(
        initialData: false,
        future: _offlineHandler.getFilterStatus(wardId ?? null),
        builder: (context, snapshot) {
          return !snapshot.data
              ? SizedBox()
              : InkWell(
                  onTap: () {
                    print(wardId);
                    Get.to(BedsScreen(
                      wardId: wardId,
                      wardData: _controller.wardListdata,
                      hospName: widget.hospName,
                      hospId: widget.hospId,
                      isfromWard: true,
                      bedsData: wardData.beds,
                    ));
                  },
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          side: BorderSide(width: 2, color: primary_color)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "$wardName",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'total_bed'.tr,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CircleAvatar(
                                        maxRadius: 12.0,
                                        child: Text(
                                          "$count",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'active_bed'.tr,
                                      style: TextStyle(fontSize: 13.0),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CircleAvatar(
                                        maxRadius: 12.0,
                                        child: Text(
                                          "$total_Patients",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "today_schedule".tr,
                                      style: TextStyle(
                                          fontSize: 13.0,color: int.parse('$today_Schedule') > 0
                                          ? Colors.red
                                          : Colors.black,
                                          fontWeight:
                                              int.parse('$today_Schedule') > 0
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CircleAvatar(
                                        maxRadius: 12.0,
                                        child: Text(
                                          today_Schedule == null
                                              ? ''
                                              : today_Schedule.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.0),
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        )),
                      )),
                  //),
                );
        });
  }
}
