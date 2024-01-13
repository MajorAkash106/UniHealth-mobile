// class SpictDataModel {
//   bool success;
//   String message;
//   List<SpictAllData> data;
//
//   SpictDataModel({this.success, this.message, this.data});
//
//   SpictDataModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = new List<SpictAllData>();
//       json['data'].forEach((v) {
//         data.add(new SpictAllData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class SpictAllData {
//   String subcategoryname;
//   bool isBlocked;
//   bool isSelected;
//   String sId;
//   String categoryId;
//   String createdAt;
//   String updatedAt;
//   int iV;
//
//   SpictAllData(
//       {this.subcategoryname,
//         this.isBlocked,this.isSelected,
//         this.sId,
//         this.categoryId,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   SpictAllData.fromJson(Map<String, dynamic> json) {
//     subcategoryname = json['Subcategoryname'];
//     isBlocked = json['isBlocked'];
//     isSelected = json['isSelected']??false;
//     sId = json['_id'];
//     categoryId = json['categoryId'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Subcategoryname'] = this.subcategoryname;
//     data['isBlocked'] = this.isBlocked;
//     data['isSelected'] = this.isSelected;
//     data['_id'] = this.sId;
//     data['categoryId'] = this.categoryId;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
//
//
// class SelectedSpictData {
//   String categoryId;
//   List<SpictAllData> data;
//
//   SelectedSpictData({this.categoryId,this.data});
//
//   SelectedSpictData.fromJson(Map<String, dynamic> json) {
//     categoryId = json['categoryId'];
//     if (json['data'] != null) {
//       data = new List<SpictAllData>();
//       json['data'].forEach((v) {
//         data.add(new SpictAllData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['categoryId'] = this.categoryId;
//     if (this.data != null) {
//       data['data'] = this.data.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }



class SPICTMODEL {
  bool success;
  String message;
  List<SpictQuestion> data;

  SPICTMODEL({this.success, this.message, this.data});

  SPICTMODEL.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<SpictQuestion>();
      json['data'].forEach((v) {
        data.add(new SpictQuestion.fromJson(v));
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

class SpictQuestion {
  String categoryname;
  bool isBlocked;
  bool isSelected;
  List<SpictOptions> options;
  String sId;
  String createdAt;
  String updatedAt;
  int iV;

  SpictQuestion(
      {this.categoryname,
        this.isBlocked,
        this.isSelected,
        this.options,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SpictQuestion.fromJson(Map<String, dynamic> json) {
    categoryname = json['categoryname'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    if (json['options'] != null) {
      options = new List<SpictOptions>();
      json['options'].forEach((v) {
        options.add(new SpictOptions.fromJson(v));
      });
    }
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryname'] = this.categoryname;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class SpictOptions {
  String subcategoryname;
  bool isBlocked;
  bool isSelected;
  String sId;
  String categoryId;
  String createdAt;
  String updatedAt;
  int iV;

  SpictOptions(
      {this.subcategoryname,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  SpictOptions.fromJson(Map<String, dynamic> json) {
    subcategoryname = json['Subcategoryname'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected']??false;
    sId = json['_id'];
    categoryId = json['categoryId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Subcategoryname'] = this.subcategoryname;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['categoryId'] = this.categoryId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}