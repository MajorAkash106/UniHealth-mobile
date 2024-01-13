class GlimModel {
  bool success;
  String message;
  List<GLIMData> data;

  GlimModel({this.success, this.message, this.data});

  GlimModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<GLIMData>();
      json['data'].forEach((v) {
        data.add(new GLIMData.fromJson(v));
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

class GLIMData {
  String title;
  String statustype;
  bool isBlocked;
  bool selectedTitle;
  String question;
  List<Options> options;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  GLIMData(
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

  GLIMData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    statustype = json['statustype'];
    isBlocked = json['isBlocked'];
    selectedTitle = json['selectedTitle']??false;
    question = json['question'];
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

class Options {
  String optionname;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  Options(
      {this.optionname,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Options.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
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