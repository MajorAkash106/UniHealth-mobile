import 'package:medical_app/model/NutritionalTherapy/enteral_data_model.dart';
import 'package:medical_app/model/NutritionalTherapy/fasting_oral_data.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/NutritionalTherapy/parenteral_model.dart';

class Ntdata {
  List<Result> result;
  String score;
  String type;
  String status;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  Ntdata(
      {this.result,
      this.score,
      this.type,
      this.status,
      this.isBlocked,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Ntdata.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<Result>();
      json['result'].forEach((v) {
        result.add(new Result.fromJson(v));
      });
    }
    score = json['score'];
    type = json['type'];
    status = json['status'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['score'] = this.score;
    data['type'] = this.type;
    data['status'] = this.status;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Result {
  String lastUpdate;
  String condition;
  String info;
  int indexPAC;
  CutomizedData cutomizedData;
  List<CutomizedData> conditionDetails;
  String adultsIcu;
  String adultsNonIcu;
  bool teamAgree;
  bool fasting;
  String fasting_reason;
  String description;
  String kcal;
  String ptn;

  String fiber;
  String volume;
  String times;

  String totalKcal;
  String totalPtn;
  String totalFiber;

  List<Ons> onsData;

  List<OralData> oralData;
  List<OralData> last3daysData;

  EnteralData enteralData;
  ParenteralData parenteralData;
  List<ParenteralData> parenteralDetails;

  List<FastingOralData> fastingOralData;

  NonNutritional nonNutritional;

  Result(
      {this.lastUpdate,
      this.condition,
      this.indexPAC,
      this.fasting,
      this.info,
      this.description,
      this.cutomizedData,
      this.teamAgree,
      this.kcal,
      this.ptn,
      this.fasting_reason,this.conditionDetails,
      this.fiber,
      this.volume,
      this.times,
      this.onsData,
      this.totalKcal,
      this.totalPtn,
      this.totalFiber,
      this.oralData,
        this.last3daysData,
      this.enteralData,
      this.parenteralData,
      this.fastingOralData,
      this.adultsIcu,
      this.adultsNonIcu,this.nonNutritional});

  Result.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    condition = json['condition'];
    info = json['info'];
    indexPAC = json['indexPAC'];
    cutomizedData = json['cutomized_data'] != null
        ? new CutomizedData.fromJson(json['cutomized_data'])
        : null;
    if (json['condition_details'] != null) {
      conditionDetails = new List<CutomizedData>();
      json['condition_details'].forEach((v) {
        conditionDetails.add(new CutomizedData.fromJson(v));
      });
    }

    adultsIcu = json['adults_icu'];
    adultsNonIcu = json['adults_non_icu'];

    teamAgree = json['team_agree'];
    fasting = json['fasting'];
    fasting_reason = json['fasting_reason'];
    description = json['description'];
    kcal = json['kcal']??"";
    ptn = json['ptn'];

    fiber = json['fiber'];
    volume = json['volume'];
    times = json['times'];

    totalKcal = json['total_kcal'];
    totalPtn = json['total_ptn'];
    totalFiber = json['total_fiber'];

    if (json['ons'] != null) {
      onsData = new List<Ons>();
      json['ons'].forEach((v) {
        onsData.add(new Ons.fromJson(v));
      });
    }

    if (json['oral_data'] != null) {
      oralData = new List<OralData>();
      json['oral_data'].forEach((v) {
        oralData.add(new OralData.fromJson(v));
      });
    }
    if (json['last3daysData'] != null) {
      last3daysData = new List<OralData>();
      json['last3daysData'].forEach((v) {
        last3daysData.add(new OralData.fromJson(v));
      });
    }

    enteralData = json['enteral_data'] != null
        ? new EnteralData.fromJson(json['enteral_data'])
        : null;

    parenteralData = json['parenteral_data'] != null
        ? new ParenteralData.fromJson(json['parenteral_data'])
        : null;

    if (json['parenteral_details'] != null) {
      parenteralDetails = new List<ParenteralData>();
      json['parenteral_details'].forEach((v) {
        parenteralDetails.add(new ParenteralData.fromJson(v));
      });
    }

    if (json['fasting_oral_data'] != null) {
      fastingOralData = new List<FastingOralData>();
      json['fasting_oral_data'].forEach((v) {
        fastingOralData.add(new FastingOralData.fromJson(v));
      });
    }

    nonNutritional = json['non_nutritional'] != null
        ? new NonNutritional.fromJson(json['non_nutritional'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['condition'] = this.condition;
    data['info'] = this.info;
    data['indexPAC'] = this.indexPAC;
    if (this.cutomizedData != null) {
      data['cutomized_data'] = this.cutomizedData.toJson();
    }
    data['adults_icu'] = this.adultsIcu;
    data['adults_non_icu'] = this.adultsNonIcu;

    data['team_agree'] = this.teamAgree;
    data['fasting'] = this.fasting;
    data['fasting_reason'] = this.fasting_reason;
    data['description'] = this.description;
    data['kcal'] = this.kcal;
    data['ptn'] = this.ptn;

    data['total_kcal'] = this.totalKcal;
    data['total_ptn'] = this.totalPtn;
    data['total_fiber'] = this.totalFiber;

    data['fiber'] = this.fiber;
    data['volume'] = this.volume;
    data['times'] = this.times;

    if (this.onsData != null) {
      data['ons'] = this.onsData.map((v) => v.toJson()).toList();
    }

    if (this.oralData != null) {
      data['oral_data'] = this.oralData.map((v) => v.toJson()).toList();
    }
    if (this.last3daysData != null) {
      data['last3daysData'] = this.last3daysData.map((v) => v.toJson()).toList();
    }

    if (this.enteralData != null) {
      data['enteral_data'] = this.enteralData.toJson();
    }

    if (this.parenteralData != null) {
      data['parenteral_data'] = this.parenteralData.toJson();
    }

    if (this.parenteralDetails != null) {
      data['parenteral_details'] =
          this.parenteralDetails.map((v) => v.toJson()).toList();
    }
    if (this.fastingOralData != null) {
      data['fasting_oral_data'] =
          this.fastingOralData.map((v) => v.toJson()).toList();
    }
    if (this.conditionDetails != null) {
      data['condition_details'] =
          this.conditionDetails.map((v) => v.toJson()).toList();
    }
    if (this.nonNutritional != null) {
      data['non_nutritional'] = this.nonNutritional.toJson();
    }

    return data;
  }
}

class CutomizedData {
  String minEnergy;
  String maxEnergy;
  String minProtien;
  String maxProtien;

  String minEnergyValue;
  String maxEnergyValue;
  String minProtienValue;
  String manProtienValue;

  String lastUpdate;
  String condition;

  CutomizedData(
      {this.minEnergy,
      this.maxEnergy,
      this.minProtien,
      this.maxProtien,
      this.minEnergyValue,
      this.maxEnergyValue,
      this.minProtienValue,
      this.manProtienValue,
      this.lastUpdate,
      this.condition});

  CutomizedData.fromJson(Map<String, dynamic> json) {
    minEnergy = json['min_energy'];
    maxEnergy = json['max_energy'];
    minProtien = json['min_protien'];
    maxProtien = json['max_protien'];

    minEnergyValue = json['min_energy_value'];
    maxEnergyValue = json['max_energy_value'];
    minProtienValue = json['min_protien_value'];
    manProtienValue = json['man_protien_value'];

    lastUpdate = json['lastUpdate'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['min_energy'] = this.minEnergy;
    data['max_energy'] = this.maxEnergy;
    data['min_protien'] = this.minProtien;
    data['max_protien'] = this.maxProtien;

    data['min_energy_value'] = this.minEnergyValue;
    data['max_energy_value'] = this.maxEnergyValue;
    data['min_protien_value'] = this.minProtienValue;
    data['man_protien_value'] = this.manProtienValue;

    data['lastUpdate'] = this.lastUpdate;
    data['condition'] = this.condition;

    return data;
  }
}

class customizedDataShow {
  String lastUpdate;
  CutomizedData cutomizedData;
  String adultsIcu;
  String adultsNonIcu;

  customizedDataShow(
      {this.lastUpdate, this.cutomizedData, this.adultsIcu, this.adultsNonIcu});

  customizedDataShow.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    cutomizedData = json['cutomized_data'] != null
        ? new CutomizedData.fromJson(json['cutomized_data'])
        : null;
    adultsIcu = json['adults_icu'];
    adultsNonIcu = json['adults_non_icu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    if (this.cutomizedData != null) {
      data['cutomized_data'] = this.cutomizedData.toJson();
    }
    data['adults_icu'] = this.adultsIcu;
    data['adults_non_icu'] = this.adultsNonIcu;
    return data;
  }
}

class Ons {
  bool teamAgree;
  String condition;
  String kcal;
  String ptn;
  String fiber;
  String volume;
  String times;
  String dropdownValue;
  int seletecIndex;
  String per;
  String lastUpdate;

  String totalKcal;
  String totalPtn;
  String totalFiber;

  Ons(
      {this.teamAgree,
      this.condition,
      this.kcal,
      this.ptn,
      this.fiber,
      this.volume,
      this.times,
      this.dropdownValue,
      this.seletecIndex,
      this.per,
      this.totalKcal,
      this.totalPtn,
      this.totalFiber,
      this.lastUpdate});

  Ons.fromJson(Map<String, dynamic> json) {
    teamAgree = json['team_agree'];
    condition = json['condition'];
    kcal = json['kcal'];
    ptn = json['ptn'];
    fiber = json['fiber'];
    volume = json['volume'];
    times = json['times'];
    dropdownValue = json['dropdownValue'];

    seletecIndex = json['seletecIndex'] ?? 0;
    per = json['per'] ?? '';
    lastUpdate = json['lastUpdate'];

    totalKcal = json['total_kcal'];
    totalPtn = json['total_ptn'];
    totalFiber = json['total_fiber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team_agree'] = this.teamAgree;
    data['condition'] = this.condition;
    data['kcal'] = this.kcal;
    data['ptn'] = this.ptn;
    data['fiber'] = this.fiber;
    data['volume'] = this.volume;
    data['times'] = this.times;
    data['dropdownValue'] = this.dropdownValue;

    data['seletecIndex'] = this.seletecIndex;
    data['per'] = this.per;
    data['lastUpdate'] = this.lastUpdate;

    data['total_kcal'] = this.totalKcal;
    data['total_ptn'] = this.totalPtn;
    data['total_fiber'] = this.totalFiber;
    return data;
  }
}

class Yesterday {
  String breakFast;
  String breakFastRes;
  String breakFastPer;
  bool isBreakFast;
  String morningSnack;
  String morningSnackRes;
  String morningSnackPer;
  bool isMorningSnack;
  String lunch;
  String lunchRes;
  String lunchPer;
  bool isLunch;
  String noon;
  String noonRes;
  String noonPer;
  bool isNoon;
  String dinner;
  String dinnerRes;
  String dinnerPer;
  bool isDinner;
  String supper;
  String supperRes;
  String supperPer;
  bool isSupper;
  String lastUpdate;

  Yesterday(
      {this.breakFast,
      this.breakFastRes,
      this.breakFastPer,
      this.isBreakFast,
      this.morningSnack,
      this.morningSnackRes,
      this.morningSnackPer,
      this.isMorningSnack,
      this.lunch,
      this.lunchRes,
      this.lunchPer,
      this.isLunch,
      this.noon,
      this.noonRes,
      this.noonPer,
      this.isNoon,
      this.dinner,
      this.dinnerRes,
      this.dinnerPer,
      this.isDinner,
      this.supper,
      this.supperRes,
      this.supperPer,
      this.isSupper,
      this.lastUpdate});

  Yesterday.fromJson(Map<String, dynamic> json) {
    breakFast = json['breakFast'];
    breakFastRes = json['breakFastRes'];
    breakFastPer = json['breakFastPer'];
    isBreakFast = json['isBreakFast'] ?? false;
    morningSnack = json['morningSnack'];
    morningSnackRes = json['morningSnackRes'];
    morningSnackPer = json['morningSnackPer'];
    isMorningSnack = json['isMorningSnack'] ?? false;
    lunch = json['lunch'];
    lunchRes = json['lunchRes'];
    lunchPer = json['lunchPer'];
    isLunch = json['isLunch'] ?? false;
    noon = json['noon'];
    noonRes = json['noonRes'];
    noonPer = json['noonPer'];
    isNoon = json['isNoon'] ?? false;
    dinner = json['dinner'];
    dinnerRes = json['dinnerRes'];
    dinnerPer = json['dinnerPer'];
    isDinner = json['isDinner'] ?? false;
    supper = json['supper'];
    supperRes = json['supperRes'];
    supperPer = json['supperPer'];
    isSupper = json['isSupper'] ?? false;
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['breakFast'] = this.breakFast;
    data['breakFastRes'] = this.breakFastRes;
    data['breakFastPer'] = this.breakFastPer;
    data['isBreakFast'] = this.isBreakFast;
    data['morningSnack'] = this.morningSnack;
    data['morningSnackRes'] = this.morningSnackRes;
    data['morningSnackPer'] = this.morningSnackPer;
    data['isMorningSnack'] = this.isMorningSnack;
    data['lunch'] = this.lunch;
    data['lunchRes'] = this.lunchRes;
    data['lunchPer'] = this.lunchPer;
    data['isLunch'] = this.isLunch;
    data['noon'] = this.noon;
    data['noonRes'] = this.noonRes;
    data['noonPer'] = this.noonPer;
    data['isNoon'] = this.isNoon;
    data['dinner'] = this.dinner;
    data['dinnerRes'] = this.dinnerRes;
    data['dinnerPer'] = this.dinnerPer;
    data['isDinner'] = this.isDinner;
    data['supper'] = this.supper;
    data['supperRes'] = this.supperRes;
    data['supperPer'] = this.supperPer;
    data['isSupper'] = this.isSupper;
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}
