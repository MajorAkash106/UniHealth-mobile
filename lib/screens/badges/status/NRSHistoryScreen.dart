import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/NRSHistory.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class NRSHistoryScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final String HistorName;
  final String historyKey;
  NRSHistoryScreen({this.patientDetailsData, this.HistorName,this.historyKey});
  @override
  _NRSHistoryScreenState createState() => _NRSHistoryScreenState();
}

class _NRSHistoryScreenState extends State<NRSHistoryScreen> {
  final NutritionalScreenController _controller = NutritionalScreenController();

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHistoryData(
            widget.patientDetailsData.sId, widget.historyKey);
        print('internet avialable');
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('${widget.HistorName}', null),
        body: Obx(
              () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: _controller.historyData.map((element) {
                  return mainWidget(element);
                }).toList(),
              ),
            ),
          ),
        ));
  }

  Widget mainWidget(NRSHistoryData e) {
    if(widget.historyKey == ConstConfig.NRSHistory) {
      return _NRSWidget(e);
    } else if(widget.historyKey == ConstConfig.STRONGKIDHistory) {
      return _KIDSWidget(e);
    }else if(widget.historyKey == ConstConfig.MUSTHistory) {
      return _MUSTWidget(e);
    }else{
      return _MNANNIWidget(e);
    }
  }

  getNRS(int score){

    if(score == 0){
      return "no_nt_risk_detected".tr.toUpperCase();
    }else if(score>=3){
      return "nt_risk".tr.toUpperCase();
    }else{
      //ask to client
      return "no_nt_risk_detected".tr.toUpperCase();
    }


  }


 getMNARESULT(int score){

    if(score == 0 || score<=7){
      return "malnourished".tr.toUpperCase();
    }else if(score>7 && score <=11){
      return "at_risk_of_malnutrition".tr.toUpperCase();
    }else if(score>11 && score <=14){
      //ask to client
      return "normal_nutritional_status".tr.toUpperCase();
    }


  }

 getSTRONGKIDS(int score){

    if(score == 0){
      return "low_risk".tr;
    }else if(score <=3){
      return "medium_risk".tr;
    }else if(score>3 && score <=5){
      //ask to client
      return "high_risk".tr;
    }


  }


  getMUST(int score){

    if(score == 0){
      return "low_risk".tr.toUpperCase();
    }else if(score ==1){
      return "medium_risk".tr.toUpperCase();
    }else if(score>=2){
      //ask to client
      return "high_risk".tr.toUpperCase();
    }


  }


  Widget _NRSWidget(NRSHistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage.map((e2) =>ExpansionTile(

                    title:
                    Row(
                      children: [
                        Text(
                          "NRS - ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                            "${getNRS(int.parse(e2.score??'0'))}",
                          style: TextStyle( fontSize: 13,color: getNRS(int.parse(e2.score??'0')).toLowerCase() == "nt_risk".tr.toLowerCase()
                                      ? redTxt_color
                                      : greenTxt_color),
                        ),
                      ],
                    ),

                    // Text(
                    //   "${getNRS(int.parse(e2.score??'0'))}",
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.normal,
                    //       color: getNRS(int.parse(e2.score??'0')).toLowerCase() == "NUTRITIONAL RISK".toLowerCase()
                    //           ?redTxt_color
                    //           : greenTxt_color
                    //          ),
                    // ),
                    children: [
                      Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: e2.data.map((e3) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8,),
                          e3.selectedQ?   Text(
                            "${e3.statusquestion}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,),
                          ):SizedBox(),
                          // e3.isSelected?   Text(
                          //   "${e3.statusoption}",
                          //   style: TextStyle(
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.normal,),
                          // ):SizedBox(),


                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: e3.options.map((e4) => e4.isSelected?  Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  "${e4.statusoption}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,),
                                ),):SizedBox(),).toList()),
                          SizedBox(height: 10,),

                        ],)).toList(),


                    ),SizedBox(height: 20,)
                    ],)).toList()
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    getTimeAgo(e.updatedAt),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: black40_color),
                  ),
                ],
              ),
              Divider()
            ]));
  }

  Widget _MNANNIWidget(NRSHistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage.map((e2) =>ExpansionTile(

                    title:   Row(
                      children: [
                        Text(
                          "MNA - ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                            "${getMNARESULT(int.parse(e2.score??'0'))}".toUpperCase(),
                          style: TextStyle( fontSize: 13,
                            color:int.parse(e2.score) <=11
                                  ?redTxt_color
                                  : greenTxt_color
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   "${getMNARESULT(int.parse(e2.score??'0'))}".toUpperCase(),
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.normal,
                    //       color: int.parse(e2.score) <=11
                    //       ?redTxt_color
                    //       : greenTxt_color
                    //   ),
                    // ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: e2.data.map((e3) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            e3.selectedQ?   Text(
                              "${e3.statusquestion}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,),
                            ):SizedBox(),
                            // e3.isSelected?   Text(
                            //   "${e3.statusoption}",
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,),
                            // ):SizedBox(),


                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e3.options.map((e4) => e4.isSelected?  Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${e4.statusoption}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,),
                                  ),):SizedBox(),).toList()),
                            SizedBox(height: 10,),

                          ],)).toList(),


                      ),SizedBox(height: 20,)
                    ],)).toList()
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    getTimeAgo(e.updatedAt),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: black40_color),
                  ),
                ],
              ),
              Divider()
            ]));
  }


  getSTRONGKIDSColors(String score){

    if(score.toLowerCase() == 'low_risk'.tr.toLowerCase()){
      return greenTxt_color;
    }else if(score.toLowerCase() == 'medium_risk'.tr.toLowerCase()){
      return Colors.orange;
    }else if(score.toLowerCase() == 'high_risk'.tr.toLowerCase()){
      //ask to client
      return redTxt_color;
    }


  }

  Widget _KIDSWidget(NRSHistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage.map((e2) =>ExpansionTile(

                    title:
                    // Text(
                    //   "${getSTRONGKIDS(int.parse(e2.score??'0'))}".toUpperCase(),
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.normal,
                    //       color: int.parse(e2.score) <=11
                    //           ?redTxt_color
                    //           : greenTxt_color
                    //   ),
                    // ),

                    Row(
                      children: [
                        Text(
                          "STRONG - KIDS - ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "${getSTRONGKIDS(int.parse(e2.score??'0'))}".toUpperCase(),
                          style: TextStyle( fontSize: 13,
                              color:getSTRONGKIDSColors(getSTRONGKIDS(int.parse(e2.score??'0')))
                              // ?redTxt_color
                              // : greenTxt_color
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: e2.data.map((e3) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            e3.selectedQ?   Text(
                              "${e3.statusquestion}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,),
                            ):SizedBox(),
                            // e3.isSelected?   Text(
                            //   "${e3.statusoption}",
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,),
                            // ):SizedBox(),


                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e3.options.map((e4) => e4.isSelected?  Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${e4.statusoption}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,),
                                  ),):SizedBox(),).toList()),
                            SizedBox(height: 10,),

                          ],)).toList(),


                      ),SizedBox(height: 20,)
                    ],)).toList()
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    getTimeAgo(e.updatedAt),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: black40_color),
                  ),
                ],
              ),
              Divider()
            ]));
  }

  Widget _MUSTWidget(NRSHistoryData e) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: e.multipalmessage.map((e2) =>ExpansionTile(

                    title:
                    // Text(
                    //   "${getSTRONGKIDS(int.parse(e2.score??'0'))}".toUpperCase(),
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.normal,
                    //       color: int.parse(e2.score) <=11
                    //           ?redTxt_color
                    //           : greenTxt_color
                    //   ),
                    // ),

                    Row(
                      children: [
                        Text(
                          "MUST - ",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "${getMUST(int.parse(e2.score??'0'))}".toUpperCase(),
                          style: TextStyle( fontSize: 13,
                            color:int.parse(e2.score??'0') ==0
                            ?redTxt_color
                            : greenTxt_color
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: e2.data.map((e3) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8,),
                            e3.selectedQ?   Text(
                              "${e3.statusquestion}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,),
                            ):SizedBox(),
                            // e3.isSelected?   Text(
                            //   "${e3.statusoption}",
                            //   style: TextStyle(
                            //     fontSize: 16,
                            //     fontWeight: FontWeight.normal,),
                            // ):SizedBox(),


                            Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: e3.options.map((e4) => e4.isSelected?  Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    "${e4.statusoption}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,),
                                  ),):SizedBox(),).toList()),
                            SizedBox(height: 10,),

                          ],)).toList(),


                      ),SizedBox(height: 20,)
                    ],)).toList()
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  Text(
                    getTimeAgo(e.updatedAt),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: black40_color),
                  ),
                ],
              ),
              Divider()
            ]));
  }
}
