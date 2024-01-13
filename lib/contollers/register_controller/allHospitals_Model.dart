class AllHospitalModel {
  bool success;
  String message;
  List<AllHoispitals> data;

  AllHospitalModel({this.success, this.message, this.data});

  AllHospitalModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AllHoispitals>();
      json['data'].forEach((v) {
        data.add(new AllHoispitals.fromJson(v));
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

class AllHoispitals {
  // List<Users> users;
  // List<Admin> admin;
  String workdays;
  bool isBlocked;
  bool isSelected;
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

  AllHoispitals(
      {
      //   this.users,
      // this.admin,
      this.workdays,
      this.isBlocked,
      this.isSelected,
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

  AllHoispitals.fromJson(Map<String, dynamic> json) {
    // if (json['users'] != null) {
    //   users = new List<Users>();
    //   json['users'].forEach((v) {
    //     users.add(new Users.fromJson(v));
    //   });
    // }
    // if (json['admin'] != null) {
    //   admin = new List<Admin>();
    //   json['admin'].forEach((v) {
    //     admin.add(new Admin.fromJson(v));
    //   });
    // }
    workdays = json['workdays'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
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
    // if (this.users != null) {
    //   data['users'] = this.users.map((v) => v.toJson()).toList();
    // }
    // if (this.admin != null) {
    //   data['admin'] = this.admin.map((v) => v.toJson()).toList();
    // }
    data['workdays'] = this.workdays;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
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
  List<Null> payments;
  List<Hospital> hospital;
  List<Null> clients;
  List<Null> ntdata;
  bool isVerifed;
  bool forgotPassword;
  bool isInfoBlocked;
  bool isBlocked;
  bool isClientBlocked;
  bool isAdminBlocked;
  bool isUserBlocked;
  bool isPatientBlocked;
  bool discharge;
  bool died;
  bool isNotificationBlocked;
  String scheduleDate;
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
  Null deviceId;

  Users(
      {this.payments,
      this.hospital,
      this.clients,
      this.ntdata,
      this.isVerifed,
      this.forgotPassword,
      this.isInfoBlocked,
      this.isBlocked,
      this.isClientBlocked,
      this.isAdminBlocked,
      this.isUserBlocked,
      this.isPatientBlocked,
      this.discharge,
      this.died,
      this.isNotificationBlocked,
      this.scheduleDate,
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
      this.updatedAt,
      this.deviceId});

  Users.fromJson(Map<String, dynamic> json) {
    isVerifed = json['isVerifed'];
    forgotPassword = json['forgotPassword'];
    isInfoBlocked = json['isInfoBlocked'];
    isBlocked = json['isBlocked'];
    isClientBlocked = json['isClientBlocked'];
    isAdminBlocked = json['isAdminBlocked'];
    isUserBlocked = json['isUserBlocked'];
    isPatientBlocked = json['isPatientBlocked'];
    discharge = json['discharge'];
    died = json['died'];
    isNotificationBlocked = json['isNotificationBlocked'];
    scheduleDate = json['scheduleDate'];

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
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['isVerifed'] = this.isVerifed;
    data['forgotPassword'] = this.forgotPassword;
    data['isInfoBlocked'] = this.isInfoBlocked;
    data['isBlocked'] = this.isBlocked;
    data['isClientBlocked'] = this.isClientBlocked;
    data['isAdminBlocked'] = this.isAdminBlocked;
    data['isUserBlocked'] = this.isUserBlocked;
    data['isPatientBlocked'] = this.isPatientBlocked;
    data['discharge'] = this.discharge;
    data['died'] = this.died;
    data['isNotificationBlocked'] = this.isNotificationBlocked;
    data['scheduleDate'] = this.scheduleDate;

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
    data['deviceId'] = this.deviceId;
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

class Admin {
  List<Null> payments;
  List<Hospital> hospital;

  List<Null> ntdata;
  bool isVerifed;
  bool forgotPassword;
  bool isInfoBlocked;
  bool isBlocked;
  bool isClientBlocked;
  bool isAdminBlocked;
  bool isUserBlocked;
  bool isPatientBlocked;
  bool discharge;
  bool died;
  bool isNotificationBlocked;
  String scheduleDate;
  List<Null> badges;
  List<Null> schedules;
  List<Null> diagnosis;
  List<Null> palcare;
  List<Null> status;
  List<Null> anthropometry;
  List<Null> vigilance;
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
  String deviceId;

  Admin(
      {this.payments,
      this.hospital,
      this.ntdata,
      this.isVerifed,
      this.forgotPassword,
      this.isInfoBlocked,
      this.isBlocked,
      this.isClientBlocked,
      this.isAdminBlocked,
      this.isUserBlocked,
      this.isPatientBlocked,
      this.discharge,
      this.died,
      this.isNotificationBlocked,
      this.scheduleDate,
      this.badges,
      this.schedules,
      this.diagnosis,
      this.palcare,
      this.status,
      this.anthropometry,
      this.vigilance,
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
      this.updatedAt,
      this.deviceId});

  Admin.fromJson(Map<String, dynamic> json) {
    isVerifed = json['isVerifed'];
    forgotPassword = json['forgotPassword'];
    isInfoBlocked = json['isInfoBlocked'];
    isBlocked = json['isBlocked'];
    isClientBlocked = json['isClientBlocked'];
    isAdminBlocked = json['isAdminBlocked'];
    isUserBlocked = json['isUserBlocked'];
    isPatientBlocked = json['isPatientBlocked'];
    discharge = json['discharge'];
    died = json['died'];
    isNotificationBlocked = json['isNotificationBlocked'];
    scheduleDate = json['scheduleDate'];
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
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['isVerifed'] = this.isVerifed;
    data['forgotPassword'] = this.forgotPassword;
    data['isInfoBlocked'] = this.isInfoBlocked;
    data['isBlocked'] = this.isBlocked;
    data['isClientBlocked'] = this.isClientBlocked;
    data['isAdminBlocked'] = this.isAdminBlocked;
    data['isUserBlocked'] = this.isUserBlocked;
    data['isPatientBlocked'] = this.isPatientBlocked;
    data['discharge'] = this.discharge;
    data['died'] = this.died;
    data['isNotificationBlocked'] = this.isNotificationBlocked;
    data['scheduleDate'] = this.scheduleDate;

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
    data['deviceId'] = this.deviceId;
    return data;
  }
}
