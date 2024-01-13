class AdultCondition {
  bool success;
  String message;
  List<ConditionData> data;

  AdultCondition({this.success, this.message, this.data});

  AdultCondition.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<ConditionData>();
      json['data'].forEach((v) {
        data.add(new ConditionData.fromJson(v));
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

class ConditionData {
  List<String> availableIn;
  String category;
  String condition;
  String type;
  String kcalmin;
  String valuekcalmin;
  String kcalmax;
  String valuekcalmax;
  String ptnmin;
  String valueptnmin;
  String ptnmax;
  String valueptnmax;
  String info;
  bool isBlocked;
  bool isSelected;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  ConditionData(
      {
        this.availableIn,
        this.category,
        this.condition,
        this.type,
        this.kcalmin,
        this.valuekcalmin,
        this.kcalmax,
        this.valuekcalmax,
        this.ptnmin,
        this.valueptnmin,
        this.ptnmax,
        this.valueptnmax,
        this.info,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  ConditionData.fromJson(Map<String, dynamic> json) {
    availableIn = json['availableIn'].cast<String>();
    category = json['category'];
    condition = json['condition'];
    type = json['type'];
    kcalmin = json['kcalmin'];
    valuekcalmin = json['valuekcalmin'];
    kcalmax = json['kcalmax'];
    valuekcalmax = json['valuekcalmax'];
    ptnmin = json['ptnmin'];
    valueptnmin = json['valueptnmin'];
    ptnmax = json['ptnmax'];
    valueptnmax = json['valueptnmax'];
    info = json['info'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableIn'] = this.availableIn;
    data['category'] = this.category;
    data['condition'] = this.condition;
    data['type'] = this.type;
    data['kcalmin'] = this.kcalmin;
    data['valuekcalmin'] = this.valuekcalmin;
    data['kcalmax'] = this.kcalmax;
    data['valuekcalmax'] = this.valuekcalmax;
    data['ptnmin'] = this.ptnmin;
    data['valueptnmin'] = this.valueptnmin;
    data['ptnmax'] = this.ptnmax;
    data['valueptnmax'] = this.valueptnmax;
    data['info'] = this.info;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}