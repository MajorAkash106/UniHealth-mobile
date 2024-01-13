class CirculationData {
  String lastUpdate;
  List<BloodPressor> bloodPressor;
  List<Vasopressor> vasopressor;

  CirculationData({this.lastUpdate, this.bloodPressor, this.vasopressor});

  CirculationData.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    if (json['blood_pressor'] != null) {
      bloodPressor = new List<BloodPressor>();
      json['blood_pressor'].forEach((v) { bloodPressor.add(new BloodPressor.fromJson(v)); });
    }
    if (json['vasopressor'] != null) {
      vasopressor = new List<Vasopressor>();
      json['vasopressor'].forEach((v) { vasopressor.add(new Vasopressor.fromJson(v)); });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.bloodPressor != null) {
      data['blood_pressor'] = this.bloodPressor.map((v) => v.toJson()).toList();
    }
    if (this.vasopressor != null) {
      data['vasopressor'] = this.vasopressor.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BloodPressor {
  String date;
  String time;
  String sbp;
  String dbp;
  String map;
  String dateTime;

  BloodPressor({this.date, this.time, this.sbp, this.dbp, this.map,this.dateTime});

  BloodPressor.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    sbp = json['sbp'];
    dbp = json['dbp'];
    map = json['map'];
    dateTime = '${json['date']} ${json['time']}:00';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['sbp'] = this.sbp;
    data['dbp'] = this.dbp;
    data['map'] = this.map;
    data['dateTime'] = this.dateTime;
    return data;
  }
}

class Vasopressor {
  String drug;
  String date;
  String time;
  String dateTime;
  String unit_type;
  String drug_amount;
  String concentration;
  String concentration_unit;
  String dose;
  String infusion;
  String diluent;

  Vasopressor({this.drug,this.date,this.dateTime,this.time,this.unit_type,this.drug_amount,this.concentration,this.dose,this.infusion,this.diluent,this.concentration_unit});

Vasopressor.fromJson(Map<String, dynamic> json) {
  drug = json['drug'];
  date = json['date'];
  time = json['time'];
  dateTime = '${json['date']} ${json['time']}:00';
  unit_type = json['unit_type'];
  drug_amount = json['drug_amount'];
  concentration = json['concentration'];
  concentration_unit = json['concentration_unit'];
  dose = json['dose'];
  infusion = json['infusion'];
  diluent = json['diluent'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['drug'] = this.drug;
  data['date'] = this.date;
  data['time'] = this.time;
  data['dateTime'] = this.dateTime;
  data['unit_type'] = this.unit_type;
  data['drug_amount'] = this.drug_amount;
  data['concentration'] = this.concentration;
  data['concentration_unit'] = this.concentration_unit;
  data['dose'] = this.dose;
  data['infusion'] = this.infusion;
  data['diluent'] = this.diluent;
  return data;
}
}
//updated by raman at 14 oct 12:28