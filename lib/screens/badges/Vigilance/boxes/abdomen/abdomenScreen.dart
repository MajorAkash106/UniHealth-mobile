import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/abdomen_summary_controller.dart';
import 'package:medical_app/contollers/vigilance/mean_iap_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ons.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/abdomen/mean_Iap_Screen.dart';
import 'package:medical_app/screens/blank_screen_loader.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'giDisfunction.dart';

// class staticList{
//   String optionText;
//   bool isSelected;
//   staticList({this.optionText,this.isSelected});
// }

class AbdomenScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool activity;
  final abdomenModelDaata latestSelectedData;
  AbdomenScreen(
      {this.patientDetailsData, this.activity, this.latestSelectedData});

  @override
  _AbdomenScreenState createState() => _AbdomenScreenState();
}

class _AbdomenScreenState extends State<AbdomenScreen> {
  String BowlMovement;
  String BowlMovement_key;
  String abdominal_distention;
  String abdominal_distention_key;
  int selectedIndexTeam = 0;
  final PatientSlipController patientSlipController = PatientSlipController();
  Mean_Iap_Controller mean_iap_controller = Mean_Iap_Controller();
  TextEditingController ngTube = TextEditingController();
  TextEditingController ngTube2 = TextEditingController();
  TextEditingController lastMean_iap = TextEditingController();
  TextEditingController currentMean_iap = TextEditingController();
  List<staticList> listOptionTab_bowlSound = <staticList>[];
  List<staticList> listOptionTab_Vomiting = <staticList>[];
  List<staticList> listOptionDrpDwn_BowelMovements = <staticList>[
    staticList(optionText: "present".tr,),
    staticList(optionText: "absent".tr),
    staticList(optionText: "liquid_few_1_or_2_day".tr),
    staticList(optionText: "liquid_few_>3_day".tr),
    staticList(optionText: "liquid_abundant_>1_day".tr),
    staticList(optionText: "evaluation_not_possible".tr),
  ];
  List<staticList> listOptionDrpDwn_abdominalDistention = <staticList>[
    staticList(optionText: "absent".tr),
    staticList(optionText: "mild".tr),
    staticList(optionText: "moderate".tr),
    staticList(optionText: "severe".tr),
    staticList(optionText: "evaluation_not_possible".tr),
  ];

  @override
  void initState() {
    // TODO: implement initState

    listOptionTab_bowlSound
        .add(staticList(optionText: 'absent'.tr, isSelected: false));

    listOptionTab_bowlSound
        .add(staticList(optionText: 'present'.tr, isSelected: false));

    listOptionTab_bowlSound.add(
        staticList(optionText: 'evaluation_not_possible'.tr, isSelected: false));

    listOptionTab_Vomiting
        .add(staticList(optionText: 'absent'.tr, isSelected: false));
    listOptionTab_Vomiting
        .add(staticList(optionText: 'present'.tr, isSelected: false));
    listOptionTab_Vomiting.add(
        staticList(optionText: 'evaluation_not_possible'.tr, isSelected: false));

    this.getData();
    this.getNGTubeData();
    this.get_meaniapdata();
    super.initState();
  }

  final AbdomenController abdomenController = AbdomenController();

  void getData() {
    if (widget.latestSelectedData == null) {
      abdomenController.getAbdomenData(widget.patientDetailsData).then((val) {
        if (val != null) {
         var data = val.result[0].abdomenData;



          // debugPrint('indexBowelMovement${listOptionDrpDwn_BowelMovements[data.indexBowelMovement]}');
          // debugPrint('BowlMovement = ${listOptionTab_bowlSound[val.result[0].abdomenData.indexBowelMovement].optionText}');

          BowlMovement = listOptionDrpDwn_BowelMovements[val.result[0].abdomenData.indexBowelMovement].optionText;
         abdominal_distention = listOptionDrpDwn_abdominalDistention[val.result[0].abdomenData.indexAbdominalDist].optionText;

         // BowlMovement = val.result[0].abdomenData.bowelMovement;
         // abdominal_distention = val.result[0].abdomenData.abdominalDist;

          ngTube.text = val.result[0].abdomenData.ngTube;
          // lap.text = val.result[0].abdomenData.meanLap;

          if (val.result[0].abdomenData.bowelSound == 0) {
            listOptionTab_bowlSound[0].isSelected = true;
          } else if (val.result[0].abdomenData.bowelSound == 1) {
            listOptionTab_bowlSound[1].isSelected = true;
          } else if (val.result[0].abdomenData.bowelSound == 2) {
            listOptionTab_bowlSound[2].isSelected = true;
          }

          if (val.result[0].abdomenData.vomit == 0) {
            listOptionTab_Vomiting[0].isSelected = true;
          } else if (val.result[0].abdomenData.vomit == 1) {
            listOptionTab_Vomiting[1].isSelected = true;
          } else if (val.result[0].abdomenData.vomit == 2) {
            listOptionTab_Vomiting[2].isSelected = true;
          }
          setState(() {});
        }
      });
    } else {
      updatedWithLatest();
    }
  }

  updatedWithLatest() {
    abdomenModelDaata data = widget.latestSelectedData;
    BowlMovement = data.bowl_movement;
    abdominal_distention = data.distention;

    if (data.sound == 0) {
      listOptionTab_bowlSound[0].isSelected = true;
    } else if (data.sound == 1) {
      listOptionTab_bowlSound[1].isSelected = true;
    } else if (data.sound == 2) {
      listOptionTab_bowlSound[2].isSelected = true;
    }

    if (data.vomit == 0) {
      listOptionTab_Vomiting[0].isSelected = true;
    } else if (data.vomit == 1) {
      listOptionTab_Vomiting[1].isSelected = true;
    } else if (data.vomit == 2) {
      listOptionTab_Vomiting[2].isSelected = true;
    }
    setState(() {});
  }

  getNGTubeData() async {
    List<double> ngData =
        await abdomenController.getNGTube(widget.patientDetailsData);

    ngTube.text = ngData[0].toString();
    ngTube2.text = ngData[1].toString();
  }

  get_meaniapdata() async {
    List<String> meanData = await mean_iap_controller.get_avg_MeanIap(
      widget.patientDetailsData,
    );

    lastMean_iap.text = double.parse(meanData[0]).toStringAsFixed(1);
    currentMean_iap.text = double.parse(meanData[1]).toStringAsFixed(1);
  }

  Future<bool> willpopScope() {
    if (widget.activity) {
      Get.to(Step1HospitalizationScreen(
        index: 3,
        patientUserId: widget.patientDetailsData.sId,
      ));
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willpopScope,
        child: Scaffold(
          appBar: BaseAppbar("abdomen".tr,
              null
            //   IconButton(icon: Icon(Icons.refresh), onPressed: (){
            // AbdomenSummaryController controller = AbdomenSummaryController();
            // controller.isConstipation(widget.patientDetailsData);})

          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: InkWell(
                            onTap: () {
                              print("qqqqq${jsonEncode(widget.patientDetailsData.vigilance)}");
                              mean_iap_controller
                                  .get_avg_MeanIap(
                                    widget.patientDetailsData,
                                  )
                                  .then((value) => print(value));
                            },
                            child: Text(
                              "bowel_mov".tr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: dropdown(
                              listOptionDrpDwn_BowelMovements, BowlMovement,
                              (value) {
                            setState(() {

                              debugPrint('value === $value');

                              BowlMovement = value;

                            // int index =  listOptionDrpDwn_BowelMovements.in;
                            //   debugPrint('index === $value');

                              // BowlMovement_key = value;



                            });
                          }, context),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "bowel_sound".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        Row(
                          children: [
                            Container(
                              // color: Colors.red,
                              width: 95.0,
                              child: _radioWidget(listOptionTab_bowlSound[0],
                                  listOptionTab_bowlSound),
                            ),
                            // Spacer(),
                            Container(
                              width: 105.0,
                              child: _radioWidget(listOptionTab_bowlSound[1],
                                  listOptionTab_bowlSound),
                            ),
                            // Spacer(),
                            Expanded(
                              child: Container(
                                // width: 120.0,
                                child: _radioWidget(listOptionTab_bowlSound[2],
                                    listOptionTab_bowlSound),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "vomiting".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        //SizedBox(height: .0,),
                        Row(
                          children: [
                            Container(
                                width: 95.0,
                                child: _radioWidget(listOptionTab_Vomiting[0],
                                    listOptionTab_Vomiting)),
                            // Spacer(),
                            Container(
                                width: 105.0,
                                child: _radioWidget(listOptionTab_Vomiting[1],
                                    listOptionTab_Vomiting)),
                            Expanded(
                              child: Container(
                                  // width: 120.0,
                                  child: _radioWidget(listOptionTab_Vomiting[2],
                                      listOptionTab_Vomiting)),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "abdominal_dist".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: dropdown(listOptionDrpDwn_abdominalDistention,
                              abdominal_distention, (value) {
                            setState(() {
                              abdominal_distention = value;
                            });
                          }, context),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "ng_tube".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        //***********************************************************

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("last_work_day".tr,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: ngTube,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(',')
                                  ],
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {},
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'ml',
                                    border: new OutlineInputBorder(
                                        //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.0) //This is Ignored,
                                        ),
                                    hintStyle: TextStyle(
                                        color: black40_color,
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("mL")
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 10, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("current_work_day".tr,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 100.0,
                                height: 40.0,
                                // child: texfld("ml", ngTube, () {
                                //   print(ngTube);
                                // }),
                                child: TextField(
                                  controller: ngTube2,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(',')
                                  ],
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {},
                                  style: TextStyle(fontSize: 12),
                                  decoration: InputDecoration(
                                    hintText: 'ml',
                                    border: new OutlineInputBorder(
                                        //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.0) //This is Ignored,
                                        ),
                                    hintStyle: TextStyle(
                                        color: black40_color,
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("mL")
                            ],
                          ),
                        ),

                        Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 20),
                            child: CustomButton(
                              text: "access_fluid_bal".tr,
                              myFunc: () async {
                                print('access:-----------------');
                                print('bowel move:--${BowlMovement}');
                                print(
                                    'abdominal_distention:--${abdominal_distention}');

                                var sound = await listOptionTab_bowlSound
                                    .indexWhere((element) =>
                                        element.isSelected == true);
                                print('sound:--${sound}');

                                var vomit = await listOptionTab_Vomiting
                                    .indexWhere((element) =>
                                        element.isSelected == true);

                                print('vomit:--${vomit}');

                                abdomenModelDaata latestSelectedData =
                                    await abdomenModelDaata(
                                        bowl_movement: BowlMovement,
                                        distention: abdominal_distention,
                                        sound: sound,
                                        vomit: vomit);

                                // onPress();
                                // abdomenController.getNGTube(widget.patientDetailsData);
                                Get.to(BalanceFluid(
                                  patientDetailsData: widget.patientDetailsData,
                                  isFromEn: true,
                                )).then((value) {
                                  print('activity $value');
                                  if (value) {
                                    Get.to(BlankScreen(
                                        function: (){
                                          getBackFromAccess(
                                              latestSelectedData);
                                        }
                                    ));
                                  }
                                });
                              },
                            )),

                        //***********************************************************

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 10.0, bottom: 20.0),
                          child: Text(
                            "mean_iap_inter_abdominal_pressure".tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("last_work_day".tr,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: lastMean_iap,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(',')
                                  ],
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {},
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                  decoration: InputDecoration(
                                    hintText: 'mmHg',
                                    border: new OutlineInputBorder(
                                        //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.0) //This is Ignored,
                                        ),
                                    hintStyle: TextStyle(
                                        color: black40_color,
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                // texfld("mmHg", lastMean_iap, () {
                                //   print(lastMean_iap);
                                // }),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "mmHg",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("current_work_day".tr,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Spacer(),
                              Container(
                                width: 100.0,
                                height: 40.0,
                                child: TextField(
                                  controller: currentMean_iap,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(',')
                                  ],
                                  enabled: false,
                                  //focusNode: focus,
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (_value) {},
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                  decoration: InputDecoration(
                                    hintText: 'mmHg',
                                    border: new OutlineInputBorder(
                                        //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 0.0) //This is Ignored,
                                        ),
                                    hintStyle: TextStyle(
                                        color: black40_color,
                                        fontSize: 9.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                // texfld("mmHg", currentMean_iap, () {
                                //   print(currentMean_iap);
                                // }),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "mmHg",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),
                        Container(
                            width: Get.width,
                            margin: const EdgeInsets.only(
                                left: 15.0, right: 15.0, bottom: 20),
                            child: CustomButton(
                              text: "access_mean_iap".tr,
                              myFunc: () {
                                print('access:-----------------');
                                print('bowel move:--${BowlMovement}');
                                print('abdominal_distention:--${abdominal_distention}');

                                var sound = listOptionTab_bowlSound.indexWhere(
                                    (element) => element.isSelected == true);
                                print('sound:--${sound}');

                                var vomit = listOptionTab_Vomiting.indexWhere(
                                    (element) => element.isSelected == true);

                                print('vomit:--${vomit}');

                                abdomenModelDaata latestSelectedData =
                                    abdomenModelDaata(
                                        bowl_movement: BowlMovement,
                                        distention: abdominal_distention,
                                        sound: sound,
                                        vomit: vomit);

                                // onPress();
                                // abdomenController.getNGTube(widget.patientDetailsData);
                                Get.to(Mean_Iap_Screen(
                                  patientDetailsData: widget.patientDetailsData,
                                  isFromEn: true,
                                )).then((value) {
                                  print('activity ${value}');
                                  if (value) {
                                    print("mmmmmmmmmmmmmmmmmmmmmmmm");

                                    Get.to(BlankScreen(
                                      function: () {

                                        getBackFromAccess(latestSelectedData);

                                      },
                                    ));
                                  }
                                });
                                ;
                              },
                            )),
                        //***********************************************************
                      ],
                    ),
                  )
                ],
              )),
              Container(
                  width: Get.width,
                  margin: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 20),
                  child: CustomButton(
                    text: "next".tr,
                    myFunc: () {


                    onPress();
                    },
                  )),
            ],
          ),
        ));
  }

  Widget _radioWidget(staticList e, var optionlist) {
    return Padding(
        padding: const EdgeInsets.only(right: 1, left: 1, top: 15),
        child: GestureDetector(
          onTap: () {
            // setState(() {
            //   for (var a in listOptionTab) {
            //     setState(() {
            //       a.isSelected = false;
            //     });
            //   }
            //   e.isSelected = true;
            // });

            setState(() {
              for (var a in optionlist) {
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;

              selectedIndexTeam = optionlist.indexOf(e);
            });
          },
          child: Container(
            child: Row(
              children: [
                e.isSelected
                    ? Icon(
                        Icons.radio_button_checked,
                        size: 25,
                        color: primary_color,
                      )
                    : Icon(
                        Icons.radio_button_off,
                        size: 25,
                      ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: new Text(
                      '${e.optionText}',
                      style: new TextStyle(fontSize: 14.0),
                    ),
                  ),
                ),
                // SizedBox(
                //   width: 10,
                // ),
              ],
            ),
          ),
        ));
  }

  getBackFromAccess(abdomenModelDaata latestSelectedData) async {
    final PatientSlipController _patientSlipController =
        PatientSlipController();

    bool mode = await _patientSlipController
        .getRoute(widget.patientDetailsData.hospital.first.sId);

    if (mode != null && mode) {
      _patientSlipController
          .getDetails(widget.patientDetailsData.sId, 0)
          .then((val) {
        print("parsing latestSelectedData :: $latestSelectedData");

        Get.to(AbdomenScreen(
          patientDetailsData: _patientSlipController.patientDetailsData[0],
          activity: true,
          latestSelectedData: latestSelectedData,
        ));
      });


    } else {
      _patientSlipController
          .getDetailsOffline(widget.patientDetailsData.sId, 0)
          .then((val) {
        print("parsing latestSelectedData :: $latestSelectedData");

        Get.to(AbdomenScreen(
          patientDetailsData: _patientSlipController.patientDetailsData[0],
          activity: true,
          latestSelectedData: latestSelectedData,
        ));
      });
    }
  }

  onPress() async {
    // print('bowel movement : ${BowlMovement}');
    var sound = listOptionTab_bowlSound
        .indexWhere((element) => element.isSelected == true);
    // print('bowel sounds : ${sound}');
    var vomit = listOptionTab_Vomiting
        .indexWhere((element) => element.isSelected == true);
    // print('vomit: ${vomit}');
    // print('abdominal dist : ${abdominal_distention}');
    // print('NG tube : ${ngTube.text}');
    // print('LAP: ${lap.text}');

    if ((BowlMovement != null && BowlMovement.isNotEmpty) &&
            (sound != null && vomit != null) &&
            (abdominal_distention != null && abdominal_distention.isNotEmpty)
        // &&
        // (ngTube.text.isNotEmpty && lap.text.isNotEmpty)
        ) {

      int indexBowlMovement =  listOptionDrpDwn_BowelMovements.indexWhere((it) => it.optionText == BowlMovement);
      int indexDist =  listOptionDrpDwn_abdominalDistention.indexWhere((it) => it.optionText ==abdominal_distention );


      Map finalData = {
        "bowel_movement": BowlMovement,
        "bowel_movement_index": indexBowlMovement,
        "bowel_sound": sound,
        "vomit": vomit,
        "abdominal_dist": abdominal_distention,
        "abdominal_dist_index": indexDist,
        "ng_tube": ngTube.text,
        "mean_lap": lastMean_iap.text,
        "lastUpdate": '${DateTime.now()}',
      };

      print('final data : ${jsonEncode(finalData)}');

      int point;
      await getPointsAbdomen(BowlMovement, sound, vomit, abdominal_distention,
              ngTube.text, lastMean_iap.text)
          .then((points) {
        point = points;
      });

      Get.to(GI_Disfunction(
        patientDetailsData: widget.patientDetailsData,
        data: finalData,
        points: point,
      ));
    } else {
      ShowMsg('All fields are mandatory.');
    }
  }
}

class staticList {
  String optionText;
  bool isSelected = false;
  staticList({this.optionText, this.isSelected});
}

Widget dropdown(
    List<staticList> listofItems, var vlu, Function func, var context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Container(
      decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black26,
            width: 1,
          )),
      height: 40.0,
      width: MediaQuery.of(context).size.width,
      child:
          //Container(child: Center(child: _value==0?,),),
          Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
              style: TextStyle(color: Colors.black, fontSize: 16.0),
              iconEnabledColor: Colors.black,
              // isExpanded: true,
              iconSize: 30.0,
              dropdownColor: Colors.white,
              hint: Text('select'.tr),
              value: vlu,
              items: listofItems
                  .map(
                    (e) => DropdownMenuItem(
                      child: Text('${e.optionText}'),
                      value: '${e.optionText}',
                    ),
                  )
                  .toList(),
              onChanged: func),
        ),
      ),
    ),
  );
}
