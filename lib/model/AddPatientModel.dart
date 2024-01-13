import 'package:medical_app/model/SettingModel.dart';

class AddPatient {
  bool success;
  String message;
  PatientDataa data;

  AddPatient({this.success, this.message, this.data});

  AddPatient.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new PatientDataa.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PatientDataa {
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
  String sId;
  String name;
  String email;
  String phone;
  String city;
  String dob;
  String state;
  String rId;
  String bedId;
  String wardId;
  String medicalId;
  String insurance;
  String admissionDate;
  String hospitalId;
  String usertype;
  String createdAt;
  String updatedAt;

  PatientDataa(
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
        this.sId,
        this.name,
        this.email,
        this.phone,
        this.city,
        this.dob,
        this.state,
        this.rId,
        this.bedId,
        this.wardId,
        this.medicalId,
        this.insurance,
        this.admissionDate,
        this.hospitalId,
        this.usertype,
        this.createdAt,
        this.updatedAt});

  PatientDataa.fromJson(Map<String, dynamic> json) {
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
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    city = json['city'];
    dob = json['dob'];
    state = json['state'];
    rId = json['rId'];
    bedId = json['bedId'];
    wardId = json['wardId'];
    medicalId = json['medicalId'];
    insurance = json['insurance'];
    admissionDate = json['admissionDate'];
    hospitalId = json['hospitalId'];
    usertype = json['usertype'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
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
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['dob'] = this.dob;
    data['state'] = this.state;
    data['rId'] = this.rId;
    data['bedId'] = this.bedId;
    data['wardId'] = this.wardId;
    data['medicalId'] = this.medicalId;
    data['insurance'] = this.insurance;
    data['admissionDate'] = this.admissionDate;
    data['hospitalId'] = this.hospitalId;
    data['usertype'] = this.usertype;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}