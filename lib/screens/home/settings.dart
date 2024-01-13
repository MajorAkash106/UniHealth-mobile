//import 'dart:html';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Locale/languages.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/versioning/versioning.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/config/widgets/textfields.dart';
import 'package:medical_app/contollers/other_controller/home_contoller.dart';
import 'package:medical_app/contollers/other_controller/log_out_controller.dart';
import 'package:medical_app/contollers/other_controller/setting_controller.dart';
import 'package:medical_app/contollers/save_lang_contoller.dart';
import 'package:medical_app/screens/home/Change_pswd_screen.dart';

import 'package:medical_app/screens/home/notification/notifications.dart';
import 'package:medical_app/screens/home/patients&hospitals/hospitals.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingController _controller = SettingController();
  final HomeConroller _homeConroller = HomeConroller();
  final Log_out_controller _log_out_controller = Log_out_controller();
  final AppVersionConfig versionController = AppVersionConfig();

  var Name = TextEditingController();
  var E_mail = TextEditingController();
  File profile_Image;

  var ref_value;
  Future<bool> _onwillpop() async {
    // await _homeConroller.getData();
    Get.back(canPop: true);
  }

  @override
  void initState() {
    getData();

    checkConnectivityWihtoutMsg().then((internet) {
      print('internet');

      if (internet != null && internet) {
        _controller.getData();
        print('internet avialable');
      } else {
        _controller.getFromSqflite();
      }
    });
    super.initState();
  }

  String currentLan;
  getData() async {
    String refU = await MySharedPreferences.instance.getStringValue(Session.refUnit);
    currentLan = await MySharedPreferences.instance.getStringValue('languageCode');

    print('reference unit: ${refU}');

    setState(() {
      _radioValue = int.parse(refU.isEmpty ? '1' : refU);

      if (_radioValue == 1) {
        ref_value = 'kg_meter'.tr;
      } else {
        ref_value = 'lbs_inches'.tr;
      }

      debugPrint('ref_value :: $ref_value');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onwillpop,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: CommonHomeButton(),
          body: Obx(
            () => _controller.email.value.isNotEmpty
                ?
                //
                // Container(
                //     height: Get.height,
                //
                //     child:
                Container(
                    color: primary_color,
                    child: SafeArea(
                        child: Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                    child: ListView(
                                  // shrinkWrap: true,
                                  children: [
                                    Container(
                                      color: primary_color,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4.0,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 20, 0, 10),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              child: Container(
                                                height: 129,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                        width: 129.0,
                                                        height: 129.0,
                                                        child: _controller
                                                                .imagepath
                                                                .value
                                                                .isBlank
                                                            ? _controller
                                                                    .imageUrl
                                                                    .value
                                                                    .isNullOrBlank
                                                                ? ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: Image
                                                                        .network(
                                                                      AppImages
                                                                          .avtarImageUrl,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      // height: 100,
                                                                      // width: 100,

                                                                      loadingBuilder: (BuildContext ctx,
                                                                          Widget
                                                                              child,
                                                                          ImageChunkEvent
                                                                              loadingProgress) {
                                                                        if (loadingProgress ==
                                                                            null) {
                                                                          return child;
                                                                        } else {
                                                                          return Container(
                                                                              width: 129.0,
                                                                              height: 129.0,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(color: card_color, width: 1.0),
                                                                              ),
                                                                              child: Center(
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                ),
                                                                              ));
                                                                        }
                                                                      },
                                                                    ),
                                                                  )
                                                                : ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child: Image
                                                                        .network(
                                                                      APIUrls.ImageUrl +
                                                                          _controller
                                                                              .imageUrl
                                                                              .value,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      // height: 100,
                                                                      // width: 100,

                                                                      loadingBuilder: (BuildContext ctx,
                                                                          Widget
                                                                              child,
                                                                          ImageChunkEvent
                                                                              loadingProgress) {
                                                                        if (loadingProgress ==
                                                                            null) {
                                                                          return child;
                                                                        } else {
                                                                          return Container(
                                                                              width: 129.0,
                                                                              height: 129.0,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                                border: Border.all(color: card_color, width: 1.0),
                                                                              ),
                                                                              child: Center(
                                                                                child: CircularProgressIndicator(
                                                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                                                ),
                                                                              ));
                                                                        }
                                                                      },
                                                                    ),
                                                                  )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                child: Image(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: FileImage(File(
                                                                      _controller
                                                                          .imagepath
                                                                          .value)),
                                                                ),
                                                              ),
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          // image: new DecorationImage(
                                                          //     fit: BoxFit.cover,
                                                          //     image:
                                                          //     _controller.imagepath.value.isBlank?
                                                          //
                                                          //     _controller.imageUrl.value.isNullOrBlank?  NetworkImage(AppImages.avtarImageUrl): NetworkImage(APIUrls.ImageUrl+_controller.imageUrl.value)
                                                          //
                                                          //         : FileImage(File(_controller.imagepath.value))
                                                          // ),
                                                          border:
                                                              new Border.all(
                                                            color: Colors.white,
                                                            width: 1.0,
                                                          ),
                                                        )),
                                                    Positioned(
                                                        bottom: 5.0,
                                                        right: 0.0,
                                                        child: InkWell(
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              radius: 12.0,
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .camera_alt,
                                                                  size: 13.5,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              )),
                                                          onTap: () {
                                                            CameraIcon_Action();
                                                          },
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 30.0,
                                                  bottom: 35.0,
                                                  right: 5.0),
                                              child:
                                                  // Expanded(child:
                                                  // Column(
                                                  //   //mainAxisAlignment: MainAxisAlignment.start,
                                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                                  //   children: [
                                                  // Expanded(
                                                  //   child:
                                                  Center(
                                                child:
                                                    // Flexible(child:
                                                    Text(
                                                  '${_controller.name.value ?? ''}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                // )
                                              ),
                                              // ),

                                              //   ],
                                              // ),
                                              // )
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.6))),
                                            child: CustomTextField(
                                                'name'.tr,
                                                _controller.nameController,
                                                TextInputType.emailAddress,
                                                false,
                                                Icon(Icons.person),
                                                Icon(null),
                                                null),
                                          ),
                                          SizedBox(
                                            height: 30.0,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              ShowMsg(
                                                  'This field can be edited only once.');
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 0.6))),
                                                // child: CustomTextField(
                                                //     'Email',
                                                //     _controller.emailController,
                                                //     TextInputType.emailAddress,
                                                //     false,
                                                //     Icon(Icons.email_outlined),
                                                //     Icon(null),
                                                //     null),
                                                child: TextField(
                                                  // onChanged:,
                                                  enabled: false,
                                                  style: TextStyle(
                                                      color: Colors.black87),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    // hintText: hint,
                                                    labelText: 'email'.tr,
                                                    // filled: true,

                                                    fillColor: Colors.black87,
                                                    prefixIcon: Icon(
                                                        Icons.email_outlined),
                                                  ),
                                                  controller: _controller
                                                      .emailController,
                                                )

                                                // TextField(decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.black,fontSize: 13),
                                                //   border: InputBorder.none
                                                // ),),
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),

                                    // RaisedButton(onPressed: (){
                                    //
                                    //   Get.to(Step1HospitalizationScreen(
                                    //     patientUserId: '60d1bdf3b423b67f843a5c8a',
                                    //   ));
                                    // },child: Text("patient's slip"),),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RaisedButton(
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 50.0,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'ref_unit'.tr,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      // Spacer(),
                                                      // Padding(
                                                      //   padding: const EdgeInsets.only(bottom: 20.0),
                                                      //   child: IconButton(
                                                      //       icon: Icon(
                                                      //         Icons.arrow_drop_down_sharp,
                                                      //         size: 40.0,
                                                      //         color: Colors.white,
                                                      //       ),
                                                      //       onPressed: () {}),
                                                      // )
                                                    ],
                                                  ),
                                                ),
                                                color: primary_color,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                onPressed: () async {
                                                  String refU =
                                                      await MySharedPreferences
                                                          .instance
                                                          .getStringValue(
                                                              Session.refUnit);
                                                  print(
                                                      'reference unit: ${refU}');

                                                  setState(() {
                                                    _radioValue = int.parse(
                                                        refU.isEmpty
                                                            ? '1'
                                                            : refU);
                                                  });
                                                  select_unit();

                                                  //
                                                  // Get.to(Step1HospitalizationScreen(
                                                  //   patientUserId: 60d1bdf3b423b67f843a5c8a,
                                                  // ));
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    ref_value != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Row(
                                              children: [
                                                //Expanded(
                                                //child:

                                                Text(
                                                  '${ref_value}'.tr,
                                                  style: TextStyle(
                                                      color: primary_color,
                                                      fontSize: 18),
                                                )
                                                //)
                                              ],
                                            ),
                                          )
                                        : SizedBox(),
                                    ref_value != null
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: Divider(),
                                          )
                                        : SizedBox(),
                                    // Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RaisedButton(
                                                child: Container(
                                                    //width: MediaQuery.of(context).size.width,
                                                    height: 50.0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'save'.tr,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    )
                                                    // child: Center(
                                                    //   child: Text(
                                                    //     'Save',
                                                    //     style: TextStyle(color: Colors.white),
                                                    //   ),
                                                    // ),
                                                    ),
                                                color: primary_color,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0)),
                                                onPressed: () {
                                                  checkConnectivity()
                                                      .then((internet) {
                                                    print('internet');
                                                    if (internet != null &&
                                                        internet) {
                                                      if (_controller.imagepath
                                                          .value.isNotEmpty) {
                                                        _controller.onSave();
                                                      } else {
                                                        _controller
                                                            .onSaveName();
                                                      }
                                                    }
                                                  });

                                                  // Get.to(Change_Password());
                                                }),
                                          )
                                        ],
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       left: 20.0, right: 20.0),
                                    //   child: Row(
                                    //     children: [
                                    //       Expanded(
                                    //         child: RaisedButton(
                                    //             child: Container(
                                    //               width: MediaQuery.of(context)
                                    //                   .size
                                    //                   .width,
                                    //               height: 50.0,
                                    //
                                    //               child: Row(
                                    //                 mainAxisAlignment:
                                    //                     MainAxisAlignment
                                    //                         .center,
                                    //                 children: [
                                    //                   Text(
                                    //                     'change_password'.tr,
                                    //                     style: TextStyle(
                                    //                         color:
                                    //                             Colors.white),
                                    //                   ),
                                    //                 ],
                                    //               ),
                                    //               // child: Center(
                                    //               //   child: Text(
                                    //               //     'Change password',
                                    //               //     style: TextStyle(color: Colors.white),
                                    //               //   ),
                                    //               // ),
                                    //             ),
                                    //             color: primary_color,
                                    //             shape: RoundedRectangleBorder(
                                    //                 borderRadius:
                                    //                     BorderRadius.circular(
                                    //                         10.0)),
                                    //             onPressed: () {
                                    //               Get.to(Change_Password());
                                    //             }),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    chooseLan(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 50.0,
                                              child:
                                              RaisedButton(
                                                  // borderSide: BorderSide(
                                                  //     color: primary_color),
                                                color: primary_color,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0)),
                                                  child:

                                                      Center(
                                                    child: Text(
                                                      'logout'.tr,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    _log_out_controller
                                                        .logout();
                                                  }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, right: 20.0, top: 10),
                                      child: FutureBuilder<String>(
                                        future: versionController
                                            .returnVersion(), // async work
                                        builder: (BuildContext context,
                                            AsyncSnapshot<String> snapshot) {
                                          return Text(
                                            '${'version'.tr} - ${snapshot.data}',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black45),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ))
                              ],
                            ))))
                // )
                : Loader(),
          )),
    );
  }

  void CameraIcon_Action() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(35.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150.0,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        'take_a_new_photo'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      onTap: () {
                                        _controller.TapOnCamera();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        'add_from_gallary'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      onTap: () {
                                        _controller.TapOnGallery();
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final LocaleConfig localeConfig = LocaleConfig();
  final LangRepository langRepository = LangRepository();

  chooseLan() {
    debugPrint("v::${localeConfig.currentLan.value}");
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: Row(
        children: [
          Expanded(
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
                      onChanged: (value) {
                        print(value);
                        currentLan = value;
                        if (value != 'en') {
                          localeConfig.setLocale(Languages.PORTUGUESE);
                          langRepository.saveLang('pt');
                          getData();
                        } else {
                          localeConfig.setLocale(Languages.ENGLISH);
                          langRepository.saveLang('en');
                          getData();
                        }
                        setState(() {});
                      })
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void open_Gallary_or_camera(ImageSource type) async {
    final ImagePicker _picker = ImagePicker();
    final XFile photo = await _picker.pickImage(source: type);

    // var picture = await ImagePicker.pickImage(
    //     source: type); //platform.pickImage(source: type);
    setState(() {
      profile_Image = File(photo.path); //File(picture.path);
    });
  }

  void select_unit() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return StatefulBuilder(builder: (context, setState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 200.0,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ref_value = 'lbs_inches'.tr;
                                      _radioValue = 0;
                                      changeRefUnit(0);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 0,
                                        groupValue: _radioValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            ref_value = 'lbs_inches'.tr;
                                            _radioValue = value;
                                            changeRefUnit(_radioValue);
                                            // Get.back();
                                            // select_unit();
                                          });
                                        },
                                      ),
                                      new Text(
                                        'lbs_inches'.tr,
                                        style: new TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      ref_value = 'kg_meter'.tr;
                                      _radioValue = 1;
                                      changeRefUnit(1);
                                      // Get.back();
                                      // select_unit();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 1,
                                        groupValue: _radioValue,
                                        onChanged: (int value) {
                                          setState(() {
                                            ref_value = 'kg_meter'.tr;
                                            _radioValue = value;
                                            changeRefUnit(_radioValue);
                                            // Get.back();
                                            // select_unit();
                                          });
                                        },
                                      ),
                                      new Text(
                                        'kg_meter'.tr,
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Container(
                                    width: Get.width,
                                    child: CustomButton(
                                      text: "save".tr,
                                      myFunc: () {
                                        Get.back();
                                        changeRefUnit(_radioValue);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  int _radioValue = 1;

  void changeRefUnit(int refUnit)async {
    print('----------$refUnit------------');
    if (refUnit == 0) {
      print('LBS & INCHES');
     await MySharedPreferences.instance.setStringValue(Session.refUnit, '$refUnit');
      Future.delayed(Duration(milliseconds: 100),()=>getData());
    } else {
      print('KG & METERS');
     await MySharedPreferences.instance.setStringValue(Session.refUnit, '$refUnit');
      Future.delayed(Duration(milliseconds: 100),()=>getData());
    }



  }
}
