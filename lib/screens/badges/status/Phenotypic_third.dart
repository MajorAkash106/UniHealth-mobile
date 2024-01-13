import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/screens/badges/status/NRS_Fifth_2002.dart';
import 'package:medical_app/screens/badges/status/NRS_third_2002.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class PenotypicThirdScreen extends StatefulWidget {
  @override
  _PenotypicThirdScreenState createState() => _PenotypicThirdScreenState();
}

class _PenotypicThirdScreenState extends State<PenotypicThirdScreen> {
  List<ASMI> ASMI_list =[
    ASMI(false,'DXA <7 (MALES) OR <5.4 (FEMALES)'),
    ASMI(false," BIA <7 (MALES) OR <5.7 (FEMALES)"),
  ];
  List<MAMC> MAMC_list =[
    MAMC(false,'70-90% (MILD TO MODERATE)'),
    MAMC(false," < 70% (SEVERE)"),
  ];
  List<FFMI> FFMI_list =[
    FFMI(false,'DXA <7 (MALES) OR <5.4 (FEMALES)'),
  ];



bool checkbox = false;

  @override
  void initState() {

    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("Phenotypic Criteria", IconButton(icon: Icon(Icons.info_outline,color: card_color,))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          // SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 0.0,right: 20.0),
            child: Text(
              "REDUCED MUSCLE MASS",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          // SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "ASMI (kg/m2)",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,right: 20.0),
            child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

              Column(mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  InkWell(

                    child: Row(
                      children: [
                        SizedBox(width: 20.0,),
                        Card(
                          child: Container(decoration:BoxDecoration(border: Border.all(color: checkbox? Colors.green:Colors.black.withAlpha(100)),
                              borderRadius: BorderRadius.circular(5.0)
                          ),


                              child:checkbox? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                          elevation: 4.0,
                        ),
                      ],
                    ),
                    onTap: (){
                      setState(() {
                        checkbox =!checkbox;
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
                      child: Text('DXA <7 (MALES) OR <5.4 (FEMALES)',
                        style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black54,fontSize: 14),
                      ),
                    ),

                    ),
                  ],
                ),
              )],),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

              Column(mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  InkWell(

                    child: Card(
                      child: Container(decoration:BoxDecoration(border: Border.all(color: checkbox? Colors.green:Colors.black.withAlpha(100)),
                          borderRadius: BorderRadius.circular(5.0)
                      ),


                          child:checkbox? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                      elevation: 4.0,
                    ),
                    onTap: (){
                      setState(() {
                        checkbox =!checkbox;
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
                      child: Text(" BIA <7 (MALES) OR <5.7 (FEMALES)",
                        style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black54,fontSize: 14),
                      ),
                    ),

                    ),
                  ],
                ),
              )],),
          ),

          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "FFMI (kg/m2):",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

              Column(mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  InkWell(

                    child: Card(
                      child: Container(decoration:BoxDecoration(border: Border.all(color: checkbox? Colors.green:Colors.black.withAlpha(100)),
                          borderRadius: BorderRadius.circular(5.0)
                      ),


                          child:checkbox? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                      elevation: 4.0,
                    ),
                    onTap: (){
                      setState(() {
                        checkbox =!checkbox;
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
                      child: Text('DXA <7 (MALES) OR <5.4 (FEMALES)',
                        style: TextStyle(fontWeight: FontWeight.normal,color: Colors.black54,fontSize: 14),
                      ),
                    ),

                    ),
                  ],
                ),
              )],),
          ),



          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 0.0,right: 20.0),
            child: Text(
              "% MAMC (LOAD THIS ITEM FROMANTHROPOMETRY AND SELECTAUTOMATICALLY, IF APPLIES)",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: MAMC_list.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Row(
                                children: [
                                  SizedBox(width: 20.0,),
                                  Card(
                                    child: Container(decoration:BoxDecoration(border: Border.all(color: MAMC_list[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),


                                        child:MAMC_list[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                    elevation: 4.0,
                                  ),
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  MAMC_list[index].selected =!MAMC_list[index].selected;
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
                                child: Text(MAMC_list[index].Agreement_desc,
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
                      child: Center(child: Text('Cofirm',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
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
class ASMI{
  String Agreement_desc;
  bool selected;
  ASMI(this.selected,this.Agreement_desc);
}

class MAMC{
  String Agreement_desc;
  bool selected;
  MAMC(this.selected,this.Agreement_desc);
}

class FFMI{
  String Agreement_desc;
  bool selected;
  FFMI(this.selected,this.Agreement_desc);
}