import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class NRSFirstScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final List<NRSListData> selectedData;
  final String id;
  final String title;
  NRSFirstScreen({this.patientDetailsData,this.selectedData ,this.id, this.title});

  @override
  _NRSFirstScreenState createState() => _NRSFirstScreenState();
}

class _NRSFirstScreenState extends State<NRSFirstScreen> {
  int _isBMI = 0;

  final NRSController _controller = NRSController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState

    print('selected len: ${widget.selectedData.length}');
    getselectedData();
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _controller.getData(widget.id).then((value){

            for(var a =0;a<_controller.radioData.length;a++){

             for(var b=0;b<_controller.radioData[a].options.length;b++){

               if(SelectedId.contains(_controller.radioData[a].options[b].sId)){
                 setState(() {
                   _controller.radioData[a].options[b].isSelected =true;
                   _controller.radioData[a].selectedQ =true;
                 });


               }
             }

            }

          });
        });

        print('internet avialable');
      }
    });
    super.initState();
  }


  List SelectedId = [];
  getselectedData(){
    for(var i=0;i<widget.selectedData.length;i++){

      for(var b =0;b<widget.selectedData[i].options.length;b++){


        if(widget.selectedData[i].options[b].isSelected) {
          SelectedId.add(widget.selectedData[i].options[b].sId);
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
    print(_controller.radioData.length);
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
          controller: _pageController, physics:new NeverScrollableScrollPhysics() ,
          onPageChanged: (int index) {
            print(index);
            setState(() {
              currentIndex = index;
            });
          },
          children: _controller.radioData
              .map((e) => WillPopScope(
                    onWillPop: _willpopScope,
                    child: Scaffold(
                        appBar: BaseAppbar(
                            "${widget.title}",
                         null

                        ),
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

                  SizedBox(height: 10,),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,/**/
                      children: e.options.map((e2) =>   GestureDetector(
                        onTap: (){
                          print('pree');

                          setState(() {

                            for(var b=0;b<e.options.length;b++){
                              e.options[b].isSelected = false;
                            }
                            e2.isSelected = true;
                            e.selectedQ = true;
                          });

                        },
                        child: Row(
                        children: [
                         e2.isSelected? Icon(Icons.radio_button_checked,size: 20,color: primary_color,):Icon(Icons.radio_button_off,size: 20,),
                          SizedBox(width: 5,),
                          new Text(
                            '${e2.statusoption}',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(width: 15,),
                        ],
                      ),),).toList()
                  ),
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
                    text: currentIndex != _controller.radioData.length - 1
                        ? "Next"
                        : "Save",
                    myFunc: () {
                      print(_controller.radioData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.radioData.length - 1) {

                          if(e.selectedQ==true){

                            // for(var a =0;a<e.)

                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );



                          }else{
                            ShowMsg('Please choose a option');
                          }


                        } else {
                          if(e.selectedQ==true){
                            print('complete');
                            onSaved();
                          }else{
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
                                e.selectedQ = false;
                                e.options[index].isSelected = !e.options[index].isSelected;
                                for(var c=0;c<e.options.length;c++){
                                  if(e.options[c].isSelected == true){
                                    e.selectedQ = true;
                                  }
                                }
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
                        currentIndex != _controller.radioData.length - 1
                            ? "Next"
                            : "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(_controller.radioData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.radioData.length - 1) {

                          if(e.selectedQ==true){



                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );



                          }else{
                            ShowMsg('Please choose atleast one option');
                          }


                        } else {

                          if(e.selectedQ==true){
                            print('complete');
                            onSaved();
                          }else{
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

      for(var s=0; s<selectedList.length;s++){

        if(selectedList[q].options[s].statusoption.toUpperCase() =='Yes'.toUpperCase() &&  selectedList[q].options[s].isSelected == true){

          setState(() {
            isPart2 = true;
          });

        }

      }

    }


    print('is will go to on part 2:  $isPart2');

    if(isPart2) {

      Get.to(NRSSecondScreen(patientDetailsData: widget.patientDetailsData,
        title: widget.title,
        id: widget.id,selectedList: selectedList,selectedLastTime: widget.selectedData,));
    }else{




      Map data = {
        'status': widget.title,
        'score': '0',
        'lastUpdate': '${DateTime.now()}',
        'nextSchdule': '',
        'data': selectedList
      };

      _controller.saveData(widget.patientDetailsData, selectedList,0,data,widget.title).then((value){

        _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.NRSHistory, [data]).then((value){

          Get.to(Step1HospitalizationScreen(
            patientUserId: widget.patientDetailsData.sId,
            index: 2,
          ));
        });


      });
    }

  }
}
