import 'package:medical_app/model/patientDetailsModel.dart';

class PatientList {
  bool success;
  String message;
  List<PatientDetailsData> data;

  PatientList({this.success, this.message, this.data});

  PatientList.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PatientDetailsData>[];
      json['data'].forEach((v) {
        data.add(new PatientDetailsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}