import 'package:age/age.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/error_widget.dart';

import 'package:medical_app/contollers/patient&hospital_controller/bedController.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/patients&hospitals/hospitals.dart';
import 'package:medical_app/screens/patient_dashboard/scheduled_for_today.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/screens/home/patients&hospitals/patients_list.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BedsScreen extends StatefulWidget {
  final bool fromDischargeDead;
  final bool isfromWard;
  final String wardId;
  final String hospName;
  final String hospId;
  final String patientIdForFocus;
  final List<WardData> wardData;
  final List<BedsData> bedsData;

  BedsScreen(
      {this.fromDischargeDead,
      this.patientIdForFocus,
      this.wardId,
      this.hospId,
      this.hospName,
      this.wardData,
      this.bedsData,
      this.isfromWard});

  @override
  _BedsScreenState createState() => _BedsScreenState();
}

class _BedsScreenState extends State<BedsScreen> {
  final BedsController _controller = BedsController();
  final OfflineHandler _offlineHandler = OfflineHandler();

  List<BedsData> _bedsList = [];

  @override
  void initState() {
    print('aaaa');
    print(widget.wardData.toString());
    // TODO: implement initState

    print("controller close: ${_controller.isClosed}");
    adLog('widget.wardId  ${widget.wardId}');

    setState(() {
      _value = widget.wardId;
      _bedsList = widget.bedsData;
      wardData.addAll(widget.wardData);
    });
    // checkConnectivityWihtoutMsg().then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     Future.delayed(const Duration(milliseconds: 100), () {
    //       _controller.getBedData(widget.wardId);
    //     });
    //
    //     print('internet avialable');
    //   } else {
    //     _controller.getFromSqflite(widget.wardId);
    //   }
    // });
    getFilter();
    Future.delayed(const Duration(seconds: 1), () {
      changeState();
    });
    super.initState();
  }

  changeState() {
    setState(() {});
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });

    // if (widget.patientIdForFocus != null && widget.patientIdForFocus != "") {
    //   _scrollDown();
    // }
  }

  List<WardData> wardData = [];

  getFilter() async {
    for (var a in widget.wardData) {
      await _offlineHandler.getFilterStatus(a.sId).then((value) {
        if (!value) {
          wardData.remove(a);
        }
      });
    }
  }

  SaveDataSqflite sqflite = SaveDataSqflite();

  @override
  void dispose() {
    _controller.onClose();
    // _controller.isClosed;
    _controller.dispose();
    super.dispose();
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  void _scrollDown() {
    print('scroll fun called');

    if (widget.isfromWard != null) {
      if (widget.isfromWard) {
        // Get.back();
      } else {
        print("widget.patientIdForFocus :: ${widget.patientIdForFocus}");
        getPatientAndJump();

        // Get.to(HospitalScreen());
      }
    } else {
      print("widget.patientIdForFocus :: ${widget.patientIdForFocus}");
      // Get.to(HospitalScreen());
      getPatientAndJump();
    }
  }

  getPatientAndJump() {
    int index = 0;
    for (var a in _bedsList) {
      if ((a.patientId != null) &&
          (a.patientId.sId.toString() == widget.patientIdForFocus)) {
        index = _bedsList.indexOf(a);
        print('index of focused patient:: $index');
        // _itemScrollController.jumpTo(index: index);
        _firstController
            .jumpTo(double.parse(index.toString()) * (Get.height / 1.1));
        break;
      }
    }
  }

  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _WillPopScope,
      child: Scaffold(
        bottomNavigationBar: CommonHomeButton(),
        appBar: AppBar(
          title: Text(
            "${widget.hospName}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.white),
          ),
          centerTitle: true,
          // leading: InkWell(child: Icon(Icons.keyboard_backspace,color: Colors.white,),onTap: (){ Navigator.of(context).pop();},),
          backgroundColor: primary_color,
          elevation: 0.0,
          //bottom:  PreferredSize(child: Container(height: 1.5,width: MediaQuery.of(context).size.width,color: Colors.grey,)),
        ),
        body: ErrorHandler(
          visibility: widget.bedsData.isNullOrBlank,
          child: Column(
            children: [
              Container(
                color: primary_color,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, left: 40.0, right: 40.0, bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    height: 40.0,
                    width: MediaQuery.of(context).size.width,
                    child:
                        //Container(child: Center(child: _value==0?,),),
                        Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0),
                            iconEnabledColor: Colors.black,
                            // isExpanded: true,
                            iconSize: 30.0,
                            dropdownColor: Colors.white,
                            // hint: Text(_value),

                            value: _value,
                            items: wardData
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text('${e.wardname}'),
                                    value: '${e.sId}',
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              _value = value;
                              var selecteddata = widget.wardData.firstWhere(
                                  (element) => element.sId == value);

                              // _bedsList.clear();
                              _bedsList = selecteddata.beds;
                              setState(() {});

                              // if (value == _value) {
                              // } else {
                              //   setState(() {

                              //     print(_value);
                              //
                              //     checkConnectivityWihtoutMsg().then((internet) {
                              //       print('internet');
                              //       if (internet != null && internet) {
                              //         Future.delayed(
                              //             const Duration(milliseconds: 100), () {
                              //           _controller.getBedData(_value);
                              //         });
                              //
                              //         print('internet avialable');
                              //       } else {
                              //         _controller.getFromSqflite(_value);
                              //       }
                              //     });
                              //
                              //     // _controller.getBedData(_value);
                              //   });
                              // }
                            }),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Center(
                  child: Text(
                    "beds".tr,
                    style: TextStyle(color: appbar_icon_color, fontSize: 18),
                  ),
                ),
              ),
              Expanded(
                child: DraggableScrollbar.arrows(
                    controller: _firstController,
                    backgroundColor: greenTxt_color,
                    alwaysVisibleScrollThumb: true,
                    heightScrollThumb: 48.0,
                    child: ListView.builder(
                      // shrinkWrap: true,
                      // itemExtent: double.parse(_bedsList.length.toString())*3.6,
                      itemExtent: 136.8,
                      controller: _firstController,
                      itemCount: _bedsList.length,
                      itemBuilder: (context, index) {
                        return new FutureBuilder(
                            initialData: false,
                            future: _offlineHandler.getFilterStatus(
                                _bedsList[index]?.patientId?.medicalId),
                            builder: (context, snapshot) {
                              return !snapshot.data
                                  ? SizedBox()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 18),
                                      child: _mainWidget(index));
                            });
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainWidget(int index) {
   if( _bedsList[index].patientId?.discharge == true || _bedsList[index].patientId?.died == true){
     _bedsList[index].patientId = null;
   }

    return _bedsWidget(
        "${_bedsList[index].bedNumber}",
        "${_bedsList[index].patientId?.name ?? 'no_patient_available'.tr}",

        // DateTime.tryParse(_bedsList[index].patientId?.scheduleDate??"1997-06-10").difference(DateTime.now()).inDays.isEqual(0)?
        true,
        // :false,
        '${_bedsList[index].patientId?.scheduleDate ?? ""}',
        _bedsList[index].patientId?.sId ?? null,
        index);
  }

  Future<bool> _WillPopScope() {
    if (widget.isfromWard != null) {
      if (widget.isfromWard) {
        Get.back();
      } else {
        Get.to(HospitalScreen());
      }
    } else {
      Get.to(HospitalScreen());
    }
  }

  String _value = '';

  PatientDetailsData pdataI;

  Widget _bedsWidget(bed_no, patients_name, bool warning, String scheduleDate,
      String id, int index) {
    return InkWell(
      onTap: () async {
        print(id);
        if (id != null) {
          SaveDataSqflite sqflite = SaveDataSqflite();
          int lastIndex = 0;
          int statuslastIndex = 0;
          await sqflite.getLastBadge(id).then((res) {
            lastIndex = res?.lastIndex ?? 0;
            statuslastIndex = res?.statusIndex ?? 0;
            print('getting last index ${lastIndex ?? 0}');
          });

          await checkConnectivityWihtoutMsg().then((internet) {
            print('internet');
            if (internet != null && internet) {
              print('getting last index on navigation ${lastIndex ?? 0}');
              Get.to(Step1HospitalizationScreen(
                patientUserId: id,
                index: lastIndex ?? 0,
                statusIndex: statuslastIndex ?? 0,
              ));
              print('internet avialable');
            } else {
              final OfflineHandler _offlineHandler = OfflineHandler();
              _offlineHandler.getPatientData(id).then((value) {
                if (value != null) {
                  Get.to(Step1HospitalizationScreen(
                    patientUserId: id,
                    index: lastIndex ?? 0,
                    statusIndex: statuslastIndex ?? 0,
                  ));
                } else {
                  ShowMsg('please try again with internet conncetion.');
                }
              });
            }
          });
        } else {
          Get.to(PatientListScreen(
            hospId: widget.hospId,
            wardId: _value,
            bedId: _bedsList[index].sId,
          ));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            side: BorderSide(width: 2, color: primary_color)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'bed_no'.tr + " - $bed_no",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                  ),

                  FutureBuilder(
                      future: sqflite.getData(id),
                      initialData: pdataI,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        PatientDetailsData pdata = snapshot?.data;
                        scheduleDate = pdata?.scheduleDate ?? "";
                        print('pdata: ${pdata?.scheduleDate}');

                        return scheduleDate == null
                            ? SizedBox()
                            : _calender_infoWidget(
                                scheduleDate == ""
                                    ? false
                                    : scheduleDate == 'empty'
                                        ? false
                                        : DateTime.parse(scheduleDate)
                                            .compareTo(DateTime.now())
                                            .isNegative,
                                scheduleDate,
                                id,
                                index);
                      })

                  // infoCalender(id: id,schduledate: scheduleDate,)
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Patient_name'.tr + " - $patients_name",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                      // overflow: TextOverflow.ellipsis,maxLines: 1,
                    ),
                  )

                  // SvgPicture.asset(AppImages.deleteIcon,color: primary_color,height: 20,),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                      future: sqflite.getData(id),
                      initialData: pdataI,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        PatientDetailsData pdata = snapshot?.data;
                        scheduleDate = pdata?.scheduleDate ?? '';
                        print('pdata: ${pdata?.scheduleDate}');

                        return scheduleDate == null
                            ? SizedBox()
                            : Expanded(
                                child: Text(
                                  // "Next Schedule - ${dateFormat.format(DateTime.parse(scheduleDate))}",
                                  'next_schedule'.tr +
                                      " - ${scheduleDate == "" || scheduleDate == "empty" ? id == null ? "" : "follow_up_stopped".tr : scheduleDate}",
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14),
                                ),
                              );
                      }),
                  id != null
                      ? InkWell(
                          onTap: () {
                            // print(scheduleDate);
                            // print('selected date: ${DateTime.parse(scheduleDate)
                            //     .difference(DateTime.now())
                            //     .inDays}');
                            // print('selected date: ${DateTime.parse(scheduleDate)
                            //     .compareTo(DateTime.now()).isNegative}');
                            // // print('days count ${DateTime.parse(scheduleDate).difference(DateTime.now()).inDays}');

                            print(id);

                            checkConnectivity().then((internet) {
                              print('internet');
                              if (internet != null && internet) {
                                _controller
                                    .deleteBed(id, context, widget.wardId)
                                    .then((value) {});

                                print('internet avialable');
                              }
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 25,
                            child: Center(
                              child: SvgPicture.asset(
                                AppImages.deleteIcon,
                                color: primary_color,
                                height: 20,
                              ),
                            ),
                          ))
                      : SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _delete() {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    new Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  Widget _calender_infoWidget(
      bool warning, String schduledate, String patientId, int index) {
    if (warning) {
      return Row(
        children: [
          DateTime.parse(schduledate).difference(DateTime.now()).inDays == 0
              ? Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.red,
                )
              : SizedBox(),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () async {
                print(patientId);
                if (patientId != null) print(_bedsList[index].patientId?.dob);
                String dob = _bedsList[index].patientId?.dob;

                DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                var currentdate = dateFormat.format(DateTime.now());
                print("currentdate : $currentdate");
                print(dob);

                DateTime today = DateTime.now(); //2020/1/24
                AgeDuration age;
                // Find out your age
                age = Age.dateDifference(
                    fromDate: DateTime.parse(dob),
                    toDate: today,
                    includeToDate: false);

                print('Your age is $age');
                var actuala_age;
                if (age.years < 19) {
                  actuala_age =
                      "${age.years} years, ${age.months} ${age.months > 1 ? "months" : 'month'}";
                } else {
                  actuala_age =
                      "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}";
                }

                SaveDataSqflite Sqflite = SaveDataSqflite();
                await sqflite.getData(patientId).then((value) {
                  Get.to(ScheduledForToday(
                    patientId: patientId,
                    isFromSlip: false,
                    hospName: widget.hospName,
                    age: actuala_age,
                    patient_Name: _bedsList[index].patientId?.name,
                    patientDetailsData: value,
                  ));
                });
              },
              child: Container(
                height: 25,
                width: 50,
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.calandar_blak,
                    color: primary_color,
                    height: 20,
                  ),
                ),
              )),
        ],
      );
    } else {
      return InkWell(
          onTap: () async {
            print(patientId);
            if (patientId != null)
              // _bedsList[index].patientId?.sId

              print(_bedsList[index].patientId?.dob);
            String dob = _bedsList[index].patientId?.dob;

            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
            var currentdate = dateFormat.format(DateTime.now());
            print("currentdate : $currentdate");
            print(dob);

            DateTime today = DateTime.now(); //2020/1/24
            AgeDuration age;
            // Find out your age
            age = Age.dateDifference(
                fromDate: DateTime.parse(dob),
                toDate: today,
                includeToDate: false);

            print('Your age is $age');
            var actuala_age;
            if (age.years < 19) {
              actuala_age =
                  "${age.years} years, ${age.months} ${age.months > 1 ? "months" : 'month'}";
            } else {
              actuala_age =
                  "${age == null ? '________' : age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}";
            }

            SaveDataSqflite Sqflite = SaveDataSqflite();
            await sqflite.getData(patientId).then((value) {
              Get.to(ScheduledForToday(
                patientId: patientId,
                isFromSlip: false,
                hospName: widget.hospName,
                age: actuala_age,
                patient_Name: _bedsList[index].patientId?.name,
                patientDetailsData: value,
              ));
            });
          },
          child: Container(
            height: 25,
            width: 50,
            child: Center(
              child: SvgPicture.asset(
                AppImages.calandar_blak,
                color: primary_color,
                height: 20,
              ),
            ),
          ));
    }
  }
}
