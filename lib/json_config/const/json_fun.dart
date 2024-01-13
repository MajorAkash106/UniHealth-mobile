import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<String> getJson(String fileName) {
  try {
    debugPrint('${'json_path'.tr}/$fileName.json');
    return rootBundle.loadString('${'json_path'.tr}/$fileName.json');
  } catch (e) {
    debugPrint('catch error $e');
  }
}
