import 'dart:convert';

import 'package:json_store/json_store.dart';
import 'package:medical_app/contollers/sqflite/model/all_patient_id.dart';
import 'package:medical_app/contollers/sqflite/model/last_badge_leave.dart';
import 'package:medical_app/in_app_purchase/subscription_service.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class SaveDataSqflite {
  final _jsonStore = JsonStore(dbName: 'patient_data');
 SubscriptionService subscriptionService = SubscriptionService();

  Future<String> savePatientDetails(
      PatientDetailsData patientDetailsData) async {
    print('save data to SQFLITE : ${jsonEncode(patientDetailsData)}');

    //updatedd patients details in sqlfite
    await _jsonStore.setItem(patientDetailsData.sId, patientDetailsData.toJson());
  }

  Future<String> saveData(PatientDetailsData patientDetailsData) async {
    print('save data to SQFLITE : ${jsonEncode(patientDetailsData)}');

    //updatedd patients details in sqflite
    await _jsonStore.setItem(
        patientDetailsData.sId, patientDetailsData.toJson());

    //save ids who data not sinked with server
    await savePatientIds(patientDetailsData.sId);
  }

  Future<PatientDetailsData> getData(String id) async {
    Map<String, dynamic> json = await _jsonStore.getItem(id);

    PatientDetailsData data =
        await json != null ? new PatientDetailsData.fromJson(json) : null;

    return data;
  }

  Future<String> clearData(String id) async {
    print('clear data from id : $id');
    await _jsonStore.setItem(id, null);
  }

  Future<String> saveUserDetails(Settingdetails settingdetails) async {
    print('save user data to SQFLITE : ${jsonEncode(settingdetails)}');
    await _jsonStore.setItem(settingdetails.data.sId, settingdetails.toJson());
    // subscriptionService.checkPlans();
  }

  Future<String> clearUserDetails(String id) async {
    print('clear user data to SQFLITE : $id');
    await _jsonStore.setItem(id, null);
  }

  Future<Settingdetails> getUserDetails(String id) async {
    Map<String, dynamic> json = await _jsonStore.getItem(id);
    Settingdetails data =
        await json != null ? new Settingdetails.fromJson(json) : null;
    print(' user data from SQFLITE : ${jsonEncode(data)}');
    return data;
  }

  Future<String> savePatientIds(String id) async {
    // print('save data to SQFLITE : ${jsonEncode(patientDetailsData)}');
    List<AllPatientIds> all_ids = [];

    await getPatientIds().then((res) {
      if (res != null) {
        all_ids.addAll(res.allPatientIds);
      }
    });

    for (var a in all_ids) {
      if (a.patientId == id) {
        all_ids.remove(a);
        break;
      }
    }

    await all_ids.add(AllPatientIds(patientId: id));

    patientIsArray pateint = await patientIsArray(allPatientIds: all_ids);

    await _jsonStore.setItem('all_ids', pateint.toJson());

    print('save all ids : ${jsonEncode(pateint)}');
  }

  Future<String> clearPatientId(String id) async {
    // print('save data to SQFLITE : ${jsonEncode(patientDetailsData)}');
    List<AllPatientIds> all_ids = [];

    await getPatientIds().then((res) {
      if (res != null) {
        all_ids.addAll(res.allPatientIds);
      }
    });

    for (var a in all_ids) {
      if (a.patientId == id) {
        all_ids.remove(a);
        break;
      }
    }

    // await all_ids.add(AllPatientIds(patientId: id));

    patientIsArray pateint = await patientIsArray(allPatientIds: all_ids);

    await _jsonStore.setItem('all_ids', pateint.toJson());

    print('save all ids : ${jsonEncode(pateint)}');
  }

  Future<patientIsArray> getPatientIds() async {
    Map<String, dynamic> json = await _jsonStore.getItem('all_ids');

    patientIsArray data =
        await json != null ? new patientIsArray.fromJson(json) : null;

    print(' user data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }

  Future<String> clearPatientIds() async {
    await _jsonStore.setItem('all_ids', null);
    return 'success';
  }

  Future<List<PatientDetailsData>> allOfflineData() async {
    List<PatientDetailsData> allOfflineData = [];
    List<AllPatientIds> patientsId = [];
    await getPatientIds().then((res) {
      if (res != null && res.allPatientIds.isNotEmpty) {
        patientsId = res.allPatientIds;
      }
    });

    for (var a in patientsId) {
      if (a.patientId != null && a.patientId != '') {
        await getData(a.patientId).then((data) {
          print('helo ${jsonEncode(data)}');
          if (data != null) {
            allOfflineData.add(data);
          }
        });
      }
    }

    print('all offline patients daata ${jsonEncode(allOfflineData)}');
    print('all offline patients daata ${allOfflineData.length}');

    return allOfflineData;
  }

  Future<String> clearAllPatients() async {
    List<AllPatientIds> patientsIds = [];
    await getPatientIds().then((res) {
      if (res != null && res.allPatientIds.isNotEmpty) {
        patientsIds = res.allPatientIds;
      }
    });

    for (var a in patientsIds) {
      if (a.patientId != null && a.patientId != '') {
        await clearData(a.patientId);
      }
    }

    await clearPatientIds();

    return 'success';
  }

  Future<String> saveLastBadge(
      String id, int lastIndex, int childIndex) async {
    LastBadges prevoius = LastBadges();

    await getLastBadge(id).then((resp) {
      if (resp != null) {
        prevoius = resp;
      }
    });
    prevoius.lastIndex = lastIndex;
    prevoius.patientId = id;
    if (lastIndex == 2) {
      prevoius.statusIndex = childIndex;
    } else if (lastIndex == 3) {
      prevoius.vigiIndex = childIndex;
    }else if (lastIndex == 4) {
      prevoius.ntIndex = childIndex ?? 0;
    }


    String modifiedId = id + 'last_badge';

    print('save last badge to SQFLITE : ${jsonEncode(prevoius)}');
    await _jsonStore.setItem(modifiedId, prevoius.toJson());
  }

  Future<LastBadges> getLastBadge(String id) async {
    String modifiedId = id + 'last_badge';

    Map<String, dynamic> json = await _jsonStore.getItem('$modifiedId');

    LastBadges lastBadges =
        await json != null ? new LastBadges.fromJson(json) : null;
    print(' last badge from SQFLITE : ${jsonEncode(lastBadges)}');

    return lastBadges;
  }
}
