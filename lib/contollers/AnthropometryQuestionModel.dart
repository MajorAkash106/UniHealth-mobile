class QuestionForCalculate {
  bool success;
  String message;
  List<QuestionsData> data;

  QuestionForCalculate({this.success, this.message, this.data});

  QuestionForCalculate.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<QuestionsData>();
      json['data'].forEach((v) {
        data.add(new QuestionsData.fromJson(v));
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

class QuestionsData {
  String title;
  String type;
  String weight;
  bool isBlocked;
  bool selected;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  QuestionsData(
      {this.title,
        this.type,
        this.weight,
        this.isBlocked,
        this.selected,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  QuestionsData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    weight = json['weight'];
    isBlocked = json['isBlocked'];
    selected = json['selected']??false;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type'] = this.type;
    data['weight'] = this.weight;
    data['isBlocked'] = this.isBlocked;
    data['selected'] = this.selected;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}