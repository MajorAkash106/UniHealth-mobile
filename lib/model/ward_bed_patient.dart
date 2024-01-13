import 'package:medical_app/model/patientDetailsModel.dart';

class WardModel {
  bool success;
  String message;
  List<WardData> data;

  WardModel({this.success, this.message, this.data});

  WardModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<WardData>();
      json['data'].forEach((v) {
        data.add(new WardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
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
  String userId;
  String hospitalId;
  int bedsCount;
  List<Beds> beds;
  int activeBeds;
  int todayschedule;
  String createdAt;
  String updatedAt;
  int iV;

  WardData(
      {this.hospital,
        this.isBlocked,
        this.isActive,
        this.sId,
        this.wardname,
        this.userId,
        this.hospitalId,
        this.bedsCount,
        this.beds,
        this.activeBeds,
        this.todayschedule,
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
    userId = json['userId'];
    hospitalId = json['hospitalId'];
    bedsCount = json['bedsCount'];
    if (json['beds'] != null) {
      beds = new List<Beds>();
      json['beds'].forEach((v) {
        beds.add(new Beds.fromJson(v));
      });
    }
    activeBeds = json['activeBeds'];
    todayschedule = json['todayschedule'];
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
    data['userId'] = this.userId;
    data['hospitalId'] = this.hospitalId;
    data['bedsCount'] = this.bedsCount;
    if (this.beds != null) {
      data['beds'] = this.beds.map((v) => v.toJson()).toList();
    }
    data['activeBeds'] = this.activeBeds;
    data['todayschedule'] = this.todayschedule;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Hospital {
  String sId;
  String name;

  Hospital({this.sId, this.name});

  Hospital.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Beds {
  PatientDetailsData patientId;
  bool isActive;
  bool active;
  bool isBlocked;
  String sId;
  String bedNumber;
  String wardId;
  String createdAt;
  String updatedAt;
  int iV;

  Beds(
      {this.patientId,
        this.isActive,
        this.active,
        this.isBlocked,
        this.sId,
        this.bedNumber,
        this.wardId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Beds.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'] != null || json['patientId'] != ""
        ? new PatientDetailsData.fromJson(json['patientId'])
        : null;
    isActive = json['isActive'];
    active = json['Active'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    bedNumber = json['bedNumber'];
    wardId = json['wardId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.patientId != null) {
      data['patientId'] = this.patientId.toJson();
    }
    data['isActive'] = this.isActive;
    data['Active'] = this.active;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['bedNumber'] = this.bedNumber;
    data['wardId'] = this.wardId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



