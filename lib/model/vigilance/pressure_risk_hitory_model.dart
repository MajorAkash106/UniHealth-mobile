class PressureRiskHistory {
  bool success;
  String message;
  List<PressureRiskData> data;

  PressureRiskHistory({this.success, this.message, this.data});

  PressureRiskHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<PressureRiskData>();
      json['data'].forEach((v) {
        data.add(new PressureRiskData.fromJson(v));
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

class PressureRiskData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  PressureRiskData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  PressureRiskData.fromJson(Map<String, dynamic> json) {
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
  String lastUpdate;
  int score;
  String output;
  List<RiskBradenData> riskBradenData;

  Multipalmessage(
      {this.lastUpdate, this.score, this.output, this.riskBradenData});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    score = json['score'];
    output = json['output'];
    if (json['risk_braden_data'] != null) {
      riskBradenData = new List<RiskBradenData>();
      json['risk_braden_data'].forEach((v) {
        riskBradenData.add(new RiskBradenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['score'] = this.score;
    data['output'] = this.output;
    if (this.riskBradenData != null) {
      data['risk_braden_data'] =
          this.riskBradenData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RiskBradenData {
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

  RiskBradenData(
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

  RiskBradenData.fromJson(Map<String, dynamic> json) {
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
  Null file;
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
        this.file,
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
    file = json['file'];
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
    data['file'] = this.file;
    data['statusquestionId'] = this.statusquestionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}