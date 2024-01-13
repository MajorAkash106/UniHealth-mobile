import 'package:flutter/material.dart';



class BlankScreen extends StatefulWidget {
 Function function;
  BlankScreen({this.function});
  @override
  _BlankScreenState createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  getData() {
    Future.delayed(const Duration(milliseconds: 0), () {
      widget.function();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // child: CircularProgressIndicator(),
      ),
    );
  }
}
