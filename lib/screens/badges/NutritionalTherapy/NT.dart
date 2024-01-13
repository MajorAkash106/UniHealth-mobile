import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/needs_achievements_box.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/other_recommendation/recommendation.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/boxes/parenteralNutrition/parenteralNutritionBox.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/enteralNutritionBox.dart';

import 'package:page_indicator/page_indicator.dart';
import 'boxes/condition_box.dart';
import 'boxes/fasting_box.dart';
import 'boxes/ons_box.dart';
import 'boxes/oral_acceptance_box.dart';

class NT_TAB extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  final int index;
  final double sum;
  NT_TAB({this.patientDetailsData, this.index,this.sum});

  @override
  _NT_TABState createState() => _NT_TABState();
}


bool _isloading = false;

class _NT_TABState extends State<NT_TAB> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      // Do something


      SaveDataSqflite sqflite = SaveDataSqflite();

      sqflite.getLastBadge(widget.patientDetailsData[0].sId).then((res){
        selectedIndex = res?.statusIndex??0;
        print('getting index ${res?.ntIndex}');



        _controller.jumpToPage(res?.ntIndex??0);
        setState(() {});
      });

    });



}

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity:
          1, // You can reduce this when loading to give different effect
          child: AbsorbPointer(
              absorbing: _isloading,
              child: Column(
                children: [
                NeedsAchievements(patientDetailsData: widget.patientDetailsData[0],),
                  SizedBox(
                    height: 10,
                  ),
                  Container(height: 230, child: _slider(widget.patientDetailsData[0]))
                  // _isloading? Center(
                  //     child: CircularProgressIndicator()):Container(height: 220, child: _slider())
                ],
              )),
        ),
        Opacity(
          opacity: _isloading ? 1.0 : 0,
          child: Container(
            height: 200,
            child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                )),
          ),
        ),
      ],
    );
  }




  int selectedIndex = 0;
final _controller = PageController(initialPage: 0);
Accessibility accessibility = Accessibility();
  Widget _slider(PatientDetailsData patientDetailsData) {

    return FutureBuilder(
        future: accessibility
            .getAccess(widget.patientDetailsData[0].hospital[0].sId),
        initialData: null,
        builder: (context, snapshot) {
          AccessFeature access = snapshot?.data;
          return access == null
              ? SizedBox()
              : PageIndicatorContainer(
            child: PageView(
              controller: _controller,
              // pageSnapping: false,
              allowImplicitScrolling: false,
              onPageChanged: (int index) {
                print('slide index $index');
                // widget.patientDetailsData[0].statusIndex = index;



                print('patients Id : ${patientDetailsData.sId}');
                SaveDataSqflite sqflite = SaveDataSqflite();
                sqflite.saveLastBadge(patientDetailsData.sId, 4,index);
                setState(() {});

              },
              reverse: false,
              children: [
                ConditionBox(patientDetailsData: patientDetailsData,access: access.nt,),
                FastingBox(patientDetailsData: patientDetailsData,access: access.nt,),
                OnsAcceptanceBox(patientDetailsData: patientDetailsData,access: access.ntFoodAccept,),
                OralAcceptanceBox(patientDetailsData: patientDetailsData,access: access.ntFoodAccept,),
                EnteralNutritionBox(patientDetailsData: patientDetailsData,access: true,),
                ParenteralNutritionBox(patientDetailsData: patientDetailsData,access: true,),
                Recommendation(patientDetailsData: patientDetailsData,access: true,),
              ],
            ),
            align: IndicatorAlign.bottom,
            length: 7,
            indicatorSpace: 10.0,
            padding: const EdgeInsets.only(top: 0),
            indicatorColor: black40_color,
            indicatorSelectorColor: primary_color,
            shape: IndicatorShape.roundRectangleShape(size: const Size(40, 5)),
          );
        });

  }


  updatedDate(List<DateTime> list) {
    list.sort((b, a) => a.compareTo(b));
    return '${list[0]}';
  }




}
