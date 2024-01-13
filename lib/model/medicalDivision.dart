import 'package:medical_app/model/SettingModel.dart';

class MedicalDivision {
  bool success;
  String message;
  List<MedicalDivisionData> data;

  MedicalDivision({this.success, this.message, this.data});

  MedicalDivision.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<MedicalDivisionData>();
      json['data'].forEach((v) {
        data.add(new MedicalDivisionData.fromJson(v));
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

class MedicalDivisionData {
  List<Hospital> hospital;
  List<String> availableIn;
  bool isBlocked;
  String sId;
  String division;
  String hospitalId;
  String hospitalname;
  String createdAt;
  String updatedAt;
  int iV;

  MedicalDivisionData(
      {this.hospital,
        this.availableIn,
        this.isBlocked,
        this.sId,
        this.division,
        this.hospitalId,
        this.hospitalname,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MedicalDivisionData.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    availableIn = json['availableIn'].cast<String>();
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    division = json['division'];
    hospitalId = json['hospitalId'];
    hospitalname = json['hospitalname'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    data['availableIn'] = this.availableIn;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['division'] = this.division;
    data['hospitalId'] = this.hospitalId;
    data['hospitalname'] = this.hospitalname;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}