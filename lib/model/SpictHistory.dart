import 'package:medical_app/model/spictDataModel.dart';

class SPICTHistory {
  bool success;
  String message;
  List<SPICTHistoryData> data;

  SPICTHistory({this.success, this.message, this.data});

  SPICTHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SPICTHistoryData>();
      json['data'].forEach((v) {
        data.add(new SPICTHistoryData.fromJson(v));
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

class SPICTHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  SPICTHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SPICTHistoryData.fromJson(Map<String, dynamic> json) {
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

  Multipalmessage({this.palcare, this.status, this.lastUpdate, this.spictData});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['palcare'] = this.palcare;
    data['status'] = this.status;
    data['lastUpdate'] = this.lastUpdate;
    if (this.spictData != null) {
      data['spictData'] = this.spictData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

