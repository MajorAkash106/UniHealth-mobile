import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/config/widgets/schedule_next_evaluation.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NRSHistory.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalScreenModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NutritionalScreenController extends GetxController {
  var listData = List<NutritionalScreenListData>().obs;

  void getData(String type) async {
    print(';llll');

    try {
      var data = await getJson(type);
      print('data from json file: ${json.decode(data)}');
      NutritionalScreenModel model =
          NutritionalScreenModel.fromJson(json.decode(data));
      print(model.success);
      print(model.message);
      if (model.success == true) {
        listData.clear();
        print(model.data);
        listData.addAll(model.data);
      } else {
        ShowMsg(model.message);
      }
    } catch (e) {
      print(e);
      ServerError();
    }
  }

  var historyData = List<NRSHistoryData>().obs;

  void getHistoryData(String patientId, String type) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": type,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        NRSHistory model = NRSHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          historyData.clear();
          print(model.data);
          historyData.addAll(model.data.reversed);

          historyData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }

  int selctedradio = -1;

  Future<String> dietaryIntake(PatientDetailsData patientDetailsData, context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              contentPadding: EdgeInsets.only(top: 10.0),
              content: Container(
                width: Get.width / 1.1,
                padding:
                    EdgeInsets.only(top: 0, bottom: 20, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                        child: Text(
                      'dietary intake'.toUpperCase(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                    Divider(),
                    ListTile(
                      leading: selctedradio == 0
                          ? Icon(
                              Icons.radio_button_checked,
                              color: primary_color,
                            )
                          : Icon(Icons.radio_button_off),
                      title: Text(
                        'adequate'.toUpperCase(),
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selctedradio = 0;
                        });
                      },
                    ),
                    ListTile(
                      leading: selctedradio == 1
                          ? Icon(
                              Icons.radio_button_checked,
                              color: primary_color,
                            )
                          : Icon(Icons.radio_button_off),
                      title: Text(
                        'inadequate'.toUpperCase(),
                        style: new TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          selctedradio = 1;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            flex: 1,
                            child: CustomButton(
                                text: '  Skip  ',
                                myFunc: () {
                                  Get.back();
                                })),
                        Flexible(
                            flex: 1,
                            child: CustomButton(
                                text: '    Confirm    ',
                                myFunc: () async {
                                  print(selctedradio);

                                  if (selctedradio == 0) {
                                    print('adequate');
                                    Get.back();

                                    // await  schduledate(patientDetailsData, 'empty');

                                    DateTime date = DateTime.now();
                                    var after7days =
                                        date.add(Duration(days: 7));
                                    print(after7days);
                                    // await schduleNext(patientDetailsData,
                                    //     context, after7days);

                                    schduleNextFunc(patientDetailsData, context,
                                        after7days);
                                  } else {
                                    Get.back();
                                    print('inadequate');
                                    // ShowMsgFor10sec(
                                    //     'clinical concern – follow local policy, set goals, improve and increase overall nutritional intake, monitor and review care plan regularly');
                                    showRiskPopup(context, 1, () async {
                                      Get.back();
                                    });
                                  }
                                  //
                                  // else {
                                  //
                                  //   if(selctedradio!=-1){
                                  //     Get.back();
                                  //     await DeadDischarge(
                                  //         patientDetailsData, selctedradio).then((
                                  //         value) {
                                  //       return 'success';
                                  //     });
                                  //   }
                                  //
                                  // }
                                })),
                      ],
                    ),
                    // SizedBox(height: 10,),
                  ],
                ),
              ),
            );
          });
        });
  }

  //--------------------------------------------------------------------------------

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _range =
          DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
              ' - ' +
              DateFormat('yyyy-MM-dd')
                  .format(args.value.endDate ?? args.value.startDate)
                  .toString();
    } else if (args.value is DateTime) {
      _selectedDate = args.value.toString();
      print("selected date: $_selectedDate");
      print(
          "selected date format: ${dateFormat.format(DateTime.parse(_selectedDate))}");
      _selectedDate = '${dateFormat.format(DateTime.parse(_selectedDate))}';
    } else if (args.value is List<DateTime>) {
      _dateCount = args.value.length.toString();
    } else {
      _rangeCount = args.value.length.toString();
    }
  }

  Future<bool> willpopScope() {
    Get.back();
  }

  schduleNextFunc(
    PatientDetailsData patientDetailsData,
    context,
    DateTime _date,
  ) async {
    print("schduledate: ${patientDetailsData.scheduleDate}");

    _selectedDate = null;
    Get.dialog(WillPopScope(
        child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              height: Get.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Center(
                          child: Text(
                        'Schedule Next Evaluation',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                      Divider(),
                      Container(
                        height: Get.height / 3,
                        width: Get.width,
                        child: SfDateRangePicker(
                            showNavigationArrow: true,
                            // initialDisplayDate: DateTime.now(),
                            // monthFormat: "yyyy-MM-dd",
                            view: DateRangePickerView.month,
                            enablePastDates: false,
                            initialDisplayDate: _date,
                            initialSelectedDate: _date,
                            onSelectionChanged: _onSelectionChanged),
                      ),
                    ],
                  ),
                  Container(
                    width: Get.width,
                    child: CustomButton(
                      text: '    Confirm    ',
                      myFunc: () {
                        Get.back();

                        print(_selectedDate);

                        if (_selectedDate != null) {
                          print('changed selected date');

                          // onpress(patientDetailsData, selectedList, count, status, _selectedDate);
                          saveDataAdequate(patientDetailsData, _selectedDate);
                        } else {
                          _selectedDate = dateFormat.format(_date);
                          print(_selectedDate);

                          print('suggested date selected');

                          saveDataAdequate(patientDetailsData, _selectedDate);

                          // onpress(patientDetailsData, selectedList, count, status, _selectedDate);

                        }
                        // Get.to(BedsScreen());
                      },
                    ),
                  )
                ],
              ),
            )),
        onWillPop: willpopScope));
  }

  //--------------------------------------------------------------------------------

  Future<String> saveDataAdequate(
      PatientDetailsData patientDetailsData, String _date) async {
    DateTime date = DateTime.now();
    var after7days = date.add(Duration(days: 7));
    print(after7days);

    StatusData MUSTData;

    for (var a = 0; a < patientDetailsData.status.length; a++) {
      var data = patientDetailsData.status[a];

      if (data.type == '0' && data.status.trim() == 'MUST'.trim()) {
        print('next schduleDate: ${data.result[0].nextSchdule}');
        MUSTData = data;

        break;
      }
    }

    print(jsonEncode(MUSTData.result[0]));
    print(MUSTData.status);
    print(MUSTData.score);
    print(MUSTData.type);
    // print(MUSTData.userId);

    MUSTData.result[0].nextSchdule = _date;

    try {
      // Get.dialog(Loader(), barrierDismissible: false);

      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': patientDetailsData.sId,
        "type": MUSTData.type,
        "status": MUSTData.status,
        'score': MUSTData.score,
        'result': jsonEncode(MUSTData.result),
      });

      print(request.body);
      print(APIUrls.PostStatus);
      // data.hospital[0].observation = text;
      await request.post().then((value) {
        CommonResponse commonResponse =
            CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        // Get.back();
        if (commonResponse.success) {
          print('control here');
          Get.offAll(Step1HospitalizationScreen(
            patientUserId: patientDetailsData.sId,
            index: 2,
          ));

          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print(e);
      // Get.back();
      // ServerError();
    }

    return "success";
  }
}
