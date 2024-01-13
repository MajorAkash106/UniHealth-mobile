class Enteral_HistoryModel {
  bool success;
  String message;
  List<Data> data;

  Enteral_HistoryModel({this.success, this.message, this.data});

  Enteral_HistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  Data(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
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
  Enteral_Data enteralData;

  Multipalmessage({this.lastUpdate, this.enteralData});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    enteralData = json['enteral_data'] != null
        ? new Enteral_Data.fromJson(json['enteral_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.enteralData != null) {
      data['enteral_data'] = this.enteralData.toJson();
    }
    return data;
  }
}

class Enteral_Data {
  String lastUpdate;
  List<Last_Selected> lastSelected;
  int teamIndex;
  int tabIndex;
  En_Data enData;
  CaloriesData caloriesData;
  Industrialized_Data industrializedData;
  Manipulated_Data manipulatedData;
  // List<IndustDetailsData> industDetailsData;
  // List<ManiDetailsData> maniDetailsData;

  Enteral_Data(
      {this.lastUpdate,
        this.lastSelected,
        this.teamIndex,
        this.tabIndex,
        this.enData,
        this.caloriesData,
        this.industrializedData,
        this.manipulatedData,
        // this.industDetailsData,
        // this.maniDetailsData
      });

  Enteral_Data.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    if (json['last_selected'] != null) {
      lastSelected = new List<Last_Selected>();
      json['last_selected'].forEach((v) {
        lastSelected.add(new Last_Selected.fromJson(v));
      });
    }
    teamIndex = json['team_index'];
    tabIndex = json['tab_index'];
    enData =
    json['en_data'] != null ? new En_Data.fromJson(json['en_data']) : null;
    caloriesData = json['calories_data'] != null
        ? new CaloriesData.fromJson(json['calories_data'])
        : null;
    industrializedData = json['industrialized_data'] != null
        ? new Industrialized_Data.fromJson(json['industrialized_data'])
        : null;
    manipulatedData = json['manipulated_data'] != null
        ? new Manipulated_Data.fromJson(json['manipulated_data'])
        : null;
    // if (json['indust_details_data'] != null) {
    //   industDetailsData = new List<IndustDetailsData>();
    //   json['indust_details_data'].forEach((v) {
    //     industDetailsData.add(new IndustDetailsData.fromJson(v));
    //   });
    // }
    // if (json['mani_details_data'] != null) {
    //   maniDetailsData = new List<ManiDetailsData>();
    //   json['mani_details_data'].forEach((v) {
    //     maniDetailsData.add(new ManiDetailsData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.lastSelected != null) {
      data['last_selected'] = this.lastSelected.map((v) => v.toJson()).toList();
    }
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
    // if (this.industDetailsData != null) {
    //   data['indust_details_data'] =
    //       this.industDetailsData.map((v) => v.toJson()).toList();
    // }
    // if (this.maniDetailsData != null) {
    //   data['mani_details_data'] =
    //       this.maniDetailsData.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Last_Selected {
  String index;
  String date;

  Last_Selected({this.index, this.date});

  Last_Selected.fromJson(Map<String, dynamic> json) {
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

class En_Data {
  String kcal;
  String protein;
  String fiber;
  String fiberModule;
  String proteinModule;


  En_Data(
      {this.kcal,
        this.protein,
        this.fiber,
        this.fiberModule,
        this.proteinModule,


      });

  En_Data.fromJson(Map<String, dynamic> json) {
    kcal = json['kcal'];
    protein = json['protein'];
    fiber = json['fiber'];
    fiberModule = json['fiber_module'];
    proteinModule = json['protein_module'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kcal'] = this.kcal;
    data['protein'] = this.protein;
    data['fiber'] = this.fiber;
    data['fiber_module'] = this.fiberModule;
    data['protein_module'] = this.proteinModule;

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

class Industrialized_Data {
  String id;
  String title;
  String startTime;
  String mlHr;
  String hrDay;
  String currentWork;
  String lastUpdate;
  En_Data enData;

  Industrialized_Data(
      {this.id,
        this.title,
        this.startTime,
        this.mlHr,
        this.hrDay,
        this.currentWork,
        this.lastUpdate,
        this.enData});

  Industrialized_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    startTime = json['start_time'];
    mlHr = json['ml_hr'];
    hrDay = json['hr_day'];
    currentWork = json['current_work'];
    lastUpdate = json['lastUpdate'];
    enData =
    json['en_data'] != null ? new En_Data.fromJson(json['en_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['start_time'] = this.startTime;
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

class Manipulated_Data {
  String id;
  String title;
  String mlDose;
  String currentWork;
  List<Doses_Data> dosesData;
  String lastUpdate;
  En_Data enData;

  Manipulated_Data(
      {this.id,
        this.title,
        this.mlDose,
        this.currentWork,
        this.dosesData,
        this.lastUpdate,
        this.enData});

  Manipulated_Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    mlDose = json['ml_dose'];
    currentWork = json['current_work'];
    if (json['doses_data'] != null) {
      dosesData = new List<Doses_Data>();
      json['doses_data'].forEach((v) {
        dosesData.add(new Doses_Data.fromJson(v));
      });
    }
    lastUpdate = json['lastUpdate'];
    enData =
    json['en_data'] != null ? new En_Data.fromJson(json['en_data']) : null;
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
    data['lastUpdate'] = this.lastUpdate;
    if (this.enData != null) {
      data['en_data'] = this.enData.toJson();
    }
    return data;
  }
}

class Doses_Data {
  String hour;
  String timePerday;
  bool istoday;
  String schduleDate;
  int index;

  Doses_Data(
      {this.hour, this.timePerday, this.istoday, this.schduleDate, this.index});

  Doses_Data.fromJson(Map<String, dynamic> json) {
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