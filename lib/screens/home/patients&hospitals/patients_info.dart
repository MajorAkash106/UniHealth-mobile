import 'package:flutter/material.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/model/PatientListModel.dart';


class PatientInfoScreen extends StatefulWidget {
  final PatientData patientInfo;
  PatientInfoScreen(this.patientInfo);
  @override
  _PatientInfoScreenState createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("Patients's Info", null),
      bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
            children: [
            _widget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _widget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Patient's name - ${widget.patientInfo.name}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Phone - ${widget.patientInfo.phone}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Email - ${widget.patientInfo.email}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "D.O.B - ${widget.patientInfo.dob}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Hospitalized on - ${widget.patientInfo.admissionDate}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Dizziness",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     SizedBox(),
          //     Text(
          //       "See More >>",
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: black40_color),
          //     ),
          //   ],
          // ),
          Divider()
        ],
      ),
    );
  }
}
