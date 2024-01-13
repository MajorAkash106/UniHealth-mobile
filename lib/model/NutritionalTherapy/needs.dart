class Needs {
  String lastUpdate;
  String type;
  String plannedKcal;
  String plannedPtn;
  String achievementKcal;
  String achievementProtein;
  bool isSecond;
  CalculatedParameters calculatedParameters;


  Needs(
      {this.lastUpdate,
        this.type,
        this.plannedKcal,
        this.plannedPtn,
        this.achievementKcal,
        this.achievementProtein,
        this.isSecond,
        this.calculatedParameters,
      });

  Needs.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    type = json['type'];
    plannedKcal = json['planned_kcal'];
    plannedPtn = json['planned_ptn'];
    achievementKcal = json['achievement_kcal'];
    achievementProtein = json['achievement_protein'];
    isSecond = json['isSecond'];
    calculatedParameters = json['calculatedParameters'] != null
        ? new CalculatedParameters.fromJson(json['calculatedParameters'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['type'] = this.type;
    data['planned_kcal'] = this.plannedKcal;
    data['planned_ptn'] = this.plannedPtn;
    data['achievement_kcal'] = this.achievementKcal;
    data['achievement_protein'] = this.achievementProtein;
    data['isSecond'] = this.isSecond;
    if (this.calculatedParameters != null) {
      data['calculatedParameters'] = this.calculatedParameters.toJson();
    }
    return data;
  }
}

class CalculatedParameters {
  String protien_perML;
  String kcl_perML;
  String curruntWork;

  CalculatedParameters(
      {
    this.protien_perML,
        this.kcl_perML,
        this.curruntWork
});

  CalculatedParameters.fromJson(Map<String, dynamic> json) {
    protien_perML = json['protien_perML'];
    kcl_perML = json['kcl_perML'];
    curruntWork = json['curruntWork'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protien_perML'] = this.protien_perML;
    data['kcl_perML'] = this.kcl_perML;
    data['curruntWork'] = this.curruntWork;

    return data;
  }
}
