class LMSDataModel {
  String age;
  String powerL;
  String medianM;
  String variationS;

  LMSDataModel({this.age, this.powerL, this.medianM, this.variationS});

  LMSDataModel.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    powerL = json['L'];
    medianM = json['M'];
    variationS = json['S'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['L'] = this.powerL;
    data['M'] = this.medianM;
    data['S'] = this.variationS;
    return data;
  }
}