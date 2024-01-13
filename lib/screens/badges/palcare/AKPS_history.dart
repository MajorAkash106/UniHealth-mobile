import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';

class AKPSHistory extends StatefulWidget {
  @override
  _AKPSHistoryState createState() => _AKPSHistoryState();
}

class _AKPSHistoryState extends State<AKPSHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('AKPS History', null),
      bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
              children: List.generate(6, (index) => _widget())
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
            "21-10-21",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "40%",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Text(
                "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal,color: black40_color),
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}
