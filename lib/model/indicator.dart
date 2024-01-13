class Indicator {
  List<Indicators> indicators;

  Indicator({this.indicators});

  Indicator.fromJson(Map<String, dynamic> json) {
    if (json['indicators'] != null) {
      indicators = <Indicators>[];
      json['indicators'].forEach((v) {
        indicators.add(new Indicators.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.indicators != null) {
      data['indicators'] = this.indicators.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Indicators {
  String name;
  int id;

  Indicators({this.name, this.id});

  Indicators.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}