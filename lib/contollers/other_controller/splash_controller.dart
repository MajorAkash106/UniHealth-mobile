import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/screens/home/home_screen.dart';
import 'package:medical_app/screens/login&Sigup/choose_language.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    isLogin();
    super.onInit();
  }

  void isLogin() async {
    var email =
        await MySharedPreferences.instance.getStringValue(Session.email);
    new Future.delayed(const Duration(milliseconds: 0), () async {
      print(email);
      if (email == null || email.isBlank) {
        String currentLan =
            await MySharedPreferences.instance.getStringValue('languageCode');

        adLog("currentLan currentLan currentLan :: $currentLan");
        if (currentLan == null || currentLan == '') {
          Get.offAll(ChooseLanguageScreen());
        } else {
          Get.offAll(LoginScreen());
        }
      } else {
        print('going to home');
        Get.offAll(HomeScreen());
      }
    });
  }
}
