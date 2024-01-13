import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class InputConfiguration {
  // static List<TextInputFormatter> format = [
  //   FilteringTextInputFormatter.deny(',')
  // ];
  static TextInputType inputType = TextInputType.numberWithOptions();
  static TextInputType inputTypeWithDot = TextInputType.numberWithOptions(decimal: true,);
  static TextInputAction inputActionNext = TextInputAction.next;

  static List<TextInputFormatter> formatDotOnly = [
    // FilteringTextInputFormatter.deny(',')
    ReplaceCommaFormatter()
  ];


 // static controller() {
 //    return MoneyMaskedTextController(
 //        decimalSeparator: ',',
 //        thousandSeparator: '',
 //        initialValue: 0.0,
 //        precision: 1);
 //  }
}


class ReplaceCommaFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.replaceAll(',', '.'),
      selection: newValue.selection,
    );
  }
}

