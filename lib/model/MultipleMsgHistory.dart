import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/spictDataModel.dart';

class MultipleMsgHistory {
  bool success;
  String message;
  List<MultipleMsgData> data;

  MultipleMsgHistory({this.success, this.message, this.data});

  MultipleMsgHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<MultipleMsgData>();
      json['data'].forEach((v) {
        data.add(new MultipleMsgData.fromJson(v));
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

class MultipleMsgData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  MultipleMsgData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MultipleMsgData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['multipalmessage'] != null) {
      multipalmessage = new List<Multipalmessage>();
      json['multipalmessage'].forEach((v) {
        multipalmessage.add(new Multipalmessage.fromJson(v));
      });
    }
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
    data['message'] = this.message;
    if (this.multipalmessage != null) {
      data['multipalmessage'] =
          this.multipalmessage.map((v) => v.toJson()).toList();
    }
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

class Multipalmessage {

  String palcare;
  String status;
  String lastUpdate;
  List<SpictQuestion> spictData;

  List<OralData> oralData;

  CutomizedData cutomizedData;
  String condition;

  String optionname;
  String cidname;
  String persentage;
  bool isBlocked;
  bool isSelected;

  bool teamAgree;
  bool fasting;
  String fastingReason;
  String kcal;
  String ptn;

  String fiber;
  String volume;
  String times;

  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  Multipalmessage(
      {
        this.palcare, this.status, this.lastUpdate, this.spictData,this.cutomizedData,this.condition,this.oralData,

        this.teamAgree,
        this.fasting,
        this.fastingReason,
        this.kcal,
        this.ptn,

        this.fiber,this.volume,this.times,

        this.optionname,
        this.persentage,
        this.cidname,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Multipalmessage.fromJson(Map<String, dynamic> json) {

    palcare = json['palcare'];

    status = json['status'];
    lastUpdate = json['lastUpdate'];
    if (json['spictData'] != null) {
      spictData = new List<SpictQuestion>();
      json['spictData'].forEach((v) {
        spictData.add(new SpictQuestion.fromJson(v));
      });
    }

    if (json['oral_data'] != null) {
      oralData = new List<OralData>();
      json['oral_data'].forEach((v) {
        oralData.add(new OralData.fromJson(v));
      });
    }

    cutomizedData = json['cutomized_data'] != null
        ? new CutomizedData.fromJson(json['cutomized_data'])
        : null;
    condition = json['condition'];

    teamAgree = json['team_agree']??false;
    fasting = json['fasting']??false;
    fastingReason = json['fasting_reason'];
    kcal = json['kcal'];
    ptn = json['ptn'];

    optionname = json['optionname'];
    cidname = json['cidname'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'];
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];

    fiber = json['fiber'];
    volume = json['volume'];
    times = json['times'];

    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['palcare'] = this.palcare;
    data['status'] = this.status;
    data['lastUpdate'] = this.lastUpdate;
    if (this.spictData != null) {
      data['spictData'] = this.spictData.map((v) => v.toJson()).toList();
    }
    if (this.cutomizedData != null) {
      data['cutomized_data'] = this.cutomizedData.toJson();
    }

    if (this.oralData != null) {
      data['oral_data'] = this.oralData.map((v) => v.toJson()).toList();
    }

    data['condition'] = this.condition;

    data['team_agree'] = this.teamAgree;
    data['fasting'] = this.fasting;
    data['fasting_reason'] = this.fastingReason;
    data['kcal'] = this.kcal;
    data['ptn'] = this.ptn;

    data['fiber'] = this.fiber;
    data['volume'] = this.volume;
    data['times'] = this.times;

    data['optionname'] = this.optionname;
    data['cidname'] = this.cidname;
    data['persentage'] = this.persentage;
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