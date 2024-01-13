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
import 'package:medical_app/screens/badges/status/Penotypic_second.dart';

class EtiologicalSecond extends StatefulWidget {
  @override
  _EtiologicalSecondState createState() => _EtiologicalSecondState();
}

class _EtiologicalSecondState extends State<EtiologicalSecond> {
  List<inflammation> _inflammation =[
    inflammation(false,"ACUTE DISEASE/INJURY"),
    inflammation(false,"CHRONIC DISEASE-RELATED"),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("Etiological Criteria",IconButton(icon: Icon(Icons.info_outline,color: card_color,),onPressed: (){Get.to(ReferenceScreen());},)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
            child: Text(
              "INFLAMMATION",
              style: TextStyle(fontSize: 16,color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _inflammation.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: _inflammation[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:_inflammation[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  OpenDiaglog();
                                  _inflammation[index].selected =!_inflammation[index].selected;
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
                                child: Text(_inflammation[index].Agreement_desc,
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

  int _radioValue = 0;
  OpenDiaglog() {
    Get.dialog(AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: Get.height / 6,
          width: Get.width / 1.1,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: Text(
                    'PERCEIVED INFLAMMATION?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              Divider(),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        new Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (int value){
                            setState(() {
                              _radioValue = value;
                              Get.back();
                              OpenDiaglog();
                            });
                          },
                        ),
                        new Text(
                          'Yes',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        new Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (int value){
                           setState(() {
                             _radioValue = value;
                             Get.back();
                             OpenDiaglog();
                           });
                          },
                        ),
                        new Text(
                          'No',
                          style: new TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
class inflammation{
  String Agreement_desc;
  bool selected;
  inflammation(this.selected,this.Agreement_desc);
}