class FluidBalanceHistory {
  bool success;
  String message;
  List<FluidHistoryData> data;

  FluidBalanceHistory({this.success, this.message, this.data});

  FluidBalanceHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<FluidHistoryData>();
      json['data'].forEach((v) {
        data.add(new FluidHistoryData.fromJson(v));
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

class FluidHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  FluidHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  FluidHistoryData.fromJson(Map<String, dynamic> json) {
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
  String balanceSince;
  List<BalanceData> data;

  Multipalmessage({this.lastUpdate, this.balanceSince, this.data});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    balanceSince = json['balance_since'];
    if (json['data'] != null) {
      data = new List<BalanceData>();
      json['data'].forEach((v) {
        data.add(new BalanceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['balance_since'] = this.balanceSince;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BalanceData {
  String item;
  String date;
  String time;
  String intOut;
  String ml;

  BalanceData({this.item, this.date, this.time, this.intOut, this.ml});

  BalanceData.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    date = json['date'];
    time = json['time'];
    intOut = json['intOut'];
    ml = json['ml'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['date'] = this.date;
    data['time'] = this.time;
    data['intOut'] = this.intOut;
    data['ml'] = this.ml;
    return data;
  }
}