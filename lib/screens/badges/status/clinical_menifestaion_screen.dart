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
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/status_controller/aspectDeficienciesController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';



class ClinicalManifest extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String id;
  final String title;
  final String HistoryKey;
  final List<NRSListData> selectedLastTime;
  final List<Options> list;
  ClinicalManifest({this.patientDetailsData, this.id, this.title,this.selectedLastTime,this.HistoryKey,this.list});

  @override
  _ClinicalManifestState createState() => _ClinicalManifestState();
}

class _ClinicalManifestState extends State<ClinicalManifest> {
  int _isBMI = 0;

  final MNAController _controller = MNAController();
  final HistoryController _historyController = HistoryController();
  final AspectDeficienciesController _aspectDeficienciesController = AspectDeficienciesController();

  @override
  void initState() {
    // TODO: implement initState
    getselectedData();

    _controller.getData(widget.id).then((value) => {

      for(var a =0;a<_controller.allData.length;a++){

        for(var b=0;b<_controller.allData[a].options.length;b++){

          if(SelectedId.contains(_controller.allData[a].options[b].sId)){
            setState(() {
              _controller.allData[a].options[b].isSelected =true;
              _controller.allData[a].selectedQ =true;
            })


          }
        }

      }
    });

    super.initState();
  }


  List SelectedId = [];
  getselectedData(){
    for(var i=0;i<widget.list.length;i++){

      print(widget.list[i].sId);
      // for(var b =0;b<widget.list.length;b++){
      //
      //
        if(widget.list[i].isSelected) {
          SelectedId.add(widget.list[i].sId);
        }
      // }

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
      controller: _pageController, physics:new NeverScrollableScrollPhysics() ,
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
            appBar: BaseAppbar(
                "${widget.title}",
                null),
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
                    text: currentIndex != _controller.allData.length - 1
                        ? "next".tr
                        : "save".tr,
                    myFunc: () {
                      print(_controller.allData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != _controller.allData.length - 1) {

                          if(e.selectedQ==true){

                            // for(var a =0;a<e.)

                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );



                          }else{
                            ShowMsg('choose_one'.tr);
                          }


                        } else {
                          if(e.selectedQ==true){
                            print('complete');
                            onSaved();
                          }else{
                            ShowMsg('please_choose_atleast_one_option'.tr);
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
                                SizedBox(width:
                                  20.0,),
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

                          if(e.selectedQ==true){



                            _pageController.animateToPage(
                              currentIndex + 1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );



                          }else{
                            ShowMsg('please_choose_atleast_one_option'.tr);
                          }


                        } else {

                          if(e.selectedQ==true){
                            print('complete');
                            onSaved();
                          }else{
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
    List <NRSListData>selectedList = [];

    for (var a = 0; a < _controller.allData.length; a++) {
      if(_controller.allData[a].selectedQ){
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(_controller.allData[a]);
      }
    }



    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    int count = 0;

    // for (var q = 0; q < selectedList.length; q++) {
    //   print(selectedList[q].options);
    //
    //   for (var s = 0; s < selectedList[q].options.length; s++) {
    //     if (selectedList[q].options[s].isSelected == true) {
    //       // print('total score: ${count+ int.parse(selectedList[q].options[s].score)}');
    //       // print('int score: ${selectedList[q].options[s].score}');
    //
    //       int a = int.parse(selectedList[q].options[s].score);
    //       setState(() {
    //         count = count + a;
    //       });
    //     }
    //   }
    // }

    print('total score: $count');


    Map data = {
      'status': aspectDeficiencies.clinical,
      'score': count.toString(),
      'lastUpdate': '${DateTime.now()}',
      'data': selectedList
    };

    print('data json: ${jsonEncode(data)}');


    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){

      if(internet!=null && internet){

        _aspectDeficienciesController.saveData(widget.patientDetailsData, 0, aspectDeficiencies.clinical, data).then((value){
          _historyController.saveMultipleMsgHistory(widget.patientDetailsData.sId, widget.HistoryKey, selectedList);
        });

      }else{
        _aspectDeficienciesController.saveDataOffline(widget.patientDetailsData, selectedList, count, data, aspectDeficiencies.clinical);
      }

    });






  }






}
