class AttributionModel {
  bool success;
  String message;
  List<AttributionData> data;

  AttributionModel({this.success, this.message, this.data});

  AttributionModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AttributionData>();
      json['data'].forEach((v) {
        data.add(new AttributionData.fromJson(v));
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

class AttributionData {
  String attributionname;
  List<Badges> badges;
  List<Hospital> hospital;
  String remdomId;
  bool checked;
  bool isBlocked;
  String sId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  AttributionData(
      {this.attributionname,
        this.badges,
        this.hospital,
        this.remdomId,
        this.checked,
        this.isBlocked,
        this.sId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AttributionData.fromJson(Map<String, dynamic> json) {
    attributionname = json['attributionname'];
    if (json['badges'] != null) {
      badges = new List<Badges>();
      json['badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
      });
    }
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    remdomId = json['remdomId'];
    checked = json['Checked'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    hospitalId = json['hospitalId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attributionname'] = this.attributionname;
    if (this.badges != null) {
      data['badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    data['remdomId'] = this.remdomId;
    data['Checked'] = this.checked;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Badges {
  String skills;
  bool checked;

  Badges({this.skills, this.checked});

  Badges.fromJson(Map<String, dynamic> json) {
    skills = json['skills'];
    checked = json['Checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skills'] = this.skills;
    data['Checked'] = this.checked;
    return data;
  }
}

class Hospital {
  String sId;
  String name;

  Hospital({this.sId, this.name});

  Hospital.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}