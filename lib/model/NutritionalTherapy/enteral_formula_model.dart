class EnteralFormulaModel {
  bool success;
  String message;
  List<Industrialized> industrialized;
  List<Industrialized> manipulated;

  EnteralFormulaModel(
      {this.success, this.message, this.industrialized, this.manipulated});

  EnteralFormulaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['Industrialized'] != null) {
      industrialized = new List<Industrialized>();
      json['Industrialized'].forEach((v) {
        industrialized.add(new Industrialized.fromJson(v));
      });
    }
    if (json['Manipulated'] != null) {
      manipulated = new List<Industrialized>();
      json['Manipulated'].forEach((v) {
        manipulated.add(new Industrialized.fromJson(v));
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

class Industrialized {
  List<String> availableIn;
  String title;
  int type;
  String valume;
  String kcal;
  String protein;
  String fiber;
  String cost;
  bool isBlocked;
  bool isActive;
  String sId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  Industrialized(
      {this.availableIn,this.title,
        this.type,
        this.valume,
        this.kcal,
        this.protein,
        this.fiber,
        this.cost,
        this.isBlocked,
        this.isActive,
        this.sId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Industrialized.fromJson(Map<String, dynamic> json) {
    availableIn = json['availableIn'].cast<String>();
    title = json['title'];
    type = json['type'];
    valume = json['valume'].toString();
    kcal = json['kcal'].toString();
    protein = json['protein'].toString();
    fiber = json['fiber'].toString();
    cost = json['cost'].toString();
    isBlocked = json['isBlocked'];
    isActive = json['isActive'];
    sId = json['_id'];
    hospitalId = json['hospitalId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['availableIn'] = this.availableIn;
    data['title'] = this.title;
    data['type'] = this.type;
    data['valume'] = this.valume;
    data['kcal'] = this.kcal;
    data['protein'] = this.protein;
    data['fiber'] = this.fiber;
    data['cost'] = this.cost;
    data['isBlocked'] = this.isBlocked;
    data['isActive'] = this.isActive;
    data['_id'] = this.sId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}