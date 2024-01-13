import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/status_controller/NRSController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../../../config/Locale/locale_config.dart';


class NRSSecondScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String id;
  final String title;
  final List<NRSListData> selectedList;
  final List<NRSListData> selectedLastTime;
  NRSSecondScreen(
      {this.patientDetailsData, this.id, this.title, this.selectedList,this.selectedLastTime});

  @override
  _NRSSecondScreenState createState() => _NRSSecondScreenState();
}

class _NRSSecondScreenState extends State<NRSSecondScreen> {
  int _isBMI = 0;

  final NRSController _controller = NRSController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    getselectedData();

    _controller.getDataPart2(widget.id).then((value){



      for(var a =0;a<_controller.checkBoxData.length;a++){

        for(var b=0;b<_controller.checkBoxData[a].options.length;b++){

          if(SelectedId.contains(_controller.checkBoxData[a].options[b].sId)){
            setState(() {
              _controller.checkBoxData[a].options[b].isSelected =true;
              _controller.checkBoxData[a].selectedQ =true;
            });


          }
        }

      }


    });

    super.initState();
  }


  List SelectedId = [];
  getselectedData(){
    for(var i=0;i<widget.selectedLastTime.length;i++){

      for(var b =0;b<widget.selectedLastTime[i].options.length;b++){


        if(widget.selectedLastTime[i].options[b].isSelected) {
          SelectedId.add(widget.selectedLastTime[i].options[b].sId);
        }
      }

    }
  }




  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;

  Future<bool> _willpopScope() {
    print('back press');
    print(_controller.checkBoxData.length);
    if (_pageController.hasClients) {
      if (currentIndex != 0) {
        _pageController.animateToPage(
          currentIndex - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      } else {
        print('complete');
        Get.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => PageView(
          controller: _pageController,
          physics: new NeverScrollableScrollPhysics(),
          onPageChanged: (int index) {
            print(index);
            setState(() {
              currentIndex = index;
            });
          },
          children: _controller.checkBoxData
              .map((e) => WillPopScope(
                    onWillPop: _willpopScope,
                    child: Scaffold(
                        appBar: BaseAppbar(
                            "${widget.title}",
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
                        body: e.type == '0'
                            ? _radioWidget(e)
                            : _checkboxWidget(e)),
                  ))
              .toList(),
        ));
  }

  Widget _radioWidget(NRSListData e) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.title == "MNA - NNI"
                      ? Center(child: NNILogo_CopyRightText())
                      : SizedBox(),
                  widget.title == "MNA - NNI"
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(),
                  Text(
                    "${e.statusquestion}",
                    style: TextStyle(fontSize: 16, fontWeight: FontBold),
                  ),
                  // Row(
                  //   children: [
                  //     Row(
                  //       children: [
                  //         new Radio(
                  //           value: 0,
                  //           groupValue: _isBMI,
                  //           onChanged: (int value) {
                  //             setState(() {
                  //               _isBMI = value;
                  //             });
                  //           },
                  //         ),
                  //         new Text(
                  //           'Yes',
                  //           style: new TextStyle(fontSize: 16.0),
                  //         ),
                  //       ],
                  //     ),
                  //
                  //     Row(
                  //       children: [
                  //         new Radio(
                  //           value: 1,
                  //           groupValue: _isBMI,
                  //           onChanged: (int value) {
                  //             setState(() {
                  //               _isBMI = value;
                  //             });
                  //           },
                  //         ),
                  //         new Text(
                  //           'No',
                  //           style: new TextStyle(fontSize: 16.0),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,/**/
                      children: e.options
                          .map(
                            (e2) => GestureDetector(
                              onTap: () {
                                print('pree');

                                setState(() {
                                  for (var b = 0; b < e.options.length; b++) {
                                    e.options[b].isSelected = false;
                                  }
                                  e2.isSelected = true;
                                  e.selectedQ = true;
                                });
                              },
                              child: Row(
                                children: [
                                  e2.isSelected
                                      ? Icon(
                                          Icons.radio_button_checked,
                                          size: 20,
                                          color: primary_color,
                                        )
                                      : Icon(
                                          Icons.radio_button_off,
                                          size: 20,
                                        ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  new Text(
                                    '${e2.statusoption}',
                                    style: new TextStyle(fontSize: 16.0),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList()),
                ],
              ),
            ),
            // SizedBox(height: 50,),
            widget.title == "MNA - NNI"
                ? Center(child: CopyRightText())
                : SizedBox(),
            widget.title == "MNA - NNI"
                ? SizedBox(
                    height: 10,
                  )
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                  width: Get.width,
                  child: CustomButton(
                    text: currentIndex != _controller.checkBoxData.length - 1
                        ? "next".tr
                        : "save".tr,
                    myFunc: () {
                      print(_controller.checkBoxData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex !=
                            _controller.checkBoxData.length - 1) {
                          if (e.selectedQ == true) {
                            // for(var a =0;a<e.)

                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('Please choose a option');
                          }
                        } else {
                          if (e.selectedQ == true) {
                            print('complete');
                            onSaved();
                          } else {
                            ShowMsg('Please choose atleast one option');
                          }
                        }
                      }
                    },
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _checkboxWidget(NRSListData e) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
        widget.title.removeAllWhitespace == "NRS-2002"   ? Center(
         child:  Padding(
           padding: EdgeInsets.only(top: 8),
           child: Text(
           "final_screening".tr,
           style: TextStyle(
               fontSize: 18, fontWeight: FontBold,color: primary_color),
         ),),):SizedBox(),
        SizedBox(
          height: 10,
        ),
        widget.title == "MNA - NNI"
            ? Center(child: NNILogo_CopyRightText())
            : SizedBox(),
        widget.title == "MNA - NNI"
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),

        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
          child: Text(
            "${e.statusquestion}",
            style: TextStyle(fontSize: 16, fontWeight: FontBold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: e.options.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 12.0, bottom: 12.0, right: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Card(
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: e.options[index].isSelected
                                              ? Colors.green
                                              : Colors.black.withAlpha(100)),
                                      borderRadius: BorderRadius.circular(5.0)),
                                  child: e.options[index].isSelected
                                      ? Icon(Icons.check,
                                          size: 20.0, color: Colors.green)
                                      : Icon(
                                          Icons.check,
                                          size: 18.0,
                                          color: Colors.transparent,
                                        )),
                              elevation: 4.0,
                            ),
                            onTap: () {
                              setState(() {
                                // e.selectedQ = false;


                                for (var c = 0; c < e.options.length; c++) {
                                  // if (e.options[c].isSelected == true) {
                                    e.selectedQ = false;
                                    e.options[c].isSelected = false;
                                  // }
                                }
                                e.options[index].isSelected = !e.options[index].isSelected;
                                e.selectedQ = e.options[index].isSelected;
                              });
                            },
                          ),
                          // SizedBox(height:15.0,)
                        ],
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  e.options[index].statusoption,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black54,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
        widget.title == "MNA - NNI"
            ? Center(child: CopyRightText())
            : SizedBox(),
        widget.title == "MNA - NNI"
            ? SizedBox(
                height: 10,
              )
            : SizedBox(),
        // Spacer(),
        // SizedBox(height: 30.0,),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 30),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: primary_color,
                    child: Center(
                      child: Text(
                        currentIndex != _controller.checkBoxData.length - 1
                            ? "next".tr
                            : "save".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(_controller.checkBoxData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex !=
                            _controller.checkBoxData.length - 1) {
                          if (e.selectedQ == true) {
                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('Please choose atleast one option');
                          }
                        } else {
                          if (e.selectedQ == true) {
                            print('complete');
                            onSaved();
                          } else {
                            ShowMsg('Please choose atleast one option');
                          }
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(height: 30.0,),
      ],
    );
  }

  onSaved() {
    List<NRSListData> selectedList = [];
    selectedList.addAll(widget.selectedList);

    for (var a = 0; a < _controller.checkBoxData.length; a++) {
      if (_controller.checkBoxData[a].selectedQ) {
        // print('selected data: ${jsonEncode(_controller.checkBoxData[a])}');
        selectedList.add(_controller.checkBoxData[a]);
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    int count = 0;

    for (var q = 0; q < selectedList.length; q++) {
      print(selectedList[q].options);

      for (var s = 0; s < selectedList[q].options.length; s++) {
        if (selectedList[q].options[s].isSelected == true) {
          // print('total score: ${count+ int.parse(selectedList[q].options[s].score)}');
          // print('int score: ${selectedList[q].options[s].score}');

          int a = int.parse(selectedList[q].options[s].score);
          setState(() {
            count = count + a;
          });
        }
      }
    }

    print('total score: $count');


    getAgeYearsFromDate(widget.patientDetailsData.dob).then((year){

      if(year>70){
        setState(() {
          count = count + 1;
        });
      }


      // Map data = {
      //   'status': widget.title,
      //   'score': count.toString(),
      //   'lastUpdate': '${DateTime.now()}',
      //   'data': selectedList
      // };

      // _controller.saveData(widget.patientDetailsData, selectedList,count,data,widget.title).then((value){
      //   print('return value: $value');
      //   _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.NRSHistory, [data]).then((value){
      //     _controller.afterSaved(count, widget.patientDetailsData,context);
      //   });
      //
      //
      // });
      afterSaved(count, widget.patientDetailsData,context,count,selectedList);

    });


    // _controller.afterSaved(count, widget.patientDetailsData,context);

  }



  void afterSaved(int score, PatientDetailsData data,context,int count,  List<NRSListData> selectedListt) async{
    if (score < 3) {
      print('show calender and schduledate');

      DateTime date = DateTime.now();
      var after7days = date.add(Duration(days: 7));
      print(after7days);
      // await  schduleNext(data, context,after7days);

      await schduleNextFunc(data, context,after7days,count,  selectedListt ).then((value){
        print('return date: $value');
      });


    } else {
      // Get.to(Step1HospitalizationScreen(
      //   patientUserId: data.sId,
      //   index: 2,
      // ));
      onpress(count, selectedListt, '');
    }
  }


// /---------------------------------------------------------------------------------/
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
                          // return 'ddsf';
                          // Get.back();
                          // schduledate(patientDetailsData, _selectedDate);
                          onpress(count, selectedList,_selectedDate);

                        } else {
                          _selectedDate = dateFormat.format(_date);
                          print(_selectedDate);
                          // schduledate(patientDetailsData, _selectedDate);
                          print('suggested date selected');
                          // return 'ddsf';
                          // ShowMsg('Please choose a date');

                          onpress(count, selectedList,_selectedDate);
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


  onpress( int count, List<NRSListData> selectedList ,String selectedDate){
    Map data = {
      'status': widget.title,
      'score': count.toString(),
      'lastUpdate': '${DateTime.now()}',
      'nextSchdule': selectedDate,
      'data': selectedList
    };
    print('data: ${jsonEncode(data)}');

    
    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
      if(internet!=null && internet){

        _controller.saveData(widget.patientDetailsData, selectedList,count,data,widget.title).then((value){
          print('return value: $value');
          _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.NRSHistory, [data]).then((value){
            // _controller.afterSaved(count, widget.patientDetailsData,context);

            Get.to(Step1HospitalizationScreen(
              patientUserId: widget.patientDetailsData.sId,
              index: 2,
            ));
          });


        });

      }else{
        _controller.saveDataOffline(widget.patientDetailsData, selectedList,count,data,widget.title);
      }
    });
    

  }

}
