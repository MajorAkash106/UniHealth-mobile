import 'package:medical_app/model/SettingModel.dart';

class GetNotificationWard {
  bool success;
  String message;
  List<GetNotificationData> data;

  GetNotificationWard({this.success, this.message, this.data});

  GetNotificationWard.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<GetNotificationData>();
      json['data'].forEach((v) {
        data.add(new GetNotificationData.fromJson(v));
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

class GetNotificationData {
  List<Hospital> hospital;
  bool isBlocked;
  bool isNotification;
  bool isActive;
  String sId;
  String wardname;
  String userId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  GetNotificationData(
      {this.hospital,
        this.isBlocked,
        this.isNotification,
        this.isActive,
        this.sId,
        this.wardname,
        this.userId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GetNotificationData.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    isBlocked = json['isBlocked'];
    isNotification = json['isNotification'];
    isActive = json['isActive'];
    sId = json['_id'];
    wardname = json['wardname'];
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
    data['isNotification'] = this.isNotification;
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['wardname'] = this.wardname;
    data['userId'] = this.userId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

