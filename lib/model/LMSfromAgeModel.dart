class LMSfromAge {
  int age;
  LMSData data;

  LMSfromAge({this.age, this.data});

  LMSfromAge.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    data = json['data'] != null ? new LMSData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LMSData {
  double l;
  double m;
  double s;
  int sD1pos;
  int sD1neg;
  int sD2pos;
  int sD2neg;
  int sD3pos;
  int sD3neg;

  LMSData(
      {this.l,
        this.m,
        this.s,
        this.sD1pos,
        this.sD1neg,
        this.sD2pos,
        this.sD2neg,
        this.sD3pos,
        this.sD3neg});

  LMSData.fromJson(Map<String, dynamic> json) {
    l = json['L'];
    m = json['M'];
    s = json['S'];
    sD1pos = json['SD1pos'];
    sD1neg = json['SD1neg'];
    sD2pos = json['SD2pos'];
    sD2neg = json['SD2neg'];
    sD3pos = json['SD3pos'];
    sD3neg = json['SD3neg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['L'] = this.l;
    data['M'] = this.m;
    data['S'] = this.s;
    data['SD1pos'] = this.sD1pos;
    data['SD1neg'] = this.sD1neg;
    data['SD2pos'] = this.sD2pos;
    data['SD2neg'] = this.sD2neg;
    data['SD3pos'] = this.sD3pos;
    data['SD3neg'] = this.sD3neg;
    return data;
  }
}