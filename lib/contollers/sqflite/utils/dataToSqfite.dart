import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/sqflite/database/Helper.dart';
import 'package:medical_app/contollers/sqflite/utils/Utils.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:json_store/json_store.dart';

class SaveTO extends StatefulWidget {
  final PatientDetailsData patientDetailsData;
  SaveTO({this.patientDetailsData});
  @override
  _SaveTOState createState() => _SaveTOState();
}

class _SaveTOState extends State<SaveTO> {
  final _jsonStore = JsonStore(dbName: 'sampleapp');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('testing mode'),
      ),
      body: SafeArea(
        child: Container(
            child: ListView(
          children: [
            RaisedButton(
              onPressed: () async {
                
                print('patient data: ${jsonEncode(widget.patientDetailsData)}');
                await _jsonStore.setItem('counter', widget.patientDetailsData.toJson());
                
              },
              child: Text('save'),
            ),
            RaisedButton(
              onPressed: () async {
                
                Map<String, dynamic> json = await _jsonStore.getItem('counter');
                PatientDetailsData data = await json != null
                    ? new PatientDetailsData.fromJson(json)
                    : null;
                
                print('data: ${jsonEncode(data)}');
              },
              child: Text('get'),
            ),
            RaisedButton(
              onPressed: () async {
                
                _jsonStore.clearDataBase();

              },
              child: Text('clear'),
            ),
          ],
        )),
      ),
    );
  }
}
