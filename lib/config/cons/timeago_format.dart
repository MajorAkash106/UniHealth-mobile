import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

String getTimeAgo(String val) {
  String output = timeago.format(DateTime.parse(val));
  if (output.contains('days ago')) {
    output = output.replaceAll('days ago', 'days_ago'.tr);
  } else if (output.contains('day ago')) {
    output = output.replaceAll('a day ago', 'day_ago'.tr);
  }else if (output.contains('a moment ago')) {
    output = output.replaceAll('a moment ago', 'moment_ago'.tr);
  } else if (output.contains('moment ago')) {
    output = output.replaceAll('moment ago', 'moment_ago'.tr);
  }  else if (output.contains('minute ago')) {
    output = output.replaceAll('a minute ago', 'minute_ago'.tr);
  } else if (output.contains('minutes ago')) {
    output = output.replaceAll('minutes ago', 'minutes_ago'.tr);
  } else if (output.contains('about an hour ago')) {
    output = output.replaceAll('about an hour ago', 'about_an_hour_ago'.tr);
  } else if (output.contains('hours ago')) {
    output = output.replaceAll('hours ago', 'hours_ago'.tr);
  } else if (output.contains('hour ago')) {
    output = output.replaceAll('hour ago', 'hour_ago'.tr);
  } else if (output.contains('about a month ago')) {
    output = output.replaceAll('about a month ago', 'about_a_month_ago'.tr);
  }else if (output.contains('months ago')) {
    output = output.replaceAll('months ago', 'months_ago'.tr);
  }
  return output;
}
