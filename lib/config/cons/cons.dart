import 'package:age/age.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/schedule_next_evaluation.dart';
import 'package:medical_app/model/patientDetailsModel.dart';

import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

var commonDateFormat = 'yyyy-MM-dd';



class ConstConfig {
  static const diagnosisHistory = 'diagnosis';
  static const diagnosisHistoryMultiple = 'diagnosis2';
  static const obsHistory = 'obs';
  static const goalHistory = 'goalsHistory';
  static const akpsHistory = 'akps';
  static const spictHistory = 'spict';
  static const NRSHistory = 'NRS-2002';
  static const MNAHistory = 'MNA-NNI';
  static const STRONGKIDHistory = 'STRONG-KIDS';
  static const MUSTHistory = 'MUST-history';
  static const NutricHistory = 'Nutric-history';
  static const clinicalManifestationHistory = 'clinicalManifestationHistory1';
  static const aspectFoodPreferenceHistory = 'aspectFoodPreferenceHistory';
  static const aspectAllergieseHistory = 'aspectAllergieseHistory';
  static const additionalDataHistory = 'additionalDataHistory';
  static const anthroHistory = 'anthroHistory';

  static const GLIMHistory = 'GLIMHistory';
  static const ESPENHistory = 'ESPENHistory';
  static const WHOHistory = 'WHOHistory';
  static const CDCHistory = 'CDCHistory';

  static const ConditionHistory = 'condition_history';
  static const enteralHistory = 'enteralHistory';
  static const parenteralHistory = 'parenteralHistory';
  static const FastingOralHistory = 'fasting_history';
  static const ONSAcceptanceHistory = 'ons_acceptance_history';
  static const ORALAcceptanceHistory = 'oral_acceptance_history';
  static const abdomenHistory = 'abdomen_history';
  static const fluidHistory = 'fluid_history';
  static const pressure_risk = 'pressure_risk_braden_history';
  static const pressure_installed = 'pressure_install_history';
  static const other_clinical_data = 'clinical_data_history';
  static const other_recommendation_data = 'recommendation_data_history';
  // static const temprature_GlycemiaHistory = 'temprature_glycemia_history';
  static const blood_pressureHistory = 'bloodpressure_history';
  static const vaso_pressureHistory = 'vaso_pressure_history';
  static const tempratureHistory = 'temprature_history';
  static const glycemiaHistory = 'glycemia_history';

  // static const NRS2002 = 'NRS-2002';
}

class statusType {
  static const nutritionalScreening = '0';
  static const aspectDeficiencies = '1';
  static const nutritionalDiagnosis = '2';
  static const additionalNutritionalData = '3';
}

class nutritionalScreening{
  static const nutricStatus = 'NUTRIC - SCORE';

}

class NTBoxes {
  static const needsAchievements = '0';
  static const condition = '1';
  static const fastingOralDiet = '2';
  static const onsAccept = '3';
  static const oralAccept = '4';
  static const enteralFormula = '5';
  static const parenteralFormula = '6';
  static const otherRecommendation = '7';
  static const nonNutritional = '8';
}

class VigiLanceBoxes {
  static const fluidBalance = '0';
  static const abdomen = '1';
  static const circulation = '2';
  static const TempGlycemiaSheet = '3';
  static const pressureUlcer = '4';
  static const mean_IAP = '5';
  static const otherClinicalDataType = '6';

  static const fluidBalance_status = 'fluidBalance';
  static const meaIAP_status = 'mean_iap';
  static const abdomen_status = 'abdomen';
  static const circulation_status = 'circulation';
  static const temp_status = 'temp_status';
  static const glycemiaSheet_status = 'glycemia_status';
  static const pressureUlcer_status_risk = 'pressureUlcer_risk';
  static const pressureUlcer_installed_status = 'pressureUlcer_installed';
  static const otherClinicalDataStatus = 'other_clinical_data';




}


class conditionNT {
  static const customized = 'customized';
  static const adults_icu = 'adults-icu';
  static const adults_non_icu = 'adults-non-icu';
  static const pediatrics = 'pediatrics';
  static const pregnancyLactation = 'pregnancyLactation';

}

class FastingOral{
  static String fastingOral = 'fasting_oral';
}

class ONSACCEPTANCE{
  static String OnsAccept = 'ons_acceptance';
  static String OnsAccept2 = 'ons_acceptance2';
}
class ORALACCEPTANCE{
  static String OralAccept = 'oral_acceptance';

}

class ENTERAL_STATUS{
  static String enteral_status = 'enteral';

}

class PARENTERAL_STATUS{
  static String parenteral_status = 'parenteral';

}

class RECOMM_STATUS{
  static String recomm_status = 'recommendation_status';

}





class aspectDeficiencies {
  static const foodAllergies = 'foodAllergies';
  static const foodPreference = 'foodPreference';
  static const clinical = 'clinicalManifestation';
}

class nutritionalDiagnosis {
  static const espen = 'ESPEN';
  static const who = 'WHO';
  static const glim = 'GLIM';
}

class additionalDataClass {
  static const additionalNutritionalData = 'additionalNutritionalData';
}

Future<String> getAgeAccordingToKidAdult(String dob) async {
  DateTime today = DateTime.now(); //2020/1/24

  AgeDuration age;

  // Find out your age
  age = Age.dateDifference(
      fromDate: DateTime.parse(dob), toDate: today, includeToDate: false);

  print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  String dateOfBirth = '';
  if (age.years < 19) {
    dateOfBirth = "${age.years} ${'years'.tr}, ${age.months} ${age.months > 1 ? "months".tr : 'month'.tr}";
  } else {
    dateOfBirth =
        "${age.years != 0 ? age.years > 1 ? "${age.years} ${'years'.tr}" : "${age.years} ${'year'.tr}" : age.months != 0 ? age.months > 1 ? "${age.months} ${'months'.tr}" : "${age.months} ${'month'.tr}" : age.days > 1 ? "${age.days} ${'days'.tr}" : "${age.days} ${'day'.tr}"}";

    print('date fo birth: $dateOfBirth');
  }

  return dateOfBirth;
}

Future<String> getAgeFromDate(String dob) async {
  DateTime today = DateTime.now(); //2020/1/24

  AgeDuration age;

  // Find out your age
  age = Age.dateDifference(
      fromDate: DateTime.parse(dob), toDate: today, includeToDate: false);

  print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  String dateOfBirth =
      "${age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}";

  print('date fo birth: $dateOfBirth');

  return dateOfBirth;
}

Future<int> getAgeYearsFromDate(String dob) async {
  DateTime today = DateTime.now(); //2020/1/24

  AgeDuration age;

  // Find out your age
  age = Age.dateDifference(
      fromDate: DateTime.parse(dob), toDate: today, includeToDate: false);

  print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  String dateOfBirth =
      "${age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}";

  print('date fo birth: $dateOfBirth');

  return age.years;
}


Future<bool>isPatientKid(String dob)async{
  bool output;

  await getAgeYearsFromDate(dob).then((res){
    if(res>=19){
      output =  false;
    }else{
      output = true;
    }
  });
  return output;
}


Future<int> getAgeMonthsFromDate(String dob) async {
  DateTime today = DateTime.now(); //2020/1/24

  AgeDuration age;

  // Find out your age
  age = Age.dateDifference(
      fromDate: DateTime.parse(dob), toDate: today, includeToDate: false);

  print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  // String dateOfBirth =
  //     "${age.years != 0 ? age.years > 1 ? "${age.years} years" : "${age.years} year" : age.months != 0 ? age.months > 1 ? "${age.months} months" : "${age.months} month" : age.days > 1 ? "${age.days} days" : "${age.days} day"}";
  //
  // print('date fo birth: $dateOfBirth');

  int mon = age.years * 12 + age.months;

  return mon;
}

String _selectedDate = '';
String _dateCount = '';
String _range = '';
String _rangeCount = '';
DateFormat dateFormat = DateFormat("yyyy-MM-dd");
void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  if (args.value is PickerDateRange) {
    _range = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
        ' - ' +
        DateFormat('yyyy-MM-dd')
            .format(args.value.endDate ?? args.value.startDate)
            .toString();
  } else if (args.value is DateTime) {
    _selectedDate = args.value.toString();
    print("selected date: $_selectedDate");
    print(
        "selected date format: ${dateFormat.format(DateTime.parse(_selectedDate))}");
    _selectedDate = '${dateFormat.format(DateTime.parse(_selectedDate))}';
  } else if (args.value is List<DateTime>) {
    _dateCount = args.value.length.toString();
  } else {
    _rangeCount = args.value.length.toString();
  }
}

schduleNext(PatientDetailsData patientDetailsData, context, DateTime _date) {
  print("schduledate: ${patientDetailsData.scheduleDate}");

  _selectedDate = null;
  Get.dialog(
    AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: Container(
          height: Get.height / 2,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                  child: Text(
                'Schedule Next Evaluation',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
              Divider(),
              Container(
                height: Get.height / 3,
                width: Get.width,
                child: SfDateRangePicker(
                    showNavigationArrow: true,
                    // initialDisplayDate: DateTime.now(),
                    // monthFormat: "yyyy-MM-dd",
                    view: DateRangePickerView.month,
                    enablePastDates: false,
                    initialSelectedDate: _date,
                    onSelectionChanged: _onSelectionChanged),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      flex: 1,
                      child: CustomButton(
                        text: '  Skip  ',
                        myFunc: () {
                          Get.back();
                          Get.to(Step1HospitalizationScreen(
                            patientUserId: patientDetailsData.sId,
                            index: 2,
                          ));
                          // opendialog(patientDetailsData[0], context);
                        },
                      )),
                  Flexible(
                      flex: 1,
                      child: CustomButton(
                        text: '    Confirm    ',
                        myFunc: () {
                          Get.back();

                          print(_selectedDate);

                          if (_selectedDate != null) {
                            print('changed selected date');
                            // Get.back();
                            schduledate(patientDetailsData, _selectedDate);
                          } else {
                            _selectedDate = dateFormat.format(_date);
                            print(_selectedDate);
                            schduledate(patientDetailsData, _selectedDate);
                            print('suggested date selected');

                            // ShowMsg('Please choose a date');
                          }
                          // Get.to(BedsScreen());
                        },
                      )),
                ],
              )
            ],
          ),
        )),
    barrierDismissible: false,
  );
}
// "data": [
// {
// "message": "",
// "multipalmessage": [
// {
// "lastUpdate": "2021-10-06 14:58:52.113712",
// "score": 16,
// "output": "MILD RISK (16 POINTS)",
// "risk_braden_data": [
// {
// "status