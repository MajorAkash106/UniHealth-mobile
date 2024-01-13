import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<TimeOfDay> timePicker(
    BuildContext context, int initialHour, int initialMin) async {
  TimeOfDay _time = TimeOfDay(hour: initialHour, minute: initialMin);
  final TimeOfDay result = await showTimePicker(
    context: context,
    cancelText: 'cancel'.tr.toUpperCase(),
    confirmText: 'ok'.tr.toUpperCase(),
    hourLabelText: 'hour'.tr.toUpperCase(),
    minuteLabelText: 'minute'.tr.toUpperCase(),
    errorInvalidText: 'enter_valid_time'.tr,
    helpText: 'enter_time'.tr,
    // helpText: ,
    initialTime:
        initialHour == null && initialMin == null ? TimeOfDay.now() : _time,
    initialEntryMode: TimePickerEntryMode.input,
    builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child,
      );
    },
  );
  if (result != null) {
    print('result : ${result.format(context)}');
    print('result : ${result.hour}:${result.minute}');

    // return "${result.hour}:${result.minute}";
    return result;
  }
}
