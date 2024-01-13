import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/funcs/func.dart';
import 'package:medical_app/model/NutritionalTherapy/NTModel.dart';
import 'package:medical_app/model/NutritionalTherapy/oral_model.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

Future<CutomizedData> getCustomized(
    PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
      data = await a.result.first.cutomizedData;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}


Future <List<CutomizedData>> getCustomizedConditiondetails(
    PatientDetailsData patientDetailsData) async {
  List <CutomizedData> data=[];
  for (var a in patientDetailsData.ntdata) {
    print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
      data = await a.result.first.conditionDetails;
      print('yress');
      break;
    }
  }
  print('return data: $data)');
  return data;
}

Future<String> getCondionFromNT(PatientDetailsData patientDetailsData) async {
  String data;
  for (var a in patientDetailsData.ntdata) {
    print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
      data = await a.result.first.condition;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}

Future<String> getCondionInfoFromNT(
    PatientDetailsData patientDetailsData) async {
  String data;
  for (var a in patientDetailsData.ntdata) {
    print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
      data = await a.result.first.info;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}

Future<String> getCondionUpdatedDate(
    PatientDetailsData patientDetailsData) async {
  String data;
  for (var a in patientDetailsData.ntdata) {
    print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.condition && a.status == conditionNT.customized) {
      data = await a.result.first.lastUpdate;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}

Future<CutomizedData> GETPRENENCYANDLAC(
    int index, double PAC, double weightType, double HEIGHT, int AGE) async {
  final CutomizedData data = CutomizedData();

  if (index == 0) {
    // PREGNANCY - FIRST TRIMESTER

    // kcal min  354 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    //  kcal max  354 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // ptn min  1.1 X WEIGHT AFTER DISCOUNTS
    //  ptn max  1.1 X WEIGHT AFTER DISCOUNTS

    double kcalmin =
        354 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double kcalmax =
        354 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double ptnmin = 1.1 * weightType;
    double ptnmax = 1.1 * weightType;

    print('kcalmin : $kcalmin');
    print('kcalmax : $kcalmax');
    print('ptnmin : $ptnmin');
    print('ptnmax : $ptnmax');
    data.minEnergy = kcalmin.toStringAsFixed(2);
    data.maxEnergy = kcalmax.toStringAsFixed(2);
    data.minProtien = ptnmin.toStringAsFixed(2);
    data.maxProtien = ptnmax.toStringAsFixed(2);

    data.minEnergyValue = '354';
    data.maxEnergyValue = '354';
    data.minProtienValue = '1.1';
    data.manProtienValue = '1.1';

    return data;
  } else if (index == 1) {
    //  PREGNANCY - SECOND TRIMESTER

    // kcal min  694 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // kcal max  694 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // ptn min  1.1 X WEIGHT AFTER DISCOUNTS
    // ptn max 1.1 X WEIGHT AFTER DISCOUNTS

    double kcalmin =
        694 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double kcalmax =
        694 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double ptnmin = 1.1 * weightType;
    double ptnmax = 1.1 * weightType;

    print('kcalmin : $kcalmin');
    print('kcalmax : $kcalmax');
    print('ptnmin : $ptnmin');
    print('ptnmax : $ptnmax');

    data.minEnergy = kcalmin.toStringAsFixed(2);
    data.maxEnergy = kcalmax.toStringAsFixed(2);
    data.minProtien = ptnmin.toStringAsFixed(2);
    data.maxProtien = ptnmax.toStringAsFixed(2);

    data.minEnergyValue = '694';
    data.maxEnergyValue = '694';
    data.minProtienValue = '1.1';
    data.manProtienValue = '1.1';

    return data;
  } else if (index == 2) {
    // PREGNANCY - THIRD TRIMESTER

    // kcal min  806 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // kcal max  806 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // ptn min   1.1 X WEIGHT AFTER DISCOUNTS
    // ptn max  1.1 X WEIGHT AFTER DISCOUNTS

    double kcalmin =
        806 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double kcalmax =
        806 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double ptnmin = 1.1 * weightType;
    double ptnmax = 1.1 * weightType;

    print('kcalmin : $kcalmin');
    print('kcalmax : $kcalmax');
    print('ptnmin : $ptnmin');
    print('ptnmax : $ptnmax');

    data.minEnergy = await kcalmin.toStringAsFixed(2);
    data.maxEnergy = await kcalmax.toStringAsFixed(2);
    data.minProtien = await ptnmin.toStringAsFixed(2);
    data.maxProtien = await ptnmax.toStringAsFixed(2);

    data.minEnergyValue = '806';
    data.maxEnergyValue = '806';
    data.minProtienValue = '1.1';
    data.manProtienValue = '1.1';

    return data;
  } else if (index == 3) {
    //LACTATION - FIRST SEMESTER

    // kcal min  684 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // kcal max  684 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // ptn min   71
    // ptn max  71

    double kcalmin =
        684 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double kcalmax =
        684 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double ptnmin = 71;
    double ptnmax = 71;

    print('kcalmin : $kcalmin');
    print('kcalmax : $kcalmax');
    print('ptnmin : $ptnmin');
    print('ptnmax : $ptnmax');

    data.minEnergy = kcalmin.toStringAsFixed(2);
    data.maxEnergy = kcalmax.toStringAsFixed(2);
    data.minProtien = ptnmin.toStringAsFixed(2);
    data.maxProtien = ptnmax.toStringAsFixed(2);

    data.minEnergyValue = '684';
    data.maxEnergyValue = '684';
    data.minProtienValue = '71';
    data.manProtienValue = '71';

    return data;
  } else if (index == 4) {
    //LACTATION - SECOND SEMESTER

    // kcal min  754 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // kcal max  754 - (6.91 x AGE) + [PAC * (9.36 X WEIGHT AFTER DISCOUNTS + 726 x HEIGHT)]
    // ptn min   71
    // ptn max  71

    double kcalmin =
        754 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double kcalmax =
        754 - (6.91 * AGE) + (PAC * (9.36 * weightType + 726 * HEIGHT));
    double ptnmin = 71;
    double ptnmax = 71;

    print('kcalmin : $kcalmin');
    print('kcalmax : $kcalmax');
    print('ptnmin : $ptnmin');
    print('ptnmax : $ptnmax');

    data.minEnergy = kcalmin.toStringAsFixed(2);
    data.maxEnergy = kcalmax.toStringAsFixed(2);
    data.minProtien = ptnmin.toStringAsFixed(2);
    data.maxProtien = ptnmax.toStringAsFixed(2);

    data.minEnergyValue = '754';
    data.maxEnergyValue = '754';
    data.minProtienValue = '71';
    data.manProtienValue = '71';

    return data;
  }
}

Future<Ntdata> getFAsting(PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    // print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.fastingOralDiet && a.status == FastingOral.fastingOral) {
      data = await a;
      // print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}







Future<Ntdata> getONS(PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    // print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.onsAccept &&
        (a.status == ONSACCEPTANCE.OnsAccept ||
            a.status == ONSACCEPTANCE.OnsAccept2)) {
      data = await a;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}

Future<String> getUpdatedDateONS_ORAL(
    PatientDetailsData patientDetailsData) async {
  Ntdata onsdata;
  Ntdata oraldata;
  await getONS(patientDetailsData).then((ons) {
    onsdata = ons;
  });
  await getORAL(patientDetailsData).then((oral) {
    oraldata = oral;
  });

  String datee = '';

  if (onsdata != null && oraldata != null) {
    //  diff date
    String a = onsdata.updatedAt;
    String b = oraldata.updatedAt;

    datee = updatedDate([DateTime.parse(a), DateTime.parse(b)]);
  } else if (onsdata == null && oraldata != null) {
    //  oral date
    datee = await oraldata.updatedAt;
  } else if (oraldata == null && onsdata != null) {
    //  ons date
    datee = await onsdata.updatedAt;
  } else {}

  await getDateFormatFromString(datee).then((value) {
    datee = value;
  });
  return datee;
}

updatedDate(List<DateTime> list) {
  list.sort((b, a) => a.compareTo(b));
  return '${list[0]}';
}

Future<Ntdata> getORAL(PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    // print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.oralAccept && a.status == ORALACCEPTANCE.OralAccept) {
      data = await a;
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}



Future<OralData> getORALDetailsToday(PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    // print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.oralAccept && a.status == ORALACCEPTANCE.OralAccept) {
      // data = await a.result..first.oralData.firstWhere((element) => element.);
      List<OralData>_list = await a?.result?.first?.oralData;
    data = await  _list.firstWhere((element) => calculateDifference(DateTime.parse(element.lastUpdate))==0 ,orElse: () => null);
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}

Future<OralData> getORALDetailsYesterday(PatientDetailsData patientDetailsData) async {
  var data;
  for (var a in patientDetailsData.ntdata) {
    // print('type: ${a.type},status: ${a.status}');
    if (a.type == NTBoxes.oralAccept && a.status == ORALACCEPTANCE.OralAccept) {
      // data = await a.result..first.oralData.firstWhere((element) => element.);
      List<OralData>_list = await a?.result?.first?.oralData;
      data = await  _list.firstWhere((element) => calculateDifference(DateTime.parse(element.lastUpdate))==-1 ,orElse: () => null);
      print('yress');
      break;
    }
  }
  print('return data: $data');
  return data;
}


Future<List> updatedDataONS(List<Ons> data) async {
  List A = [];

  List todayData = [];
  List yesterdayData = [];

  for (var i in data) {
    Ons onsdata = i;
    Map finaldata = {
      'team_agree': onsdata.teamAgree,
      'condition': onsdata.condition,
      'kcal': onsdata.kcal,
      'ptn': onsdata.ptn,
      'fiber': onsdata.fiber,
      'volume': onsdata.volume,
      'times': onsdata.times,
      "dropdownValue": onsdata.dropdownValue,
      "seletecIndex": onsdata.seletecIndex,
      "per": onsdata.per,
      'lastUpdate': onsdata.lastUpdate,
    };

    DateTime lastTime = DateTime.parse(onsdata.lastUpdate);

    print('get day : ${calculateDifference(lastTime)}');

    if (calculateDifference(lastTime) == 0) {
      //if today data not added in list only updated
    } else if (calculateDifference(lastTime) == -1) {
      //if yesterday data exist in list, data added
      await A.add(finaldata);
    } else {}
  }

  // if(todayData.length>1){
  //   todayData.sort((b, a) => a.compareTo(b));
  //
  // }
  //  if(yesterdayData.length>1){
  //
  //    yesterdayData.sort((b, a) => a.compareTo(b));
  //  }
  //
  //  await A.addAll(todayData[0]);
  //  await A.addAll(yesterdayData[0]);

  return A;
}



Future<OralData> updatedDataORAL(
    List<OralData> data, String type) async {
  OralData output;

  for (var i in data) {
    OralData oraldata = i;

    DateTime lastTime = DateTime.parse(oraldata.lastUpdate);

    print('get day : ${calculateDifference(lastTime)}');

    if (type == '-1' && calculateDifference(lastTime) == 0) {
      output = await i;
      // return oraldata;
      print('adding today data & update yesterday');
      break;
    }
    if (type == '1' && calculateDifference(lastTime) == -1) {
      output = await i;
      print('adding yesterday data & update today');
      break;
    }
  }

  return output;
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}
