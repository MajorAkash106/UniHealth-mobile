import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';

class ReferenceScreen extends StatefulWidget {
  final List Ref_list;

  const ReferenceScreen({Key key, this.Ref_list}) : super(key: key);
  @override
  _ReferenceScreenState createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<ReferenceScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar('reference'.tr, null),
      // bottomNavigationBar: CommonHomeButton(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView(
              children: List.generate(widget.Ref_list.length, (index) => _widget(index))
          ),
        ),
      ),
    );
  }

  Widget _widget(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.Ref_list[index],
            style: TextStyle(fontSize: 15),
          ),
          SizedBox(height: 10,),
          Divider()
        ],
      ),
    );
  }
}
