import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medical_app/model/commonResponse.dart';

import '../config/cons/APIs.dart';
import '../config/cons/Sessionkey.dart';
import '../config/request.dart';
import '../config/sharedpref.dart';

class LangRepository extends GetxController {
  void saveLang(String lang) async {
    var userid = await MySharedPreferences.instance.getStringValue(Session.userid);
    if (userid != null && userid != '') {
      final body = {'userId': userid, 'lang': lang};

      print(APIUrls.saveLang);
      Request request = Request(url: APIUrls.saveLang, body: body);
      print(request.body);
      await request.post().then((resp) {
        CommonResponse response =
            CommonResponse.fromJson(jsonDecode(resp.body));
        debugPrint('response : ${response.toJson()}');
      });
    }
  }
}
