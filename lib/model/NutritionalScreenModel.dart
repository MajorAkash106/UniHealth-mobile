class NutritionalScreenModel {
  bool success;
  String message;
  List<NutritionalScreenListData> data;

  NutritionalScreenModel({this.success, this.message, this.data});

  NutritionalScreenModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<NutritionalScreenListData>();
      json['data'].forEach((v) {
        data.add(new NutritionalScreenListData.fromJson(v));
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

class NutritionalScreenListData {
  String statusname;
  bool isBlocked;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  NutritionalScreenListData(
      {this.statusname,
        this.isBlocked,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  NutritionalScreenListData.fromJson(Map<String, dynamic> json) {
    statusname = json['statusname'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusname'] = this.statusname;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
