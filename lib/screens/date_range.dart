import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../config/Snackbars.dart';
import '../config/widgets/unihealth_button.dart';

// ignore: must_be_immutable
class DateRange extends StatefulWidget {
  List<String> initialDates;

  DateRange({this.initialDates});

  @override
  DateRangeState createState() => DateRangeState();
}

/// State for DateRange
class DateRangeState extends State<DateRange> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  var _startDate;
  var _endDate;
  // final format = DateFormat("dd/MM/yyyy");
  final format = DateFormat("yyyy-MM-dd");
  // final formatAssign = DateFormat("yyyy-MM-dd");

  DateRangePickerSelectionChangedArgs arg;

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${format.format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${format.format(args.value.endDate ?? args.value.startDate)}';

        _startDate = format.format(args.value.startDate).toString();
        // _startDate = args.value.startDate;
        _endDate = format.format(args.value.endDate).toString();
        // _endDate = args.value.endDate;


        arg = args;
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    adLog('widget.initialDates :: ${widget.initialDates}');
    // adLog('format :: ${DateTime.now().subtract(const Duration(days: 4))}');
    // adLog('format :: ${DateTime.parse(formatAssign.format(DateTime.parse(widget.initialDates.first)) + ' 11:54:01')}');
    return Scaffold(
        // bottomNavigationBar:
        appBar: AppBar(
          title: const Text('Choose dates'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _range.isEmpty
                        ? SizedBox()
                        : Text(
                            _range,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      height: Get.height / 2,
                      child: SfDateRangePicker(
                        confirmText: 'OK',
                        cancelText: 'CANCEL',
                        endRangeSelectionColor: primary_color,
                        startRangeSelectionColor: primary_color,
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                        // initialSelectedRange: widget.initialDates.isEmpty
                        //     ? null
                        //     : PickerDateRange(
                        //   DateTime.parse(formatAssign.format(DateTime.parse(widget.initialDates.first)) + ' 11:54:01'),
                        //   DateTime.parse(formatAssign.format(DateTime.parse(widget.initialDates.last)) + ' 11:54:01'),
                        //         //  DateTime.now().subtract(const Duration(days: 4)),
                        //         //                           DateTime.now().add(const Duration(days: 3))),
                        //       ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                    width: Get.width,
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      elevation: 0,
                      onPressed: () {
                        Get.back();
                        Get.to(DateRange(
                          initialDates: [],
                        ));
                      },
                      color: Colors.red.shade400,
                      textColor: Colors.white,
                      child: Text("reset".tr, style: TextStyle(fontSize: 14)),
                    )),
              ),
              Container(
                  width: Get.width,
                  child: RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    elevation: 0,
                    onPressed: () async{
                      if (_startDate == _endDate) {
                        ShowMsg('Start date & End date must not be same');
                      } else {
                        Get.back(result: [_startDate, _endDate]);

                       //  await adLog(arg);
                       //
                       // await adLog(arg.value.startDate.year);
                       // await adLog(arg.value.startDate.month);
                       //
                       //  DateTime lastDayOfMonth = await new DateTime(
                       //      arg.value.startDate.year,
                       //      arg.value.startDate.month +1,
                       //      0);
                       //  adLog("N days: ${lastDayOfMonth.day}");
                      }
                    },
                    color: primary_color,
                    textColor: Colors.white,
                    child: Text("save".tr, style: TextStyle(fontSize: 14)),
                  )),
            ],
          ),
        ));
  }
}
