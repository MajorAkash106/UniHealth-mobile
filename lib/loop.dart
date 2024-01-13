import 'contollers/sqflite/database/hospitals_offline.dart';
import 'model/hospitalListModel.dart';

class setHospitalToggle {
  final HospitalSqflite sqflite = HospitalSqflite();

  HospitalsListDetails hospitalsListDetails = HospitalsListDetails();

 void setHosp(String hospId) async {
    hospitalsListDetails = await sqflite.getHospitals();

    // hospitalListData = resp.data.firstWhere((element) => element.sId == hospId, orElse: () => null);

    if (hospitalsListDetails.data != null) {
      for (var a in hospitalsListDetails.data) {
        if (a.sId == hospId) {
          a.istoggle = true;
          break;
        }
      }
    }

    await sqflite.saveHospitals(hospitalsListDetails);
  }
}
