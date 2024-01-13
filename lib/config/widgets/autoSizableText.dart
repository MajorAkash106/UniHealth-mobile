import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/config/funcs/func.dart';


Widget autoSizableText(String text, String heading, var data,BuildContext context) {
  return text ==null || text ==''
      ? SizedBox()
      : Flexible(
      child: AutoSizeText(
        text.trim(),
        maxLines: 1,
        style: TextStyle(fontSize: 13),
        minFontSize: 13,
        overflowReplacement: Stack(
          // This widget will be replaced.
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 45),
              child: Text(
                text.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Positioned(
                right: 2,
                child: InkWell(
                  onTap: () {
                    data.runtimeType == String
                        ? ShowTextONPopup(context, heading, data)
                        : ShowListONPopup(context, heading, data);
                  },
                  child: Container(
                    //height: 40.0,
                    width: 40.0,
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "MORE".toUpperCase(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ));
}