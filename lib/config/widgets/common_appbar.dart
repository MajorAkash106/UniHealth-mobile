import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';

Widget BaseAppbar(String text,IconButton iconButton) {
  return AppBar(
    title:
    Text(
      text,
      style: TextStyle(color: card_color,fontSize: 15.0),
    ),
    centerTitle: true,
    elevation: 1,
    backgroundColor: primary_color,
    iconTheme: IconThemeData(color: card_color),
    actions: [
      iconButton??SizedBox()
    ],
  );
}
