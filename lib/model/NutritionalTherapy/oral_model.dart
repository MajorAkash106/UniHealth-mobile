
class OralData {
  String lastUpdate;
  String average;
  Data data;

  OralData({this.lastUpdate, this.average, this.data});

  OralData.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    average = json['average'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['average'] = this.average;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
    breakFast = json['breakFast'];
    breakFastRes = json['breakFastRes'];
    breakFastPer = json['breakFastPer'];
    isBreakFast = json['isBreakFast'];
    morningSnack = json['morningSnack'];
    morningSnackRes = json['morningSnackRes'];
    morningSnackPer = json['morningSnackPer'];
    isMorningSnack = json['isMorningSnack'];
    lunch = json['lunch'];
    lunchRes = json['lunchRes'];
    lunchPer = json['lunchPer'];
    isLunch = json['isLunch'];
    noon = json['noon'];
    noonRes = json['noonRes'];
    noonPer = json['noonPer'];
    isNoon = json['isNoon'];
    dinner = json['dinner'];
    dinnerRes = json['dinnerRes'];
    dinnerPer = json['dinnerPer'];
    isDinner = json['isDinner'];
    supper = json['supper'];
    supperRes = json['supperRes'];
    supperPer = json['supperPer'];
    isSupper = json['isSupper'];
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