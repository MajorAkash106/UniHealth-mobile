class CommonResponse {
  bool success;
  String message;
  // List<MedicalDivisionData> data;

  CommonResponse({this.success, this.message,});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    // if (json['data'] != null) {
    //   data = new List<MedicalDivisionData>();
    //   json['data'].forEach((v) {
    //     data.add(new MedicalDivisionData.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}