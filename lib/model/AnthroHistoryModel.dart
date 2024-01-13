import 'package:medical_app/model/patientDetailsModel.dart';

class AnthroHistoryModel {
  bool success;
  String message;
  List<AnthroHistoryData> data;

  AnthroHistoryModel({this.success, this.message, this.data});

  AnthroHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AnthroHistoryData>();
      json['data'].forEach((v) {
        data.add(new AnthroHistoryData.fromJson(v));
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

class AnthroHistoryData {
  String message;
  List<Multipalmessage> multipalmessage;
  String type;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  AnthroHistoryData(
      {this.message,
        this.multipalmessage,
        this.type,
        this.isBlocked,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AnthroHistoryData.fromJson(Map<String, dynamic> json) {
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
  String weightType;
  String weightMeasuredReported;
  String weightMeasuredReportedLBS;
  String ac;
  String ac_inch;
  String mUAC;
  String MUAC_inch;
  String cALF;
  String CALF_inch;
  String tST;
  String TST_inch;
  String estimatedWeight;
  String estimatedWeightLBS;
  String edema;
  String edema_LBS;
  List<Null> edemaData;
  String ascities;
  String ascities_LBS;
  List<Null> ascitiesData;
  String amputation;
  String amputation_LBS;
  String amputationPer;
  List<AmputationData> amputationData;
  String discountedWeight;
  String discountedWeightLBS;
  String heightType;
  String heightMeasuredReported;
  String heightMeasuredReported_inch;
  String kneeHeight;
  String kneeHeight_inch;
  String armSpan;
  String armSpan_inch;
  String estimatedHeight;
  String estimatedHeightInches;
  String bmi;
  String mamc;
  String mamcper;
  String idealBodyWeight;
  String idealBodyWeightLBS;
  String adjustedBodyWeight;
  String adjustedBodyWeightLBS;
  String lastUpdate;

  //   'weightType': _weightValue,
  //       'weightMeasuredReported': ifZeroReturnBlank(weightMeasureController.text),
  //       'weightMeasuredReportedLBS':
  //           ifZeroReturnBlank(weightMeasureControllerLBS.text),
  //
  //       'ac': ifZeroReturnBlank(ACController.text),
  //       'ac_inch': ifZeroReturnBlank(ACControllerLBS.text),
  //       'MUAC': ifZeroReturnBlank(MUACController.text),
  //       'MUAC_inch': ifZeroReturnBlank(MUACControllerLBS.text),
  //       'CALF': ifZeroReturnBlank(CALFController.text),
  //       'CALF_inch': ifZeroReturnBlank(CALFControllerLBS.text),
  //       'TST': ifZeroReturnBlank(TSTController.text),
  //       'TST_inch': ifZeroReturnBlank(TSTControllerLBS.text),
  //       'mamc': MAMCValue,
  //       'mamcper': MAMCPer,
  //
  //       'estimatedWeight': ifZeroReturnBlank(EstimatedWeightController.text),
  //       'estimatedWeightLBS':
  //           ifZeroReturnBlank(EstimatedWeightControllerLBS.text),
  //
  //       'edema': ifZeroReturnBlank(EDEMAController.text),
  //       'edema_LBS': ifZeroReturnBlank(EDEMAControllerLBS.text),
  //       'edemaData': [],
  //       'ascities': ifZeroReturnBlank(ASCITIESController.text),
  //       'ascities_LBS': ifZeroReturnBlank(ASCITIESControllerLBS.text),
  //       'ascitiesData': [],
  //       'amputation': ifZeroReturnBlank(AMPUTATIONController.text),
  //       'amputation_LBS': ifZeroReturnBlank(AMPUTATIONControllerLBS.text),
  //       'wantDiscountOnWeightFromAmputation': wantDiscountOnWeightFromAmputation,
  //       'amputationPer': ifZeroReturnBlank(_amputationPer),
  //       'amputationData': AmputationDataa,
  //       'discountedWeight': ifZeroReturnBlank(discountedWeightController.text),
  //       'discountedWeightLBS':
  //           ifZeroReturnBlank(discountedWeightControllerLBS.text),
  //
  //       // 'heightType':  heightMeasureController.text.isEmpty?'1':'0',
  //       'heightType': _heightValue,
  //       'heightMeasuredReported': ifZeroReturnBlank(heightMeasureController.text),
  //       'heightMeasuredReported_inch':
  //           ifZeroReturnBlank(heightMeasureControllerInches.text),
  //       'heightMeasuredReportedMeter': double.parse(
  //               heightMeasureController.text.isEmpty
  //                   ? '0'
  //                   : heightMeasureController.text) /
  //           100,
  //       // 'heightMeasuredReportedInches': heightMeasureController.text,
  //       'kneeHeight': ifZeroReturnBlank(KneeHeightController.text),
  //       'kneeHeight_inch': ifZeroReturnBlank(KneeHeightControllerInches.text),
  //       'armSpan': ifZeroReturnBlank(ArmSpanController.text),
  //       'armSpan_inch': ifZeroReturnBlank(ArmSpanControllerInches.text),
  //       'estimatedHeight': ifZeroReturnBlank(EstimatedHeightController.text),
  //       'estimatedHeightInches':
  //           ifZeroReturnBlank(EstimatedHeightControllerInches.text),
  //
  //       'bmi': BMIValue,
  //
  //       'idealBodyWeight': ifZeroReturnBlank(idealBodyWeight),
  //       'idealBodyWeightLBS': ifZeroReturnBlank(idealBodyWeightLBS),
  //       'adjustedBodyWeight': ifZeroReturnBlank(adjustedBodyWeight),
  //       'adjustedBodyWeightLBS': ifZeroReturnBlank(adjustedBodyWeightLBS),
  //       'lastUpdate': '${DateTime.now()}',



  Multipalmessage(
      {this.weightType,
        this.weightMeasuredReported,
        this.weightMeasuredReportedLBS,
        this.ac,
        this.ac_inch,
        this.mUAC,
        this.MUAC_inch,
        this.cALF,
        this.CALF_inch,
        this.tST,
        this.TST_inch,
        this.estimatedWeight,
        this.estimatedWeightLBS,
        this.edema,
        this.edema_LBS,
        this.edemaData,
        this.ascities,
        this.ascities_LBS,
        this.ascitiesData,
        this.amputation,
        this.amputation_LBS,
        this.amputationPer,
        this.amputationData,
        this.discountedWeight,
        this.discountedWeightLBS,
        this.heightType,
        this.heightMeasuredReported,
        this.heightMeasuredReported_inch,
        this.kneeHeight,
        this.kneeHeight_inch,
        this.armSpan,
        this.armSpan_inch,
        this.estimatedHeight,
        this.estimatedHeightInches,
        this.bmi,
        this.mamc,
        this.mamcper,
        this.idealBodyWeight,
        this.idealBodyWeightLBS,
        this.adjustedBodyWeight,
        this.adjustedBodyWeightLBS,
        this.lastUpdate});

  Multipalmessage.fromJson(Map<String, dynamic> json) {
    weightType = json['weightType'];
    weightMeasuredReported = json['weightMeasuredReported'];
    weightMeasuredReportedLBS = json['weightMeasuredReportedLBS'];
    ac = json['ac'];
    ac_inch = json['ac_inch'];
    mUAC = json['MUAC'];
    MUAC_inch = json['MUAC_inch'];
    cALF = json['CALF'];
    CALF_inch = json['CALF_inch'];
    tST = json['TST'];
    TST_inch = json['TST_inch'];
    estimatedWeight = json['estimatedWeight'];
    estimatedWeightLBS = json['estimatedWeightLBS'];
    edema = json['edema'];
    edema_LBS = json['edema_LBS'];
    // if (json['edemaData'] != null) {
    //   edemaData = new List<Null>();
    //   json['edemaData'].forEach((v) {
    //     edemaData.add(new Null.fromJson(v));
    //   });
    // }
    ascities = json['ascities'];
    ascities_LBS = json['ascities_LBS'];
    // if (json['ascitiesData'] != null) {
    //   ascitiesData = new List<Null>();
    //   json['ascitiesData'].forEach((v) {
    //     ascitiesData.add(new Null.fromJson(v));
    //   });
    // }
    amputation = json['amputation'];
    amputation_LBS = json['amputation_LBS'];
    amputationPer = json['amputationPer'];
    if (json['amputationData'] != null) {
      amputationData = new List<AmputationData>();
      json['amputationData'].forEach((v) {
        amputationData.add(new AmputationData.fromJson(v));
      });
    }
    discountedWeight = json['discountedWeight'];
    discountedWeightLBS = json['discountedWeightLBS'];
    heightType = json['heightType'];
    heightMeasuredReported = json['heightMeasuredReported'];
    heightMeasuredReported_inch = json['heightMeasuredReported_inch'];
    kneeHeight = json['kneeHeight'];
    kneeHeight_inch = json['kneeHeight_inch'];
    armSpan = json['armSpan'];
    armSpan_inch = json['armSpan_inch'];
    estimatedHeight = json['estimatedHeight'];
    estimatedHeightInches = json['estimatedHeightInches'];
    bmi = json['bmi'];
    mamc = json['mamc'];
    mamcper = json['mamcper'];
    idealBodyWeight = json['idealBodyWeight'];
    idealBodyWeightLBS = json['idealBodyWeightLBS'];
    adjustedBodyWeightLBS = json['adjustedBodyWeightLBS'];
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['weightType'] = this.weightType;
    data['weightMeasuredReported'] = this.weightMeasuredReported;
    data['weightMeasuredReportedLBS'] = this.weightMeasuredReportedLBS;
    data['ac'] = this.ac;
    data['ac_inch'] = this.ac_inch;
    data['MUAC'] = this.mUAC;
    data['MUAC_inch'] = this.MUAC_inch;
    data['CALF'] = this.cALF;
    data['CALF_inch'] = this.CALF_inch;
    data['TST'] = this.tST;
    data['TST_inch'] = this.TST_inch;
    data['estimatedWeight'] = this.estimatedWeight;
    data['estimatedWeightLBS'] = this.estimatedWeightLBS;
    data['edema'] = this.edema;
    data['edema_LBS'] = this.edema_LBS;
    // if (this.edemaData != null) {
    //   data['edemaData'] = this.edemaData.map((v) => v.toJson()).toList();
    // }
    data['ascities_LBS'] = this.ascities_LBS;
    // if (this.ascitiesData != null) {
    //   data['ascitiesData'] = this.ascitiesData.map((v) => v.toJson()).toList();
    // }
    data['amputation'] = this.amputation;
    data['amputation_LBS'] = this.amputation_LBS;
    data['amputationPer'] = this.amputationPer;
    if (this.amputationData != null) {
      data['amputationData'] =
          this.amputationData.map((v) => v.toJson()).toList();
    }
    data['discountedWeight'] = this.discountedWeight;
    data['discountedWeightLBS'] = this.discountedWeightLBS;
    data['heightType'] = this.heightType;
    data['heightMeasuredReported'] = this.heightMeasuredReported;
    data['heightMeasuredReported_inch'] = this.heightMeasuredReported_inch;
    data['kneeHeight'] = this.kneeHeight;
    data['kneeHeight_inch'] = this.kneeHeight_inch;
    data['armSpan'] = this.armSpan;
    data['armSpan_inch'] = this.armSpan_inch;
    data['estimatedHeight'] = this.estimatedHeight;
    data['estimatedHeightInches'] = this.estimatedHeightInches;
    data['bmi'] = this.bmi;
    data['mamc'] = this.mamc;
    data['mamcper'] = this.mamcper;
    data['idealBodyWeight'] = this.idealBodyWeight;
    data['idealBodyWeightLBS'] = this.idealBodyWeightLBS;
    data['adjustedBodyWeightLBS'] = this.adjustedBodyWeightLBS;
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

