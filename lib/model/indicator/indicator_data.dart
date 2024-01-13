import '../duration_date.dart';

class IndicatorData {
  double total;
  double in24hour;
  double out24hour;
  double diarrhea;
  Info info;
  int indicatorType;
  DurationDate durationDate;

  IndicatorData(
      {this.total,
      this.in24hour,
      this.out24hour,
      this.diarrhea,
      this.info,
      this.indicatorType,
      this.durationDate});
}

class Info {
  String hospitalName;
  String wardName;
  String indicatorName;
  String startDate;
  String endDate;

  Info(
      {this.hospitalName,
      this.wardName,
      this.indicatorName,
      this.startDate,
      this.endDate});

// Info.fromJson(Map<String, dynamic> json) {
//   hospitalName = json['hospital_name'];
//   wardName = json['ward_name'];
//   indicatorName = json['indicator_name'];
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['hospital_name'] = this.hospitalName;
//   data['ward_name'] = this.wardName;
//   data['indicator_name'] = this.indicatorName;
//   return data;
// }
}
