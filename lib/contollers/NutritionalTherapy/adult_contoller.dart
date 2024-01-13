import 'dart:convert';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/request.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/contollers/sqflite/database/hospitals_offline.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/json_config/const/json_fun.dart';
import 'package:medical_app/json_config/const/json_paths.dart';
import 'package:medical_app/model/NutritionalTherapy/adult_condition_model.dart';
import 'package:medical_app/model/WardListModel.dart';

class AdultsContoller extends GetxController {
  var Adult_icu = List<ConditionData>().obs;
  var Adult_non_icu = List<ConditionData>().obs;
  var pediatrics = List<ConditionData>().obs;
  var isError = false.obs;
  HospitalSqflite sqflite = HospitalSqflite();

 Future<String> getRouteForMode(String category, String type, String condition,String hospId)async{
   await checkConnectivityWithToggle(hospId).then((internet) {
      print('internet');

      if (internet != null && internet) {
       getData(category, type, condition, hospId);
        print('internet avialable');
      } else {
       getDataFromSqlite(category, type, condition, hospId);
      }
    });
   return 'success';
  }



  Future<String> getData(String category, String type, String condition,String hospId) async {
    print('condition: ${condition}');

    Get.dialog(Loader(), barrierDismissible: false);
    try {
      print(APIUrls.getConditions);
      Request request = Request(url: APIUrls.getConditions, body: {
        'hospitalId': hospId,
        'category': category,
        'type': type,
      });

      print(request.body);
      await request.post().then((value) {
        AdultCondition model = AdultCondition.fromJson(json.decode(value.body));
        print(model.success);
        print(model.message);
        Get.back();
        if (model.success == true) {
          print(model.data.length);

          if(condition!=null && condition!=''){
            for (var a in model.data) {
              if (a.condition.contains(condition)) {
                a.isSelected = true;
                break;
              }
            }
          }


          if (category == 'Adults-NON ICU') {
            Adult_non_icu.clear();
            Adult_non_icu.addAll(model.data);
          } else if (category == 'PEDIATRICS') {
            pediatrics.clear();
            pediatrics.addAll(model.data);
          } else {
            Adult_icu.clear();
            Adult_icu.addAll(model.data);
          }
        } else {
          isError.value = true;
          // ShowMsg(model.message);
        }
      });
    } catch (e) {
      Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }

  Future<String> getDataFromSqlite(String category, String type, String condition,String hospId) async {
    print('condition: ${condition}');

    await sqflite.getWards(hospId).then((res) {
      if (res != null) {
        WardList wardList = res;
        print(wardList.success);
        print(wardList.message);
        if (wardList.success == true) {
          print(wardList.data);



          if(condition!=null && condition!=''){
            for (var a in wardList.offline.ntPanel.adultIcu) {
              if (a.condition.contains(condition)) {
                a.isSelected = true;
                break;
              }
            }
            for (var a in wardList.offline.ntPanel.adultNonIcu) {
              if (a.condition.contains(condition)) {
                a.isSelected = true;
                break;
              }
            }
          }



          if (category == 'Adults-NON ICU') {
            Adult_non_icu.clear();
            Adult_non_icu.addAll(wardList.offline.ntPanel.adultNonIcu);
          } else if (category == 'PEDIATRICS') {
            pediatrics.clear();
            pediatrics.addAll(wardList.offline.ntPanel.adultIcu);
          } else {
            Adult_icu.clear();
            Adult_icu.addAll(wardList.offline.ntPanel.adultIcu);
          }

        } else {
          isError.value = true;
          // ShowMsg(wardList.message);
        }
      } else {
        DATADOESNOTEXIST();
      }
    });
    // return 'success';
  }




  Future<String> getDataPediatric(String category, String type, String condition,String hospId) async {
    print('condition: ${condition}');


    try {
      var data = await getJson(JsonFilePath.pediatricsData);
      print('data from json file: ${json.decode(data)}');
      AdultCondition model = AdultCondition.fromJson(json.decode(data));
      print(model.success);
      print(model.message);
      // Get.back();
      if (model.success == true) {
        print(model.data.length);

        for (var a in model.data) {
          if (a.condition.contains(condition)) {
            a.isSelected = true;
            break;
          }
        }

        pediatrics.clear();
        pediatrics.addAll(model.data);
      } else {
        ShowMsg(model.message);
      }
    } catch (e) {
      // Get.back();
      print(e);
      // ServerError();
    }
    return 'success';
  }
}
