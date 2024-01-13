import 'dart:convert';

import 'package:medical_app/config/cons/Sessionkey.dart';
import 'package:medical_app/config/sharedpref.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/handle_access/handle_access.dart';

class Accessibility {
  final SaveDataSqflite sqflite = SaveDataSqflite();

  Future<List<AttributionInfo>> accessInfo() async {
    var userid =
        await MySharedPreferences.instance.getStringValue(Session.userid);

    List<AttributionInfo> attributionInfo = [];
    await sqflite.getUserDetails(userid).then((value) {
      print('resp: ${jsonEncode(value.data.attributionInfo)}');
      attributionInfo = value.data.attributionInfo;
    });

    return attributionInfo;
  }

  Future<List<AttributionInfo>> getHospitalAttributionInfo(
      String hospId) async {
    List<AttributionInfo> attributionInfo = [];
    await accessInfo().then((res) {
      for (var a in res) {
        if (a.hospitalId == hospId) {
          attributionInfo.add(a);
        }
      }
    });

    return attributionInfo;
  }

  Future<AccessFeature> getAccess(String hospId) async {
    AccessFeature accessFeature = AccessFeature();

    await getHospitalAttributionInfo(hospId).then((resp) {
      print('return hospital accessibility : ${jsonEncode(resp)}');

      if (resp != null && resp.isNotEmpty) {
        for (var a in resp) {
          for (var b in a.accessInfo) {
            if (b.name == 'Patientinfo') {
              accessFeature.editPatient =
                  returnValue(accessFeature.editPatient, b.access);
            } else if (b.name == 'Diagnosis') {
              accessFeature.diagnosis =
                  returnValue(accessFeature.diagnosis, b.access);
            } else if (b.name == 'PalliativeCare') {
              accessFeature.palCare =
                  returnValue(accessFeature.palCare, b.access);
            } else if (b.name == 'Anthropometry') {
              accessFeature.anthro =
                  returnValue(accessFeature.anthro, b.access);
            } else if (b.name == 'Status') {
              accessFeature.status =
                  returnValue(accessFeature.status, b.access);
            } else if (b.name == 'NT') {
              accessFeature.nt = returnValue(accessFeature.nt, b.access);
            } else if (b.name == 'NTBOX') {
              accessFeature.ntFoodAccept =
                  returnValue(accessFeature.ntFoodAccept, b.access);
            }
          }
        }
      } else {
        accessFeature.editPatient = true;
        accessFeature.anthro = true;
        accessFeature.diagnosis = true;
        accessFeature.nt = true;
        accessFeature.ntFoodAccept = true;
        accessFeature.palCare = true;
        accessFeature.status = true;
      }
    });

    if(accessFeature==null){
      accessFeature.editPatient = false;
      accessFeature.anthro = false;
      accessFeature.diagnosis = false;
      accessFeature.nt = false;
      accessFeature.ntFoodAccept = false;
      accessFeature.palCare = false;
      accessFeature.status = false;
    }
    print('access feature: ${accessFeature.palCare}');

    return accessFeature;
  }

  returnValue(bool previous, bool current) {
    if (previous != null && previous) {
      return previous;
    } else {
      return current;
    }
  }
}

class AccessFeature {
  bool editPatient;
  bool diagnosis;
  bool palCare;
  bool anthro;
  bool status;
  bool nt;
  bool ntFoodAccept;
  AccessFeature(
      {this.editPatient,
      this.diagnosis,
      this.palCare,
      this.anthro,
      this.status,
      this.nt,
      this.ntFoodAccept});
}
