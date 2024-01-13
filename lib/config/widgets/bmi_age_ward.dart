import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
class BmiAgeWard extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  BmiAgeWard({this.patientDetailsData});
  @override
  _BmiAgeWardState createState() => _BmiAgeWardState();
}

class _BmiAgeWardState extends State<BmiAgeWard> {
  @override
  Widget build(BuildContext context) {
    return  FutureBuilder(
        future: getAgeAccordingToKidAdult(widget.patientDetailsData.dob),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> value) {
          return Container(
            child: Expanded(
                child: Text(
                  '${'bmi'.tr.toUpperCase()}: ${widget.patientDetailsData.anthropometry.isNotEmpty?widget.patientDetailsData.anthropometry[0].bmi:'0'} kg/m\u{00B2} , ${'age'.tr}: ${value.data}, ${'ward'.tr}: ${widget.patientDetailsData.wardId.wardname}',
                  style:
                  TextStyle(color: Colors.black, fontSize: 17.0),
                )),
          );
        });
  }
}
