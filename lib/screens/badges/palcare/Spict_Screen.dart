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
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/status_controller/NRSController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/palcare_controller/spictController.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/spictDataModel.dart';
import 'package:medical_app/screens/badges/status/NRS_second_2002.dart';

import '../../../config/cons/string_keys.dart';

class SPICTScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;

  SPICTScreen({
    this.patientDetailsData,
  });

  @override
  _SPICTScreenState createState() => _SPICTScreenState();
}

class _SPICTScreenState extends State<SPICTScreen> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();

  final SpictController _controller = SpictController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    getselectedData();
    _controller.getData().then((value) {
      print('return: $value');
      print('return: ${selctedOptionID.length}');

      for (var a = 0; a < _controller.spictAllData.length; a++) {
        for (var b = 0; b < _controller.spictAllData[a].options.length; b++) {
          if (selctedOptionID.contains(_controller.spictAllData[a].options[b].sId)) {
            _controller.spictAllData[a].options[b].isSelected = true;
            _controller.spictAllData[a].isSelected = true;
          }
        }
      }
    });
    super.initState();
  }

  List selctedOptionID = [];

  getselectedData() {
    selctedOptionID.clear();
    for (var a = 0; a < widget.patientDetailsData.palcare.length; a++) {
      if (widget.patientDetailsData.palcare[a].palcare == 'spict') {
        for (var b = 0;
            b < widget.patientDetailsData.palcare[a].spictData.length;
            b++) {
          for (var c = 0;
              c <
                  widget.patientDetailsData.palcare[a].spictData[b].options
                      .length;
              c++) {
            if (widget.patientDetailsData.palcare[a].spictData[b].options[c]
                .isSelected) {
              selctedOptionID.add(widget
                  .patientDetailsData.palcare[a].spictData[b].options[c].sId);
            }
          }
        }

        break;
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
    print(_controller.spictAllData.length);
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
          children: _controller.spictAllData
              .map((e) => WillPopScope(
                  onWillPop: _willpopScope,
                  child: Scaffold(
                      appBar: BaseAppbar(
                          "spict".tr,
                          IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              color: card_color,
                            ),
                            onPressed: () {
                              Get.to(ReferenceScreen(Ref_list: ref_controller.SPICT_Ref_list,));
                            },
                          )),
                      body: _checkboxWidget(e))))
              .toList(),
        ));
  }

  // Widget _radioWidget(SpictQuestion e) {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Container(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Container(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 widget.title == "MNA - NNI"
  //                     ? Center(child: NNILogo_CopyRightText())
  //                     : SizedBox(),
  //                 widget.title == "MNA - NNI"
  //                     ? SizedBox(
  //                   height: 10,
  //                 )
  //                     : SizedBox(),
  //                 Text(
  //                   "${e.statusquestion}",
  //                   style: TextStyle(fontSize: 16, fontWeight: FontBold),
  //                 ),
  //                 // Row(
  //                 //   children: [
  //                 //     Row(
  //                 //       children: [
  //                 //         new Radio(
  //                 //           value: 0,
  //                 //           groupValue: _isBMI,
  //                 //           onChanged: (int value) {
  //                 //             setState(() {
  //                 //               _isBMI = value;
  //                 //             });
  //                 //           },
  //                 //         ),
  //                 //         new Text(
  //                 //           'Yes',
  //                 //           style: new TextStyle(fontSize: 16.0),
  //                 //         ),
  //                 //       ],
  //                 //     ),
  //                 //
  //                 //     Row(
  //                 //       children: [
  //                 //         new Radio(
  //                 //           value: 1,
  //                 //           groupValue: _isBMI,
  //                 //           onChanged: (int value) {
  //                 //             setState(() {
  //                 //               _isBMI = value;
  //                 //             });
  //                 //           },
  //                 //         ),
  //                 //         new Text(
  //                 //           'No',
  //                 //           style: new TextStyle(fontSize: 16.0),
  //                 //         ),
  //                 //       ],
  //                 //     ),
  //                 //   ],
  //                 // ),
  //
  //                 SizedBox(height: 10,),
  //                 Row(
  //                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,/**/
  //                     children: e.options.map((e2) =>   GestureDetector(
  //                       onTap: (){
  //                         print('pree');
  //
  //                         setState(() {
  //
  //                           for(var b=0;b<e.options.length;b++){
  //                             e.options[b].isSelected = false;
  //                           }
  //                           e2.isSelected = true;
  //                           e.selectedQ = true;
  //                         });
  //
  //                       },
  //                       child: Row(
  //                         children: [
  //                           e2.isSelected? Icon(Icons.radio_button_checked,size: 20,color: primary_color,):Icon(Icons.radio_button_off,size: 20,),
  //                           SizedBox(width: 5,),
  //                           new Text(
  //                             '${e2.statusoption}',
  //                             style: new TextStyle(fontSize: 16.0),
  //                           ),
  //                           SizedBox(width: 15,),
  //                         ],
  //                       ),),).toList()
  //                 ),
  //               ],
  //             ),
  //           ),
  //           // SizedBox(height: 50,),
  //           widget.title == "MNA - NNI"
  //               ? Center(child: CopyRightText())
  //               : SizedBox(),
  //           widget.title == "MNA - NNI"
  //               ? SizedBox(
  //             height: 10,
  //           )
  //               : SizedBox(),
  //           Padding(
  //             padding: const EdgeInsets.only(bottom: 30),
  //             child: Container(
  //                 width: Get.width,
  //                 child: CustomButton(
  //                   text: currentIndex != _controller.spictAllData.length - 1
  //                       ? "Next"
  //                       : "Save",
  //                   myFunc: () {
  //                     print(_controller.spictAllData.length);
  //                     if (_pageController.hasClients) {
  //                       if (currentIndex != _controller.spictAllData.length - 1) {
  //
  //                         if(e.selectedQ==true){
  //                           _pageController.animateToPage(
  //                             currentIndex + 1,
  //                             duration: const Duration(milliseconds: 400),
  //                             curve: Curves.easeInOut,
  //                           );
  //                         }else{
  //                           ShowMsg('Please choose a option');
  //                         }
  //
  //
  //                       } else {
  //                         if(e.selectedQ==true){
  //                           print('complete');
  //                           onSaved();
  //                         }else{
  //                           ShowMsg('Please choose atleast one option');
  //                         }
  //                       }
  //                     }
  //                   },
  //                 )),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _checkboxWidget(SpictQuestion e) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
        SizedBox(
          height: 10,
        ),

        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
          child: Text(
            "${e.categoryname}",
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
                       top: 12.0, bottom: 12.0, right: 20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            child: Row(
                              children: [
                                SizedBox(width: 20.0,),
                                Card(
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
                              ],
                            ),
                            onTap: () {
                              setState(() {


                                if(e.options[index].subcategoryname.trim().toLowerCase().contains('not_applicable'.tr.trim().toLowerCase())){

                                  print('yess');
                                  for (var c = 0; c < e.options.length; c++) {
                                    e.isSelected = false;
                                    e.options[c].isSelected = false;
                                  }

                                }else{
                                  print('nooo');
                                  for (var c = 0; c < e.options.length; c++) {

                                    if((e.options[c].subcategoryname.toLowerCase().contains("not_applicable".tr.toLowerCase()))){
                                      e.isSelected = false;
                                      e.options[c].isSelected = false;
                                    }

                                  }

                                }




                                e.isSelected = false;
                                e.options[index].isSelected = !e.options[index].isSelected;


                                for (var c = 0; c < e.options.length; c++) {
                                  if (e.options[c].isSelected == true) {
                                    e.isSelected = true;
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
                                  e.options[index].subcategoryname,
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
                        currentIndex != _controller.spictAllData.length - 1
                            ? "next".tr
                            : "save".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(_controller.spictAllData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex !=
                            _controller.spictAllData.length - 1) {
                          if (e.isSelected == true) {
                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
                        } else {
                          if (e.isSelected == true) {
                            print('complete');
                            onSaved();
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
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

  onSaved() async {
    List<SpictQuestion> selectedList = [];

    selectedList.clear();

    for (var a = 0; a < _controller.spictAllData.length; a++) {
      if (_controller.spictAllData[a].isSelected) {
        // print('selected data: ${jsonEncode(_controller.spictAllData[a])}');
        selectedList.add(_controller.spictAllData[a]);
      }
    }
    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    // var selectedData = selectedList.firstWhere((element) => element.categoryname
    //     .toUpperCase()
    //     .contains('General Indicator'.toUpperCase()));

    //
    var selectedData = selectedList.firstWhere((element) => element.sId == AppString.generalIndicator);


    print(selectedData.options.length);
    List selectedOptionGeneral = [];
    selectedOptionGeneral.clear();
    for (var a = 0; a < selectedData.options.length; a++) {
      if (selectedData.options[a].isSelected) {
        if (selectedData.options[a].subcategoryname.toUpperCase() != 'not_applicable'.tr) {
          selectedOptionGeneral.add(selectedData.options[a]);

        }

        // if (selectedData.options[a].sId!= AppString.notApplicable) {
        //   selectedOptionGeneral.add(selectedData.options[a]);
        //
        // }

      }
    }

    print('general: ${selectedOptionGeneral.length}');

    // var selectedData = selectedList.firstWhere((element) => element.categoryname.contains('General Indicator'));
    //
    // print(selectedData.options.length);
    // List selectedOptionclinical = [];
    // selectedOptionGeneral.clear();

    bool clinicalselected = false;

    for (var a = 0; a < selectedList.length; a++) {
      if (selectedList[a]
          .categoryname
          .toUpperCase()
          .contains('clinical_indicator'.tr.toUpperCase())) {
        // setState(() {
        //   clinicalselected = true;
        // });
        // break;

        for (var b = 0; b < selectedList[a].options.length; b++) {
          print('here: ${selectedList[a].options[b].subcategoryname}');

          if (selectedList[a].options[b].isSelected) {
            print('selcted: ${selectedList[a].options[b].subcategoryname}');
            if (selectedList[a].options[b].subcategoryname.trim().contains('not_applicable'.tr) || selectedList[a].options[b].subcategoryname.trim().contains('not_applicable'.tr)) {
              print('noooo');
            }
                else {
              print('yessssssss');
              setState(() {
                clinicalselected = true;
              });
              break;
            }
          }
        }
      }
    }

    print('general: ${selectedOptionGeneral.length}');
    print('clinical: ${clinicalselected}');

    String status;
    if (selectedOptionGeneral.length >= 2 && clinicalselected == true) {
      print('positive');

      setState(() {
        status = 'Positive';
      });
    } else {
      print('negative');
      setState(() {
        status = 'Negative';
      });
    }

    Map data = {
      'palcare': 'spict',
      "status": status,
      'lastUpdate': '${DateTime.now()}',
      'spictData': selectedList
    };

    print(jsonEncode(data));

    List a = [];
    a.clear();
    a.add(data);

    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){

      if(internet!=null && internet){
         _controller.saveData(widget.patientDetailsData, data).then((value){
          _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, ConstConfig.spictHistory, a);
        });
      }else{
        _controller.saveDataOffline(widget.patientDetailsData, data);
      }

    });



    //  save history
  }
}
