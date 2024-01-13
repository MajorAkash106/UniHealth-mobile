import 'package:medical_app/model/SettingModel.dart';

class HospitalDetails {
  bool success;
  String message;
  List<HospitalAllDetails> data;

  HospitalDetails({this.success, this.message, this.data});

  HospitalDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<HospitalAllDetails>();
      json['data'].forEach((v) {
        data.add(new HospitalAllDetails.fromJson(v));
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

class HospitalAllDetails {
  List<Users> users;
  List<Null> admin;
  bool isBlocked;
  String sId;
  String name;
  String hospitalgroup;
  String phone;
  String cpnj;
  String country;
  String state;
  String city;
  String street;
  String number;
  int remdomId;
  String createdAt;
  String updatedAt;
  int iV;

  HospitalAllDetails(
      {this.users,
        this.admin,
        this.isBlocked,
        this.sId,
        this.name,
        this.hospitalgroup,
        this.phone,
        this.cpnj,
        this.country,
        this.state,
        this.city,
        this.street,
        this.number,
        this.remdomId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  HospitalAllDetails.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
    // if (json['admin'] != null) {
    //   admin = new List<Null>();
    //   json['admin'].forEach((v) {
    //     admin.add(new Null.fromJson(v));
    //   });
    // }
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    name = json['name'];
    hospitalgroup = json['hospitalgroup'];
    phone = json['phone'];
    cpnj = json['cpnj'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    street = json['street'];
    number = json['number'];
    remdomId = json['remdomId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    // if (this.admin != null) {
    //   data['admin'] = this.admin.map((v) => v.toJson()).toList();
    // }
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['hospitalgroup'] = this.hospitalgroup;
    data['phone'] = this.phone;
    data['cpnj'] = this.cpnj;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['street'] = this.street;
    data['number'] = this.number;
    data['remdomId'] = this.remdomId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Users {
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
  String usertype;
  String phone;
  String cpnj;
  String licenseExpDate;
  String country;
  String state;
  String city;
  String street;
  String number;
  String createdAt;
  String updatedAt;

  Users(
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
        this.usertype,
        this.phone,
        this.cpnj,
        this.licenseExpDate,
        this.country,
        this.state,
        this.city,
        this.street,
        this.number,
        this.createdAt,
        this.updatedAt});

  Users.fromJson(Map<String, dynamic> json) {
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
    usertype = json['usertype'];
    phone = json['phone'];
    cpnj = json['cpnj'];
    licenseExpDate = json['licenseExpDate'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    street = json['street'];
    number = json['number'];
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
    data['usertype'] = this.usertype;
    data['phone'] = this.phone;
    data['cpnj'] = this.cpnj;
    data['licenseExpDate'] = this.licenseExpDate;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['street'] = this.street;
    data['number'] = this.number;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}