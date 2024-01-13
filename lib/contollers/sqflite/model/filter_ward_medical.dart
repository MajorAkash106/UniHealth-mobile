class FilterWardMedical {
  String id;
  bool staus;

  FilterWardMedical({this.id, this.staus});

  FilterWardMedical.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    staus = json['staus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['staus'] = this.staus;
    return data;
  }
}