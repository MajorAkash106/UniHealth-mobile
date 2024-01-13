import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/NNI_logo_text.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/screens/badges/status/MNA_sixth.dart';
import 'package:medical_app/screens/badges/status/MNA_third.dart';
class ASCITEScreen extends StatefulWidget {
  @override
  _ASCITEScreenState createState() => _ASCITEScreenState();
}

class _ASCITEScreenState extends State<ASCITEScreen> {
  List<Ascitis> _Ascitis =[
    Ascitis(false," MINIMAL (2.2 KG SHOULD BE REDUCED FROM THE BODY WEIGHT)"),
    Ascitis(false,"MODERATE ( 6 KG SHOULD BE REDUCED FROM THE BODY WEIGHT) "),
    Ascitis(false,"SEVERE (14KG SHOULD BE REDUCED FROM THE BODY WEIGHT)"),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("ASCITES",IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _Ascitis.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: _Ascitis[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:_Ascitis[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  _Ascitis[index].selected =!_Ascitis[index].selected;
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
                                child: Text(_Ascitis[index].Agreement_desc,
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
                      child: Center(child: Text('Save',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
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
class Ascitis{
  String Agreement_desc;
  bool selected;
  Ascitis(this.selected,this.Agreement_desc);
}