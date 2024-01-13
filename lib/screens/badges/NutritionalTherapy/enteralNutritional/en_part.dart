import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/contollers/NutritionalTherapy/getCurrentNeed.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/fiberProteinModule.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/protein_module.dart';
class ENPART extends StatefulWidget {
 final VoidCallback onUpdate;
  final String enkCal;
  final String protein;
  final String fiber;
  final ModuleDetail moduleDetail;
  ModuleDetail moduleDetail2;
  final List<ModuleData> moduleData;
   TextEditingController fiberModule;
  TextEditingController proteinModule;
  TextEditingController plan_ptn;
  TextEditingController plan_kcal;
  TextEditingController total_volume;
 VoidCallback onIsClearPtn;
  ENPART({this.onUpdate,this.enkCal,this.protein,this.fiber,this.moduleData,this.fiberModule,this.proteinModule, this.plan_ptn, this.plan_kcal, this.total_volume,this.moduleDetail,this.moduleDetail2,this.onIsClearPtn});


  @override
  _ENPARTState createState() => _ENPARTState();
}

class _ENPARTState extends State<ENPART> {

  EnteralNutritionalController _controller = EnteralNutritionalController();

  @override
  Widget build(BuildContext context) {
    print('getting data ${widget.enkCal}');
    return Column(children: [
      SizedBox(
        height: 10.0,
      ),
      Divider(
        thickness: 3,
        color: Colors.black12,
      ),
      SizedBox(
        height: 20.0,
      ),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'en_kcal'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 100,
              ),
              Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black12),
                  child: Center(
                    child: Text(
                      "${widget.enkCal??0}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'en_protein'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 60,
              ),
              Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black12),
                  child: Center(
                    child: Text(
                      "${widget.protein??0}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'en_fiber'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 100,
              ),
              Container(
                  width: 100.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black12),
                  child: Center(
                    child: Text(
                      "${widget.fiber??0}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Container(
                    width: 140,
                    child: CustomButton(
                      text: "fiber_module".tr,
                      myFunc: () {

                        List<ModuleData>data = [];
                        for(var a in widget.moduleData){
                          //isBlocked key is used  for isActive key here.
                          if(!a.fiber && a.isBlocked){
                            data.add(a);
                          }
                        }

                        fiberModuleBottomSheet(context,data,'fiber_module'.tr,widget.moduleDetail).then((val){
                          print(widget.moduleDetail.total_vol);
                          widget.fiberModule.text = val!=null?val?.total_amt??"0":widget.fiberModule.text;
                          print('...${jsonEncode(val)}');
                           widget.moduleDetail.item =val!=null? val?.item??"":widget.moduleDetail.item;
                           widget.moduleDetail.per_day =val!=null? val?.per_day??"":widget.moduleDetail.per_day;
                           widget.moduleDetail.g_per_dose = val!=null? val?.g_per_dose??"":widget.moduleDetail.g_per_dose;
                           widget.moduleDetail.total_amt = val!=null?val?.total_amt??"":widget.moduleDetail.total_amt;
                           widget.moduleDetail.total_vol = val!=null?val?.total_vol??"":widget.moduleDetail.total_vol;
                           widget.total_volume.text = val!=null?val?.total_vol??"":widget.total_volume;


                          setState(() {

                          });
                        });
                      },
                    )),
                Spacer(),
                Container(
                    width: 140,
                    child: CustomButton(
                      text: "protein_module".tr,
                      myFunc: () {

                        List<ModuleData>data = [];
                        for(var a in widget.moduleData){
                          //isBlocked key is used  for isActive key here.
                          if(a.fiber && a.isBlocked){
                            data.add(a);
                          }
                        }
                        proteinModuleBottomsheet(context,data,'protein_module'.tr,widget.moduleDetail2).then((val){
                            print('return from protien module${val}');
                          widget.proteinModule.text = val!=null? val["totalAmount"]: widget.proteinModule.text;
                           widget.plan_ptn.text =val!=null?  val["plan_ptn"]: widget.plan_ptn.text;
                           widget.plan_kcal.text = val!=null?val["plan_kcal"]: widget.plan_kcal.text;
                           widget.total_volume.text =val!=null?  val["totalVolume"]:widget.total_volume.text;
                           widget.moduleDetail2.item =val!=null?  val['details'].item:widget.moduleDetail2.item;
                           widget.moduleDetail2.per_day =val!=null?  val['details'].per_day:widget.moduleDetail2.per_day;
                           widget.moduleDetail2.g_per_dose =val!=null?  val['details'].g_per_dose:widget.moduleDetail2.g_per_dose;
                           widget.moduleDetail2.total_vol =val!=null?  val['details'].total_vol:widget.moduleDetail2.total_vol;
                           widget.moduleDetail2.total_amt =val!=null?  val['details'].total_amt:widget.moduleDetail2.total_amt;
                            widget.total_volume.text = val!=null?val['details'].total_vol.toString()??"0.0":widget.total_volume.text;
                           print(widget.total_volume.text);

                            // if(widget.proteinModule.text == '0' && widget.total_volume.text == '0'){
                            //   _currentNeed.removeNeedObject(widget.pData, 'protein_module').then((value) => widget.pData = value);
                            // }

                            if(val["isClear"]==true){
                              widget.moduleDetail2.item = null;
                              widget.onIsClearPtn();
                            }

                          setState(() {

                          });



                            widget.onUpdate();
                        });
                      },
                    )),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding:
            const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              children: [
                Container(
                    width: 140.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                        color: Colors.black12),
                    child: Center(
                      child: Text(
                        "${widget.fiberModule.text.isNotEmpty?widget.fiberModule.text:0} g",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Spacer(),
                Container(
                    width: 140.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10.0),
                        color: Colors.black12),
                    child: Center(
                      child: Text(
                        "${widget.proteinModule.text.isNotEmpty?widget.proteinModule.text:0} g",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    ],);
  }
}
