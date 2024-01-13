class CIDModel {
  bool success;
  String message;
  List<CIDData> data;

  CIDModel({this.success, this.message, this.data});

  CIDModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CIDData>();
      json['data'].forEach((v) {
        data.add(new CIDData.fromJson(v));
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

class CIDData {
  String cidname;
  bool isBlocked;
  bool isSelected;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  CIDData(
      {this.cidname,
        this.isBlocked,this.isSelected,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  CIDData.fromJson(Map<String, dynamic> json) {
    cidname = json['cidname'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cidname'] = this.cidname;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}