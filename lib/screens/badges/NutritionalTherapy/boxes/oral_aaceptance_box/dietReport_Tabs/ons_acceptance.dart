import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/NTfunc.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/config/funcs/future_func.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/NutritionalTherapy/ons_acceptance.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../../../../config/Locale/locale_config.dart';
import '../../../ons.dart';
import '../oral_food_Acptnc.dart';

class Ons_Acceptance_Screen extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  Ons_Acceptance_Screen({this.patientDetailsData});

  @override
  _Ons_Acceptance_ScreenState createState() => _Ons_Acceptance_ScreenState();
}

class _Ons_Acceptance_ScreenState extends State<Ons_Acceptance_Screen> {
  List<staticList> listOptionDropdown = <staticList>[];
  List<Percentages> prcnt_list = <Percentages>[
    Percentages('0%', false),
    Percentages('25%', false),
    Percentages('50%', false),
    Percentages('75%', false),
    Percentages('100%', false),
  ];
  int selectedIndex = -1;
  // bool selected = false;
  String _value;
  @override
  void initState() {
    // listOptionDropdown.add(staticList(optionText: 'Justify if <75%', isSelected: false));
    listOptionDropdown.add(staticList(optionText: 'fasting_for_procedure'.tr, isSelected: false));
    listOptionDropdown.add(staticList(optionText: 'fasting_for_surgery'.tr, isSelected: false));
    listOptionDropdown.add(staticList(optionText: 'patient_refuses'.tr, isSelected: false));
    listOptionDropdown.add(staticList(optionText: 'unknown_reason_other'.tr, isSelected: false));

    // TODO: implement initState
    super.initState();
    getData();
  }



  getData(){

    getONS(widget.patientDetailsData).then((res){
      List<Ons> listData = res.result.first.onsData;
      for(var a in listData){

        if(calculateDifference(DateTime.parse(a.lastUpdate))==0){

        }else if(calculateDifference(DateTime.parse(a.lastUpdate))==-1){

        }else{
         setState(() {
           listData.remove(a);
         });
        }

      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('obs_acceptance'.tr, null),
        body: FutureBuilder(
            future: getONS(widget.patientDetailsData),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Ntdata data = snapshot.data;
              List<Ons> listData = data?.result?.first?.onsData;
              listData.sort((a, b) {
                return b.lastUpdate.compareTo(a.lastUpdate);
              });

              return listData.isEmpty?Center(child: Text('No record found'),):Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listData.length,
                          itemBuilder: (context, index) {
                            return  carditem(listData[index]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Container(
                        width: Get.width,
                        child: CustomButton(
                          text: "confirm".tr,
                          myFunc: () {
                            // print('json data: ${jsonEncode(listData)}');


                        this.onConfirm(data, listData);

                            // Get.to(Pregnancy_Lagtation_page2());
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }));
  }

  int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }


  Widget carditem(Ons data) {



    return Container(
      //height: 200,
      width: Get.width,
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getDateFormatFromString(data.lastUpdate),
                      initialData: "Loading text..",
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        return Text(
                          '${snapshot.data ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        );
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${data.condition}',
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text('${data.volume} ml ${data.times}x ${'per_day'.tr}'),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      '${'kcal'.tr}:${data.kcal}; ${'protein'.tr}:${data.ptn}; ${'fiber'.tr}:${data.fiber}'),
                  SizedBox(
                    height: 20,
                  ),
                  prcnt_tabs(data),
                  SizedBox(
                    height: 20,
                  ),
                  justification(data)
                  // dropdwon(data),

                  // SizedBox(height: 5.0,),
                  // Text('Dinner') ,
                  // SizedBox(height: 5.0,),
                  // Text('Supper') ,
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),

            // InkWell(child: Center(child: Text('Click here to answer',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 17.0) ,),),
            //   onTap: (){
            //   //  Get.to(Oral_Food_Accptnc());
            //
            //   },
            // ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget justification(Ons data){
    // print(data.seletecIndex);

    if(data.seletecIndex ==3 || data.seletecIndex ==4){
      return SizedBox();
    }else{
      return dropdwon(data);
    }

  }

  Widget dropdwon(Ons data) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              width: 1,
            )),
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        child:
            //Container(child: Center(child: _value==0?,),),
            Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                style: TextStyle(color: Colors.black, fontSize: 16.0),
                iconEnabledColor: Colors.black,
                // isExpanded: true,
                iconSize: 30.0,
                dropdownColor: Colors.white,
                hint: Text('justify_if_<_75'.tr),
                // value: _value,
                value: data.dropdownValue,
                items: listOptionDropdown
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text('${e.optionText}'),
                        value: '${e.optionText}',
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    data.dropdownValue = value;
                    print(value);
                  });
                }),
          ),
        ),
      ),
    );
  }

  Widget prcnt_tabs(Ons data) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Container(
        height: 50.0,
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0), color: Colors.black12),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: prcnt_list.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: InkWell(
                  child: Container(
                    width: 58,
                    height: 50.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: data.seletecIndex == index
                          ? Colors.white
                          : Colors.transparent,
                    ),
                    child: Center(
                        child: Text(
                      prcnt_list[index].prcnt_text,
                      style: TextStyle(
                          color: data.seletecIndex == index
                              ? Colors.blue
                              : Colors.black26),
                    )),
                  ),
                  onTap: () {
                    print('selected: ${data.seletecIndex}');
                    data.seletecIndex = index;
                    data.per = prcnt_list[index].prcnt_text;

                    // if()

                    setState(() {});
                  },
                ),
              );
            }),
      ),
    );
  }


  onConfirm(Ntdata data,List<Ons> listData)async{
    final ONSAcceptanceController _controller = ONSAcceptanceController();

    Map finalData = {
      'team_agree': data.result.first.teamAgree,
      'condition': data.result.first.condition,
      'kcal': data.result.first.kcal,
      'ptn': data.result.first.ptn,
      'fiber': data.result.first.fiber,
      'volume': data.result.first.volume,
      'times': data.result.first.times,
      'lastUpdate': '${DateTime.now()}',
      'ons': listData
    };

    print('json data: ${jsonEncode(finalData)}');

   List<Needs> computeNeed = await computeTotal(listData,widget.patientDetailsData.hospital[0].sId);


   print('saving here::');
    _controller
        .getRouteForModeSave(widget.patientDetailsData, finalData, ONSACCEPTANCE.OnsAccept,computeNeed);
    //     .then((value) {
    //   // Get.to(Step1HospitalizationScreen(
    //   //   patientUserId: widget.patientDetailsData.sId,
    //   //   index: 4,
    //   //   statusIndex: 3,
    //   // ));
    // });

  }

  ifBlankReturnZero(String text){
    if(text!=null && text!=''){
      return double.parse(text);
    }else{
      return 0.0;
    }
  }

 Future<List<Needs>> computeTotal(List<Ons> listData,String hospId)async{

    List<Needs> output = [];

    for(var a in listData){

      if(a.per!=null && a.per!=''){

        double pkcal = ifBlankReturnZero(a.kcal);
        double pptn = ifBlankReturnZero(a.ptn);
        double akcal = pkcal * int.parse(a.per.replaceAll("%", '').toString().removeAllWhitespace)/100;
        double aptn = pptn  * int.parse(a.per.replaceAll("%", '')..toString().removeAllWhitespace)/100;

        print('---------total----------');
        print('plan kcal : ${pkcal}');
        print('plan ptn : ${pptn}');

        print('Ach kcal : ${akcal}');
        print('Ach ptn : ${aptn}');

        Needs addItem = Needs();
        // DateTime lastworkday = await getDateTimeWithWorkdayHosp(hospId, DateTime.now().subtract(Duration(days: 1)));
        // DateTime currentworkdayStart = await getDateTimeWithWorkdayHosp(hospId, DateTime.now());
        // DateTime currentworkdayEnd = await getDateTimeWithWorkdayHosp(hospId, DateTime.now().add(Duration(days: 1)));
        // DateTime _date = DateTime.parse(a.lastUpdate);

        addItem.lastUpdate = a.lastUpdate;
        addItem.type = ONSACCEPTANCE.OnsAccept;

        addItem.plannedKcal = pkcal.toString();
        addItem.plannedPtn = pptn.toString();

        addItem.achievementKcal = akcal.toString();
        addItem.achievementProtein = aptn.toString();

        output.add(addItem);

      }

    }

    return output;

  }

}
