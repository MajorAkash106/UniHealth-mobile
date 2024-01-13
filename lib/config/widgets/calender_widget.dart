import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Locale/locale_config.dart';

String _selectedDate = '';
String _dateCount = '';
String _range = '';
String _rangeCount = '';
DateFormat dateFormat = DateFormat("yyyy-MM-dd");

void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
  _selectedDate = dateFormat.format(args.value).toString();
  // if (args.value is PickerDateRange) {
  //   _range = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString() +
  //       ' - ' +
  //       DateFormat('yyyy-MM-dd')
  //           .format(args.value.endDate ?? args.value.startDate)
  //           .toString();
  // } else if (args.value is DateTime) {
  //   _selectedDate = args.value.toString();
  //   print("selected date: $_selectedDate");
  //   print(
  //       "selected date format: ${dateFormat.format(DateTime.parse(_selectedDate))}");
  //   _selectedDate = '${dateFormat.format(DateTime.parse(_selectedDate))}';
  // } else if (args.value is List<DateTime>) {
  //   _dateCount = args.value.length.toString();
  // } else {
  //   _rangeCount = args.value.length.toString();
  // }
}

Future<String> calenderWidget(context, TextEditingController dataa,
    Function confirm, String heading, String initialDate,
    {bool disableFutureDate}) async {
  Locale locale = await LocaleConfig().getLocale();
  _selectedDate = '';

  Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Container(
        height: Get.height / 1.8,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
                child: Text(
              '$heading',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )),
            Divider(),
            Container(
              height: Get.height / 3,
              width: Get.width,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                supportedLocales: [
                  Locale('en' 'US'),
                  Locale('pt', 'BR'),
                ],
                locale: locale,
                home: SfDateRangePicker(
                    showNavigationArrow: true,
                    initialDisplayDate:
                        DateTime.parse(initialDate ?? '${DateTime.now()}'),
                    //  monthFormat: "yyyy-MM-dd",
                    view: DateRangePickerView.month,
                    enablePastDates: true,
                    initialSelectedDate:
                        DateTime.parse(initialDate ?? '${DateTime.now()}'),
                    maxDate:(disableFutureDate!=null && disableFutureDate)?DateTime.now():null,
                    onSelectionChanged: _onSelectionChanged),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    flex: 1,
                    child: CustomButton(
                      text: '  ${'skip'.tr}  ',
                      myFunc: () {
                        Get.back();
                      },
                    )),
                Flexible(
                    flex: 1,
                    child: CustomButton(
                        text: 'confirm'.tr,
                        myFunc: () {

                          debugPrint('on confirm :: $_selectedDate');

                          if(_selectedDate==''){
                            _selectedDate = '${dateFormat.format(DateTime.now())}';
                          }
                          dataa.text = _selectedDate;

                          Get.back(result: _selectedDate);
                          confirm();
                        })),
              ],
            )
          ],
        ),
      )));
}
