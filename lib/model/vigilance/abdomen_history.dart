class AbdomenHistory {
  bool success;
  String message;
  List<AbdomenHistoryData> data;

  AbdomenHistory({this.success, this.message, this.data});

  AbdomenHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AbdomenHistoryData>();
      json['data'].forEach((v) {
        data.add(new AbdomenHistoryData.fromJson(v));
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

class AbdomenHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  AbdomenHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AbdomenHistoryData.fromJson(Map<String, dynamic> json) {
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
  String result;
  AbdomenData abdomenData;
  List<AdverseEventData> adverseEventData;

  Multipalmessage(
      {this.lastUpdate, this.result, this.abdomenData, this.adverseEventData});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    result = json['result'];
    abdomenData = json['abdomen_data'] != null
        ? new AbdomenData.fromJson(json['abdomen_data'])
        : null;
    if (json['adverse_eventData'] != null) {
      adverseEventData = new List<AdverseEventData>();
      json['adverse_eventData'].forEach((v) {
        adverseEventData.add(new AdverseEventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['result'] = this.result;
    if (this.abdomenData != null) {
      data['abdomen_data'] = this.abdomenData.toJson();
    }
    if (this.adverseEventData != null) {
      data['adverse_eventData'] =
          this.adverseEventData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AbdomenData {
  String bowelMovement;
  int indexBowelMovement;
  int bowelSound;
  int vomit;
  String abdominalDist;
  String ngTube;
  String meanLap;

  AbdomenData(
      {this.bowelMovement,
        this.indexBowelMovement,
        this.bowelSound,
        this.vomit,
        this.abdominalDist,
        this.ngTube,
        this.meanLap});

  AbdomenData.fromJson(Map<String, dynamic> json) {
    bowelMovement = json['bowel_movement'];
    indexBowelMovement = json['bowel_movement_index']??-1;
    bowelSound = json['bowel_sound'];
    vomit = json['vomit'];
    abdominalDist = json['abdominal_dist'];
    ngTube = json['ng_tube'];
    meanLap = json['mean_lap'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowel_movement'] = this.bowelMovement;
    data['bowel_movement_index'] = this.indexBowelMovement;
    data['bowel_sound'] = this.bowelSound;
    data['vomit'] = this.vomit;
    data['abdominal_dist'] = this.abdominalDist;
    data['ng_tube'] = this.ngTube;
    data['mean_lap'] = this.meanLap;
    return data;
  }
}

class AdverseEventData {
  String optionname;
  String persentage;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  AdverseEventData(
      {this.optionname,
        this.persentage,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AdverseEventData.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'];
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionname'] = this.optionname;
    data['persentage'] = this.persentage;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['questionId'] = this.questionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}