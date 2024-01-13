import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController tc;
  final String hint;
  final keyboard;
  final secure;
  final iconsspre;
  final iconssend;

  final Function myFunc;

  CustomTextField(this.hint, this.tc, this.keyboard, this.secure,
      this.iconsspre, this.iconssend, this.myFunc);

  // CustomTextField({this.hint, this.tc, this.keyboard, this.secure,
  //     this.iconsspre, this.iconssend, this.myFunc});
 

  @override
  Widget build(BuildContext context) {
    return TextField(
      // onChanged:,
      style: TextStyle(color: Colors.black87),
      keyboardType: keyboard,
      obscureText: secure,
      decoration: InputDecoration(
        // hintText: hint,
        labelText: hint,
        // filled: true,

        fillColor: Colors.black87,
        prefixIcon: iconsspre,
//          suffixIcon:
        suffixIcon: IconButton(icon: iconssend, onPressed: myFunc),
      ),
      controller: tc,
    );
  }
}


