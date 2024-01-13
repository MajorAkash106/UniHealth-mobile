import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/lessAchieveNeeds.dart';
import 'package:medical_app/contollers/NutritionalTherapy/need_achievement_controller.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/mean_iap_controller.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_history.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/numberOfDoses.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart' as w;
import 'package:medical_app/model/vigilance/abdomen_model.dart' as ab;

import '../../config/cons/Sessionkey.dart';
import '../../config/sharedpref.dart';

class AbdomenController extends GetxController {
  final VigilanceController vigilanceController = VigilanceController();

  final HistoryController _historyController = HistoryController();
  final EnteralNutritionalController eternal_controller =
      EnteralNutritionalController();
  Mean_Iap_Controller mean_iap_controller = Mean_Iap_Controller();
  final NeedsController needsController = NeedsController();
  LessAchieveNeeds lessAchieveNeeds_cntrlr = LessAchieveNeeds();

  Future<String> onSaved(
      PatientDetailsData patientDetailsData,
      Map mapData,
      List<AKPSData> selectedData,
      String result /*,List<MeanIapData> meandata*/) async {
    List<w.AbdomenData> abdomen =
        await gettingUpdated(patientDetailsData, mapData);

    Map finalData = {
      "lastUpdate": '${DateTime.now()}',
      "result": result,
      // "mean_iap_data":meandata,
      "abdomen_data": mapData ?? '',
      "abdomen_data_details": abdomen,
      "adverse_eventData": selectedData,
    };

    print('final Data: ${jsonEncode(finalData)}');

    await saveHistory(patientDetailsData.sId, finalData,
        ConstConfig.abdomenHistory, patientDetailsData.hospital.first.sId);

    await vigilanceController
        .saveData(patientDetailsData, finalData, VigiLanceBoxes.abdomen_status,
            VigiLanceBoxes.abdomen)
        .then((value) {
      Get.to(Step1HospitalizationScreen(
        index: 3,
        patientUserId: patientDetailsData.sId,
      ));
    });

    return 'success';
  }

  Future<List<w.AbdomenData>> gettingUpdated(
      PatientDetailsData pData, Map mapData) async {
    List<w.AbdomenData> abdomen = await getAllAbdomen(pData, mapData);

    DateTime start = await getDateTimeWithWorkdayHosp(
        pData.hospital.first.sId, DateTime.now());
    DateTime lastDate = start.subtract(Duration(days: 7));

    List<w.AbdomenData> output = [];

    for (var a in abdomen) {
      DateTime dateTime = DateTime.parse(a.lastUpdate);

      if (dateTime.isAfter(lastDate)) {
        output.add(a);
      }
    }
    return output;
  }

  Future<List<w.AbdomenData>> getAllAbdomen(
      PatientDetailsData pData, Map mapData) async {
    w.AbdomenData latestData = await gettingReadyObj(mapData);
    List<w.AbdomenData> output = [];

    Vigilance data = await getAbdomenData(pData);
    if (data != null && data.result.first.abdomenDetails != null) {
      List<w.AbdomenData> abdomen = data.result.first.abdomenDetails;

      DateTime start = await getDateTimeWithWorkdayHosp(
          pData.hospital.first.sId, DateTime.now());
      DateTime end = start.add(Duration(days: 1));

      w.AbdomenData previousObj;

      for (var a in abdomen) {
        DateTime dateTime = DateTime.parse(a.lastUpdate);

        if (dateTime.isAfter(start) && dateTime.isBefore(end)) {
          previousObj = a;
          break;
        }
      }

      if (previousObj != null) {
        abdomen.remove(previousObj);
        abdomen.add(latestData);
      } else {
        abdomen.add(latestData);
      }

      output = abdomen;
    } else {
      output.add(latestData);
    }

    return output;
  }

  Future<w.AbdomenData> gettingReadyObj(Map data) async {
    //      "bowel_movement": BowlMovement,
    //         "bowel_sound": sound,
    //         "vomit": vomit,
    //         "abdominal_dist": abdominal_distention,
    //         "ng_tube": ngTube.text,
    //         "mean_lap": lastMean_iap.text,
    //         "lastUpdate": '${DateTime.now()}',
    return w.AbdomenData(
        bowelMovement: data['bowel_movement'],
        indexBowelMovement: data['bowel_movement_index'],
        bowelSound: data['bowel_sound'],
        vomit: data['vomit'],
        abdominalDist: data['abdominal_dist'],
        indexAbdominalDist: data['abdominal_dist_index'],
        ngTube: data['ng_tube'],
        meanLap: data['mean_lap'],
        lastUpdate: data['lastUpdate']);
  }

//   Future<String> enter_mean(PatientDetailsData patientDetailsData, ab.AbdomenData mapData,
//       List<w.AdverseEventData> selectedData, String result,List<MeanIapData> meandata ) async {
//
//     Map finalData = {
//       "lastUpdate": '${DateTime.now()}',
//       "result": result,
//       "mean_iap_data":meandata,
//       "abdomen_data": mapData ?? '',
//       "adverse_eventData": selectedData
//     };
//
//     print('final Data: ${jsonEncode(finalData)}');
//
//     //await saveHistory(patientDetailsData.sId, finalData, ConstConfig.abdomenHistory);
//     await vigilanceController
//         .saveData(patientDetailsData, finalData, VigiLanceBoxes.abdomen_status,
//         VigiLanceBoxes.abdomen)
//         .then((value) {
// print('added mean');
//
//       // Get.to(Step1HospitalizationScreen(
//       //   index: 3,
//       //   patientUserId: patientDetailsData.sId,
//       // ));
//     });
//
//     return 'success';
//   }

  Future<String> saveHistory(
      String patientId, Map data, type, String hospId) async {
    final PatientSlipController controller = PatientSlipController();

    bool mode = await controller.getRoute(hospId);
    if (mode != null && mode) {
      await _historyController.saveMultipleMsgHistory(patientId, type, [data]);
    }
  }

  var historyData = List<AbdomenHistoryData>().obs;

  void getHistoryData(String patientId) async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getHistory);
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        "type": ConstConfig.abdomenHistory,
        'loggedUserId': userid,
      });
      print(request.body);
      await request.post().then((value) {
        AbdomenHistory model = AbdomenHistory.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          historyData.clear();
          print(model.data);
          historyData.addAll(model.data.reversed);

          historyData.sort((a, b) {
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

  Future<Vigilance> getAbdomenData(PatientDetailsData data) async {
    Vigilance vigilance;

    if (data.vigilance.isNotEmpty) {
      vigilance = await data.vigilance.firstWhere(
          (element) =>
              element.type == VigiLanceBoxes.abdomen &&
              element.status == VigiLanceBoxes.abdomen_status,
          orElse: () => null);
    }

    return vigilance;
  }

  Future<List<double>> getNGTube(PatientDetailsData data) async {
    double lastwork = 0.0;
    double currentwork = 0.0;
    Vigilance vigilance = await getFluidBalanace(data);
    String workingday = await getWorkingDays(data.hospital[0].sId);

    if (vigilance != null && vigilance.result.first.data != null) {
      print('getting vigilance len : ${vigilance.result.first.data.length}');

      for (var a in vigilance.result.first.data) {
        print('obj : ${a.date} ${a.time}:00');
        var dateTimee = await '${a.date} ${a.time}:00';

        var today =
            '${DateFormat(commonDateFormat).format(DateTime.now())} ${workingday}:00';
        var last =
            '${DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1)))} ${workingday}:00';
        print('today --- ${today}');

        print(
            's d a d----------${DateTime.parse(dateTimee).isAfter(DateTime.parse(last))}');

        bool get =
            await DateTime.parse(dateTimee).isAfter(DateTime.parse(last)) &&
                DateTime.parse(dateTimee).isBefore(DateTime.parse(today));
        bool curruntday =
            await DateTime.parse(dateTimee).isAfter(DateTime.parse(today));

        if (curruntday == true) {
          if (a.intOut == '1' && (a.item == 'Nasogastric Tube' || a.item == 'Sonda Nasogástrica')) {
            currentwork = currentwork + double.parse(a.ml);
          }
        } else if (get == true) {
          if (a.intOut == '1' && (a.item == 'Nasogastric Tube' || a.item == 'Sonda Nasogástrica')) {
            lastwork = lastwork + double.parse(a.ml);
          }
        }
      }

      print('last workday  : ${lastwork}');
      print('current workday  : ${currentwork}');
    }

    return [lastwork, currentwork];
  }

  Future<Sum_NG_out_ENin_values> get_Sum_NG_out_EN_in(
      PatientDetailsData data) async {
    // this func. returning sum of ng tube toggled out and EN toggled in of current day and last day
    List last_toggle_out_NGtube = [];
    List current_toggle_out_NGtube = [];
    List last_toggle_in_EnteralNutrion = [];
    List current_toggle_in_EnteralNutrion = [];

    String sumEN_current;
    String sumEN_last;
    String sumNG_current;
    String sumNG_last;

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
          dateTimee =
              '${value.result[0].data[i].date} ${value.result[0].data[i].time}:00';
          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  (value.result[0].data[i].item == "Nasogastric Tube" &&
                      value.result[0].data[i].intOut == '1')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            last_toggle_out_NGtube.add(double.parse(value.result[0].data[i].ml));
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  (value.result[0].data[i].item == "Nasogastric Tube" &&
                      value.result[0].data[i].intOut == '1')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            current_toggle_out_NGtube
                .add(double.parse(value.result[0].data[i].ml));
          } else {}

          // getting here EN data for last or current IN

          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  (value.result[0].data[i].item == "Enteral Nutrition" &&
                      value.result[0].data[i].intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            last_toggle_in_EnteralNutrion
                .add(double.parse(value.result[0].data[i].ml).toInt());
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  (value.result[0].data[i].item == "Enteral Nutrition" &&
                      value.result[0].data[i].intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            current_toggle_in_EnteralNutrion
                .add(double.parse(value.result[0].data[i].ml).toInt());
          } else {}

          // getting here NG data for last or current IN and adding same list of EN data in

          if ((DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                      DateTime.parse(dateTimee).isAfter(lastWorkStart)) &&
                  (value.result[0].data[i].item == "Nasogastric Tube" &&
                      value.result[0].data[i].intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            last_toggle_in_EnteralNutrion
                .add(double.parse(value.result[0].data[i].ml).toInt());
          } else if ((DateTime.parse(dateTimee)
                      .isAfter(lastWorkEndCurrentStart)) &&
                  (value.result[0].data[i].item == "Nasogastric Tube" &&
                      value.result[0].data[i].intOut == '0')
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            current_toggle_in_EnteralNutrion
                .add(double.parse(value.result[0].data[i].ml).toInt());
          } else {}
        }
        print("currnt ngt.... ${current_toggle_out_NGtube}");
        print("last ngt.... ${last_toggle_out_NGtube}");
        print("last En.... ${last_toggle_in_EnteralNutrion}");
        print("Current En.... ${current_toggle_in_EnteralNutrion}");

        if (last_toggle_out_NGtube.isNotEmpty) {
          sumNG_last =
              last_toggle_out_NGtube.reduce((a, b) => a + b).toString();
          print("sumNG_last ${sumNG_last}");
        } else {
          sumNG_last = '0';
        }

        if (current_toggle_out_NGtube.isNotEmpty) {
          sumNG_current =
              current_toggle_out_NGtube.reduce((a, b) => a + b).toString();
          print("sumNG_current ${sumNG_current}");
        } else {
          sumNG_current = '0';
        }

        if (last_toggle_in_EnteralNutrion.isNotEmpty) {
          sumEN_last =
              last_toggle_in_EnteralNutrion.reduce((a, b) => a + b).toString();
          print("sumEN_last ${sumEN_last}");
        } else {
          sumEN_last = '0';
        }

        if (current_toggle_in_EnteralNutrion.isNotEmpty) {
          sumEN_current = current_toggle_in_EnteralNutrion
              .reduce((a, b) => a + b)
              .toString();
          print("sumEN_current ${sumEN_current}");
        } else {
          sumEN_current = '0';
          print("sumEN_current ${sumEN_current}");
        }
      }
    });

    print('sumNG_current ::: $sumNG_current');
    return Sum_NG_out_ENin_values(
        sumEN_current: sumEN_current,
        sumEN_last: sumEN_last,
        sumNG_current: sumNG_current,
        sumNG_last: sumNG_last);
  }

  Future<CurrentDayAbdomnData> currentDay_abdomnData(
      PatientDetailsData data) async {
    //this function retrurning abdoman data of current day

    var vomit;
    var distention;
    var bowl_movement;

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    Vigilance abdomnData = await getAbdomenData(data);
    if (abdomnData != null) {
      print("abdddd  ${abdomnData.result[0].lastUpdate}");
      //dateTimee =  '${abdomnData.result[0].lastUpdate} ${abdomnData.result[0].lastUpdate}:00';
      print(
          "mmmmmmmm ${DateTime.parse(abdomnData.result[0].lastUpdate).isAfter(lastWorkEndCurrentStart)}");

      bool iscurrunt_abdom_present =
          DateTime.parse(abdomnData.result[0].lastUpdate)
              .isAfter(lastWorkEndCurrentStart);
      if (iscurrunt_abdom_present) {
        print('abdomne for current day is present');
        vomit = abdomnData.result[0].abdomenData.vomit;
        distention = abdomnData.result[0].abdomenData.abdominalDist;
        bowl_movement = abdomnData.result[0].abdomenData.bowelMovement;
      } else {
        print('abdomne for current day is not present');
      }
    } else {}
    return CurrentDayAbdomnData(
        vomit: vomit, distention: distention, bowl_movement: bowl_movement);
  }

  Future<CurrentDayEnteralData> currentDay_EternalData(
      PatientDetailsData data) async {
    String ml_mani_currentWorkDay;

    String ml_indust_currentWorkDay;
    List<NumberOfDays> _numberOfDayList = [];

    EnteralData enData;
    int tabindex;
    String mlPerDose = '';
    String workday;
    double previuosManipuatedMl = 0.0;

    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    print("cccc.....${lastWorkStart.toString()}");
    print("llll......${lastWorkEndCurrentStart.toString()}");

    await getWorkingDays(data.hospital.first.sId).then((value) {
      workday = value;
    });

    await eternal_controller.getCurrentManipulatedML(data).then((val) {
      previuosManipuatedMl = val;
    });

    var previous_indst = await eternal_controller.getCurrentIndustML(data);

    await eternal_controller.getEnternalData(data).then((res) {
      if (res != null) {
        enData = res;
        tabindex = res.tabIndex;
        if (!res.manipulatedData.isNullOrBlank) {
          mlPerDose = res.manipulatedData.mlDose;
        } else {}

        if (!res.manipulatedData.dosesData.isNullOrBlank) {
          _numberOfDayList.clear();
          print('get doses number ${res.manipulatedData.dosesData.length}');
          for (var a in res.manipulatedData.dosesData) {
            NumberOfDays numberOfDays = NumberOfDays();
            numberOfDays.index = a.index;
            numberOfDays.hour = a.hour;
            numberOfDays.istoday = a.istoday;
            numberOfDays.timePerday = a.timePerday;
            numberOfDays.schdule_date = a.istoday
                ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
                : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

            _numberOfDayList.add(numberOfDays);
          }
        } else {}
      }
    });
    if (tabindex == 1) {
      await eternal_controller
          .getManiplatedCurrentWork(
              _numberOfDayList, mlPerDose, workday, previuosManipuatedMl)
          .then((value) {
        print(jsonEncode(_numberOfDayList));
        print(jsonEncode(mlPerDose));
        print(jsonEncode(workday));
        print(jsonEncode(previuosManipuatedMl));
        print('ppppp');
        if (value.isNotEmpty) {
          print(value.length);
          ml_mani_currentWorkDay = value?.first?.totalwork;
          print(ml_mani_currentWorkDay);
          print("ml_currentWorkDay");
        } else {
          print('emty list');
        }
      });
    } else if (enData != null && tabindex == 0) {
      await eternal_controller
          .getCurrentWorkday(
              TextEditingController(text: enData.industrializedData.mlHr),
              TextEditingController(text: enData.industrializedData.hrDay),
              TextEditingController(text: enData.industrializedData.startTime),
              TextEditingController(text: enData.industrializedData.startDate),
              workday)
          .then((val) {
        if (enData != null && enData.industrializedData != null) {
          double total = double.parse(val) + previous_indst;
          ml_indust_currentWorkDay = total.toStringAsFixed(2);
          print("insuttttt 2...${ml_indust_currentWorkDay}");
        }
      });
    }
    return CurrentDayEnteralData(
        ml_mani_currentWorkDay: ml_mani_currentWorkDay,
        ml_indust_currentWorkDay: ml_indust_currentWorkDay,
        tabindex: tabindex);
  }

  Future<CurrentDayFasting> currentDay_fastingData(
      PatientDetailsData data) async {
    //this funtion is returning fasting data of current day
    var fasting;
    var fasting_reason;
    var fasting_condition;
    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    Ntdata fasting_oralDiet_Data = await getFAsting(data);
    if (fasting_oralDiet_Data != null) {
      print("fasting  ${fasting_oralDiet_Data.result[0].lastUpdate}");
      print(
          "nnnn ${DateTime.parse(fasting_oralDiet_Data.result[0].lastUpdate).isAfter(lastWorkEndCurrentStart)}");
      bool iscurrunt_fasting_present =
          DateTime.parse(fasting_oralDiet_Data.result[0].lastUpdate)
              .isAfter(lastWorkEndCurrentStart);
      if (iscurrunt_fasting_present) {
        fasting = fasting_oralDiet_Data.result[0].fasting;
        fasting_reason = fasting_oralDiet_Data.result[0].fasting_reason;
        fasting_condition = fasting_oralDiet_Data.result[0].condition;
      } else {}
    } else {}

    return CurrentDayFasting(
        fasting: fasting,
        fasting_reason: fasting_reason,
        fasting_condition: fasting_condition);
  }

  Future<int> gif_score_calculation(PatientDetailsData data) async {
    int point = 0;
    Sum_NG_out_ENin_values Ng_En_Values = await get_Sum_NG_out_EN_in(data);
    CurrentDayAbdomnData abdomvalues = await currentDay_abdomnData(data);

    CurrentDayEnteralData etData = await currentDay_EternalData(data);
    CurrentDayFasting fastingvalues = await currentDay_fastingData(data);
    bool isNtDataFasting = await getNtDataFasting(data);

    bool isNtDataOralacceptance = await getNtDataOralAcceptance(data);
    bool isNtDataReduced = await getNtDataReducedJustification(data);

    var isNeedsDataLessThan50Perc =
        await lessAchieveNeeds_cntrlr.getLessDatafrom(data, 50);

    print(
        'dataa-------------------50--------${isNeedsDataLessThan50Perc.ptnLess},${isNeedsDataLessThan50Perc.ptnLess}');

    var isNeedsDataLessThan10Perc =
        await lessAchieveNeeds_cntrlr.getLessDatafrom(data, 10);
    print(
        'dataa-------------------10--------${isNeedsDataLessThan10Perc.ptnLess},${isNeedsDataLessThan10Perc.ptnLess}');

    print('yessss');
    // print(ml_mani_currentWorkDay);

    print("final");
    print("1 ${Ng_En_Values.sumEN_current}");
    print("2 ${Ng_En_Values.sumEN_last}");
    print("2.. ${Ng_En_Values.sumNG_current}");
    print("3 ${Ng_En_Values.sumNG_last}");
// print("4 ${abdomvalues.}");
    print("5.,.,. ${etData.ml_mani_currentWorkDay}");
// print("6 ${etData.ml_indust_currentWorkDay}");
    print("vomit ${abdomvalues.vomit}");
    print("vombowl_movement ${abdomvalues.bowl_movement}");
    print("distention ${abdomvalues.distention}");
    print("fasting ${fastingvalues.fasting}");
    print("oral_acceptance ${isNtDataOralacceptance}");
    print(" nt data fasting ${isNtDataFasting}");
    print("nt data reduced ${isNtDataReduced}");
    print("less tha 50 perc ${isNeedsDataLessThan50Perc}");
    print("less tha 10 perc ${isNeedsDataLessThan10Perc}");

    List<String> meadData = await mean_iap_controller.get_avg_MeanIap(data);
    print("meaaaaaa ${meadData}");

    if (((isNeedsDataLessThan50Perc.ptnLess == true ||
                isNeedsDataLessThan50Perc.kcalLess == true) &&
            isNtDataReduced == true) ||
        isNtDataFasting == true ||
        ((isNeedsDataLessThan10Perc.ptnLess == true ||
                isNeedsDataLessThan10Perc.kcalLess) &&
            isNtDataOralacceptance == true)) {
      point = 1;
    }

    var isEnternalBlank = await isEnternalNull_orBlank(etData);
    var distention = await isSpecified_distentionPresent(abdomvalues);
    var bowlMov = await isSpecified_bowlMovePresent(abdomvalues);
    bool meanHighCheck = await get_mean_IapDataHIGH(data) ?? false;

//  else
    if ((
            //(etData==null || etData.tabindex==0?etData.ml_indust_currentWorkDay.isNullOrBlank:etData.ml_mani_currentWorkDay.isNullOrBlank)
            isEnternalBlank &&
                (fastingvalues.fasting_condition == null ||
                    fastingvalues.fasting == true) &&
                (abdomvalues.vomit == 1 ||
                    //abdomvalues.distention=="Mild"||abdomvalues.distention=="Moderate"||abdomvalues.distention=="Severe"||
                    distention ||
                    // abdomvalues.bowl_movement=="Liquid - Few (≥3/day)"||
                    bowlMov ||
                    (((Ng_En_Values.sumNG_last == null
                            ? false
                            : double.parse(Ng_En_Values.sumNG_last).toInt() >
                                (Ng_En_Values.sumEN_last == null
                                    ? false
                                    : double.parse(Ng_En_Values.sumEN_last)
                                        .toInt()))
                        // &&
                        // (Ng_En_Values.sumEN_last==null?false:double.parse(Ng_En_Values.sumEN_last).toInt()>0 )
                        ) ||
                        ((Ng_En_Values.sumNG_current == null
                            ? false
                            : double.parse(Ng_En_Values.sumNG_current).toInt() >
                                (Ng_En_Values.sumEN_current == null
                                    ? false
                                    : double.parse(Ng_En_Values.sumEN_current)
                                        .toInt()))
                        // &&
                        // Ng_En_Values.sumEN_current==null?false:double.parse(Ng_En_Values.sumEN_current).toInt()>0
                        )))) ||
        (double.parse(meadData[0]) >= 12 ||
            double.parse(meadData[1]) >= 12)) {
      point = 2;
    }

    //  else
    if ((

            //(etData==null || etData.tabindex==0?etData.ml_indust_currentWorkDay.isNullOrBlank:etData.ml_mani_currentWorkDay.isNullOrBlank)
            isEnternalBlank &&
                (fastingvalues.fasting_condition == null ||
                    fastingvalues.fasting == true) &&
                (abdomvalues.vomit == 1 ||
                    //abdomvalues.distention=="Mild"||abdomvalues.distention=="Moderate"||abdomvalues.distention=="Severe"||
                    distention ||
                    // abdomvalues.bowl_movement=="Liquid - Few (≥3/day)"||
                    bowlMov ||
                    (((Ng_En_Values.sumNG_last == null
                            ? false
                            : double.parse(Ng_En_Values.sumNG_last).toInt() >
                                (Ng_En_Values.sumEN_last == null
                                    ? false
                                    : double.parse(Ng_En_Values.sumEN_last)
                                        .toInt()))
                        // &&
                        // (Ng_En_Values.sumEN_last==null?false:double.parse(Ng_En_Values.sumEN_last).toInt()>0 )
                        ) ||
                        ((Ng_En_Values.sumNG_current == null
                            ? false
                            : double.parse(Ng_En_Values.sumNG_current).toInt() >
                                (Ng_En_Values.sumEN_current == null
                                    ? false
                                    : double.parse(Ng_En_Values.sumEN_current)
                                        .toInt()))
                        // &&
                        // Ng_En_Values.sumEN_current==null?false:double.parse(Ng_En_Values.sumEN_current).toInt()>0
                        )))) &&
        (double.parse(meadData[0]) >= 12 ||
            double.parse(meadData[1]) >= 12)) {
      point = 3;
    }
//  else if((
//     // (etData.ml_mani_currentWorkDay.isNullOrBlank||etData.ml_indust_currentWorkDay.isNullOrBlank)
//     (etData.tabindex==0?etData.ml_indust_currentWorkDay.isNullOrBlank:etData.ml_mani_currentWorkDay.isNullOrBlank)  &&
//         (fastingvalues.fasting_condition==null || fastingvalues.fasting==true)&& ( abdomvalues.vomit==1||abdomvalues.distention=="Mild"||abdomvalues.distention=="Moderate"||abdomvalues.distention=="Severe"||
//         abdomvalues.bowl_movement=="Liquid - Few (≥3/day)"||abdomvalues.bowl_movement=="Liquid - Abundant (≥1/day)"||(Ng_En_Values.sumNG_last==null?false:int.parse(Ng_En_Values.sumNG_last)>
//         (Ng_En_Values.sumEN_last==null?false:int.parse(Ng_En_Values.sumEN_last)) && (Ng_En_Values.sumEN_last==null?false:int.parse(Ng_En_Values.sumEN_last)>0) )||
//         (Ng_En_Values.sumNG_current==null?false:int.parse(Ng_En_Values.sumNG_current)>(Ng_En_Values.sumEN_current==null?false:int.parse(Ng_En_Values.sumEN_current)) && Ng_En_Values.sumEN_current==null?false:int.parse(Ng_En_Values.sumEN_current)>0 )))&&(double.parse(meadData[0]).toInt().toDouble()>12||double.parse(meadData[1]).toInt().toDouble()>12)
//     ){
//       point=3;
//     }
    if ((double.parse(meadData[0]) > 20 ||
            double.parse(meadData[1]) > 20) &&
        (meanHighCheck == true)) {
      point = 4;
    }

    print("pooint${point}");
    print("meanHighCheck :: $meanHighCheck");

    return point;
  }

  Future<Gif_Data> GIF_result(PatientDetailsData data) async {
    String gif_Result;
    int gifscore = await gif_score_calculation(data);
    print("gifscore -- ${gifscore}");

    if (gifscore == 0) {
      gif_Result = "output_gif_0".tr;
    } else if (gifscore == 1) {
      gif_Result = "output_gif_1".tr;
    } else if (gifscore == 2) {
      gif_Result = "output_gif_2".tr;
    } else if (gifscore == 3) {
      gif_Result = "output_gif_3".tr;
    } else if (gifscore == 4) {
      gif_Result = "output_gif_4".tr;
    }

    print('Gif_Data return : $Gif_Data');
    return Gif_Data(gif_score: gifscore, gif_result: gif_Result);
  }

  Future<bool> isEnternalNull_orBlank(CurrentDayEnteralData etData) async {
    bool ret_obj = false;
    if (etData == null || etData.tabindex == 0
        ? etData.ml_indust_currentWorkDay.isNullOrBlank
        : etData.ml_mani_currentWorkDay.isNullOrBlank) {
      ret_obj = await true;
    } else {
      ret_obj = await false;
    }
    return ret_obj;
  }

  Future<bool> isSpecified_distentionPresent(
      CurrentDayAbdomnData abdomvalues) async {
    bool ret_obj = false;
    if (abdomvalues.distention == "Mild" ||
        abdomvalues.distention == "Moderate" ||
        abdomvalues.distention == "Severe") {
      ret_obj = await true;
    } else {
      ret_obj = await false;
    }
    return ret_obj;
  }

  Future<bool> isSpecified_bowlMovePresent(
      CurrentDayAbdomnData abdomvalues) async {
    bool ret_obj = false;
    if (abdomvalues.bowl_movement == "Liquid - Few (≥3/day)" ||
        abdomvalues.bowl_movement == "Liquid - Abundant (≥1/day)") {
      ret_obj = await true;
    } else {
      ret_obj = await false;
    }
    return ret_obj;
  }

  // Future<bool> isCurrent_NG_greater_EN(Sum_NG_out_ENin_values Ng_En_Values)async{
  //   bool ret_obj = false;
  //   // if(Ng_En_Values.sumNG_current==null?false:int.parse(Ng_En_Values.sumNG_current)>(Ng_En_Values.sumEN_current==null?false:int.parse(Ng_En_Values.sumEN_current)) && Ng_En_Values.sumEN_current==null?false:int.parse(Ng_En_Values.sumEN_current)>0){
  //   //   ret_obj = await true;
  //   // }else{
  //   //   ret_obj = await false;
  //   // }
  //
  //   if(Ng_En_Values.sumNG_current == null ||Ng_En_Values.sumEN_current == null){
  //     ret_obj = await false;
  //   }else if(double.parse(Ng_En_Values.sumNG_current).toInt() > double.parse(Ng_En_Values.sumEN_current).toInt() && double.parse(Ng_En_Values.sumEN_current).toInt()>0 ){
  //        ret_obj = await true;
  //   }
  //
  //   return ret_obj;
  // }

  Future<bool> getNtDataOralAcceptance(
      PatientDetailsData patientDetailsData) async {
    bool is_obj = false;
    var oraldata = await getORAL(patientDetailsData);

    if (oraldata != null &&
        oraldata.result.isNotEmpty &&
        oraldata?.result?.first?.last3daysData != null &&
        oraldata?.result?.first?.last3daysData.isNotEmpty) {
      if (oraldata?.result?.first?.last3daysData?.length == 3) {
        for (var a in oraldata?.result?.first?.last3daysData) {
          if (a.data.breakFastRes == "Abdominal surgery" ||
              a.data.breakFastRes == "Abdominal surgery" ||
              a.data.lunchRes == "Abdominal surgery" ||
              a.data.noonRes == "Abdominal surgery" ||
              a.data.dinnerRes == "Abdominal surgery" ||
              a.data.supperRes == "Abdominal surgery") {
            is_obj = true;
          } else {
            is_obj = false;
          }
        }
      }
    }

    return is_obj;
  }

  Future<bool> getNtDataReducedJustification(
      PatientDetailsData patientDetailsData) async {
    bool is_object = false;

    var enteral_data =
        await eternal_controller.getEnternalData(patientDetailsData);

    if (enteral_data != null &&
        enteral_data.reducesed_justification != null &&
        enteral_data.reducesed_justification.surgery_postOpList != null &&
        enteral_data.reducesed_justification.surgery_postOpList.isNotEmpty) {
      for (var a in enteral_data.reducesed_justification.surgery_postOpList) {
        if (a.surgery_postOp == "yes") {
          is_object = true;
        } else {
          is_object = false;
        }
      }
    }

    return is_object;
  }

  Future<bool> getNtDataFasting(PatientDetailsData patientDetailsData) async {
    bool is_object = false;
    Ntdata ntdata = await getFAsting(patientDetailsData);
    if (ntdata != null &&
        ntdata?.result?.isNotEmpty &&
        ntdata?.result?.first?.fastingOralData.isNotEmpty) {
      if (ntdata.result?.first?.fastingOralData.length == 3) {
        for (var a in ntdata?.result?.first?.fastingOralData) {
          if (a.fastingReason == "Fasting after abdominal surgery") {
            is_object = true;
          } else {
            is_object = false;
          }
        }
      }
    }

    return is_object;
  }
}

class Sum_NG_out_ENin_values {
  String sumEN_current;
  String sumEN_last;
  String sumNG_current;
  String sumNG_last;

  Sum_NG_out_ENin_values(
      {this.sumNG_current,
      this.sumNG_last,
      this.sumEN_current,
      this.sumEN_last});
}

class CurrentDayFasting {
  var fasting;
  var fasting_reason;
  var fasting_condition;

  CurrentDayFasting(
      {this.fasting, this.fasting_reason, this.fasting_condition});
}

class CurrentDayAbdomnData {
  var vomit;
  var distention;
  var bowl_movement;

  CurrentDayAbdomnData({this.vomit, this.distention, this.bowl_movement});
}

class CurrentDayEnteralData {
  String ml_mani_currentWorkDay;
  String ml_indust_currentWorkDay;
  int tabindex;

  CurrentDayEnteralData(
      {this.ml_mani_currentWorkDay,
      this.ml_indust_currentWorkDay,
      this.tabindex});
}

class Gif_Data {
  int gif_score;
  String gif_result;

  Gif_Data({this.gif_score, this.gif_result});
}

class abdomenModelDaata {
  var bowl_movement;
  var distention;
  var vomit;
  var sound;

  abdomenModelDaata(
      {this.bowl_movement, this.distention, this.vomit, this.sound});
}
