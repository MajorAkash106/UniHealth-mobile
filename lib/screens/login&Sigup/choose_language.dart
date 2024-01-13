import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/screens/login&Sigup/login_screen.dart';

import '../../config/Locale/languages.dart';
import '../../config/Locale/locale_config.dart';
import '../../config/cons/colors.dart';
import '../../config/cons/images.dart';
import '../../config/sharedpref.dart';
import '../../contollers/save_lang_contoller.dart';

class ChooseLanguageScreen extends StatefulWidget {
  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  final LocaleConfig localeConfig = LocaleConfig();
  final LangRepository langRepository = LangRepository();
  String currentLan;

  getData() async {
    currentLan =
        await MySharedPreferences.instance.getStringValue('languageCode');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Center(
                  child: Image.asset(
                AppImages.uniHealthLogo,
                width: Get.width / 1.5,
              )),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  // Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'choose_your_language'.tr,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        chooseLan(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () =>onTap(),
                            child: Text("skip>".tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic))),
                        GestureDetector(
                            onTap: () =>onTap(),
                            child: Text("next>".tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic))),
                      ],
                    ),
                  ),
                  // Spacer()

                  // Container(
                  //     width: Get.width,
                  //     child: RaisedButton(
                  //       // shape: RoundedRectangleBorder(
                  //       //   borderRadius: BorderRadius.circular(10.0),
                  //       // ),
                  //       padding: EdgeInsets.all(15.0),
                  //       elevation: 0,
                  //       onPressed: () {
                  //         Get.to(LoginScreen());
                  //       },
                  //       color: primary_color,
                  //       textColor: Colors.white,
                  //       child: Text("Skip".tr, style: TextStyle(fontSize: 14)),
                  //     )),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //     width: Get.width,
                  //     child: RaisedButton(
                  //       // shape: RoundedRectangleBorder(
                  //       //   borderRadius: BorderRadius.circular(10.0),
                  //       // ),
                  //       padding: EdgeInsets.all(15.0),
                  //       elevation: 0,
                  //       onPressed: () {},
                  //       color: primary_color,
                  //       textColor: Colors.white,
                  //       child: Text("Next".tr, style: TextStyle(fontSize: 14)),
                  //     )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  onTap() {
    if (currentLan==null || currentLan == '' || currentLan == Languages.ENGLISH) {
      localeConfig.setLocale(Languages.ENGLISH);
    } else {
      localeConfig.setLocale(Languages.PORTUGUESE);
    }
    Get.to(LoginScreen(
      isFromLangScreen: true,
    ));
  }

  Widget chooseLan() {
    // debugPrint("v::${localeConfig.currentLan.value}");
    return Padding(
      padding: const EdgeInsets.only(
        left: 0.0,
        right: 0.0,
      ),
      child: Container(
        height: 50.0,
        child: Container(
          decoration: BoxDecoration(
              // color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: primary_color,
                // width: 4,
              )),
          height: 40.0,
          width: MediaQuery.of(context).size.width,
          child:
              //Container(child: Center(child: _value==0?,),),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      iconEnabledColor: Colors.black,
                      // isExpanded: true,
                      iconSize: 30.0,
                      dropdownColor: Colors.white,
                      // hint: Text(_value),

                      value: currentLan == 'pt' ? 'pt' : 'en',
                      items: [
                        DropdownMenuItem(
                            value: "pt",
                            child: Text(
                              "   Portuguese (BR)",
                              style: Theme.of(context).textTheme.bodyText2,
                            )),
                        DropdownMenuItem(
                            value: "en",
                            child: Text(
                              "   English (US)",
                              style: Theme.of(context).textTheme.bodyText2,
                            ))
                      ],
                      onChanged: (value) async {
                        print('value ;; $value');
                        currentLan = value;

                        if (currentLan==null || currentLan == '' || currentLan == Languages.ENGLISH) {
                          localeConfig.setLocale(Languages.ENGLISH);
                        } else {
                          localeConfig.setLocale(Languages.PORTUGUESE);
                        }
                        getData();
                        setState(() {});
                      })),
        ),
      ),
    );
  }
}
