import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/palcare_controller/goals_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';




class Goals_agreement extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  Goals_agreement({this.patientDetailsData});
  @override
  _Goals_agreementState createState() => _Goals_agreementState();
}

class _Goals_agreementState extends State<Goals_agreement> {
  final GoalsController _controller = GoalsController();
  final HistoryController _historyController = HistoryController();
  @override
  void initState() {
    getselectedData();

    _controller.getData().then((value) {
      print('return value: $value');

      List optionName = [];
      optionName.clear();
      print("selctedQuestionID:${selctedOptionID}");
      for (var c = 0; c < _controller.goalData.length; c++) {
        // print("sId:${_controller.goalData[c].sId}");
        // print("sId:${_controller.goalData[c].optionname}");
        optionName.add(_controller.goalData[c].optionname);
        if (selctedOptionID.contains(_controller.goalData[c].sId)) {
          print('contains');
          _controller.goalData[c].isSelected = true;
        }
      }

      for (var s = 0; s < selctedOptionName.length; s++) {
        print(selctedOptionName[s]);
        if (!optionName.contains(selctedOptionName[s])) {
          print('yess');
          setState(() {
            otherText.text = selctedOptionName[s];
          });
        }
      }
    });

    super.initState();
  }

  List selctedOptionID = [];
  List selctedOptionName = [];
  getselectedData() {
    selctedOptionID.clear();
    selctedOptionName.clear();
    for (var a = 0; a < widget.patientDetailsData[0].palcare.length; a++) {
      if (widget.patientDetailsData[0].palcare[a].palcare == 'goals') {
        for (var b = 0; b < widget.patientDetailsData[0].palcare[a].goals.length; b++) {
          setState(() {
            selctedOptionID
                .add(widget.patientDetailsData[0].palcare[a].goals[b].sId);
            selctedOptionName.add(
                widget.patientDetailsData[0].palcare[a].goals[b].optionname);
          });
        }

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "goals_palliative_care".tr,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: Colors.black87),
          ),
          leading: InkWell(
            child: Icon(
              Icons.keyboard_backspace,
              color: Colors.black87,
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          // actions:<Widget>[InkWell(child: Container( padding:EdgeInsets.only(right: 20.0),child: Icon(Icons.info_outlined,color: Colors.black,size: 20.0,)),
          //   onTap: ()async{
          //   // Get.to(ReferenceScreen(Ref_list: [],));
          //
          //     var data =  await getJson(JsonFilePath.goalData);
          //     print('get data form json:  ${jsonDecode(data)}');
          //
          //
          //   },),],
          elevation: 0.0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.5),
              child: Container(
            height: 1.5,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
          )),
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.goalData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, bottom: 12.0, right: 20.0),
                          child: Column(
                            children: [
                              Row(
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
                                                          color: _controller
                                                                  .goalData[
                                                                      index]
                                                                  .isSelected
                                                              ? Colors.green
                                                              : Colors.black
                                                                  .withAlpha(
                                                                      100)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0)),
                                                  child: _controller
                                                          .goalData[index]
                                                          .isSelected
                                                      ? Icon(Icons.check,
                                                          size: 20.0,
                                                          color: Colors.green)
                                                      : Icon(
                                                          Icons.check,
                                                          size: 18.0,
                                                          color: Colors
                                                              .transparent,
                                                        )),
                                              elevation: 4.0,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            // for(var i = 0;i<_controller.goalData.length;i++){
                                            //   _controller.goalData[i].isSelected = false;
                                            // }

                                            _controller.goalData[index]
                                                    .isSelected =
                                                !_controller
                                                    .goalData[index].isSelected;
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              _controller
                                                  .goalData[index].optionname
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: black40_color),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              _controller.goalData[index].sId == AppString.others
                                  ? _controller.goalData[index].isSelected
                                      ? _textarea()
                                      : SizedBox()
                                  : SizedBox()
                            ],
                          ));
                    }),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'confirm'.tr,
                        myFunc: () async {
                          List<AKPSData> selectedList = [];

                          selectedList.clear();
                          for (var i = 0;
                              i < _controller.goalData.length;
                              i++) {
                            if (_controller.goalData[i].isSelected == true) {
                              selectedList.add(_controller.goalData[i]);
                            }
                          }
                          for (var i = 0; i < selectedList.length; i++) {
                            // if (selectedList[i].optionname.toUpperCase() == 'OTHERS') {
                            if (selectedList[i].sId == AppString.others) {
                              if (otherText.text.isNotEmpty) {
                                selectedList[i].optionname = otherText.text;
                              } else {
                                ShowMsg('TextField is empty');
                              }
                              break;
                              // selectedList.add(_controller.goalData[i].optionname = otherText.text;);
                            }
                          }

                          // print("selected: ${jsonEncode(selectedList)}");

                          // var selectedData =
                          // _controller.goalData.firstWhere((element) => element.isSelected == true);
                          // // print(jsonEncode(selectedData))
                          Map data = {
                            'palcare': 'goals',
                            'lastUpdate': '${DateTime.now()}',
                            'goals': selectedList
                          };

                          print(jsonEncode(data));

                          // print(widget.patientDetailsData[0].name);
                          if (selectedList.isNotEmpty) {
                            checkConnectivityWithToggle(widget.patientDetailsData[0].hospital[0].sId).then((internet) {
                              if (internet != null && internet) {

                                 _controller
                                    .saveData(widget.patientDetailsData[0], data)
                                    .then((value) {
                                  print('getback');
                                  _historyController.saveMultipleMsgHistory(
                                      widget.patientDetailsData[0].sId,
                                      ConstConfig.goalHistory,
                                      selectedList);
                                  // Get.back();
                                  // _patientSlipController.getDetails(widget.patientDetailsData[0].sId);
                                });

                              }else{
                                _controller.saveDataGoalsDataOffline(widget.patientDetailsData[0], data);
                              }

                            });


                          } else {
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }
                          // Get.back();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ));
  }

  var otherText = TextEditingController();
  Widget _textarea() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 5, right: 5),
      child: TextField(
        autofocus: false,
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
            hintText: 'type_here'.tr,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            )),
            // filled: true,
            fillColor: Colors.grey),
        maxLines: 2,
        controller: otherText,
      ),
    );
  }
}
