
class TempratureSheetData {
  String lastUpdate;
  List<TempratureData> tempratureData;

  TempratureSheetData({this.tempratureData,this.lastUpdate});

  TempratureSheetData.fromJson(Map<String, dynamic> json) {
    if (json['tempratureData'] != null) {
      tempratureData = new List<TempratureData>();
      json['tempratureData'].forEach((v) {
        tempratureData.add(new TempratureData.fromJson(v));
      });
    }
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tempratureData != null) {
      data['tempratureData'] =
          this.tempratureData.map((v) => v.toJson()).toList();
    }
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

class TempratureData {

  String date;
  String time;
  String value;
  String dateTime;

  TempratureData({ this.date, this.time, this.value,this.dateTime});

  TempratureData.fromJson(Map<String, dynamic> json) {

    date = json['date'];
    time = json['time'];
    value = json['value'];
    dateTime = '${json['date']} ${json['time']}:00';

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['date'] = this.date;
    data['time'] = this.time;
    data['value'] = this.value;
    data['dateTime'] = this.dateTime;
    return data;
  }
}