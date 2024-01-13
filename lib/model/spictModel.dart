class SpictModel {
  bool success;
  String message;
  List<SpictData> data;

  SpictModel({this.success, this.message, this.data});

  SpictModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SpictData>();
      json['data'].forEach((v) {
        data.add(new SpictData.fromJson(v));
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

class SpictData {
  String categoryname;
  bool isBlocked;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  SpictData(
      {this.categoryname,
        this.isBlocked,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SpictData.fromJson(Map<String, dynamic> json) {
    categoryname = json['categoryname'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryname'] = this.categoryname;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}