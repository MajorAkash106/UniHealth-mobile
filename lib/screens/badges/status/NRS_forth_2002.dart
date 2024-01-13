import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/custom_text.dart';
import 'package:medical_app/screens/badges/status/NRS_Fifth_2002.dart';
import 'package:medical_app/screens/badges/status/NRS_third_2002.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class NRS_ForthScreen extends StatefulWidget {
  @override
  _NRS_ForthScreenState createState() => _NRS_ForthScreenState();
}

class _NRS_ForthScreenState extends State<NRS_ForthScreen> {
  List<Nutritional> nutritional_list =[Nutritional(false,'Normal nutritional status (Score 0)'),
    Nutritional(false,"Weight loss >5% in 3 months or food intake below 50,75% of normal requirement in preceding week. (Score 1)"),
    Nutritional(false,"Weight loss >5% in 2 months or BMI 18.5--20.5 + impaired general condition or food intake 25%--60% of normal requirement in preceding week. (Score 2)--25%"),
    Nutritional(false,"Weight loss >5% in 1 month (>15in 3 months) or BMI< 18.5 + impaired general condition or food intake 0 of normal requirement in preceding week in preceding week. (Score 3)"),
  ];





  @override
  void initState() {

    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:BaseAppbar("NRS - 2002", IconButton(icon: Icon(Icons.info_outline,color: card_color,))),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [//Row(children: [Container(color: Colors.red,height: 20.0,width: 40.0,)],),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 0.0,right: 20.0),
            child: Text(
              "Impaired Nutritional Status",
              style: TextStyle(fontSize: 16,fontWeight: FontBold),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: nutritional_list.length,
                itemBuilder: (context,index){
                  return
                    Padding(
                      padding: const EdgeInsets.only(left:20.0,top: 12.0,bottom: 12.0,right: 20.0),
                      child: Row(crossAxisAlignment:CrossAxisAlignment.start,children: [

                        Column(mainAxisAlignment: MainAxisAlignment.start,

                          children: [
                            InkWell(

                              child: Card(
                                child: Container(decoration:BoxDecoration(border: Border.all(color: nutritional_list[index].selected? Colors.green:Colors.black.withAlpha(100)),
                                    borderRadius: BorderRadius.circular(5.0)
                                ),


                                    child:nutritional_list[index].selected? Icon(Icons.check,size: 20.0,color:Colors.green):Icon(Icons.check,size: 18.0,color: Colors.transparent,)),
                                elevation: 4.0,
                              ),
                              onTap: (){
                                setState(() {
                                  nutritional_list[index].selected =!nutritional_list[index].selected;
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
                                child: Text(nutritional_list[index].Agreement_desc,
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
                      child: Center(child: Text('Next',style: TextStyle(color: Colors.white),),),
                      onPressed: (){
                        Get.to(NRS_FifthScreen());
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
class Nutritional{
  String Agreement_desc;
  bool selected;
  Nutritional(this.selected,this.Agreement_desc);
}