import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

import '../ons.dart';

class INFUSION extends StatefulWidget {
  final String selctedText;
  final String selected_surgery_op;
  INFUSION({this.selctedText, this.selected_surgery_op});
  @override
  _INFUSIONState createState() => _INFUSIONState();
}

class _INFUSIONState extends State<INFUSION> {
  List<staticList>listOption = <staticList> [];
  String radio_value;
  List<Infusion> _infusion = [
    Infusion(false, "no_register_of_infusion".tr),
    Infusion(false, "infusion_error".tr),
    Infusion(false, "medical_order".tr),
    Infusion(false, "orotracheal_intubation_extubation".tr),
    Infusion(false, "fasting_for_procedures_surgery".tr),
    Infusion(false, "abdominal_distension".tr),
    Infusion(false, "_vomiting".tr),
    Infusion(false, "diarrhea_".tr),
    Infusion(false, "patient_refused".tr),
    Infusion(false, "high_gastric_residual_volume".tr),
    Infusion(false, "unknown_other".tr),


  ];



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOption.add(staticList(optionText: 'yes',isSelected: widget.selected_surgery_op=="yes"?true:false));
    listOption.add(staticList(optionText: 'no',isSelected: widget.selected_surgery_op=="no"?true:false));
  if(!widget.selctedText.isNullOrBlank){
    for(var a in _infusion){
      if(a.Agreement_desc.contains(widget.selctedText)){
        a.selected = true;
        break;
      }
    }
  }
  if(!widget.selected_surgery_op.isNullOrBlank){
      selectedIndexTeam = widget.selected_surgery_op=="yes"?0:1;

  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("infusion".tr, null),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Column(
              children: [
                InkWell(
                  child: Text("abdominal_surgery_post_op".tr,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),onTap: (){
                    print(widget.selected_surgery_op);
                },
                ),

                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                  Container(
                    // color: Colors.red,
                    width: 95.0,
                    child: _radioWidget(listOption[0],
                        listOption),
                  ),
                  Container(
                    // color: Colors.red,
                    width: 95.0,
                    child: _radioWidget(listOption[1],
                        listOption),
                  ),
                ]

                )
              ],
            ),
          ) ,
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'justificative_for_reduced_infusion'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _infusion.length,
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
                                            color: _infusion[index].selected
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: _infusion[index].selected
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
                                  for (var a in _infusion) {
                                    if (a.Agreement_desc !=
                                        _infusion[index].Agreement_desc) {
                                      a.selected = false;
                                    }
                                  }

                                  _infusion[index].selected =
                                      !_infusion[index].selected;
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
                                    _infusion[index]
                                        .Agreement_desc
                                        .toUpperCase(),
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
          //Spacer(),
          // SizedBox(
          //   height: 30.0,
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 10, bottom: 20),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primary_color,
                child: Center(
                  child: Text(
                    'confirm'.tr,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  if(selectedIndexTeam.isNullOrBlank){

                    ShowMsg("please_answer_abdominal_surgery".tr) ;
                  }
                  // else if(){}
                  else{
                    var data = _infusion.firstWhere((element) => element.selected == true, orElse: (){
                      ShowMsg("please_awnser_justification".tr) ;
                    });
                        print(radio_value.runtimeType);
                          print(selectedIndexTeam.runtimeType);
                        if(data!= null) {
                     Get.back(result: Reduced_options(
                       surgery_postOp: selectedIndexTeam == 0 ? 'yes' : 'no',
                    selected_reason: data.Agreement_desc));
                        }
                  }


                },
              ),
            ),
          ),
        ],
      ),
    );
  }
  int selectedIndexTeam ;

  Widget _radioWidget(staticList e, var optionlist) {
    return Padding(
        padding: const EdgeInsets.only(right: 1, left: 1, top: 15),
        child: GestureDetector(
          onTap: () {
            // setState(() {
            //   for (var a in listOptionTab) {
            //     setState(() {
            //       a.isSelected = false;
            //     });
            //   }
            //   e.isSelected = true;
            // });

            setState(() {
              for (var a in optionlist) {
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;

              selectedIndexTeam = optionlist.indexOf(e);
              print(selectedIndexTeam);
            });
          },
          child: Container(
            child: Row(
              children: [
                e.isSelected
                    ? Icon(
                  Icons.radio_button_checked,
                  size: 25,
                  color: primary_color,
                )
                    : Icon(
                  Icons.radio_button_off,
                  size: 25,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(
                      '${e.optionText}'.tr,
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        ));
  }
}

class Infusion {
  String Agreement_desc;
  bool selected;
  Infusion(this.selected, this.Agreement_desc);
}

class Reduced_options{
  String surgery_postOp;
  String selected_reason;
  Reduced_options({this.surgery_postOp, this.selected_reason});
}