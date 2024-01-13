class ModuleModel {
  bool success;
  String message;
  List<ModuleData> industrialized;
  List<ModuleData> manipulated;

  ModuleModel(
      {this.success, this.message, this.industrialized, this.manipulated});

  ModuleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['Industrialized'] != null) {
      industrialized = new List<ModuleData>();
      json['Industrialized'].forEach((v) {
        industrialized.add(new ModuleData.fromJson(v));
      });
    }
    if (json['Manipulated'] != null) {
      manipulated = new List<ModuleData>();
      json['Manipulated'].forEach((v) {
        manipulated.add(new ModuleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.industrialized != null) {
      data['Industrialized'] =
          this.industrialized.map((v) => v.toJson()).toList();
    }
    if (this.manipulated != null) {
      data['Manipulated'] = this.manipulated.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ModuleData {
  String title;
  int type;
  bool fiber;
  String protein;
  String volume;
  String remdomId;
  bool isAdmin;
  bool isBlocked;
  String sId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  ModuleData(
      {this.title,
        this.type,
        this.fiber,
        this.protein,
        this.volume,
        this.remdomId,
        this.isAdmin,
        this.isBlocked,
        this.sId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ModuleData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    fiber = json['fiber']??false;
    protein = json['gram'].toString();
    volume = json['volume'].toString();
    remdomId = json['remdomId'];
    isAdmin = json['isAdmin'];
    isBlocked = json['isActive'];
    sId = json['_id'];
    hospitalId = json['hospitalId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type'] = this.type;
    data['fiber'] = this.fiber;
    data['gram'] = this.protein;
    data['volume'] = this.volume;
    data['remdomId'] = this.remdomId;
    data['isAdmin'] = this.isAdmin;
    data['isActive'] = this.isBlocked;
    data['_id'] = this.sId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ModuleDetail {
  String item;
  String per_day;
  String g_per_dose;
  String total_amt;
  String total_vol;


  ModuleDetail(
      {this.item, this.per_day,this.g_per_dose,this.total_amt,this.total_vol});

  ModuleDetail.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    per_day = json['per_day'];
    g_per_dose = json['g_per_dose'];
    total_amt = json['total_amt'];
    total_vol = json['total_vol'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['per_day'] = this.per_day;
    data['g_per_dose'] = this.g_per_dose;
    data['total_amt'] = this.total_amt;
    data['total_vol'] = this.total_vol;

    return data;
  }
}

