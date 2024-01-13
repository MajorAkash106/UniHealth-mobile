class EditProfileDetails {
  bool success;
  String message;
  Data data;

  EditProfileDetails({this.success, this.message, this.data});

  EditProfileDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String deviceId;
  bool forgotPassword;
  String gender;
  String avatar;
  String address;
  int latitude;
  double longitude;
  bool isBlocked;
  bool isDeleted;
  bool loggedIn;
  String socialId;
  String sId;
  String name;
  String email;
  String phone;
  String createdAt;
  String updatedAt;

  Data(
      {this.deviceId,
        this.forgotPassword,
        this.gender,
        this.avatar,
        this.address,
        this.latitude,
        this.longitude,
        this.isBlocked,
        this.isDeleted,
        this.loggedIn,
        this.socialId,
        this.sId,
        this.name,
        this.email,
        this.phone,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    forgotPassword = json['forgotPassword'];
    gender = json['gender'];
    avatar = json['avatar'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isBlocked = json['isBlocked'];
    isDeleted = json['isDeleted'];
    loggedIn = json['loggedIn'];
    socialId = json['socialId'];
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceId'] = this.deviceId;
    data['forgotPassword'] = this.forgotPassword;
    data['gender'] = this.gender;
    data['avatar'] = this.avatar;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['isBlocked'] = this.isBlocked;
    data['isDeleted'] = this.isDeleted;
    data['loggedIn'] = this.loggedIn;
    data['socialId'] = this.socialId;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}