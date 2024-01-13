import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/status_controller/aspectDeficienciesController.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/contollers/patient&hospital_controller/save_history_controller.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/clinical_menifestaion_screen.dart';


class AdpectsDeficiencies extends StatefulWidget {
  final String foodAllergies;
  final String foodPereference;final List<Options> list;
  final List<PatientDetailsData> patientDetailsData;
  AdpectsDeficiencies({this.patientDetailsData,this.foodAllergies,this.foodPereference,this.list});
  @override
  _AdpectsDeficienciesState createState() => _AdpectsDeficienciesState();
}

class _AdpectsDeficienciesState extends State<AdpectsDeficiencies> {
  final NutritionalScreenController _controller = NutritionalScreenController();
  final AspectDeficienciesController _aspectDeficienciesController =
      AspectDeficienciesController();

  final HistoryController _historyController = HistoryController();

  @override
  void initState() {
    // TODO: implement initState
    // _controller.getData('1');
    _controller.getData(JsonFilePath.aspectDefBox);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('aspects_deficiencies'.tr, null),
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
                    // if (e.statusname == "CLINICAL MANIFESTATION OF NUTRIENT DEFECIENCIES") {
                    if (e.sId == AppString.clinical_manifestation) {
                      print('_id: ${e.sId}');

                      Get.to(ClinicalManifest(
                        // id: e.sId,
                        id: JsonFilePath.clinicalData,
                        HistoryKey: ConstConfig.clinicalManifestationHistory,
                        patientDetailsData: widget.patientDetailsData[0],
                        title: e.statusname, selectedLastTime: [],list: widget.list,));
                    // } else if (e.statusname == "FOOD PREFERENCES") {
                    } else if (e.sId == AppString.food_preferences) {
                      // Get.to(Clinical_menifestation(patientDetailsData: widget.patientDetailsData,));

                      var foodPreference = TextEditingController();

                      Get.to(FreeTextScreen(
                        text: "${e.statusname}",
                        controller: foodPreference,
                        fillValue: widget.foodPereference??'',
                        function: () {
                          print(foodPreference.text);

                          // Get.back();
                          Map data = {
                            'status': aspectDeficiencies.foodPreference,
                            'score': '0',
                            'lastUpdate': '${DateTime.now()}',
                            'dataText': foodPreference.text
                          };

                          List a = [];
                          a.add(data);

                          print('List a: $a');

                          checkConnectivityWithToggle(widget.patientDetailsData[0].hospital[0].sId).then((internet){
                            if(internet!=null && internet){

                              _aspectDeficienciesController.saveData(
                                  widget.patientDetailsData[0],
                                  0,
                                  aspectDeficiencies.foodPreference,
                                  data).then((value){
                                _historyController.saveHistory(widget.patientDetailsData[0].sId, ConstConfig.aspectFoodPreferenceHistory, foodPreference.text);
                              });

                            }else{
                              _aspectDeficienciesController.saveDataOffline(widget.patientDetailsData[0], [], 0, data, aspectDeficiencies.foodPreference);
                            }
                          });




                        },
                      ));
                    } else {
                      var foodAllergies = TextEditingController();

                      Get.to(FreeTextScreen(
                        text: "${e.statusname}",
                        controller: foodAllergies,
                        fillValue: widget.foodAllergies??'',
                        function: () {
                          // Get.back();
                          Map data = {
                            'status': aspectDeficiencies.foodAllergies,
                            'score': '0',
                            'lastUpdate': '${DateTime.now()}',
                            'dataText': foodAllergies.text
                          };

                          List a = [];
                          a.add(data);

                          print('List a: $a');

                          checkConnectivityWithToggle(widget.patientDetailsData[0].hospital[0].sId).then((internet){

                            if(internet!=null && internet){

                              _aspectDeficienciesController.saveData(
                                  widget.patientDetailsData[0],
                                  0,
                                  aspectDeficiencies.foodAllergies,
                                  data).then((value){
                                _historyController.saveHistory(widget.patientDetailsData[0].sId, ConstConfig.aspectAllergieseHistory, foodAllergies.text);
                              });


                            }else{
                              _aspectDeficienciesController.saveDataOffline(widget.patientDetailsData[0], [], 0, data, aspectDeficiencies.foodAllergies);
                            }

                          });




                        },
                      ));
                    }

                    // Get.to(NRSFirstScreen(patientDetailsData: widget.patientDetailsData,id: e.sId,));
                    // Get.to(NRS_ForthScreen());
                    // Get.to(MNAScreen());
                    // Get.to(MustScreen());
                    // Get.to(SKDFirst());
                  }),
                ],
              );
            }).toList()),
          ),
        ),
      ),
    );
  }

  Widget _cardwidget(String text, String path, Function _function) {
    return InkWell(
      onTap: _function,
      child: Column(
        children: [
          Card(
              color: primary_color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                // side: BorderSide(width: 5, color: Colors.green)
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(
                    child: Text(
                  "$text",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: card_color,
                      fontSize: 20,
                      fontWeight: FontWeight.normal),
                )),
              )),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text(
          //         "Last update - 02/02/2020",
          //         style: TextStyle(color: black40_color, fontSize: 13),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }




}
