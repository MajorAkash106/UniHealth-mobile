import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/freetextscreen.dart';
import 'package:medical_app/contollers/status_controller/aspectDeficienciesController.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/clinical_menifestaion_screen.dart';
import 'package:medical_app/screens/badges/status/AspectclinicalHistory.dart';
import 'package:medical_app/screens/badges/diagnosis/diagnosis_history.dart';

import '../../../config/cons/string_keys.dart';


class AspectsDeficienciesHistory extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  AspectsDeficienciesHistory({this.patientDetailsData});
  @override
  _AspectsDeficienciesHistoryState createState() => _AspectsDeficienciesHistoryState();
}

class _AspectsDeficienciesHistoryState extends State<AspectsDeficienciesHistory> {
  final NutritionalScreenController _controller = NutritionalScreenController();
  final AspectDeficienciesController _aspectDeficienciesController =
  AspectDeficienciesController();

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
      appBar: BaseAppbar('history'.tr + ' - ${"aspect_def".tr}', null),
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

                          // Get.to(NRSHistoryScreen(patientDetailsData: widget.patientDetailsData[0],HistorName: e.statusname+ "History",historyKey: ConstConfig.clinicalManifestationHistory,));
                          Get.to(AspectClinicalHistory(patientDetailsData: widget.patientDetailsData[0],HistorName: "history".tr +' - ' +e.statusname,historyKey: ConstConfig.clinicalManifestationHistory,));

                        // } else if (e.statusname == "FOOD PREFERENCES") {
                        } else if (e.sId == AppString.food_preferences) {
                          // Get.to(Clinical_menifestation(patientDetailsData: widget.patientDetailsData,));
                          Get.to(DiagnosisHistory(type: ConstConfig.aspectFoodPreferenceHistory,HistorName: "history".tr +' - ' +e.statusname,patientDetailsData: widget.patientDetailsData[0],));

                        } else {
                          Get.to(DiagnosisHistory(type: ConstConfig.aspectAllergieseHistory,HistorName: "history".tr +' - ' +e.statusname,patientDetailsData: widget.patientDetailsData[0],));
                        }

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
      child: Card(
          color: primary_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // side: BorderSide(width: 5, color: Colors.green)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:ListTile(title: Text(
              "$text",
              style: TextStyle(
                  color: card_color,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            ),trailing: Icon(Icons.arrow_forward,color: Colors.white,),),
          )),
    );
  }
}
