import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/contollers/accessibilty_feature/accessibility.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/Circulation/circulation.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/fluidBalance.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/abdomen/abdomen.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/clinicalData/otherClinicalData.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/pressureUlcer/pressureUlcer.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/temp&Glycemia/tempGlycemia.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/title.dart';
import 'package:page_indicator/page_indicator.dart';


class VIGILANCE extends StatefulWidget {
  final List<PatientDetailsData> patientDetailsData;
  final int index;
  VIGILANCE({this.patientDetailsData, this.index});

  @override
  _VIGILANCEState createState() => _VIGILANCEState();
}


bool _isloading = false;

class _VIGILANCEState extends State<VIGILANCE> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      // Do something


      SaveDataSqflite sqflite = SaveDataSqflite();

      sqflite.getLastBadge(widget.patientDetailsData[0].sId).then((res){
        selectedIndex = res?.statusIndex??0;
        print('getting index ${res?.vigiIndex??0}');



        _controller.jumpToPage(res?.vigiIndex??0);
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
                  // RaisedButton(onPressed: (){
                  //
                  //   print('on tap');
                  //
                  //   getFluidBalanceData(widget.patientDetailsData[0]);
                  //
                  // }),
                  VigiTitle(patientDetails: widget.patientDetailsData[0],),
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
                print(index);
                widget.patientDetailsData[0].statusIndex = index;



                SaveDataSqflite sqflite = SaveDataSqflite();
                sqflite.saveLastBadge(widget.patientDetailsData[0].sId, 3,index);
                setState(() {});

              },
              reverse: false,
              children: [
                FluidBalance(patientDetailsData: patientDetailsData,access: access.status,),
                abDomen(patientDetailsData: patientDetailsData,access: access.status,),
                circulation(patientDetailsData: patientDetailsData,access: access.status,),
                tempGlycemia(patientDetailsData: patientDetailsData,access: access.status,),
                pressureUlcer(patientDetailsData: patientDetailsData,access: access.status,),
                OtherCinicalData(patientDetailsData: patientDetailsData,access: access.status,),
              ],
            ),
            align: IndicatorAlign.bottom,
            length: 6,
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
