import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';

import 'future_func.dart';

final HospitalSqflite sqflite = HospitalSqflite();

Future<Vigilance> getFluidBalanace(PatientDetailsData data) async {
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
        (element) =>
            element.type == VigiLanceBoxes.fluidBalance &&
            element.status == VigiLanceBoxes.fluidBalance_status,
        orElse: () => null);
  }

  return vigilanceData;
}


Future<Vigilance> get_mean_IapData(PatientDetailsData data) async {
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
            (element) =>
        element.type == VigiLanceBoxes.mean_IAP &&
            element.status == VigiLanceBoxes.meaIAP_status,
        orElse: () => null);
  }

  return vigilanceData;
}


Future<bool> get_mean_IapDataHIGH(PatientDetailsData data) async {
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
            (element) =>
        element.type == VigiLanceBoxes.mean_IAP &&
            element.status == VigiLanceBoxes.meaIAP_status,
        orElse: () => null);
  }

  if(vigilanceData==null){
    return false;
  }
  return vigilanceData.result.first.meansHighCheck??false;
}

Future<Vigilance> getCirculationData(PatientDetailsData data) async {
  print('geting circulation data ');
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
        (element) =>
            element.type == VigiLanceBoxes.circulation &&
            element.status == VigiLanceBoxes.circulation_status,
        orElse: () => null);
  }


  return vigilanceData;
}

Future<Vigilance> getTempData(PatientDetailsData data) async {
  print('geting temp data ');
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
        (element) =>
            element.type == VigiLanceBoxes.TempGlycemiaSheet &&
            element.status == VigiLanceBoxes.temp_status,
        orElse: () => null);
  }

  return vigilanceData;
}

Future<Vigilance> get_glycemiaData(PatientDetailsData data) async {
  print('geting gly data ');
  Vigilance vigilanceData;
  if (data.vigilance != null && data.vigilance.isNotEmpty) {
    vigilanceData = await data.vigilance.firstWhere(
        (element) =>
            element.type == VigiLanceBoxes.TempGlycemiaSheet &&
            element.status == VigiLanceBoxes.glycemiaSheet_status,
        orElse: () => null);
  }

  return vigilanceData;
}

Future<String> getWorkingDays(String hospId) async {
  String output;

  await sqflite.getHospitals().then((value) {
    // print('json resp: ${jsonEncode(value)}');
    print('hospId : ${hospId}');

    var data = value.data
        .firstWhere((element) => element.sId == hospId, orElse: () => null);

    if (data != null) {
      print('working days: ${data.workdays}');
      output = data.workdays;
    }
  });

  return output;
}

Future<List<int>> getFluidBalanceData(PatientDetailsData data) async {
  String workDay;
  Vigilance vigilanceData;
  await getWorkingDays(data.hospital[0].sId).then((workingDay) {
    workDay = workingDay;
    print('getting working days : ${workingDay}');
  });

  vigilanceData = await getFluidBalanace(data);

  List<int> output = [];

 if(vigilanceData!=null){
   print('vigilanceData not null');
   output = await filterWorkDay(vigilanceData.result[0].data, workDay, vigilanceData.result[0].balanceSince)??[];
 }

  return output;
}



Future<List<int>> filterWorkDay(List<vigi_resultData> _fuilddata, String workingday, String balanceSince) async {
  if (_fuilddata != null && _fuilddata.isNotEmpty) {
    int lastwork = 0;
    int lastwork_in = 0;
    int currentwork = 0;
    int currentwork_in = 0;

    print('getting vigilance len : ${_fuilddata.length}');

    for (var a in _fuilddata) {
      // print('date time ${DateTime.parse(a.date).difference(DateTime.now()).inDays}');
      //
      // print('index----- ${_fuilddata.indexOf(a)}');
      // print('item----- ${a.item}');

      print('obj : ${a.date} ${a.time}:00');
      var dateTimee = await '${a.date} ${a.time}:00';

      var today = '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
      var last = '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
      print('today --- ${today}');

      print('s d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

      bool get = await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) && DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
      bool curruntday = await DateTime.parse(dateTimee).isAfter(DateTime.parse(today));

      if (curruntday == true) {
        if (a.intOut == '0') {
          currentwork_in = currentwork_in + double.parse(a.ml).toInt();
        } else {
          currentwork = currentwork + double.parse(a.ml).toInt();
        }
      } else if (get == true) {
        if (a.intOut == '0') {
          lastwork_in = lastwork_in + double.parse(a.ml).toInt();
        } else {
          lastwork = lastwork + double.parse(a.ml).toInt();
        }
      }
    }

    print('last workday  : ${lastwork}');
    print('last workday in  : ${lastwork_in}');

    print('current workday  : ${currentwork}');
    print('current workday in  : ${currentwork_in}');

    print("last work day ${lastwork_in - lastwork}");
    print("current work day ${currentwork_in - currentwork}");

    int totalOut = 0;
    int totalIn = 0;
    var bal_since = '${DateFormat(commonDateFormat).format(DateTime.parse(balanceSince.isNotEmpty?balanceSince:"${DateTime.now()}"))} ${workingday}:00';

    print('bal_since date - ${bal_since}');

    if (bal_since != null && bal_since.isNotEmpty) {
      for (var b in _fuilddata) {
        print('getting in for loop');
        var dateTimee = await '${b.date} ${b.time}:00';
        print('gett ------- ${DateTime.parse(dateTimee).isAfter(DateTime.parse(bal_since))}');
        bool gett = DateTime.parse(dateTimee).isAfter(DateTime.parse(bal_since));
        if (gett) {
          if (b.intOut == '0') {
            totalIn = totalIn + double.parse(b.ml).toInt();
          } else {
            totalOut = totalOut + double.parse(b.ml).toInt();
          }
        }
      }
    }
    // else {
    //   for (var b in _fuilddata) {
    //     if (b.intOut == '0') {
    //       totalIn = totalIn + int.parse(b.ml);
    //     } else {
    //       totalOut = totalOut + int.parse(b.ml);
    //     }
    //   }
    // }

    print("last work day ${lastwork_in - lastwork}");
    print("current work day ${currentwork_in - currentwork}");

    print("total in ${totalIn}");
    print("total out ${totalOut}");
    print('balance -- ${totalOut - totalIn}');

    return [
      lastwork_in - lastwork,
      currentwork_in - currentwork,
      totalIn - totalOut
    ];
  }
}

Future<int> getPointsAbdomen(String bowelMovement, int bowelSound, int vomit,
    String abdomenDist, String ngTube, String meanLap) async {
  // NG TUBE > 500
  // BOWEL SOUNDS = ABSENT
  // VOMITING = PRESENT
  // ABDOMINAL DISTENSION = ANY OPTION DIFFERENT OF ABSENT
  // BOWEL MOVEMENTS = LIQUID - FEW (≥3/DAY) OR LIQUID - ABUNDANT (≥1/DAY)
  // ENTERAL NUTRITION INFUSED/PRESCRIBED < 20% (From NT BADGE)
  // mean IAP/24HS ≥ 12

  int points = 0;

  if (bowelMovement.trim() == 'Liquid - Few (1 or 2/day)'.trim() ||
      bowelMovement.trim() == 'Liquid - Abundant(1 or more/day)'.trim()) {
    points = points + 1;
    print('1 point for bowel movement');
  }

  if (bowelSound == 0) {
    points = points + 1;
    print('1 point for bowel sound');
  }

  if (vomit == 1) {
    points = points + 1;
    print('1 point for vomit');
  }

  if (abdomenDist.trim() != 'Absent'.trim()) {
    points = points + 1;
    print('1 point for abdomenDist');
  }

  if (ngTube.isNotEmpty && double.parse(ngTube) > 500.0) {
    points = points + 1;
    print('1 point for NG Tube');
  }

  if (meanLap.isNotEmpty && double.parse(meanLap) >= 12.0) {
    points = points + 1;
    print('1 point for mean IAP');
  }

  print('points $points');
  return points;
}

Future<String> getBalanceLastUpdatedDate(PatientDetailsData data) async {
  String output;
  Vigilance vigilance;
  await getFluidBalanace(data).then((value) {
    if (value != null) {
      vigilance = value;
    }
  });

  await getDateFormatFromString(vigilance.result.first.lastUpdate).then((date) {
    print('return date: ${date}');
    output = date;
  });

  print('return output: ${output}');
  return output;
}
