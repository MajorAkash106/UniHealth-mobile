
//  // badges  -  attribution_info
//   // in object>>
//   // badges -  access_info
//   // skills - name
//   // checked - access

class AttributionInfo {
  String attributionname;
  List<AccessInfo> accessInfo;
  List<Hospital> hospital;
  bool checked;
  bool isBlocked;
  String sId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  AttributionInfo(
      {this.attributionname,
        this.accessInfo,
        this.hospital,
        this.checked,
        this.isBlocked,
        this.sId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AttributionInfo.fromJson(Map<String, dynamic> json) {
    attributionname = json['attributionname'];
    if (json['badges'] != null) {
      accessInfo = new List<AccessInfo>();
      json['badges'].forEach((v) {
        accessInfo.add(new AccessInfo.fromJson(v));
      });
    }
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
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
    if (this.accessInfo != null) {
      data['badges'] = this.accessInfo.map((v) => v.toJson()).toList();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
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

class AccessInfo {
  String name;
  bool access;

  AccessInfo({this.name, this.access});

  AccessInfo.fromJson(Map<String, dynamic> json) {
    name = json['skills'];
    access = json['Checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skills'] = this.name;
    data['Checked'] = this.access;
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