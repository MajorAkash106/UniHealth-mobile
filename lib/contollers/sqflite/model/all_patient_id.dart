class patientIsArray {
  List<AllPatientIds> allPatientIds;

  patientIsArray({this.allPatientIds});

  patientIsArray.fromJson(Map<String, dynamic> json) {
    if (json['all_patient_ids'] != null) {
      allPatientIds = new List<AllPatientIds>();
      json['all_patient_ids'].forEach((v) {
        allPatientIds.add(new AllPatientIds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allPatientIds != null) {
      data['all_patient_ids'] =
          this.allPatientIds.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllPatientIds {
  String patientId;

  AllPatientIds({this.patientId});

  AllPatientIds.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    return data;
  }
}