import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/string_keys.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import '../../config/cons/cons.dart';

class NSConfig {
  bool getPatientScreening(PatientDetailsData pData) {
    bool output = false;

    for (var a in pData.status) {
      if (a.type == "0" &&
          (a.status == AppString.nrsObj ||
              a.status == AppString.mnaObj ||
              a.status == AppString.mustObj ||
              a.status == AppString.kidsObj ||
              a.status == AppString.nutObj)) {
        var admissionDate = DateTime.parse('${pData.admissionDate} 12:00:00');
        var screeningDate = DateTime.parse('${DateFormat(commonDateFormat).format(DateTime.parse(a.result.first.lastUpdate))} 11:59:00');


        DateFormat(commonDateFormat).format(admissionDate);

        adLog('screeningDate : $screeningDate -- admissionDate : $admissionDate');
        adLog('diff : ${screeningDate.difference(admissionDate).inHours}');

        if (screeningDate.difference(admissionDate).inHours < 24) {
          output = true;
        } else {
          output = false;
        }

        break;
      }
    }

    return output;
  }
}
