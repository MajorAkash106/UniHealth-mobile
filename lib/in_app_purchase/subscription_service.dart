import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/commonResponse.dart';
import 'package:medical_app/model/handle_access/handle_access.dart';
import 'package:medical_app/model/register_controller/attribution_model.dart';
import 'package:medical_app/model/register_controller/payment_model.dart';

class SubscriptionService {
  bool isFoundExpired = false;

  Future<Settingdetails> getUserDetailsWithFilterPlan(
      Settingdetails alldetails) async {
    if (alldetails.data.payments.isNotEmpty &&
        alldetails.data.attributionInfo.isNotEmpty) {
      List<Payments> paymentData = [];
      List<AttributionInfo> attribution = [];

      for (var p in alldetails.data.payments) {
        // DateTime exiredDate = DateTime.parse(p.expiredDate);
        var exiredDate = DateFormat(commonDateFormat).format(DateTime.parse(p.expiredDate));
        // DateTime today = DateTime.now();
        // DateTime currentDate = DateTime.parse(alldetails.currentdate);
        var currentDate = DateFormat(commonDateFormat).format(DateTime.parse(alldetails.currentdate));
        // print('current date from server: $currentDate');
        // print('expired date from server: $exiredDate');
        // print('testing from current date : ${currentDate.isAfter(exiredDate)}');

        bool expired = currentDate.toString() == exiredDate.toString();

        if (!expired) {
          print('subscription details');
          print('subscription ${p.productId}');
          print('plan is expired $expired');

          var a = await alldetails.data.attributionInfo.firstWhere(
              (element) => element.sId == p.attributeId,
              orElse: () => null);

          print('expired attribute --- ${jsonEncode(a)}');

          paymentData.add(p);
          attribution.add(a);
        } else {
          isFoundExpired = true;
          // await active_payemnt.add(p);
        }
      }

      print(paymentData.length);
      print(attribution.length);

      alldetails.data.payments.clear();
      alldetails.data.attributionInfo.clear();

      alldetails.data.attributionInfo.addAll(attribution);
      alldetails.data.payments.addAll(paymentData);

      return alldetails;
    } else {
      return alldetails;
    }
  }

  Future<String> checkPlans() async {
    SaveDataSqflite dataSqflite = SaveDataSqflite();

    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    await dataSqflite.getUserDetails(userid).then((value) {
      if (value.data.payments.isNotEmpty && value.data.attributionInfo.isNotEmpty) {
        print('get : ${value.data.payments.length} ${value.data.attributionInfo.length}');

        getUserDetailsWithFilterPlan(value).then((resp) {
          print('return resp : ${resp.data.payments.length} ${resp.data.attributionInfo.length}');

          print('is any expired: ${isFoundExpired}');

          if (isFoundExpired) {




            saveLocalAndServer(resp);
          }



          // if (value.data.payments.length != resp.data.payments.length) {
          //   print('save local & update server Active plans');
          // } else {
          //   print('every plan is active');
          // }
        });
      }
    });
  }

  saveLocalAndServer(Settingdetails data) async {
    SaveDataSqflite dataSqflite = SaveDataSqflite();
    await dataSqflite.clearData(data.data.sId);
    await dataSqflite.saveUserDetails(data);
    await saveAttributeAndPaymentDetails(data);
  }

  Future<String> saveAttributeAndPaymentDetails(Settingdetails data) async {
    // List hospitalData = [];
    // for (var a in data.data.attributionInfo) {
    //   Map data = {
    //     "_id": a.hospital.first.sId,
    //     "name": a.hospital.first.name,
    //   };
    //   hospitalData.add(data);
    // }

    try {
      print(APIUrls.upDateRequest);
      Request request = Request(url: APIUrls.upDateRequest, body: {
        "userId": data.data.sId,
        "hospital": jsonEncode(data.data.hospital),
        "badges": jsonEncode(data.data.attributionInfo),
        "payments": jsonEncode(data.data.payments),
      });
      print('update Active plans');
      print(request.body);
      await request.post().then((respone) {
        CommonResponse model = CommonResponse.fromJson(jsonDecode(respone.body));
        print(model.success);
        print(model.message);

      });
    } catch (e) {
      // Get.to(LoginScreen());
      print('exception occur : ${e}');

      // ServerError();
    }

    return "suceess";
  }
}
