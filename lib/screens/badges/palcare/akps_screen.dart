import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/palcare_controller/akps_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class Akps_screen extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  Akps_screen({this.patientDetailsData});
  @override
  _Akps_screenState createState() => _Akps_screenState();
}

class _Akps_screenState extends State<Akps_screen> {
  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();
  final AkpsController _controller = AkpsController();
  final PatientSlipController _patientSlipController = PatientSlipController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    getSelectedData();

    _controller.getData().then((value) {
      print("value: $value");

      for(var a =0; a<  _controller.akpsData.length; a++){
        if(_controller.akpsData[a].persentage == selectedData){
          _controller.akpsData[a].isSelected = true;
          break;
        }
      }

    });

    super.initState();
  }

  String selectedData;
  getSelectedData() {
    for (var a = 0; a < widget.patientDetailsData[0].palcare.length; a++) {
      if (widget.patientDetailsData[0].palcare[a].palcare == 'akps') {
        print(
            'AKPS per: ${widget.patientDetailsData[0].palcare[a].akps.persentage}');
        setState(() {
          selectedData =
              widget.patientDetailsData[0].palcare[a].akps.persentage;
        });

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('AKPS'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: InkWell(
                child: Icon(
                  Icons.info_outlined,
                ),
                onTap: () {
                  Get.to(ReferenceScreen(Ref_list: ref_controller.APKS_Ref_list,));
                },
              ),
            ),
          ],
        ),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _controller.akpsData.length,
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
                                      SizedBox(width:20.0),
                                      Card(
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: _controller
                                                            .akpsData[index]
                                                            .isSelected
                                                        ? Colors.green
                                                        : Colors.black
                                                            .withAlpha(100)),
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: _controller
                                                    .akpsData[index].isSelected
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
                                      for (var i = 0;
                                          i < _controller.akpsData.length;
                                          i++) {
                                        _controller.akpsData[i].isSelected =
                                            false;
                                      }

                                      _controller.akpsData[index].isSelected =
                                          !_controller
                                              .akpsData[index].isSelected;
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
                                        _controller.akpsData[index].optionname
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
                      );
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
                          var selectedData = _controller.akpsData.firstWhere(
                              (element) => element.isSelected == true);
                          // print(jsonEncode(selectedData))
                          Map data = {
                            'palcare': 'akps',
                            'lastUpdate': '${DateTime.now()}',
                            'akps': selectedData
                          };

                          // print('{"akps": ${selectedData}}');
                          // var a = '{"akps": ${selectedData}}';
                          // print(data);

                          print(widget.patientDetailsData[0].name);
                          print(selectedData.persentage);


                          checkConnectivityWithToggle(widget.patientDetailsData[0].hospital[0].sId).then((internet){
                            if(internet!=null && internet){
                               _controller.saveData(widget.patientDetailsData[0], data).then((value) {
                                print('getback');
                                _historyController.saveHistory(
                                    widget.patientDetailsData[0].sId,
                                    ConstConfig.akpsHistory,
                                    selectedData.persentage);
                              });
                            }else{
                              _controller.saveDataOffline(widget.patientDetailsData[0], data);
                            }

                          });


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
}
