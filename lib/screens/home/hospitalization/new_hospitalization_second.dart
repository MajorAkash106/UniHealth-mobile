import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:medical_app/contollers/hospitalization_controller/newHospController.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

class NewHospitalizationScreenSecond extends StatefulWidget {
  final String title;
  final PatientData patientData;
  NewHospitalizationScreenSecond({this.title, this.patientData});
  @override
  _NewHospitalizationScreenSecondState createState() =>
      _NewHospitalizationScreenSecondState();
}

class _NewHospitalizationScreenSecondState
    extends State<NewHospitalizationScreenSecond> {
  final NewHospController _controller = NewHospController();

  @override
  void initState() {
    // TODO: implement initState
    getSelected();
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHospitalData();
        print('internet avialable');
      }
    });
    super.initState();
  }

  getSelected() {
    PatientData data = widget.patientData;
    if (data != null) {
      patientName.text = data.name ?? '';
      phone.text = data.phone ?? '';
      email.text = data.email ?? '';
      hospId.text = data.hospitalId ?? '';
      rId.text = data.rId ?? '';
      insuranceCompany.text = data.insurance ?? '';
      dob_initial = DateTime.parse(data.dob);
      dob = DateTime.parse(data.dob);
      admit_initial = DateTime.parse(data.admissionDate);
      admission_date = DateTime.parse(data.admissionDate);
      gender_value = data.gender;


    }
  }

  var patientName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var hospId = TextEditingController();
  var rId = TextEditingController();
  var insuranceCompany = TextEditingController();
  var pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('${widget.title}', null),
        bottomNavigationBar: CommonHomeButton(),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: [
                  Text(
                    "Patient's Info",
                    style: TextStyle(color: appbar_icon_color, fontSize: 16),
                  ),
                  Card(
                    color: card_color,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: [
                            hospitalListWidget(),

                            SizedBox(
                              height: 20,
                            ),
                            _textfield("Patient's name", patientName,
                                TextInputType.text),
                            SizedBox(
                              height: 20,
                            ),
                            // _textfield("Phone", phone,TextInputType.phone),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                              ],
                              controller: phone,
                              decoration: InputDecoration(
                                labelText: "Phone",
                                contentPadding: EdgeInsets.all(0.0),
                              ),
                              onChanged: (String newValue) {
                                // _stashItem.width = "$newValue $_widthUnit";
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _textfield(
                                "Email", email, TextInputType.emailAddress),

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   WhitelistingTextInputFormatter.digitsOnly
                                      // ],
                                      // enabled: false,
                                      controller: hospId,
                                      decoration: InputDecoration(
                                        labelText: "Hosp. Id",
                                        contentPadding: EdgeInsets.all(0.0),
                                      ),
                                      onChanged: (String newValue) {
                                        // _stashItem.width = "$newValue $_widthUnit";
                                      },
                                    )
                                    // _textfield("Hosp. Id", hospId,TextInputType.text)
                                    ),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1,
                                    child: _textfield(
                                        "R-Id", rId, TextInputType.text)
                                    // _dropdownfield(hosp_name,"R-Id",rid),
                                    )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: _dropdownfield(
                                      genderlist, "Gender", gender_value),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1, child: date_of_birth("D.O.B", dob))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            wardListWidget(),
                            // _dropdownfield(hosp_name,"Select Ward",hosp_value),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 1,
                                  child: bedListWidget(),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1,
                                    child: date_of_admit(
                                        "Admit date", admission_date))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            medicalListWidget(),
                            // _dropdownfield(hosp_name,"Medical Division",hosp_value),
                            SizedBox(
                              height: 20,
                            ),
                            _textfield("Insurance Company", insuranceCompany,
                                TextInputType.text),
                            // _dropdownfield(hosp_name,"Insurance Company",hosp_value),
                            SizedBox(
                              height: 20,
                            ),
                            // Row(
                            //   children: <Widget>[
                            //     Flexible(
                            //       flex: 1,
                            //       child: _dropdownfield(hosp_name,"Select",rid),
                            //     ),
                            //     SizedBox(width: 20,),
                            //     Flexible(
                            //         flex: 2,
                            //         child: _textfield("Identification Number",rId)
                            //     ),
                            //   ],
                            // ),
                            // _textfield("Password", pass,TextInputType.text),
                            // SizedBox(
                            //   height: 20,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: "Confirm",
                    myFunc: onpreesss,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String gender_value;
  List<String> genderlist = [
    'Male',
    'Female',
    // 'Other',
  ];

  void onpreesss() {
    // Get.to(Step1HospitalizationScreen());
    print(gender_value);
    _controller.submitForm(
        selectedHospital,
        patientName.text,
        phone.text,
        email.text,
        hospId.text,
        rId.text,
        gender_value,
        dob,
        selectedWard,
        selectedBed,
        admission_date,
        selectedMedical,
        insuranceCompany.text,
        '12345');
  }

  String selectedHospital;
  String selectedHospitalName;
  Widget hospitalListWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: "Hospital's name",
          labelText: "Hospital's name",
          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        value: selectedHospital,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items: _controller.hospListdata
            .map((e) =>
                DropdownMenuItem<String>(value: e.sId, child: Text(e.name)))
            .toList(),
        onChanged: (value) => setState(() {
              // print('value: $selectedHospital');

              var selectedData = _controller.hospListdata
                  .firstWhere((element) => element.sId == value);
              setState(() {
                selectedHospitalName = selectedData.name;
              });

              if (selectedHospital != value) {
                selectedHospital = value;
                print(selectedHospital);
                // hospId.text = value;
                _controller.wardListdata.clear();
                selectedWard = null;
                _controller.bedListdata.clear();
                selectedBed = null;
                _controller.getWardData(selectedHospital);

                print('hospital: ${jsonEncode(selectedData)}');
                _controller.getMedicalData([selectedData]);
              }
            }));
  }

  String selectedWard;
  String selectedWardName;
  Widget wardListWidget() {
    return InkWell(
      onTap: () {
        print(_controller.wardListdata.isEmpty);
        if (_controller.wardListdata.isEmpty) {
          ShowMsg('Sorry! Wards are not available.');
        }
      },
      child:  DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: "Select Ward",
          labelText: "Select Ward",
          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        value: selectedWard,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items: _controller.wardListdata
            .map((e) =>
            DropdownMenuItem<String>(value: e.sId, child: Text(e.wardname)))
            .toList(),
        onChanged: (value) => setState(() {
          // print('value: $selectedWard');
          var selectedData = _controller.wardListdata
              .firstWhere((element) => element.sId == value);
          setState(() {
            selectedWardName = selectedData.wardname;
          });

          if (selectedWard != value) {
            selectedWard = value;
            _controller.bedListdata.clear();
            selectedBed = null;
            _controller.getBedData(selectedWard);
          }
        })),);
  }

  String selectedBed;
  Widget bedListWidget() {
    return InkWell(
      onTap: () {
        print(_controller.bedListdata.isEmpty);
        if (_controller.bedListdata.isEmpty) {
          ShowMsg('Sorry! Beds are not available.');
        }
      },
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "Bed",
            labelText: "Bed",
            // suffixIcon: Icon(Icons.arrow_drop_down)
          ),
          value: selectedBed,
          iconEnabledColor: primary_color,
          icon: Icon(null),
          items: _controller.bedListdata
              .map((e) => DropdownMenuItem<String>(
                  value: e.sId, child: Text(e.bedNumber)))
              .toList(),
          onChanged: (value) => setState(() {
                selectedBed = value;
                print('value: $selectedBed');
              })),
    );
  }

  String selectedMedical;
  Widget medicalListWidget() {
    return InkWell(
      onTap: () {
        print(_controller.bedListdata.isEmpty);
        if (_controller.bedListdata.isEmpty) {
          ShowMsg('Sorry! Medical Division is not available.');
        }
      },
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "Medical Division",
            labelText: "Medical Division",
            // suffixIcon: Icon(Icons.arrow_drop_down)
          ),
          value: selectedMedical,
          iconEnabledColor: primary_color,
          icon: Icon(null),
          items: _controller.medicalListdata
              .map((e) => DropdownMenuItem<String>(
                  value: e.sId, child: Text(e.division)))
              .toList(),
          onChanged: (value) => setState(() {
                selectedMedical = value;
                print('value: $selectedMedical');
              })),
    );
  }

  Widget _dropdownfield(itemslist, text, value) {
    return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: "$text",
          labelText: "$text",
          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        value: value,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items: genderlist
            .map((String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value)))
            .toList(),
        onChanged: (val) => setState(() {
              gender_value = val;
            }));
  }

  Widget _textfield(
      text, TextEditingController controller, TextInputType _type) {
    return TextFormField(
      keyboardType: _type,
      // inputFormatters: <TextInputFormatter>[
      //   WhitelistingTextInputFormatter.digitsOnly
      // ],
      controller: controller,
      decoration: InputDecoration(
        labelText: "$text",
        contentPadding: EdgeInsets.all(0.0),
      ),
      onChanged: (String newValue) {
        // _stashItem.width = "$newValue $_widthUnit";
      },
    );
  }

  var dob;
  DateTime dob_initial;
  DateTime admit_initial;
  var admission_date;
  final format = DateFormat("dd-MM-yyyy");
  Widget date_of_birth(text, value) {
    return DateTimeField(
      format: format,
      initialValue: dob_initial,
      onChanged: (DateTime newValue) {
        setState(() {
          print(value);
          print(newValue);
          dob = newValue;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          labelText: "$text",
          suffixIcon: Icon(
            Icons.date_range,
            color: primary_color,
          )
          // icon: Icon(Icons.date_range)
          ),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime.now());
      },
    );
  }

  Widget date_of_admit(text, value) {
    return DateTimeField(
      format: format,
      initialValue: admit_initial,
      onChanged: (DateTime val) {
        setState(() {
          // print(value);
          print(val);
          admission_date = val;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          labelText: "$text",
          suffixIcon: Icon(
            Icons.date_range,
            color: primary_color,
          )
          // icon: Icon(Icons.date_range)
          ),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime.now());
      },
    );
  }
}
