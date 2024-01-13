import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../config/Locale/locale_config.dart';


class MNAController extends GetxController {

  var allData = List<NRSListData>().obs;

  Future<String> getData(String id) async {
    // Get.dialog(Loader(), barrierDismissible: false);
    try {
      // print(APIUrls.getNRSQuestions);
      // Request request = Request(url: APIUrls.getNRSQuestions, body: {
      //   'statusId': id,
      // });
      //
      // print(request.body);
      // await request.post().then((value) {
      //   NRSModel model = NRSModel.fromJson(json.decode(value.body));
      //   print(model.success);
      //   print(model.message);
      //   Get.back();
      //   if (model.success == true) {
      //     allData.clear();
      //
      //     print(model.data);
      //     allData.addAll(model.data);
      //
      //   } else {
      //     ShowMsg(model.message);
      //   }
      // });
      //
      var data = await getJson(id);
      print('data from json file: ${json.decode(data)}');
        NRSModel model = NRSModel.fromJson(json.decode(data));
        print(model.success);
        print(model.message);

        if (model.success == true) {
          allData.clear();

          print(model.data);
          allData.addAll(model.data);

          debugPrint('allData -- ${allData.length}');

        } else {
          ShowMsg(model.message);
        }

    } catch (e) {
      ServerError();
    }

    return "success";

  }



  Future<String> saveData(PatientDetailsData data,
      List<NRSListData> selectedList, int score,String status,Map dataa) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.PostStatus);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalScreening,
        "status": status,
        'score': score.toString(),
        'result': jsonEncode([dataa]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      Get.back();
      ServerError();
    }

    return "success";
  }



  Future<String> saveDataOffline(
      PatientDetailsData data,
      List<NRSListData> selectedList,
      int score,
      Map dataa,
      String status) async {

    try {

      await  returnPatientDAtaFromNRS(data,score,dataa,status,statusType.nutritionalScreening).then((value){
        print('return patient ${jsonEncode(value)}');
        // print('return ${jsonEncode(value.status)}');
        // print('return ${jsonEncode(value.name)}');
        //
        SaveDataSqflite sqflite = SaveDataSqflite();
        sqflite.saveData(value);
        Get.to(Step1HospitalizationScreen(
          patientUserId: value.sId,
          index: 2,
        ));

      });

    } catch (e) {
      // Get.back();

      print('exception occur : $e');
      ServerError();
    }

    return "success";
  }


  void savedMustData(PatientDetailsData patient_data, List<NRSListData> selectedList, int score,String status,BuildContext context){


    Map data = {
      'status': status,
      'score': score.toString(),
      'lastUpdate': '${DateTime.now()}',
      'data': selectedList
    };

    print('data json: ${jsonEncode(data)}');


    afterSaved(score, patient_data, context,selectedList,status);

  }

  void savedStrongKidData(PatientDetailsData patient_data, List<NRSListData> selectedList, int score,String status,BuildContext context){


    Map data = {
      'status': status,
      'score': score.toString(),
      'lastUpdate': '${DateTime.now()}',
      'data': selectedList
    };

    print('data json: ${jsonEncode(data)}');


    // afterSaved(score, patient_data, context,selectedList,status);

    DateTime date = DateTime.now();
    var after7days = date.add(Duration(days: 7));
    print(after7days);

    schduleNextFunc(patient_data, context, after7days, score, selectedList,status);

  }

  void saveNutric(PatientDetailsData data, List<NRSListData> selectedList, int score,String status,BuildContext context){


  String scoreType = getNutricRisk(selectedList, score);


    Map dataa = {
      'status': status,
      'score': score.toString(),
      'dataText': scoreType,
      'lastUpdate': '${DateTime.now()}',
      'data': selectedList
    };
    // print('data json: ${jsonEncode(data)}');

  void _fun() async{

    Get.back();

  bool internet = await  checkConnectivityWithToggle(data.hospital[0].sId);

    if(internet!=null && internet){

      saveData2(data, selectedList, score, status, dataa).then((value){

        _historyController.saveMultipleMsgHistory(
            data.sId,
            ConstConfig.NutricHistory,
            [dataa]).then((value){
          Get.to(Step1HospitalizationScreen(
            patientUserId: data.sId,
            index: 2,
          ));
        });


      });

    }else{
      saveDataOffline(data, selectedList, score, dataa, status);
    }


  }

    showNutricPopup(context, score,scoreType, _fun);


  }
  
 String getNutricRisk(List<NRSListData> selectedList, int score){
    bool isILLAvailable = false;
    for(var a in selectedList){
      if(a.statusquestion.contains('IL-6')){
        for(var b in a.options){
          if(b.isSelected && b.statusoption!='not_available'.tr){
            isILLAvailable = true;
          }
        }
        break;
      }
    }



    String scoreType = '';
    if(isILLAvailable){
      if(score<=5){
        scoreType = 'low_score';
      }else if(score>5 && score<=10){
        scoreType = 'high_score';
      }
    }else{
      if(score<=4){
        scoreType = 'low_score';
      }else if(score>4 && score<=9){
        scoreType = 'high_score';
      }
    }
    debugPrint('scoreType :: $scoreType $score-- isILLAvailable ::$isILLAvailable');
    return scoreType;
  }


  Future<String> afterSaved(int score, PatientDetailsData data,context,List<NRSListData> selectedList,status) async {
    if (score == 0) {
      print('score 0');
      print('show calender and schduledate');

      DateTime date = DateTime.now();
      var after7days = date.add(Duration(days: 7));
      print(after7days);

      showRiskPopup(context,0,()async{
        Get.back();
        // await  schduleNext(data, context,after7days);
        // schduleNextFunc(patientDetailsData, context, _date, count, selectedList, status);
        schduleNextFunc(data, context, after7days, score, selectedList,status);

       // Navigator.of(context).pop();
      });



    } else if (score == 1) {

      print('score 1');

      DateTime date = DateTime.now();
      var after3days = date.add(Duration(days: 3));
      print(after3days);

      showRiskPopup(context,1,()async{
        Get.back();



        // await ShowMsg('Document dietary intake for 3 days');
        //
        // Future.delayed(const Duration(seconds: 3), () {
        //   schduleNext(data, context,after3days);
        //
        //
        // });

        schduleNextFunc(data, context, after3days, score, selectedList,status);


      });




    }else{
      print('score 2 or 2 +');


      showRiskPopup(context,2,()async{


        onpress(data, selectedList, score, status, '');

        // Get.to(Step1HospitalizationScreen(
        //   patientUserId: data.sId,
        //   index: 2,
        // ));
        //
        // await Future.delayed(const Duration(seconds: 3), () {
        //   ShowMsgFor10sec('Refer to dietitian, Nutritional Support Team or implement local policy Set goals, improve and increase overall nutritional intakeMonitor and review care plan weekly');
        // });


      });






    }
  }

final HistoryController _historyController = HistoryController();
  onpress(PatientDetailsData data, List<NRSListData> selectedList, int score,String status,String schduleDate){


    Map dataa = {
      'status': status,
      'score': score.toString(),
      'lastUpdate': '${DateTime.now()}',
      'nextSchdule': schduleDate,
      'data': selectedList
    };

    print('opress data json: ${jsonEncode(data)}');


    checkConnectivityWithToggle(data.hospital[0].sId).then((internet){

      if(internet!=null && internet){

        saveData2(data, selectedList, score, status, dataa).then((value){

          if(status.toLowerCase().removeAllWhitespace.contains('Strong-kids'.toLowerCase().removeAllWhitespace)){
            _historyController.saveMultipleMsgHistory(
                data.sId,
                ConstConfig.STRONGKIDHistory,
                [dataa]).then((value){
              Get.to(Step1HospitalizationScreen(
                patientUserId: data.sId,
                index: 2,
              ));
            });
          }else{
            _historyController.saveMultipleMsgHistory(
                data.sId,
                ConstConfig.MUSTHistory,
                [dataa]).then((value){
              Get.to(Step1HospitalizationScreen(
                patientUserId: data.sId,
                index: 2,
              ));
            });
          }


        });

      }else{
        saveDataOffline(data, selectedList, score, dataa, status);
      }

    });




  }





//  ---------------------------------------------------------------------------------
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      _range = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
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
    // Get.back();
  }

  schduleNextFunc(PatientDetailsData patientDetailsData, context,
      DateTime _date, int count,  List<NRSListData> selectedList,String status ) async{
    print("schduledate: ${patientDetailsData.scheduleDate}");
    Locale locale = await LocaleConfig().getLocale();

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
                            // 'Schedule Next Evaluation',
                            'schedule_next_evaluation'.tr,
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              // monthFormat: "yyyy-MM-dd",
                              view: DateRangePickerView.month,
                              enablePastDates: false,initialDisplayDate: _date,
                              initialSelectedDate: _date,
                              onSelectionChanged: _onSelectionChanged),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: Get.width,
                    child: CustomButton(
                      text: '    ${'confirm'.tr}    ',
                      myFunc: () {
                        Get.back();

                        print(_selectedDate);

                        if (_selectedDate != null) {
                          print('changed selected date');

                          onpress(patientDetailsData, selectedList, count, status, _selectedDate);

                        } else {
                          _selectedDate = dateFormat.format(_date);
                          print(_selectedDate);

                          print('suggested date selected');

                          onpress(patientDetailsData, selectedList, count, status, _selectedDate);

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




  Future<String> saveData2(PatientDetailsData data, List<NRSListData> selectedList, int score,String status,Map dataa) async {
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.PostStatus);
      // data.hospital[0].observation = text;
      // data.hospital[0].observationLastUpdate = "${DateTime.now()}";
      Request request = Request(url: APIUrls.PostStatus, body: {
        'userId': data.sId,
        "type": statusType.nutritionalScreening,
        "status": status,
        'score': score.toString(),
        'result': jsonEncode([dataa]),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));
        print(commonResponse.success);
        print(commonResponse.message);
        Get.back();
        if (commonResponse.success == true) {
          // afterSaved(score,data);
          // Get.back();
          // print(commonResponse.data);
          // patientDetailsData.add(patientDetails.data);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      Get.back();
      ServerError();
    }

    return "success";
  }



  Future<String> getNutricResult(PatientDetailsData data) async {
    String output = '';

    if (data.status.isNotEmpty) {
      StatusData _statusData = await data.status.firstWhere(
              (element) =>
          element.type == statusType.nutritionalScreening &&
              element.status == nutritionalScreening.nutricStatus,
          orElse: () => null);

      if(_statusData !=null){
        output = await _statusData.result.first.dataText;
      }
    }

    return output;
  }


}
