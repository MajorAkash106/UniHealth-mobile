import 'package:get/get.dart';
import 'dart:convert';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusionReportModel.dart' as infusion;

class InfusionReportFormula extends GetxController {
  void updateEnteralFormulaInfusion(PatientDetailsData data, Map dataa,
      List<Needs> needs, List formulaData, List<String> times) async {
    List<infusion.Data> getData = await data.enteralFormula;

    var updatedData = {

      // "currenttime": DateFormat('HH:mm').format(DateTime.now()),
      // "hospitaltime": DateFormat('HH:mm').format(DateTime.parse(times[1])),
      // "date": DateFormat(commonDateFormat).format(DateTime.now()),
      // "time": DateFormat('HH:mm').format(DateTime.now()),
      "currentdate": times[0],
      "hospitaldate": times[1],
      "formulastatus": "enteral",
      "userId": data.sId,
      // "hospitalId": data.hospital.first.sId,
      'formula': formulaData,
    };

    print('updatedData :: ${updatedData}');

    var jsonData = jsonEncode(updatedData);
    infusion.Data updated = await infusion.Data.fromJson(jsonDecode(jsonData));
    // print("updated::${updated}");
    if(getData.length!=0){
      infusion.Data infusedData;
      for(var a in getData){
        if(a.currentdate == times[0] && a.hospitaldate == times[1]){
          infusedData = a;
          break;
        }
      }
      updated.sId = infusedData?.sId??"";
      getData.remove(infusedData);
      getData.add(updated);
    }else{
      getData.add(updated);
    }
    print('getData :: ${getData}');

    data.enteralFormula = await getData;
    print('data.enteralFormula ::: ${data.enteralFormula}');

    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    // await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

  }


  void updateParenteralFormulaInfusion(PatientDetailsData data, Map dataa, List formulaData, List<String> times) async {
    List<infusion.Data> getData = await data.parenteralFormula;

    var updatedData = {

      // "currenttime": DateFormat('HH:mm').format(DateTime.now()),
      // "hospitaltime": DateFormat('HH:mm').format(DateTime.parse(times[1])),
      // "date": DateFormat(commonDateFormat).format(DateTime.now()),
      // "time": DateFormat('HH:mm').format(DateTime.now()),
      "currentdate": times[0],
      "hospitaldate": times[1],
      "formulastatus": "parenteral",
      "userId": data.sId,
      // "hospitalId": data.hospital.first.sId,
      'formula': formulaData,
    };

    print('updatedData :: ${updatedData}');

    var jsonData = jsonEncode(updatedData);
    infusion.Data updated = await infusion.Data.fromJson(jsonDecode(jsonData));
    // print("updated::${updated}");
    if(getData.length!=0){
      infusion.Data infusedData;
      for(var a in getData){
        if(a.currentdate == times[0] && a.hospitaldate == times[1]){
          infusedData = a;
          break;
        }
      }
      updated.sId = infusedData?.sId??'';
      getData.remove(infusedData);
      getData.add(updated);
    }else{
      getData.add(updated);
    }
    print('getData :: ${getData}');

    data.parenteralFormula = await getData;
    print('data.parenteralFormula ::: ${data.parenteralFormula}');

    final SaveDataSqflite sqfliteStroe = SaveDataSqflite();
    // await ShowMsg('data_updated_successfully'.tr);
    await sqfliteStroe.saveData(data);

  }

}
