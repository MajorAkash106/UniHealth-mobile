import 'dart:math';

import 'package:medical_app/config/cons/LMSfromAgeConstFemale.dart';
import 'package:medical_app/config/funcs/percentileFunc.dart';
import 'package:medical_app/config/funcs/whofunc.dart';

import 'package:medical_app/config/cons/LMSfromAgeConst.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class WhoControllerUpdated {
  String zscore = '';
  String resultt;
  String condtion;
  String Zindd = '';
  String ZalphaString = '';
  String percentile = '';

 Future<WHOOutput> getWHO(PatientDetailsData patientDetailsData) async {

   WHOOutput output;
    if (patientDetailsData.gender.toLowerCase() == 'male') {
      output = await getZscoreBoys(patientDetailsData);

      print('whoOutput for boys :: $output');
    } else {
      output = await getZscoreGirls(patientDetailsData);

      print('whoOutput for girls :: $output');
    }
    return output;
  }

  Future<WHOOutput> getZscoreBoys(PatientDetailsData patientDetailsData) async {
    print('Zscore boys');

    print(
        'lenght cm: ${patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print(
        'weight kg: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');

    double length = double.parse(
        patientDetailsData.anthropometry[0].heightMeasuredReported);

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
        // setState(() {
        zscore = total.toStringAsFixed(2);
        // });

        break;
      }
    }

    int mon = await getAgeMonthsFromDate(patientDetailsData.dob);
    List data = await LMSDATA.getLMS(mon);
    WHOOutput output = await getZind(
        data[0], data[1], data[2], data[3], mon, patientDetailsData);

    // output.zScore = zscore;

    return output;
  }

  Future<WHOOutput> getZscoreGirls(
      PatientDetailsData patientDetailsData) async {
    print('Zscore girls');

    print(
        'lenght cm: ${patientDetailsData.anthropometry[0].heightMeasuredReported}');
    print(
        'weight kg: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');

    double length = double.parse(
        patientDetailsData.anthropometry[0].heightMeasuredReported);

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
        // setState(() {
        zscore = total.toStringAsFixed(2);
        // });

      }
    }

    int mon = await getAgeMonthsFromDate(patientDetailsData.dob);

    List data = await LMSDATAFemale.getLMSFemale(mon);

    WHOOutput output = await getZind(
        data[0], data[1], data[2], data[3], mon, patientDetailsData);

    // output.zScore = zscore;
    return output;
  }

  Future<WHOOutput> getZind(double L, double M, double S, int index, int months,
      PatientDetailsData patientDetailsData) async {
    double y = 0.0;
    print('age:$months');
    if (months < 24) {
      print(
          'weight: ${patientDetailsData.anthropometry[0].weightMeasuredReported}');
      y = double.parse(
          patientDetailsData.anthropometry[0].weightMeasuredReported.isEmpty
              ? '0'
              : patientDetailsData.anthropometry[0].weightMeasuredReported);
    } else {
      y =
          // 20.5;

          double.parse(patientDetailsData.anthropometry[0].bmi.isEmpty
              ? '0'
              : patientDetailsData.anthropometry[0].bmi);
      print('bmi: ${patientDetailsData.anthropometry[0].bmi}');
    }
    // if(months)

    print('y : $y');

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

    double Zalpha = 0.0;

    Zalpha = Zind2 == 0.0 ? Zind : Zind2;
    ZalphaString = Zalpha.toStringAsFixed(2);

    print('Z alpha: $Zalpha');
    double C100 = M * (pow((1 + (L * S * Zalpha)), 1 / L));
    print("double C100 = $M *  (pow((1 + $L * $S * $Zalpha), 1 / $L) );");

    print('C100@: $C100');

    // print("P = 1 - (1/sqrt(2*pie);) [ e * (pow(-z,2)   ]");

    double percen = 0.0;
    if (Zalpha >= 0) {
      percen = await percentileFromFormula(Zalpha);
    } else {
      percen = await percentileFromFormulaB(Zalpha);
    }

    Zindd = Zind.toStringAsFixed(2);

    if (patientDetailsData.gender.toLowerCase() == 'male') {
      print('male');

      int ageInMonths = await getAgeMonthsFromDate(patientDetailsData.dob);
      String res = await getWHOResultMale(index, percen, ageInMonths);
      var spliString = res.split(";");

      resultt = spliString[1];
      condtion = spliString[0];
      percentile = percen.toStringAsFixed(2);
    } else {
      print('female');

      int ageInMonths = await getAgeMonthsFromDate(patientDetailsData.dob);
      String res = await getWHOResultFeMale(index, percen, ageInMonths);
      print('res: $res');
      var spliString = res.split(";");

      resultt = spliString[1];
      condtion = spliString[0];
      percentile = percen.toStringAsFixed(2);
    }

    return WHOOutput(
        zScore: ZalphaString,
        percentile: percentile,
        condition: condtion,
        result: resultt);
  }
}

class WHOOutput {
  String zScore;
  String percentile;
  String condition;
  String result;
  WHOOutput({this.zScore, this.percentile, this.condition, this.result});
}
