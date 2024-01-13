import 'package:medical_app/model/handle_access/handle_access.dart';
import 'package:medical_app/model/register_controller/payment_model.dart';

class Settingdetails {
  bool success;
  String message;
  String currentdate;
  Data data;

  Settingdetails({this.success, this.currentdate ,this.message, this.data});

  Settingdetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    currentdate = json['currentdate'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['currentdate'] = this.currentdate;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String deviceId;
  bool forgotPassword;
  bool isNotificationBlocked;
  String gender;
  String avatar;
  String address;
  dynamic latitude;
  dynamic longitude;
  bool isBlocked;
  bool isDeleted;
  bool loggedIn;
  bool isdocVerifed;
  int isdocStatus;
  int docVerification;
  String socialId;
  String sId;
  String name;
  String email;
  String city;
  String state;
  String phone;
  String createdAt;
  String updatedAt;
  List<Hospital> hospital;

  // badges  -  attribution_info
  // in object>>
  // badges -  access_info
  // skills - name
  // checked - access
  //
  List<AttributionInfo> attributionInfo;
  List<Payments> payments;

  Data(
      {this.deviceId,
        this.forgotPassword,this.isNotificationBlocked,
        this.gender,
        this.avatar,
        this.city,this.state,
        this.address,
        this.latitude,
        this.longitude,
        this.isBlocked,
        this.isDeleted,
        this.loggedIn,this.isdocVerifed,this.isdocStatus,this.docVerification,
        this.socialId,
        this.sId,
        this.name,
        this.email,
        this.phone,
        this.createdAt,this.attributionInfo,this.payments,
        this.updatedAt,this.hospital});

  Data.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    forgotPassword = json['forgotPassword'];
    isNotificationBlocked = json['isNotificationBlocked'];
    gender = json['gender'];
    avatar = json['avatar'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isBlocked = json['isBlocked'];
    isdocVerifed = json['isdocVerifed'];
    isdocStatus = json['isdocStatus'];
    docVerification = json['docVerification'];
    isDeleted = json['isDeleted'];
    loggedIn = json['loggedIn'];
    socialId = json['socialId'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    if (json['badges'] != null) {
      attributionInfo = new List<AttributionInfo>();
      json['badges'].forEach((v) {
        attributionInfo.add(new AttributionInfo.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = new List<Payments>();
      json['payments'].forEach((v) {
        payments.add(new Payments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['forgotPassword'] = this.forgotPassword;
    data['isNotificationBlocked'] = this.isNotificationBlocked;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isBlocked'] = this.isBlocked;
    data['isdocVerifed'] = this.isdocVerifed;
    data['isdocStatus'] = this.isdocStatus;
    data['docVerification'] = this.docVerification;
    data['isDeleted'] = this.isDeleted;
    data['loggedIn'] = this.loggedIn;
    data['socialId'] = this.socialId;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    if (this.attributionInfo != null) {
      data['badges'] = this.attributionInfo.map((v) => v.toJson()).toList();
    }
    if (this.payments != null) {
      data['payments'] = this.payments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Hospital {
  String sId;
  String name;
  int verificationStatus;
  String admissionDatee;
  String diagnosis;
  String diagnosisLastUpdate;
  String observation;
  String observationLastUpdate;
  Hospital({this.sId, this.name,this.admissionDatee,this.diagnosis,this.diagnosisLastUpdate,
    this.observation,this.observationLastUpdate,this.verificationStatus
  });

  Hospital.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    admissionDatee = json['admissionDate'];
    diagnosis = json['diagnosis'];
    diagnosisLastUpdate = json['diagnosisLastUpdate'];
    verificationStatus = json['verificationStatus'];
    observation = json['observation'];
    observationLastUpdate = json['observationLastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['admissionDate'] = this.admissionDatee;
    data['diagnosis'] = this.diagnosis;
    data['diagnosisLastUpdate'] = this.diagnosisLastUpdate;
    data['verificationStatus'] = this.verificationStatus;
    data['observation'] = this.observation;
    data['observationLastUpdate'] = this.observationLastUpdate;
    return data;
  }
}


class HospitalObject {
  String sId;
  String name;
  String admissionDatee;

  HospitalObject({this.sId, this.name,this.admissionDatee});

  HospitalObject.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    admissionDatee = json['admissionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['admissionDate'] = this.admissionDatee;
    return data;
  }
}