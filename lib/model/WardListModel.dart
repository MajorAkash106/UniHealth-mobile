import 'package:medical_app/model/BedsListModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/offline_mode/offline_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class WardList {
  bool success;
  String message;
  String lastSync;
  List<WardData> data;
  List<PatientDetailsData> patients;
  Offline offline;


  WardList({this.success, this.message, this.data,this.lastSync,this.offline});

  WardList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    lastSync = json['last_sync'];
    if (json['data'] != null) {
      data = new List<WardData>();
      json['data'].forEach((v) {
        data.add(new WardData.fromJson(v));
      });
    }
    if (json['patients'] != null) {
      patients = new List<PatientDetailsData>();
      json['patients'].forEach((v) {
        patients.add(new PatientDetailsData.fromJson(v));
      });
    }
    offline =
    json['offline'] != null ? new Offline.fromJson(json['offline']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['last_sync'] = this.lastSync;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.patients != null) {
      data['patients'] = this.patients.map((v) => v.toJson()).toList();
    }
    if (this.offline != null) {
      data['offline'] = this.offline.toJson();
    }
    return data;
  }
}

class WardData {
  List<Hospital> hospital;
  bool isBlocked;
  bool isActive;
  String sId;
  String wardname;
  String bedsCount;
  List<BedsData> beds;
  String activeBeds;
  String todayschedule;
  String userId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  WardData(
      {this.hospital,
        this.isBlocked,
        this.isActive,
        this.sId,
        this.wardname,
        this.bedsCount,  this.beds,
        this.activeBeds,
        this.todayschedule,
        this.userId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  WardData.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    isBlocked = json['isBlocked'];
    isActive = json['isActive'];
    sId = json['_id'];
    wardname = json['wardname'];
    bedsCount = json['bedsCount'].toString();

    if (json['beds'] != null) {
      beds = new List<BedsData>();
      json['beds'].forEach((v) {
        beds.add(new BedsData.fromJson(v));
      });
    }

    activeBeds = json['activeBeds'].toString();
    todayschedule = json['todayschedule'].toString();
    userId = json['userId'];
    hospitalId = json['hospitalId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    data['isBlocked'] = this.isBlocked;
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['wardname'] = this.wardname;
    data['bedsCount'] = this.bedsCount;

    if (this.beds != null) {
      data['beds'] = this.beds.map((v) => v.toJson()).toList();
    }

    data['activeBeds'] = this.activeBeds;
    data['todayschedule'] =this.todayschedule;
    data['userId'] = this.userId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

