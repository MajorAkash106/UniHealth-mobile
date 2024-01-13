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

class MNASixthScreen extends StatefulWidget {
  @override
  _MNASixthScreenState createState() => _MNASixthScreenState();
}

class _MNASixthScreenState extends State<MNASixthScreen> {
  List<calf> _calf =[
    calf(false,"CC less than 31 (Score=0)"),
    calf(false,"CC 31 or greater (Score=3)"),
    calf(false,"BMI 21 to less than 23 (Score=2)"),
    calf(false,"BMI 23 or greater (Score=3)"),
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
              " Calf circumference (CC) in cm",
              style: TextStyle(fontSize: 16,fontWeight: FontBold),
            ),
          ),

          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _calf.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: _calf[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:_calf[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  _calf[index].selected =!_calf[index].selected;
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
                                child: Text(_calf[index].Agreement_desc,
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
                      child: Center(child: Text('Confirm',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
                        for (var i = 0; i < 6; i++) {
                        Get.back();
                        }
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
class calf{
  String Agreement_desc;
  bool selected;
  calf(this.selected,this.Agreement_desc);
}