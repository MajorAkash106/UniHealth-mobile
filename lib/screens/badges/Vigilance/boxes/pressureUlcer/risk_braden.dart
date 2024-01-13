import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/pressure_controller.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class RiskBraden extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  RiskBraden({this.patientDetailsData});

  @override
  _RiskBradenState createState() => _RiskBradenState();
}

class _RiskBradenState extends State<RiskBraden> {
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final HistoryController _historyController = HistoryController();

  final PressureController _controller = PressureController();

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    _controller.getData(JsonFilePath.riskBraden).then((value) {
      setState(() {});
      print('selcted ids : ${SelectedId}');

      if(!SelectedId.isNullOrBlank){
        for(var a in _controller.allData){
          for(var b in a.options){
            print(b.sId);
            if(SelectedId.contains(b.statusoption)){
              b.isSelected = true;
              a.selectedQ = true;
            }
          }
        }
      }
      setState(() {});
    });
  }

  List SelectedId = [];

  getData() {

    _controller.getPriviousData(widget.patientDetailsData, VigiLanceBoxes.pressureUlcer, VigiLanceBoxes.pressureUlcer_status_risk).then((resp){


      if(resp!=null){

        for(var a in resp.result.first.riskBradenData){

          for(var b in a.options){
            if(b.isSelected){
              SelectedId.add(b.statusoption);
            }
          }

        }


      }

    });

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
    print(_controller.allData.length);
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
          children: _controller.allData
              .map((e) => WillPopScope(
                    onWillPop: _willpopScope,
                    child: Scaffold(
                        appBar: BaseAppbar("risk_braden".tr, null),
                        body: _checkboxWidget(e)),
                  ))
              .toList(),
        ));
  }

  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  Widget _checkboxWidget(NRSListData e) {
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
                                SizedBox(
                                  width: 20.0,
                                ),
                                Card(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: e.options[index].isSelected
                                                  ? Colors.green
                                                  : Colors.black
                                                      .withAlpha(100)),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
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
                                for (var c = 0; c < e.options.length; c++) {
                                  e.options[c].isSelected = false;
                                  e.selectedQ = false;
                                }
                                e.options[index].isSelected =
                                    !e.options[index].isSelected;
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
                        currentIndex != _controller.allData.length - 1
                            ? "next".tr
                            : "save".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(_controller.allData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.allData.length - 1) {
                          if (e.selectedQ == true) {
                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
                        } else {
                          if (e.selectedQ == true) {
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

  onSaved() {
    List<NRSListData> selectedList = [];

    for (var a = 0; a < _controller.allData.length; a++) {
      if (_controller.allData[a].selectedQ) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(_controller.allData[a]);
      }
    }

    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    int count = 0;

    for (var q = 0; q < selectedList.length; q++) {
      print(selectedList[q].options);

      for (var s = 0; s < selectedList[q].options.length; s++) {
        if (selectedList[q].options[s].isSelected == true) {
          int a = int.parse(selectedList[q].options[s].score);
          setState(() {
            count = count + a;
          });
        }
      }
    }

    print('total score: $count');

    // for (var a in selectedList) {
    //   var options = a.options.firstWhere(
    //       (element) => element.isSelected == true,
    //       orElse: () => null);
    //
    //   a.options.clear();
    //   a.options.add(options);
    // }

    _controller.onSavedRisk(widget.patientDetailsData, selectedList, count);
  }
}
