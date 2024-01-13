import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';

class ParenteralData {
  String lastUpdate;
  List<LastSelected> lastSelected;
  int teamStatus;
  bool tabStatus;
  ReadyToUse readyToUse;
  Manipulated manipulated;
  NonNutritional nonNutritional;
  List<ReadyToUse> readyToUseDetails;
  List<Manipulated> manipulatedDetails;
  Reducesed_justification reducesed_justification;

  ParenteralData(
      {this.lastUpdate,
        this.lastSelected,
        this.teamStatus,
        this.tabStatus,
        this.readyToUse,
        this.manipulated,
        this.nonNutritional,
        this.readyToUseDetails,
        this.manipulatedDetails,
        this.reducesed_justification

      });

  ParenteralData.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    if (json['last_selected'] != null) {
      lastSelected = new List<LastSelected>();
      json['last_selected'].forEach((v) {
        lastSelected.add(new LastSelected.fromJson(v));
      });
    }
    teamStatus = json['team_status'];
    tabStatus = json['tab_status'];
    readyToUse = json['ready_to_use'] != null
        ? new ReadyToUse.fromJson(json['ready_to_use'])
        : null;
    manipulated = json['manipulated'] != null
        ? new Manipulated.fromJson(json['manipulated'])
        : null;
    nonNutritional = json['non_nutritional'] != null
        ? new NonNutritional.fromJson(json['non_nutritional'])
        : null;
    if (json['ready_to_use_details'] != null) {
      readyToUseDetails = new List<ReadyToUse>();
      json['ready_to_use_details'].forEach((v) {
        readyToUseDetails.add(new ReadyToUse.fromJson(v));
      });
    }
    if (json['manipulated_details'] != null) {
      manipulatedDetails = new List<Manipulated>();
      json['manipulated_details'].forEach((v) {
        manipulatedDetails.add(new Manipulated.fromJson(v));
      });
    }
    reducesed_justification = json['reduced_justification'] != null
        ? new Reducesed_justification.fromJson(json['reduced_justification'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.lastSelected != null) {
      data['last_selected'] = this.lastSelected.map((v) => v.toJson()).toList();
    }
    data['team_status'] = this.teamStatus;
    data['tab_status'] = this.tabStatus;
    if (this.readyToUse != null) {
      data['ready_to_use'] = this.readyToUse.toJson();
    }
    if (this.manipulated != null) {
      data['manipulated'] = this.manipulated.toJson();
    }

    if (this.nonNutritional != null) {
      data['non_nutritional'] = this.nonNutritional.toJson();
    }
    if (this.readyToUseDetails != null) {
      data['ready_to_use_details'] =
          this.readyToUseDetails.map((v) => v.toJson()).toList();
    }
    if (this.manipulatedDetails != null) {
      data['manipulated_details'] =
          this.manipulatedDetails.map((v) => v.toJson()).toList();
    }
    if (this.reducesed_justification != null) {
      data['reduced_justification'] = this.reducesed_justification.toJson();
    }
    return data;
  }
}

class LastSelected {
  String lastUpdate;
  bool tabStatus;

  LastSelected({this.lastUpdate, this.tabStatus});

  LastSelected.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    tabStatus = json['tab_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['tab_status'] = this.tabStatus;
    return data;
  }
}

class ReadyToUse {
  String lastUpdate;
  String title;
  String titleId;
  String bagPerDay;
  String bagsFromAdmin;
  String startTime;
  String startDate;
  String hrInfusion;
  String totalVol;
  String totalCal;
  String currentWork;
  TotalMacro totalMacro;
  RelativeMacro relativeMacro;

  ReadyToUse(
      {this.lastUpdate,
        this.title,
        this.titleId,
        this.bagPerDay,
        this.bagsFromAdmin,
        this.startTime,
        this.startDate,
        this.hrInfusion,
        this.totalVol,
        this.totalCal,
        this.currentWork,
        this.totalMacro,
        this.relativeMacro});

  ReadyToUse.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    title = json['title'];
    titleId = json['title_id'];
    bagPerDay = json['bag_per_day'];
    bagsFromAdmin = json['bags_from_admin'];
    startTime = json['start_time'];
    startDate = json['start_date'];
    hrInfusion = json['hr_infusion'];
    totalVol = json['total_vol'];
    totalCal = json['total_cal'];
    currentWork = json['current_work'];
    totalMacro = json['total_macro'] != null
        ? new TotalMacro.fromJson(json['total_macro'])
        : null;
    relativeMacro = json['relative_macro'] != null
        ? new RelativeMacro.fromJson(json['relative_macro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['title'] = this.title;
    data['title_id'] = this.titleId;
    data['bag_per_day'] = this.bagPerDay;
    data['bags_from_admin'] = this.bagsFromAdmin;
    data['start_time'] = this.startTime;
    data['start_date'] = this.startDate;
    data['hr_infusion'] = this.hrInfusion;
    data['total_vol'] = this.totalVol;
    data['total_cal'] = this.totalCal;
    data['current_work'] = this.currentWork;
    if (this.totalMacro != null) {
      data['total_macro'] = this.totalMacro.toJson();
    }
    if (this.relativeMacro != null) {
      data['relative_macro'] = this.relativeMacro.toJson();
    }
    return data;
  }
}

class TotalMacro {
  String protein;
  String liquid;
  String glucose;

  TotalMacro({this.protein, this.liquid, this.glucose});

  TotalMacro.fromJson(Map<String, dynamic> json) {
    protein = json['protein'];
    liquid = json['liquid'];
    glucose = json['glucose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['protein'] = this.protein;
    data['liquid'] = this.liquid;
    data['glucose'] = this.glucose;
    return data;
  }
}

class RelativeMacro {
  String liquid;
  String glucose;

  RelativeMacro({this.liquid, this.glucose});

  RelativeMacro.fromJson(Map<String, dynamic> json) {
    liquid = json['liquid'];
    glucose = json['glucose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['liquid'] = this.liquid;
    data['glucose'] = this.glucose;
    return data;
  }
}

class Manipulated {
  String lastUpdate;
  String startTime;
  String startDate;
  String hrInfusion;
  String totalVol;
  String totalCal;
  String currentWork;
  TotalMacro totalMacro;
  RelativeMacro relativeMacro;

  Manipulated(
      {this.lastUpdate,
        this.startTime,
        this.startDate,
        this.hrInfusion,
        this.totalVol,
        this.totalCal,
        this.currentWork,
        this.totalMacro,
        this.relativeMacro});

  Manipulated.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    startTime = json['start_time'];
    startDate = json['start_date'];
    hrInfusion = json['hr_infusion'];
    totalVol = json['total_vol'];
    totalCal = json['total_cal'];
    currentWork = json['current_work'];
    totalMacro = json['total_macro'] != null
        ? new TotalMacro.fromJson(json['total_macro'])
        : null;
    relativeMacro = json['relative_macro'] != null
        ? new RelativeMacro.fromJson(json['relative_macro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['start_time'] = this.startTime;
    data['start_date'] = this.startDate;
    data['hr_infusion'] = this.hrInfusion;
    data['total_vol'] = this.totalVol;
    data['total_cal'] = this.totalCal;
    data['current_work'] = this.currentWork;
    if (this.totalMacro != null) {
      data['total_macro'] = this.totalMacro.toJson();
    }
    if (this.relativeMacro != null) {
      data['relative_macro'] = this.relativeMacro.toJson();
    }
    return data;
  }
}

class NonNutritional {
  String propofol;
  String glucose;
  String citrate;
  String total;

  NonNutritional({this.propofol, this.glucose, this.citrate, this.total});

  NonNutritional.fromJson(Map<String, dynamic> json) {
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