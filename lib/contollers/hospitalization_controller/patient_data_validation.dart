import 'package:email_validator/email_validator.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';

class PatientValidate {
  bool patientDataValidate(
      String hospitalName,
      String patientsName,
      String phone,
      String email,
      String hospId,
      String rId,
      String gender,
      var dob,
      String ward,
      String bed,
      var admitDate,
      String mDivision,
      String insuranceCompany,
      String password) {
    print('hospital name: $hospitalName');
    print('patient name: $patientsName');
    print('phone: $phone');
    print('email: $email');
    print('hospId: $hospId');
    print('rId: $rId');
    print('gender: $gender');
    print('dob: $dob');
    print('ward: $ward');
    print('bed: $bed');
    print('admitdata: $admitDate');
    print('mdiv: $mDivision');
    print('Insurance: $insuranceCompany');
    print('pass: $password');

    if (hospitalName != null &&
        (patientsName != null && patientsName.isNotEmpty) &&
        (gender != '' && gender != null) &&
        (dob != null &&
            ward != null &&
            bed != null &&
            admitDate != null &&
            mDivision != null)) {


      if(phoneOrEmailValidate(email, phone)){
        // ShowMsg('all okay');
        return true;
      }

    } else {
      ShowMsg('please_fill_all_the_mandatory_fields'.tr);
      return false;
    }
    return false;
  }

  bool phoneOrEmailValidate(String email, String phone) {
    if ((phone.isNotEmpty && phone != null)) {
      if(phone.length != 11){
        ShowMsg('Please_enter_11_digit_phone'.tr);
        return false;
      }
    }
    if (email.isNotEmpty && email != null) {
      if(EmailValidator.validate(email) == false){
        ShowMsg('email_validation'.tr);
        return false;
      };
    }

    return true;

  }
}
