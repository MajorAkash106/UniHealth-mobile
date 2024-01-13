class InfusionReportModel {
  bool success;
  String message;
  List<Data> data;

  InfusionReportModel({this.success, this.message, this.data});

  InfusionReportModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String formulastatus;
  String currentdate;
  String hospitaldate;
  bool isBlocked;
  String sId;
  String userId;
  List<Formula> formula;
  String createdAt;
  String updatedAt;
  int iV;

  Data(
      {this.formulastatus,
        this.currentdate,
        this.hospitaldate,
        this.isBlocked,
        this.sId,
        this.userId,
        this.formula,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    formulastatus = json['formulastatus'];
    currentdate = json['currentdate'];
    hospitaldate = json['hospitaldate'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    if (json['formula'] != null) {
      formula = new List<Formula>();
      json['formula'].forEach((v) {
        formula.add(new Formula.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['formulastatus'] = this.formulastatus;
    data['currentdate'] = this.currentdate;
    data['hospitaldate'] = this.hospitaldate;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    if (this.formula != null) {
      data['formula'] = this.formula.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Formula {
  String date;
  String time;
  String start_interval;
  String end_interval;
  String lastUpdate;
  String formulaName;
  String expectedVol;
  String infusedVol;
  String type;

  Formula(
      {this.date,
        this.time,
        this.start_interval,
        this.end_interval,
        this.lastUpdate,
        this.formulaName,
        this.expectedVol,
        this.infusedVol,
        this.type,
      });

  Formula.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    start_interval = json["start_interval"] ==''?'${DateTime.now()}':json["start_interval"];;
    end_interval = json["end_interval"];
    lastUpdate = json['lastUpdate'];
    formulaName = json['formula_name'];
    expectedVol = json['expected_vol'];
    infusedVol = json['infused_vol'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['start_interval'] = this.start_interval;
    data['end_interval'] = this.end_interval;
    data['lastUpdate'] = this.lastUpdate;
    data['formula_name'] = this.formulaName;
    data['expected_vol'] = this.expectedVol;
    data['infused_vol'] = this.infusedVol;
    data['type'] = this.type;
    return data;
  }
}