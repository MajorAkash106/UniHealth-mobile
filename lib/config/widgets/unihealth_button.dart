import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RaisedButton extends StatelessWidget {
  Function onPressed;
  Widget child;
  OutlinedBorder shape;
  EdgeInsetsGeometry padding;
  Color color;
  Color textColor;
  double elevation;


  RaisedButton({this.padding,this.shape,this.color,this.child,this.onPressed,this.textColor,this.elevation});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: shape, padding: padding, backgroundColor: color),
    );
  }
}
