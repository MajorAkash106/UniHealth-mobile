import 'dart:convert';

import 'package:get/get.dart';
// import 'package:medical_app/Subscription_history/subscription_historyModel.dart';
import 'package:medical_app/Subscription_history/subscription_historyModel.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/request.dart';

class Subscription_HistoryController extends GetxController{


  Subscription_historyModel subscription_historyModel;
  Future<List<Data>> getSubscription_History(String user_id,int filter )async{
    try{
      List<Data> data =[];

      print(APIUrls.getRequests);
      Request request = await Request(url: APIUrls.getRequests,body: {
        "userId":user_id
      });
      print(request.body);
     await request.post().then((response) async{
     subscription_historyModel = await Subscription_historyModel.fromJson(jsonDecode(response.body));
    if(subscription_historyModel.success==true){
      print('>>>>>>>True>>>${subscription_historyModel.data[0].badges[0].attributionname}');

         data.clear() ;
        data =subscription_historyModel.data;

    }
    else{
     // Get.back();
      ShowMsg(subscription_historyModel.message);
      print(subscription_historyModel.message);
    }
      });


      print(data.length);
      return data;



       // return data;

    }catch(e){
      print("exception..... ${e.toString()}");

    }
    print('00000000000');

    // return subscription_historyModel;
  }






}