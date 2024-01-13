import 'dart:convert';

import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/model/indicator/multiple_patient_history.dart';
import 'package:medical_app/config/cons/bowel_movement.dart';

import 'package:medical_app/model/patientDetailsModel.dart';

import '../../config/Snackbars.dart';
import '../../config/cons/APIs.dart';
import '../../config/cons/Sessionkey.dart';
import '../../config/cons/cons.dart';
import '../../config/request.dart';
import '../../config/sharedpref.dart';
import '../../config/widgets/initial_loader.dart';
import '../../model/duration_date.dart';
import '../vigilance/abdomen_summary_controller.dart';

class DiarrheaConfig {
  AbdomenSummaryController _summaryController = AbdomenSummaryController();

  bool isEnteralUsing(PatientDetailsData pData, DurationDate durationDate) {
    bool output = false;
    if (!pData.ntdata.isNullOrBlank) {
      var getData = pData.ntdata.firstWhere(
          (it) =>
              it.type == NTBoxes.enteralFormula &&
              it.status == ENTERAL_STATUS.enteral_status &&
              (DateTime.parse(it.result.first.lastUpdate)
                      .isAfter(durationDate.startDate) &&
                  DateTime.parse(it.result.first.lastUpdate)
                      .isBefore(durationDate.endDate)),
          orElse: () => null);
      if (!getData.isNullOrBlank && getData.result.isNotEmpty) {
        // DateTime date = DateTime.parse()
        // if (durationDate.startDate.isAfter(_yesterdaydate) &&
        //     durationDate.endDate.isBefore(_todaydate))
        output = true;
      }
    }
    return output;
  }

  List<PatientDetailsData> patientsWithEn(
      List<PatientDetailsData> pList, DurationDate durationDate) {
    List<PatientDetailsData> output = [];
    for (var a in pList) {
      bool isUsingEn = isEnteralUsing(a, durationDate);
      if (isUsingEn) {
        output.add(a);
      }
    }
    return output;
  }

  Future<int> totalPatientsWithDiarrhea(List<PatientDetailsData> pList) async {
    int count = 0;
    for (var a in pList) {
      String summary = await _summaryController.getResultSummary(a);
      if (summary.contains('diarrhea'.tr)) {
        count++;
      }
    }
    return count;
  }

  Future<int> totalPatientsWithEn(List<PatientDetailsData> pList) async {
    int count = await pList.length;
    return count;
  }

  List<mHistory> abdomenData = <mHistory>[];
  List<mHistory> enData = <mHistory>[];

  void getHistoryData(String hospId, String wardId, String type) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(), barrierDismissible: false);
    // abdomenData.clear();
    // enData.clear();
    try {
      print(APIUrls.getMultiplePatientHistory);

      var payload;
      if (wardId == null) {
        payload = {
          'hospitalId': hospId,
          "type": type,
          'loggedUserId': userid,
        };
      } else {
        payload = {
          'hospitalId': hospId,
          'wardId': wardId,
          "type": type,
          'loggedUserId': userid,
        };
      }

      Request request =
          Request(url: APIUrls.getMultiplePatientHistory, body: payload);
      print(request.body);
      await request.post().then((value) {
        MultiplePatientHistory model =
            MultiplePatientHistory.fromJson(json.decode(value.body));
        print(model.success);
        Get.back();
        if (model.success == true) {
          switch (type) {
            case ConstConfig.abdomenHistory:
              abdomenData.addAll(model.data);
              adLog('abdomenData.length :: ${abdomenData.length}');
              break;
            default:
              enData.addAll(model.data);
              adLog('enData.length :: ${enData.length}');
              break;
          }
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }

  List<mHistory> dataWithEn(DurationDate durationDate) {
    List<mHistory> output = [];
    for (var a in enData) {
      bool isUsingEn = isEnUsing(a, durationDate);
      if (isUsingEn) {
        output.add(a);
      }
    }
    return output;
  }

  Future<List<mHistory>> dataWithDia(DurationDate durationDate,List<mHistory> usingEn) async {
    List<mHistory> output = [];
    for (var a in abdomenData) {
      bool isUsingDia = await isDiaUsing(a, durationDate,usingEn);
      if (isUsingDia) {
        output.add(a);
      }
    }
    return output;
  }

  bool isEnUsing(mHistory data, DurationDate durationDate) {
    bool output = false;
    if (!data.historyEn.isNullOrBlank) {
      var getData = data.historyEn.firstWhere(
          (it) => (DateTime.parse(it.multipalmessage.first.lastUpdate)
                  .isAfter(durationDate.startDate) &&
              DateTime.parse(it.multipalmessage.first.lastUpdate)
                  .isBefore(durationDate.endDate)),
          orElse: () => null);
      if (!getData.isNullOrBlank) {
        output = true;
      }
    }
    return output;
  }

  Future<bool> isDiaUsing(mHistory data, DurationDate durationDate,List<mHistory> usingEn) async {
    bool output = false;

    if (!data.historyAbdomen.isNullOrBlank) {
      // await data.historyAbdomen.forEach((it) {
      //   if ((it.multipalmessage.first.abdomenData.indexBowelMovement ==
      //           bowelMovement.LIQUID_FEW_3_DAY ||
      //       it.multipalmessage.first.abdomenData.indexBowelMovement ==
      //           bowelMovement.LIQUID_ABUNDANT_1_DAY)) {
      //     adLog('diarrhea => ${it.multipalmessage.first.abdomenData.indexBowelMovement}');
      //     adLog('diarrhea => ${it.multipalmessage.first.lastUpdate}');
      //   }
      // });


      var getData = await data.historyAbdomen.firstWhere(
          (it) =>

              //diarrhea condition
              (it.multipalmessage.first.abdomenData.indexBowelMovement ==
                      bowelMovement.LIQUID_FEW_3_DAY ||
                  it.multipalmessage.first.abdomenData.indexBowelMovement ==
                      bowelMovement.LIQUID_ABUNDANT_1_DAY) &&
              (DateTime.parse(it.multipalmessage.first.lastUpdate)
                      .isAfter(durationDate.startDate) &&
                  DateTime.parse(it.multipalmessage.first.lastUpdate)
                      .isBefore(durationDate.endDate)),
          orElse: () => null);
      if (!getData.isNullOrBlank) {

        // adLog('message');

        var enHistory = await usingEn.firstWhere((it) => it.patientId == data.patientId,orElse: ()=>null);

        if(enHistory!=null) {
    await  enHistory.historyEn.forEach((a)  {
           DateTime enDate = DateTime.parse(a.multipalmessage.first.lastUpdate);
           DateTime nextDate = DateTime.parse(a.multipalmessage.first.lastUpdate).add(Duration(days: 1));

           adLog(dateFormat.format(nextDate));

           DateTime nextdate2 = DateTime.parse( '${dateFormat.format(nextDate)} 23:59:59');

           DateTime diarrheaDate = DateTime.parse(getData.multipalmessage.first.lastUpdate);

           adLog('getting en history=> enDate : $enDate  nextDate : $nextdate2  diarrheaDate : $diarrheaDate');


           adLog('endate ${diarrheaDate.isAfter(enDate) && diarrheaDate.isBefore(nextdate2)}');

           if(diarrheaDate.isAfter(enDate) && diarrheaDate.isBefore(nextdate2)) {
             output = true;
           }



          });
        }



      }
    }
    return output;
  }
}
