import 'package:medical_app/contollers/akpsModel.dart';
import 'package:medical_app/model/NRS_model.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/needs.dart';
import 'package:medical_app/model/SettingModel.dart';
import 'package:medical_app/model/spictDataModel.dart';
import 'package:medical_app/model/vigilance/vigilance_model.dart';
import 'package:medical_app/screens/badges/NutritionalTherapy/enteralNutritional/infusionReportModel.dart' as infusion;

class PatientDetails {
  bool success;
  String message;
  PatientDetailsData data;

  PatientDetails({this.success, this.message, this.data});

  PatientDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? new PatientDetailsData.fromJson(json['data'])
        : null;
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

class PatientDetailsData {
  List<Hospital> hospital;
  // List<Null> clients;
  List<Diagnosis> diagnosis;
  List<Anthropometry> anthropometry;
  List<Ntdata> ntdata;
  List<Needs> needs;
  List<Vigilance> vigilance;

  List<infusion.Data> enteralFormula;
  List<infusion.Data> parenteralFormula;

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
  String admissionTime;
  String hospitalId;
  String usertype;
  String createdAt;
  String updatedAt;

  PatientDetailsData(
      {
        this.hospital,
      this.diagnosis,
      // this.clients,
      this.statusIndex,this.vigilance,this.needs,
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
      this.enteralFormula,
      this.parenteralFormula,
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
      this.admissionTime,
      this.hospitalId,
      this.usertype,
      this.createdAt,
      this.updatedAt});

  PatientDetailsData.fromJson(Map<String, dynamic> json) {
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

    if (json['vigilance'] != null) {
      vigilance = new List<Vigilance>();
      json['vigilance'].forEach((v) {
        vigilance.add(new Vigilance.fromJson(v));
      });
    }

    if (json['enteral_formula'] != null) {
      enteralFormula = new List<infusion.Data>();
      json['enteral_formula'].forEach((v) {
        enteralFormula.add(new infusion.Data.fromJson(v));
      });
    }

    if (json['parenteral_formula'] != null) {
      parenteralFormula = new List<infusion.Data>();
      json['parenteral_formula'].forEach((v) {
        parenteralFormula.add(new infusion.Data.fromJson(v));
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
    if (json['needs'] != null) {
      needs = new List<Needs>();
      json['needs'].forEach((v) {
        needs.add(new Needs.fromJson(v));
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
    admissionTime = json['admissionTime'];
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

    if (this.needs != null) {
      data['needs'] = this.needs.map((v) => v.toJson()).toList();
    }

    if (this.vigilance != null) {
      data['vigilance'] = this.vigilance.map((v) => v.toJson()).toList();
    }
    if (this.enteralFormula != null) {
      data['enteral_formula'] = this.enteralFormula.map((v) => v.toJson()).toList();
    }
    if (this.parenteralFormula != null) {
      data['parenteral_formula'] = this.parenteralFormula.map((v) => v.toJson()).toList();
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
    data['admissionTime'] = this.admissionTime;
    data['hospitalId'] = this.hospitalId;
    data['usertype'] = this.usertype;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class BedId {
  String patientId;
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

  BedId.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
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
    data['patientId'] = this.patientId;
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

class WardId {
  List<Hospital> hospital;
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

class MedicalId {
  List<Hospital> hospital;
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
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
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

class Palcare {
  String palcare;
  String status;
  String categoryId;
  String lastUpdate;
  AKPSData akps;
  List<AKPSData> goals;
  List<SpictQuestion> spictData;
  List<AKPSData> clinicalData;

  Palcare(
      {this.palcare,
      this.akps,
      this.goals,
      this.spictData,
      this.clinicalData,
      this.categoryId});

  Palcare.fromJson(Map<String, dynamic> json) {
    palcare = json['palcare'];
    status = json['status'];
    categoryId = json['categoryId'];
    lastUpdate = json['lastUpdate'];
    akps = json['akps'] != null ? new AKPSData.fromJson(json['akps']) : null;
    if (json['goals'] != null) {
      goals = new List<AKPSData>();
      json['goals'].forEach((v) {
        goals.add(new AKPSData.fromJson(v));
      });
    }
    if (json['spictData'] != null) {
      spictData = new List<SpictQuestion>();
      json['spictData'].forEach((v) {
        spictData.add(new SpictQuestion.fromJson(v));
      });
    }
    if (json['clinicalData'] != null) {
      clinicalData = new List<AKPSData>();
      json['clinicalData'].forEach((v) {
        clinicalData.add(new AKPSData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['palcare'] = this.palcare;
    data['status'] = this.status;
    data['categoryId'] = this.categoryId;
    data['lastUpdate'] = this.lastUpdate;
    if (this.akps != null) {
      data['akps'] = this.akps.toJson();
    }
    if (this.goals != null) {
      data['goals'] = this.goals.map((v) => v.toJson()).toList();
    }
    if (this.spictData != null) {
      data['spictData'] = this.spictData.map((v) => v.toJson()).toList();
    }
    if (this.clinicalData != null) {
      data['clinicalData'] = this.clinicalData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diagnosis {
  String lastUpdate;
  List<CidData> cidData;

  Diagnosis({this.lastUpdate,
    this.cidData
  });

  Diagnosis.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    if (json['cidData'] != null) {
      cidData = new List<CidData>();
      json['cidData'].forEach((v) {
        cidData.add(new CidData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.cidData != null) {
      data['cidData'] = this.cidData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CidData {
  String cidname;
  bool isBlocked;
  bool isSelected;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  CidData(
      {this.cidname,
      this.isBlocked,
      this.isSelected,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CidData.fromJson(Map<String, dynamic> json) {
    cidname = json['cidname'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'];
    sId = json['_id'];
    createdAt = json['createdAt']??'';
    updatedAt = json['updatedAt']??'';
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidname'] = this.cidname;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class StatusData {
  List<Result> result;
  String score;
  String status;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  StatusData(
      {this.result,
      this.score,
      this.status,
      this.type,
      this.isBlocked,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  StatusData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
    score = json['score'];
    status = json['status'];
    type = json['type'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['score'] = this.score;
    data['status'] = this.status;
    data['type'] = this.type;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Result {
  String status;
  String lastUpdate;
  String nextSchdule;
  String dataText;
  String espen_output;
  String who_output;
  String cdc_output;
  List<NRSListData> data;

  Etiologic etiologic;
  Severity severity;
  Phenotypic phenotypic;

  bool uNINTENTIONALWEIGHT;

  Result(
      {this.status,
      this.lastUpdate,
      this.dataText,
      this.espen_output,
      this.who_output,
      this.cdc_output,
      this.data,
      this.nextSchdule,
      this.etiologic,
      this.severity,
      this.phenotypic,
      this.uNINTENTIONALWEIGHT});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    dataText = json['dataText'];
    lastUpdate = json['lastUpdate'];
    nextSchdule = json['nextSchdule'];
    espen_output = json['espen_output'];
    who_output = json['who_output'];
    cdc_output = json['cdc_output'];
    uNINTENTIONALWEIGHT = json['UNINTENTIONALWEIGHT'];
    if (json['data'] != null) {
      data = new List<NRSListData>();
      json['data'].forEach((v) {
        data.add(new NRSListData.fromJson(v));
      });
    }
    etiologic = json['etiologic'] != null
        ? new Etiologic.fromJson(json['etiologic'])
        : null;
    severity = json['severity'] != null
        ? new Severity.fromJson(json['severity'])
        : null;

    phenotypic = json['phenotypic'] != null
        ? new Phenotypic.fromJson(json['phenotypic'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['dataText'] = this.dataText;
    data['lastUpdate'] = this.lastUpdate;
    data['nextSchdule'] = this.nextSchdule;
    data['espen_output'] = this.espen_output;
    data['who_output'] = this.who_output;
    data['cdc_output'] = this.cdc_output;
    data['UNINTENTIONALWEIGHT'] = this.uNINTENTIONALWEIGHT;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.etiologic != null) {
      data['etiologic'] = this.etiologic.toJson();
    }

    if (this.severity != null) {
      data['severity'] = this.severity.toJson();
    }

    if (this.phenotypic != null) {
      data['phenotypic'] = this.phenotypic.toJson();
    }
    return data;
  }
}

class Anthropometry {
  String weightType;
  String weightMeasuredReported;
  String weightMeasuredReportedLBS;
  String ac;
  String mUAC;
  String cALF;
  String tST;
  String estimatedWeight;
  String estimatedWeightLBS;
  String edema;
  List<Null> edemaData;
  String ascities;
  List<Null> ascitiesData;
  String amputation;
  bool wantDiscountOnWeightFromAmputation;
  String amputationPer;
  List<AmputationData> amputationData;
  String discountedWeight;
  String discountedWeightLBS;
  String heightType;
  String heightMeasuredReported;
  String kneeHeight;
  String armSpan;
  String estimatedHeight;
  String estimatedHeightInches;
  String bmi;
  String mamc;
  String mamcper;
  String idealBodyWeight;
  String adjustedBodyWeight;
  String idealBodyWeightLBS;
  String adjustedBodyWeightLBS;

  String lastUpdate;

  String ac_inch;
  String MUAC_inch;
  String CALF_inch;
  String TST_inch;
  String edema_LBS;
  String ascities_LBS;
  String amputation_LBS;
  String kneeHeight_inch;
  String armSpan_inch;
  String heightMeasuredReported_inch;

  Anthropometry({
    this.weightType,
    this.weightMeasuredReported,
    this.weightMeasuredReportedLBS,
    this.ac,
    this.mUAC,
    this.cALF,
    this.tST,
    this.estimatedWeight,
    this.estimatedWeightLBS,
    this.edema,
    this.edemaData,
    this.ascities,
    this.ascitiesData,
    this.amputation,
    this.wantDiscountOnWeightFromAmputation,
    this.amputationPer,
    this.amputationData,
    this.discountedWeight,
    this.discountedWeightLBS,
    this.heightType,
    this.heightMeasuredReported,
    this.kneeHeight,
    this.armSpan,
    this.estimatedHeight,
    this.estimatedHeightInches,
    this.bmi,
    this.mamc,
    this.mamcper,
    this.idealBodyWeight,
    this.adjustedBodyWeight,

    this.idealBodyWeightLBS,
    this.adjustedBodyWeightLBS,

    this.lastUpdate,
    this.ac_inch,
    this.MUAC_inch,
    this.CALF_inch,
    this.TST_inch,
    this.edema_LBS,
    this.ascities_LBS,
    this.amputation_LBS,
    this.kneeHeight_inch,
    this.armSpan_inch,
    this.heightMeasuredReported_inch,
  });

  Anthropometry.fromJson(Map<String, dynamic> json) {
    weightType = json['weightType'];
    weightMeasuredReported = json['weightMeasuredReported'];
    weightMeasuredReportedLBS = json['weightMeasuredReportedLBS'];
    heightMeasuredReported = json['heightMeasuredReported'];
    ac = json['ac'];
    mUAC = json['MUAC'];
    cALF = json['CALF'];
    tST = json['TST'];
    estimatedWeight = json['estimatedWeight'];
    estimatedWeightLBS = json['estimatedWeightLBS'];
    edema = json['edema'];
    // if (json['edemaData'] != null) {
    //   edemaData = new List<Null>();
    //   json['edemaData'].forEach((v) {
    //     edemaData.add(new Null.fromJson(v));
    //   });
    // }
    ascities = json['ascities'];
    // if (json['ascitiesData'] != null) {
    //   ascitiesData = new List<Null>();
    //   json['ascitiesData'].forEach((v) {
    //     ascitiesData.add(new Null.fromJson(v));
    //   });
    // }
    amputation = json['amputation'];
    wantDiscountOnWeightFromAmputation =
        json['wantDiscountOnWeightFromAmputation'] ?? false;
    amputationPer = json['amputationPer'];
    if (json['amputationData'] != null) {
      amputationData = new List<AmputationData>();
      json['amputationData'].forEach((v) {
        amputationData.add(new AmputationData.fromJson(v));
      });
    }
    discountedWeight = json['discountedWeight'];
    discountedWeightLBS = json['discountedWeightLBS'];
    heightType = json['heightType'];
    kneeHeight = json['kneeHeight'];
    armSpan = json['armSpan'];
    estimatedHeight = json['estimatedHeight'];
    estimatedHeightInches = json['estimatedHeightInches'];
    bmi = json['bmi'];
    mamc = json['mamc'];
    mamcper = json['mamcper'];
    idealBodyWeight = json['idealBodyWeight'];
    adjustedBodyWeight = json['adjustedBodyWeight'];

    idealBodyWeightLBS = json['idealBodyWeightLBS'];
    adjustedBodyWeightLBS = json['adjustedBodyWeightLBS'];

    lastUpdate = json['lastUpdate'];

    ac_inch = json['ac_inch'];
    MUAC_inch = json['MUAC_inch'];
    CALF_inch = json['CALF_inch'];
    TST_inch = json['TST_inch'];
    edema_LBS = json['edema_LBS'];
    ascities_LBS = json['ascities_LBS'];
    amputation_LBS = json['amputation_LBS'];
    kneeHeight_inch = json['kneeHeight_inch'];
    armSpan_inch = json['armSpan_inch'];
    heightMeasuredReported_inch = json['heightMeasuredReported_inch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weightType'] = this.weightType;
    data['weightMeasuredReported'] = this.weightMeasuredReported;
    data['weightMeasuredReportedLBS'] = this.weightMeasuredReportedLBS;
    data['heightMeasuredReported'] = this.heightMeasuredReported;
    data['ac'] = this.ac;
    data['MUAC'] = this.mUAC;
    data['CALF'] = this.cALF;
    data['TST'] = this.tST;
    data['estimatedWeight'] = this.estimatedWeight;
    data['estimatedWeightLBS'] = this.estimatedWeightLBS;
    data['edema'] = this.edema;
    // if (this.edemaData != null) {
    //   data['edemaData'] = this.edemaData.map((v) => v.toJson()).toList();
    // }
    data['ascities'] = this.ascities;
    // if (this.ascitiesData != null) {
    //   data['ascitiesData'] = this.ascitiesData.map((v) => v.toJson()).toList();
    // }
    data['amputation'] = this.amputation;
    data['wantDiscountOnWeightFromAmputation'] =
        this.wantDiscountOnWeightFromAmputation;
    data['amputationPer'] = this.amputationPer;
    if (this.amputationData != null) {
      data['amputationData'] =
          this.amputationData.map((v) => v.toJson()).toList();
    }
    data['discountedWeight'] = this.discountedWeight;
    data['discountedWeightLBS'] = this.discountedWeightLBS;
    data['heightType'] = this.heightType;
    data['kneeHeight'] = this.kneeHeight;
    data['armSpan'] = this.armSpan;
    data['estimatedHeight'] = this.estimatedHeight;
    data['estimatedHeightInches'] = this.estimatedHeightInches;
    data['bmi'] = this.bmi;
    data['mamc'] = this.mamc;
    data['mamcper'] = this.mamcper;
    data['idealBodyWeight'] = this.idealBodyWeight;
    data['adjustedBodyWeight'] = this.adjustedBodyWeight;

    data['idealBodyWeightLBS'] = this.idealBodyWeightLBS;
    data['adjustedBodyWeightLBS'] = this.adjustedBodyWeightLBS;

    data['lastUpdate'] = this.lastUpdate;

    data['ac_inch'] = this.ac_inch;
    data['MUAC_inch'] = this.MUAC_inch;
    data['CALF_inch'] = this.CALF_inch;
    data['TST_inch'] = this.TST_inch;
    data['edema_LBS'] = this.edema_LBS;
    data['ascities_LBS'] = this.ascities_LBS;
    data['amputation_LBS'] = this.amputation_LBS;
    data['kneeHeight_inch'] = this.kneeHeight_inch;
    data['armSpan_inch'] = this.armSpan_inch;
    data['heightMeasuredReported_inch'] = this.heightMeasuredReported_inch;

    return data;
  }
}

class AmputationData {
  String name;
  bool value;

  AmputationData({this.name, this.value});

  AmputationData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}

class Etiologic {
  String lastUpdate;
  String etioStatus;
  String selectedStatus;
  String PERCEIVED;
  String foodIntake;
  String iNFLAMMATIONText;
  List<EtiologicData> etiologicData;

  Etiologic(
      {this.lastUpdate,
      this.etioStatus,
      this.selectedStatus,
      this.PERCEIVED,
      this.etiologicData,
      this.foodIntake,
      this.iNFLAMMATIONText});

  Etiologic.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    etioStatus = json['EtioStatus'];
    PERCEIVED = json['PERCEIVED'];
    selectedStatus = json['SelectedStatus'];
    if (json['EtiologicData'] != null) {
      etiologicData = new List<EtiologicData>();
      json['EtiologicData'].forEach((v) {
        etiologicData.add(new EtiologicData.fromJson(v));
      });
    }
    foodIntake = json['foodIntake'];
    iNFLAMMATIONText = json['INFLAMMATIONText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['EtioStatus'] = this.etioStatus;
    data['PERCEIVED'] = this.PERCEIVED;
    data['SelectedStatus'] = this.selectedStatus;
    data['foodIntake'] = this.foodIntake;
    data['INFLAMMATIONText'] = this.iNFLAMMATIONText;
    if (this.etiologicData != null) {
      data['EtiologicData'] =
          this.etiologicData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EtiologicData {
  String title;
  String statustype;
  bool isBlocked;
  bool selectedTitle;
  String question;
  List<EtioOptions> options;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  EtiologicData(
      {this.title,
      this.statustype,
      this.isBlocked,
      this.selectedTitle,
      this.question,
      this.options,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  EtiologicData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    statustype = json['statustype'];
    isBlocked = json['isBlocked'];
    selectedTitle = json['selectedTitle'];
    question = json['question'];
    if (json['options'] != null) {
      options = new List<EtioOptions>();
      json['options'].forEach((v) {
        options.add(new EtioOptions.fromJson(v));
      });
    }
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['statustype'] = this.statustype;
    data['isBlocked'] = this.isBlocked;
    data['selectedTitle'] = this.selectedTitle;
    data['question'] = this.question;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Phenotypic {
  String lastUpdate;
  String phenoStatus;
  String selectedStatus;
  String patientType;
  String weightlossStatus;
  bool condition;
  List<EtiologicData> phenotypicData;
  List<EtioOptions> reducedMassMuscle;

  Phenotypic(
      {this.lastUpdate,
      this.phenoStatus,
      this.patientType,
      this.weightlossStatus,
      this.condition,
      this.selectedStatus,
      this.phenotypicData,
      this.reducedMassMuscle});

  Phenotypic.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    phenoStatus = json['phenoStatus'];
    patientType = json['patientType'];
    weightlossStatus = json['weightlossStatus'];
    condition = json['condition'];
    selectedStatus = json['SelectedStatus'];
    if (json['phenotypicData'] != null) {
      phenotypicData = new List<EtiologicData>();
      json['phenotypicData'].forEach((v) {
        phenotypicData.add(new EtiologicData.fromJson(v));
      });
    }
    if (json['reducedMassMuscle'] != null) {
      reducedMassMuscle = new List<EtioOptions>();
      json['reducedMassMuscle'].forEach((v) {
        reducedMassMuscle.add(new EtioOptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['phenoStatus'] = this.phenoStatus;

    data['condition'] = this.condition;
    data['patientType'] = this.patientType;
    data['weightlossStatus'] = this.weightlossStatus;

    data['SelectedStatus'] = this.selectedStatus;
    if (this.phenotypicData != null) {
      data['phenotypicData'] =
          this.phenotypicData.map((v) => v.toJson()).toList();
    }
    if (this.reducedMassMuscle != null) {
      data['reducedMassMuscle'] =
          this.reducedMassMuscle.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EtioOptions {
  String optionname;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  EtioOptions(
      {this.optionname,
      this.isBlocked,
      this.isSelected,
      this.sId,
      this.questionId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  EtioOptions.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'] ?? false;
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionname'] = this.optionname;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['questionId'] = this.questionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Severity {
  String lastUpdate;
  String severityStatus;
  String stageType;
  String selectedStatus;
  List<EtiologicData> severityData;

  Severity(
      {this.lastUpdate,
      this.severityStatus,
      this.stageType,
      this.selectedStatus,
      this.severityData});

  Severity.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    severityStatus = json['severityStatus'];
    stageType = json['stageType'];
    selectedStatus = json['SelectedStatus'];
    if (json['severityData'] != null) {
      severityData = new List<EtiologicData>();
      json['severityData'].forEach((v) {
        severityData.add(new EtiologicData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['severityStatus'] = this.severityStatus;
    data['stageType'] = this.stageType;
    data['SelectedStatus'] = this.selectedStatus;
    if (this.severityData != null) {
      data['severityData'] = this.severityData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
