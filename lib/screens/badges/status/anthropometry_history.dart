import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';

class AnthropometryHistory extends StatefulWidget {
  @override
  _AnthropometryHistoryState createState() => _AnthropometryHistoryState();
}

class _AnthropometryHistoryState extends State<AnthropometryHistory> {
  String _value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('Anthropometry History', null),
      bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:5.0,bottom: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration:BoxDecoration(color: primary_color,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        height: 40.0,
                        width: 230.0,//MediaQuery.of(context).size.width/3,
                        child:
                        //Container(child: Center(child: _value==0?,),),
                        Padding(
                          padding: const EdgeInsets.only(left:15.0,right: 15.0),
                          child:
                          DropdownButtonHideUnderline(
                            child: DropdownButton(

                                style: TextStyle(color: Colors.white,fontSize: 14.0),iconEnabledColor: Colors.white,
                                isExpanded: true,
                                iconSize:30.0,

                                dropdownColor:primary_color,
                                 hint: Text('Weight',style: TextStyle(color: Colors.white),),

                                value: _value,
                                items: [
                                  DropdownMenuItem(child: Text('AC'),value: '0',),
                                  DropdownMenuItem(child: Text('MUAC'),value: '1'),
                                  DropdownMenuItem(child: Text('CALF C'),value: '2'),
                                  DropdownMenuItem(child: Text('TST'),value: '3'),
                                  DropdownMenuItem(child: Text('WEIGHT ESTIMATED'),value: '4'),
                                  DropdownMenuItem(child: Text('WEIGHT AFTER DISCOUNT'),value: '5'),
                                  //  DropdownMenuItem(child: Text('item4'),value: '3'),

                                ],


                                onChanged: (value){
                                  setState(() {
                                    _value = value;

                                  });

                                }),
                          ),


                        ),

                      ),

                  ],),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: Get.width,
                height: Get.height/3.5,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.black)),
                  child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap"),
                ),
                SizedBox(height: 35.0,),
                Container(
                  padding: EdgeInsets.all(10.0),
                  width: Get.width,
                  height: Get.height/4.2,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0),border: Border.all(color: Colors.black)),
                  child: Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap"),
                ),
                SizedBox(height: 25.0,),
                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //          width: Get.width,
                //           child: CustomButton(text: 'Save',myFunc: (){},)),
                //     ),
                //   ],
                // ),
                SizedBox(height: 25.0,),


              ],
            ),
          ],
        ),
      ),
    );
  }




}
