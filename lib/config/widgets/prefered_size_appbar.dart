import 'package:flutter/material.dart';
import 'package:medical_app/config/cons/colors.dart';

Widget _preferdsizeappbar(String text, Widget _widget){
  return AppBar(
      title: Text(
        "Patient's List",
        style: TextStyle(color: appbar_icon_color),
      ),
      elevation: 1,
      backgroundColor: appbar_color,
      iconTheme: IconThemeData(color: appbar_icon_color),
      bottom: PreferredSize(
        //Here is the preferred height.
          preferredSize: Size.fromHeight(110.0),
          child: SafeArea(
            child:Column(
              children: [

                SizedBox(height: 10,),
                // SizedBox(height: 5,),
              ],
            ),
          )));
}