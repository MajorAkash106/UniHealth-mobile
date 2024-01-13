import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/ESPEN.dart';
import 'package:medical_app/screens/badges/status/GLIM.dart';
import 'package:medical_app/screens/badges/status/WHO.dart';

class NutrintionalDiagnosis extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final List<StatusData> type1;
  NutrintionalDiagnosis({this.patientDetailsData, this.type1});
  @override
  _NutrintionalDiagnosisState createState() => _NutrintionalDiagnosisState();
}

class _NutrintionalDiagnosisState extends State<NutrintionalDiagnosis> {
  final NutritionalScreenController _controller = NutritionalScreenController();

  int patientAge;

  @override
  void initState() {
    // TODO: implement initState
    // print('type1 len : ${widget.type1.length}');

    getAgeYearsFromDate(widget.patientDetailsData.dob).then((value) {
      print('return age: $value');

      setState(() {
        patientAge = value;
      });
    });

    // _controller.getData('2');
    _controller.getData(JsonFilePath.nutritionalDiagnosisBox);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('nutritional_diagnosis'.tr, null),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: ListView(
                  children: _controller.listData.map((e) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    _cardwidget("${e.statusname}", 'path', () {
                      print(e.statusname);

                      if (e.sId == AppString.espen) {
                        getAgeYearsFromDate(widget.patientDetailsData.dob)
                            .then((age) {
                          print('patients age: $age');
                          if (age >= 19) {
                            Get.to(ESPENScreen(
                              patientDetailsData: widget.patientDetailsData,
                            ));

                            // Get.to(Anthropometery(patientDetailsData: widget.patientDetailsData,isFromAnthroTab: true,));
                          } else {
                            print('go to espen');
                            ShowMsg('sorry_patient_age_is_less_than_19_years'.tr);
                          }
                        });
                      } else if (e.sId == AppString.who) {
                        print(widget.patientDetailsData.dob);
                        getAgeYearsFromDate(widget.patientDetailsData.dob)
                            .then((age) {
                          print('patients age: $age');
                          if (age >= 19) {
                            ShowMsg('sorry_patient_age_is_more_than_19_years'.tr);
                            // Get.to(Anthropometery(patientDetailsData: widget.patientDetailsData,isFromAnthroTab: true,));
                          } else {
                            print('go to who');
                            Get.to(WHOScreen(
                              patientDetailsData: widget.patientDetailsData,
                            ));
                          }
                        });
                      } else if (e.sId == AppString.glim) {

                        getAgeYearsFromDate(widget.patientDetailsData.dob)
                            .then((age) {
                          print('patients age: $age');
                          if (age >= 19) {
                            Get.to(GLIMScreen(
                              patientDetailsData: widget.patientDetailsData,
                            ));

                            // Get.to(Anthropometery(patientDetailsData: widget.patientDetailsData,isFromAnthroTab: true,));
                          } else {
                            print('go to who');
                            ShowMsg('sorry_patient_age_is_less_than_19_years'.tr);
                          }
                        });



                      } else {
                        Get.to(FreeTextScreen(
                          text: "${e.statusname}",
                          function: () {
                            Get.back();
                          },
                        ));
                      }
                    }),
                  ],
                );
              }).toList()
                  //  SizedBox(height: 20,),
                  // _cardwidget("NRS - 2002", 'path', (){Get.to(NRSFirstScreen());}),
                  //  SizedBox(height: 20,),
                  //  _cardwidget("MNA - NNI", 'path', (){
                  //    Get.to(MNAScreen());
                  //  }),
                  //  SizedBox(height: 20,),
                  // _cardwidget("MUST", 'path', (){
                  //   Get.to(MustScreen());
                  // }),
                  //  SizedBox(height: 20,),
                  // _cardwidget("STRONG - KIDS", 'path', (){Get.to(SKDFirst());}),

                  ),
            ),
          ),
        ));
  }

  Widget _cardwidget(String text, String path, Function _function) {
    return InkWell(
      onTap: _function,
      child: Card(
          color: patientAge >= 19
              ? text.contains("who".tr)
                  ? Colors.black12
                  : primary_color
              : text.contains("who".tr) && patientAge < 19 && patientAge >= 0
                  ? primary_color
                  : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // side: BorderSide(width: 5, color: Colors.green)
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
                  text == "WHO"?    "$text/CDC" : "$text",
              style: TextStyle(
                  color: card_color,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            )),
          )),
    );
  }
}
