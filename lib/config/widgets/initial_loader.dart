import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(backgroundColor: Colors.white,),
    );
  }
}

Future showLoader() {
  return Get.dialog(Loader(),
      barrierDismissible: false,);
}
