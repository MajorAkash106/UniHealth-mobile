import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/Subscription_history/subscription_historyController.dart';
import 'package:medical_app/Subscription_history/subscription_historyModel.dart';
import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';


class Subscription_HistoryScreen extends StatefulWidget {
  const Subscription_HistoryScreen({Key key}) : super(key: key);

  @override
  _Subscription_HistoryScreenState createState() => _Subscription_HistoryScreenState();
}

class _Subscription_HistoryScreenState extends State<Subscription_HistoryScreen> {
  Subscription_HistoryController subscrp_historyController =Subscription_HistoryController();
  final GlobalKey<PopupMenuButtonState<int>> _key = GlobalKey();
  String userId;
List<String> filtertabs =["All","Active","Expired",];
List<Data> _value;
  List<Data> data_list =[];

  List<Data> active_list =[];
  List<Data> expired_list =[];


  List<Data> f_list =[];
@override
  void initState() {
    // TODO: implement initState
     MySharedPreferences.instance.getStringValue(Session.userid).then((id) {
       setState(() {
         userId = id.toString();
         print(userId);
        data_get_in_init(userId);
       });

     });
    // subscrp_historyController.getSubscription_History("616fc41bdb7c9e1d4a69616a",0).then((resp){
    //   Future.delayed(Duration(seconds: 1)).then((value) {
    //      _value =  resp;
    //   });
    // });


    super.initState();
  }

  Future<List<Data>>data_get_in_init(String userId)async{
    print("userId.........");
  print(userId);


    subscrp_historyController.getSubscription_History(userId,0).then((resp) {
      Future.delayed(Duration(seconds: 1)).then((value)async {

        _value =  await resp;
        data_list = _value;
       await active_list.addAll(_value.where((element) => DateTime.parse(element.payments[0].expiredDate).isAfter(DateTime.now())));

       await expired_list.addAll(_value.where((element) => DateTime.parse(element.payments[0].expiredDate).isBefore(DateTime.now())));

        print(_value.length);
        setState(() {

        });
      });
    });
  }
  // Future<List<Data>>data_get()async{
  // Future.delayed(Duration(milliseconds: 100)).then((value) {
  //   // tempdata=_value;
  //   // setState(() {
  //   //
  //   // });
  // });
  //
  // return await _value;
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar:
    AppBar(title: Text('Subscription History',style: TextStyle(fontSize: 14),),
    centerTitle: true,
    actions: [
      PopupMenuButton(
        initialValue: 2,
        child: Padding(
          padding: const EdgeInsets.only(right:10.0),
          child: Center(
              child:  SvgPicture.asset(
                AppImages.filterImageSvg,
                color: card_color,
              )),
        ),
        itemBuilder: (context) {
          return List.generate(filtertabs.length, (index) {
            return PopupMenuItem(
              value: index,
              child: InkWell(child: Row(
                children: [
                  Text(filtertabs[index]),
                ],
              ),
              onTap: (){

                if(index ==0){
                 setState(() {
                   // type =1;
                   //data_list.clear();
                   data_list =_value;

                 });
                }
                else if(index ==1){
                  setState(() {
                    print(active_list.length);
                    data_list=active_list;
                    print(data_list.length);
                    //

                  });
                }
                else{
                  setState(() {
                    print(expired_list.length);
                    data_list=expired_list;
                    print(data_list.length);
                  });
                }
                // filter(tempdata,1);
                //print(filtertabs[index]);
                Get.back();
              },
              ),
            );
          });
        },
      ),
    ],
    ),

      body: data_list.isEmpty?Center(child: Container(),):
                  Column(children: [
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: data_list.length,
                        itemBuilder: (BuildContext context, index) {
                          return
                            //subscrp_historyController.subscription_historyModel==null?SizedBox():
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: Container(height: 245.0, width: Get.width,
                                    decoration: BoxDecoration(
                                      // color: Colors.red,
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),

                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 10.0, left: 10.0),
                                      child: Column(children: [
                                        // Container(height: 50.0,width: Get.width,
                                        //
                                        //   decoration: BoxDecoration(
                                        //     color: primary_color,
                                        //     borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20.0))
                                        //   ),
                                        // )
                                        SizedBox(height: 10.0,),
                                        InkWell(

                                          onTap: () {
                                          // subscrp_historyController
                                          //     .getSubscription_History(
                                          //     "616fc41bdb7c9e1d4a69616a",0).then((
                                          //     data) {
                                          //
                                          // });
                                        },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            children: [
                                              Text('Subscription status : ',style: TextStyle(fontWeight: FontWeight.bold),),
                                              SizedBox(width: 10.0,),
                                              Container(
                                                child: //Text(
                                                  DateTime.parse(
                                                   data_list[index]
                                                        .payments[0].expiredDate)
                                                    .isBefore(DateTime.now())
                                                    ? Text("Expired",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)
                                                    :Text("Active",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)
                                                //),
                                              )
                                            ],
                                          ),
                                        ),
                                        // SizedBox(height: 10.0,),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Divider(height: 1,
                                            thickness: 2,
                                            color: Colors.black12,),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Row(children: [
                                          Text("Plan Name : "),
                                          Text(data_list[index].badges[0]
                                              .attributionname ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Hospital's name : "),
                                          Text(data_list[index]
                                              .hospital[0].name ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Product ID : "),
                                          Text(data_list[index]
                                              .payments[0].productId ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Payment status : "),
                                          Text(data_list[index]
                                              .payments[0].status ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Paid amount : "),
                                          Text(data_list[index]
                                              .payments[0].amount ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Order ID : "),
                                          Text(data_list[index]
                                              .payments[0].orderId ?? ""),
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Row(children: [
                                          Text("Verification status : "),
                                          data_list[index].isAccept==true?Text('Approved',style: TextStyle(color: Colors.green),):data_list[index].isReject==true?Text('Rejected',style: TextStyle(color: Colors.red),):Text("Pending",style: TextStyle(color: Colors.orange),)
                                        ],),
                                        SizedBox(height: 5.0,),
                                        Spacer(),
                                        Row(children: [
                                          Container(child: Row(children: [
                                            Text("Subscribed date : ",
                                              style: TextStyle(fontSize: 11),),
                                            Text(
                                              DateFormat(commonDateFormat).format(
                                                  DateTime.parse(
                                                      data_list[index]
                                                          .payments[0]
                                                          .subscribedDate)),
                                              style: TextStyle(fontSize: 11),),
                                          ],),),


                                          Spacer(),
                                          Container(child: Row(children: [
                                            Text("Expired date : ",
                                              style: TextStyle(fontSize: 11),),
                                            Text(
                                              DateFormat(commonDateFormat).format(
                                                  DateTime.parse(
                                                      data_list[index]
                                                          .payments[0]
                                                          .expiredDate)),
                                              style: TextStyle(fontSize: 11),)
                                          ],),),

                                        ],),
                                        SizedBox(height: 10.0,)
                                      ],),
                                    ),

                                  )
                              ),
                            );
                        }),
                  )
                ],)


    );
  }





}
