import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class NRS_FifthScreen extends StatefulWidget {
  @override
  _NRS_FifthScreenState createState() => _NRS_FifthScreenState();
}

class _NRS_FifthScreenState extends State<NRS_FifthScreen> {
  List<Severity_details> severity_list =[
    Severity_details(false,"Normal severity status (Score 0)"),
    Severity_details(false,"Hip fracture* Chronic patients, in particular withacute complications: cirrhosis*, COPD*. Chronichemo diabetes, oncology (Score 1)"),
    Severity_details(false,"Head injury*, bone marrow transplantation*,intensive care patients (APACHE >10). (Score 3)"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("NRS - 2002",IconButton(icon: Icon(Icons.info_outline,color: card_color,))),
      body: Column(
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 0.0,right: 20.0),
            child: Text(
              "Severity of disease (increase in reqirements)",
              style: TextStyle(fontSize: 16,fontWeight: FontBold),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: severity_list.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: severity_list[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:severity_list[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  severity_list[index].selected =!severity_list[index].selected;
                                });
                              },
                            ),
                            // SizedBox(height:15.0,)
                          ],
                        ),
                        SizedBox(width: 5.0,),

                        Expanded(
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(width: MediaQuery.of(context).size.width,child: Padding(
                                padding: const EdgeInsets.only(top:4.0),
                                child: Text(severity_list[index].Agreement_desc,
                                  style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black54,fontSize: 14),
                                ),
                              ),

                              ),
                            ],
                          ),
                        )],),
                    );

                }),
          ),
          //Spacer(),
          SizedBox(height: 30.0,),
          Padding(
            padding: const EdgeInsets.only(left:25.0,right: 25.0),
            child: Row(
              children: [
                Expanded(
                  child:Container(
                    height:50.0,
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      color: primary_color,
                      child: Center(child: Text('Confirm',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                        Get.back();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.0,),
        ],
      ),


    );
  }
}
class Severity_details{
  String Agreement_desc;
  bool selected;
  Severity_details(this.selected,this.Agreement_desc);
}