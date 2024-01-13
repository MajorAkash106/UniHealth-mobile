import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/LMSfromAgeConst.dart';
import 'package:medical_app/config/cons/LMSfromAgeConstFemale.dart';

import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/percentileFemale.dart';
import 'package:medical_app/config/funcs/percentileFunc.dart';
import 'package:medical_app/config/cons/percentileMale.dart';
import 'package:medical_app/config/funcs/whofunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/status_controller/CDC_Controller.dart';
import 'package:medical_app/contollers/status_controller/WHO_Controller_updated.dart';
import 'package:medical_app/model/LMSfromAgeModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import 'dart:math';

import 'package:medical_app/contollers/status_controller/WHO_Controller.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class WHOScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  WHOScreen({this.patientDetailsData});
  @override
  _WHOScreenState createState() => _WHOScreenState();
}

class _WHOScreenState extends State<WHOScreen> {
  final PatientSlipController _patientSlipController = PatientSlipController();
  final WHOController _whoController = WHOController();
 final CDCController _cdcController = CDCController();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  @override
  void initState() {
    // TODO: implement initState
    //
    // checkConnectivity().then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     _patientSlipController.getDetails(widget.patientDetailsData.sId, 0).then((value){
    //       getZscore();
    //     });
    //     print('internet avialable');
    //   }
    // });
    if (widget.patientDetailsData.anthropometry.isNotEmpty) {
      getAndSave();

    } else {
      print('anthropometry empty');
      Future.delayed(Duration(milliseconds: 100), () {
        // 5 seconds over, navigate to Page2.
      showAlertForEmptyData();
      });
    }
    super.initState();
  }



  getAndSave()async{
  await  getZscore();


    // checkConnectivityWithToggle(hospId).then((internet) {
    //   print('internet');
    //   if (internet != null && internet) {
    //     SaveToServer();
    //
    //     print('internet avialable');
    //   }else{
    //     SaveToServer();
    //   }
    // });



  Future.delayed(Duration(milliseconds: 100), () {
    // Do something

    SaveToServer();
  });



  }


  showAlertForEmptyData() {
    return Get.dialog(
        WillPopScope(child:  new AlertDialog(
          title: new Text(
            'who_depends_on_anthropometry'.tr,
            style: TextStyle(fontSize: 16),
          ),
          // content: new Text(
          //   'unintentional weight loss > 5% in the last three months or > 10% indefinite of time?'
          //       .toUpperCase(),
          //   style: TextStyle(fontSize: 14),
          // ),
          actions: <Widget>[
            new ElevatedButton(
              onPressed: () async {
                Get.back();
                Get.back();
                Get.back();


              },
              child: new Text('ok'.tr),
            ),
          ],
        ), onWillPop: willPopScope)
    );
  }
  Future<bool>willPopScope(){
    Get.back();
    Get.back();
  }

  Future<bool>_willPopScope()async{
    // Get.back();
    // Get.back();
   await SaveToServer();
    Get.to(Step1HospitalizationScreen(patientUserId: widget.patientDetailsData.sId, statusIndex: 2,index: 2,));
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopScope,
        child: Scaffold(
      appBar: BaseAppbar('${'who'.tr}/${'cdc'.tr}',
          null
      // IconButton(icon: Icon(Icons.refresh), onPressed: ()async{
      //
      //   WhoControllerUpdated controllerUpdated = WhoControllerUpdated();
      //
      //  WHOOutput data = await controllerUpdated.getWHO(widget.patientDetailsData);
      //   print('data.percentile :${data.percentile}');
      //   print('data.result :${data.result}');
      //   print('data.condition :${data.condition}');
      //   print('data.zScore :${data.zScore}');
      //
      //
      // })
      ),
      // bottomNavigationBar: CommonHomeButton(),
      body:widget.patientDetailsData.anthropometry.isEmpty? SizedBox():Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
             whoWidget(),




              cdcWidget(),

            ],
          ),
        ),
      ),
    ));
  }

  Widget whoWidget(){
    return Column(children: [
      SizedBox(height: 10,),
      Center(
        child: Text(
          "who".tr,
          style: TextStyle(
              color: appbar_icon_color,
              fontSize: 18,
              fontWeight: FontWeight.normal),
        ),
      ),
      SizedBox(height: 10,),
      Center(
        child: Text(
          "result_given".tr,
          style: TextStyle(
              color: appbar_icon_color,
              fontSize: 18,
              fontWeight: FontWeight.normal),
        ),
      ),
      SizedBox(height: 5,),
      Center(
        child: Text(
          "z = $ZalphaString; p = $percentile; $condtion".toUpperCase(),
          style: TextStyle(
              color: appbar_icon_color,
              fontSize: 15,
              fontWeight: FontWeight.normal),
          // maxLines: 1,overflow: TextOverflow.ellipsis,
        ),
      ),
      SizedBox(height: 70,),
      _cardwidget("${resultt??'None'}".toUpperCase(), 'path'),

    ],);
  }






  Widget cdcWidget(){

  return  FutureBuilder(
      future: _cdcController.getCDC(widget.patientDetailsData),
      builder: (context,AsyncSnapshot snapshot) {
        CDCOutput data = snapshot.data;

        if(data==null){
          return SizedBox();
        }
        return  Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 24,right: 24,top: 20),
            child: Divider(color: Colors.black45,thickness: 2,),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              "cdc".tr,
              style: TextStyle(
                  color: appbar_icon_color,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text(
              "result_given".tr,
              style: TextStyle(
                  color: appbar_icon_color,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(height: 5,),
          Center(
            child:
            Text(
              "z = ${data.zScore}; p = ${data.percentile}; ${data.condition}".toUpperCase(),
              style: TextStyle(
                  color: appbar_icon_color,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
              // maxLines: 1,overflow: TextOverflow.ellipsis,
            )

          ),
          SizedBox(height: 70,),

          _cardwidget("${data.result??'None'}".toUpperCase(), 'path')
        ],);
      },
    );


  }

  Widget _cardwidget(String text, String path) {
    return  Column(
      children: [
        Card(
            color: primary_color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              // side: BorderSide(width: 5, color: Colors.green)
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                  child: Text(
                    "$text",
                    style: TextStyle(
                        color: card_color,
                        fontSize: 20,
                        fontWeight: FontWeight.normal),
                  )),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            _patientSlipController.patientDetailsData.isEmpty
                ? SizedBox()
                : widget.patientDetailsData.anthropometry.isEmpty
                ? SizedBox()
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: TextStyle(fontSize: 15),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(right: 10, bottom: 8),
                  child: Text(
                    "Last update - ${dateFormat.format(DateTime.parse(widget.patientDetailsData.anthropometry[0].lastUpdate))}",
                    style: TextStyle(
                        color: primary_color, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  String zscore = '';

  getZscore() {
    if (widget.patientDetailsData.gender.toLowerCase() == 'male') {
      getZscoreBoys();
    } else {
      getZscoreGirls();
    }
  }

  getZscoreBoys() {
    print('Zscore boys');

    print('lenght cm: ${widget.patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print('weight kg: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReported}');
    // print('weight LBS: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReportedLBS}');

    // print('---------girls data -----------');
    // print(whogirls.lenghtCM.length);
    // print(whogirls.PoewrL.length);
    // print(whogirls.MedianM.length);
    // print(whogirls.variationS.length);
    //
    // print('---------boys data -----------');
    // print(whoboys.lenghtCM.length);
    // print(whoboys.powerL.length);
    // print(whoboys.medianM.length);
    // print(whoboys.variationS.length);

    double length = double.parse(widget.patientDetailsData.anthropometry[0].heightMeasuredReported);



    for (var a = 0; a < whoboys.lenghtCM.length; a++) {
      if (length == double.parse('${whoboys.lenghtCM[a]}')) {
        print(a);

        print('power L: ${whoboys.powerL[a]}');
        print('meidan M: ${whoboys.medianM[a]}');
        print('variation S: ${whoboys.variationS[a]}');

        double Weight = double.parse(
            widget.patientDetailsData.anthropometry[0].weightMeasuredReported);
        //
        double powerL = double.parse("${whoboys.powerL[a]}");
        double medianM = double.parse("${whoboys.medianM[a]}");
        double variationS = double.parse("${whoboys.variationS[a]}");

        // Z score = ((Weight/M) L - 1) / (L * S)
        print(
            ' Z score = ([($Weight/$medianM)power$powerL] - 1) / ($powerL * $variationS)');

        double ab = Weight / medianM;
        double cd = pow(ab, powerL) - 1;

        double total = cd / (powerL * variationS);
        print('Zscore: $total');
        setState(() {
          zscore = total.toStringAsFixed(1);
        });

        // getAgeMonthsFromDate(widget.patientDetailsData.dob).then((mon){
        //  LMSDATA.getLMS(mon).then((data){
        //    print('return data: $data');
        //  });
        // });



        break;
      }
    }

    //---------------------------------------------------------------------
    getAgeMonthsFromDate(widget.patientDetailsData.dob).then((mon) {
      LMSDATA.getLMS(mon).then((data) {
        print('return data: $data');
        getZind(data[0], data[1], data[2], data[3],mon);
      });
    });

  }

  getZscoreGirls() {
    print('Zscore girls');

    print(
        'lenght cm: ${widget.patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print(
        'weight kg: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReported}');
    // print('weight LBS: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReportedLBS}');

    // print('---------girls data -----------');
    // print(whogirls.lenghtCM.length);
    // print(whogirls.PoewrL.length);
    // print(whogirls.MedianM.length);
    // print(whogirls.variationS.length);
    //
    // print('---------boys data -----------');
    // print(whoboys.lenghtCM.length);
    // print(whoboys.powerL.length);
    // print(whoboys.medianM.length);
    // print(whoboys.variationS.length);

    double length = double.parse(
        widget.patientDetailsData.anthropometry[0].heightMeasuredReported);




    for (var a = 0; a < whogirls.lenghtCM.length; a++) {
      if (length == double.parse('${whogirls.lenghtCM[a]}')) {
        print(a);

        print('power L: ${whogirls.PoewrL[a]}');
        print('meidan M: ${whogirls.MedianM[a]}');
        print('variation S: ${whogirls.variationS[a]}');

        double Weight = double.parse(
            widget.patientDetailsData.anthropometry[0].weightMeasuredReported);
        //
        double powerL = double.parse("${whogirls.PoewrL[a]}");
        double medianM = double.parse("${whogirls.MedianM[a]}");
        double variationS = double.parse("${whogirls.variationS[a]}");

        // Z score = ((Weight/M) L - 1) / (L * S)
        print(' Z score = ([($Weight/$medianM)power$powerL] - 1) / ($powerL * $variationS)');

        double ab = Weight / medianM;
        double cd = pow(ab, powerL) - 1;

        double total = cd / (powerL * variationS);
        print('Zscore: $total');
        setState(() {
          zscore = total.toStringAsFixed(1);
        });

        // getAgeMonthsFromDate(widget.patientDetailsData.dob).then((mon) {
        //   LMSDATAFemale.getLMSFemale(mon).then((data) {
        //     print('return data: $data');
        //     getZind(data[0], data[1], data[2], data[3],mon);
        //   });
        // });
      }
    }

    // ---------------------------------------------------------------------
    getAgeMonthsFromDate(widget.patientDetailsData.dob).then((mon) {
      LMSDATAFemale.getLMSFemale(mon).then((data) {
        print('return data: $data');
        getZind(data[0], data[1], data[2], data[3],mon);
      });
    });

  }

  String Zindd = '';
  String ZalphaString = '';
  String percentile = '';
  getZind(double L, double M, double S, int index,int months) {
    //
    // print('L: $L');
    // print('M: $M');
    // print('S: $S');
    double y = 0.0;
    print('age:$months');
    if(months<24){
      print('weight: ${widget.patientDetailsData.anthropometry[0].weightMeasuredReported}');
       y = double.parse(widget.patientDetailsData.anthropometry[0].weightMeasuredReported.isEmpty?'0':widget.patientDetailsData.anthropometry[0].weightMeasuredReported);
    }else{
      y =
      // 20.5;



      double.parse(widget.patientDetailsData.anthropometry[0].bmi.isEmpty?'0':widget.patientDetailsData.anthropometry[0].bmi);
      print('bmi: ${widget.patientDetailsData.anthropometry[0].bmi}');
    }
    // if(months)



    print('y : $y');


    getAgeMonthsFromDate(widget.patientDetailsData.dob).then((value) {
      print('age: $value months');
      print('y : $y');
    });

    double a = pow(y / M, L) - 1;
    double b = S * L;
    print('a : $a');
    print('b : $b');

    double Zind = a / b;

    print('Zind: $Zind');

    print("SD3pos = M(t)[ 1 + L(t) * S(t) * (3) ]pow(1/L(t))");

    double SD3pos = M * pow((1 + L * S * 3), 1 / L);
    print('SD3pos: $SD3pos');

    print("SD3neg = M(t)[ 1 + L(t) * S(t) * (-3) ]pow(1/L(t))");

    double SD3neg = M * pow((1 + L * S * (-3)), 1 / L);
    print('SD3neg: $SD3neg');

    print(
        "SD23pos = M(t)[ 1 + L(t) * S(t) * 3 ]pow(1/L(t))  -  M(t)[ 1 + L(t) * S(t) * 2 ]pow(1/L(t))");

    double SD23pos =
        M * pow((1 + L * S * 3), 1 / L) - M * pow((1 + L * S * 2), 1 / L);
    print('SD23pos: $SD23pos');

    print(
        "SD23neg = M(t)[ 1 + L(t) * S(t) * (-2) ]pow(1/L(t))  -  M(t)[ 1 + L(t) * S(t) * (-3) ]pow(1/L(t))");

    double SD23neg =
        M * pow((1 + L * S * (-2)), 1 / L) - M * pow((1 + L * S * (-3)), 1 / L);
    print('SD23neg: $SD23neg');

    double Zind2 = 0.0;
    if (Zind > 3) {
      print('Zind > 3');

      print('Z*ind = 3 + [(y - SD3pos)/ SD23pos ]');

      Zind2 = 3 + ((y - SD3pos) / SD23pos);

      print('Z*ind: $Zind2');
    } else if (Zind < -3) {
      print('Zind < - 3');

      print('Z*ind = - 3 + [(y - SD3neg)/ SD23neg ]');

      Zind2 = -3 + ((y - SD3neg) / SD23neg);

      print('Z*ind: $Zind2');
    }

    print('C100@(t) = M(t) + [ 1 + L(t)S(t)Z@ ] pow(1/L(t))');
    print('Note: @ means alpha here');
    print('Note: Z@ means Zind/Z*ind here');

    // double Zalpha = Zind2 == 0.0 ? Zind : Zind2;
    // double Zalpha = Zind;

    double Zalpha = 0.0;
    // if(Zind > -3 && Zind <= 3){
    //   setState(() {
    //     Zalpha  = Zind;
    //     ZalphaString = Zalpha.toStringAsFixed(2);
    //   });
    //
    // }else{
    //   setState(() {
    //     Zalpha = Zind2 == 0.0 ? Zind : Zind2;
    //     ZalphaString = Zalpha.toStringAsFixed(2);
    //   });
    //
    // }

    setState(() {
      Zalpha = Zind2 == 0.0 ? Zind : Zind2;
      ZalphaString = Zalpha.toStringAsFixed(2);
    });

    print('Z alpha: $Zalpha');
    double C100 = M * (pow((1 + (L * S * Zalpha)), 1 / L));
    print("double C100 = $M *  (pow((1 + $L * $S * $Zalpha), 1 / $L) );");

    print('C100@: $C100');


    // print("P = 1 - (1/sqrt(2*pie);) [ e * (pow(-z,2)   ]");


    double percen = 0.0;
    if(Zalpha>=0){

      percentileFromFormula(Zalpha).then((p) {

        print('return pencentile from formula: $p');
        setState(() {
          percen = p;
        });
      });

    }else{
      percentileFromFormulaB(Zalpha).then((p) {

        print('return pencentile from formula: $p');
        setState(() {
          percen = p;
        });
      });

    }


    setState(() {
      Zindd = Zind.toStringAsFixed(2);
    });

    if (widget.patientDetailsData.gender.toLowerCase() == 'male') {
      print('male');

      getAgeMonthsFromDate(widget.patientDetailsData.dob).then((ageInMonths) {
        print('age: $ageInMonths months');



        getWHOResultMale(index, percen,ageInMonths).then((res){

          print('res: $res');


          var spliString = res.split(";");
          // var splitag1 = spliString[0];

          setState(() {
            resultt = spliString[1];
            condtion = spliString[0];
            percentile = percen.toStringAsFixed(2);
          });

        });

      });

    } else {
      print('female');


      getAgeMonthsFromDate(widget.patientDetailsData.dob).then((ageInMonths) {
        print('age: $ageInMonths months');


        getWHOResultFeMale(index, percen,ageInMonths).then((res){

          print('res: $res');
          var spliString = res.split(";");
          // var splitag1 = spliString[0];

          setState(() {
            resultt = spliString[1];
            condtion = spliString[0];
            percentile = percen.toStringAsFixed(2);
          });
        });

      });

    }
  }

  String resultt;
  String condtion;



final HistoryController _historyController = HistoryController();

  SaveToServer()async{

    int age = await getAgeMonthsFromDate(widget.patientDetailsData.dob);
    CDCOutput cdcData;
    if(age>23){
       cdcData = await _cdcController.getCDC(widget.patientDetailsData);
    }


   // cdcOutput(percentile).then((value) => cdcResult = value);



    Map data = {
      'status': "WHO",
      'score': '0',
      'who_output': "z = $ZalphaString; p = $percentile; $condtion; $resultt".toUpperCase(),
      'cdc_output':
      cdcData==null?'':
      "z = ${cdcData.zScore}; p = ${cdcData.percentile}; ${cdcData.condition}; ${cdcData.result}".toUpperCase(),
      'lastUpdate': '${DateTime.now()}',
    };

    print('data json: ${jsonEncode(data)}');



    checkConnectivityWithToggle(widget.patientDetailsData.hospital[0].sId).then((internet){

      if(internet!=null && internet){
          _whoController.saveData(widget.patientDetailsData, data).then((value){

          print('updatedd');

          _historyController.saveHistoryWihtoutLoader(
              widget.patientDetailsData.sId,
              ConstConfig.WHOHistory,
              "z = $ZalphaString; p = $percentile; $condtion; $resultt".toUpperCase());

        });
      }else{
        _whoController.saveDataOffline(widget.patientDetailsData, data);
      }

    });


  }


}






