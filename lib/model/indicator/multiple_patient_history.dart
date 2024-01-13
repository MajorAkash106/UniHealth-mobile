import 'package:medical_app/config/ad_log.dart';

import '../../config/cons/cons.dart';
import '../vigilance/abdomen_history.dart';
import '../../screens/badges/NutritionalTherapy/enteralNutritional/enteral_History_Model.dart'
    as en;

class MultiplePatientHistory {
  bool success;
  String message;
  List<mHistory> data;

  MultiplePatientHistory({this.success, this.message, this.data});

  MultiplePatientHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <mHistory>[];
      json['data'].forEach((v) {
        data.add(new mHistory.fromJson(v));
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

class mHistory {
  String patientId;
  String type;
  List<AbdomenHistoryData> historyAbdomen;
  List<en.Data> historyEn;

  mHistory({this.patientId, this.type, this.historyAbdomen, this.historyEn});

  mHistory.fromJson(Map<String, dynamic> json) {
    patientId = json['patientId'];
    type = json['type'];
    if (json['history'] != null) {
      historyAbdomen = <AbdomenHistoryData>[];
      historyEn = <en.Data>[];
      if (type == ConstConfig.abdomenHistory) {
        // adLog('type:: $type');
        json['history'].forEach((v) {
          historyAbdomen.add(new AbdomenHistoryData.fromJson(v));
        });
      } else {
        // adLog('type:: $type');
        json['history'].forEach((v) {
          historyEn.add(new en.Data.fromJson(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientId'] = this.patientId;
    data['type'] = this.type;
    if (this.historyAbdomen != null) {
      data['history'] = this.historyAbdomen.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
