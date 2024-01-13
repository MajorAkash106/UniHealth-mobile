import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/WardListController.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/home/patients&hospitals/beds.dart';

import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Locale/locale_config.dart';

// String selectdate;


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
    print("selected date format: ${dateFormat.format(DateTime.parse(_selectedDate))}");
     _selectedDate = '${dateFormat.format(DateTime.parse(_selectedDate))}';
  } else if (args.value is List<DateTime>) {
    _dateCount = args.value.length.toString();
  } else {
    _rangeCount = args.value.length.toString();
  }
}

next_evaluation(List<PatientDetailsData> patientDetailsData,context) async{
  print("schduledate: ${patientDetailsData[0].scheduleDate.isEmpty?'em':'notem'}");
  _selectedDate = patientDetailsData[0].scheduleDate=="empty"||patientDetailsData[0].scheduleDate.isEmpty?"${dateFormat.format(DateTime.parse('${DateTime.now()}'))}":patientDetailsData[0].scheduleDate;
  print(_selectedDate);

  Locale locale = await LocaleConfig().getLocale();

  Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: Get.height / 1.8,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text(
              'schedule_next_evaluation'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Divider(),
            Container(
              height: Get.height / 3,
              width: Get.width,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                supportedLocales: [
                  Locale('en' 'US'),
                  Locale('pt', 'BR'),
                ],
                locale: locale,
                home: SfDateRangePicker(
                  showNavigationArrow: true,
                 // initialDisplayDate: DateTime.now(),
                 //  monthFormat: "yyyy-MM-dd",
                    view: DateRangePickerView.month,
                    enablePastDates: false,
                    initialSelectedDate: DateTime.parse(patientDetailsData[0].scheduleDate!=""?
                    patientDetailsData[0].scheduleDate!="empty"?
                    patientDetailsData[0].scheduleDate
                        :"${dateFormat.format(DateTime.parse('${DateTime.now()}'))}"
                    :"${dateFormat.format(DateTime.parse('${DateTime.now()}'))}"),
                 onSelectionChanged: _onSelectionChanged
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 1,
                    child: CustomButton(
                      text: '  ${'skip'.tr}  ',
                      myFunc: () {
                        Get.back();
                        opendialog(patientDetailsData[0], context);
                      },
                    )),
                Flexible(
                    flex: 1,
                    child: CustomButton(
                      text: '${'confirm'.tr}',
                      myFunc: () {
                        // Get.back();
                        print(_selectedDate);
                        print('raman');
                        if(_selectedDate !=null){
                          Get.back();



                          checkConnectivityWithToggle(patientDetailsData[0].hospital[0].sId).then((value){
                            if(value!=null && value){
                              schduledate(patientDetailsData[0], _selectedDate);
                            }else{
                              schduledOffline(patientDetailsData[0], _selectedDate);
                            }
                          });

                        }else{

                          _selectedDate = patientDetailsData[0].scheduleDate;
                          Get.back();

                          checkConnectivityWithToggle(patientDetailsData[0].hospital[0].sId).then((value){

                            if(value!=null && value){
                              schduledate(patientDetailsData[0], _selectedDate);
                            }else{
                              schduledOffline(patientDetailsData[0], _selectedDate);
                            }

                          });


                          // ShowMsg('Please choose a date');
                        }
                        // Get.to(BedsScreen());
                      },
                    )),
              ],
            )
          ],
        ),
      )));
}



schduledOffline(PatientDetailsData data, _selectedDate)async{

  SaveDataSqflite sqflite = SaveDataSqflite();

  data.scheduleDate = _selectedDate;

 await sqflite.saveData(data);

  WardListController wardListController = WardListController();
  wardListController.getFromSqflite(data.hospital[0].sId).then((value){

    var selectedData = wardListController.wardListdata.firstWhere((element) => element.sId == data.wardId.sId);

    Get.to(BedsScreen(patientIdForFocus: data.sId,wardId: data.wardId.sId,wardData: wardListController.wardListdata,hospName: data.hospital[0].name,bedsData: selectedData.beds,hospId: data.hospital[0].sId,));


  });

}



int _radioValue = 0;

void _handleRadioValueChange(int value) {

  _radioValue = value;

  switch (_radioValue) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      break;
  }
  Get.back();
  whyskipdialog("${'why_are_you_skipping'.tr}", () {
    Get.back();
    // Get.to(BedsScreen());
  }, ()async {
    Get.back();
    print('discharge here or dead here');
    print(_radioValue);
    // await DeadDischarge(patientDetailsData[0], _radioValue);
    // Get.to(BedsScreen());
  });
}

whyskipdialog(text, Function _skip, Function _confirm,) {
  Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: Get.height / 3,
        width: Get.width / 1.1,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text(
              '$text',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Divider(),
            // Row(
            //   children: [
            //     new Radio(
            //       value: 0,
            //       groupValue: _radioValue,
            //       onChanged: _handleRadioValueChange,
            //     ),
            //     new Text(
            //       'Not Followed',
            //       style: new TextStyle(fontSize: 16.0),
            //     ),
            //   ],
            // ),
            Row(
              children: [
                new Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (int val){
                    _radioValue = val;

                    switch (_radioValue) {
                      case 0:
                        break;
                      case 1:
                        break;
                      case 2:
                        break;
                    }
                    Get.back();
                    whyskipdialog("why_are_you_skipping".tr, () {
                      Get.back();
                      // Get.to(BedsScreen());
                    }, ()async {
                      Get.back();
                      print('discharge here or dead here');
                      print(_radioValue);
                      // await DeadDischarge(patientDetailsData[0], _radioValue);
                      // Get.to(BedsScreen());
                    });
                  },
                ),
                new Text(
                  'discharged'.tr,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                new Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: _handleRadioValueChange,
                ),
                new Text(
                  'dead'.tr,
                  style: new TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 1,
                    child: CustomButton(
                      text: '  ${'skip'.tr}  ',
                      myFunc:_skip
                    )),
                Flexible(
                    flex: 1,
                    child: CustomButton(
                      text: '    ${'confirm'.tr}    ',
                      myFunc: _confirm
                    )),
              ],
            )
          ],
        ),
      )));
}


int selctedradio = -1;

Future<String> opendialog(PatientDetailsData patientDetailsData,context) {
  final WardListController _ward_controller = WardListController();
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) { return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: Get.width/1.1,
            padding: EdgeInsets.only(top: 0,bottom: 20,left: 16,right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                    child: Text(
                      'why_are_you_skipping'.tr,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                Divider(),
                ListTile(leading:selctedradio==0?Icon(Icons.radio_button_checked,color: primary_color,)
                    :Icon(Icons.radio_button_off),title: Text(
                  'discharged'.tr,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                onTap: (){
                  setState(() {
                    selctedradio = 0;
                  });
                },
                ),
                ListTile(leading:selctedradio==1?Icon(Icons.radio_button_checked,color: primary_color,)
                :Icon(Icons.radio_button_off),title: Text(
                  'dead'.tr,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),  onTap: (){
                  setState(() {
                    selctedradio = 1;
                  });
                },),
                ListTile(leading:selctedradio==2?Icon(Icons.radio_button_checked,color: primary_color,)
                    :Icon(Icons.radio_button_off),title: Text(
                  'follow_up_stopped'.tr,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),  onTap: (){
                  setState(() {
                    selctedradio = 2;
                  });
                },),
                ListTile(leading:selctedradio==3?Icon(Icons.radio_button_checked,color: primary_color,)
                    :Icon(Icons.radio_button_off),title: Text(
                  'not_listed'.tr,
                  style: new TextStyle(
                    fontSize: 16.0,
                  ),
                ),  onTap: (){
                  setState(() {
                    selctedradio = 3;
                  });
                },),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                        flex: 1,
                        child: CustomButton(
                            text: '  ${'back'.tr}  ',
                            myFunc: (){

                              Get.back();

                            }
                        )),
                    Flexible(
                        flex: 1,
                        child: CustomButton(
                            text: '    ${'confirm'.tr}    ',
                            myFunc: ()async{

                              if(selctedradio==2 ){
                                print('follow-up stopped');
                                Get.back();

                               await checkConnectivityWithToggle(patientDetailsData.hospital[0].sId).then((internet){
                                  if(internet!=null && internet){
                                      schduledate(patientDetailsData, 'empty');
                                  }else{
                                    schduledOffline(patientDetailsData, 'empty');
                                  }
                                });


                              }
                              else if(selctedradio==3){
                                print('not listed was selected');

                                 Get.back();
                                // Get.back();
                                not_listed(patientDetailsData);

                                // Get.to(BedsScreen(wardId: patientDetailsData.wardId.sId,wardData: _ward_controller.wardListdata,hospName: patientDetailsData.hospital[0].name,
                                //   fromDischargeDead: false,
                                // ));

                                // selctedradio = -1;



                              }

                              else {

                               if(selctedradio!=-1){

                                 print(selctedradio);

                                 Get.back();

                                 await checkConnectivityWithToggle(patientDetailsData.hospital[0].sId).then((internet){
                                   if(internet !=null && internet){
                                      DeadDischarge(
                                         patientDetailsData, selctedradio).then((
                                         value) {
                                       return 'success';
                                     });
                                   }else{
                                     ShowMsgFor10sec('cannot_discharge_or_dead_in_offline_mode'.tr);
                                   }
                                 });

                               }


                              }
                              selctedradio = -1;
                            }
                        )),
                  ],
                ),
                // SizedBox(height: 10,),
              ],
            ),
          ),
        );});
      });
}



Future<String> DeadDischarge(PatientDetailsData data,int selectRadio) async {
  Get.dialog(Loader(),
      barrierDismissible: false);
  print('get selected: $selectRadio');
  try {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    print('userId: $userid');
    print(APIUrls.editProfile);

    Request request = Request(url: APIUrls.editProfile, body: {

      'city': data.city,
      'state': data.state,
      'userId': data.sId,
      'discharge': selectRadio==0?jsonEncode(true):jsonEncode(false),
      'died': selectRadio==1?jsonEncode(true):jsonEncode(false),

    });

    print(request.body);
    await request.post().then((value) {
      CommonResponse commonResponse =
      CommonResponse.fromJson(json.decode(value.body));
      print(commonResponse.success);
      print(commonResponse.message);
      Get.back();
      if(commonResponse.success==true){

        //clear data from local
        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.clearData(data.sId);
        sqflite.clearPatientId(data.sId);


        getWardData(data.hospital[0].sId,data.wardId.sId,data.hospital[0].name,true);
        // Get.to(HomeScreen());
        // Get.back();
        // print(commonResponse.data);
        // patientDetailsData.add(patientDetails.data);
      }else{
        ShowMsg(commonResponse.message);
      }


    });

  }catch(e){
    Get.back();
    print(e);
    // ServerError();
  }

  return "success";

}

Future<String> schduledate(PatientDetailsData data,String scheduleDate) async {
  Get.dialog(Loader(),
      barrierDismissible: false);
  try {
    var userid =
    await MySharedPreferences.instance.getStringValue(Session.userid);
    print('userId: $userid');
    print(APIUrls.editProfile);

    Request request = Request(url: APIUrls.editProfile, body: {
      'city': data.city,
      'state': data.state,
      'userId': data.sId,
      'scheduleDate': scheduleDate,
    });

    print(request.body);
    await request.post().then((value) {
      CommonResponse commonResponse =
      CommonResponse.fromJson(json.decode(value.body));
      print(commonResponse.success);
      print(commonResponse.message);
      Get.back();
      if(commonResponse.success==true){
        print("hosp id: ${data.hospital[0].sId}");
        print("ward id: ${data.wardId.sId}");
        print("hosp name: ${data.hospital[0].name}");

        //because on bed screen schdule data showing from local show update with local
        data.scheduleDate = scheduleDate;
        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.savePatientDetails(data);

        getWardData(data.hospital[0].sId,data.wardId.sId,data.hospital[0].name,false);

      }else{
        ShowMsg(commonResponse.message);
      }


    });

  }catch(e){
    Get.back();
    print(e);
    // ServerError();
  }

  return "success";

}

Future<String> getWardData(String id,String wardId,String hospName,bool dischargeDead) async {
final  HospitalSqflite sqflite =  HospitalSqflite();
  print(APIUrls.getWardList);
  showLoader();
  try {

    Request request = Request(url: APIUrls.getWardList, body: {
      'hospitalId': id,
      'type': '0',
    });

    await request.post().then((value) {
      WardList wardList = WardList.fromJson(json.decode(value.body));

      //save to sqlite
      sqflite.saveWard(wardList, id);
      saveAllPatients(wardList.patients);

      print(wardList.success);
      print(wardList.message);
      Get.back();
      if(wardList.success == true){

        print(wardList.data);
        wardList.data.sort((a, b) {
          return a.wardname
              .toString()
              .toLowerCase()
              .compareTo(b.wardname.toString().toLowerCase());
        });

        var selectedData = wardList.data.firstWhere((element) => element.sId == wardId);
        print('---------scope here-------------');
        // Get.back();
        Get.to(BedsScreen(wardId: wardId,wardData: wardList.data,hospName: hospName,fromDischargeDead: dischargeDead,bedsData: selectedData.beds,hospId: id,));

      }else{
        ShowMsg(wardList.message);
      }


    });

  }catch(e){
    // Get.back();
    // ServerError();
  }

}

Future<String> getWardData2(String id,String wardId,String hospName,bool dischargeDead) async {
  final  HospitalSqflite sqflite =  HospitalSqflite();
  print(APIUrls.getWardList);
  showLoader();
  try {

    Request request = Request(url: APIUrls.getWardList, body: {
      'hospitalId': id,
      'type': '0',
    });

    await request.post().then((value) {
      WardList wardList = WardList.fromJson(json.decode(value.body));

      //save to sqlite
      sqflite.saveWard(wardList, id);
      saveAllPatients(wardList.patients);

      print(wardList.success);
      print(wardList.message);
      Get.back();
      if(wardList.success == true){

        print(wardList.data);
        wardList.data.sort((a, b) {
          return a.wardname
              .toString()
              .toLowerCase()
              .compareTo(b.wardname.toString().toLowerCase());
        });

        var selectedData = wardList.data.firstWhere((element) => element.sId == wardId);
        print('---------scope here-------------');
        Get.back();
        Get.to(BedsScreen(wardId: wardId,wardData: wardList.data,hospName: hospName,fromDischargeDead: dischargeDead,bedsData: selectedData.beds,hospId: id,));

      }else{
        ShowMsg(wardList.message);
      }


    });

  }catch(e){
    // Get.back();
    // ServerError();
  }

}

void not_listed(PatientDetailsData data){

  checkConnectivityWithToggle(data.hospital[0].sId).then((internet) {
    print('internet');
    if (internet != null && internet) {
      getWardData(data.hospital[0].sId,data.wardId.sId,data.hospital[0].name,false,);
      print('internet avialable');
    }else{
      WardListController wardListController = WardListController();
      wardListController.getFromSqflite(data.hospital[0].sId).then((value){

        var selectedData = wardListController.wardListdata.firstWhere((element) => element.sId == data.wardId.sId);

        Get.to(BedsScreen(patientIdForFocus: data.sId,wardId: data.wardId.sId,wardData: wardListController.wardListdata,hospName: data.hospital[0].name,bedsData: selectedData.beds,hospId: data.hospital[0].sId,));


      });

      
      // _controller.getFromSqflite();
    }
  });
  
//  Get.to(BedsScreen(wardId:data.wardId.toString(),wardData: ,));

}
