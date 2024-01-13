import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/NRSController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import 'package:medical_app/screens/badges/status/NRS_forth_2002.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NRSThirdScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final List<NRSListData> selectedData;
  final String id;
  final String title;
  NRSThirdScreen({this.patientDetailsData, this.selectedData, this.id, this.title});
  @override
  _NRSThirdScreenState createState() => _NRSThirdScreenState();
}

class _NRSThirdScreenState extends State<NRSThirdScreen> {
  final NRSController _controller = NRSController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState

    print('selected len: ${widget.selectedData.length}');
    getselectedData();

    _controller.getData(widget.id).then((value) {
      for (var a = 0; a < _controller.radioData.length; a++) {
        for (var b = 0;
        b < _controller.radioData[a].options.length;
        b++) {
          if (SelectedId.contains(
              _controller.radioData[a].options[b].sId)) {
            setState(() {
              _controller.radioData[a].options[b].isSelected = true;
              _controller.radioData[a].selectedQ = true;
            });
          }
        }
      }
    });


    super.initState();
  }

  List SelectedId = [];
  getselectedData() {
    for (var i = 0; i < widget.selectedData.length; i++) {
      for (var b = 0; b < widget.selectedData[i].options.length; b++) {
        if (widget.selectedData[i].options[b].isSelected) {
          SelectedId.add(widget.selectedData[i].options[b].sId);
        }
      }
    }
  }

  int _isDietary = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          "NRS - 2002",
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: card_color,
            ),
            onPressed: () {
              final Refference_Notes_Controller  refference_notes_controller = Refference_Notes_Controller();
              Get.to(ReferenceScreen(Ref_list:refference_notes_controller.NRSREF ,));

            },
          )),
      body: Obx(()=>Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
              Text(
                "initial_screening".tr,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontBold,color: primary_color),
              ),
              Expanded(
                child: ListView(
                  children: _controller.radioData
                      .map(
                        (e) => Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${e.statusquestion}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontBold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              children: e.options
                                  .map(
                                    (e2) => GestureDetector(
                                  child: Row(
                                    children: [
                                      // new Radio(
                                      //   value: 0,
                                      //   groupValue: _isDietary,
                                      //   onChanged: (int value){
                                      //     setState(() {
                                      //       _isDietary = value;
                                      //     });
                                      //   },
                                      // ),
                                      e2.isSelected
                                          ? Icon(
                                        Icons
                                            .radio_button_checked,
                                        color: primary_color,
                                        size: 22,
                                      )
                                          : Icon(
                                        Icons.radio_button_off,
                                        size: 22,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      new Text(
                                        '${e2.statusoption}',
                                        style: new TextStyle(
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    setState(() {
                                      for (var b = 0; b < e.options.length; b++) {
                                        e.options[b].isSelected = false;
                                      }
                                      e2.isSelected = true;
                                      e.selectedQ = true;
                                    });
                                  },
                                ),
                              )
                                  .toList()),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                    width: Get.width,
                    child: CustomButton(
                      text: "next".tr,
                      myFunc: () {
                        // Get.to(NRS_ForthScreen());
                        bool allSelected = true;
                        for(var a = 0; a<_controller.radioData.length; a++){
                          if(_controller.radioData[a].selectedQ == false){
                            setState(() {
                              allSelected = false;
                            });
                          }
                        }
                       if(allSelected){
                         onSaved();
                       }else{
                         ShowMsg('all_mandatory'.tr);
                       }
                      },
                    )),
              )
            ],
          ),
        ),
      ),)
    );
  }


  onSaved() {
    List <NRSListData>selectedList = [];

    for (var a = 0; a < _controller.radioData.length; a++) {
      if(_controller.radioData[a].selectedQ){
        // print('selected data: ${jsonEncode(_controller.radioData[a])}');
        selectedList.add(_controller.radioData[a]);
      }
    }



    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    bool isPart2= false;

    for(var q=0;q<selectedList.length;q++){
      print(selectedList[q].options);

      for(var s=0; s<selectedList[q].options.length;s++){

        String option = selectedList[q].options[s].statusoption.toUpperCase();
        if((option =='Yes'.toUpperCase() || option =='yes'.tr.toUpperCase()) &&  selectedList[q].options[s].isSelected == true){

          setState(() {
            isPart2 = true;
          });

        }

      }

    }


    print('is will go to on part 2:  $isPart2');

    if(isPart2) {
      print('final screening');
      Get.to(NRSSecondScreen(patientDetailsData: widget.patientDetailsData,
        title: widget.title,
        id: widget.id,selectedList: selectedList,selectedLastTime: widget.selectedData,));
    }else{

      print('first screening');




      DateTime date = DateTime.now();
      var after7days = date.add(Duration(days: 7));
      print(after7days);
      schduleNextFunc(widget.patientDetailsData, context, after7days, 0, selectedList);
      // _controller.saveData(widget.patientDetailsData, selectedList,0,data,widget.title).then((value){
      //
      //   _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.NRSHistory, [data]).then((value){
      //
      //     Get.to(Step1HospitalizationScreen(
      //       patientUserId: widget.patientDetailsData.sId,
      //       index: 2,
      //     ));
      //   });
      //
      //
      // });
    }

  }


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
    Get.back();
  }

  schduleNextFunc(PatientDetailsData patientDetailsData, context,
      DateTime _date, int count,  List<NRSListData> selectedList ) async{
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
                            'schedule_next_evaluation'.tr,
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            enablePastDates: false,initialDisplayDate: _date,
                            initialSelectedDate: _date,
                            onSelectionChanged: _onSelectionChanged),
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

                          onpress(selectedList,_selectedDate);
                        } else {
                          _selectedDate = dateFormat.format(_date);
                          print(_selectedDate);

                          print('suggested date selected');

                          onpress(selectedList,_selectedDate);
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

onpress( List<NRSListData> selectedList,_selectedDate){

  Map data = {
    'status': widget.title,
    'score': '0',
    'lastUpdate': '${DateTime.now()}',
    'nextSchdule': _selectedDate,
    'data': selectedList
  };
  print('encoded data: ${jsonEncode(data)}');

  checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){

    if(internet !=null && internet){


      _controller.saveData(widget.patientDetailsData, selectedList,0,data,widget.title).then((value){

        _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.NRSHistory, [data]).then((value){

          Get.to(Step1HospitalizationScreen(
            patientUserId: widget.patientDetailsData.sId,
            index: 2,
          ));
        });


      });

    }else{
      _controller.saveDataOffline(widget.patientDetailsData, selectedList,0,data,widget.title);
    }

  });



}

}
