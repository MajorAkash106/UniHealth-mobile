import 'package:medical_app/model/SettingModel.dart';

class Beds {
  bool success;
  String message;
  List<BedsData> data;

  Beds({this.success, this.message, this.data});

  Beds.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<BedsData>();
      json['data'].forEach((v) {
        data.add(new BedsData.fromJson(v));
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

class BedsData {
  PatientId patientId;
  bool isActive;
  bool active;
  bool isBlocked;
  String sId;
  String bedNumber;
  String wardId;
  String createdAt;
  String updatedAt;
  int iV;

  BedsData(
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

  BedsData.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'] != null
        ? new PatientId.fromJson(json['patientId'])
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




class PatientId {
  List<Hospital> hospital;
  List<Null> clients;
  bool forgotPassword;
  bool isBlocked;
  bool isClientBlocked;
  bool isAdminBlocked;
  bool isUserBlocked;
  bool isPatientBlocked;
  bool discharge;
  bool died;
  bool isNotificationBlocked;
  String scheduleDate;
  List<Null> schedules;
  List<Null> palcare;
  String sId;
  String name;
  String email;
  String phone;
  String hospitalId;
  String city;
  String state;
  String street;
  String rId;
  String dob;
  String wardId;
  String bedId;
  String medicalId;
  String insurance;
  String admissionDate;
  String usertype;
  String createdAt;
  String updatedAt;
  String gender;

  PatientId(
      {this.hospital,
        this.clients,
        this.forgotPassword,
        this.isBlocked,
        this.isClientBlocked,
        this.isAdminBlocked,
        this.isUserBlocked,
        this.isPatientBlocked,
        this.discharge,
        this.died,
        this.isNotificationBlocked,
        this.scheduleDate,
        this.schedules,
        this.palcare,
        this.sId,
        this.name,
        this.email,
        this.phone,
        this.hospitalId,
        this.city,
        this.state,
        this.street,
        this.rId,
        this.dob,
        this.wardId,
        this.bedId,
        this.medicalId,
        this.insurance,
        this.admissionDate,
        this.usertype,
        this.createdAt,
        this.updatedAt,
        this.gender});

  PatientId.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    // if (json['clients'] != null) {
    //   clients = new List<Null>();
    //   json['clients'].forEach((v) {
    //     clients.add(new Null.fromJson(v));
    //   });
    // }
    forgotPassword = json['forgotPassword'];
    isBlocked = json['isBlocked'];
    isClientBlocked = json['isClientBlocked'];
    isAdminBlocked = json['isAdminBlocked'];
    isUserBlocked = json['isUserBlocked'];
    isPatientBlocked = json['isPatientBlocked'];
    discharge = json['discharge'];
    died = json['died'];
    isNotificationBlocked = json['isNotificationBlocked'];
    scheduleDate = json['scheduleDate'];
    // if (json['schedules'] != null) {
    //   schedules = new List<Null>();
    //   json['schedules'].forEach((v) {
    //     schedules.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['palcare'] != null) {
    //   palcare = new List<Null>();
    //   json['palcare'].forEach((v) {
    //     palcare.add(new Null.fromJson(v));
    //   });
    // }
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    hospitalId = json['hospitalId'];
    city = json['city'];
    state = json['state'];
    street = json['street'];
    rId = json['rId'];
    dob = json['dob'];
    wardId = json['wardId'];
    bedId = json['bedId'];
    medicalId = json['medicalId'];
    insurance = json['insurance'];
    admissionDate = json['admissionDate'];
    usertype = json['usertype'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    gender = json['gender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    // if (this.clients != null) {
    //   data['clients'] = this.clients.map((v) => v.toJson()).toList();
    // }
    data['forgotPassword'] = this.forgotPassword;
    data['isBlocked'] = this.isBlocked;
    data['isClientBlocked'] = this.isClientBlocked;
    data['isAdminBlocked'] = this.isAdminBlocked;
    data['isUserBlocked'] = this.isUserBlocked;
    data['isPatientBlocked'] = this.isPatientBlocked;
    data['discharge'] = this.discharge;
    data['died'] = this.died;
    data['isNotificationBlocked'] = this.isNotificationBlocked;
    data['scheduleDate'] = this.scheduleDate;
    // if (this.schedules != null) {
    //   data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    // }
    // if (this.palcare != null) {
    //   data['palcare'] = this.palcare.map((v) => v.toJson()).toList();
    // }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['hospitalId'] = this.hospitalId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['street'] = this.street;
    data['rId'] = this.rId;
    data['dob'] = this.dob;
    data['wardId'] = this.wardId;
    data['bedId'] = this.bedId;
    data['medicalId'] = this.medicalId;
    data['insurance'] = this.insurance;
    data['admissionDate'] = this.admissionDate;
    data['usertype'] = this.usertype;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['gender'] = this.gender;
    return data;
  }
}