class State_CityModel {
  List<Cities> cities;
  List<States> states;

  State_CityModel({this.cities, this.states});

  State_CityModel.fromJson(Map<String, dynamic> json) {
    if (json['Cities'] != null) {
      cities = new List<Cities>();
      json['Cities'].forEach((v) {
        cities.add(new Cities.fromJson(v));
      });
    }
    if (json['States'] != null) {
      states = new List<States>();
      json['States'].forEach((v) {
        states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cities != null) {
      data['Cities'] = this.cities.map((v) => v.toJson()).toList();
    }
    if (this.states != null) {
      data['States'] = this.states.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String sTATE;
  String cITY;

  Cities({this.sTATE, this.cITY});

  Cities.fromJson(Map<String, dynamic> json) {
    sTATE = json['STATE'];
    cITY = json['CITY'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['STATE'] = this.sTATE;
    data['CITY'] = this.cITY;
    return data;
  }
}

class States {
  String rO;

  States({this.rO});

  States.fromJson(Map<String, dynamic> json) {
    rO = json['RO'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RO'] = this.rO;
    return data;
  }
}