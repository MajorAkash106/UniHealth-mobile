import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/status_controller/GLIMController.dart';
import 'package:medical_app/contollers/status_controller/MNAController.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/GlimModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class EtiologicScreen extends StatefulWidget {
  final List<GLIMData> EtiologicData;
  final PatientDetailsData patientDetailsData;
  final String title;
  EtiologicScreen({this.EtiologicData, this.title, this.patientDetailsData});

  @override
  _EtiologicScreenState createState() => _EtiologicScreenState();
}

class _EtiologicScreenState extends State<EtiologicScreen> {
  int _isBMI = 0;
  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  final GlimController _glimController = GlimController();
  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    getData();

  }

  List SelectedId = [];

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int currentIndex = 0;

  Future<bool> _willpopScope() {
    print('back press');
    print(widget.EtiologicData.length);
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


  getData(){
    for(var x in widget.patientDetailsData.status){
      if (x.type == '2' && x.status == nutritionalDiagnosis.glim){

        print('yesss');
        Etiologic etiologic = x.result[0].etiologic;

        if(!etiologic.isNullOrBlank){

          if(etiologic.PERCEIVED == '0' || etiologic.PERCEIVED == '1'){
          setState(() {

            PERCEIVED = true;
            PERCEIVEDValue = etiologic.PERCEIVED;

          });
          }

          print('etio data--- ${jsonEncode(etiologic.etiologicData)}');

          if(!etiologic.etiologicData.isNullOrBlank){

            for(var a in etiologic.etiologicData){

              // if(a.selectedTitle && a.title.contains('INFLAMMATION')){
              if(a.selectedTitle && a.sId == AppString.inflammation_glim){

                if(a.options[0].isSelected){

                 for(var s in  widget.EtiologicData){

                   // if(s.title.contains('INFLAMMATION')){
                   if(s.sId == AppString.inflammation_glim){

                     print('yess----------------');
                     s.selectedTitle =true;
                     s.options[0].isSelected = true;
                     setState(() {});

                     break;
                   }

                 }

                }

                break;
              }

            }

          }

        }




        break;
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
          children: widget.EtiologicData.map((e) => WillPopScope(
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
                            Get.to(ReferenceScreen(Ref_list: ref_Controller.Etological_ref_list,));
                          },
                        )),
                    body: _checkboxWidget(e)),
              )).toList(),
        ));
  }

  bool PERCEIVED = false;
  String PERCEIVEDValue = '-1';

  Widget _checkboxWidget(GLIMData e) {
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
            "${e.title}",
            style: TextStyle(fontSize: 16, fontWeight: FontBold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        e.question.isEmpty
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
                child: Text(
                  "${e.question}",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: e.options.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 20.0),
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
                                                : Colors.black.withAlpha(100)),
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
                                if (e.options[c].sId != e.options[index].sId) {
                                  e.options[c].isSelected = false;
                                  e.selectedTitle = false;
                                }
                              }

                              e.options[index].isSelected = !e.options[index].isSelected;
                              e.selectedTitle = e.options[index].isSelected;
                            });

                            // if (e.options[index].optionname.toLowerCase().contains('CHRONIC DISEASE'.toLowerCase())
                            if (e.options[index].sId == AppString.chronic_disease_glim
                                &&
                                e.selectedTitle) {
                              print('CHRONIC DISEASE RELATED');

                              setState(() {
                                PERCEIVED = true;
                              });
                            } else {
                              setState(() {
                                PERCEIVED = false;
                                PERCEIVEDValue = '-1';
                              });
                            }
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
                                e.options[index].optionname,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        !PERCEIVED
            ? SizedBox()
            :
        // e.title.contains('INFLAMMATION')?
        e.sId == AppString.inflammation_glim?
        Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 12.0, bottom: 0.0, right: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "perceived_inflammation".tr,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Card(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PERCEIVEDValue == '0'
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: PERCEIVEDValue == '0'
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
                                  PERCEIVEDValue = '0';
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'yes'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  PERCEIVEDValue = '1';
                                });
                              },
                              child: Card(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: PERCEIVEDValue == '1'
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: PERCEIVEDValue == '1'
                                        ? Icon(Icons.check,
                                            size: 20.0, color: Colors.green)
                                        : Icon(
                                            Icons.check,
                                            size: 18.0,
                                            color: Colors.transparent,
                                          )),
                                elevation: 4.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'no'.tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )):SizedBox(),
        Spacer(),
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
                        currentIndex != widget.EtiologicData.length - 1
                            ? "next".tr
                            : "save".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      print(widget.EtiologicData.length);
                      if (_pageController.hasClients) {
                        if (currentIndex != widget.EtiologicData.length - 1) {
                          _pageController.animateToPage(
                            currentIndex + 1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );

                          // if (e.selectedTitle == true) {
                          //   _pageController.animateToPage(
                          //     currentIndex + 1,
                          //     duration: const Duration(milliseconds: 400),
                          //     curve: Curves.easeInOut,
                          //   );
                          // } else {
                          //   ShowMsg('Please choose atleast one option');
                          // }
                        } else {
                          print('complete');

                          print("PERCEIVED: $PERCEIVED PERCEIVEDValue : $PERCEIVEDValue");

                         if(PERCEIVED == true && PERCEIVEDValue == '-1' ){

                           ShowMsg('please_choose_atleast_one_option'.tr);

                         }else{
                           onSaved();
                         }

                          // Get.back();

                          // if (e.selectedTitle == true) {
                          //   print('complete');
                          // onSaved();
                          // } else {
                          //   ShowMsg('Please choose atleast one option');
                          // }
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



    print("PERCEIVED: $PERCEIVED");

    List<GLIMData> selectedList = [];

    for (var a = 0; a < widget.EtiologicData.length; a++) {
      if (widget.EtiologicData[a].selectedTitle) {
        // print('selected data: ${jsonEncode(_controller.allData[a])}');
        selectedList.add(widget.EtiologicData[a]);
      }
    }




    String foodIntake = '';
    String INFLAMMATIONText = '';

    for(var i in selectedList){
      if(i.title.contains('REDUCED FOOD INTAKE') || i.title.contains('ALIMENTAÇÃO REDUZIDA') && i.selectedTitle == true){
      // if(i.createdAt.contains('REDUCED FOOD INTAKE') && i.selectedTitle == true){

       foodIntake = 'YES';

      }


      if(i.title.contains('INFLAMMATION') || i.title.contains('INFLAMAÇÃO')  && i.selectedTitle == true){
      // if(i.sId == AppString.inflammation_glim && i.selectedTitle == true){

       for(var s in i.options){

         if(s.isSelected){
           INFLAMMATIONText = s.optionname;
         }

       }

      }

    }


    print('selected data: ${jsonEncode(selectedList)}');
    print('selected data: ${selectedList.length}');

    print('foodIntake: ${foodIntake}');
    print('INFLAMMATIONText: ${INFLAMMATIONText}');

    Map data = {
      'lastUpdate': '${DateTime.now()}',
      'EtioStatus': selectedList.isEmpty ? 'Negative' : 'Positive',
      'SelectedStatus': selectedList.isEmpty ? '0' : '1',
      'PERCEIVED': PERCEIVED?PERCEIVEDValue:'',
      'EtiologicData': selectedList,
      'foodIntake': foodIntake,
      'INFLAMMATIONText': INFLAMMATIONText,
    };

    print('data json: ${jsonEncode(data)}');
    // if (selectedList.isNotEmpty) {
      Phenotypic phenotypic;
      Severity severity;
      for (var a = 0; a < widget.patientDetailsData.status.length; a++) {
        if (widget.patientDetailsData.status[a].type ==
                statusType.nutritionalDiagnosis &&
            widget.patientDetailsData.status[a].status.trim() ==
                nutritionalDiagnosis.glim.trim()) {
          Result result = widget.patientDetailsData.status[a].result[0];
          print('etiologic data: ${jsonEncode(result.phenotypic)}');
          print('severity data: ${jsonEncode(result.severity)}');
          phenotypic = result.phenotypic;
          severity = result.severity;

          break;
        }
      }

      Etiologic etiologic;

      checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){
        if(internet!=null && internet){
          _glimController.saveData(
              widget.patientDetailsData, data, '1', etiologic, phenotypic,severity);
        }else{
          _glimController.saveDataOffline(
              widget.patientDetailsData, data, '1', etiologic, phenotypic,severity).then((value){
            // Get.back();
            Get.back(result: '1');
          });
        }
      });

    // } else {
    //   Get.back();
    // }
  }
}
