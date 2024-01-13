import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';

Widget LongAppbarWidget(Widget _widget){
  return AppBar(
    // title: Text(
    //   "Patient's List",
    //   style: TextStyle(color: appbar_icon_color),
    // ),
      elevation: 1,
      backgroundColor: primary_color,
      iconTheme: IconThemeData(color: card_color),
      bottom: PreferredSize(
        //Here is the preferred height.
          preferredSize: Size.fromHeight(60.0),
          child: SafeArea(
            child:_widget
          )));
}
