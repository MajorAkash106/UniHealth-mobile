import 'dart:convert';

import 'package:json_store/json_store.dart';
import 'package:medical_app/contollers/sqflite/model/filter_ward_medical.dart';
import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/WardListModel.dart';
import 'package:medical_app/model/hospitalListModel.dart';
import 'package:medical_app/model/medicalDivision.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class HospitalSqflite {
  final _jsonStore = JsonStore(dbName: 'hospital_data');


  Future<String> saveHospitals(HospitalsListDetails hospitalsListDetails) async {

    print('update hosiptal data in SQFLITE : ${jsonEncode(hospitalsListDetails)}');

    await _jsonStore.setItem('all_hospitals', hospitalsListDetails.toJson());

  }

  Future<HospitalsListDetails> getHospitals() async {

    Map<String, dynamic> json = await _jsonStore.getItem('all_hospitals');

    HospitalsListDetails data = await json != null ? new HospitalsListDetails.fromJson(json) : null;

    print('hospital data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }


  Future<String> saveWard(WardList data,String hospId) async {

    data.lastSync = "${DateTime.now()}";
    print('update ward data in SQFLITE : ${jsonEncode(data)}');

    await _jsonStore.setItem(hospId, data.toJson());

  }

  Future<WardList> getWards(String hospId) async {

    Map<String, dynamic> json = await _jsonStore.getItem(hospId);

    WardList data = await json != null ? new WardList.fromJson(json) : null;

    print('ward data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }

  Future<String> saveBeds(Beds data,String wardId) async {

    print('update beds data in SQFLITE : ${jsonEncode(data)}');

    await _jsonStore.setItem(wardId, data.toJson());

  }

  Future<Beds> getBeds(String wardId) async {

    Map<String, dynamic> json = await _jsonStore.getItem(wardId);

    Beds data = await json != null ? new Beds.fromJson(json) : null;

    print('beds data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }



  Future<String> savePatients(PatientList data) async {

    print('patients list data in SQFLITE : ${jsonEncode(data)}');

    await _jsonStore.setItem('all_patients', data.toJson());

  }


  Future<PatientList> getPatients() async {

    Map<String, dynamic> json = await _jsonStore.getItem('all_patients');

    PatientList data = await json != null ? new PatientList.fromJson(json) : null;

    print('patients list from SQFLITE : ${jsonEncode(data)}');

    return data;
  }



  Future<String> saveMedical(MedicalDivision data,String hospId) async {

    print('update android data in SQFLITE : ${jsonEncode(data)}');
    String keyName = hospId + "_medicalDivision";

    await _jsonStore.setItem(keyName, data.toJson());

  }


  Future<MedicalDivision> getMedical(String hospId) async {
    String keyName = hospId + "_medicalDivision";

    Map<String, dynamic> json = await _jsonStore.getItem(keyName);

    MedicalDivision data = await json != null ? new MedicalDivision.fromJson(json) : null;

    print('android data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }



  Future<String> saveOnlyWards(WardList data,String hospId) async {

    print('update only wards data in SQFLITE : ${jsonEncode(data)}');
    String keyName = hospId + "_saveOnlyWard";

    await _jsonStore.setItem(keyName, data.toJson());

  }


  Future<WardList> getOnlyWards(String hospId) async {
    String keyName = hospId + "_saveOnlyWard";

    Map<String, dynamic> json = await _jsonStore.getItem(keyName);

    WardList data = await json != null ? new WardList.fromJson(json) : null;

    print('ward data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }


  Future<String> saveFilteredStatus(String id,FilterWardMedical data) async {

    print('update android data in SQFLITE : ${jsonEncode(data)}');
    String keyName = id + "_statusWardMedical";

    await _jsonStore.setItem(keyName, data.toJson());

  }

  Future<FilterWardMedical> getFilteredStatus(String id) async {
    String keyName = id + "_statusWardMedical";

    Map<String, dynamic> json = await _jsonStore.getItem(keyName);

    FilterWardMedical data = await json != null ? new FilterWardMedical.fromJson(json) : null;

    print('ward data from SQFLITE : ${jsonEncode(data)}');

    return data;
  }


}
