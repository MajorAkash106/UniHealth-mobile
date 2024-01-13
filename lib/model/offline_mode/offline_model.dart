import 'package:medical_app/model/NutritionalTherapy/Parenteral_NutritionalModel.dart';
import 'package:medical_app/model/NutritionalTherapy/adult_condition_model.dart';
import 'package:medical_app/model/NutritionalTherapy/diet_category.dart';
import 'package:medical_app/model/NutritionalTherapy/enteral_formula_model.dart';
import 'package:medical_app/model/NutritionalTherapy/module_model.dart';
import 'package:medical_app/model/NutritionalTherapy/ons_acceptance_model.dart';

class Offline {
  NtPanel ntPanel;

  Offline({this.ntPanel});

  Offline.fromJson(Map<String, dynamic> json) {
    ntPanel =
    json['ntPanel'] != null ? new NtPanel.fromJson(json['ntPanel']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ntPanel != null) {
      data['ntPanel'] = this.ntPanel.toJson();
    }
    return data;
  }
}

class NtPanel {
  List<ConditionData> adultNonIcu;
  List<ConditionData> adultIcu;
  List<DataDietCategory> fastingOral;
  ONSDATA onsdata;
  EnteralFormulaModel enternalData;
  ModuleModel moduleData;
  List<PARENTERALDATA> parenteralData;

  NtPanel({this.adultNonIcu, this.adultIcu, this.fastingOral,this.onsdata,this.enternalData,this.moduleData,this.parenteralData});

  NtPanel.fromJson(Map<String, dynamic> json) {
    if (json['adult_non_icu'] != null) {
      adultNonIcu = new List<ConditionData>();
      json['adult_non_icu'].forEach((v) {
        adultNonIcu.add(new ConditionData.fromJson(v));
      });
    }
    if (json['adult_icu'] != null) {
      adultIcu = new List<ConditionData>();
      json['adult_icu'].forEach((v) {
        adultIcu.add(new ConditionData.fromJson(v));
      });
    }
    if (json['fasting_oral'] != null) {
      fastingOral = new List<DataDietCategory>();
      json['fasting_oral'].forEach((v) {
        fastingOral.add(new DataDietCategory.fromJson(v));
      });
    }
    onsdata =
    json['ons_data'] != null ? new ONSDATA.fromJson(json['ons_data']) : null;
    enternalData =
    json['enteral_data'] != null ? new EnteralFormulaModel.fromJson(json['enteral_data']) : null;
    moduleData =
    json['modules_data'] != null ? new ModuleModel.fromJson(json['modules_data']) : null;

    if (json['parenteral_data'] != null) {
      parenteralData = new List<PARENTERALDATA>();
      json['parenteral_data'].forEach((v) {
        parenteralData.add(new PARENTERALDATA.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.adultNonIcu != null) {
      data['adult_non_icu'] = this.adultNonIcu.map((v) => v.toJson()).toList();
    }
    if (this.adultIcu != null) {
      data['adult_icu'] = this.adultIcu.map((v) => v.toJson()).toList();
    }
    if (this.fastingOral != null) {
      data['fasting_oral'] = this.fastingOral.map((v) => v.toJson()).toList();
    }
    if (this.onsdata != null) {
      data['ons_data'] = this.onsdata.toJson();
    }
    if (this.enternalData != null) {
      data['enteral_data'] = this.enternalData.toJson();
    }
    if (this.moduleData != null) {
      data['modules_data'] = this.moduleData.toJson();
    }

    if (this.parenteralData != null) {
      data['parenteral_data'] = this.parenteralData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


