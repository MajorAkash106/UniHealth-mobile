import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/abdomen/gi_DisfunctionController.dart';


class GI_Disfunction extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final Map data;
  final int points;
  GI_Disfunction({this.patientDetailsData,this.data, this.points});

  @override
  _GI_DisfunctionState createState() => _GI_DisfunctionState();
}

class _GI_DisfunctionState extends State<GI_Disfunction> {
  GI_Disfuntion_Controller gi_disfuntion_controller = GI_Disfuntion_Controller();
  final AbdomenController abdomenController = AbdomenController();
  bool isOther;
  // List<staticList> justification_list = <staticList>[staticList(optionText: "Treatment prescribed but not administrated",isSelected: false),
  //   staticList(optionText: "laxative not  prescribed",isSelected: false),
  //   staticList(optionText: "Prokinetic not prescribed",isSelected: false),
  //   staticList(optionText: "Use of madication related ot nausea/vomiting/constipation",isSelected: false),
  //   staticList(optionText: "Use of laxative.cathartic medication",isSelected: false),
  //   staticList(optionText: "Use of vasoactive drugs",isSelected: false),
  //   staticList(optionText: "Adverse event after GI surgery",isSelected: false),
  //   staticList(optionText: "Patient did not accept treatment",isSelected: false),
  //   staticList(optionText: "Problem due to lack of resources",isSelected: false),
  //   staticList(optionText: "No other cause than patient's condition was detected",isSelected: false),
  //   staticList(optionText: "Others",isSelected: false),
  //
  // ];

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
    print('d');
    gi_disfuntion_controller.get_Disfunction_Data().then((value) {
      setState(() {});
      print('data fetched');

      for(var a in gi_disfuntion_controller.gi_Disfunction_Data){
        if(selectedIds.contains(a.sId)){
          a.isSelected = true;
          if(selectedIds.contains(a.optionname=="OTHERS")){
           otherText.text=a.description;
           print("===desc ${otherText.text}");
          }
        }

      }

    });
  }


List selectedIds = [];
  void getData() {
    abdomenController.getAbdomenData(widget.patientDetailsData).then((val) {
      if (val != null) {


        for(var a in val.result[0].adverseEventData){
         if(a.isSelected){

           selectedIds.add(a.sId);
           if(a.optionname=="OTHERS"){
             otherText.text=a.description;
           }

         }
        }

      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("abdomen".tr,IconButton(
        icon: Icon(
          Icons.info_outline,
          color: card_color,
        ),
        onPressed: () {
          final Refference_Notes_Controller  refference_notes_controller = Refference_Notes_Controller();
          Get.to(ReferenceScreen(Ref_list:refference_notes_controller.abdomen_Gi_disfunction ,));

        },
      )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       height: 20.0,
                    //     ),
                    //     Text("GI Disfunction Result",
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.bold, fontSize: 16)),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height:widget.points < 3 ?0.0: 20.0,
                    // ),
                    // widget.points < 3 ?SizedBox():
                    // Center(
                    //   child: Container(
                    //     height: 50.0,
                    //     width: 180,
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.black),
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         color: Colors.pinkAccent.withAlpha(200)),
                    //     child: Center(
                    //       child: Text(
                    //         "${widget.points < 3 ? 'ABSENT' : 'PRESENT'}",
                    //         style: TextStyle(fontWeight: FontWeight.bold),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        "justificative_for_adverse_events".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    Center(
                      child: Text(
                        "leave_blank_if_none".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            gi_disfuntion_controller.gi_Disfunction_Data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, bottom: 12.0, right: 15.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                                  color: gi_disfuntion_controller
                                                                          .gi_Disfunction_Data[
                                                                              index]
                                                                          .isSelected
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .black
                                                                          .withAlpha(
                                                                              100)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                          child: gi_disfuntion_controller
                                                                  .gi_Disfunction_Data[
                                                                      index]
                                                                  .isSelected
                                                              ? Icon(
                                                                  Icons.check,
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

                                                    gi_disfuntion_controller
                                                            .gi_Disfunction_Data[
                                                                index]
                                                            .isSelected =
                                                        !gi_disfuntion_controller
                                                            .gi_Disfunction_Data[
                                                                index]
                                                            .isSelected;
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
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      gi_disfuntion_controller
                                                          .gi_Disfunction_Data[
                                                              index]
                                                          .optionname
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: black40_color),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      gi_disfuntion_controller
                                                  .gi_Disfunction_Data[index]
                                                  .optionname
                                                  .toUpperCase() ==
                                              "OTHERS"
                                          ? gi_disfuntion_controller
                                                  .gi_Disfunction_Data[index]
                                                  .isSelected
                                              ? _textarea()
                                              : SizedBox()
                                          : SizedBox()
                                    ],
                                  )),
                            ],
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    // Spacer(),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 10, bottom: 20),
            child: Container(
                width: Get.width,
                child: CustomButton(
                  text: "confirm".tr,
                  myFunc: () {
                    onConfirm();
                  },
                )),
          ),
        ],
      ),
    );
  }

  var otherText = TextEditingController();
  Widget _textarea() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20.0),
      child: TextField(
        autofocus: false,
        style: TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
            hintText: 'Type here...',
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

  onConfirm()async {
    List<AKPSData> selectedData = [];
    for (var a in gi_disfuntion_controller.gi_Disfunction_Data) {
      if (a.isSelected) {
        print(a.optionname);

        if (a.optionname.toLowerCase().trim() == "Others".toLowerCase().trim()) {
          a.optionname = "OTHERS";
          a.description = otherText.text;
        }

        selectedData.add(a);
      }
    }

    print('selected data : ${jsonEncode(selectedData)}');
    // List<MeanIapData> meandata =[] ;

    // await abdomenController.getAbdomenData(widget.patientDetailsData).then((val) {
    //   if (val == null||val.result[0].meaIapData==null) {
    //     meandata =[];
    //     //balanceSheet = val.result[0].balanceSince;
    //   }else{
    //     meandata.addAll(val.result[0].meaIapData);
    //
    //   }
    //
    // });
   print("check on gi");
   //print("selec.. ${jsonEncode(selectedData)}");
   // print("selec.. ${jsonEncode(meandata)}");



    for(int i=0;i<selectedData.length;i++){
      if(selectedData[i].optionname=="OTHERS"){
        isOther=true;
      }else{
        isOther=false;
      }
    }

if(isOther==true){
  if(otherText.text.isNotEmpty){
    abdomenController.onSaved(widget.patientDetailsData, widget.data, selectedData, widget.points < 3 ? 'ABSENT' : 'PRESENT'/*,meandata*/);

  }else{
    ShowMsg("Description cannot be empty");
  }
}else{
  abdomenController.onSaved(widget.patientDetailsData, widget.data, selectedData, widget.points < 3 ? 'ABSENT' : 'PRESENT'/*,meandata*/);

}
     // abdomenController.onSaved(widget.patientDetailsData, widget.data, selectedData, widget.points < 3 ? 'ABSENT' : 'PRESENT'/*,meandata*/);

  }
}
