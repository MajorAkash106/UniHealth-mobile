import 'package:medical_app/model/NutritionalTherapy/module_model.dart';

class EnteralData {
  String lastUpdate;
  int teamIndex;
  int tabIndex;
  EnData enData;
  CaloriesData caloriesData;
  IndustrializedData industrializedData;
  ManipulatedData manipulatedData;
  Reducesed_justification reducesed_justification;
  List<IndustrializedData> industDetailsData;
  List<ManipulatedData> maniDetailsData;
  List<LastSelected> lastSelected;

  EnteralData(
      {this.lastUpdate,
        this.teamIndex,
        this.tabIndex,
        this.enData,
        this.caloriesData,
        this.industrializedData,
        this.manipulatedData,
        this.reducesed_justification,
        this.industDetailsData,this.maniDetailsData,this.lastSelected});

  EnteralData.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    teamIndex = json['team_index'];
    tabIndex = json['tab_index'];
    enData =
    json['en_data'] != null ? new EnData.fromJson(json['en_data']) : null;
    caloriesData = json['calories_data'] != null
        ? new CaloriesData.fromJson(json['calories_data'])
        : null;
    industrializedData = json['industrialized_data'] != null
        ? new IndustrializedData.fromJson(json['industrialized_data'])
        : null;
    manipulatedData = json['manipulated_data'] != null
        ? new ManipulatedData.fromJson(json['manipulated_data'])
        : null;
    reducesed_justification = json['reduced_justification'] != null
        ? new Reducesed_justification.fromJson(json['reduced_justification'])
        : null;
    if (json['indust_details_data'] != null) {
      industDetailsData = new List<IndustrializedData>();
      json['indust_details_data'].forEach((v) {
        industDetailsData.add(new IndustrializedData.fromJson(v));
      });
    }
    if (json['mani_details_data'] != null) {
      maniDetailsData = new List<ManipulatedData>();
      json['mani_details_data'].forEach((v) {
        maniDetailsData.add(new ManipulatedData.fromJson(v));
      });
    }
    if (json['last_selected'] != null) {
      lastSelected = new List<LastSelected>();
      json['last_selected'].forEach((v) {
        lastSelected.add(new LastSelected.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['team_index'] = this.teamIndex;
    data['tab_index'] = this.tabIndex;
    if (this.enData != null) {
      data['en_data'] = this.enData.toJson();
    }
    if (this.caloriesData != null) {
      data['calories_data'] = this.caloriesData.toJson();
    }
    if (this.industrializedData != null) {
      data['industrialized_data'] = this.industrializedData.toJson();
    }
    if (this.manipulatedData != null) {
      data['manipulated_data'] = this.manipulatedData.toJson();
    }
    if (this.reducesed_justification != null) {
      data['reduced_justification'] = this.reducesed_justification.toJson();
    }
    if (this.industDetailsData != null) {
      data['indust_details_data'] =
          this.industDetailsData.map((v) => v.toJson()).toList();
    }
    if (this.maniDetailsData != null) {
      data['mani_details_data'] =
          this.maniDetailsData.map((v) => v.toJson()).toList();
    }
    if (this.lastSelected != null) {
      data['last_selected'] = this.lastSelected.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EnData {
  String kcal;
  String protein;
  String fiber;
  String fiberModule;
  String proteinModule;
  String plan_ptn;
  String plan_kcal;
  String total_volume;
  String proteinModule_name;
  ModuleDetail protienModluleDetail;
  ModuleDetail fiberModluleDetail;
  String fiberModule_name;

  EnData(
      {this.kcal,
        this.protein,
        this.fiber,
        this.fiberModule,
        this.proteinModule,this.plan_ptn,this.plan_kcal,this.total_volume,
      this.fiberModule_name,
        this.proteinModule_name,
        this.protienModluleDetail,
        this.fiberModluleDetail
      });

  EnData.fromJson(Map<String, dynamic> json) {
    kcal = json['kcal'];
    protein = json['protein'];
    fiber = json['fiber'];
    fiberModule = json['fiber_module'];
    proteinModule = json['protein_module'];
    plan_ptn = json['plan_ptn'];
    plan_kcal = json['plan_kcal'];
    total_volume = json['total_volume'];
    fiberModule_name = json['fiberModule_name'];
    proteinModule_name = json['proteinModule_name'];
    protienModluleDetail = json['proteinModuleDetail'] != null ? new ModuleDetail.fromJson(json['proteinModuleDetail']) : null;
    fiberModluleDetail = json['fiberModuleDetail'] != null ? new ModuleDetail.fromJson(json['fiberModuleDetail']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kcal'] = this.kcal;
    data['protein'] = this.protein;
    data['fiber'] = this.fiber;
    data['fiber_module'] = this.fiberModule;
    data['protein_module'] = this.proteinModule;
    data['plan_ptn'] = this.plan_ptn;
    data['plan_kcal'] = this.plan_kcal;
    data['total_volume'] = this.total_volume;
    data['fiberModule_name'] = this.fiberModule_name;
    data['proteinModule_name'] = this.proteinModule_name;
    if (this.protienModluleDetail != null) {
      data['proteinModuleDetail'] = this.protienModluleDetail.toJson();
    }

    if (this.fiberModluleDetail != null) {
      data['fiberModuleDetail'] = this.fiberModluleDetail.toJson();
    }
    return data;
  }
}

class CaloriesData {
  String propofol;
  String glucose;
  String citrate;
  String total;

  CaloriesData({this.propofol, this.glucose, this.citrate, this.total});

  CaloriesData.fromJson(Map<String, dynamic> json) {
    propofol = json['propofol'];
    glucose = json['glucose'];
    citrate = json['citrate'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['propofol'] = this.propofol;
    data['glucose'] = this.glucose;
    data['citrate'] = this.citrate;
    data['total'] = this.total;
    return data;
  }
}

class IndustrializedData {
  String id;
  String title;
  String startTime;
  String startDate;
  String mlHr;
  String hrDay;
  String currentWork;
  String lastUpdate;
  EnData enData;

  IndustrializedData(
      {this.id,
        this.title,
        this.startTime,
        this.startDate,
        this.mlHr,
        this.hrDay,
        this.currentWork,this.lastUpdate,this.enData});

  IndustrializedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startTime = json['start_time'];
    startDate = json['start_date'];
    mlHr = json['ml_hr'];
    hrDay = json['hr_day'];
    currentWork = json['current_work'];
    lastUpdate = json['lastUpdate'];
    enData =
    json['en_data'] != null ? new EnData.fromJson(json['en_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['start_time'] = this.startTime;
    data['start_date'] = this.startDate;
    data['ml_hr'] = this.mlHr;
    data['hr_day'] = this.hrDay;
    data['current_work'] = this.currentWork;
    data['lastUpdate'] = this.lastUpdate;
    if (this.enData != null) {
      data['en_data'] = this.enData.toJson();
    }
    return data;
  }
}

class ManipulatedData {
  String id;
  String title;
  String mlDose;
  String currentWork;
  List<DosesData> dosesData;
  String lastUpdate;
  EnData enData;

  ManipulatedData(
      {this.id, this.title, this.mlDose, this.currentWork, this.dosesData, this.enData, this.lastUpdate});

  ManipulatedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mlDose = json['ml_dose'];
    currentWork = json['current_work'];
    if (json['doses_data'] != null) {
      dosesData = new List<DosesData>();
      json['doses_data'].forEach((v) {
        dosesData.add(new DosesData.fromJson(v));
      });
    }
    enData =
    json['en_data'] != null ? new EnData.fromJson(json['en_data']) : null;
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['ml_dose'] = this.mlDose;
    data['current_work'] = this.currentWork;
    if (this.dosesData != null) {
      data['doses_data'] = this.dosesData.map((v) => v.toJson()).toList();
    }
    if (this.enData != null) {
      data['en_data'] = this.enData.toJson();
    }
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

class DosesData {
  String hour;
  String timePerday;
  bool istoday;
  String schduleDate;
  int index;

  DosesData(
      {this.hour, this.timePerday, this.istoday, this.schduleDate, this.index});

  DosesData.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    timePerday = json['timePerday'];
    istoday = json['istoday'];
    schduleDate = json['schdule_date'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['timePerday'] = this.timePerday;
    data['istoday'] = this.istoday;
    data['schdule_date'] = this.schduleDate;
    data['index'] = this.index;
    return data;
  }
}

class LastSelected {
  String index;
  String date;

  LastSelected({this.index, this.date});

  LastSelected.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['date'] = this.date;
    return data;
  }
}


class Reducesed_justification{
  String lastUpdate;
 String justification;
 String surgery_postOp;
 List<Surgery_postOpList> surgery_postOpList;


 Reducesed_justification(
     {this.lastUpdate, this.justification, this.surgery_postOp, this.surgery_postOpList, });

 Reducesed_justification.fromJson(Map<String, dynamic> json) {
   lastUpdate = json['lastUpdate'];
   justification = json['justification'];
   surgery_postOp = json['surgery_postOp'];

   if (json['surgery_postOpList'] != null) {
     surgery_postOpList = new List<Surgery_postOpList>();
     json['surgery_postOpList'].forEach((v) {
       surgery_postOpList.add(new Surgery_postOpList.fromJson(v));
     });
   }

 }

 Map<String, dynamic> toJson(){
   final Map<String, dynamic> data = new Map<String, dynamic>();
   data['lastUpdate'] = this.lastUpdate;
   data['justification'] = this.justification;
   data['surgery_postOp'] = this.surgery_postOp;

   if (this.surgery_postOpList != null) {
     data['surgery_postOpList'] = this.surgery_postOpList.map((v) => v.toJson()).toList();
   }


   return data;
 }




}



class Surgery_postOpList{
  String lastUpdate;
  String surgery_postOp;
  String type;
  Surgery_postOpList({this.lastUpdate,this.surgery_postOp,this.type});

  Surgery_postOpList.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    surgery_postOp = json['surgery_postOp'];
    type = json['type'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['surgery_postOp'] = this.surgery_postOp;
    data['type'] = this.type;

    return data;
  }

}
