import 'package:flutter/cupertino.dart';

class SchduleData {
  bool success;
  String message;
  List<SchduleDataDetails> data;

  SchduleData({this.success, this.message, this.data});

  SchduleData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SchduleDataDetails>();
      json['data'].forEach((v) {
        data.add(new SchduleDataDetails.fromJson(v));
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

class SchduleDataDetails {
  String schedulename;
  String userId;
  bool isBlocked;
  List<Options> options;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  SchduleDataDetails(
      {this.schedulename,
        this.userId,
        this.isBlocked,
        this.options,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SchduleDataDetails.fromJson(Map<String, dynamic> json) {
    schedulename = json['schedulename'];
    userId = json['userId'];
    isBlocked = json['isBlocked'];
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schedulename'] = this.schedulename;
    data['userId'] = this.userId;
    data['isBlocked'] = this.isBlocked;
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

class Options {
  String title;
  String subtitle;

  var subtitleTc = TextEditingController();
  var titleTc = TextEditingController();
 // final myFocusNode = FocusNode();
 // final myFocusNode2 = FocusNode();

  bool isBlocked;
  String sId;
  String scheduleId;
  String createdAt;
  String updatedAt;
  int iV;

  Options(
      {this.title,
        this.subtitle,
        this.titleTc,this.subtitleTc,
        this.isBlocked,
        this.sId,
        this.scheduleId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Options.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle = json['subtitle'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    scheduleId = json['scheduleId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['scheduleId'] = this.scheduleId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}