import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/NutritionalTherapy/enteralNutritionalController.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_formula_model.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';



var times = TextEditingController();
var mass = TextEditingController();

String totalAmount;
String totalVolume;

var _value;
var _selectedData;
int type = 0;
String title;

final EnteralNutritionalController _controller = EnteralNutritionalController();

Future<ModuleDetail> fiberModuleBottomSheet(BuildContext context,List<ModuleData>listData,String module,ModuleDetail fiber_moduledetail){
  times.clear();
  mass.clear();
  _value=null;

  totalAmount = null;
  totalVolume = null;
  if(fiber_moduledetail != null){
for(var a in listData){
  if(a.title == fiber_moduledetail.item){
    _value = a.sId;
  }
}
  times.text = fiber_moduledetail.per_day;
mass.text = fiber_moduledetail.g_per_dose;
  }
  _controller.getModuleTotalData(times.text, _selectedData, mass.text).then((value){
    totalAmount = value[0];
    totalVolume = value[1];
  });

 return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // You need this, notice the parameters below:
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
              Padding(padding: EdgeInsets.only(left: 10),child:   Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      '$module',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0),
                    ),
                  ],
                ),
              ),),
                SizedBox(height: 20,),
                dropdownFormulass(
                    listData, _value,
                        (value) {
                      setState(() {
                        _value = value;
                        _selectedData = listData.firstWhere((element) => element.sId == value,orElse: ()=>null);
                        type = _selectedData.type;
                        title = _selectedData.title;

                        adLog('message ${_selectedData.type} --- ${_selectedData.title}');
                        print('return value: $value');

                        times.clear();
                        mass.clear();
                        totalAmount = null;
                        totalVolume = null;

                      });
                    }, context),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Container(
                            width: 130.0,
                            height: 40.0,
                            child:
                            // texfld2("times", times, () {
                            //   // print(times);
                            //   totalAmount = null;
                            //   totalVolume = null;
                            //   _controller.getModuleTotalData(times.text, _selectedData, mass.text).then((value){
                            //     totalAmount = value[0];
                            //     totalVolume = value[1];
                            //     setState(() {});
                            //   });
                            // }),
                            TextField(
                              controller: times,

                              //focusNode: focus,
                              keyboardType: TextInputType.number,
                              onChanged: (_value) {

                                totalAmount = null;
                                totalVolume = null;

                                _controller.getModuleTotalData(times.text, _selectedData, mass.text).then((value){
                                  totalAmount = value[0];
                                  totalVolume = value[1];
                                  setState(() {});
                                });

                              },
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'times'.tr,
                                border: new OutlineInputBorder(
                                  //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                    borderSide:
                                    BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                                ),
                                hintStyle: TextStyle(
                                    color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                              ),
                            )
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'x_per_day'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'if_manipulated'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold,color:type==0?disable_color:Colors.black,),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 130.0,
                            height: 40.0,
                            child:
                            // texfld2("mass", a, () {
                            //   print(a);
                            // }),
                            TextField(
                              controller: mass,
                              enabled: type==0?false:true,
                              //focusNode: focus,
                              keyboardType: TextInputType.number,
                              onChanged: (_value) {

                                totalAmount = null;
                                totalVolume = null;

                                _controller.getModuleTotalData(times.text, _selectedData, mass.text).then((value){
                                  totalAmount = value[0];
                                  totalVolume = value[1];
                                  setState(() {});
                                });

                              },
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'mass'.tr,
                                border: new OutlineInputBorder(
                                  //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                                    borderSide:
                                    BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
                                ),
                                hintStyle: TextStyle(
                                    color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
                              ),
                            )
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'g_dose'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold,color:type==0?disable_color:Colors.black,),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Column(
                        children: [
                          Text(
                            'total_amount'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          Container(
                              width: 130.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  color: Colors.black12),
                              child: Center(
                                child: Text(
                                  "${totalAmount??0}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )),


                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'total_volume'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5,),
                          Container(
                              width: 130.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(10.0),
                                  color: Colors.black12),
                              child: Center(
                                child: Text(
                                  "${totalVolume??0}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              )),


                        ],
                      ),
                    ],),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child:  Container(
                      width: Get.width,
                      child: RaisedButton(
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(10.0),
                        // ),
                        padding: EdgeInsets.all(15.0),
                        elevation: 0,
                        onPressed: () {

                          // Get.back(result: totalAmount??'0');
                          Get.back(result: ModuleDetail(item: title,per_day:times.text,g_per_dose: mass.text,total_amt: totalAmount,total_vol: totalVolume ));
                        },
                        color: primary_color,
                        textColor: Colors.white,
                        child: Text("save".tr,
                            style: TextStyle(fontSize: 14)),
                      )),
                )
              ],
            );
          },
        );
      });
}





Widget dropdownFormulass(
    List<ModuleData> listofItems, var val, Function func, var context) {
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
    child: Container(
      decoration: BoxDecoration(
        // color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black26,
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
              hint: Text('select'.tr),
              value: val,
              items: listofItems
                  .map(
                    (e) => DropdownMenuItem(
                  child: Text('${e.title}'),
                  value: '${e.sId}',
                ),
              )
                  .toList(),
              onChanged: func),
        ),
      ),
    ),
  );
}