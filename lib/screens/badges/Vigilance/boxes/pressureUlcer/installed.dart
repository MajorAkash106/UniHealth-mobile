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
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/installed_second.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class Installed extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  Installed({this.patientDetailsData});

  @override
  _InstalledState createState() => _InstalledState();
}

class _InstalledState extends State<Installed> {
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final HistoryController _historyController = HistoryController();

  final PressureController _controller = PressureController();

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    _controller.getData(JsonFilePath.installed).then((value) {
      var a = _controller.allData.firstWhere(
          // (element) => element.statusquestion == "SUSPECTED DEEP TISSUE INJURY",
          (element) => element.statusId == "SUSPECTED DEEP TISSUE INJURY",
          orElse: () => null);

      _controller.allData.remove(a);

      setState(() {});
      print('selcted ids : ${SelectedId}');

      if (!SelectedId.isNullOrBlank) {
        for (var a in _controller.allData) {
          for (var b in a.options) {
            print(b.sId);
            if (SelectedId.contains(b.statusoption)) {
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
    _controller
        .getPriviousData(
            widget.patientDetailsData,
            VigiLanceBoxes.pressureUlcer,
            VigiLanceBoxes.pressureUlcer_installed_status)
        .then((resp) {
      if (resp != null) {
        for (var a in resp.result.first.installedData) {
          for (var b in a.options) {
            if (b.isSelected) {
              SelectedId.add(b.statusoption);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar("installed".tr, null),
        body: Container(
            child: Column(
          children: [
            Expanded(
                child: Obx(
              () => ListView(
                children:
                    _controller.allData.map((e) => _checkboxWidget(e)).toList(),
              ),
            )),
            Padding(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20),
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
                            "confirm".tr,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          onSaved();
                          // Get.to(InstalledSecond(patientDetailsData: widget.patientDetailsData,));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
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
        Column(
            children: e.options
                .map((e2) => Padding(
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
                                                  color: e2.isSelected
                                                      ? Colors.green
                                                      : Colors.black
                                                          .withAlpha(100)),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: e2.isSelected
                                              ? Icon(Icons.check,
                                                  size: 20.0,
                                                  color: Colors.green)
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
                                  //    //(c.statusquestion!='DEPTH UNKNOWN' && c.statusquestion!='SUSPECTED DEEP TISSUE INJURY')

                                  // if (e.statusquestion != 'DEPTH UNKNOWN' && e.statusquestion != 'SUSPECTED DEEP TISSUE INJURY') {
                                  for (var c in _controller.allData) {
                                    // if (c.statusquestion != e.statusquestion) {
                                    if (c.statusId != e.statusId) {
                                      c.selectedQ = false;
                                      for (var d in c.options) {
                                        d.isSelected = false;
                                      }
                                    }
                                  }
                                  e2.isSelected = !e2.isSelected;
                                  e.selectedQ = e2.isSelected;
                                  // } else {
                                  //   e2.isSelected = !e2.isSelected;
                                  //   e.selectedQ = e2.isSelected;
                                  // }

                                  setState(() {});
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
                                      e2.statusoption,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black54,
                                          fontSize: 14),
                                    ),
                                  ),
                                ),
                                e2.file.isNullOrBlank
                                    ? SizedBox()
                                    : Container(
                                        height: 200,
                                        margin: EdgeInsets.only(top: 10),
                                        width: double.infinity,
                                        child: Image.asset(
                                          e2.file ?? "",
                                          fit: BoxFit.fill,
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList()),

        Divider()
        // SizedBox(height: 30.0,),
      ],
    );
  }

  onSaved() {
    List<NRSListData> selectedList = [];

    String stage;
    bool next = false;
    for (var a = 0; a < _controller.allData.length; a++) {
      if (_controller.allData[a].selectedQ) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(_controller.allData[a]);
        // if (_controller.allData[a].statusquestion.contains('STAGE') || _controller.allData[a].statusquestion.contains('DEPTH UNKNOWN')) {
        if (_controller.allData[a].statusId.contains('STAGE') || _controller.allData[a].statusId.contains('DEPTH UNKNOWN')) {
          stage = _controller.allData[a].statusquestion;
        }
        // if (_controller.allData[a].statusquestion.contains('STAGE 1') || _controller.allData[a].statusquestion.contains('STAGE 2')) {
        if (_controller.allData[a].statusId.contains('STAGE 1') || _controller.allData[a].statusId.contains('STAGE 2')) {
          next = true;
        }
      }
    }

    // print('selected data: ${jsonEncode(selectedList[1])}');
    print('selected data length : ${selectedList.length}');
    print('selected stage : ${stage}');

    if (next) {
      Get.to(InstalledSecond(
        patientDetailsData: widget.patientDetailsData,
        selectedList: selectedList,
      ));
    } else {
      _controller.onSavedInstalled(
          widget.patientDetailsData, selectedList, stage);
    }
  }
}
