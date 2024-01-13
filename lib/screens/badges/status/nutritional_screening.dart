import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/status_controller/nutrintionalScreeningController.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/status/MNA.dart';
import 'package:medical_app/screens/badges/status/NRS_third_2002.dart';



class NutrintionalScreening extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final List<StatusData> type1;
  NutrintionalScreening({this.patientDetailsData, this.type1});
  @override
  _NutrintionalScreeningState createState() => _NutrintionalScreeningState();
}

class _NutrintionalScreeningState extends State<NutrintionalScreening> {
  final NutritionalScreenController _controller = NutritionalScreenController();

  int patientAge;

  @override
  void initState() {
    // TODO: implement initState
    print('type1 len : ${widget.type1.length}');

    getAgeYearsFromDate(widget.patientDetailsData.dob).then((value) {
      print('return age: $value');

      setState(() {
        patientAge = value;
      });
    });
    // _controller.getData('0');
    _controller.getData(JsonFilePath.nutritionalBox);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('nutritional_screening'.tr, null),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                      children: _controller.listData.map((e) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        _cardwidget("${e.statusname}", 'path', () {
                          print(e.statusname);

                          if (e.statusname.toLowerCase().removeAllWhitespace == "STRONG - KIDS".toLowerCase().removeAllWhitespace) {

                            if (patientAge < 19
                                // && patientAge >= 1
                            ) {
                              List<NRSListData> NRSSelected = [];

                              NRSSelected.clear();

                              for (var a = 0; a < widget.type1.length; a++) {
                                print(widget.type1[a].status);

                                if (widget.type1[a].status == e.statusname) {
                                  NRSSelected.addAll(
                                      widget.type1[a].result[0].data);
                                }
                              }

                              // Get.to(NRSFirstScreen(
                              //   patientDetailsData: widget.patientDetailsData,
                              //   id: e.sId,
                              //   title: e.statusname,
                              //   selectedData: NRSSelected,
                              // ));
                              print('_id : ${e.sId}');

                              Get.to(MNAScreen(
                                patientDetailsData: widget.patientDetailsData,
                                // id: e.sId,
                                id: JsonFilePath.strongKidsData,
                                title: e.statusname, selectedLastTime: NRSSelected,HistoryKey: ConstConfig.STRONGKIDHistory,
                              ));


                            } else {
                              print('patientAge: 1 to 19');
                              print('patientAge:$patientAge');
                              print('status name:${e.statusname}');
                              // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            }
                          } else if (e.statusname == "NRS - 2002") {
                            if (patientAge >= 19) {
                              List<NRSListData> NRSSelected = [];

                              NRSSelected.clear();

                              for (var a = 0; a < widget.type1.length; a++) {
                                print(widget.type1[a].status);

                                if (widget.type1[a].status == e.statusname) {
                                  NRSSelected.addAll(
                                      widget.type1[a].result[0].data);
                                }
                              }

                              // Get.to(NRSFirstScreen(
                              //   patientDetailsData: widget.patientDetailsData,
                              //   id: e.sId,
                              //   title: e.statusname,
                              //   selectedData: NRSSelected,
                              // ));

                              Get.to(NRSThirdScreen(
                                patientDetailsData: widget.patientDetailsData,
                                // id: e.sId,
                                id: JsonFilePath.nrsData,
                                title: e.statusname,
                                selectedData: NRSSelected,
                              ));

                            } else {
                              // ShowMsg("Sorry! patient's age ${patientAge} yet,");

                            }
                          }else if(e.statusname == "MUST"){
                            if (patientAge >= 19) {



                              List<NRSListData> NRSSelected = [];
                              String MustLastDate = '';

                              NRSSelected.clear();

                              for (var a = 0; a < widget.type1.length; a++) {
                                print(widget.type1[a].status);

                                if (widget.type1[a].status == e.statusname) {
                                  NRSSelected.addAll(
                                      widget.type1[a].result[0].data);
                                  MustLastDate = widget.type1[a].result[0].lastUpdate;

                                }
                              }


                             print('days diffrence: ${ DateTime.parse('2021-06-14 14:21:23.503219').compareTo(DateTime.now()).isNegative}');

                              print('_id: ${e.sId}');

                              Get.to(MNAScreen(
                                patientDetailsData: widget.patientDetailsData,
                                // id: e.sId,
                                id: JsonFilePath.mustData,
                                title: e.statusname, selectedLastTime: NRSSelected,HistoryKey: ConstConfig.MUSTHistory,
                              ));
                            } else {
                              // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            }
                          }else if(e.statusname == "NUTRIC - SCORE"){
                            if (patientAge >= 19) {



                              List<NRSListData> NRSSelected = [];
                              String MustLastDate = '';

                              NRSSelected.clear();

                              for (var a = 0; a < widget.type1.length; a++) {
                                print(widget.type1[a].status);

                                if (widget.type1[a].status == e.statusname) {
                                  NRSSelected.addAll(
                                      widget.type1[a].result[0].data);
                                  MustLastDate = widget.type1[a].result[0].lastUpdate;

                                }
                              }


                              print('days diffrence: ${ DateTime.parse('2021-06-14 14:21:23.503219').compareTo(DateTime.now()).isNegative}');

                              print('_id: ${e.sId}');

                              Get.to(MNAScreen(
                                patientDetailsData: widget.patientDetailsData,
                                // id: e.sId,
                                id: JsonFilePath.nutricScore,
                                title: e.statusname, selectedLastTime: NRSSelected,
                                HistoryKey: ConstConfig.NutricHistory,
                              ));
                            } else {
                              // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            }
                          }


                          else {
                            if (patientAge >= 19) {



                              List<NRSListData> NRSSelected = [];

                              NRSSelected.clear();

                              for (var a = 0; a < widget.type1.length; a++) {
                                print(widget.type1[a].status);

                                if (widget.type1[a].status == e.statusname) {
                                  NRSSelected.addAll(
                                      widget.type1[a].result[0].data);
                                }
                              }


                                Get.to(MNAScreen(
                                  patientDetailsData: widget.patientDetailsData,
                                  // id: e.sId,
                                  id: JsonFilePath.mnaData,
                                  title: e.statusname, selectedLastTime: NRSSelected,HistoryKey: ConstConfig.MNAHistory,
                                ));
                            } else {
                              // ShowMsg("Sorry! patient's age ${patientAge} yet,");
                            }
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

                ],
              ),
            ),
          ),
        ));
  }

  Widget _cardwidget(String text, String path, Function _function) {
    return InkWell(
      onTap: _function,
      child: Card(
          color: patientAge >= 19 ?

          text =="STRONG - KIDS"? Colors.black12 :
          primary_color :

         text =="STRONG - KIDS" && patientAge < 19
             // && patientAge >= 1
             ?primary_color:
          Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            // side: BorderSide(width: 5, color: Colors.green)
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
                child: Text(
              "$text",
              style: TextStyle(
                  color: card_color,
                  fontSize: 20,
                  fontWeight: FontWeight.normal),
            )),
          )),
    );
  }
}
