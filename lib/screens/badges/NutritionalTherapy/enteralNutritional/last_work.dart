import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/EnteralNutritionScreen.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusion_report_screen.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet.dart';

import '../../../blank_screen_loader.dart';

class LastWork extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  TextEditingController currentWork;
  TextEditingController infusedReason;
  TextEditingController surgery_postop;
  TextEditingController is_alertEnabled = TextEditingController();
  Function accessFluid;

  LastWork({this.patientDetailsData,this.currentWork,this.infusedReason,this.accessFluid,this.surgery_postop,this.is_alertEnabled});
  @override
  _LastWorkState createState() => _LastWorkState();
}

class _LastWorkState extends State<LastWork> {
  final EnteralNutritionalController _controller = EnteralNutritionalController();

  EnteralData _data;
  IndustrializedData _IndustdataLast;
  ManipulatedData _ManidataLast;

  @override
  void initState() {
    // TODO: implement initState

    print(
        '************************************************************************');
    getData();
    computeData();



    super.initState();
  }

  getData() async {
    var workday;

    await getWorkingDays(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      workday = value;
    });

    await _controller.getEnternalData(widget.patientDetailsData).then((resp) {
      if (resp != null) {

       for(var a in resp.industDetailsData){

         var _todaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
         var _yesterdaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

         var _lastDate = DateTime.parse(a.lastUpdate);

         print('------------dates data-----------------');

         print(_todaydate);
         print(_yesterdaydate);
         print(_lastDate);
         print(_lastDate.isAfter(_yesterdaydate) && _lastDate.isBefore(_todaydate));

         if (_lastDate.isAfter(_yesterdaydate) && _lastDate.isBefore(_todaydate)) {
           _data = resp;
           _IndustdataLast = a;

           break;
         }
       }



       for(var a in resp.maniDetailsData){

         var _todaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
         var _yesterdaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

         var _lastDate = DateTime.parse(a.lastUpdate);

         print('------------dates data-----------------');
         print(_todaydate);
         print(_yesterdaydate);
         print(_lastDate);
         print(_lastDate.isAfter(_yesterdaydate) && _lastDate.isBefore(_todaydate));

         if (_lastDate.isAfter(_yesterdaydate) && _lastDate.isBefore(_todaydate)) {
           _data = resp;
           _ManidataLast = a;

           break;
         }
       }


     for(var a in resp.lastSelected){

       var _todaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
       var _yesterdaydate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');

       if(DateTime.parse(a.date).isAfter(_yesterdaydate) && DateTime.parse(a.date).isBefore(_todaydate)){

         lastIndex = int.parse(a.index);

       }

     }


      }
      // _data = resp;
    });
  }


  int lastIndex;

  void computeData() async {
    List<vigi_resultData> data = [];
    await getFluidBalanace(widget.patientDetailsData).then((resp) {
      if (resp != null) {
        for (var a in resp.result[0].data) {
          if (a.item.toLowerCase().contains('enteral'.toLowerCase())) {
            print('yre');

            data.add(a);
          }
        }
      }
    });
    print('enteral related list : ${jsonEncode(data)}');
    List<vigi_resultData> ptn = [];
    List<vigi_resultData> fiber = [];
    List<vigi_resultData> nutrition = [];

    for (var a in data) {
      if (a.item
          .toLowerCase()
          .removeAllWhitespace == 'enteralnutrition') {
        nutrition.add(a);
      } else if (a.item
          .toLowerCase()
          .removeAllWhitespace
          .contains('enteralproteinmodule'.toLowerCase())) {
        ptn.add(a);
      } else if (a.item
          .toLowerCase()
          .removeAllWhitespace
          .contains('enteralfibermodule'.toLowerCase())) {
        fiber.add(a);
      }
    }

    print('ptn : ${jsonEncode(ptn)}');
    print('fiber : ${jsonEncode(fiber)}');
    print('nutrition : ${jsonEncode(nutrition)}');
    filterData(nutrition, fiber, ptn);
  }

  double nutrition_in = 0.0;
  double nutrition_out = 0.0;

  double ptn_in = 0.0;
  double ptn_out = 0.0;

  double fiber_in = 0.0;
  double fiber_out = 0.0;

  void filterData(
    List<vigi_resultData> nutritional,
    List<vigi_resultData> fiber,
    List<vigi_resultData> ptn,
  ) async {
    var workday;
    await getWorkingDays(widget.patientDetailsData.hospital.first.sId)
        .then((value) {
      workday = value;
    });
    var _todaydate = DateTime.parse(
        '${DateFormat(commonDateFormat).format(DateTime.now())} ${workday}:00');
    var _yesterdaydate = DateTime.parse(
        '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workday}:00');


    //for nutritional
    for (var a in nutritional) {
      print('date :---------  ${a.date} ${a.time}:00');

      var eventDate = DateTime.parse("${a.date} ${a.time}:00");
      print(eventDate);

      print("${eventDate.isAfter(_yesterdaydate)}");

      if (eventDate.isAfter(_yesterdaydate) && eventDate.isBefore(_todaydate)) {
        if (a.intOut == '0') {
          print('nutrition in : ${a.ml}');
          nutrition_in = nutrition_in + double.parse(a.ml);
        } else {
          nutrition_out =  nutrition_out + double.parse(a.ml);
        }
      }
    }

    //for fiber
    for (var a in fiber) {
      print('date :---------  ${a.date} ${a.time}:00');

      var eventDate = DateTime.parse("${a.date} ${a.time}:00");
      print(eventDate);

      print("${eventDate.isAfter(_yesterdaydate)}");

      if (eventDate.isAfter(_yesterdaydate) && eventDate.isBefore(_todaydate)) {
        if (a.intOut == '0') {
          fiber_in = fiber_in + double.parse(a.ml);
        } else {
          fiber_out = fiber_out + double.parse(a.ml);
        }
      }
    }

    //for ptn
    for (var a in ptn) {
      print('date :---------  ${a.date} ${a.time}:00');

      var eventDate = DateTime.parse("${a.date} ${a.time}:00");
      print(eventDate);

      print("${eventDate.isAfter(_yesterdaydate)}");

      if (eventDate.isAfter(_yesterdaydate) && eventDate.isBefore(_todaydate)) {
        if (a.intOut == '0') {
          ptn_in = ptn_in + double.parse(a.ml);
        } else {
          ptn_out = ptn_out + double.parse(a.ml);
        }
      }
    }


    setState(() {});
  }


  double infusedValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return _data.isNullOrBlank
        ? SizedBox()
        : Column(
            children: [
              InkWell( onTap: (){
                print(widget.is_alertEnabled.text);
              },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "last_work_day".tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        new FutureBuilder(
                            future: _controller.getLastWorkDayDate(
                                widget.patientDetailsData.hospital.first.sId),
                            initialData: '',
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              String data = snapshot.data;
                              return Text(
                                "$data",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              );
                            })
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // _returnResult(),
             Padding(
    padding: const EdgeInsets.all(8.0),
    child: CustomButton(
    text:
    "access_enteral_nt_report".tr,
    myFunc: () {
    print('kk');
    Get.to(InfusionReport(title: 'Enteral Nutrition/Modules Infusion',patientDetailsData: widget.patientDetailsData,formula_status: "enteral",isFromEn: true,type: "Enteral Nutrition",isFromPn: false,)).then((value) {
      print('activity ${value}');
      if (value!=null&&value ) {

        Get.to(BlankScreen(
          function: () {
            final PatientSlipController
            _patientSlipController =
            PatientSlipController();

            _patientSlipController
                .getDetails(
                _patientSlipController.patientDetailsData[0].sId,
                0)
                .then((val) {
              Get.to(EnteralNutritionScreen(patientDetailsData: _patientSlipController.patientDetailsData[0],));
            });
          },
        ));
      }
    });
    // Get.to(INFUSION());
    },
    ),
    ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                  child: Text(
                "infused_prescribed".tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [

                    // _infused(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'enteral_nutrition'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 160,
                          // child: CustomButton(
                          //   text: "${nutrition_in}/${_IndustdataLast?.currentWork?.isNullOrBlank?_ManidataLast.currentWork:_IndustdataLast.currentWork} mL",
                          //   myFunc: () {
                          //
                          //     print('nutritional ----   ${nutrition_in} ${nutrition_out}');
                          //     print('fiber ----   ${fiber_in} ${fiber_out}');
                          //     print('ptn ----   ${ptn_in} ${ptn_out}');
                          //
                          //   },
                          // ),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(15.0),
                            onPressed: (){

                              double per;
                              if(_IndustdataLast?.currentWork.isNullOrBlank){
                                per = _ManidataLast.currentWork.isNullOrBlank?0.0: double.parse(_ManidataLast.currentWork.isNullOrBlank?'0.0':_ManidataLast.currentWork) * 80.0/100.0;
                              }else{
                                per = _IndustdataLast.currentWork.isNullOrBlank?0.0: double.parse(_IndustdataLast.currentWork.isNullOrBlank?'0.0':_IndustdataLast.currentWork) * 80.0/100.0;
                              }

                              if(nutrition_in/0.75 <per || nutrition_in/0.75 == 0.0){

                                print('per : ${per}');

                                Get.to(INFUSION(selctedText: widget.infusedReason.text,selected_surgery_op: widget.surgery_postop.text,)).then((res){

                                  if(res!=null){
                                    Reduced_options d = res;
                                    // print('retuen INFUSION : ${d.selected_reason}');
                                    print('retuen INFUSION : ${d.surgery_postOp}');
                                     widget.infusedReason.text = d.selected_reason;
                                     widget.surgery_postop.text = d.surgery_postOp;
                                    setState(() {});
                                  }

                                });

                              }


                            },
                            color: primary_color,
                            textColor: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Text("${(nutrition_in/0.75).toStringAsFixed(2)}/${_IndustdataLast?.currentWork?.isNullOrBlank?_ManidataLast.currentWork:_IndustdataLast.currentWork} mL", style: TextStyle(fontSize: 13)),
                              _infused()
                            ],),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'protein_module'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 160,
                          child: _protienModule()
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'fiber_module'.tr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 160,
                          child:_fiberModule()
                        )
                      ],
                    )
                  ],
                ),
              ),

             // Container(
             //     margin: EdgeInsets.only(top: 10),
             //     child:  CustomButton(myFunc: (){
             //     widget.accessFluid();
             //     },text: 'Access Fluid Balance',)),
              //
              // Container(
              //     width: Get.width,
              //     height: 45.0,margin: EdgeInsets.only(top: 10),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10.0),
              //         color: Colors.black12),
              //     child: Center(
              //       child: Text(
              //         "Access Fluid Balance",
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold),
              //       ),
              //     )),

              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 3.0,
                color: Colors.black12,
                thickness: 2,
              ),
              SizedBox(
                height: 15.0,
              ),
            ],
          );
  }

// String infusedReason;
  Widget _infused(){
    double per;
    if(_IndustdataLast?.currentWork.isNullOrBlank){
       per = _ManidataLast.currentWork.isNullOrBlank?0.0: double.parse(_ManidataLast.currentWork.isNullOrBlank?'0.0':_ManidataLast.currentWork) * 80.0/100.0;
    }else{
      per = _IndustdataLast.currentWork.isNullOrBlank?0.0: double.parse(_IndustdataLast.currentWork.isNullOrBlank?'0.0':_IndustdataLast.currentWork) * 80.0/100.0;
    }



     // print('per : ${per} ${ widget.currentWork.text} ${nutrition_in/0.75}');

    if(nutrition_in/0.75 < per || nutrition_in/0.75 == 0.0) {
      widget.is_alertEnabled.text ="true";

      print("nutrition_in");
      print(nutrition_in);
      print(per);
      // return Column(
      //   mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //   Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Text(
      //         'Infused',
      //         style: TextStyle(fontWeight: FontWeight.bold),
      //       ),
      //       Container(
      //           width: 150,
      //           child:
      //           // CustomButton(
      //           //   text: "${nutrition_in}ml",
      //           //   myFunc: () {
      //           //
      //           //     print('nutritional ----   ${nutrition_in} ${nutrition_out}');
      //           //     print('fiber ----   ${fiber_in} ${fiber_out}');
      //           //     print('ptn ----   ${ptn_in} ${ptn_out}');
      //           //
      //           //   },
      //           // ),
      //           RaisedButton(
      //             shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10.0),
      //             ),
      //             padding: EdgeInsets.all(15.0),
      //             onPressed: () {
      //               Get.to(INFUSION(selctedText: widget.infusedReason.text,)).then((res){
      //
      //                 if(res!=null){
      //                   print('retuen INFUSION : $res');
      //                   widget.infusedReason.text = res;
      //                   setState(() {});
      //                 }
      //
      //               });
      //             },
      //             color: primary_color,
      //             textColor: Colors.white,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //               Text("${nutrition_in} mL ", style: TextStyle(fontSize: 14)),
      //               Icon(Icons.warning_amber_outlined, color: Colors.yellow,
      //                 size: 18,)
      //             ],),
      //           )
      //       )
      //     ],
      //   ),
      //     widget.infusedReason.text.isNullOrBlank?SizedBox(): Padding(
      //    padding: EdgeInsets.only(top: 5,bottom: 5),
      //    child:  AutoSizeText(
      //
      //      "REASON : ${widget.infusedReason.text.toUpperCase()}",
      //      style: TextStyle(
      //          fontWeight: FontWeight.normal,
      //          color: Colors.black54,
      //          fontSize: 14),
      //      maxLines: 1,
      //    )
      //  ),
      //   SizedBox(
      //     height: 5.0,
      //   ),
      // ],);
      return Icon(Icons.warning_amber_outlined, color: Colors.yellow,
        size: 18,);
    }else{
      widget.is_alertEnabled.text ="false";

      return SizedBox();
    }
  }



  Widget _returnResult(){

    if(_IndustdataLast.title.isNullOrBlank){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          text:
          "${_ManidataLast.title} (${_ManidataLast.mlDose}/${_ManidataLast.dosesData.length}/${_ManidataLast.currentWork})",
          myFunc: () {
            print('kk');
            // Get.to(INFUSION());
          },
        ),
      );
    }else{
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child:  CustomButton(
          text:
          "${_IndustdataLast.title} (${_IndustdataLast.mlHr}/${_IndustdataLast.hrDay}/${_IndustdataLast.currentWork})",
          myFunc: () {
            print('kk');
            // Get.to(INFUSION());
          },
        )
      );
    }


  }

  Widget _protienModule(){
    if(_IndustdataLast.title.isNullOrBlank){
      return  CustomButton(
        text: "${ptn_in.toStringAsFixed(2)}/${_ManidataLast.enData.protienModluleDetail.total_vol.isNullOrBlank?0.0:_ManidataLast.enData.protienModluleDetail.total_vol} mL",
        myFunc: () {},
      );
    }else{
      return CustomButton(
        text: "${ptn_in.toStringAsFixed(2)}/${_IndustdataLast.enData.protienModluleDetail.total_vol.isNullOrBlank?0.0:_IndustdataLast.enData.protienModluleDetail.total_vol} mL",
        myFunc: () {},
      );
    }


  }

  Widget _fiberModule(){
    if(_IndustdataLast.title.isNullOrBlank){
      return CustomButton(
        text: "${fiber_in.toStringAsFixed(2)}/${_ManidataLast.enData.fiberModluleDetail.total_vol.isNullOrBlank?0.0:_ManidataLast.enData.fiberModluleDetail.total_vol} mL",
        myFunc: () {},
      );
    }else{
      return CustomButton(
        text: "${fiber_in.toStringAsFixed(2)}/${_IndustdataLast.enData.fiberModluleDetail.total_vol.isNullOrBlank?0.0:_IndustdataLast.enData.fiberModluleDetail.total_vol} mL",
        myFunc: () {},
      );
    }



  }

}
