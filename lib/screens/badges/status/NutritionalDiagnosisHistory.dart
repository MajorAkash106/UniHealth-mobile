import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';

import '../../../config/cons/string_keys.dart';
import '../../../config/widgets/unihealth_button.dart';


class NutrintionalDiagnosisHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  NutrintionalDiagnosisHistory({this.patientDetailsData});
  @override
  _NutrintionalDiagnosisHistoryState createState() => _NutrintionalDiagnosisHistoryState();
}

class _NutrintionalDiagnosisHistoryState extends State<NutrintionalDiagnosisHistory> {


  final NutritionalScreenController _controller = NutritionalScreenController();
  final PatientSlipController _patientSlipController = PatientSlipController();

  @override
  void initState() {
    // TODO: implement initState

    // _controller.getData('2');
    _controller.getData(JsonFilePath.nutritionalDiagnosisBox);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('history'.tr, null),
      body: Obx(
            () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: ListView(
                children: _controller.listData.map((e) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      // e.statusname =="ESPEN"? SizedBox() :
                      //
                      // e.statusname =="WHO"? SizedBox() :
                      _cardwidget("${e.statusname}"== "WHO"?"${e.statusname}/${'cdc'.tr}" : "${e.statusname}", 'path', () {
                        // if(e.statusname =="ESPEN") {
                        if (e.sId == AppString.espen) {

                          Get.to(DiagnosisHistory(patientDetailsData: widget.patientDetailsData,HistorName: e.statusname,type: ConstConfig.ESPENHistory,));
                          //
                          // getAgeYearsFromDate(widget.patientDetailsData.dob).then((age){
                          //
                          //   print('patients age: $age');
                          //   if(age>=19){
                          //     Get.to(ESPENScreen(patientDetailsData: widget.patientDetailsData,));
                          //
                          //     // Get.to(Anthropometery(patientDetailsData: widget.patientDetailsData,isFromAnthroTab: true,));
                          //   }else{
                          //     print('go to espen');
                          //     ShowMsg('Sorry! patient age is less than 19 years');
                          //   }
                          //
                          // });
                          //


                        // }else if(e.statusname =="WHO"){
                        } else if (e.sId == AppString.who) {
                          openDialogAsk();

                          // print(widget.patientDetailsData.dob);
                          // getAgeYearsFromDate(widget.patientDetailsData.dob).then((age){
                          //
                          //   print('patients age: $age');
                          //   if(age>=19){
                          //     ShowMsg('Sorry! patient age is more than 19 years');
                          //     // Get.to(Anthropometery(patientDetailsData: widget.patientDetailsData,isFromAnthroTab: true,));
                          //   }else{
                          //     print('go to who');
                          //     Get.to(WHOScreen(patientDetailsData: widget.patientDetailsData,));
                          //   }
                          //
                          // });

                        // }else if(e.statusname =="GLIM"){
                        } else if (e.sId == AppString.glim) {

                          Get.to(DiagnosisHistory(patientDetailsData: widget.patientDetailsData,HistorName: e.statusname,type: ConstConfig.GLIMHistory,));

                        }else{
                          // Get.to(FreeTextScreen(
                          //   text: "${e.statusname}",
                          //   function: () {
                          //     Get.back();
                          //   },
                          // ));
                        }

                      }),
                    ],
                  );
                }).toList()),
          ),
        ),
      ),
    );
  }
  Widget _cardwidget(String text,String path,Function _function){
    return  InkWell(
      onTap:_function,
      child: Column(
        children: [
          Card(
              color: primary_color,
              shape: RoundedRectangleBorder(
                borderRadius:BorderRadius.all(Radius.circular(15)),
                // side: BorderSide(width: 5, color: Colors.green)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Center(child: Text("$text",style: TextStyle(color: card_color,fontSize: 20,fontWeight: FontWeight.normal),)),
                child: ListTile(title: Text(
                  "$text",
                  style: TextStyle(
                      color: card_color,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                ),trailing: Icon(Icons.arrow_forward,color: Colors.white,),),
              )
          ),
        ],
      ),
    );
  }


  openDialogAsk() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "choose_one".tr,
                        style: TextStyle(color: primary_color),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Column(
                        children: [
                          Container(
                            width: Get.width,
                            child: RaisedButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      width: 1.0, color: primary_color)),
                              padding: EdgeInsets.all(15.0),
                              onPressed: () async {
                                Get.back();
                                Get.to(DiagnosisHistory(patientDetailsData: widget.patientDetailsData,HistorName: "${'history'.tr} - ${"who".tr}",type: ConstConfig.WHOHistory,));

                              },
                              color:  Colors.white,
                              textColor: primary_color,
                              child: Text("${'history'.tr} - ${"who".tr}" ,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: primary_color)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: Get.width,
                            child: RaisedButton(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(
                                      width: 1.0, color: primary_color)),
                              padding: EdgeInsets.all(15.0),
                              onPressed: () {
                                Get.back();
                                Get.to(DiagnosisHistory(patientDetailsData: widget.patientDetailsData,HistorName: "${'history'.tr} - ${"cdc".tr}",type: ConstConfig.CDCHistory,));

                              },
                              color:  Colors.white,
                              textColor: primary_color,
                              child: Text("${'history'.tr} - ${"cdc".tr}",
                                  style: TextStyle(fontSize: 14,color: primary_color)),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        color: primary_color,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "close".tr,
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

}
