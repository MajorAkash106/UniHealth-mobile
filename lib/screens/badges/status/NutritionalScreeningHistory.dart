import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/NRSHistoryScreen.dart';



class NutrintionalScreeningHistory extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  NutrintionalScreeningHistory({this.patientDetailsData});
  @override
  _NutrintionalScreeningHistoryState createState() => _NutrintionalScreeningHistoryState();
}

class _NutrintionalScreeningHistoryState extends State<NutrintionalScreeningHistory> {
  final NutritionalScreenController _controller = NutritionalScreenController();

  int patientAge;

  @override
  void initState() {
    // TODO: implement initState

    // _controller.getData('0');
    _controller.getData(JsonFilePath.nutritionalBox);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('history'.tr, null),
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

                          if (e.statusname == "STRONG - KIDS") {
                            // if (patientAge < 19 && patientAge > 1) {
                            //   Get.to(NRSFirstScreen(
                            //     patientDetailsData: widget.patientDetailsData,
                            //     id: e.sId,
                            //     title: e.statusname,
                            //   ));
                            // } else {
                            //   print('patientAge: 1 to 19');
                            //   print('patientAge:$patientAge');
                            //   // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            // }
                            Get.to(NRSHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: "${'${'history'.tr}'} - "+e.statusname,historyKey: ConstConfig.STRONGKIDHistory,));
                          } else if(e.statusname == "NRS - 2002") {
                            // if (patientAge >= 19) {
                            // Get.to(NRSFirstScreen(
                            //   patientDetailsData: widget.patientDetailsData,
                            //   id: e.sId,
                            //   title: e.statusname,
                            // ));
                            // } else {
                            //   // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            //
                            // }

                            Get.to(NRSHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName:"${'${'history'.tr}'} - "+e.statusname,historyKey: ConstConfig.NRSHistory,));

                          }else if (e.statusname.trim() == "MNA - NNI".trim()){


                            Get.to(NRSHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: "${'${'history'.tr}'} - "+e.statusname,historyKey: ConstConfig.MNAHistory,));
                            // if (patientAge >= 19) {
                            //   Get.to(MNAScreen(
                            //     patientDetailsData: widget.patientDetailsData,
                            //     id: e.sId,
                            //     title: e.statusname,
                            //   ));
                            // }



                          }else if (e.statusname.trim() == "MUST".trim()){


                            Get.to(NRSHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: "${'${'history'.tr}'} - "+e.statusname,historyKey: ConstConfig.MUSTHistory,));
                            // if (patientAge >= 19) {
                            //   Get.to(MNAScreen(
                            //     patientDetailsData: widget.patientDetailsData,
                            //     id: e.sId,
                            //     title: e.statusname,
                            //   ));
                            // }



                          }

                          // Get.to(NRSFirstScreen(patientDetailsData: widget.patientDetailsData,id: e.sId,title: e.statusname,));
                          // Get.to(NRS_ForthScreen());
                          // Get.to(MNAScreen());
                          // Get.to(MustScreen());
                          // Get.to(SKDFirst());
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
