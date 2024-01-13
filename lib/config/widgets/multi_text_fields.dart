import 'package:flutter/material.dart';

class CustomMultiTextField extends StatelessWidget {
  // final TextEditingController tc;
  final String text;

  CustomMultiTextField({this.text,});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      style: TextStyle(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
          hintText: '$text',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          // filled: true,
          fillColor: Colors.grey),
      maxLines: 5,
      // controller: _aboutme,
    );
  }
}