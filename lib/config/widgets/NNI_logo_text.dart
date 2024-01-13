
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_app/config/cons/images.dart';

Widget NNILogo_CopyRightText(){
  return Column(children: [
    SvgPicture.asset(AppImages.nni,height: 30,),
    SizedBox(height: 10,),
    Text(
      "© Copyright Products Nestle SA, 1994 Revision 2009.",
      style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),
    ),
  ],);
}

Widget CopyRightText(){
  return Text(
    "© Copyright Products Nestle SA, 1994 Revision 2009.",
    style: TextStyle(fontSize: 10,color: Colors.black,fontWeight: FontWeight.bold),
  );
}