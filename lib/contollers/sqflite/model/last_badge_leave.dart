class LastBadges {
  String patientId;
  int lastIndex;
  int statusIndex;
  int vigiIndex;
  int ntIndex;

  LastBadges({this.patientId, this.lastIndex,this.statusIndex,this.ntIndex});

  LastBadges.fromJson(Map<String, dynamic> json) {
    patientId = json['patient_id'];
    lastIndex = json['last_index'];
    statusIndex = json['status_index'];
    vigiIndex = json['vigi_index'];
    ntIndex = json['nt_index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patient_id'] = this.patientId;
    data['last_index'] = this.lastIndex;
    data['status_index'] = this.statusIndex;
    data['vigi_index'] = this.vigiIndex;
    data['nt_index'] = this.ntIndex;
    return data;
  }
}