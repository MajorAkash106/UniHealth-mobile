import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

class PatientList {
  bool success;
  String message;
  List<PatientData> data;

  PatientList({this.success, this.message, this.data});

  PatientList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<PatientData>();
      json['data'].forEach((v) {
        data.add(new PatientData.fromJson(v));
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

// class PatientData {
//   List<Hospitall> hospital;
//   // List<Null> clients;
//   bool forgotPassword;
//   bool isBlocked;
//   bool isClientBlocked;
//   bool isAdminBlocked;
//   bool isUserBlocked;
//   bool isPatientBlocked;
//   bool discharge;
//   bool died;
//   String sId;
//   String name;
//   String email;
//   String usertype;
//   String phone;
//   String dob;
//   String state;
//   String city;
//   String hospitalId;
//   String rId;
//   String admissionDate;
//   MedicalId medicalId;
//   WardId wardId;
//   BedId bedId;
//   String insurance;
//   String createdAt;
//   String updatedAt;
//
//   PatientData(
//       {this.hospital,
//         // this.clients,
//         this.forgotPassword,
//         this.isBlocked,
//         this.isClientBlocked,
//         this.isAdminBlocked,
//         this.isUserBlocked,
//         this.isPatientBlocked,
//         this.discharge,
//         this.died,
//         this.sId,
//         this.name,
//         this.email,
//         this.usertype,
//         this.phone,
//         this.dob,
//         this.state,
//         this.city,
//         this.hospitalId,
//         this.rId,
//         this.admissionDate,
//         this.medicalId,
//         this.wardId,
//         this.bedId,
//         this.insurance,
//         this.createdAt,
//         this.updatedAt});
//
//   PatientData.fromJson(Map<String, dynamic> json) {
//     if (json['hospital'] != null) {
//       hospital = new List<Hospitall>();
//       json['hospital'].forEach((v) {
//         hospital.add(new Hospitall.fromJson(v));
//       });
//     }
//     // if (json['clients'] != null) {
//     //   clients = new List<Null>();
//     //   json['clients'].forEach((v) {
//     //     clients.add(new Null.fromJson(v));
//     //   });
//     // }
//     forgotPassword = json['forgotPassword'];
//     isBlocked = json['isBlocked'];
//     isClientBlocked = json['isClientBlocked'];
//     isAdminBlocked = json['isAdminBlocked'];
//     isUserBlocked = json['isUserBlocked'];
//     isPatientBlocked = json['isPatientBlocked'];
//     discharge = json['discharge'];
//     died = json['died'];
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     usertype = json['usertype'];
//     phone = json['phone'];
//     dob = json['dob'];
//     state = json['state'];
//     city = json['city'];
//     hospitalId = json['hospitalId'];
//     rId = json['rId'];
//     admissionDate = json['admissionDate'];
//     medicalId = json['medicalId'] != null
//         ? new MedicalId.fromJson(json['medicalId'])
//         : null;
//     wardId =
//     json['wardId'] != null ? new WardId.fromJson(json['wardId']) : null;
//     bedId = json['bedId'] != null ? new BedId.fromJson(json['bedId']) : null;
//     insurance = json['insurance'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.hospital != null) {
//       data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
//     }
//     // if (this.clients != null) {
//     //   data['clients'] = this.clients.map((v) => v.toJson()).toList();
//     // }
//     data['forgotPassword'] = this.forgotPassword;
//     data['isBlocked'] = this.isBlocked;
//     data['isClientBlocked'] = this.isClientBlocked;
//     data['isAdminBlocked'] = this.isAdminBlocked;
//     data['isUserBlocked'] = this.isUserBlocked;
//     data['isPatientBlocked'] = this.isPatientBlocked;
//     data['discharge'] = this.discharge;
//     data['died'] = this.died;
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['usertype'] = this.usertype;
//     data['phone'] = this.phone;
//     data['dob'] = this.dob;
//     data['state'] = this.state;
//     data['city'] = this.city;
//     data['hospitalId'] = this.hospitalId;
//     data['rId'] = this.rId;
//     data['admissionDate'] = this.admissionDate;
//     if (this.medicalId != null) {
//       data['medicalId'] = this.medicalId.toJson();
//     }
//     if (this.wardId != null) {
//       data['wardId'] = this.wardId.toJson();
//     }
//     if (this.bedId != null) {
//       data['bedId'] = this.bedId.toJson();
//     }
//     data['insurance'] = this.insurance;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     return data;
//   }
// }
class PatientData {
  List<Hospital> hospital;
  // List<Null> clients;
  List<Diagnosis> diagnosis;
  List<Anthropometry> anthropometry;
  List<Ntdata> ntdata;

  int statusIndex;

  bool forgotPassword;
  bool isBlocked;
  bool isClientBlocked;
  bool isAdminBlocked;
  bool isUserBlocked;
  bool isPatientBlocked;
  bool discharge;
  bool died;
  List<Palcare> palcare;
  List<StatusData> status;
  String sId;
  String name;
  String gender;
  String email;
  String phone;
  String scheduleDate;
  String city;
  String dob;
  String state;
  String rId;
  BedId bedId;
  WardId wardId;
  MedicalId medicalId;
  String insurance;
  String admissionDate;
  String hospitalId;
  String usertype;
  String createdAt;
  String updatedAt;

  PatientData(
      {
        this.hospital,
        this.diagnosis,
        // this.clients,
        this.statusIndex,
        this.ntdata,
        this.forgotPassword,
        this.isBlocked,
        this.isClientBlocked,
        this.isAdminBlocked,
        this.isUserBlocked,
        this.isPatientBlocked,
        this.discharge,
        this.palcare,
        this.status,
        this.anthropometry,
        this.died,
        this.sId,
        this.name,
        this.gender,
        this.email,
        this.phone,
        this.scheduleDate,
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

  PatientData.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    if (json['palcare'] != null) {
      palcare = new List<Palcare>();
      json['palcare'].forEach((v) {
        palcare.add(new Palcare.fromJson(v));
      });
    }

    if (json['status'] != null) {
      status = new List<StatusData>();
      json['status'].forEach((v) {
        status.add(new StatusData.fromJson(v));
      });
    }

    if (json['diagnosis'] != null) {
      diagnosis = new List<Diagnosis>();
      json['diagnosis'].forEach((v) {
        diagnosis.add(new Diagnosis.fromJson(v));
      });
    }

    if (json['anthropometry'] != null) {
      anthropometry = new List<Anthropometry>();
      json['anthropometry'].forEach((v) {
        anthropometry.add(new Anthropometry.fromJson(v));
      });
    }
    if (json['ntdata'] != null) {
      ntdata = new List<Ntdata>();
      json['ntdata'].forEach((v) {
        ntdata.add(new Ntdata.fromJson(v));
      });
    }

    // if (json['clients'] != null) {
    //   clients = new List<Null>();
    //   json['clients'].forEach((v) {
    //     clients.add(new Null.fromJson(v));
    //   });
    // }
    statusIndex = json['statusIndex'] ?? 0;
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
    gender = json['gender'];
    email = json['email'];
    scheduleDate = json['scheduleDate'];
    phone = json['phone'];
    city = json['city'];
    dob = json['dob'];
    state = json['state'];
    rId = json['rId'];
    bedId = json['bedId'] != null ? new BedId.fromJson(json['bedId']) : null;
    wardId =
    json['wardId'] != null ? new WardId.fromJson(json['wardId']) : null;
    medicalId = json['medicalId'] != null
        ? new MedicalId.fromJson(json['medicalId'])
        : null;
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
    if (this.palcare != null) {
      data['palcare'] = this.palcare.map((v) => v.toJson()).toList();
    }
    if (this.status != null) {
      data['status'] = this.status.map((v) => v.toJson()).toList();
    }
    if (this.diagnosis != null) {
      data['diagnosis'] = this.diagnosis.map((v) => v.toJson()).toList();
    }
    if (this.anthropometry != null) {
      data['anthropometry'] =
          this.anthropometry.map((v) => v.toJson()).toList();
    }
    if (this.ntdata != null) {
      data['ntdata'] = this.ntdata.map((v) => v.toJson()).toList();
    }
    // if (this.clients != null) {
    //   data['clients'] = this.clients.map((v) => v.toJson()).toList();
    // }
    data['statusIndex'] = this.statusIndex;
    data['forgotPassword'] = this.forgotPassword;
    data['isBlocked'] = this.isBlocked;
    data['isClientBlocked'] = this.isClientBlocked;
    data['isAdminBlocked'] = this.isAdminBlocked;
    data['isUserBlocked'] = this.isUserBlocked;
    data['isPatientBlocked'] = this.isPatientBlocked;
    data['discharge'] = this.discharge;
    data['scheduleDate'] = this.scheduleDate;
    data['died'] = this.died;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['city'] = this.city;
    data['dob'] = this.dob;
    data['state'] = this.state;
    data['rId'] = this.rId;
    if (this.bedId != null) {
      data['bedId'] = this.bedId.toJson();
    }
    if (this.wardId != null) {
      data['wardId'] = this.wardId.toJson();
    }
    if (this.medicalId != null) {
      data['medicalId'] = this.medicalId.toJson();
    }
    data['insurance'] = this.insurance;
    data['admissionDate'] = this.admissionDate;
    data['hospitalId'] = this.hospitalId;
    data['usertype'] = this.usertype;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}



class MedicalId {
  List<Hospitall> hospital;
  bool isBlocked;
  String sId;
  String division;
  String hospitalId;
  String hospitalname;
  String createdAt;
  String updatedAt;
  int iV;

  MedicalId(
      {this.hospital,
        this.isBlocked,
        this.sId,
        this.division,
        this.hospitalId,
        this.hospitalname,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MedicalId.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospitall>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospitall.fromJson(v));
      });
    }
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

class Hospitall {
  String sId;
  String name;

  Hospitall({this.sId, this.name});

  Hospitall.fromJson(Map<String, dynamic> json) {
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

class WardId {
  List<Hospitall> hospital;
  bool isBlocked;
  bool isActive;
  String sId;
  String wardname;
  String userId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  WardId(
      {this.hospital,
        this.isBlocked,
        this.isActive,
        this.sId,
        this.wardname,
        this.userId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  WardId.fromJson(Map<String, dynamic> json) {
    if (json['hospital'] != null) {
      hospital = new List<Hospitall>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospitall.fromJson(v));
      });
    }
    isBlocked = json['isBlocked'];
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

class BedId {
  bool isActive;
  bool active;
  bool isBlocked;
  String sId;
  String bedNumber;
  String wardId;
  String createdAt;
  String updatedAt;
  int iV;

  BedId(
      {this.isActive,
        this.active,
        this.isBlocked,
        this.sId,
        this.bedNumber,
        this.wardId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  BedId.fromJson(Map<String, dynamic> json) {
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