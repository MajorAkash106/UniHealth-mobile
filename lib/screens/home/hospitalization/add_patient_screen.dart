import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Locale/locale_config.dart';
import 'package:medical_app/config/cons/gender_config.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/mandatory_label.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import '../../../config/funcs/CheckConnectivity.dart';
import '../../../contollers/hospitalization_controller/add_patient_controller.dart';
import '../../../contollers/hospitalization_controller/patient_data_validation.dart';

class AddPatientScreen extends StatefulWidget {
  final String title;
  final String hospId;
  final String wardId;
  final String bedId;
  final PatientDetailsData pData;
  final bool isEdit;

  AddPatientScreen(
      {this.title, this.hospId, this.wardId, this.bedId, this.pData,this.isEdit});

  @override
  _AddPatientScreenState createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final AddPatientController _controller = AddPatientController();

  var patientName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var hospId = TextEditingController();
  var rId = TextEditingController();
  var insuranceCompany = TextEditingController();
  var pass = TextEditingController();
  String selectedHospital;
  String selectedHospitalName;
  String selectedWard;
  String selectedWardName;
  String selectedBed;
  String selectedMedical;
  var dob;
  var admission_date;
  final format = DateFormat("dd-MM-yyyy");
  Locale locale;
  String gender_value;
  List<String> genderlist = [
    'male',
    'female',
    // 'Other',
  ];

  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      if (internet != null && internet) {
        _controller.getHospitalData().then((value) => autoFill());
      }
    });
    getLocale();
    super.initState();
  }

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
                    "patients_info".tr,
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
                            _textfield("patient_name".tr, patientName,
                                TextInputType.text, true),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11),
                              ],
                              controller: phone,
                              decoration: InputDecoration(
                                labelText: "phone".tr,
                                contentPadding: EdgeInsets.all(0.0),
                              ),
                              onChanged: (String newValue) {},
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _textfield("email".tr, email,
                                TextInputType.emailAddress, false),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 1,
                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      controller: hospId,
                                      decoration: InputDecoration(
                                        labelText: "hosp._id".tr,
                                        contentPadding: EdgeInsets.all(0.0),
                                      ),
                                      onChanged: (String newValue) {},
                                    )),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1,
                                    child: _textfield("r_id".tr, rId,
                                        TextInputType.text, false))
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
                                      genderlist, "gender".tr, gender_value),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1,
                                    child: date_of_birth("dob".tr, dob))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            wardListWidget(),
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
                                        "admit_dated".tr, admission_date))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            medicalListWidget(),
                            SizedBox(
                              height: 20,
                            ),
                            _textfield("insurance_company".tr, insuranceCompany,
                                TextInputType.text, false),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    text: "confirm".tr,
                    myFunc: () => onConfirm(),
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

  void onConfirm() {
    // Get.to(Step1HospitalizationScreen());
    // PatientValidate patientValidate = PatientValidate();

    print(gender_value);
    _controller.submitForm(
        selectedHospital,
        patientName.text,
        phone.text,
        email.text,
        hospId.text,
        rId.text,
        // gender_value,
        //for BR version
        getGenderFromKey(gender_value),
        dob,
        selectedWard,
        selectedBed,
        admission_date,
        selectedMedical,
        insuranceCompany.text,
        '12345',widget.isEdit,widget.pData);
  }

  Widget hospitalListWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "hospitals_named".tr,
            label: labelWidget(label: 'hospitals_named'.tr, isMandatory: true)),
        value: selectedHospital,
        disabledHint:widget.isEdit? Text(widget.pData.hospital[0].name):SizedBox(),
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items: _controller.hospListdata
            .map((e) =>
                DropdownMenuItem<String>(value: e.sId, child: Text(e.name)))
            .toList(),
        onChanged:widget.isEdit?null: (value) => setState(() {
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

  Widget wardListWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "select_ward".tr,
            label: labelWidget(label: 'select_ward'.tr, isMandatory: true)),
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
                if(widget.isEdit){
                   _controller.getEditBedData(selectedWard,widget.bedId);
                }else {
                   _controller.getBedData(selectedWard);
                }
              }
            }));
  }

  Widget bedListWidget() {
    return InkWell(
      onTap: () {
        print(_controller.bedListdata.isEmpty);
        if (_controller.bedListdata.isEmpty) {
          ShowMsg('all_beds_are_occupied'.tr);
        }
      },
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              hintText: "bed".tr,
              label: labelWidget(label: 'bed'.tr, isMandatory: true)),
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

  Widget medicalListWidget() {
    return InkWell(
      onTap: () {
        print(_controller.medicalListdata.isEmpty);
        if (_controller.medicalListdata.isEmpty) {
          ShowMsg('medical_div_is_not_available'.tr);
        }
      },
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0.0),
              hintText: "medical_division".tr,
              label:
                  labelWidget(label: 'medical_division'.tr, isMandatory: true)),
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
            label: labelWidget(label: text, isMandatory: true)),
        value: value,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items: genderlist
            .map((String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value.tr)))
            .toList(),
        onChanged: (val) => setState(() {
              gender_value = val;
              debugPrint(
                  'gender_value::$gender_value   getGenderFromKey : ${getGenderFromKey(gender_value)}');

              getGenderFromKey(gender_value);
            }));
  }

  Widget _textfield(text, TextEditingController controller, TextInputType _type,
      bool isMandatoryField) {
    return TextFormField(
      keyboardType: _type,
      controller: controller,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          label: labelWidget(label: text, isMandatory: isMandatoryField)),
      onChanged: (String newValue) {},
    );
  }

  void getLocale() async {
    locale = await LocaleConfig().getLocale();
  }

  Widget date_of_birth(text, value) {
    return DateTimeField(
      format: format,
      initialValue: widget.isEdit? DateTime.parse(widget.pData.dob):null,
      resetIcon: Icon(Icons.add),
      onChanged: (DateTime newValue) {
        setState(() {
          print(value);
          print(newValue);
          dob = newValue;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          label: labelWidget(label: text, isMandatory: true),
          suffixIcon: Icon(
            Icons.date_range,
            color: primary_color,
          )),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
          context: context,
          locale: locale,
          firstDate: DateTime(1900),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime.now(),
        );
      },
    );
  }

  Widget date_of_admit(text, value) {
    return DateTimeField(
      format: format,
      initialValue: widget.isEdit? DateTime.parse(widget.pData.admissionDate):null,
      onChanged: (DateTime val) {
        setState(() {
          print(val);
          admission_date = val;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          label: labelWidget(label: text, isMandatory: true),
          suffixIcon: Icon(
            Icons.date_range,
            color: primary_color,
          )),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            locale: locale,
            context: context,
            firstDate: DateTime(2000),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime.now());
      },
    );
  }

  void autoFill()async {
   await autoFillHospAndWard();
   await autoFillOtherInfo();
  }

  void autoFillHospAndWard()async {
    if (widget.hospId != null &&
        widget.wardId != null &&
        widget.bedId != null) {
      var selectedData = _controller.hospListdata
          .firstWhere((element) => element.sId == widget.hospId);
      setState(() {
        selectedHospitalName = selectedData.name;
      });

      if (selectedHospital != widget.hospId) {

        var isHospAvailable = _controller.hospListdata.firstWhere((it) => it.sId == widget.hospId,orElse: null);
        selectedHospital = isHospAvailable!=null? widget.hospId:null;

        print(selectedHospital);
        // hospId.text = value;
        _controller.wardListdata.clear();
        selectedWard = null;
        _controller.bedListdata.clear();
        selectedBed = null;
       await _controller.getWardData(selectedHospital)
            .then((value) => autoFillBed());

        print('hospital: ${jsonEncode(selectedData)}');
        await _controller.getMedicalData([selectedData]);

        setState(() {});
      }
    }
  }

  void autoFillBed()async {
    var selectedData = _controller.wardListdata
        .firstWhere((element) => element.sId == widget.wardId);
    setState(() {
      selectedWardName = selectedData.wardname;
    });

    if (selectedWard != widget.wardId) {

      var isWardAvailable = _controller.wardListdata.firstWhere((it) => it.sId == widget.wardId,orElse: null);
      selectedWard = isWardAvailable!=null? widget.wardId:null;

      _controller.bedListdata.clear();
      selectedBed = null;
      if(widget.isEdit){
        debugPrint('getEditBedData${widget.bedId}  ${selectedWard}');
       await _controller.getEditBedData(selectedWard,widget.bedId);
      }else {
        debugPrint('getBedData');
        await _controller.getBedData(selectedWard);
      }
    }


    var isBedAvailable = _controller.bedListdata.firstWhere((it) => it.sId == widget.bedId,orElse: null);
    selectedBed = isBedAvailable!=null? widget.bedId:null;
    print('value: $selectedBed');
    setState(() {});
  }

  void autoFillOtherInfo() {
    if (widget.pData != null) {
      print(widget.pData.admissionDate);
      debugPrint('autoFillOtherInfo calling!');
      gender_value = widget.pData.gender.toLowerCase();
      dob = DateTime.parse(widget.pData.dob);
      admission_date = DateTime.now();


     var isMedicalAvailable = _controller.medicalListdata.firstWhere((it) => it.sId == widget.pData.medicalId.sId,orElse: null);
      selectedMedical =isMedicalAvailable!=null? widget.pData.medicalId.sId:null;

      patientName = TextEditingController(text: widget.pData.name);
      phone = TextEditingController(text: widget.pData.phone??'');
      email = TextEditingController(text: widget.pData.email??'');
      hospId = TextEditingController(text: widget.pData.hospitalId??'');
      rId = TextEditingController(text: widget.pData.rId??'');
      insuranceCompany = TextEditingController(text: widget.pData.insurance??'');
      setState(() {});
    }
  }
}
