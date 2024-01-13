class NRSModel {
  bool success;
  String message;
  List<NRSListData> data;

  NRSModel({this.success, this.message, this.data});

  NRSModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<NRSListData>();
      json['data'].forEach((v) {
        data.add(new NRSListData.fromJson(v));
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

class NRSListData {
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

  NRSListData(
      {this.statusquestion,
        this.statusId,
        this.type,
        this.isBlocked,this.selectedQ,
        this.options,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NRSListData.fromJson(Map<String, dynamic> json) {
    statusquestion = json['statusquestion'];
    statusId = json['statusId'];
    type = json['type'];
    isBlocked = json['isBlocked'];
    selectedQ = json['selectedQ']??false;
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
  String file;
  String statusquestionId;
  String createdAt;
  String updatedAt;
  int iV;

  Options(
      {this.statusoption,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.score,this.file,
        this.statusquestionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Options.fromJson(Map<String, dynamic> json) {
    statusoption = json['statusoption'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'] ??false;
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