import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/screens/badges/status/MNA_third.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class MNASecondScreen extends StatefulWidget {
  @override
  _MNASecondScreenState createState() => _MNASecondScreenState();
}

class _MNASecondScreenState extends State<MNASecondScreen> {
  List<Mobility> _Mobility =[
    Mobility(false,"Bed or chair bound (Score=0)"),
    Mobility(false,"Able to get out of bed / chair but does not go out(Score=1)"),
    Mobility(false,"Goes out (Score = 2)"),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("MNA",IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          SizedBox(height: 20,),
          Center(child: NNILogo_CopyRightText()),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "Mobility",
              style: TextStyle(fontSize: 16,fontWeight: FontBold),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _Mobility.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: _Mobility[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:_Mobility[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  _Mobility[index].selected =!_Mobility[index].selected;
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
                                child: Text(_Mobility[index].Agreement_desc,
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
          Center(child: CopyRightText()),
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
                      child: Center(child: Text('Next',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
                       Get.to(MNAThirdScreen());
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
class Mobility{
  String Agreement_desc;
  bool selected;
  Mobility(this.selected,this.Agreement_desc);
}