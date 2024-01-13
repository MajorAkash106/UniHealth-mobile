import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/vigilanceController.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_history.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/fluid_history_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart' as w;

class Mean_Iap_Controller extends GetxController {
  final VigilanceController vigilanceController = VigilanceController();
  final PatientSlipController patientSlipController = PatientSlipController();

  Future<String> onSaved(PatientDetailsData data, TextEditingController _date,
      TextEditingController value) async {
    print('date : ${_date.text}');
    // print('in & out : ${selectedIndex}');
    print('ml : ${value.text}');

    List<Mean_IAP_Data> mean_data_list = [];
    String balanceSince;
    await get_mean_IapData(data).then((val) {
      if (val != null) {
        mean_data_list.addAll(val.result[0].mean_data);
        balanceSince = val.result[0].balanceSince;
      }
    });

   await mean_data_list.add(Mean_IAP_Data(
        // date: DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days: 1))),
        // date: DateFormat(commonDateFormat).format(DateTime.now()),
        date: _date.text,
        iap_value: value.text,
        time: DateFormat('HH:mm').format(DateTime.now())
        // time: '04:15'
        ));



    await checkMeanStatus(data, mean_data_list, balanceSince);

    // await vigilanceController.saveData(data, finalData, VigiLanceBoxes.meaIAP_status,VigiLanceBoxes.mean_IAP);
    // await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);


    return 'success';
  }

  Future<String> onEdit(
      PatientDetailsData data,
      TextEditingController _date,
      TextEditingController iap_value,
      Mean_IAP_Data previousData,
      bool delete) async {
    print('date : ${_date.text}');
    print('ml : ${iap_value.text}');

    List<Mean_IAP_Data> mean_data_list = [];
    int index = 0;
    String balanceSheet;
    await get_mean_IapData(data).then((val) {
      if (val != null) {
        index = val.result[0].mean_data.indexOf(previousData);
        val.result[0].mean_data.remove(previousData);

        mean_data_list.addAll(val.result[0].mean_data);
        balanceSheet = val.result[0].balanceSince;
      }
    });
    print('edit part');
    if (!delete) {
      await mean_data_list.insert(
          index,
          Mean_IAP_Data(
              iap_value: iap_value.text,
              date: previousData.date,
              time: previousData.time));
      await checkMeanStatus(data, mean_data_list, balanceSheet);
    }else{
     await saveDataAfterMeanStatus(data, mean_data_list, balanceSheet);
    }





    // await vigilanceController.saveData(data, finalData, VigiLanceBoxes.meaIAP_status,VigiLanceBoxes.mean_IAP);
    // await saveHistory(data.sId, finalData, ConstConfig.fluidHistory);


    return 'success';
  }

  saveDataAfterMeanStatus(PatientDetailsData data,List<Mean_IAP_Data> meanData,String balanceSince) async {

    Map finalData = {
      "lastUpdate": '${DateFormat(commonDateFormat).format(DateTime.now())}',
      "balance_since": balanceSince ?? '',
      "meansHighCheck": meanHigh.value,
      "mean_data": meanData
    };
    print('final Data: ${jsonEncode(finalData)}');
    await vigilanceController.saveData(data, finalData, VigiLanceBoxes.meaIAP_status,VigiLanceBoxes.mean_IAP);
  }

  Future<List<String>> get_avg_MeanIap(PatientDetailsData data) async {
    // try {
    // await  patientSlipController.getDetails(data.sId, 0);
    // PatientDetailsData data = patientSlipController.patientDetailsData[0];
    DateTime lastWorkStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now().subtract(Duration(days: 1)));

    DateTime lastWorkEndCurrentStart = await getDateTimeWithWorkdayHosp(
        data.hospital.first.sId, DateTime.now());

    print("cccc.....${lastWorkStart.toString()}");
    print("llll......${lastWorkEndCurrentStart.toString()}");

    List lastDay_Mean = [];
    List currentDay_Mean = [];
    String last_day_meanIAP_avg = '0';
    String current_day_meanIAP_avg = '0';
    var dateTimee;
    await get_mean_IapData(data).then((val) {
// print(jsonEncode(val));
      if (val != null) {
        print("getting mean data");
        for (int i = 0; i < val.result[0].mean_data.length; i++) {
          print('ppp');
          dateTimee =
              '${val.result[0].mean_data[i].date} ${val.result[0].mean_data[i].time}:00';
          print(".........****${DateTime.parse(dateTimee)}");
          print(DateFormat(commonDateFormat)
              .format(DateTime.now().subtract(Duration(days: 1))));
          if (DateTime.parse(dateTimee).isBefore(lastWorkEndCurrentStart) &&
                  DateTime.parse(dateTimee).isAfter(lastWorkStart)
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now().subtract(Duration(days:1)))

              ) {
            lastDay_Mean.add(double.parse(val.result[0].mean_data[i].iap_value));
          } else if (DateTime.parse(dateTimee).isAfter(lastWorkEndCurrentStart)
              // DateFormat(commonDateFormat).format(DateTime.parse(value.result[0].tempratureSheetData.tempratureData[i].date))==DateFormat(commonDateFormat).format(DateTime.now())
              ) {
            currentDay_Mean.add(double.parse(val.result[0].mean_data[i].iap_value));
          } else {}
        }
      } else {
        print('value null');
      }

      print("last day mean.. ${lastDay_Mean.toString()}");
      print("current day mean.. ${currentDay_Mean.toString()}");
      if (lastDay_Mean.isNotEmpty) {
        var lst_avg = lastDay_Mean.reduce((a, b) => a + b) / lastDay_Mean.length;
        last_day_meanIAP_avg = lst_avg.toString();
        print(last_day_meanIAP_avg);
      } else {}
      if (currentDay_Mean.isNotEmpty) {
        var crnt_avg =
            currentDay_Mean.reduce((a, b) => a + b) / currentDay_Mean.length;
        current_day_meanIAP_avg = crnt_avg.toString();
        print(current_day_meanIAP_avg);
      } else {}
    });

    return [last_day_meanIAP_avg, current_day_meanIAP_avg];
  }

  checkMeanStatus(PatientDetailsData data,List<Mean_IAP_Data> meanData,String balanceSince) async {
    meanHigh.value = false;
    if (data != null && meanData.length != 0) {
      double total = 0.0;
      for (var a in meanData) {
        double val = double.parse(a.iap_value);
        total = total + val;
      }

      if (total > 20) {
        debugPrint("mean IAP is going upper");
       await showVersionDialog(data, meanData, balanceSince);
      } else {
        // saveDataAfterMeanStatus(data, meanData, balanceSince);
        debugPrint("mean IAP is going down");
        await saveDataAfterMeanStatus(data, meanData, balanceSince);
      }
    }else{
      await saveDataAfterMeanStatus(data, meanData, balanceSince);
    }
  }

  var meanHigh = false.obs;
  void showVersionDialog(PatientDetailsData data,List<Mean_IAP_Data> meanData,String balanceSince) async {
    await showDialog<String>(
      context: Get.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "New Update Available";
        String message =
            "iap_is_less_des".tr;
        String btnLabel = "yes".tr;
        String btnLabelCancel = "no".tr;
        return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Platform.isIOS
                ? CupertinoAlertDialog(
                    // title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text(btnLabel),
                        onPressed: ()async {
                          meanHigh.value = true;
                          Navigator.pop(context);
                        await saveDataAfterMeanStatus(data, meanData, balanceSince);

                        },
                      ),
                      ElevatedButton(
                        child: Text(btnLabelCancel),
                        onPressed: ()async {
                          meanHigh.value = false;
                          Navigator.pop(context);
                         await saveDataAfterMeanStatus(data, meanData, balanceSince);

                        },
                      ),
                    ],
                  )
                : AlertDialog(
                    // title: Text(title),
                    content: Text(message),
                    actions: <Widget>[
                      ElevatedButton(
                        child: Text(btnLabel),
                        onPressed: () async{
                          meanHigh.value = true;
                          Navigator.pop(context);
                         await saveDataAfterMeanStatus(data, meanData, balanceSince);
                        },
                      ),
                      ElevatedButton(
                        child: Text(btnLabelCancel),
                        onPressed: ()async{
                          meanHigh.value = false;
                          Navigator.pop(context);
                        await saveDataAfterMeanStatus(data, meanData, balanceSince);
                        },
                      ),
                    ],
                  ));
      },
    );
  }
}

// }
