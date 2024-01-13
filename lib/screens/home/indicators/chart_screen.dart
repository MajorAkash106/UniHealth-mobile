import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/ad_log.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:medical_app/config/cons/indicator_type.dart';
import '../../../model/indicator/indicator_data.dart';

class ChartScreen extends StatefulWidget {
  final List<IndicatorData> data;

  ChartScreen({this.data});

  @override
  ChartScreenState createState() => ChartScreenState(data);
}

class ChartScreenState extends State<ChartScreen> {
  final List<IndicatorData> data;

  ChartScreenState(this.data);

  List<ChartData> chartData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppbar('Indicator', null),
        body: SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                left: 8,
                right: 8,
                bottom: 100,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'hospital'.tr + ' - ',
                        style: TextStyle(color: black40_color, fontSize: 15),
                      ),
                      Text(
                        data.first.info.hospitalName,
                        style: TextStyle(color: primary_color, fontSize: 15),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: data.first.info.wardName.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Text(
                            'ward'.tr + ' - ',
                            style:
                                TextStyle(color: black40_color, fontSize: 15),
                          ),
                          Text(
                            data.first.info.wardName,
                            style:
                                TextStyle(color: primary_color, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        'indicator'.tr + ' - ',
                        style: TextStyle(color: black40_color, fontSize: 15),
                      ),
                      Text(
                        data.first.info.indicatorName,
                        style: TextStyle(color: primary_color, fontSize: 15),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      children: [
                        Text(
                          'duration'.tr + ' - ',
                          style: TextStyle(color: black40_color, fontSize: 15),
                        ),
                        Text(
                          '${data.first.info.startDate} to ${data.first.info.endDate}',
                          style: TextStyle(color: primary_color, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _chart,
          ],
        )));
  }

  Widget get _chart {
    switch (data.first.indicatorType) {
      case indicatorType.one:
        return _indicator1;
        break;
      case indicatorType.two:
        return _indicator2;
        break;
      default:
        return _indicator1;
    }
  }

  Widget get _indicator1 {
    // chartData = [ChartData(data.first.out24hour.toStringAsFixed(1), data.first.out24hour, Colors.red),
    //   ChartData(data.first.in24hour.toStringAsFixed(1), data.first.in24hour, Colors.blue),
    // ];
    var _tooltip = TooltipBehavior(enable: true);
    data.forEach((it) {
      adLog('chart : ${it.diarrhea}');
      if(it.in24hour.isNaN){
        it.in24hour = 0;
      }
      chartData.add(ChartData(it.in24hour.toStringAsFixed(1) + '%', it.in24hour,
          _parseDateStrToColor(it.durationDate.startDate)));
      // var other = it.total - it.diarrhea;
      // chartData.add(ChartData(other.toStringAsFixed(1) + '%', other, Colors.red));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...data
                .map((it) => Row(
              children: [
                Icon(
                  Icons.circle,
                  color:
                  _parseDateStrToColor(it.durationDate.startDate),
                ),
                SizedBox(
                  width: 8,
                ),
                Text('${_parseDateStr(it.durationDate.startDate)}'),
              ],
            ))
                .toList()
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
            child: Container(
                width: Get.width * 0.80,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis:
                    NumericAxis(minimum: 0, maximum: 100, interval: 10),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Color.fromRGBO(8, 142, 255, 1))
                    ]))),
      ],
    );
  }

  Widget get _indicator2 {
    var _tooltip = TooltipBehavior(enable: true);
    data.forEach((it) {
      adLog('chart : ${it.diarrhea}');
      if(it.diarrhea.isNaN){
        it.diarrhea = 0;
      }
      chartData.add(ChartData(it.diarrhea.toStringAsFixed(1) + '%', it.diarrhea,
          _parseDateStrToColor(it.durationDate.startDate)));
      // var other = it.total - it.diarrhea;
      // chartData.add(ChartData(other.toStringAsFixed(1) + '%', other, Colors.red));
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...data
                .map((it) => Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color:
                              _parseDateStrToColor(it.durationDate.startDate),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text('${_parseDateStr(it.durationDate.startDate)}'),
                      ],
                    ))
                .toList()
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
            child: Container(
                width: Get.width * 0.80,
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis:
                        NumericAxis(minimum: 0, maximum: 100, interval: 10),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<ChartData, String>>[
                      ColumnSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Color.fromRGBO(8, 142, 255, 1))
                    ]))),
      ],
    );
  }

  String _parseDateStr(DateTime inputString) {
    List months = [
      'jan',
      'feb',
      'mar',
      'april',
      'may',
      'jun',
      'july',
      'aug',
      'sep',
      'oct',
      'nov',
      'dec'
    ];
    var mon = inputString.month;
    return months[mon - 1].toString().capitalizeFirst;
  }

  Color _parseDateStrToColor(DateTime inputString) {
    List months = [
      Colors.tealAccent,
      Colors.yellow.shade500,
      Colors.green.shade500,
      Colors.blue.shade500,
      Colors.red.shade500,
      Colors.orange.shade500,
      Colors.teal.shade500,
      Colors.purpleAccent,
      Colors.indigoAccent,
      Colors.lime,
      Colors.pinkAccent,
      Colors.blueGrey
    ];
    var mon = inputString.month;
    return months[mon - 1];
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color color;
}
