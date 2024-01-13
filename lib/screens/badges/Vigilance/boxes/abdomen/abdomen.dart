import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/contollers/vigilance/abdomenController.dart';
import 'package:medical_app/contollers/vigilance/mean_iap_controller.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/abdomen/abdomenScreen.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/abdomen/adbomen_history.dart';

import '../../../../../config/widgets/autoSizableText.dart';


class abDomen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  abDomen({this.patientDetailsData,this.access});
  @override
  _abDomenState createState() => _abDomenState();
}

class _abDomenState extends State<abDomen> {

  final AbdomenController _controller = AbdomenController();
  Mean_Iap_Controller _mean_iap_controller = Mean_Iap_Controller();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 220,

          child: FutureBuilder(
              future: _controller.getAbdomenData(widget.patientDetailsData),
              initialData: null,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                Vigilance data = snapshot.data;
                AbdomenData abdomen =  data?.result?.first?.abdomenData;


                return InkWell(
                  onTap: ()async{
                    Get.to(AbdomenScreen(patientDetailsData: widget.patientDetailsData,activity: false,));
                  },
                  child:  Card(
                    // color:widget.access? card_color : disable_color,
                      color: card_color ,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          side: BorderSide(width: 1, color: primary_color)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: primary_color,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, bottom: 8.0, left: 16.0),
                                      child: Text(
                                        'abdomen'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(AbdomenHistoryScreen(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr));
                                      },
                                      child: Container(
                                        //margin: EdgeInsets.only(right: 8.0,),
                                        //color: Colors.red,
                                        width: 60,
                                        height: 30.0,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.historyClockIcon,
                                              color: card_color,
                                              height: 20,
                                            ),
                                            SizedBox(
                                              width: 16.0,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),


                              data.isNullOrBlank?SizedBox():
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [


                                    Row(
                                      children: [
                                        Text(
                                          '${'bowel_sound'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      Flexible(child:   Text(
                                        '${abdomen.bowelSound==0?'absent'.tr:abdomen.bowelSound==1?'present'.tr:'evaluation_not_possible'.tr}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13.0),
                                        maxLines: 2,
                                      )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          '${'bowel_mov_short'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(child:   Text(
                                          '${abdomen.bowelMovement??''}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                          maxLines: 2,
                                        )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          '${'vomiting'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${abdomen.vomit==0?'absent'.tr:abdomen.vomit==1?'present'.tr:'evaluation_not_possible'.tr}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),

                                    SizedBox(
                                      height: 2,
                                    ),

                                    Row(
                                      children: [
                                        Text(
                                          '${'abd_dist'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 14.0),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${abdomen.abdominalDist??''}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    data==null?SizedBox():  Row(
                                      children: [
                                        FutureBuilder(
                                            future: _mean_iap_controller.get_avg_MeanIap(widget.patientDetailsData),
                                            initialData: null,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              var meandata =snapshot.data;
                                              print(meandata.toString());

                                              return
                                                meandata==null?SizedBox():
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'mean_iap'.tr}(mmHg):',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontSize: 14.0),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${double.parse(meandata[0]).toString()??''}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0),
                                                    ),
                                                    Text(
                                                      " (${'last_work_day'.tr}) ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8.0),
                                                    ),

                                                    Text(
                                                      '${'/'+double.parse(meandata[1]).toString()??''}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0),
                                                    ),
                                                    Text(
                                                      " (${'current_work_day'.tr})",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8.0),
                                                    ),


                                                  ],
                                                );
                                            }
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    data==null?SizedBox():   Row(
                                      children: [
                                        FutureBuilder(
                                            future: _controller.getNGTube(widget.patientDetailsData),
                                            initialData: null,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              var ngTubedata = snapshot.data;
                                              print(ngTubedata.toString());

                                              return
                                                ngTubedata==null?SizedBox():
                                                Row(
                                                  children: [
                                                    Text(
                                                      '${'ng_tube'.tr}(mL):',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontSize: 14.0),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '${ngTubedata[0].toString()??''}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0),
                                                    ),
                                                    Text(
                                                      " (${'last_work_day'.tr}) ",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8.0),
                                                    ),

                                                    Text(
                                                      '${'/'+ngTubedata[1].toString()??''}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13.0),
                                                    ),
                                                    Text(
                                                      " (${'current_work_day'.tr})",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8.0),
                                                    ),


                                                  ],
                                                );
                                            }
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    data==null?SizedBox():
                                    Row(
                                      children: [
                                        FutureBuilder(
                                            future: _controller.GIF_result(widget.patientDetailsData),
                                            initialData: null,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              Gif_Data gif_data =snapshot.data;
                                              print('gif_data :: $gif_data');


                                              return
                                                gif_data==null?SizedBox():
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${'gif_score'.tr}',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.normal,
                                                          fontSize: 14.0),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          '${gif_data.gif_score==null?gif_data.gif_score:gif_data.gif_score} ',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 13.0),
                                                        ),
                                                        Text(
                                                          '(${gif_data.gif_result==null?"":gif_data.gif_result})',
                                                          style: TextStyle(
                                                              color: Colors.black,
                                                              fontSize: 12.0),
                                                        ),
                                                      ],
                                                    ),



                                                  ],
                                                );
                                            }
                                        ),
                                      ],
                                    ),



                                  ],
                                ),
                              ),

                            ],
                          ),
                          data==null?SizedBox():  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "",
                                style: TextStyle(fontSize: 15),
                              ),
                              FutureBuilder(
                                  future: getDateFormatFromString(
                                      data?.result.first.lastUpdate),
                                  initialData: "Loading text..",
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshota) {
                                    return snapshota.data == null
                                        ? SizedBox()
                                        : Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10, bottom: 8),
                                      child: Text(
                                        "${'last_update'.tr} - "
                                            '${snapshota.data}',
                                        style: TextStyle(
                                            color: primary_color,
                                            fontSize: 10),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ],
                      )),);
              }),
        ),
        // SizedBox(height: 20,)
      ],
    );
  }
}
