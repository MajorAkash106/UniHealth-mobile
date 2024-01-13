import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/contollers/status_controller/CDC_Controller.dart';
import 'package:medical_app/contollers/status_controller/WHO_Controller_updated.dart';
import 'package:medical_app/model/hospitalListModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import '../../contollers/patient&hospital_controller/save_history_controller.dart';

Future<String> GETESPEN(PatientDetailsData patientDetailsData) async {
  String output = '';
  for (var a in patientDetailsData.status) {
    if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.espen.trim()) {
      output = await a.result[0].espen_output;

      break;
    }
  }

  return output;
}

Future<bool> ISNRSORMUST(PatientDetailsData patientDetailsData) async {
  bool output = false;
  for (var a in patientDetailsData.status) {
    if (a.type == '0' &&
        (a.status.trim() == 'NRS - 2002'.trim() ||
            a.status.trim() == 'MUST'.trim())) {
      output = await true;

      break;
    }
  }

  return output;
}

Future<String> GETWHORESULT(PatientDetailsData patientDetailsData) async {
  // String output = '';
  // for (var a in patientDetailsData.status) {
  //   if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.who.trim()) {
  //     output = await a.result[0].who_output;
  //
  //     break;
  //   }
  // }

  final WhoControllerUpdated controller = WhoControllerUpdated();
  WHOOutput data = await controller.getWHO(patientDetailsData);
  String output = "z = ${data.zScore}; p = ${data.percentile}; ${data.condition}; ${data.result}".toUpperCase();

  return output;
}
Future<String> GETCDCRESULT(PatientDetailsData patientDetailsData) async {
  // String output = '';
  // for (var a in patientDetailsData.status) {
  //   if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.who.trim()) {
  //     output = await a.result[0].cdc_output;
  //
  //     break;
  //   }
  // }

 final CDCController controller = CDCController();
  CDCOutput cdcData = await controller.getCDC(patientDetailsData);
  String output = "z = ${cdcData.zScore}; p = ${cdcData.percentile}; ${cdcData.condition}; ${cdcData.result}".toUpperCase();
  isCDCChange(output,patientDetailsData.sId);

  return output;
}


void isCDCChange(String cdcOutput,String patientId)async{

  String getCDC = await MySharedPreferences.instance.getStringValue(ConstConfig.CDCHistory)??'';

  if(getCDC != cdcOutput){
    debugPrint('cdcOutput changed');
    MySharedPreferences.instance.setStringValue(ConstConfig.CDCHistory, cdcOutput);
    final HistoryController _historyController = HistoryController();
    _historyController.saveHistoryWihtoutLoader(
        patientId,
        ConstConfig.CDCHistory,cdcOutput
        );
  }else{
    debugPrint('cdcOutput not changed');
  }

}



Future<String> LASTUPDATEDIAGNOSIS(
    PatientDetailsData patientDetailsData) async {
  String output = '';
  List<DateTime> datess = [];
  for (var a in patientDetailsData.status) {
    if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.espen.trim()) {
      await datess.add(DateTime.parse(a.result[0].lastUpdate));
    }

    if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.glim.trim()) {
      await datess.add(DateTime.parse(a.result[0].lastUpdate));
    }

    if (a.type == '2' && a.status.trim() == nutritionalDiagnosis.who.trim()) {
      await datess.add(DateTime.parse(a.result[0].lastUpdate));
    }
  }

  await updatedDate(datess).then((value) {
    output = value;
  });

  return output;
}

DateFormat dateFormat = DateFormat("yyyy-MM-dd");
Future<String> updatedDate(List<DateTime> list) async {
  list.sort((b, a) => a.compareTo(b));
  return '${dateFormat.format(list[0])}';
}

Future<PatientDetailsData> returnPatientDAtaFromNRS(PatientDetailsData data,
    int score, Map dataa, String status, String type) async {
  List<Result> resultList = [];
  var encoded = jsonEncode(dataa);
  Result _result = await Result.fromJson(jsonDecode(encoded));
  await resultList.add(_result);

  print('result----${jsonEncode(_result)}');

  StatusData statusData = StatusData();

  statusData.status = await status;
  statusData.type = await type;
  statusData.score = await score.toString();
  statusData.result = await resultList;
  statusData.userId = await data.sId;
  //
  // print('resp---- ${jsonEncode(statusData.result)}');
  // print('resp---- ${jsonEncode(resultList.length)}');

  if (data.status != null && data.status.length != 0) {
    var statusObj = await data?.status?.firstWhere(
        (element) => element.type == type && element.status == status,
        orElse: () => null);

    if (statusObj != null) {
      await data.status.remove(statusObj);
      await data.status.add(statusData);
    } else {
      await data.status.add(statusData);
    }
  } else {
    await data.status.add(statusData);
  }

  print('updated data-----${jsonEncode(data)}');
  print('updated data-----${jsonEncode(data.status)}');

  return data;
}

Future<bool> isOfflineOnlineJourney(String hospId) async {
  final HospitalSqflite sqflite = HospitalSqflite();

  HospitalListData hospitalListData = HospitalListData();

  await sqflite.getHospitals().then((resp) {
    hospitalListData = resp.data.firstWhere((element) => element.sId == hospId, orElse: () => null);
  });

  print(hospitalListData.istoggle);
  return hospitalListData?.istoggle ?? false;
}

Future<String> getDateWithMonthName(String date) async {
  var months = [
    "jan".tr,
    "feb".tr,
    "mar".tr,
    "april".tr,
    "may".tr,
    "june".tr,
    "july".tr,
    "aug".tr,
    "sep".tr,
    "oct".tr,
    "nov".tr,
    "dec".tr
  ];

  if (date != null && date.isNotEmpty) {
    String data =
        "${DateTime.parse(date).day} ${months[DateTime.parse(date).month - 1]}";
    print('date : $data');

    return data;
  } else {
    String data = "${DateTime.now().day} ${months[DateTime.now().month - 1]}";
    print('date : $data');
    return data;
  }
}

Future<DateTime> getDateTimeWithWorkdayHosp(
    String hospId, DateTime _date) async {
  String workday;
  await getWorkingDays(hospId).then((workd) {
    print(workday);
    workday = workd;
  });

  var output = await DateTime.parse(
      '${DateFormat(commonDateFormat).format(_date)} ${workday}:00');

  return output;
}


Future<bool> isDocVerified() async {
  bool output = false;
  var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
  SaveDataSqflite dataSqflite = SaveDataSqflite();
  await dataSqflite.getUserDetails(userid).then((v) {
    print('v.data.isdocVerifed : ${v.data.isdocVerifed}');
    output = v.data.isdocVerifed;
  });
  return output;
}

Future<int> getDocStatus() async {
  int output = 0;
  var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
  SaveDataSqflite dataSqflite = SaveDataSqflite();
  await dataSqflite.getUserDetails(userid).then((v) {
    print('v.data.isdocVerifed : ${v.data.docVerification}');
    if(v!=null && v.data!=null) {
      output = v.data.docVerification;
    }
  });
  return output;
}

