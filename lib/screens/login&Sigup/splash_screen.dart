import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/diagnosis_controller/CIDsController.dart';
import 'package:medical_app/contollers/other_controller/splash_controller.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/contollers/sqflite/model/User.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController splashController = Get.put(SplashController());


  @override
  void initState() {
    // TODO: implement initState
    getDataa();
    super.initState();
  }


  getDataa() async {
    var dbHelper = Helper();
    await dbHelper.chackDb().then((value) {
      print('database exist : ${value}');
      if(value){

        print('sqflite database contain all cids');

      }else{
        print('sqflite database doesnot contain data');
        SaveDataToSqflite();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: primary_color,
        // child: Center(child: SvgPicture.asset(AppImages.Splashlogo)),
        // child: Center(child: Image.asset(AppImages.SplashlogoUnihealth,width: Get.width/1.3,)),
      ),
    );
  }
}



Future<String> SaveDataToSqflite(){

  print('cid data from api');

  final CIDsController _ciDsController = CIDsController();

  _ciDsController.getListData().then((value){
    print('all cids data: ${value.length}');
    // -------------------save data to sqflite---------------------------

    print('cids: ${_ciDsController.CIDList.length}');

    for (var a = 0; a < _ciDsController.CIDList.length; a++) {
      var user = User();
      user.name = _ciDsController.CIDList[a].cidname;
      user.phone = _ciDsController.CIDList[a].sId;
      user.email = 'teEmailController.text';
      var dbHelper = Helper();
      dbHelper.insert(user).then((value) {

      });
    }

  });


}