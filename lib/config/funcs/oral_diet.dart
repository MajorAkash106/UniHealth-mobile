import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

Future<List<FastingOralData>> addItemFASTING(
    PatientDetailsData patientDetailsData, Map oralData, int fasting) async {
  FastingOralData result = FastingOralData();
  List<FastingOralData> output = [];
  List<FastingOralData> getprevious = [];
  if (fasting == 0) {
    result.teamAgree = oralData['team_agree'];
    result.fasting = oralData['fasting'];
    result.fastingReason = oralData['fasting_reason'];
    result.condition = oralData['condition'];
    result.kcal = oralData['kcal'];
    result.ptn = oralData['ptn'];
    result.lastUpdate = oralData['lastUpdate'];
  } else {
    result.fasting = oralData['fasting'];
    result.fastingReason = oralData['fasting_reason'];
    result.description = oralData['description'] ?? "";
    result.lastUpdate = oralData['lastUpdate'];
  }
  output.add(result);

  getprevious = await getPreviuos(patientDetailsData);

  if (getprevious.isNotEmpty) {
    await output.addAll(getprevious);
  }

  List<FastingOralData> returnList = [];
 returnList = await getFilterData(output, patientDetailsData);

  return returnList;
}

Future<List<FastingOralData>> getPreviuos(PatientDetailsData data) async {
  List<FastingOralData> output = [];
  Ntdata ntdata = await getFAsting(data);

  if (ntdata != null &&
      (ntdata?.result?.first?.fastingOralData != null ||
          ntdata?.result?.first?.fastingOralData?.length != 0)) {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    // DateTime currentworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now());
    // DateTime currentworkdayend = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    for (var a in ntdata?.result?.first?.fastingOralData) {
      DateTime _date = DateTime.parse(a.lastUpdate);
      print('date is before ${_date.isBefore(lastworkday)}');
      if (_date.isAfter(lastworkday)) {
        output.add(a);
      }
    }
  }
  return output;
}







Future<List<FastingOralData>> getFilterData(
    List<FastingOralData> fastingData, PatientDetailsData data) async {
  DateTime lastworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
  DateTime currentworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now());
  // DateTime currentworkdayend = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));
  List<FastingOralData> last = [];
  List<FastingOralData> current = [];
  List<FastingOralData> previouys_last = [];

  for (var a in fastingData) {
    DateTime _date = DateTime.parse(a.lastUpdate);
    print('date is before ${_date.isBefore(lastworkday)}');
    if(_date.isAfter(lastworkday.subtract(Duration(days: 1))) && _date.isBefore(lastworkday)){
      previouys_last.add(a);
    }
    else if (_date.isAfter(lastworkday) && _date.isBefore(currentworkday)) {
      last.add(a);
    } else if (_date.isAfter(currentworkday)) {
      current.add(a);
    } else {}
  }

  List<FastingOralData> output = [];

  if (last.isNotEmpty) {
    FastingOralData data = await updatedDateSelect(last);
    output.add(data);
  }
  if (current.isNotEmpty) {
    FastingOralData data = await updatedDateSelect(current);
    output.add(data);
  }
  if(previouys_last.isNotEmpty){
   for(var a in previouys_last){
     output.add(a);
   }
  }

  return output;
}

Future<FastingOralData> updatedDateSelect(List<FastingOralData> list) async {
  list.sort((b, a) =>
      DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
  return list[0];
}




Future<List<FastingOralData>> addItem_inLast3DaysData(
    PatientDetailsData patientDetailsData, Map oralData, int fasting) async {
  FastingOralData result = FastingOralData();
  List<FastingOralData> output = [];
  List<FastingOralData> getprevious = [];
  if (fasting == 0) {
    result.teamAgree = oralData['team_agree'];
    result.fasting = oralData['fasting'];
    result.fastingReason = oralData['fasting_reason'];
    result.condition = oralData['condition'];
    result.kcal = oralData['kcal'];
    result.ptn = oralData['ptn'];
    result.lastUpdate = oralData['lastUpdate'];
  } else {
    result.fasting = oralData['fasting'];
    result.fastingReason = oralData['fasting_reason'];
    result.description = oralData['description'] ?? "";
    result.lastUpdate = oralData['lastUpdate'];
  }
  output.add(result);

  getprevious = await getPreviuos3Daysdata(patientDetailsData);

  if (getprevious.isNotEmpty) {
    await output.addAll(getprevious);
  }

  List<FastingOralData> returnList = [];
  returnList = await getFilterData(output, patientDetailsData);

  return returnList;
}

Future<List<FastingOralData>> getPreviuos3Daysdata(PatientDetailsData data) async {
  List<FastingOralData> output = [];
  Ntdata ntdata = await getFAsting(data);

  if (ntdata != null &&
      (ntdata?.result?.first?.fastingOralData != null ||
          ntdata?.result?.first?.fastingOralData?.length != 0)) {
    DateTime lastworkday = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));
    // DateTime currentworkday = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now());
    // DateTime currentworkdayend = await getDateTimeWithWorkdayHosp(data.hospital.first.sId, DateTime.now().add(Duration(days: 1)));

    for (var a in ntdata?.result?.first?.fastingOralData) {
      DateTime _date = DateTime.parse(a.lastUpdate);
      print('date is before ${_date.isBefore(lastworkday)}');
      if (_date.isAfter(lastworkday.subtract(Duration(days: 1)))) {
         output.add(a);
      }
    }
  }
  return output;
}


Future<List<FastingOralData>> last3DataData(
    List<FastingOralData> data, String hospId, String type) async {
  DateTime lastworkday = await getDateTimeWithWorkdayHosp(
      hospId, DateTime.now().subtract(Duration(days: 1)));
  DateTime currentworkdayStart =
  await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
  DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(
      hospId, DateTime.now().add(Duration(days: 1)));
  List<FastingOralData> output = [];
  print('www');
  if (data != null && data.isNotEmpty) {
    List<FastingOralData> currentDay = [];
    List<FastingOralData> lastDay = [];
    List<FastingOralData> previousDay = [];
    for (var b in data) {
      DateTime _date = DateTime.parse(b.lastUpdate);
      if ((_date.isAfter(currentworkdayStart) &&
          _date.isBefore(currentworkdayEnd) )) {
        currentDay.add(b);
      } else if ((_date.isAfter(lastworkday) &&
          _date.isBefore(currentworkdayStart) )) {
        lastDay.add(b);
      }
      else {
        previousDay.add(b);
      }
    }

    print('current : ${currentDay.length}');

    if (currentDay != null && currentDay.isNotEmpty) {
      FastingOralData current = await updatedDateSelected(currentDay);
      output.add(current);
    }
    if (lastDay != null && lastDay.isNotEmpty) {
      FastingOralData last = await updatedDateSelected(lastDay);
      output.add(last);
    }

    output.addAll(previousDay);

    for(int a =0; a<data.length;a++){
      DateTime _date = DateTime.parse(data[a].lastUpdate);
      output.removeWhere((element) => DateTime.parse(element.lastUpdate).isBefore(lastworkday.subtract(Duration(days: 1))));
      // if(_date.isBefore(lastworkday.subtract(Duration(days: 1))) && a.type== type){
      //   output.remove(a);
      // }
    }

  }

  return output;
}


Future<FastingOralData> updatedDateSelected(List<FastingOralData> list) async {
  // print('get all objects needs : ${list.length}');
  // print('get all objects needs 1 : ${jsonEncode(list[0])}');
  // print('get all objects needs 2 : ${jsonEncode(list[1])}');
  list.sort((b, a) =>
      DateTime.parse(a.lastUpdate).compareTo(DateTime.parse(b.lastUpdate)));
  return list[0];
}