class Subscription_historyModel {
  bool success;
  String message;
  List<Data> data;

  Subscription_historyModel({this.success, this.message, this.data});

  Subscription_historyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  String state;
  String city;
  List<Hospital> hospital;
  List<Payments> payments;
  List<Badges> badges;
  String documentId;
  String facephoto;
  String statereg;
  bool isAccept;
  bool isReject;
  bool isBlocked;
  String sId;
  UserId userId;
  String name;
  String professionalNumber;

  Data(
      {this.state,
        this.city,
        this.hospital,
        this.payments,
        this.badges,
        this.documentId,
        this.facephoto,
        this.statereg,
        this.isAccept,
        this.isReject,
        this.isBlocked,
        this.sId,
        this.userId,
        this.name,
        this.professionalNumber});

  Data.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    city = json['city'];
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    if (json['payments'] != null) {
      payments = new List<Payments>();
      json['payments'].forEach((v) {
        payments.add(new Payments.fromJson(v));
      });
    }
    if (json['badges'] != null) {
      badges = new List<Badges>();
      json['badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
      });
    }
    documentId = json['documentId'];
    facephoto = json['facephoto'];
    statereg = json['statereg'];
    isAccept = json['isAccept'];
    isReject = json['isReject'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    name = json['name'];
    professionalNumber = json['professionalNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state'] = this.state;
    data['city'] = this.city;
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    if (this.payments != null) {
      data['payments'] = this.payments.map((v) => v.toJson()).toList();
    }
    if (this.badges != null) {
      data['badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    data['documentId'] = this.documentId;
    data['facephoto'] = this.facephoto;
    data['statereg'] = this.statereg;
    data['isAccept'] = this.isAccept;
    data['isReject'] = this.isReject;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId.toJson();
    }
    data['name'] = this.name;
    data['professionalNumber'] = this.professionalNumber;
    return data;
  }
}

class Hospital {
  String sId;
  String name;

  Hospital({this.sId, this.name});

  Hospital.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Payments {
  String amount;
  String status;
  String packageId;
  String orderId;
  String purchaseTime;
  String purchaseToken;
  String productId;
  String attributeId;
  String hospitalId;
  String subscribedDate;
  String expiredDate;

  Payments(
      {this.amount,
        this.status,
        this.packageId,
        this.orderId,
        this.purchaseTime,
        this.purchaseToken,
        this.productId,
        this.attributeId,
        this.hospitalId,
        this.subscribedDate,
        this.expiredDate});

  Payments.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
    packageId = json['package_id'];
    orderId = json['order_id'];
    purchaseTime = json['purchase_time'];
    purchaseToken = json['purchase_token'];
    productId = json['product_id'];
    attributeId = json['attribute_id'];
    hospitalId = json['hospital_id'];
    subscribedDate = json['subscribed_date'];
    expiredDate = json['expired_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['package_id'] = this.packageId;
    data['order_id'] = this.orderId;
    data['purchase_time'] = this.purchaseTime;
    data['purchase_token'] = this.purchaseToken;
    data['product_id'] = this.productId;
    data['attribute_id'] = this.attributeId;
    data['hospital_id'] = this.hospitalId;
    data['subscribed_date'] = this.subscribedDate;
    data['expired_date'] = this.expiredDate;
    return data;
  }
}

class Badges {
  String attributionname;
  List<Badges> badges;
  List<Hospital> hospital;
  String remdomId;
  bool checked;
  bool isBlocked;
  String sId;
  String hospitalId;
  String createdAt;
  String updatedAt;
  int iV;

  Badges(
      {this.attributionname,
        this.badges,
        this.hospital,
        this.remdomId,
        this.checked,
        this.isBlocked,
        this.sId,
        this.hospitalId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Badges.fromJson(Map<String, dynamic> json) {
    attributionname = json['attributionname'];
    if (json['badges'] != null) {
      badges = new List<Badges>();
      json['badges'].forEach((v) {
        badges.add(new Badges.fromJson(v));
      });
    }
    if (json['hospital'] != null) {
      hospital = new List<Hospital>();
      json['hospital'].forEach((v) {
        hospital.add(new Hospital.fromJson(v));
      });
    }
    remdomId = json['remdomId'];
    checked = json['Checked'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    hospitalId = json['hospitalId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attributionname'] = this.attributionname;
    if (this.badges != null) {
      data['badges'] = this.badges.map((v) => v.toJson()).toList();
    }
    if (this.hospital != null) {
      data['hospital'] = this.hospital.map((v) => v.toJson()).toList();
    }
    data['remdomId'] = this.remdomId;
    data['Checked'] = this.checked;
    data['isBlocked'] = this.isBlocked;
    data['_id'] = this.sId;
    data['hospitalId'] = this.hospitalId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



class UserId {
  String sId;
  String usertype;
  String licenseExpDate;
  String email;
  String phone;
  String name;

  UserId(
      {this.sId,
        this.usertype,
        this.licenseExpDate,
        this.email,
        this.phone,
        this.name});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    usertype = json['usertype'];
    licenseExpDate = json['licenseExpDate'];
    email = json['email'];
    phone = json['phone'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['usertype'] = this.usertype;
    data['licenseExpDate'] = this.licenseExpDate;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['name'] = this.name;
    return data;
  }
}