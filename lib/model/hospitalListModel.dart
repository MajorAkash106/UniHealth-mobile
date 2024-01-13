class HospitalsListDetails {
  bool success;
  String message;
  List<HospitalListData> data;

  HospitalsListDetails({this.success, this.message, this.data});

  HospitalsListDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<HospitalListData>();
      json['data'].forEach((v) {
        data.add(new HospitalListData.fromJson(v));
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

class HospitalListData {
  bool isBlocked;
  bool istoggle;
  bool onTap;
  String sId;
  String name;
  String workdays;
  String hospitalgroup;
  String phone;
  String cpnj;
  String country;
  String state;
  String city;
  String street;
  String number;
  String createdAt;
  String updatedAt;
  int iV;

  HospitalListData(
      {this.isBlocked,
        this.istoggle,
        this.onTap,
        this.workdays,
        this.sId,
        this.name,
        this.hospitalgroup,
        this.phone,
        this.cpnj,
        this.country,
        this.state,
        this.city,
        this.street,
        this.number,
        this.createdAt,
        this.updatedAt,
        this.iV});

  HospitalListData.fromJson(Map<String, dynamic> json) {
    isBlocked = json['isBlocked'];
    istoggle = json['istoggle']??false;
    onTap = json['onTap']??false;
    sId = json['_id'];
    name = json['name'];
    workdays = json['workdays'];
    hospitalgroup = json['hospitalgroup'];
    phone = json['phone'];
    cpnj = json['cpnj'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    street = json['street'];
    number = json['number'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isBlocked'] = this.isBlocked;
    data['istoggle'] = this.istoggle;
    data['onTap'] = this.onTap;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['workdays'] = this.workdays;
    data['hospitalgroup'] = this.hospitalgroup;
    data['phone'] = this.phone;
    data['cpnj'] = this.cpnj;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['street'] = this.street;
    data['number'] = this.number;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}