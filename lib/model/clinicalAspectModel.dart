class ClinicalAspectHistory {
  bool success;
  String message;
  List<AspectClinicalHistoryData> data;

  ClinicalAspectHistory({this.success, this.message, this.data});

  ClinicalAspectHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AspectClinicalHistoryData>();
      json['data'].forEach((v) {
        data.add(new AspectClinicalHistoryData.fromJson(v));
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

class AspectClinicalHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  AspectClinicalHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AspectClinicalHistoryData.fromJson(Map<String, dynamic> json) {
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
  String statusquestion;
  String statusId;
  String type;
  bool isBlocked;
  bool selectedQ;
  List<Options> options;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  Multipalmessage(
      {this.statusquestion,
        this.statusId,
        this.type,
        this.isBlocked,
        this.selectedQ,
        this.options,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    statusquestion = json['statusquestion'];
    statusId = json['statusId'];
    type = json['type'];
    isBlocked = json['isBlocked'];
    selectedQ = json['selectedQ'];
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
    data['statusquestion'] = this.statusquestion;
    data['statusId'] = this.statusId;
    data['type'] = this.type;
    data['isBlocked'] = this.isBlocked;
    data['selectedQ'] = this.selectedQ;
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
  String statusoption;
  bool isBlocked;
  bool isSelected;
  String sId;
  String score;
  String statusquestionId;
  String createdAt;
  String updatedAt;
  int iV;

  Options(
      {this.statusoption,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.score,
        this.statusquestionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Options.fromJson(Map<String, dynamic> json) {
    statusoption = json['statusoption'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'];
    sId = json['_id'];
    score = json['score'];
    statusquestionId = json['statusquestionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusoption'] = this.statusoption;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['score'] = this.score;
    data['statusquestionId'] = this.statusquestionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}