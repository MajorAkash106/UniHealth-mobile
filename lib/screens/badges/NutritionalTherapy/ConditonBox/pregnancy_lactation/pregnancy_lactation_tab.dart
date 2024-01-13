import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/bmi_age_ward.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/adults/adult_icu.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/ConditonBox/pregnancy_lactation/pregnancy_lactation_page2.dart';

class Pregnancy_Lactation extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  Pregnancy_Lactation({this.patientDetailsData});

  @override
  _Pregnancy_LactationState createState() => _Pregnancy_LactationState();
}

class _Pregnancy_LactationState extends State<Pregnancy_Lactation> {
  List<staticList>listOption = <staticList> [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    listOption.add(staticList(optionText: 'sedentary_'.tr,isSelected: false));
    listOption.add(staticList(optionText: 'moderate_'.tr,isSelected: false));
    listOption.add(staticList(optionText: 'active_'.tr,isSelected: false));
    getSelected();
  }




  getSelected()async{

    for (var a in widget.patientDetailsData.ntdata) {
      print('type: ${a.type},status: ${a.status}');
      if (a.type == NTBoxes.condition) {

        setState(() {
          selectedIndex =  a.result.first.indexPAC;

          listOption[selectedIndex].isSelected = true;

        });

        print('yress');
        break;
      }
    }
  }


  Refference_Notes_Controller ref_Controller = Refference_Notes_Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('conditions'.tr, IconButton(
      icon: Icon(
        Icons.info_outline,
      ),
      onPressed: () {
        Get.to(ReferenceScreen(Ref_list:ref_Controller.pregAndLac ,));

      },
    )),

      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          Center(child: Text('pregnancy_lactation'.tr,style: TextStyle(color: Colors.black,fontSize: 17.0,fontWeight: FontWeight.bold,),)),
          SizedBox(height: 20.0,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(child: Text('${'attention'.tr}:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),),
              SizedBox(width: 10.0,),
              BmiAgeWard(patientDetailsData: widget.patientDetailsData,)
            ],
          ),
          SizedBox(height: 20.0,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(child: Text('${'pac'.tr} - ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18.0),),),
              SizedBox(width: 10.0,),
              Container(child: Expanded(child: Text('pac_with_full_form'.tr,style: TextStyle(color: Colors.black,fontSize: 18.0),)),),
            ],
          ),
          SizedBox(height: 20.0,),

          Expanded(
            child: ListView(children: listOption.map((e) => _radioWidget(e)).toList(),),
          ),

          Padding(
            padding:
            const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              width: Get.width,
              child: CustomButton(
                text: "next".tr,
                myFunc: () {

                  if(selectedIndex!=-1){

                    print('selectedIndex: $selectedIndex');
                    print('selected: ${listOption[selectedIndex].optionText}');

                    double PAC = 0.0;
                    if(selectedIndex==0){
                      PAC = 1.0;
                    }else if(selectedIndex==1){
                      PAC = 1.1;
                    }else if(selectedIndex == 2){
                      PAC = 1.27;
                    }


                    Get.to(Pregnancy_Lagtation_page2(patientDetailsData: widget.patientDetailsData,PAC: PAC, indexPAC: selectedIndex,));
                  }
                },
              ),
            ),
          )
        ],),
      ),
    );
  }

  int selectedIndex = -1;

  Widget _radioWidget(staticList e) {
    return Padding(
        padding: const EdgeInsets.only(right: 8,left: 8,top: 15),
        child: GestureDetector(
          onTap: (){
            setState(() {

              for(var a in listOption){
                setState(() {
                  a.isSelected = false;
                });
              }
              e.isSelected = true;

              selectedIndex = listOption.indexOf(e);

            });
          },
          child: Container(
            child: Row(
              children: [
                e.isSelected
                    ? Icon(
                  Icons.radio_button_checked,
                  size: 25,
                  color: primary_color,
                )
                    : Icon(
                  Icons.radio_button_off,
                  size: 25,
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child:  new Text(
                    '${e.optionText}',
                    style: new TextStyle(fontSize: 16.0),
                  ),),),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),)
    );
  }
}

