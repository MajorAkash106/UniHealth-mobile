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
import 'package:medical_app/contollers/patient&hospital_controller/Patients_slip_controller.dart';
import 'package:medical_app/contollers/hospitalization_controller/newHospController.dart';
import 'package:medical_app/contollers/hospitalization_controller/re_admit_controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/patient_dashboard/step1_hospitalization.dart';

import '../../../config/cons/gender_config.dart';

class ReAdmitPatient extends StatefulWidget {
  final String title;
  final List<PatientDetailsData> patientDetail;
  final selectedHospital;
  final String hospId;
  final String wardId;
  final String bedId;

  ReAdmitPatient({this.title, this.patientDetail, this.selectedHospital,
  this.hospId,this.wardId,this.bedId
  });
  @override
  _ReAdmitPatientState createState() =>
      _ReAdmitPatientState();
}

class _ReAdmitPatientState extends State<ReAdmitPatient> {

  final ReAdmitController _controller = ReAdmitController();


  @override
  void initState() {
    // TODO: implement initState
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {

        _controller.getHospitalData().then((value){
          var selectedData = _controller.hospListdata.firstWhere((element) => element.sId == widget.hospId,orElse: ()=>null);

          if(selectedData!=null){
            selectedHospital= widget.hospId;
          }

          _controller.getWardData(selectedHospital).then((value){


            var selectedDataward = _controller.wardListdata.firstWhere((element) => element.sId == widget.wardId,orElse: ()=>null);

            if(selectedDataward!=null){
              selectedWard= widget.wardId;

              _controller.getBedData(selectedWard).then((value){

                var selectedDatabed = _controller.bedListdata.firstWhere((element) => element.sId == widget.bedId,orElse: ()=>null);

                if(selectedDatabed!=null) {
                  selectedBed = widget.bedId;
                }
              });
            }



            _controller.getMedicalData([selectedData]).then((value){
              var selctv = _controller.medicalListdata.firstWhere((element) => element.sId == widget.patientDetail[0].medicalId.sId,orElse: ()=>null);
              if(selctv!=null){
                selectedMedical = selctv.sId;
              }
            });
          });


          //
          // print('selected hospital: ${jsonEncode(selectedData)}');
          //
          // _controller.getMedicalData([selectedData]);
          // get_ward_data();
        });

        print('internet avialable');
      }
    });
    // print('abc');
    // print( widget.patientDetail[0].hospital[0].name);
    // print( _controller.hospListdataDetails.length);
    //
    //
    // print('abc');
    // print(selectedHospital);
    // print('abc');
    // print(widget.patientDetail[0].hospital[0].sId);
    // print(widget.selectedHospital.toString());
    //60bfb0fbc860be2e0a5ccf7d
    print(widget.patientDetail[0].admissionDate);
    patientName = TextEditingController(text: widget.patientDetail[0].name);
    // hospitalname = TextEditingController(text: widget.patientDetail[0].hospital[0].name);
    phone = TextEditingController(text: widget.patientDetail[0].phone);
    email = TextEditingController(text: widget.patientDetail[0].email);
    hospId = TextEditingController(text: widget.patientDetail[0].hospitalId);
    rId = TextEditingController(text: widget.patientDetail[0].rId);
    insuranceCompany = TextEditingController(text: widget.patientDetail[0].insurance);
    gender_value = widget.patientDetail[0].gender.toLowerCase();
    dob_initial = DateTime.parse(widget.patientDetail[0].dob);
    print(dob_initial);
    // admit_date = DateTime.parse(widget.patientDetail[0].admissionDate.trim());
    admit_date = DateTime.now();
    print('admit_date : ${admit_date}');
    // selectedHospital= selectedHospital??widget.patientDetail[0].hospital[0].sId;
    //selectedHospital =widget.selectedHospital;
    // selectedMedical = widget.patientDetail[0].medicalId.sId;
    // selectedMedicalName = widget.patientDetail[0].medicalId.division;
    // selectedWard =selectedWard??widget.patientDetail[0].wardId.sId;
    // selectedBed = widget.patientDetail[0].bedId.bedNumber;
    // selectedBedId = widget.patientDetail[0].bedId.sId;

    setState(() {
      dob = dob_initial;
      admission_date = admit_date;
      // _controller.bedListdata.add(widget.patientDetail[0].bedId.);


    });

    super.initState();

  }
  String selectedBedId;

  var patientName = TextEditingController();
  var hospitalname = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var hospId = TextEditingController();
  var rId = TextEditingController();
  var insuranceCompany = TextEditingController();
  var pass = TextEditingController();

  void get_ward_data(){
    _controller.getWardData(selectedHospital).then((value){

      _controller.getEditBedData(selectedWard,widget.patientDetail[0].bedId.sId).then((value) {
        setState(() {
          selectedBed = widget.patientDetail[0].bedId.sId;
        });
      });
    });

    // Future.delayed(Duration(seconds: 1)).then((value) => ,);

    // selectedBed = selectedBed??widget.patientDetail[0].bedId.sId;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('${widget.title}', null),
        // bottomNavigationBar: CommonHomeButton(),
        body: Obx(
              () => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView(
                children: [
                  Text(
                    "patients_info".tr,
                    style: TextStyle(color: appbar_icon_color, fontSize: 16,),
                  ),
                  Card(
                    color: card_color,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Column(
                          children: [

                            hospitalListWidget(),

                            // _textfield("Hospital Name", hospitalname,TextInputType.text,readonly: true),

                            SizedBox(
                              height: 20,
                            ),
                            _textfield("name".tr, patientName,TextInputType.text,readonly: false),
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
                                labelText: "phone".tr,
                                contentPadding: EdgeInsets.all(0.0),
                              ),
                              onChanged: (String newValue) {
                                print(newValue);
                                // _stashItem.width = "$newValue $_widthUnit";
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _textfield("email".tr, email,TextInputType.emailAddress,readonly: false),

                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    flex: 1,
                                    child:
                                    TextFormField(
                                      keyboardType: TextInputType.text,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   WhitelistingTextInputFormatter.digitsOnly
                                      // ],
                                      // enabled: false,
                                      controller: hospId,
                                      decoration: InputDecoration(
                                        labelText: "hosp_id".tr,
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
                                Flexible(flex: 1, child: _textfield("r_id".tr, rId,TextInputType.text,readonly: false)
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
                                      genderlist, "gender".tr, gender_value),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Flexible(
                                    flex: 1, child: date_of_birth("dob".tr, dob))
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
                                        "admit_date".tr, admission_date))
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
                            _textfield("insurance_company".tr, insuranceCompany,TextInputType.text,readonly: false),
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
                    text: "save".tr,
                    // myFunc: (){
                    //    print(selectedHospital);
                    //    print(patientName.text);
                    //    print(phone.text);
                    //    print(email.text);
                    //    print(hospId.text);
                    //    print(rId.text);
                    //    print(gender_value);
                    //    print(dob==null?dob_initial:dob);
                    //    print(selectedWard);
                    //    print(selectedBed==null?widget.patientDetail[0].bedId.sId:selectedBed);
                    //    print(admission_date==null?admit_date:admission_date);
                    //    print(selectedMedical);
                    //    print(insuranceCompany.text);
                    //    //print(dob_initial.toString());
                    // },
                    myFunc:(){onpreesss();} ,
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
    'male',
    'female',
    // 'Other',
  ];

  void onpreesss() {
    // Get.to(Step1HospitalizationScreen());
    print('dob: $dob');
    print(gender_value);
    _controller.editPatientDetails(
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
        '12345',widget.patientDetail[0]);
  }



  String selectedHospital;
  String selectedHospitalName;
  Widget hospitalListWidget() {
    return DropdownButtonFormField(
        isExpanded: true,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: "hospitals_name".tr,
          labelText: "hospitals_name".tr,

          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        // disabledHint: Text(widget.patientDetail[0].hospital[0].name),
        value: selectedHospital,//==null?widget.patientDetail[0].hospital[0].sId:selectedHospital,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        // items: [DropdownMenuItem(child: Text('abc'),value: selectedHospital,)],
        items:
        _controller.hospListdata.map((e) => DropdownMenuItem<String>(value: e.sId, child: Text(e.name))).toList(),

        onChanged: (value) => setState(() {
          // print('value: $selectedHospital');

          var selectedData = _controller.hospListdata.firstWhere((element) => element.sId == value);
          setState(() {
            selectedHospitalName = selectedData.name;
          });

          if (selectedHospital != value) {
            print('yest..');
            selectedHospital = value;
            // hospId.text = value;
            _controller.wardListdata.clear();
            selectedWard = null;
            _controller.bedListdata.clear();
            selectedBed = null;
            _controller.getWardData(selectedHospital);

            _controller.getMedicalData([selectedData]);

          }else{
            print('else');
          }
          print('dddd');
          print(value);
          print('dddd');
        })

    );
  }

  String selectedWard;
  String selectedWardName;
  Widget wardListWidget() {
    return DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          hintText: "select_ward".tr ,
          labelText: "select_ward".tr,

          hintStyle: TextStyle(color: widget.title=="Update_patient_info".tr?Colors.black:null),
          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        // disabledHint: Text(widget.patientDetail[0].wardId.wardname),
        value: selectedWard,//==null?widget.patientDetail[0].wardId.sId:selectedWard,
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
          else{
            print('same');
          }
        })
      // onChanged: null,
    );
  }

  String selectedBed;
  Widget bedListWidget() {
    // return InkWell(
    //   onTap: (){
    //     print( _controller.bedListdata.isEmpty);
    //     if(_controller.bedListdata.isEmpty){
    //       ShowMsg('Sorry! All Beds are occupied');
    //     }
    //   },
    //   child: DropdownButtonFormField(
    //       isExpanded: true,
    //       decoration: InputDecoration(
    //         contentPadding: EdgeInsets.all(0.0),
    //         hintText: "Select Bed",
    //         labelText: "Select Bed",
    //         // hintStyle: TextStyle(color: widget.title=="Update Patient Info"?Colors.black:null),
    //         // suffixIcon: Icon(Icons.arrow_drop_down)
    //       ),
    //       // hint: Padding(
    //       //   padding: const EdgeInsets.only(top: 6.0),
    //       //   child: Text('abc'),
    //       // ) ,
    //       value: selectedBed,//??widget.patientDetail[0].sId,//:selectedBed,
    //       iconEnabledColor: primary_color,
    //       // disabledHint: Text(widget.patientDetail[0].bedId.bedNumber),
    //       icon: Icon(null),
    //       items: _controller.bedListdata
    //           .map((e) => DropdownMenuItem<String>(
    //           value: e.sId, child: Text(e.bedNumber)))
    //           .toList(),
    //       onChanged: (value) => setState(() {
    //         if(selectedBed !=value){
    //           selectedBed = value;
    //           print('value: $selectedBed');
    //         }
    //
    //       })
    //     // onChanged: null,
    //   ),
    // );
    return  InkWell(
      onTap: (){
        print( _controller.bedListdata.isEmpty);
        if(_controller.bedListdata.isEmpty){
          ShowMsg('all_beds_are_occupied'.tr);
        }
      },
      child: DropdownButtonFormField(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "select_bed".tr,
            labelText: "select_bed".tr,
            // hintStyle: TextStyle(color: widget.title=="Update Patient Info"?Colors.black:null),
            // suffixIcon: Icon(Icons.arrow_drop_down)
          ),
          // hint: Padding(
          //   padding: const EdgeInsets.only(top: 6.0),
          //   child: Text('abc'),
          // ) ,
          value: selectedBed,//??widget.patientDetail[0].sId,//:selectedBed,
          iconEnabledColor: primary_color,
          // disabledHint: Text(widget.patientDetail[0].bedId.bedNumber),
          icon: Icon(null),
          items: _controller.bedListdata
              .map((e) => DropdownMenuItem<String>(
              value: e.sId, child: Text(e.bedNumber)))
              .toList(),
          onChanged: (value) => setState(() {
            if(selectedBed !=value){
              selectedBed = value;
              print('value: $selectedBed');
            }

          })
        // onChanged: null,
      ),);
  }


  String selectedMedical;
  String selectedMedicalName;
  Widget medicalListWidget() {
    return DropdownButtonFormField(
        isExpanded:  true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            hintText: "medical_div".tr,
            labelText:"medical_div".tr

          // suffixIcon: Icon(Icons.arrow_drop_down)
        ),
        value:selectedMedical,
        // disabledHint: ,
        //selectedMedical,//==null?widget.patientDetail[0].medicalId.sId:selectedMedical,
        iconEnabledColor: primary_color,
        icon: Icon(null),
        items:
        //[DropdownMenuItem(child: Text('abc'),value: '123',),],
        _controller.medicalListdata==null?[]:_controller.medicalListdata
            .map((e) => DropdownMenuItem<String>(
            value: e.sId, child: Text(e.division)))
            .toList(),
        onChanged: (value) => setState(() {
          selectedMedical = value;
          print('value: $selectedMedical');
        })

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
            DropdownMenuItem<String>(value: value, child: Text(value.tr)))
            .toList(),
        onChanged: (val) => setState(() {
          gender_value = val;
        }));
  }

  Widget _textfield(text, TextEditingController controller,TextInputType _type,{bool readonly}) {
    return TextFormField(
      readOnly: readonly,
      keyboardType: _type,
      // inputFormatters: <TextInputFormatter>[
      //   WhitelistingTextInputFormatter.digitsOnly
      // ],
      controller: controller,
      decoration: InputDecoration(
        labelText: "$text",
        labelStyle: TextStyle(color: readonly?Colors.black45:null),
        contentPadding: EdgeInsets.all(0.0),

      ),
      onChanged: (String newValue) {
        print(newValue);
        // _stashItem.width = "$newValue $_widthUnit";
      },
    );
  }

  var dob;
  DateTime dob_initial;
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
  DateTime admit_date;
  Widget date_of_admit(text, value) {
    return DateTimeField(
      format: format,
      // enabled: false,
      initialValue: admit_date,
      // style: TextStyle(color: Colors.black45),
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
