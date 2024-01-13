class AkpsModel {
  bool success;
  String message;
  List<AkpsData> data;

  AkpsModel({this.success, this.message, this.data});

  AkpsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AkpsData>();
      json['data'].forEach((v) {
        data.add(new AkpsData.fromJson(v));
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

class AkpsData {
  String question;
  String persentage;
  bool isBlocked;
  bool isSelected;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  AkpsData(
      {this.question,
        this.persentage,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AkpsData.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['persentage'] = this.persentage;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}




class AkpsDataModel {
  bool success;
  String message;
  List<AKPSData> data;

  AkpsDataModel({this.success, this.message, this.data});

  AkpsDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AKPSData>();
      json['data'].forEach((v) {
        data.add(new AKPSData.fromJson(v));
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

class AKPSData {
  String optionname;
  String description;
  String persentage;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  AKPSData(
      {this.optionname,
        this.description,
        this.persentage,
        this.isBlocked,this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AKPSData.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
    description = json['description'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionname'] = this.optionname;
    data['description'] = this.description;
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


class GOAlSelectedData {
  String optionname;
  String persentage;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  GOAlSelectedData(
      {this.optionname,
        this.persentage,
        this.isBlocked,this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GOAlSelectedData.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionname'] = this.optionname;
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