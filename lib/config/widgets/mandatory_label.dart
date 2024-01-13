import 'package:flutter/material.dart';
import '../cons/colors.dart';

Widget labelWidget({String label, bool isMandatory}) {
  return Row(
    children: [
      Text(label),
      isMandatory
          ? Text(
              '*',
              style: TextStyle(color: redTxt_color),
            )
          : SizedBox(),
    ],
  );
}
