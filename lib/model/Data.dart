class Data {
    String id;
    String address;
    String avatar;
    String createdAt;
    String deviceId;
    String email;
    bool forgotPassword;
    String gender;
    bool isBlocked;
    bool isDeleted;
    dynamic latitude;
    bool loggedIn;
    dynamic longitude;
    String name;
    String phone;
    String socialId;
    String updatedAt;

    Data({this.id, this.address, this.avatar, this.createdAt, this.deviceId, this.email, this.forgotPassword, this.gender, this.isBlocked, this.isDeleted, this.latitude, this.loggedIn, this.longitude, this.name, this.phone, this.socialId, this.updatedAt});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            id: json['_id'],
            address: json['address'], 
            avatar: json['avatar'], 
            createdAt: json['createdAt'], 
            deviceId: json['deviceId'], 
            email: json['email'], 
            forgotPassword: json['forgotPassword'], 
            gender: json['gender'], 
            isBlocked: json['isBlocked'], 
            isDeleted: json['isDeleted'], 
            latitude: json['latitude'], 
            loggedIn: json['loggedIn'], 
            longitude: json['longitude'], 
            name: json['name'], 
            phone: json['phone'], 
            socialId: json['socialId'], 
            updatedAt: json['updatedAt'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.id;
        data['address'] = this.address;
        data['avatar'] = this.avatar;
        data['createdAt'] = this.createdAt;
        data['deviceId'] = this.deviceId;
        data['email'] = this.email;
        data['forgotPassword'] = this.forgotPassword;
        data['gender'] = this.gender;
        data['isBlocked'] = this.isBlocked;
        data['isDeleted'] = this.isDeleted;
        data['latitude'] = this.latitude;
        data['loggedIn'] = this.loggedIn;
        data['longitude'] = this.longitude;
        data['name'] = this.name;
        data['phone'] = this.phone;
        data['socialId'] = this.socialId;
        data['updatedAt'] = this.updatedAt;
        return data;
    }
}