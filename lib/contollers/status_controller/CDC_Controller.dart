import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/percentileFunc.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/LMS_CDC_Model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class CDCController extends GetxController {
  Future<CDCOutput> getCDC(PatientDetailsData pData) async {
    LMSDataModel lmsData = await getLMSDATA(pData);

    double powerL = double.parse(double.parse(lmsData.powerL).toStringAsFixed(8));
    double medianM = double.parse(double.parse(lmsData.medianM).toStringAsFixed(8));
    double variationS = double.parse(double.parse(lmsData.variationS).toStringAsFixed(8));

    double bmi = double.parse(pData.anthropometry[0].bmi);

    // -1.850468473	15.58176458	0.072306081

    // Z score = ((bmi/M) L - 1) / (L * S)
    print(
        ' Z score = ([($bmi/$medianM)power$powerL] - 1) / ($powerL * $variationS)');

    double ab = bmi / medianM;
    double cd = pow(ab, powerL) - 1;

    double total = cd / (powerL * variationS);
    print('Zscore: ${total.toStringAsFixed(2)}');

    double Zalpha = total;

    double percentile = 0.0;
    if (Zalpha >= 0) {
      debugPrint('Zalpha >= 0');
      percentile = await percentileFromFormula(Zalpha);
    } else {
      debugPrint('Zalpha >= 0 else');
      percentile = await percentileFromFormulaB(Zalpha);
    }

    percentileFromFormula(Zalpha).then((value) => print('percentile:: ${value}'));
    percentileFromFormulaB(Zalpha).then((value) => print('percentile B:: ${value}'));

    String condition = await cdcCondition(percentile);
    String result = await cdcResult(percentile);

    return CDCOutput(zScore:Zalpha.toStringAsFixed(2),condition: condition,result: result,percentile: percentile.toStringAsFixed(2) );
  }

  Future<LMSDataModel> getLMSDATA(PatientDetailsData pData) async {
    String path = pData.gender.toLowerCase() == 'male'
        ? JsonFilePath.LMS_CDC_boys
        : JsonFilePath.LMS_CDC_girls;
    print('path::$path');
    var data = await getJson(path);
    var decodedData = json.decode(data) as List;
    List<LMSDataModel> lmsData =
        decodedData.map((e) => LMSDataModel.fromJson(e)).toList();
    adLog('lmsData :: $lmsData');

    int age = await getAgeMonthsFromDate(pData.dob);
    print('getAgeMonthsFromDate: $age');

    LMSDataModel output;

    for (var a in lmsData) {
      if (int.parse(a.age) == age ) {
        print('age: ${a.age}');
        print('power L: ${a.powerL}');
        print('meidan M: ${a.medianM}');
        print('variation S: ${a.variationS}');

        output = a;
        break;
      }
    }
    return output;
  }

  Future<String> cdcResult(double percentile) async {
    // print('getting percentile for CDC ::$percentile');
    double per = percentile;

    if (per < 5) {
      return 'underweight'.tr;
    } else if (per >= 5 && per < 85) {
      return 'healthy_weight'.tr;
    } else if (per >= 85 && per < 95) {
      return 'overweight'.tr;
    } else if (per >= 95) {
      return 'obesity'.tr;
    } else {
      return null;
    }
  }

  Future<String> cdcCondition(double percentile) async {
    // print('getting percentile for CDC ::$percentile');
    double per = percentile;

    if (per < 5) {
      return 'P<5';
    } else if (per >= 5 && per < 85) {
      return 'P>=5 && P<85';
    } else if (per >= 85 && per < 95) {
      return 'P>=85 && P<95';
    } else if (per >= 95) {
      return 'P>=95';
    } else {
      return null;
    }
  }
}

class CDCOutput {
  String zScore;
  String percentile;
  String condition;
  String result;
  CDCOutput({this.zScore, this.percentile, this.condition, this.result});
}
