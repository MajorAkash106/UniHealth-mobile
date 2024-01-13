import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/Penotypic_second.dart';
import 'package:medical_app/screens/badges/status/Severity_second.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class SeverityThirdScreen extends StatefulWidget {
  @override
  _SeverityThirdScreenState createState() => _SeverityThirdScreenState();
}

class _SeverityThirdScreenState extends State<SeverityThirdScreen> {
  List<weightloss> _weightloss =[
    weightloss(false,"MILD TO MODERATE DEFICIT ASSESSED BY DXA, BIA, CT OR MRI"),
    weightloss(false," SEVERE DEFICIT ASSESSED BY DXA, BIA, CT OR MRI"),
    weightloss(false," 70-90% (MILD TO MODERATE)"),
    weightloss(false," < 70% (SEVERE)"),
  ];


  bool checkbox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("Severity",
       null
    ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "REDUCED MUSCLE MASS",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "STAGE 1 / MODERATE MALNUTRITION",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _weightloss.length,
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
                                    child: Container(decoration:BoxDecoration(border: Border.all(color: _weightloss[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                        borderRadius: BorderRadius.circular(5.0)
                                    ),


                                        child:_weightloss[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                    elevation: 4.0,
                                  ),
                                ],
                              ),
                              onTap: (){
                                setState(() {
                                  _weightloss[index].selected =!_weightloss[index].selected;
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
                                child: Text(_weightloss[index].Agreement_desc,
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
class weightloss{
  String Agreement_desc;
  bool selected;
  weightloss(this.selected,this.Agreement_desc);
}