import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/model/HistoryModel.dart';
import 'package:medical_app/model/MultipleMsgHistory.dart';
import 'package:medical_app/model/commonResponse.dart';


class HistoryController extends GetxController {



  void saveHistory(String id,String type,String message) async {
    print(APIUrls.addHistory);
    showLoader();
    try {
      Request request = Request(url: APIUrls.addHistory, body: {
        'userId': id,
        'type': type,
        'message': message,
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        Get.back();
        if (commonResponse.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }

  void saveHistoryWihtoutLoader(String id,String type,String message) async {
    print(APIUrls.addHistory);
    // showLoader();
    try {
      Request request = Request(url: APIUrls.addHistory, body: {
        'userId': id,
        'type': type,
        'message': message,
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        // Get.back();
        if (commonResponse.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          // ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }


  Future<String> saveMultipleMsgHistory(String id,String type,List messages) async {
    print(APIUrls.addHistory);
    showLoader();
    try {
      Request request = Request(url: APIUrls.addHistory, body: {
        'userId': id,
        'type': type,
        'message': '',
        'apptype': '0',
        'multipalmessage': jsonEncode(messages),
      });

      print(request.body);
      await request.post().then((value) {
        CommonResponse commonResponse =
        CommonResponse.fromJson(json.decode(value.body));

        print(commonResponse.message);
        print(commonResponse.success);
        Get.back();
        if (commonResponse.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
        } else {
          ShowMsg(commonResponse.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }

    return 'success';

  }


  var getHistoryData = List<HistoryData>().obs;

  void getHistory(String patientId,String type) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);

    print(APIUrls.getHistory);
    showLoader();

    try {
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        'type': type,
        'loggedUserId': userid,
      });

      print(request.body);
      await request.post().then((value) {
        GetHistory getHistory =
        GetHistory.fromJson(json.decode(value.body));

        print(getHistory.message);
        print(getHistory.success);
        Get.back();
        if (getHistory.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
          getHistoryData.clear();
          getHistoryData.addAll(getHistory.data);

          getHistoryData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(getHistory.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }



  var getHistoryMultipleData = List<MultipleMsgData>().obs;

  void getMultipleHistory(String patientId,String type) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);

    print(APIUrls.getHistory);
    showLoader();

    try {
      Request request = Request(url: APIUrls.getHistory, body: {
        'userId': patientId,
        'type': type,
        'loggedUserId': userid,
      });

      print(request.body);
      await request.post().then((value) {
        MultipleMsgHistory msgHistory =
        MultipleMsgHistory.fromJson(json.decode(value.body));

        print(msgHistory.message);
        print(msgHistory.success);
        Get.back();
        if (msgHistory.success == true) {
          // Get.back();
          // ShowMsg(settingdetails.message);
          getHistoryMultipleData.clear();
          getHistoryMultipleData.addAll(msgHistory.data);
          getHistoryMultipleData.sort((a, b) {
            var adate = a.createdAt; //before -> var adate = a.expiry;
            var bdate = b.createdAt; //before -> var bdate = b.expiry;
            return bdate.compareTo(
                adate); //to get the order other way just switch `adate & bdate`
          });
        } else {
          ShowMsg(msgHistory.message);
        }
      });
    } catch (e) {
      print('eception: $e');
      // ServerError();
    }
  }

}
