

class Parenteral_NutritionalModel {
    bool success;
    String message;
    List<PARENTERALDATA> data;

    Parenteral_NutritionalModel({this.success, this.message, this.data});

    Parenteral_NutritionalModel.fromJson(Map<String, dynamic> json) {
        success = json['success'];
        message = json['message'];
        if (json['data'] != null) {
            data = new List<PARENTERALDATA>();
            json['data'].forEach((v) {
                data.add(new PARENTERALDATA.fromJson(v));
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

class PARENTERALDATA {
    List<String> availableIn;
    String title;
    int type;
    String bag;
    String kcal;
    String protein;
    String glucose;
    String lipids;
    bool isActive;
    String remdomId;
    bool isAdmin;
    bool isBlocked;
    String sId;
    String hospitalId;
    String createdAt;
    String updatedAt;
    int iV;

    PARENTERALDATA(
        {this.availableIn,this.title,
            this.type,
            this.bag,
            this.kcal,
            this.protein,
            this.glucose,
            this.lipids,
            this.isActive,
            this.remdomId,
            this.isAdmin,
            this.isBlocked,
            this.sId,
            this.hospitalId,
            this.createdAt,
            this.updatedAt,
            this.iV});

    PARENTERALDATA.fromJson(Map<String, dynamic> json) {
        availableIn = json['availableIn'].cast<String>();
        title = json['title'];
        type = json['type'];
        bag = json['bag'].toString();
        kcal = json['kcal'].toString();
        protein = json['protein'].toString();
        glucose = json['glucose'].toString();
        lipids = json['lipids'].toString();
        isActive = json['isActive'];
        remdomId = json['remdomId'];
        isAdmin = json['isAdmin'];
        isBlocked = json['isBlocked'];
        sId = json['_id'];
        hospitalId = json['hospitalId'];
        createdAt = json['createdAt'];
        updatedAt = json['updatedAt'];
        iV = json['__v'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['availableIn'] = this.availableIn;
        data['title'] = this.title;
        data['type'] = this.type;
        data['bag'] = this.bag;
        data['kcal'] = this.kcal;
        data['protein'] = this.protein;
        data['glucose'] = this.glucose;
        data['lipids'] = this.lipids;
        data['isActive'] = this.isActive;
        data['remdomId'] = this.remdomId;
        data['isAdmin'] = this.isAdmin;
        data['isBlocked'] = this.isBlocked;
        data['_id'] = this.sId;
        data['hospitalId'] = this.hospitalId;
        data['createdAt'] = this.createdAt;
        data['updatedAt'] = this.updatedAt;
        data['__v'] = this.iV;
        return data;
    }
}