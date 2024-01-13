import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorHandler extends StatelessWidget {
  final bool visibility;
  final String message;
  final child;

  const ErrorHandler({Key key, this.message, this.child, this.visibility})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (visibility) {
      case true:
        return Center(child: Text(message ?? 'no_item_to_display'.tr,
        textAlign: TextAlign.center,
        ));
        break;
      default:
        return child;
    }
  }
}
