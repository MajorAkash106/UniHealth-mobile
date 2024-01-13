class SENDOTPModel {
  bool success;
  String message;
  OTPData data;

  SENDOTPModel({this.success, this.message, this.data});

  SENDOTPModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new OTPData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OTPData {
  String otp;
  String otpId;
  String sId;
  String email;
  String phone;
  String type;

  OTPData({this.otp, this.otpId, this.email, this.phone, this.type,this.sId});

  OTPData.fromJson(Map<String, dynamic> json) {
    otp = json['otp'].toString();
    otpId = json['otpId'];
    sId = json['_id'];
    email = json['email'];
    phone = json['phone'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['otpId'] = this.otpId;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['type'] = this.type;
    return data;
  }
}