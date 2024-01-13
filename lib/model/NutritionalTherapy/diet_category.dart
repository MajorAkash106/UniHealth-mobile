class DietCategory {
  bool success;
  String message;
  List<DataDietCategory> data;

  DietCategory({this.success, this.message, this.data});

  DietCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<DataDietCategory>();
      json['data'].forEach((v) {
        data.add(new DataDietCategory.fromJson(v));
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



class DataDietCategory {
  String oraldietname;
  bool breakfaststatus;
  String breakfastkcal;
  String breakfastprotein;
  String breakfastfiber;
  bool morningsnackstatus;
  String morningsnackkcal;
  String morningsnackprotein;
  String morningsnackfiber;
  bool lunchstatus;
  String lunchkcal;
  String lunchprotein;
  String lunchfiber;
  bool afternoonsnackstatus;
  String afternoonsnackkcal;
  String afternoonsnackprotein;
  String afternoonsnackfiber;
  bool dinnerstatus;
  String dinnerkcal;
  String dinnerprotein;
  String dinnerfiber;
  bool supperstatus;
  String supperkcal;
  String supperprotein;
  String supperfiber;
  String averagekcal;
  String averageprotein;
  String averagefiber;
  bool isBlocked;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  DataDietCategory(
      {this.oraldietname,
        this.breakfaststatus,
        this.breakfastkcal,
        this.breakfastprotein,
        this.breakfastfiber,
        this.morningsnackstatus,
        this.morningsnackkcal,
        this.morningsnackprotein,
        this.morningsnackfiber,
        this.lunchstatus,
        this.lunchkcal,
        this.lunchprotein,
        this.lunchfiber,
        this.afternoonsnackstatus,
        this.afternoonsnackkcal,
        this.afternoonsnackprotein,
        this.afternoonsnackfiber,
        this.dinnerstatus,
        this.dinnerkcal,
        this.dinnerprotein,
        this.dinnerfiber,
        this.supperstatus,
        this.supperkcal,
        this.supperprotein,
        this.supperfiber,
        this.averagekcal,
        this.averageprotein,
        this.averagefiber,
        this.isBlocked,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  DataDietCategory.fromJson(Map<String, dynamic> json) {
    oraldietname = json['oraldietname'].toString();
    breakfaststatus = json['breakfaststatus'];
    breakfastkcal = json['breakfastkcal'].toString();
    breakfastprotein = json['breakfastprotein'].toString();
    breakfastfiber = json['breakfastfiber'].toString();
    morningsnackstatus = json['morningsnackstatus'];
    morningsnackkcal = json['morningsnackkcal'].toString();
    morningsnackprotein = json['morningsnackprotein'].toString();
    morningsnackfiber = json['morningsnackfiber'].toString();
    lunchstatus = json['lunchstatus'];
    lunchkcal = json['lunchkcal'].toString();
    lunchprotein = json['lunchprotein'].toString();
    lunchfiber = json['lunchfiber'].toString();
    afternoonsnackstatus = json['afternoonsnackstatus'];
    afternoonsnackkcal = json['afternoonsnackkcal'].toString();
    afternoonsnackprotein = json['afternoonsnackprotein'].toString();
    afternoonsnackfiber = json['afternoonsnackfiber'].toString();
    dinnerstatus = json['dinnerstatus'];
    dinnerkcal = json['dinnerkcal'].toString();
    dinnerprotein = json['dinnerprotein'].toString();
    dinnerfiber = json['dinnerfiber'].toString();
    supperstatus = json['supperstatus'];
    supperkcal = json['supperkcal'].toString();
    supperprotein = json['supperprotein'].toString();
    supperfiber = json['supperfiber'].toString();
    averagekcal = json['averagekcal'].toString();
    averageprotein = json['averageprotein'].toString();
    averagefiber = json['averagefiber'].toString();
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oraldietname'] = this.oraldietname;
    data['breakfaststatus'] = this.breakfaststatus;
    data['breakfastkcal'] = this.breakfastkcal;
    data['breakfastprotein'] = this.breakfastprotein;
    data['breakfastfiber'] = this.breakfastfiber;
    data['morningsnackstatus'] = this.morningsnackstatus;
    data['morningsnackkcal'] = this.morningsnackkcal;
    data['morningsnackprotein'] = this.morningsnackprotein;
    data['morningsnackfiber'] = this.morningsnackfiber;
    data['lunchstatus'] = this.lunchstatus;
    data['lunchkcal'] = this.lunchkcal;
    data['lunchprotein'] = this.lunchprotein;
    data['lunchfiber'] = this.lunchfiber;
    data['afternoonsnackstatus'] = this.afternoonsnackstatus;
    data['afternoonsnackkcal'] = this.afternoonsnackkcal;
    data['afternoonsnackprotein'] = this.afternoonsnackprotein;
    data['afternoonsnackfiber'] = this.afternoonsnackfiber;
    data['dinnerstatus'] = this.dinnerstatus;
    data['dinnerkcal'] = this.dinnerkcal;
    data['dinnerprotein'] = this.dinnerprotein;
    data['dinnerfiber'] = this.dinnerfiber;
    data['supperstatus'] = this.supperstatus;
    data['supperkcal'] = this.supperkcal;
    data['supperprotein'] = this.supperprotein;
    data['supperfiber'] = this.supperfiber;
    data['averagekcal'] = this.averagekcal;
    data['averageprotein'] = this.averageprotein;
    data['averagefiber'] = this.averagefiber;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}