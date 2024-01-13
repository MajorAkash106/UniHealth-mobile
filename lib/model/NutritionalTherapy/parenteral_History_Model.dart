class Parenteral_HIstoryModel {
  bool success;
  String message;
  List<Data_history> data;

  Parenteral_HIstoryModel({this.success, this.message, this.data});

  Parenteral_HIstoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data_history>();
      json['data'].forEach((v) {
        data.add(new Data_history.fromJson(v));
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

class Data_history {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  Data_history(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data_history.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['multipalmessage'] != null) {
      multipalmessage = new List<Multipalmessage>();
      json['multipalmessage'].forEach((v) {
        multipalmessage.add(new Multipalmessage.fromJson(v));
      });
    }
    type = json['type'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.multipalmessage != null) {
      data['multipalmessage'] =
          this.multipalmessage.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Multipalmessage {
  String lastUpdate;
  ParenteralData_histoy parenteralData;

  Multipalmessage({this.lastUpdate, this.parenteralData});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    parenteralData = json['parenteral_data'] != null
        ? new ParenteralData_histoy.fromJson(json['parenteral_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.parenteralData != null) {
      data['parenteral_data'] = this.parenteralData.toJson();
    }
    return data;
  }
}

class ParenteralData_histoy {
  String lastUpdate;
  int teamStatus;
  bool tabStatus;
  ReadyToUse_history readyToUse;
  Manipulated_history manipulated;
  NonNutritional_history nonNutritional;

  ParenteralData_histoy(
      {this.lastUpdate,
        this.teamStatus,
        this.tabStatus,
        this.readyToUse,
        this.manipulated,
        this.nonNutritional});

  ParenteralData_histoy.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    teamStatus = json['team_status'];
    tabStatus = json['tab_status'];
    readyToUse = json['ready_to_use'] != null
        ? new ReadyToUse_history.fromJson(json['ready_to_use'])
        : null;
    manipulated = json['manipulated'] != null
        ? new Manipulated_history.fromJson(json['manipulated'])
        : null;
    nonNutritional = json['non_nutritional'] != null
        ? new NonNutritional_history.fromJson(json['non_nutritional'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
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
    return data;
  }
}

class ReadyToUse_history {
  String lastUpdate;
  String title;
  String titleId;
  String bagPerDay;
  String startTime;
  String hrInfusion;
  String totalVol;
  String totalCal;
  String currentWork;
  TotalMacro_history totalMacro;
  RelativeMacro_history relativeMacro;

  ReadyToUse_history(
      {this.lastUpdate,
        this.title,
        this.titleId,
        this.bagPerDay,
        this.startTime,
        this.hrInfusion,
        this.totalVol,
        this.totalCal,
        this.currentWork,
        this.totalMacro,
        this.relativeMacro});

  ReadyToUse_history.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    title = json['title'];
    titleId = json['title_id'];
    bagPerDay = json['bag_per_day'];
    startTime = json['start_time'];
    hrInfusion = json['hr_infusion'];
    totalVol = json['total_vol'];
    totalCal = json['total_cal'];
    currentWork = json['current_work'];
    totalMacro = json['total_macro'] != null
        ? new TotalMacro_history.fromJson(json['total_macro'])
        : null;
    relativeMacro = json['relative_macro'] != null
        ? new RelativeMacro_history.fromJson(json['relative_macro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['title'] = this.title;
    data['title_id'] = this.titleId;
    data['bag_per_day'] = this.bagPerDay;
    data['start_time'] = this.startTime;
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

class TotalMacro_history {
  String protein;
  String liquid;
  String glucose;

  TotalMacro_history({this.protein, this.liquid, this.glucose});

  TotalMacro_history.fromJson(Map<String, dynamic> json) {
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

class RelativeMacro_history {
  String liquid;
  String glucose;

  RelativeMacro_history({this.liquid, this.glucose});

  RelativeMacro_history.fromJson(Map<String, dynamic> json) {
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

class Manipulated_history {
  String lastUpdate;
  String startTime;
  String hrInfusion;
  String totalVol;
  String totalCal;
  String currentWork;
  TotalMacro_history totalMacro;
  RelativeMacro_history relativeMacro;

  Manipulated_history(
      {this.lastUpdate,
        this.startTime,
        this.hrInfusion,
        this.totalVol,
        this.totalCal,
        this.currentWork,
        this.totalMacro,
        this.relativeMacro});

  Manipulated_history.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    startTime = json['start_time'];
    hrInfusion = json['hr_infusion'];
    totalVol = json['total_vol'];
    totalCal = json['total_cal'];
    currentWork = json['current_work'];
    totalMacro = json['total_macro'] != null
        ? new TotalMacro_history.fromJson(json['total_macro'])
        : null;
    relativeMacro = json['relative_macro'] != null
        ? new RelativeMacro_history.fromJson(json['relative_macro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['start_time'] = this.startTime;
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

class NonNutritional_history {
  String propofol;
  String glucose;
  String citrate;
  String total;

  NonNutritional_history({this.propofol, this.glucose, this.citrate, this.total});

  NonNutritional_history.fromJson(Map<String, dynamic> json) {
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