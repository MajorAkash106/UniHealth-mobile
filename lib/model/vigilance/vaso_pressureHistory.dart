class VasoPressureHistory {
  bool success;
  String message;
  List<VasoPressureHistoryData> data;

  VasoPressureHistory({this.success, this.message, this.data});

  VasoPressureHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<VasoPressureHistoryData>();
      json['data'].forEach((v) {
        data.add(new VasoPressureHistoryData.fromJson(v));
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

class VasoPressureHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  VasoPressureHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  VasoPressureHistoryData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['multipalmessage'] != null) {
      multipalmessage = new List<Multipalmessage>();
      json['multipalmessage'].forEach((v) {
        multipalmessage.add(new Multipalmessage.fromJson(v));
      });
    }
    type = json['type'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.multipalmessage != null) {
      data['multipalmessage'] =
          this.multipalmessage.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Multipalmessage {
  String lastUpdate;
  List<Data> data;

  Multipalmessage({this.lastUpdate, this.data});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String date;
  String time;
  String flag;
  String drug;
  String drugAmount;
  String concentration;
  String unit_type;
  String dose;
  String diluent;
  String infusion;

  Data(
      {this.date,
        this.time,
        this.flag,
        this.drug,
        this.drugAmount,
        this.concentration,
        this.unit_type,
        this.dose,
        this.diluent,
        this.infusion});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    flag = json['flag'];
    drug = json['drug'];
    drugAmount = json['drug_amount'];
    concentration = json['concentration'];
    unit_type = json['unit_type'];
    dose = json['dose'];
    diluent = json['diluent'];
    infusion = json['infusion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['flag'] = this.flag;
    data['drug'] = this.drug;
    data['drug_amount'] = this.drugAmount;
    data['concentration'] = this.concentration;
    data['unit_type'] = this.unit_type;
    data['dose'] = this.dose;
    data['diluent'] = this.diluent;
    data['infusion'] = this.infusion;
    return data;
  }
}
//updated by raman at 14 oct 12:28