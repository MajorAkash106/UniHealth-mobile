import 'package:medical_app/model/vigilance/abdomen_model.dart';
import 'package:medical_app/model/vigilance/glycamia_sheetModel.dart';

import 'package:medical_app/model/vigilance/pressure_ulcer_model.dart';

import 'package:medical_app/model/vigilance/circulation_model.dart';
import 'package:medical_app/model/vigilance/temp_sheetModel.dart';


class Vigilance {
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

  Vigilance(
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

  Vigilance.fromJson(Map<String, dynamic> json) {
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
  String balanceSince;
  bool meansHighCheck;
  List<vigi_resultData> data;
  List<Mean_IAP_Data> mean_data;

  CirculationData circulaltiondata;
  TempratureSheetData tempratureSheetData;
  GlycemiaSheetData glycemiaSheetData;
  String result;
  AbdomenData abdomenData;
  List<AdverseEventData> adverseEventData;

  List<AbdomenData> abdomenDetails;
  // List<MeanIapData> meaIapData;


  int score;
  String output;
  List<RiskBradenData> riskBradenData;
  List<RiskBradenData> installedData;

  Result(
      {this.lastUpdate,
      this.balanceSince,
      this.data,
        this.mean_data,this.meansHighCheck,
      this.result,
      this.abdomenData,
        this.tempratureSheetData,
        this.glycemiaSheetData,
      this.adverseEventData,
      this.abdomenDetails,
        this.circulaltiondata,
      this.score,
      this.output,
      this.riskBradenData,
      this.installedData,
        // this.meaIapData
      });



  Result.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    meansHighCheck = json['meansHighCheck']??false;
    balanceSince = json['balance_since'];
    if (json['data'] != null) {
      data = new List<vigi_resultData>();
      json['data'].forEach((v) {
        data.add(new vigi_resultData.fromJson(v));
      });
    }
    if (json['mean_data'] != null) {
      mean_data = new List<Mean_IAP_Data>();
      json['mean_data'].forEach((v) {
        mean_data.add(new Mean_IAP_Data.fromJson(v));
      });
    }

    result = json['result'];
    abdomenData = json['abdomen_data'] != null
        ? new AbdomenData.fromJson(json['abdomen_data'])
        : null;

    tempratureSheetData = json['tempratureSheetData'] != null
        ? new TempratureSheetData.fromJson(json['tempratureSheetData'])
        : null;
    glycemiaSheetData = json['glycemiaSheetData'] != null
        ? new GlycemiaSheetData.fromJson(json['glycemiaSheetData'])
        : null;

    circulaltiondata = json['circulaltiondata'] != null
        ? new CirculationData.fromJson(json['circulaltiondata'])
        : null;
    if (json['adverse_eventData'] != null) {
      adverseEventData = new List<AdverseEventData>();
      json['adverse_eventData'].forEach((v) {
        adverseEventData.add(new AdverseEventData.fromJson(v));
      });
    }

    if (json['abdomen_data_details'] != null) {
      abdomenDetails = new List<AbdomenData>();
      json['abdomen_data_details'].forEach((v) {
        abdomenDetails.add(new AbdomenData.fromJson(v));
      });
    }
    // if (json['mean_iap_data'] != null) {
    // meaIapData = new List<MeanIapData>();
    // json['mean_iap_data'].forEach((v) {
    // meaIapData.add(new MeanIapData.fromJson(v));
    // });
    // }

    score = json['score'];
    output = json['output'];
    if (json['risk_braden_data'] != null) {
      riskBradenData = new List<RiskBradenData>();
      json['risk_braden_data'].forEach((v) {
        riskBradenData.add(new RiskBradenData.fromJson(v));
      });
    }
    if (json['installed_data'] != null) {
      installedData = new List<RiskBradenData>();
      json['installed_data'].forEach((v) {
        installedData.add(new RiskBradenData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['meansHighCheck'] = this.meansHighCheck;
    data['balance_since'] = this.balanceSince;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.mean_data != null) {
      data['mean_data'] = this.mean_data.map((v) => v.toJson()).toList();
    }
    data['result'] = this.result;
    if (this.abdomenData != null) {
      data['abdomen_data'] = this.abdomenData.toJson();
    }
    if (this.tempratureSheetData != null) {
      data['tempratureSheetData'] = this.tempratureSheetData.toJson();
    }
    if (this.glycemiaSheetData != null) {
      data['glycemiaSheetData'] = this.glycemiaSheetData.toJson();
    }
    if (this.circulaltiondata != null) {
      data['circulaltiondata'] = this.circulaltiondata.toJson();
    }
    if (this.adverseEventData != null) {
      data['adverse_eventData'] =
          this.adverseEventData.map((v) => v.toJson()).toList();
    }

    if (this.abdomenDetails != null) {
      data['abdomen_data_details'] =
          this.abdomenDetails.map((v) => v.toJson()).toList();
    }
    // if (this.meaIapData != null) {
    //   data['mean_iap_data'] =
    //       this.meaIapData.map((v) => v.toJson()).toList();
    // }

    data['score'] = this.score;
    data['output'] = this.output;
    if (this.riskBradenData != null) {
      data['risk_braden_data'] =
          this.riskBradenData.map((v) => v.toJson()).toList();
    }
    if (this.installedData != null) {
      data['installed_data'] =
          this.installedData.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class vigi_resultData {
  String item;
  String date;
  String time;
  String intOut;
  String ml;

  vigi_resultData({this.item, this.date, this.intOut, this.ml, this.time});

  vigi_resultData.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    date = json['date'];
    time = json['time'];
    intOut = json['intOut'];
    ml = json['ml'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item'] = this.item;
    data['date'] = this.date;
    data['time'] = this.time;
    data['intOut'] = this.intOut;
    data['ml'] = this.ml;
    return data;
  }
}


class Mean_IAP_Data {

  String date;
  String time;

  String iap_value;

  Mean_IAP_Data({ this.date,  this.iap_value, this.time});

  Mean_IAP_Data.fromJson(Map<String, dynamic> json) {

    date = json['date'];
    time = json['time'];

    iap_value = json['iap_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['date'] = this.date;
    data['time'] = this.time;

    data['iap_value'] = this.iap_value;
    return data;
  }
}