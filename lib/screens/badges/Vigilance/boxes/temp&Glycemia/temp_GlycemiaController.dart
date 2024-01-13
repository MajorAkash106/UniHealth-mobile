import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/glycamia_sheetModel.dart';
import 'package:medical_app/model/vigilance/temp_glycemia_HistoryModel.dart';
import 'package:medical_app/model/vigilance/temp_sheetModel.dart';
import 'package:collection/collection.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/Temp_gly_historyDash.dart';

// import 'package:quiver/iterables.dart' as quiver;
import 'dart:math';

import '../../../../../config/cons/Sessionkey.dart';
import '../../../../../config/sharedpref.dart';

class Temp_GlycemiaController extends GetxController {
  final VigilanceController vigilanceController = VigilanceController();
  final HistoryController _historyController = HistoryController();

  //***********################### add edit in temprature sheet ************************

  Future<String> onsaveTemp({PatientDetailsData data, String tempValue,String date,String time}) async {
    List<TempratureData> temp_Sheet = [];

    await getTempData(data).then((val) {
      if (val != null) {
        temp_Sheet.addAll(val.result[0].tempratureSheetData.tempratureData);
      }
    });

    temp_Sheet.add(TempratureData(
      date: date,
      // date: DateFormat(commonDateFormat).format(DateTime.now()),
      //DateFormat(commonDateFormat).format(DateTime.parse("2021-10-04")),
      // time: DateFormat('HH:mm').format(DateTime.now()),
      time: time,
      value: double.parse(tempValue.replaceAll(',', '.'))
          .toString(), //tempValue,//.replaceAll(",", ".")
    ));
    Map finalData = {
      "tempratureSheetData": {
        "lastUpdate": '${DateTime.now()}',
        "tempratureData": temp_Sheet,
      }
    };
    print('final.....${jsonEncode(finalData)}');

    await vigilanceController.saveData(data, finalData,
        VigiLanceBoxes.temp_status, VigiLanceBoxes.TempGlycemiaSheet);
    Map temp_sheet_HistoryData = {
      "lastUpdate": '${DateTime.now()}',
      "data": [
        {
          "date": DateFormat(commonDateFormat).format(DateTime.now()),
          "time": DateFormat('HH:mm').format(DateTime.now()),
          "value": double.parse(tempValue.replaceAll(',', '.')).toString(),
          // tempValue,//.replaceAll(",", "."),
          "flag": "Added"
        }
      ]
    };
    await saveHistory(data.sId, temp_sheet_HistoryData,
        ConstConfig.tempratureHistory, data.hospital.first.sId);

    return 'success';
  }

  Future<String> onEditTemp(
      {PatientDetailsData data,
      TempratureData previousData,
      String tempVaue,
      bool delete,String date,String time}) async {
    List<TempratureData> temp_Sheet = [];
    int index = 0;

    await getTempData(data).then((val) {
      if (val != null) {
        index = val.result[0].tempratureSheetData.tempratureData
            .indexOf(previousData);
        val.result[0].tempratureSheetData.tempratureData.remove(previousData);
        temp_Sheet.addAll(val.result[0].tempratureSheetData.tempratureData);
      }
    });
    if (!delete) {
      await temp_Sheet.insert(
          index,
          TempratureData(
            // date: previousData.date,
            // time: previousData.time,
            date: date,time: time,
            // value:tempVaue,
            value: double.parse(tempVaue.replaceAll(',', '.')).toString(),
          ));

      Map finalData = {
        "tempratureSheetData": {
          "lastUpdate": '${DateTime.now()}',
          "tempratureData": temp_Sheet,
        }
      };
      print('final.....${jsonEncode(finalData)}');

      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.temp_status, VigiLanceBoxes.TempGlycemiaSheet);
      Map temp_sheet_HistoryData = {
        "lastUpdate": '${DateTime.now()}',
        "data": [
          {
            "date": previousData.date,
            "time": previousData.time,
            // "value":tempVaue,
            "value": double.parse(tempVaue.replaceAll(',', '.')).toString(),
            "flag": "Edited"
          }
        ]
      };
      await saveHistory(data.sId, temp_sheet_HistoryData,
          ConstConfig.tempratureHistory, data.hospital.first.sId);
    } else {
      Map finalData = {
        "tempratureSheetData": {
          "lastUpdate": '${DateTime.now()}',
          "tempratureData": temp_Sheet,
        }
      };
      print('final.....${jsonEncode(finalData)}');

      await vigilanceController.saveData(data, finalData,
          VigiLanceBoxes.temp_status, VigiLanceBoxes.TempGlycemiaSheet);
      Map temp_sheet_HistoryData = {
        "lastUpdate": '${DateTime.now()}',
        "data": [
          {
            "date": previousData.date,
            "time": previousData.time,
            // "value":tempVaue,
            "value": double.parse(tempVaue.replaceAll(',', '.')).toString(),
            "flag": "Deleted"
          }
        ]
      };
      await saveHistory(data.sId, temp_sheet_HistoryData,
          ConstConfig.tempratureHistory, data.hospital.first.sId);
    }
    return 'success';
  }

//***********################### add edit in glycemia sheet ************************

  Future<String> onsaveGlycemia(
      {PatientDetailsData data, String tempValue,String date,String time}) async {
    List<GlycemiaData> glycemia_sheet = [];

    await get_glycemiaData(data).then((val) {
      if (val != null) {
        glycemia_sheet.addAll(val.result[0].glycemiaSheetData.glycemiaData);
      }
    });

    glycemia_sheet.add(GlycemiaData(
        // date: DateFormat(commonDateFormat).format(DateTime.now()),
        date: date,
        // time: DateFormat('HH:mm').format(DateTime.now()),
        time: time,
        // value: double.parse(tempValue).toString(),//tempValue,//.replaceAll(",", ".")
        // value:double.parse(tempValue.replaceAll(',', '.')).toString(),
        value: tempValue));
    Map finalData = {
      "glycemiaSheetData": {
        "lastUpdate": '${DateTime.now()}',
        "glycemiaData": glycemia_sheet,
      }
    };
    print('final.....${jsonEncode(finalData)}');

    await vigilanceController.saveData(data, finalData,
        VigiLanceBoxes.glycemiaSheet_status, VigiLanceBoxes.TempGlycemiaSheet);
    Map temp_sheet_HistoryData = {
      "lastUpdate": '${DateTime.now()}',
      "data": [
        {
          "date": DateFormat(commonDateFormat).format(DateTime.now()),
          "time": DateFormat('HH:mm').format(DateTime.now()),
          // "value":double.parse(tempValue).toString(),//tempValue,//.replaceAll(",", "."),
          // "value":double.parse(tempValue.replaceAll(',', '.')).toString(),
          "value": tempValue,
          "flag": "Added"
        }
      ]
    };
    await saveHistory(data.sId, temp_sheet_HistoryData,
        ConstConfig.glycemiaHistory, data.hospital.first.sId);

    return 'success';
  }

  Future<String> onEdit_glycemia(
      {PatientDetailsData data,
      GlycemiaData previousData,
      String tempVaue,
      bool delete,String date,String time}) async {
    List<GlycemiaData> glycemia_sheet = [];
    int index = 0;

    await get_glycemiaData(data).then((val) {
      if (val != null) {
        index =
            val.result[0].glycemiaSheetData.glycemiaData.indexOf(previousData);
        val.result[0].glycemiaSheetData.glycemiaData.remove(previousData);
        glycemia_sheet.addAll(val.result[0].glycemiaSheetData.glycemiaData);
      }
    });
    if (!delete) {
      await glycemia_sheet.insert(
          index,
          GlycemiaData(
              // date: previousData.date, time: previousData.time,
            date: date,time: time,
              value: tempVaue
              // value:double.parse(tempVaue.replaceAll(',', '.')).toString(),
              ));

      Map finalData = {
        "glycemiaSheetData": {
          "lastUpdate": '${DateTime.now()}',
          "glycemiaData": glycemia_sheet,
        }
      };
      print('final.....${jsonEncode(finalData)}');

      await vigilanceController.saveData(
          data,
          finalData,
          VigiLanceBoxes.glycemiaSheet_status,
          VigiLanceBoxes.TempGlycemiaSheet);
      Map temp_sheet_HistoryData = {
        "lastUpdate": '${DateTime.now()}',
        "data": [
          {
            "date": previousData.date,
            "time": previousData.time,
            // "value":tempVaue,
            // "value":double.parse(tempVaue.replaceAll(',', '.')).toString(),
            "value": tempVaue,
            "flag": "Edited"
          }
        ]
      };
      await saveHistory(data.sId, temp_sheet_HistoryData,
          ConstConfig.glycemiaHistory, data.hospital.first.sId);
    } else {
      Map finalData = {
        "glycemiaSheetData": {
          "lastUpdate": '${DateTime.now()}',
          "glycemiaData": glycemia_sheet,
        }
      };
      print('final.....${jsonEncode(finalData)}');

      await vigilanceController.saveData(
          data,
          finalData,
          VigiLanceBoxes.glycemiaSheet_status,
          VigiLanceBoxes.TempGlycemiaSheet);
      Map temp_sheet_HistoryData = {
        "lastUpdate": '${DateTime.now()}',
        "data": [
          {
            "date": previousData.date,
            "time": previousData.time,
            "value": tempVaue,
            // "value":double.parse(tempVaue.replaceAll(',', '.')).toString(),
            "flag": "Deleted"
          }
        ]
      };
      await saveHistory(data.sId, temp_sheet_HistoryData,
          ConstConfig.glycemiaHistory, data.hospital.first.sId);
    }

    return 'success';
  }

  Future<String> saveHistory(
      String patientId, Map data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();

    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      await _historyController.saveMultipleMsgHistory(patientId, type, [data]);
      print('internet avialable');
    }
  }

  var temp_historyData = List<Temp_Gly_HistoryData>().obs;

  void get_Temp_HistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.tempratureHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        TempGlyHistory model = TempGlyHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          // historyData.clear();
          print(model.data);
          temp_historyData.addAll(model.data.reversed);

          temp_historyData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }

  var gly_historyData = List<Temp_Gly_HistoryData>().obs;

  void get_Gly_HistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);
    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.glycemiaHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        TempGlyHistory model = TempGlyHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          // historyData.clear();
          print(model.data);
          gly_historyData.addAll(model.data.reversed);

          gly_historyData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(model.message);
        }
      });
    } catch (e) {
      print(e);
      ServerError();
    }
  }

//***********################### currunt and last workig data data calculation which are shown in temp & glycemia box ************************

  Future<Temp_glyShowData_onBox> current_last_workingDay_data(
      PatientDetailsData data) async {
    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    print("cccc.....${lastWorkStart}");
    print("llll......${lastWorkEndCurrentStart.toString()}");

    print('lllllllllllllllll');
    List temp_lastDayWork = [];
    List glycemia_lastDayWork = [];
    List glycemia_curruntDayWork = [];
    List temprature_curruntDayWork = [];
    String lastUpdate;

    var dateTimee;
    await getTempData(data).then((value) => {
          if (value != null)
            {
              print("tempdata:........${jsonEncode(value)}"),
              lastUpdate = DateFormat(commonDateFormat).format(DateTime.parse(
                  value.result[0].tempratureSheetData.lastUpdate)),
              for (int i = 0;
                  i < value.result[0].tempratureSheetData.tempratureData.length;
                  i++)
                {
                  print('ppp'),
                  dateTimee =
                      '${value.result[0].tempratureSheetData.tempratureData[i].date} ${value.result[0].tempratureSheetData.tempratureData[i].time}:00',
                  print(".........****${DateTime.parse(dateTimee)}"),
                  print(DateFormat(commonDateFormat)
                      .format(DateTime.now().subtract(Duration(days: 1)))),
                  if (DateTime.parse(dateTimee)
                          .isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)
                  // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

                  )
                    {
                      temp_lastDayWork.add(double.parse(value.result[0]
                          .tempratureSheetData.tempratureData[i].value))
                    }
                  else if (DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)
                  // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
                  )
                    {
                      temprature_curruntDayWork.add(double.parse(value.result[0]
                          .tempratureSheetData.tempratureData[i].value))
                    }
                  else
                    {}
                },
            }
        });

    await get_glycemiaData(data).then((value) => {
          if (value != null)
            {
              print("gly data:........${jsonEncode(value)}"),
              for (int i = 0;
                  i < value.result[0].glycemiaSheetData.glycemiaData.length;
                  i++)
                {
                  print('ppp'),
                  dateTimee =
                      '${value.result[0].glycemiaSheetData.glycemiaData[i].date} ${value.result[0].glycemiaSheetData.glycemiaData[i].time}:00',
                  // print(DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))),
// print(value.result[0].tempratureSheetData.tempratureData[i].date),
                  if (DateTime.parse(dateTimee)
                          .isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)
                  // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].glycemiaSheetData.glycemiaData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

                  )
                    {
                      glycemia_lastDayWork.add(double.parse(value
                          .result[0].glycemiaSheetData.glycemiaData[i].value))
                    }
                  else if (DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)
                  // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].glycemiaSheetData.glycemiaData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
                  )
                    {
                      glycemia_curruntDayWork.add(double.parse(value
                          .result[0].glycemiaSheetData.glycemiaData[i].value))
                    }
                  else
                    {}
                },
              // print('last work day data of glycamia>>>>>> ${glycemia_lastDayWork.toString()}'),
              lastUpdate =
                  value.result[0].glycemiaSheetData.lastUpdate.isNullOrBlank
                      ? lastUpdate
                      : DateFormat(commonDateFormat).format(DateTime.parse(
                          value.result[0].glycemiaSheetData.lastUpdate)),
            }
        });

    print('last work day data of temp>>>>>> ${temp_lastDayWork.toString()}');
    print(
        'current work day data of temp>>>>>1 ${temprature_curruntDayWork.toString()}');

    var min_tempCurrent;
    var max_tempCurrent;
    if (temprature_curruntDayWork.isNotEmpty) {
      min_tempCurrent = temprature_curruntDayWork[0];
      max_tempCurrent = temprature_curruntDayWork[0];
      temprature_curruntDayWork.forEach((e) => {
            if (e > max_tempCurrent) {max_tempCurrent = e},
            if (e < min_tempCurrent) {min_tempCurrent = e},
          });
    } else {
      min_tempCurrent = '0';
      max_tempCurrent = '0';
    }

    var min_templast;
    var max_templast;
    if (temp_lastDayWork.isNotEmpty) {
      min_templast = temp_lastDayWork[0];
      max_templast = temp_lastDayWork[0];
      temp_lastDayWork.forEach((e) => {
            if (e > max_templast) {max_templast = e},
            if (e < min_templast) {min_templast = e},
          });
    } else {
      min_templast = '0';
      max_templast = '0';
    }

    var min_glycurruent;
    var max_glycurruent;
    if (glycemia_curruntDayWork.isNotEmpty) {
      min_glycurruent = glycemia_curruntDayWork[0];
      max_glycurruent = glycemia_curruntDayWork[0];

      glycemia_curruntDayWork.forEach((e) => {
            if (e > max_glycurruent) {max_glycurruent = e},
            if (e < min_glycurruent) {min_glycurruent = e},
          });
    } else {
      min_glycurruent = '0';
      max_glycurruent = '0';
    }

    var min_glyLast;
    var max_glyLast;

    if (glycemia_lastDayWork.isNotEmpty) {
      min_glyLast = glycemia_lastDayWork[0];
      max_glyLast = glycemia_lastDayWork[0];

      glycemia_lastDayWork.forEach((e) => {
            if (e > max_glyLast) {max_glyLast = e},
            if (e < min_glyLast) {min_glyLast = e},
          });
    } else {
      min_glyLast = '0';
      max_glyLast = '0';
    }

    Map d = {
      "temp_min_last": //'0',
          min_templast.toString() ?? '0',
      "temp_max_last": //'0',
          max_templast.toString() ?? '0',
      "temp_min_current": //'0',

          min_tempCurrent.toString() ?? '0',
      "temp_max_current": //'0',
          max_tempCurrent.toString() ?? '0',
      "gly_min_current": //'0',
          min_glycurruent.toString() ?? '0',
      "gly_max_current": //'0',
          max_glycurruent.toString() ?? '0',
      "gly_min_last": //'0',
          min_glyLast.toString() ?? '0',
      "gly_max_last": //'0',
          max_glyLast.toString() ?? '0',
      "lastUpdate": lastUpdate
    };

    print(
        "Caculated Data for current_last_workingDay_data.......... ${d.toString()} ");

    return Temp_glyShowData_onBox(
        temp_min_last: //'0',
            min_templast.toString() ?? '0',
        temp_max_last: //'0',
            max_templast.toString() ?? '0',
        temp_min_current: //'0',

            min_tempCurrent.toString() ?? '0',
        temp_max_current: //'0',
            max_tempCurrent.toString() ?? '0',
        gly_min_current: //'0',
            min_glycurruent.toString() ?? '0',
        gly_max_current: //'0',
            max_glycurruent.toString() ?? '0',
        gly_min_last: //'0',
            min_glyLast.toString() ?? '0',
        gly_max_last: //'0',
            max_glyLast.toString() ?? '0',
        lastUpdate: lastUpdate);
  }
}

class Temp_glyShowData_onBox {
  String temp_min_current;
  String temp_max_current;
  String temp_min_last;
  String temp_max_last;

  String gly_min_current;
  String gly_max_current;
  String gly_min_last;
  String gly_max_last;

  String lastUpdate;

  Temp_glyShowData_onBox(
      {this.gly_min_current,
      this.gly_max_current,
      this.gly_max_last,
      this.gly_min_last,
      this.lastUpdate,
      this.temp_min_last,
      this.temp_max_last,
      this.temp_min_current,
      this.temp_max_current});
}
