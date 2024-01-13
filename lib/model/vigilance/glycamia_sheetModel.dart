class GlycemiaSheetData {
  String lastUpdate;
  List<GlycemiaData> glycemiaData;

  GlycemiaSheetData({this.glycemiaData,this.lastUpdate});

  GlycemiaSheetData.fromJson(Map<String, dynamic> json) {
    if (json['glycemiaData'] != null) {
      glycemiaData = new List<GlycemiaData>();
      json['glycemiaData'].forEach((v) {
        glycemiaData.add(new GlycemiaData.fromJson(v));
      });
    }
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.glycemiaData != null) {
      data['glycemiaData'] = this.glycemiaData.map((v) => v.toJson()).toList();
    }
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

class GlycemiaData {
  String date;
  String time;
  String value;
  String dateTime;

  GlycemiaData({this.date, this.time, this.value,this.dateTime});

  GlycemiaData.fromJson(Map<String, dynamic> json) {
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