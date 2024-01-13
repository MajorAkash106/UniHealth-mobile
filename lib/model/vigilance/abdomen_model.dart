class AbdomenData {
  String bowelMovement;
  int indexBowelMovement;
  int bowelSound;
  int vomit;
  String abdominalDist;
  int indexAbdominalDist;
  String ngTube;
  String meanLap;
  String lastUpdate;

  AbdomenData(
      {
        this.bowelMovement,
        this.indexBowelMovement,
        this.bowelSound,
        this.vomit,
        this.abdominalDist,
        this.indexAbdominalDist,
        this.ngTube,
        this.meanLap,
        this.lastUpdate,

      });

  AbdomenData.fromJson(Map<String, dynamic> json) {
    bowelMovement = json['bowel_movement'];
    indexBowelMovement = json['bowel_movement_index']??-1;
    bowelSound = json['bowel_sound'];
    vomit = json['vomit'];
    abdominalDist = json['abdominal_dist'];
    indexAbdominalDist = json['abdominal_dist_index']??-1;
    ngTube = json['ng_tube'];
    meanLap = json['mean_lap'];
    lastUpdate = json['lastUpdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bowel_movement'] = this.bowelMovement;
    data['bowel_movement_index'] = this.indexBowelMovement;
    data['bowel_sound'] = this.bowelSound;
    data['vomit'] = this.vomit;
    data['abdominal_dist'] = this.abdominalDist;
    data['abdominal_dist_index'] = this.indexAbdominalDist;
    data['ng_tube'] = this.ngTube;
    data['mean_lap'] = this.meanLap;
    data['lastUpdate'] = this.lastUpdate;
    return data;
  }
}

class AdverseEventData {
  String optionname;
  String description;
  String persentage;
  bool isBlocked;
  bool isSelected;
  String sId;
  String questionId;
  String createdAt;
  String updatedAt;
  int iV;

  AdverseEventData(
      {this.optionname,
      this.description,
      this.persentage,
        this.isBlocked,
        this.isSelected,
        this.sId,
        this.questionId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  AdverseEventData.fromJson(Map<String, dynamic> json) {
    optionname = json['optionname'];
    description = json['description'];
    persentage = json['persentage'];
    isBlocked = json['isBlocked'];
    isSelected = json['isSelected'];
    sId = json['_id'];
    questionId = json['questionId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['optionname'] = this.optionname;
    data['description'] = this.description;
    data['persentage'] = this.persentage;
    data['isBlocked'] = this.isBlocked;
    data['isSelected'] = this.isSelected;
    data['_id'] = this.sId;
    data['questionId'] = this.questionId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}



// {
// "item": "Nasogastric Tube",
// "date": "2021-11-09",
// "time": "18:06",
// "intOut": "1",
// "ml": "100"
// },

// class MeanIapData {
//   String item;
//   String date;
//   String time;
//   String intOut;
//   String ml;
//
//
//   MeanIapData(
//       {this.item,
//         this.date,
//         this.time,
//         this.intOut,
//         this.ml,
//
//       });
//
//   MeanIapData.fromJson(Map<String, dynamic> json) {
//     item = json['item'];
//     date = json['date'];
//     time = json['time'];
//     intOut = json['intOut'];
//     ml = json['ml'];
//
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['item'] = this.item;
//     data['date'] = this.date;
//     data['time'] = this.time;
//     data['intOut'] = this.intOut;
//     data['ml'] = this.ml;
//
//     return data;
//   }
// }