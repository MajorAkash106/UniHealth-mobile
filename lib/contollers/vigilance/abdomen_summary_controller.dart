import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/abdominal_dist.dart';
import 'package:medical_app/config/cons/bowel_movement.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/mean_iap_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart' as w;

class AbdomenSummaryController extends GetxController {
  final AbdomenController abdomenController = AbdomenController();
  Mean_Iap_Controller meanIapController = Mean_Iap_Controller();

  Future<String> getResultSummary(PatientDetailsData pdata) async {
    Vigilance abdomen = await abdomenController.getAbdomenData(pdata);

    List<double> ngTubeData = await abdomenController.getNGTube(pdata);

    List<String> meanIapData = await meanIapController.get_avg_MeanIap(pdata);

    Gif_Data gifData = await abdomenController.GIF_result(pdata);

    bool condition = await isHighNgTube(pdata);

    adLog('data data :: $condition');

    bool condition2 = await isHigh(pdata);

    bool meanHighCheck = await get_mean_IapDataHIGH(pdata) ?? false;

    bool isMean20Plus = await isMeanTwentyPlus(pdata) ?? false;

    bool isConstipations = await isConstipation(pdata) ?? false;

    // if(gifData==null){
    //   //for null error
    //   gifData = Gif_Data(gif_result: '',gif_score: -1);
    // }



    try {
      String output = '';
      if (abdomen != null) {
        AbdomenData data = abdomen?.result?.first?.abdomenData;

        print('gifData -----:: $gifData');
        // print(
        //     '${double.parse(meanIapData[0])} ${double.parse(meanIapData[1])}  ${ngTubeData[0]} ${ngTubeData[1]} ${gifData.gif_score}');

        // if ((data.bowelMovement == 'Present') &&
        if ((data.indexBowelMovement == bowelMovement.PRESENT) &&
            (data.bowelSound == 1) &&
            (data.vomit == 0) &&
            // (data.abdominalDist == 'Absent') &&
            (data.indexAbdominalDist == abdoDist.ABSENT) &&
            (ngTubeData[0] == 0.0 && ngTubeData[1] == 0.0) &&
            (double.parse(meanIapData[0]) == 0.0 &&
                double.parse(meanIapData[1]) == 0.0) &&
            (gifData.gif_score == 0)) {
          print('condition 1 executed');

          if (output == '') {
            output = 'no_abnormalities'.tr;
          } else {
            output = '$output, ${'no_abnormalities'.tr}';
          }
        }
        // if (data.bowelMovement == 'Liquid - Few (≥3/day)' ||
        //     data.bowelMovement == 'Liquid - Abundant (≥1/day)') {

        if (data.indexBowelMovement == bowelMovement.LIQUID_FEW_3_DAY ||
            data.indexBowelMovement == bowelMovement.LIQUID_ABUNDANT_1_DAY) {
          print('condition 2 executed');

          if (output == '') {
            output = 'diarrhea'.tr;
          } else {
            output = '$output, ${'diarrhea'.tr}';
          }
        }
        if (isConstipations == true) {
          // if absent in last three days = constipation

          //under development, have to record last 3 days data
          if (output == '') {
            output = 'constipation'.tr;
          } else {
            output = '$output, ${'constipation'.tr}';
          }
        }
        // if (data.bowelMovement == 'Evaluation not possible') {
        if (data.indexBowelMovement == bowelMovement.EVALUATION_NOT_POSSIBLE) {
          print('condition 3 executed');

          if (output == '') {
            output = 'bowel_mov_ne'.tr;
          } else {
            output = '$output, ${'bowel_mov_ne'.tr}';
          }
        }
        if (data.bowelSound == 0) {
          // data.bowelSound == absent
          print('condition 4 executed');

          if (output == '') {
            output = 'bowel_sounds_absent'.tr;
          } else {
            output = '$output, ${'bowel_sounds_absent'.tr}';
          }
        }
        if (data.bowelSound == 2) {
          print('condition 5 executed');
          // data.bowelSound == Evaluation not possible

          if (output == '') {
            output = 'bowel_sounds_ne'.tr;
          } else {
            output = '$output, ${'bowel_sounds_ne'.tr}';
          }
        }
        if (data.vomit == 1) {
          print('condition 6 executed');
          // data.vomit == present

          if (output == '') {
            output = 'vomiting_'.tr;
          } else {
            output = '$output, ${'vomiting_'.tr}';
          }
        }
        if (data.vomit == 2) {
          print('condition 7 executed');
          // data.vomit == Evaluation not possible

          if (output == '') {
            output = 'vomiting_ne'.tr;
          } else {
            output = '$output, ${'vomiting_ne'.tr}';
          }
        }
        // if (data.abdominalDist == 'Mild' ||
        //     data.abdominalDist == 'Moderate' ||
        //     data.abdominalDist == 'Severe') {
        if (data.indexAbdominalDist == abdoDist.MILD ||
            data.indexAbdominalDist == abdoDist.MODERATE ||
            data.indexAbdominalDist == abdoDist.SEVERE) {
          print('condition 8 executed');

          if (output == '') {
            output = 'distension'.tr;
          } else {
            output = '$output, ${'distension'.tr}';
          }
        }
        // if (data.abdominalDist == 'Evaluation not possible') {
        if (data.indexAbdominalDist == abdoDist.EVALUATION_NOT_POSSIBLE) {
          print('condition 9 executed');

          if (output == '') {
            output = 'distension_ne'.tr;
          } else {
            output = '$output, ${'distension_ne'.tr}';
          }
        }
        if (condition == true || condition2 == true) {
          //Gastric residual Alert conditions
          print('condition = $condition ------ condition2 = $condition2');
          print('condition 10 executed');

          if (output == '') {
            output = 'gastric_residual_alert'.tr;
          } else {
            output = '$output, ${'gastric_residual_alert'.tr}';
          }
        }
        if (isMean20Plus == true && meanHighCheck == false) {
          print('condition 11 executed');

          if (output == '') {
            output = 'risk_of_intra_abdominal_hypertension'.tr;
          } else {
            output = '$output, ${'risk_of_intra_abdominal_hypertension'.tr}';
          }
        }
        if (isMean20Plus == true && meanHighCheck == true) {
          print('condition 12 executed');

          if (output == '') {
            output = 'intra_abdominal_hypertension_alert'.tr;
          } else {
            output = '$output, ${'intra_abdominal_hypertension_alert'.tr}';
          }
        }
        if (gifData.gif_score >= 0) {
          print('condition 13 executed');

          if (output == '') {
            output = 'GIF score = ${gifData.gif_score} (${gifData.gif_result})';
          } else {
            output =
                '$output, GIF score = ${gifData.gif_score} (${gifData.gif_result})';
          }
        }
        // else {
        //   print('condition 14 executed else');
        // }
      }

      print('return abdomen summary $output');
      return output;
    } catch (e) {
      print('error :$e');
    }
  }

  Future<bool> isMeanTwentyPlus(PatientDetailsData data) async {
    Vigilance meanData = await get_mean_IapData(data);
    bool output = false;

    if (meanData != null) {
      for (var a in meanData.result.first.mean_data) {
        if (double.parse(a.iap_value) > 20) {
          output = true;
          break;
        }
      }
    }
    return output;
  }

  Future<bool> isConstipation(PatientDetailsData pData) async {
    bool output = false;
    Vigilance data = await abdomenController.getAbdomenData(pData);
    int countDays = 0;
    if (data != null && data.result.first.abdomenDetails != null) {
      DateTime start = await getDateTimeWithWorkdayHosp(
          pData.hospital.first.sId, DateTime.now());
      DateTime lastThreeDayDate = start.subtract(Duration(days: 3));

      print('start : $start lastThreeDayDate :$lastThreeDayDate');

      List<w.AbdomenData> abdomenList = data.result.first.abdomenDetails;

      for (var a in abdomenList) {
        DateTime dateTime = DateTime.parse(a.lastUpdate);

        // if (dateTime.isAfter(lastThreeDayDate) && (a.bowelMovement == 'Absent')) {
        if (dateTime.isAfter(lastThreeDayDate) &&
            (a.indexBowelMovement == bowelMovement.ABSENT)) {
          countDays++;
          // break;
        }
      }
    }

    if (countDays >= 3) {
      output = true;
    }
    print('output countDays $countDays :: $output');
    return output;
  }

  Future<bool> isHighNgTube(PatientDetailsData data) async {
    // this func. returning sum of ng tube toggled out and EN toggled in of current day and last day
    List last_toggle_out_NGtube = [];
    List current_toggle_out_NGtube = [];
    bool isAlert = false;

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    print("cccc.....${lastWorkStart.toString()}");
    print("llll......${lastWorkEndCurrentStart.toString()}");
    var dateTimee;
    await getFluidBalanace(data).then((value) {
      if (value != null) {
        for (int i = 0; i < value.result[0].data.length; i++) {
          var item = value.result[0].data[i];
          dateTimee = '${item.date} ${item.time}:00';
          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  ((item.item == "Nasogastric Tube" ||
                          item.item == "Sonda Nasogástrica") &&
                      item.intOut == '1')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            last_toggle_out_NGtube.add(double.parse(item.ml));
          } else if ((DateTime.parse(dateTimee).isAfter(lastWorkEndCurrentStart)) &&
                  ((item.item == "Nasogastric Tube" ||
                          item.item == "Sonda Nasogástrica") &&
                      item.intOut == '1')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            current_toggle_out_NGtube.add(double.parse(item.ml));
          } else {}
        }
        print("current .... ${current_toggle_out_NGtube}");
        print("last .... ${last_toggle_out_NGtube}");

        if (last_toggle_out_NGtube.isNotEmpty) {
          for (var a in last_toggle_out_NGtube) {
            if (double.parse('$a') > 500.0) {
              isAlert = true;
              break;
            }
          }
        }

        if (current_toggle_out_NGtube.isNotEmpty) {
          for (var a in current_toggle_out_NGtube) {
            if (double.parse('$a') > 500.0) {
              print(
                  'current_toggle_out_NGtube true ${double.parse('$a')} > 500.0');
              isAlert = true;
              break;
            }
          }
        }
      }
    });

    return isAlert;
  }

  Future<bool> isHigh(PatientDetailsData data) async {
    // Sum_NG_out_ENin_values Ng_En_Values =
    //     await abdomenController.get_Sum_NG_out_EN_in(data);
    bool isAlert = await getData(data);

    return isAlert;
  }

  Future<bool> getData(PatientDetailsData data) async {
    List ng_out_current = [];
    List ng_in_current = [];
    List en_in_current = [];

    List ng_out_last = [];
    List ng_in_last = [];
    List en_in_last = [];

    bool output = false;

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    var dateTimee;
    await getFluidBalanace(data).then((value) {
      if (value != null) {
        for (int i = 0; i < value.result[0].data.length; i++) {
          var item = value.result[0].data[i];

          dateTimee = '${item.date} ${item.time}:00';
          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                  DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
              ((item.item == "Nasogastric Tube" ||
                      item.item == 'Sonda Nasogástrica') &&
                  item.intOut == '1')) {
            ng_out_last.add(double.parse(item.ml));
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  ((item.item == "Nasogastric Tube" ||
                          item.item == 'Sonda Nasogástrica') &&
                      item.intOut == '1')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            ng_out_current.add(double.parse(item.ml));
          } else {}

          // getting here EN data for last or current IN

          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  (item.item == "Enteral Nutrition" && item.intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            en_in_last.add(double.parse(item.ml).toInt());
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  (item.item == "Enteral Nutrition" && item.intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            en_in_current.add(double.parse(item.ml).toInt());
          } else {}

          // getting here NG data for last or current IN and adding same list of EN data in

          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  ((item.item == "Nasogastric Tube" ||
                          item.item == 'Sonda Nasogástrica') &&
                      item.intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            ng_in_last.add(double.parse(item.ml).toInt());
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  ((item.item == "Nasogastric Tube" ||
                          item.item == 'Sonda Nasogástrica') &&
                      item.intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            ng_in_current.add(double.parse(item.ml).toInt());
          } else {}
        }

        // print("ng tube out in last day.... ${last_toggle_out_NGtube}");

        print('-----------current day-------------');
        print('ng_out_current : $ng_out_current');
        print('ng_in_current : $ng_in_current');
        print('en_in_current : $en_in_current');
        print('-----------last day-------------');
        print('ng_out_last : $ng_out_last');
        print('ng_in_last : $ng_in_last');
        print('en_in_last : $en_in_last');

        bool forCurrent = getEquationResult(ng_out_current, ng_in_current, en_in_current);
        print('forCurrent : $forCurrent');
        bool forLast = getEquationResult(ng_out_last, ng_in_last, en_in_last);
        print('forLast : $forLast');
        if (forCurrent || forLast) {
          output = true;
        }
      }
    });
    return output;
  }

  bool getEquationResult(
      List<dynamic> ngOut, List<dynamic> ngIn, List<dynamic> En) {
    double sumOut = 0.0;
    double sumIn = 0.0;
    double sumEn = 0.0;
    if(ngIn.isEmpty && En.isEmpty){
      return false;
    }
    for (var a in ngOut) {
      sumOut = sumOut + a;
    }
    for (var a in ngIn) {
      sumIn = sumIn + a;
    }
    for (var a in En) {
      sumEn = sumEn + a;
    }

    if (sumOut > (sumIn + sumEn)) {
      return true;
    } else {
      return false;
    }
    ;
  }
}
