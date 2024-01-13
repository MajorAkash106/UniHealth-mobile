class FastingOralData {
  String lastUpdate;
  String condition;
  bool teamAgree;
  bool fasting;
  String fastingReason;
  String description;
  String kcal;
  String ptn;

  FastingOralData(
      {this.lastUpdate,
        this.condition,
        this.teamAgree,
        this.fasting,
        this.fastingReason,
        this.description,
        this.kcal,
        this.ptn});

  FastingOralData.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    condition = json['condition'];
    teamAgree = json['team_agree'];
    fasting = json['fasting'];
    fastingReason = json['fasting_reason'];
    description = json['description'];
    kcal = json['kcal'];
    ptn = json['ptn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['condition'] = this.condition;
    data['team_agree'] = this.teamAgree;
    data['fasting'] = this.fasting;
    data['fasting_reason'] = this.fastingReason;
    data['description'] = this.description;
    data['kcal'] = this.kcal;
    data['ptn'] = this.ptn;
    return data;
  }
}