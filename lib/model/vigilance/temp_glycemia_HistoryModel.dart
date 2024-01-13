class TempGlyHistory {
  bool success;
  String message;
  List<Temp_Gly_HistoryData> data;

  TempGlyHistory({this.success, this.message, this.data});

  TempGlyHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Temp_Gly_HistoryData>();
      json['data'].forEach((v) {
        data.add(new Temp_Gly_HistoryData.fromJson(v));
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

class Temp_Gly_HistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  Temp_Gly_HistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Temp_Gly_HistoryData.fromJson(Map<String, dynamic> json) {
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
  String value;
  String flag;

  Data({this.date, this.time, this.value, this.flag});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    value = json['value'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['value'] = this.value;
    data['flag'] = this.flag;
    return data;
  }
}