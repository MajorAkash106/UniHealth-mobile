import 'dart:math';

import 'package:get/get.dart';
import 'package:medical_app/config/cons/LMSfromAgeConst.dart';
import 'package:medical_app/config/cons/LMSfromAgeConstFemale.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/percentileFemale.dart';
import 'package:medical_app/config/cons/percentileMale.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/config/funcs/whofunc.dart';

Future<String> getWHOResultMale(
    int index, double percentile, int months) async {
  // print('percentile 1st: ${percentileMale.first_th.length}');
  // print('percentile 3: ${percentileMale.Third_th.length}');
  // print('percentile 5: ${percentileMale.fifth_th.length}');
  // print('percentile 15: ${percentileMale.one_five_th.length}');
  // print('percentile 25: ${percentileMale.two_five_th.length}');
  // print('percentile 50: ${percentileMale.five_zero_th.length}');
  // print('percentile 75: ${percentileMale.seven_five_th.length}');
  // print('percentile 85: ${percentileMale.eight_five_th.length}');
  // print('percentile 95: ${percentileMale.nine_five_th.length}');
  // print('percentile 97: ${percentileMale.nine_seven_th.length}');
  // print('percentile 99: ${percentileMale.nine_nine_th.length}');
  //
  //
  //
  // print('percentile 1st: ${percentileFeMale.first_th.length}');
  // print('percentile 3: ${percentileFeMale.Third_th.length}');
  // print('percentile 5: ${percentileFeMale.fifth_th.length}');
  // print('percentile 15: ${percentileFeMale.one_five_th.length}');
  // print('percentile 25: ${percentileFeMale.two_five_th.length}');
  // print('percentile 50: ${percentileFeMale.five_zero_th.length}');
  // print('percentile 75: ${percentileFeMale.seven_five_th.length}');
  // print('percentile 85: ${percentileFeMale.eight_five_th.length}');
  // print('percentile 95: ${percentileFeMale.nine_five_th.length}');
  // print('percentile 97: ${percentileFeMale.nine_seven_th.length}');
  // print('percentile 99: ${percentileFeMale.nine_nine_th.length}');

  print('index:$index');
  String resultt;
  await ReturnResultManually(index, percentile, months).then((value){
    resultt = value;
  });

  return resultt;

  // if (percentile < percentileMale.first_th[index]) {
  //   print('percentile: p < 1 ');
  //   // in all case same result
  //   print('SEVERE UNDERWEIGHT FOR AGE');
  //
  //   return 'p < 1; SEVERE UNDERWEIGHT FOR AGE';
  // } else if (percentile >= percentileMale.first_th[index] &&
  //     percentile < percentileMale.Third_th[index]) {
  //   print('percentile: p >= 1 or p < 3');
  //   // in all case same result
  //   print('UNDERWEIGHT FOR AGE');
  //   return 'p >= 1 or p < 3; UNDERWEIGHT FOR AGE';
  // } else if (percentile >= percentileMale.Third_th[index] &&
  //     percentile < percentileMale.eight_five_th[index]) {
  //   print('percentile: p >= 3 or p < 85');
  //   // in all case same result
  //   print('EUTHROPHIC');
  //
  //   return 'p >= 3 or p < 8; EUTHROPHIC';
  // } else if (percentile >= percentileMale.eight_five_th[index] &&
  //     percentile < percentileMale.nine_seven_th[index]) {
  //   print('percentile: p >= 85 or p < 97');
  //
  //   if (months < 24) {
  //     print('EUTHROPHIC');
  //     return 'p >= 85 or p < 97; EUTHROPHIC';
  //   } else if (months >= 24 && months < 60) {
  //     print('RISK OF OVERWEIGHT');
  //     return 'p >= 85 or p < 97; RISK OF OVERWEIGHT';
  //   } else {
  //     print('OVERWEIGHT');
  //     return 'p >= 85 or p < 97; OVERWEIGHT';
  //   }
  // } else if (percentile >= percentileMale.nine_seven_th[index] &&
  //     percentile < percentileMale.nine_nine_th[index]) {
  //   print('percentile: p >= 97 or p < 99');
  //
  //   if (months < 24) {
  //     print('OVERWEIGHT FOR AGE');
  //     return 'p >= 97 or p < 99; OVERWEIGHT FOR AGE';
  //   } else if (months >= 24 && months < 60) {
  //     print('OVERWEIGHT');
  //
  //     return 'p >= 97 or p < 99; OVERWEIGHT';
  //   } else {
  //     print('OBESITY');
  //     return 'p >= 97 or p < 99; OBESITY';
  //   }
  // } else if (percentile > percentileMale.nine_nine_th[index]) {
  //   print('percentile: p > 99');
  //
  //   if (months < 24) {
  //     print('OVERWEIGHT FOR AGE');
  //     return 'p > 99; OVERWEIGHT FOR AGE';
  //   } else if (months >= 24 && months < 60) {
  //     print('OBESITY');
  //     return 'p > 99; OBESITY';
  //   } else {
  //     print('SEVERE OBESITY');
  //     return 'p > 99; SEVERE OBESITY';
  //   }
  // }
}

Future<String> getWHOResultFeMale(
    int index, double percentile, int months) async {
  print('index:$index');
  print('percentile:$percentile');

  String resultt;
 await ReturnResultManually(index, percentile, months).then((value){
    resultt = value;
  });

 return resultt;
  // if (percentile < percentileFeMale.first_th[index]) {
  //   print('percentile: p < 1 ');
  //   print('first_th: ${percentileFeMale.first_th[index]} ');
  //   // in all case same result
  //   print('SEVERE UNDERWEIGHT FOR AGE');
  //
  //   return 'p < 1; SEVERE UNDERWEIGHT FOR AGE';
  // } else if (percentile >= percentileFeMale.first_th[index] &&
  //     percentile < percentileFeMale.Third_th[index]) {
  //   print('percentile: p >= 1 or p < 3');
  //   // in all case same result
  //   print('UNDERWEIGHT FOR AGE');
  //   return 'p >= 1 or p < 3; UNDERWEIGHT FOR AGE';
  // } else if (percentile >= percentileFeMale.Third_th[index] &&
  //     percentile < percentileFeMale.eight_five_th[index]) {
  //   print('percentile: p >= 3 or p < 85');
  //   // in all case same result
  //   print('EUTHROPHIC');
  //
  //   return 'p >= 3 or p < 85; EUTHROPHIC';
  // } else if (percentile >= percentileFeMale.eight_five_th[index] &&
  //     percentile < percentileFeMale.nine_seven_th[index]) {
  //   print('percentile: p >= 85 or p < 97');
  //
  //   if (months < 24) {
  //     print('EUTHROPHIC');
  //     return 'p >= 85 or p < 97; EUTHROPHIC';
  //   } else if (months >= 24 && months < 60) {
  //     print('RISK OF OVERWEIGHT');
  //     return 'p >= 85 or p < 97; RISK OF OVERWEIGHT';
  //   } else {
  //     print('OVERWEIGHT');
  //     return 'p >= 85 or p < 97; OVERWEIGHT';
  //   }
  // } else if (percentile >= percentileFeMale.nine_seven_th[index] &&
  //     percentile < percentileFeMale.nine_nine_th[index]) {
  //   print('percentile: p >= 97 or p < 99');
  //
  //   if (months < 24) {
  //     print('OVERWEIGHT FOR AGE');
  //     return 'p >= 97 or p < 99; OVERWEIGHT FOR AGE';
  //   } else if (months >= 24 && months < 60) {
  //     print('OVERWEIGHT');
  //
  //     return 'p >= 97 or p < 99; OVERWEIGHT';
  //   } else {
  //     print('OBESITY');
  //     return 'p >= 97 or p < 99; OBESITY';
  //   }
  // } else if (percentile > percentileFeMale.nine_nine_th[index]) {
  //   print('percentile: p > 99');
  //
  //   if (months < 24) {
  //     print('OVERWEIGHT FOR AGE');
  //     return 'p > 99; OVERWEIGHT FOR AGE';
  //   } else if (months >= 24 && months < 60) {
  //     print('OBESITY');
  //     return 'p > 99; OBESITY';
  //   } else {
  //     print('SEVERE OBESITY');
  //     return 'p > 99; SEVERE OBESITY';
  //   }
  // }
}




Future<String>ReturnResultManually(int index, double percentile, int months)async{
  print('index:$index');
  print('percentile:$percentile ${ percentile < 3}');
  if (percentile < 0.1) {
    print('percentile: p < 0.1 ');
    print('first_th: ${percentileFeMale.first_th[index]} ');
    // in all case same result
    print('SEVERE UNDERWEIGHT FOR AGE');

    return 'p < 0.1; ${'severe_underweight_for_age'.tr}';
  } else if (percentile >= 0.1 && percentile < 3) {
    print('percentile: p >= 0.1 or p < 3');
    // in all case same result
    print('UNDERWEIGHT FOR AGE');
    return 'p >= 0.1 AND p < 3; ${'underweight_for_age'.tr}';
  } else if (percentile >= 3 && percentile < 85) {
    print('percentile: p >= 3 or p < 85');
    // in all case same result
    print('EUTHROPHIC');

    return 'p >= 3 AND p < 85; ${'euthrophic_'.tr}';
  } else if (percentile >= 85 && percentile < 97) {
    print('percentile: p >= 85 or p < 97');

    if (months < 24) {
      print('EUTHROPHIC');
      return 'p >= 85 AND p < 97; ${'euthrophic_'.tr}';
    } else if (months >= 24 && months < 60) {
      print('RISK OF OVERWEIGHT');
      return 'p >= 85 AND p < 97; ${'risk_of_overweight'.tr}';
    } else {
      print('OVERWEIGHT');
      return 'p >= 85 AND p < 97; ${'overweight'.tr}';
    }
  } else if (percentile >= 97 &&
      percentile < 99) {
    print('percentile: p >= 97 or p < 99');

    if (months < 24) {
      print('OVERWEIGHT FOR AGE');
      return 'p >= 97 AND p < 99; ${'overweight_for_age'.tr}';
    } else if (months >= 24 && months < 60) {
      print('OVERWEIGHT');

      return 'p >= 97 AND p < 99; ${'overweight'.tr}';
    } else {
      print('OBESITY');
      return 'p >= 97 AND p < 99; ${'obesity'.tr}';
    }
  } else if (percentile > 99) {
    print('percentile: p > 99');

    if (months < 24) {
      print('OVERWEIGHT FOR AGE');
      return 'p > 99; ${'overweight_for_age'.tr}';
    } else if (months >= 24 && months < 60) {
      print('OBESITY');
      return 'p > 99; ${'obesity'.tr}';
    } else {
      print('SEVERE OBESITY');
      return 'p > 99; ${'severe_obesity'.tr}';
    }
  }
}




class GetResultWHO extends GetxController{

  Future<String> getZscore(PatientDetailsData patientDetailsData) async {
    String result;
    if (patientDetailsData.gender.toLowerCase() == 'male') {
      await getZscoreBoys(patientDetailsData).then((value) {
        result = value;
        // return value;
      });
    } else {
      await  getZscoreGirls(patientDetailsData).then((value){
        result = value;
      });
    }
    return result;
  }

  Future<String> getZscoreBoys(PatientDetailsData patientDetailsData) async {
    print('Zscore boys');

    print(
        'lenght cm: ${patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print(
        'weight kg: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');
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

    double length =
    double.parse(patientDetailsData.anthropometry[0].heightMeasuredReported);
    String res;
    for (var a = 0; a < whoboys.lenghtCM.length; a++) {
      if (length == double.parse('${whoboys.lenghtCM[a]}')) {
        print(a);

        print('power L: ${whoboys.powerL[a]}');
        print('meidan M: ${whoboys.medianM[a]}');
        print('variation S: ${whoboys.variationS[a]}');

        double Weight = double.parse(
            patientDetailsData.anthropometry[0].weightMeasuredReported);
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

        zscore = total.toStringAsFixed(1);

        // getAgeMonthsFromDate(widget.patientDetailsData.dob).then((mon){
        //  LMSDATA.getLMS(mon).then((data){
        //    print('return data: $data');
        //  });
        // });



        break;
      }
    }


    await getAgeMonthsFromDate(patientDetailsData.dob).then((mon) {
      LMSDATA.getLMS(mon).then((data) {
        print('return data: $data');
        getZind(data[0], data[1], data[2], data[3], patientDetailsData,mon)
            .then((r) {
          print('return res: $r');
          res = r;
        });
      });
    });

    return res;
  }

  Future<String> getZscoreGirls(PatientDetailsData patientDetailsData) async {
    print('Zscore girls');

    print(
        'lenght cm: ${patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print(
        'weight kg: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');
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

    double length =
    double.parse(patientDetailsData.anthropometry[0].heightMeasuredReported);
    String res;
    for (var a = 0; a < whogirls.lenghtCM.length; a++) {
      if (length == double.parse('${whogirls.lenghtCM[a]}')) {
        print(a);

        print('power L: ${whogirls.PoewrL[a]}');
        print('meidan M: ${whogirls.MedianM[a]}');
        print('variation S: ${whogirls.variationS[a]}');

        double Weight = double.parse(
            patientDetailsData.anthropometry[0].weightMeasuredReported);
        //
        double powerL = double.parse("${whogirls.PoewrL[a]}");
        double medianM = double.parse("${whogirls.MedianM[a]}");
        double variationS = double.parse("${whogirls.variationS[a]}");

        // Z score = ((Weight/M) L - 1) / (L * S)
        print(
            ' Z score = ([($Weight/$medianM)power$powerL] - 1) / ($powerL * $variationS)');

        double ab = Weight / medianM;
        double cd = pow(ab, powerL) - 1;

        double total = cd / (powerL * variationS);
        print('Zscore: $total');
        zscore = total.toStringAsFixed(1);


      }
    }

    await getAgeMonthsFromDate(patientDetailsData.dob).then((mon) {
      LMSDATAFemale.getLMSFemale(mon).then((data) {
        print('return data: $data');
        getZind(data[0], data[1], data[2], data[3], patientDetailsData,mon)
            .then((re) {
          res = re;
        });
      });
    });

    return res;
  }

  String Zindd = '';
  String zscore = '';
  Future<String> getZind(double L, double M, double S, int index,
      PatientDetailsData patientDetailsData,int months) async {
    //
    // print('L: $L');
    // print('M: $M');
    // print('S: $S');

    // print('bmi: ${patientDetailsData.anthropometry[0].bmi}');
    // double y =
    // // 20.5;
    // double.parse(patientDetailsData.anthropometry[0].bmi.isEmpty
    //     ? '0'
    //     : patientDetailsData.anthropometry[0].bmi);
    // print('y : $y');



    double y = 0.0;
    print('age:$months');
    if(months<24){
      print('weight: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');
      y = double.parse(patientDetailsData.anthropometry[0].weightMeasuredReported.isEmpty?'0':patientDetailsData.anthropometry[0].weightMeasuredReported);
    }else{
      y =
      // 20.5;



      double.parse(patientDetailsData.anthropometry[0].bmi.isEmpty?'0':patientDetailsData.anthropometry[0].bmi);
      print('bmi: ${patientDetailsData.anthropometry[0].bmi}');
    }



    getAgeMonthsFromDate(patientDetailsData.dob).then((value) {
      print('age: $value months');
      print('y : $y');
    });

    double a = pow(y / M, L) - 1;
    double b = S * L;
    // print('a : $a');
    // print('b : $b');

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
    double Zalpha = 0.0;
    // if(Zind > -3 && Zind <= 3){
    //   Zalpha  = Zind;
    // }else{
    //    Zalpha = Zind2 == 0.0 ? Zind : Zind2;
    // }

    Zalpha = Zind2 == 0.0 ? Zind : Zind2;




    print('Z alpha: $Zalpha');
    double C100 = M * (pow((1 + (L * S * Zalpha)), 1 / L));
    print("double C100 = $M *  (pow((1 + $L * $S * $Zalpha), 1 / $L) );");

    print('C100@: $C100');

    Zindd = Zind.toStringAsFixed(2);



    double percen = 0.0;
    if(Zalpha>=0){

      percentileFromFormula(Zalpha).then((p) {

        print('return pencentile from formula: $p');
        percen = p;
      });

    }else{
      percentileFromFormulaB(Zalpha).then((p) {

        print('return pencentile from formula: $p');
        percen = p;
      });

    }


    if (patientDetailsData.gender.toLowerCase() == 'male') {
      print('male');

      await getAgeMonthsFromDate(patientDetailsData.dob).then((ageInMonths) {
        print('age: $ageInMonths months');

        getWHOResultMale(index, percen, ageInMonths).then((res) {
          print('res: $res');
          print('z = $Zalpha; $res'.toUpperCase());
          resultt.value = 'z = ${Zalpha.toStringAsFixed(2)}; p = ${percen.toStringAsFixed(2)}; $res'.toUpperCase();
        });
      });
    } else {
      print('female');

      await getAgeMonthsFromDate(patientDetailsData.dob).then((ageInMonths) {
        print('age: $ageInMonths months');

        getWHOResultFeMale(index, percen, ageInMonths).then((res) {
          print('z = $Zalpha; $res'.toUpperCase());
          resultt.value = 'z = ${Zalpha.toStringAsFixed(2)}; p = ${percen.toStringAsFixed(2)}; $res'.toUpperCase();
        });
      });
    }
    // return resultt;
  }



  var resultt = ''.obs;

}




Future<double>percentileFromFormula(double zz)async{

  double pie = 3.14;
  double e = 2.71828182845904523536028747135266249775724709369995;



  double z = zz;
  double twoPieRootValue =  1/sqrt(2*pie);

  print('z value: $z');
  print('powerrr: ${pow(z, 2)}');

  double epower = (pow((z), 2))/2;

  double ab = pow(e, -epower);

  double bc = 0.226 + (0.64 * z) + (0.33 *  sqrt((pow(z,2))+3) );



  double p = (1-twoPieRootValue *(ab/bc))  * 100;
  print('twoPieRootValue : $twoPieRootValue');
  print('epower : $epower');
  print('ab : $ab');
  print('bc : $bc');

  print('final p : $p');
  return p;

}

Future<double>percentileFromFormulaB(double zz)async{

  double pie = 3.14;
  double e = 2.71828182845904523536028747135266249775724709369995;



  double z = zz;
  double twoPieRootValue =  1/sqrt(2*pie);

  print('z value2: $z');
  print('powerrr2: ${pow(z, 2)}');

  print('error under root: ${sqrt((pow(z,2))+3)}');

  double epower = (pow((z), 2))/2;

  double ab = pow(e, -epower);

  double bc = 0.226 - (0.64 * z) + (0.33 *  sqrt((pow(z,2))+3) );



  double p =( twoPieRootValue *(ab/bc)  ) *100;
  print('twoPieRootValue2 : $twoPieRootValue');
  print('epower2 : $epower');
  print('ab2 : $ab');
  print('bc2 : $bc');

  print('final p2 : $p');
  return p;

}



