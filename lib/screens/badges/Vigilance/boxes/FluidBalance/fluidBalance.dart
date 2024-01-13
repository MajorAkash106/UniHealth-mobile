import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/vigilanceFunc.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet.dart';
import 'package:medical_app/screens/badges/Vigilance/boxes/FluidBalance/balance_sheet_history.dart';


class FluidBalance extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  final bool access;
  FluidBalance({this.patientDetailsData,this.access});
  @override
  _FluidBalanceState createState() => _FluidBalanceState();
}

class _FluidBalanceState extends State<FluidBalance> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: Get.width,
          height: 200,
          child: FutureBuilder(
              future: getFluidBalanceData(widget.patientDetailsData),
              initialData: [0,0,0],
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //      0 index = last work day
                //      1 index = current work day
                //      2 index = balance since

                print('return data : ${snapshot.data}');
                List<int> data = snapshot.data;

                return InkWell(
                  onTap: ()async{
                    // if(widget.access) {
                      // Get.to(ons_acceptance(
                      //     patientDetailsData: widget.patientDetailsData,
                      //     ntdata: data));
                    // }

                    // getWorkingDays(widget.patientDetailsData.hospital[0].sId);
                    // getFluidBalanceData(widget.patientDetailsData);

                    Get.to(BalanceFluid(patientDetailsData: widget.patientDetailsData,isFromEn: false,));
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
                                        'fluid_balance'.tr,
                                        style: TextStyle(
                                          color: card_color,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(BalanceSheetHistory(patientDetailsData: widget.patientDetailsData,HistorName: 'history'.tr));
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
                                height: 10,
                              ),
                              data.isNullOrBlank?SizedBox():  Padding(
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
                                          '${'current_work_day'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${data[1].isNegative?'':"+"}${data[1]} mL',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${'last_work_day'.tr}:',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          '${data[0].isNegative?'':"+"}${data[0]} mL',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [


                                        FutureBuilder(
                                          future: getFluidBalanace(widget.patientDetailsData),
                                          initialData: null,
                                          builder: (context, snapshot) {
                                            String balanceSince;
                                            Vigilance data = snapshot.data;
                                            if(data?.result!=null)
                                            {
                                               balanceSince = data?.result[0]?.balanceSince;
                                            }
                                            else{
                                               balanceSince=null;
                                            }

                                            var  months = ["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"];


                                           return Text(
                                              '${'balance_since'.tr} ${balanceSince.isNullOrBlank?'${DateTime.now().day} ${months[DateTime.now().month-1]}'
                                                  :"${DateTime.parse(balanceSince).day} "+months[DateTime.parse(balanceSince).month-1]}:',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.normal,
                                                  fontSize: 16.0),
                                            );
                                          },
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          '${data[2].isNegative?'':"+"}${data[2]} mL',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0),
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
                                  future: getBalanceLastUpdatedDate(widget.patientDetailsData),
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
