import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/timeago_format.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/Parenteral_Nutrional_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:timeago/timeago.dart' as timeago;

class Parenteral_histoyScreen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  const Parenteral_histoyScreen({Key key, this.patientDetailsData}) : super(key: key);

  @override
  _Enteral_histoyScreenState createState() => _Enteral_histoyScreenState();
}

class _Enteral_histoyScreenState extends State<Parenteral_histoyScreen> {
  ParenteralNutrional_Controller _controller = ParenteralNutrional_Controller();

  @override
  void initState() {
    // TODO: implement initState

    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getParenteral_HistoryData(
          widget.patientDetailsData.sId,
        ).then((value) {
          setState(() {

          });
        });

        print('internet avialable');
      }

    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("${'history'.tr} - ${'parenteral_nutrition'.tr}", null),
      body: Column(children: [
        Expanded(child: ListView.builder(
            shrinkWrap: true,
            itemCount: _controller.historyData.length,
            itemBuilder: (context,index){
              return

                Padding(
                  padding: const EdgeInsets.only(left:15.0,right: 15.0),
                  child: Column(
                    children: [
                      Container(//height: 100.0,
                        width:Get.width,
                        child:

                        _controller.historyData[index]?.multipalmessage[0]?.parenteralData?.tabStatus==true?
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0,),
                            Text( _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.title??"0",style: TextStyle(fontWeight: FontWeight.bold),),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text("${'total_volume'.tr} : "),
                                    Text( _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.totalVol??"0"),Text(' ml,') ,
                                    SizedBox(width: 10,),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${'total_cal'.tr} : "),Text( _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.totalCal??"0"),Text(' kcal'),
                                  ],
                                )
                              ],
                            ),
                            // SizedBox(height: 5.0,),
                            Row(children: [
                              Text("${'current_work_day'.tr} : ") ,Text( _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.currentWork??"0") ,Text(' ml') ,
                            ],),
                            SizedBox(height: 5.0,),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("total_macro_short".tr,style: TextStyle(fontWeight: FontWeight.bold)) ,
                                    Text("${'protein'.tr} : ${ _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.totalMacro?.protein??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("${'lipids'.tr} : ${ _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.totalMacro?.liquid??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("${'glucose_'.tr} : ${ _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.totalMacro?.glucose??"0"} g"),
                                  ],
                                ),
                                SizedBox(width: 30.0,),
                                _controller.historyData[index].multipalmessage[0].parenteralData.readyToUse.relativeMacro.liquid.isEmpty?SizedBox():
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${'ralative_macro_short'.tr}",style: TextStyle(fontWeight: FontWeight.bold)) ,
                                    Text("${'lipids'.tr} : ${ _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.relativeMacro?.liquid??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("${'glucose_'.tr} : ${ _controller.historyData[index].multipalmessage[0].parenteralData?.readyToUse?.relativeMacro?.glucose??"0"} g"),
                                  ],
                                ),
                              ],
                            )
                          ],)

                            :Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0,),
                            Text("Manipulated",style: TextStyle(fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Text("Total vol : "),Text(_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.totalVol??"0"),Text(' ml,') ,
                                SizedBox(width: 10,),
                                Text("Total cal : "),Text(_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.totalCal??"0"),Text(' kcal')
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(children: [
                              Text("Current work day : ") ,Text(_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.currentWork??"0") ,Text(' ml') ,
                            ],),
                            SizedBox(height: 5.0,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Total Mcro",style: TextStyle(fontWeight: FontWeight.bold)) ,
                                    Text("Protien : ${_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.totalMacro?.protein??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("Lipids : ${_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.totalMacro?.liquid??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("Glucose : ${_controller.historyData[index].multipalmessage[0].parenteralData?.manipulated?.totalMacro?.glucose??"0"} g"),
                                  ],
                                ),
                                SizedBox(width: 30.0,),
                                _controller.historyData[index].multipalmessage[0]?.parenteralData?.manipulated?.relativeMacro?.liquid.isEmpty?SizedBox():
                                Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Relative Macro",style: TextStyle(fontWeight: FontWeight.bold)) ,
                                    Text("Lipids : ${_controller.historyData[index]?.multipalmessage[0]?.parenteralData?.manipulated?.relativeMacro?.liquid??"0"} g"),
                                    SizedBox(width: 5.0,),
                                    Text("Glucose : ${_controller.historyData[index]?.multipalmessage[0]?.parenteralData?.manipulated?.relativeMacro?.glucose??"0"} g"),
                                  ],
                                ),
                              ],
                            )

                          ],
                        )


                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(),


                          Text(
                                // '${timeago.format(DateTime.parse(_controller.historyData[index].updatedAt))}',
                                
                          getTimeAgo(_controller.historyData[index].updatedAt)
                          ,style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: black40_color),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Divider(height: 2,color: Colors.black12,thickness: 2,)
                    ],
                  ),
                );

            }))
      ],),
    );
  }
}
