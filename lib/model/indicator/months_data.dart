class monthsData {
  List<Info> info;

  monthsData({this.info});

  monthsData.fromJson(Map<String, dynamic> json) {
    if (json['info'] != null) {
      info = <Info>[];
      json['info'].forEach((v) {
        info.add(new Info.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.info != null) {
      data['info'] = this.info.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Info {
  String abbreviation;
  String name;

  Info({this.abbreviation, this.name});

  Info.fromJson(Map<String, dynamic> json) {
    abbreviation = json['abbreviation'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviation'] = this.abbreviation;
    data['name'] = this.name;
    return data;
  }
}
