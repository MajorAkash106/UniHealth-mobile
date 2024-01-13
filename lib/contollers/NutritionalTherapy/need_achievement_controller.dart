// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:medical_app/config/funcs/NTfunc.dart';
// import 'package:medical_app/config/funcs/future_func.dart';
// import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
// import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
// import 'package:medical_app/model/NutritionalTherapy/needs.dart';
// import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
// import 'package:medical_app/model/patientDetailsModel.dart';
//
// class NeedsController extends GetxController {
//   Future<String> getCurrentData(PatientDetailsData data) async {
//     // print('ONS len : ${onsData.result[0].onsData.length}');
//
//     FastingOralData lastOral = await getLastOralData(data);
//     FastingOralData currentOral = await getCurrentOralData(data);
//     Ons lastOns = await getLastOns(data);
//     Ons currentOns = await getCurrentOns(data);
//
//     OralData todayOralAccep = await getORALDetailsToday(data);
//     OralData LastOralAccep = await getORALDetailsYesterday(data);
//
//     print('lastOral ${lastOral}');
//     print('currentOral ${currentOral}');
//     print('lastOns ${lastOns}');
//     print('currentOns ${currentOns}');
//     print('todayOralAccep ${todayOralAccep}');
//     print('LastOralAccep ${LastOralAccep}');
//
//     // last ons
//     double onsKcal = double.parse(lastOns.kcal);
//     double onsPtn = double.parse(lastOns.ptn);
//     double onsAccept = double.parse(lastOns.per.replaceAll("%", ''));
//
//     //current ons
//     double onsKcalC = double.parse(currentOns.kcal);
//     double onsPtnC = double.parse(currentOns.ptn);
//     double onsAcceptC = double.parse(currentOns.per.replaceAll("%", ''));
//
//     //last oral
//     double oralKcal = double.parse(lastOral.kcal);
//     double orlPtn = double.parse(lastOral.ptn);
//     double oralAccept = double.parse(LastOralAccep.average);
//
//     //current oral
//     double oralKcalC = double.parse(currentOral.kcal);
//     double orlPtnC = double.parse(currentOral.ptn);
//     double oralAcceptC = double.parse(todayOralAccep.average);
//
//     //last oral kcal
//     double oralKcalL = (oralKcal * oralAccept) + (onsKcal * onsAccept);
//     //current oral kcal
//     double oralKcalCC = (oralKcalC * oralAcceptC) + (onsKcalC * onsAcceptC);
//
//     //last
//     double oralPtn = (orlPtn * oralAccept) + (onsPtn * onsAccept);
//
//     double oralPtnC = (orlPtnC * oralAcceptC) + (onsPtnC * onsAcceptC);
//
//     print('last work : ${oralKcalL} - ${oralPtn}');
//
//     print('current work : ${oralKcalCC} - ${oralPtnC}');
//
//     double a = oralKcal * oralAccept / 100;
//     double b = oralKcalC * oralAccept / 100;
//
//     print('a & b : ${a} - ${b}');
//
//     // Map finalData = {
//     //   ""
//     // };
//   }
//
//   Future<FastingOralData> getLastOralData(PatientDetailsData data) async {
//     DateTime lastworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
//     DateTime currentworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now());
//     FastingOralData output;
//     Ntdata oralData = await getFAsting(data);
//
//     if (oralData != null &&
//         oralData.result.first.fastingOralData != null &&
//         oralData.result.first.fastingOralData.isNotEmpty) {
//       for (var a in oralData.result.first.fastingOralData) {
//         DateTime _date = DateTime.parse(a.lastUpdate);
//
//         if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
//           output = a;
//           break;
//         }
//       }
//     }
//     return output;
//   }
//
//   Future<FastingOralData> getCurrentOralData(PatientDetailsData data) async {
//     // DateTime lastworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
//     DateTime currentworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now());
//     FastingOralData output;
//     Ntdata oralData = await getFAsting(data);
//
//     if (oralData != null &&
//         oralData.result.first.fastingOralData != null &&
//         oralData.result.first.fastingOralData.isNotEmpty) {
//       for (var a in oralData.result.first.fastingOralData) {
//         DateTime _date = DateTime.parse(a.lastUpdate);
//
//         if (_date.isAfter(currentworkday)) {
//           output = a;
//           break;
//         }
//       }
//     }
//     return output;
//   }
//
//   Future<Ons> getLastOns(PatientDetailsData data) async {
//     DateTime lastworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
//     DateTime currentworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now());
//     Ons output;
//     Ntdata onsData = await getONS(data);
//     if (onsData != null &&
//         onsData.result.first.onsData != null &&
//         onsData.result.first.onsData.isNotEmpty) {
//       for (var a in onsData.result.first.onsData) {
//         DateTime _date = DateTime.parse(a.lastUpdate);
//
//         if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
//           output = a;
//           break;
//         }
//       }
//     }
//     return output;
//   }
//
//   Future<Ons> getCurrentOns(PatientDetailsData data) async {
//     // DateTime lastworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
//     DateTime currentworkday = await getDateTimeWithWorkdayHosp(
//         data.hospital.first.sId, DateTime.now());
//     Ons output;
//     Ntdata onsData = await getONS(data);
//     if (onsData != null &&
//         onsData.result.first.onsData != null &&
//         onsData.result.first.onsData.isNotEmpty) {
//       for (var a in onsData.result.first.onsData) {
//         DateTime _date = DateTime.parse(a.lastUpdate);
//
//         if (_date.isAfter(currentworkday)) {
//           output = a;
//           break;
//         }
//       }
//     }
//     return output;
//   }
//
//   Future<List<Needs>> getNeedsData(PatientDetailsData data, Needs addItem,String type,) async {
//
//
//     List<Needs> needsData = [];
//     needsData.add(addItem);
//     if (data.needs != null && data.needs.isNotEmpty) {
//
//       needsData.addAll(data.needs);
//     }
//
//
//
//     if(needsData.isNotEmpty){
//       List<Needs> getUpdated = await  removeSameOb(needsData,data.hospital[0].sId,type,);
//
//       needsData.clear();
//       needsData.addAll(getUpdated);
//
//     }
//
//     return needsData;
//   }
//
//
//   Future<List<Needs>> removeSameOb(List<Needs> data,String hospId,String type,{String type2})async{
//     DateTime lastworkday = await getDateTimeWithWorkdayHosp(hospId, DateTime.now().subtract(Duration(days: 1)));
//     DateTime currentworkdayStart = await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
//     DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(hospId, DateTime.now().add(Duration(days: 1)));
//     List<Needs> output = [];
//     if(data!=null && data.isNotEmpty){
//
//       List<Needs>currentDay = [];
//       List<Needs>lastDay = [];
//       List<Needs>previousDay = [];
//
//       List<Needs>currentDay2 = [];
//       List<Needs>lastDay2 = [];
//
//       for(var b in data){
//         print(b.type);
//         print("b.type");
//         DateTime _date = DateTime.parse(b.lastUpdate);
//         if((_date.isAfter(currentworkdayStart) && _date.isBefore(currentworkdayEnd) && b.type == type)){
//           currentDay.add(b);
//         }else if((_date.isAfter(lastworkday) && _date.isBefore(currentworkdayStart) && b.type == type)){
//          lastDay.add(b);
//         }
//         else if(type2!=null){
//           if((_date.isAfter(currentworkdayStart) && _date.isBefore(currentworkdayEnd) && b.type == type2)){
//             currentDay2.add(b);
//           }
//           else if((_date.isAfter(lastworkday) && _date.isBefore(currentworkdayStart) && b.type == type2)){
//             lastDay2.add(b);
//           }
//         }
//         else{
//           previousDay.add(b);
//         }
//
//
//
//
//
//       }
//
//
//       print('current : ${currentDay.length}');
//
//       if(currentDay!=null && currentDay.isNotEmpty){
//         Needs current = await updatedDateSelect(currentDay);
//         output.add(current);
//       }
//       if(lastDay!=null && lastDay.isNotEmpty){
//         Needs last = await updatedDateSelect(lastDay);
//         output.add(last);
//       }
//       if(currentDay2!=null && currentDay2.isNotEmpty){
//         Needs current2 = await updatedDateSelect(currentDay2);
//         output.add(current2);
//       }
//       if(lastDay2!=null && lastDay2.isNotEmpty){
//         Needs last2 = await updatedDateSelect(lastDay2);
//         output.add(last2);
//       }
//
//
//     output.addAll(previousDay);
//
//
//
//     return output;
//     }
//
//   }
//
//   Future<Needs> updatedDateSelect(List<Needs> list) async {
//
//     // print('get all objects needs : ${list.length}');
//     // print('get all objects needs 1 : ${jsonEncode(list[0])}');
//     // print('get all objects needs 2 : ${jsonEncode(list[1])}');
//     list.sort((b, a) => DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
//     return list[0];
//   }
//
//
//
//
//
//
// }

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class NeedsController extends GetxController {
  Future<String> getCurrentData(PatientDetailsData data) async {
    // print('ONS len : ${onsData.result[0].onsData.length}');

    FastingOralData lastOral = await getLastOralData(data);
    FastingOralData currentOral = await getCurrentOralData(data);
    Ons lastOns = await getLastOns(data);
    Ons currentOns = await getCurrentOns(data);

    OralData todayOralAccep = await getORALDetailsToday(data);
    OralData LastOralAccep = await getORALDetailsYesterday(data);

    print('lastOral ${lastOral}');
    print('currentOral ${currentOral}');
    print('lastOns ${lastOns}');
    print('currentOns ${currentOns}');
    print('todayOralAccep ${todayOralAccep}');
    print('LastOralAccep ${LastOralAccep}');

    // last ons
    double onsKcal = double.parse(lastOns.kcal);
    double onsPtn = double.parse(lastOns.ptn);
    double onsAccept = double.parse(lastOns.per.replaceAll("%", ''));

    //current ons
    double onsKcalC = double.parse(currentOns.kcal);
    double onsPtnC = double.parse(currentOns.ptn);
    double onsAcceptC = double.parse(currentOns.per.replaceAll("%", ''));

    //last oral
    double oralKcal = double.parse(lastOral.kcal);
    double orlPtn = double.parse(lastOral.ptn);
    double oralAccept = double.parse(LastOralAccep.average);

    //current oral
    double oralKcalC = double.parse(currentOral.kcal);
    double orlPtnC = double.parse(currentOral.ptn);
    double oralAcceptC = double.parse(todayOralAccep.average);

    //last oral kcal
    double oralKcalL = (oralKcal * oralAccept) + (onsKcal * onsAccept);
    //current oral kcal
    double oralKcalCC = (oralKcalC * oralAcceptC) + (onsKcalC * onsAcceptC);

    //last
    double oralPtn = (orlPtn * oralAccept) + (onsPtn * onsAccept);

    double oralPtnC = (orlPtnC * oralAcceptC) + (onsPtnC * onsAcceptC);

    print('last work : ${oralKcalL} - ${oralPtn}');

    print('current work : ${oralKcalCC} - ${oralPtnC}');

    double a = oralKcal * oralAccept / 100;
    double b = oralKcalC * oralAccept / 100;

    print('a & b : ${a} - ${b}');

    // Map finalData = {
    //   ""
    // };
  }

  Future<FastingOralData> getLastOralData(PatientDetailsData data) async {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    FastingOralData output;
    Ntdata oralData = await getFAsting(data);

    if (oralData != null &&
        oralData.result.first.fastingOralData != null &&
        oralData.result.first.fastingOralData.isNotEmpty) {
      for (var a in oralData.result.first.fastingOralData) {
        DateTime _date = DateTime.parse(a.lastUpdate);

        if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
          output = a;
          break;
        }
      }
    }
    return output;
  }

  Future<FastingOralData> getCurrentOralData(PatientDetailsData data) async {
    // DateTime lastworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    FastingOralData output;
    Ntdata oralData = await getFAsting(data);

    if (oralData != null &&
        oralData.result.first.fastingOralData != null &&
        oralData.result.first.fastingOralData.isNotEmpty) {
      for (var a in oralData.result.first.fastingOralData) {
        DateTime _date = DateTime.parse(a.lastUpdate);

        if (_date.isAfter(currentworkday)) {
          output = a;
          break;
        }
      }
    }
    return output;
  }

  Future<Ons> getLastOns(PatientDetailsData data) async {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    Ons output;
    Ntdata onsData = await getONS(data);
    if (onsData != null &&
        onsData.result.first.onsData != null &&
        onsData.result.first.onsData.isNotEmpty) {
      for (var a in onsData.result.first.onsData) {
        DateTime _date = DateTime.parse(a.lastUpdate);

        if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
          output = a;
          break;
        }
      }
    }
    return output;
  }

  Future<Ons> getCurrentOns(PatientDetailsData data) async {
    // DateTime lastworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());
    Ons output;
    Ntdata onsData = await getONS(data);
    if (onsData != null &&
        onsData.result.first.onsData != null &&
        onsData.result.first.onsData.isNotEmpty) {
      for (var a in onsData.result.first.onsData) {
        DateTime _date = DateTime.parse(a.lastUpdate);

        if (_date.isAfter(currentworkday)) {
          output = a;
          break;
        }
      }
    }
    return output;
  }

  Future<List<Needs>> getNeedsData(
      PatientDetailsData data, Needs addItem, String type) async {
    List<Needs> needsData = [];
    needsData.add(addItem);
    if (data.needs != null && data.needs.isNotEmpty) {
      needsData.addAll(data.needs);
    }

    if (needsData.isNotEmpty) {
      List<Needs> getUpdated = await removeSameOb(needsData, data.hospital[0].sId, type);

      needsData.clear();
      needsData.addAll(getUpdated);
    }

    return needsData;
  }

  Future<List<Needs>> removeSameOb(
      List<Needs> data, String hospId, String type) async {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().subtract(Duration(days: 1)));
    DateTime currentworkdayStart =
        await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
    DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(
        hospId, DateTime.now().add(Duration(days: 1)));
    List<Needs> output = [];
    if (data != null && data.isNotEmpty) {
      List<Needs> currentDay = [];
      List<Needs> lastDay = [];
      List<Needs> previousDay = [];
      for (var b in data) {
        DateTime _date = DateTime.parse(b.lastUpdate);
        if ((_date.isAfter(currentworkdayStart) &&
            _date.isBefore(currentworkdayEnd) &&
            b.type == type)) {
          currentDay.add(b);
        } else if ((_date.isAfter(lastworkday) &&
            _date.isBefore(currentworkdayStart) &&
            b.type == type)) {
          lastDay.add(b);
        } else {
          previousDay.add(b);
        }
      }

      print('current : ${currentDay.length}');

      if (currentDay != null && currentDay.isNotEmpty) {
        Needs current = await updatedDateSelect(currentDay);
        output.add(current);
      }
      if (lastDay != null && lastDay.isNotEmpty) {
        Needs last = await updatedDateSelect(lastDay);
        output.add(last);
      }

      output.addAll(previousDay);

      return output;
    }
  }

  Future<Needs> updatedDateSelect(List<Needs> list) async {
    // print('get all objects needs : ${list.length}');
    // print('get all objects needs 1 : ${jsonEncode(list[0])}');
    // print('get all objects needs 2 : ${jsonEncode(list[1])}');
    list.sort((b, a) =>
        DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
    return list[0];
  }

  Future<FilterLast_Current_Day_Needs> getNeeds_achievementData(
      PatientDetailsData data, String hospitalId) async {
    List<Needs> needsList = [];
    List<Needs> lastDayNeedsData = [];
    lastDayNeedsData = [];
    List<Needs> currentDayNeedsData = [];

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    final lastDay = DateTime(now.year, now.month, now.day - 1);
    String tommorowFormattedDate = DateFormat('yyyy-MM-dd').format(lastDay);
    var ed = "${tommorowFormattedDate}" + " " + workingday;
    DateTime LastWorkStart = DateTime.parse(ed);
    print("===last work day date ${LastWorkStart}");

    if (data.needs.length != null) {
      needsList = data.needs;
      print("===needs list length ${needsList.length}");
    }else{
      return null;
    }

    for (int i = 0; i < needsList.length; i++) {
      DateTime dateTime = DateTime.parse(needsList[i].lastUpdate);
      print("===dateTime ${dateTime}");

      if (dateTime.isAfter(LastWorkEndCurrentStart) &&
          dateTime.isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
        currentDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal));
      } else if (dateTime.isBefore(LastWorkEndCurrentStart) &&
          dateTime.isAfter(LastWorkStart)) {
        lastDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal));
      }
    }

    print("===length of lastDayNeedsData ${lastDayNeedsData.length}");
    print("===length of currentDayNeedsData ${currentDayNeedsData.length}");

    return FilterLast_Current_Day_Needs(
        last_day_needs_data: lastDayNeedsData,
        current_day_needs_data: currentDayNeedsData,
        since_admit_needs_data: needsList);
  }

  Future<Needs_achiveivementData> showNeed_AchievementData(
      PatientDetailsData data, String hospitalId) async {
    FilterLast_Current_Day_Needs needs_data =
        await getNeeds_achievementData(data, hospitalId);

    double kcal_max = 0;
    double kcal_min = 0;
    double ptn_max = 0;
    double ptn_min = 0;

    needs_data.current_day_needs_data.forEach((e) {
      kcal_max += double.parse(e.plannedKcal);
    });
    print(kcal_max);
    print("kcal_max");

    needs_data.current_day_needs_data.forEach((e) {
      kcal_min += double.parse(e.achievementKcal);
    });
    print(kcal_min);
    print("kcal_min");

    needs_data.current_day_needs_data.forEach((e) {
      ptn_max += double.parse(e.plannedPtn);
    });
    print(ptn_max);
    print("ptn_max");

    needs_data.current_day_needs_data.forEach((e) {
      ptn_min += double.parse(e.achievementProtein);
    });
    print(ptn_min);
    print("ptn_min");

    double last_kcal_max = 0;
    double last_kcal_min = 0;
    double last_ptn_max = 0;
    double last_ptn_min = 0;

    needs_data.last_day_needs_data.forEach((e) {
      last_kcal_max += double.parse(e.plannedKcal);
    });
    print(last_kcal_max);
    print("last_kcal_max");

    needs_data.last_day_needs_data.forEach((e) {
      last_kcal_min += double.parse(e.achievementKcal);
    });
    print(last_kcal_min);
    print("last_kcal_min");

    needs_data.last_day_needs_data.forEach((e) {
      last_ptn_max += double.parse(e.plannedPtn);
    });
    print(last_ptn_max);
    print("last_ptn_max");

    needs_data.last_day_needs_data.forEach((e) {
      last_ptn_min += double.parse(e.achievementProtein);
    });
    print(last_ptn_min);
    print("last_ptn_min");

    double sinceAdmt_kcal_max = 0;
    double sinceAdmt_kcal_min = 0;
    double sinceAdmt_ptn_max = 0;
    double sinceAdmt_ptn_min = 0;

    needs_data.since_admit_needs_data.forEach((e) {
      sinceAdmt_kcal_max += double.parse(e.plannedKcal);
    });
    print(sinceAdmt_kcal_max);
    print("sinceAdmt_kcal_max");

    needs_data.since_admit_needs_data.forEach((e) {
      sinceAdmt_kcal_min += double.parse(e.achievementKcal);
    });
    print(sinceAdmt_kcal_min);
    print("sinceAdmt_kcal_min");

    needs_data.since_admit_needs_data.forEach((e) {
      sinceAdmt_ptn_max += double.parse(e.plannedPtn);
    });
    print(sinceAdmt_ptn_max);
    print("sinceAdmt_ptn_max");

    needs_data.since_admit_needs_data.forEach((e) {
      sinceAdmt_ptn_min += double.parse(e.achievementProtein);
    });
    print(sinceAdmt_ptn_min);
    print("sinceAdmt_ptn_min");

    return Needs_achiveivementData(
        kcal_max: kcal_max,
        kcal_min: kcal_min,
        ptn_max: ptn_max,
        ptn_min: ptn_min,
        last_kcal_max: last_kcal_max,
        last_kcal_min: last_kcal_min,
        last_ptn_max: last_ptn_max,
        last_ptn_min: last_ptn_min,
        since_kcal_max: sinceAdmt_kcal_max,
        since_kcal_min: sinceAdmt_kcal_min,
        since_ptn_max: sinceAdmt_ptn_max,
        since_ptn_min: sinceAdmt_ptn_min);
  }



  Future<Filter_Need_Achievement_data> checkAchievementPercent(
      PatientDetailsData data) async {
    List<Needs> needsList = [];
    List<Needs> achievementPtnListLessThan75Perc = [];
    List<Needs> achievementKcalListLessThan75Perc = [];
    double needPtnPerc = 0.0;
    double needKcalPerc = 0.0;

    if (data.needs.length != null) {
      needsList = data?.needs;
      print("===needs list length ${needsList.length}");
    }

    for (int i = 0; i < needsList?.length; i++) {
      if (needsList[i].plannedPtn.isNotEmpty &&
          needsList[i].plannedPtn != "0.0" &&
          needsList[i].achievementProtein != "Nan" &&
          needsList[i].plannedPtn != "Nan" &&
          needsList[i].plannedPtn != null) {
        needPtnPerc = (double.parse(needsList[i]?.achievementProtein) * 100) /
            double.parse(needsList[i].plannedPtn);
        print("===need protein perc ${needPtnPerc}");
      } else {
        needPtnPerc = null;
      }

      if (needsList[i].plannedKcal.isNotEmpty &&
          needsList[i].plannedKcal != "0.0" &&
          needsList[i].achievementKcal != "Nan" &&
          needsList[i].plannedKcal != "Nan" &&
          needsList[i].plannedKcal != null) {
        needKcalPerc = (double.parse(needsList[i]?.achievementKcal) * 100) /
            double.parse(needsList[i].plannedKcal);
        print("===need kcal perc ${needKcalPerc}");
      } else {
        needKcalPerc = null;
      }

      if (needPtnPerc != null && needPtnPerc.toInt() < 75) {
        achievementPtnListLessThan75Perc.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            achievementProtein: needsList[i].achievementProtein,
            achievementKcal: needsList[i].achievementKcal,
            plannedKcal: needsList[i].plannedKcal,
            plannedPtn: needsList[i].plannedPtn,
            type: needsList[i].type));
      } else {}

      if (needKcalPerc != null && needKcalPerc.toInt() < 75) {
        achievementKcalListLessThan75Perc.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            achievementProtein: needsList[i].achievementProtein,
            achievementKcal: needsList[i].achievementKcal,
            plannedKcal: needsList[i].plannedKcal,
            plannedPtn: needsList[i].plannedPtn,
            type: needsList[i].type));
      } else {}
    }

    print(
        "===protein achievemnt list ${achievementPtnListLessThan75Perc.length}");
    print(
        "===kcal achievemnt list ${achievementKcalListLessThan75Perc.length}");

    return Filter_Need_Achievement_data(
        ptn_achievement_data: achievementPtnListLessThan75Perc,
        kcal_achievement_data: achievementKcalListLessThan75Perc);
  }

  Sum_Of_protein_kacl get_sum({List<Needs> proteinList, List<Needs> kaclList})  {
    double achievemnt_protein_total_sum = 0.0;
    double achievemnt_kacl_total_sum = 0.0;
    double planned_kacl_total_sum = 0.0;
    double planned_ptn_total_sum = 0.0;

    for (int i = 0; i < proteinList.length; i++) {
      achievemnt_protein_total_sum = achievemnt_protein_total_sum +
          double.parse(proteinList[i].achievementProtein);
      planned_ptn_total_sum =
          planned_ptn_total_sum + double.parse(proteinList[i].plannedPtn);
    }
    print(
        "==total sum of all achievemnt protein${achievemnt_protein_total_sum}");
    print("==total sum of all planned protein${planned_ptn_total_sum}");
    for (int i = 0; i < kaclList.length; i++) {
      achievemnt_kacl_total_sum =
          achievemnt_kacl_total_sum + double.parse(kaclList[i].achievementKcal);
      planned_kacl_total_sum =
          planned_kacl_total_sum + double.parse(kaclList[i].plannedKcal);
    }
    print("==total sum of all achievement kacl${achievemnt_kacl_total_sum}");
    print("==total sum of all planned kacl${planned_kacl_total_sum}");



    return Sum_Of_protein_kacl(
        achievemnt_protein_total_sum: achievemnt_protein_total_sum,
        planned_ptn_total_sum: planned_ptn_total_sum,
        achievemnt_kacl_total_sum: achievemnt_kacl_total_sum,
        planned_kacl_total_sum: planned_kacl_total_sum);
  }



  Future<FilterLast_Current_Day_Needs> getNeeds_achievementData_less_than50Perc(
      PatientDetailsData data, String hospitalId) async 
  {
    List<Needs> needsList = [];
    List<Needs> lastDayNeedsData = [];

    List<Needs> currentDayNeedsData = [];
    List<Needs> lastPreviousDayNeedsData = [];

    String workingday = await getWorkingDays(hospitalId);

    print("===working day ${workingday}");

    DateTime now = DateTime.now();
    String todayFormattedDate = DateFormat('yyyy-MM-dd').format(now);
    var startDate = "${todayFormattedDate}" + " " + workingday;
    DateTime LastWorkEndCurrentStart = DateTime.parse(startDate);
    print("===current Date ${LastWorkEndCurrentStart}");

    final lastDay = DateTime(now.year, now.month, now.day - 1);
    String tommorowFormattedDate = DateFormat('yyyy-MM-dd').format(lastDay);
    var ed = "${tommorowFormattedDate}" + " " + workingday;
    DateTime LastWorkStart = DateTime.parse(ed);
    print("===last work day date ${LastWorkStart}");

    if (data.needs != null && data.needs.length != 0) {
      needsList = data.needs;
      print("===needs list length ${needsList.length}");
    }

    for (int i = 0; i < needsList.length; i++) {
      DateTime dateTime = DateTime.parse(needsList[i].lastUpdate);
      print("===dateTime ${dateTime}");

      if (dateTime.isAfter(LastWorkEndCurrentStart) &&
          dateTime.isBefore(LastWorkEndCurrentStart.add(Duration(days: 1)))) {
        currentDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal));
      } else if (dateTime.isBefore(LastWorkEndCurrentStart) &&
          dateTime.isAfter(LastWorkStart)) {
        lastDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal));
      }
      else if(dateTime.isAfter(LastWorkStart.subtract(Duration(days:1))) && dateTime.isBefore(LastWorkStart)){
        lastPreviousDayNeedsData.add(Needs(
            lastUpdate: needsList[i].lastUpdate,
            type: needsList[i].type,
            achievementKcal: needsList[i].achievementKcal,
            achievementProtein: needsList[i].achievementProtein,
            plannedPtn: needsList[i].plannedPtn,
            plannedKcal: needsList[i].plannedKcal));
      }
    }

    print("===length of lastDayNeedsData ${lastDayNeedsData.length}");
    print("===length of currentDayNeedsData ${currentDayNeedsData.length}");
    print("===length of lastPreviousDayNeedsData ${lastPreviousDayNeedsData.length}");

    return FilterLast_Current_Day_Needs(
        last_day_needs_data: lastDayNeedsData,
        current_day_needs_data: currentDayNeedsData,
        last_previous_day_needs_data: lastPreviousDayNeedsData);
  }














}

class Filter_Need_Achievement_data {
  List<Needs> ptn_achievement_data = [];
  List<Needs> kcal_achievement_data = [];

  Filter_Need_Achievement_data(
      {this.ptn_achievement_data, this.kcal_achievement_data});
}

class FilterLast_Current_Day_Needs {
  List<Needs> last_day_needs_data = [];
  List<Needs> current_day_needs_data = [];
  List<Needs> last_previous_day_needs_data = [];
  List<Needs> since_admit_needs_data = [];

  FilterLast_Current_Day_Needs(
      {this.current_day_needs_data,
      this.last_day_needs_data,
      this.since_admit_needs_data,this.last_previous_day_needs_data});
}

class Needs_achiveivementData {
  double kcal_max = 0;
  double kcal_min = 0;
  double ptn_max = 0;
  double ptn_min = 0;

  double last_kcal_max = 0;
  double last_kcal_min = 0;
  double last_ptn_max = 0;
  double last_ptn_min = 0;

  double since_kcal_max = 0;
  double since_kcal_min = 0;
  double since_ptn_max = 0;
  double since_ptn_min = 0;

  Needs_achiveivementData(
      {this.kcal_max,
      this.kcal_min,
      this.ptn_max,
      this.ptn_min,
      this.last_kcal_max,
      this.last_kcal_min,
      this.last_ptn_max,
      this.last_ptn_min,
      this.since_kcal_max,
      this.since_kcal_min,
      this.since_ptn_max,
      this.since_ptn_min});
}

class Sum_Of_protein_kacl {
  double achievemnt_protein_total_sum = 0.0;
  double achievemnt_kacl_total_sum = 0.0;
  double planned_kacl_total_sum = 0.0;
  double planned_ptn_total_sum = 0.0;

  Sum_Of_protein_kacl(
      {this.achievemnt_protein_total_sum,
      this.planned_ptn_total_sum,
      this.achievemnt_kacl_total_sum,
      this.planned_kacl_total_sum});
}
