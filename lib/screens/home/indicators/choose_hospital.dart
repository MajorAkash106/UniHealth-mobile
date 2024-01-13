import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/cons/indicator_type.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/indicators/indicator_controller.dart';
import 'package:medical_app/contollers/register_controller/state_cityController.dart';
import 'package:medical_app/model/duration_date.dart';
import 'package:medical_app/model/indicator/indicator_data.dart';
import 'package:medical_app/screens/date_range.dart';
import 'package:medical_app/screens/home/indicators/chart_screen.dart';

class ChooseHospital extends StatefulWidget {
  @override
  _ChooseHospitalState createState() => _ChooseHospitalState();
}

class _ChooseHospitalState extends State<ChooseHospital> {
  State_cityController state_cityController = State_cityController();
  IndicatorController _indicatorController = IndicatorController();
  String _selectedHosp;
  String _selectedWard;
  String _selectedIndicator;
  var _startDate;
  var _endDate;
  List<String> selected = [];
  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  @override
  void initState() {
    initArgument();
    super.initState();
  }

  void initArgument() async {
    Future.delayed(const Duration(milliseconds: 100), () {
      _indicatorController.getHospFromLocal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CommonHomeButton(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
                height: Get.height / 3,
                width: Get.width,
                color: primary_color,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                      AppImages.SplashlogoUnihealth,
                      height: 100,
                    ),
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              "choose_a_hospital".tr,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child:
                    //Container(child: Center(child: _value==0?,),),
                    Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                          iconEnabledColor: Colors.white,
                          isExpanded: true,
                          iconSize: 30.0,
                          hint: Text('select_hospital'.tr),
                          dropdownColor: Colors.white,
                          value: _selectedHosp,
                          items: _indicatorController.hosp
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(
                                    '${e.name}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0),
                                  ),
                                  value: '${e.sId}',
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            _selectedHosp = value;
                            _indicatorController.getWardData(_selectedHosp);

                            setState(() {});
                          }),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 10.0, right: 10.0, bottom: 0.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                child:
                    //Container(child: Center(child: _value==0?,),),
                    Obx(
                  () => Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          style: TextStyle(color: Colors.black, fontSize: 14.0),
                          iconEnabledColor: Colors.white,
                          isExpanded: true,
                          iconSize: 30.0,
                          hint: Text('select_ward_optional_'.tr),
                          dropdownColor: Colors.white,
                          value: _selectedWard,
                          items: _indicatorController.wards
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(
                                    '${e.wardname}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.0),
                                  ),
                                  value: '${e.sId}',
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            _selectedWard = value;
                            setState(() {});
                          }),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 10.0, right: 10.0, bottom: 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10.0),
              ),
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                      style: TextStyle(color: Colors.black, fontSize: 14.0),
                      iconEnabledColor: Colors.white,
                      isExpanded: true,
                      iconSize: 30.0,
                      hint: Text('select_indicator'.tr),
                      dropdownColor: Colors.white,
                      value: _selectedIndicator,
                      items: _indicatorController.indicators
                          .map(
                            (e) => DropdownMenuItem(
                              child: Text(
                                '${e.name}'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                              value: '${e.id}',
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        _selectedIndicator = value;

                        setState(() {});
                      }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 10.0, right: 10.0, bottom: 0.0),
            child: GestureDetector(
              onTap: () {
                // _onPressed();

                List<String> _dates = [];
                if (_startDate != null && _endDate != null) {
                  _dates = [_startDate, _endDate];
                }

                Get.to(DateRange(
                  initialDates: _dates,
                )).then((arg) {
                  if (arg != null) {
                    setState(() {
                      _startDate = arg[0];
                      _endDate = arg[1];
                    });
                  }
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            '${_startDate ?? 'Start Date'}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                          ),
                          VerticalDivider(
                            thickness: 1.5,
                          ),
                          Text(
                            '${_endDate ?? 'End Date'}',
                            style:
                                TextStyle(color: Colors.black, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ),

          Spacer(),
          Container(
            width: Get.width,
            margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: CustomButton(text: 'next'.tr, myFunc: () => onNext()),
          )
        ],
      ),
    );
  }

  Future<List<IndicatorData>> getIndicatorData() async {
    List<IndicatorData> indicatorData;
    List<DurationDate> durationData = duration;
    switch (int.parse(_selectedIndicator)) {
      case indicatorType.one:
        await _indicatorController.getPatientsData(
            _selectedHosp, _selectedWard);
        indicatorData = await _indicatorController.getFreq(_indicatorController.getPatients(_selectedWard),duration);
        break;
      case indicatorType.two:


        adLog('durationData : ${durationData.length}');

        indicatorData =  await _indicatorController.getBothHistory(
            _selectedHosp, _selectedWard, durationData);

        break;
      default:
        return null;
    }

    var hosp = await _indicatorController.hosp
        .firstWhereOrNull((it) => it.sId == _selectedHosp);
    var ward = await _indicatorController.wards.firstWhereOrNull(
      (it) => it.sId == _selectedWard,
    );
    var indicator = await _indicatorController.indicators
        .firstWhereOrNull((it) => it.id.toString() == _selectedIndicator);
    // adLog('message == ${hosp.name} , ${ward.wardname}, ${indicator.name}');
    var info = Info(
        hospitalName: hosp.name,
        wardName: ward?.wardname ?? '',
        indicatorName: indicator.name,
        startDate: _startDate,
        endDate: _endDate);
    indicatorData.first.info = info;

    return indicatorData;
  }

  onNext() async {
    if (_selectedHosp != null) {
      if (_selectedIndicator != null) {
        if (_startDate != null && _endDate != null) {
          List<IndicatorData> indicatorData =
          await getIndicatorData();
          Get.to(ChartScreen(
            data: indicatorData,
          ));
        } else {
          ShowMsg('Please choose dates');
        }
      } else {
        ShowMsg('Please choose indicator');
      }
    } else {
      ShowMsg('At-least choose hospital');
    }
  }

  List<DurationDate> get duration {
    var date1 = DateTime.parse(_startDate);
    var date2 = DateTime.parse(_endDate);
    var dates = [];
    while (date1.isBefore(date2)) {
      // print(DateFormat(commonDateFormat).format(date1));
      dates.add(DateFormat(commonDateFormat).format(date1));
      date1 = DateTime(date1.year, date1.month + 1);
    }

    dates.add(_endDate);
    adLog('dates :: $dates');
    List<DurationDate> durationData = [];
    for (var a = 0; a < dates.length; a++) {
      adLog(dates[a]);

      durationData.add(DurationDate(
          startDate: DateTime.parse('${dates[a]} 00:00:00'),
          endDate: DateTime.parse('${dates[a + 1]} 00:00:00')));
      if (dates[a + 1] == dates.last) {
        break;
      }
    }
    //
    // for (var a in durationData) {
    //   adLog('durationData start : ${a.startDate}');
    //   adLog('durationData end : ${a.endDate}');
    // }

    return durationData;
  }
}
