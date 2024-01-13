import 'package:age/age.dart';

Future<double> getExactAge(String dob) async {
  DateTime today = DateTime.now(); //2020/1/24

  AgeDuration age;

  // Find out your age
  age = Age.dateDifference(
      fromDate: DateTime.parse(dob), toDate: today, includeToDate: false);

  print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  print('exact age: ${age.years}.${age.months}');
  print(double.parse("${age.years}.${age.months}"));
  double a = double.parse("${age.years}.${age.months}");

  // getPercentileFemale(a);
  // getPercentileMale(a);
  return a;
}

Future<double> getPercentileFemale(double age) async {
//   if(age>=1 && age<=1.9){
//   //  12.4
//   }else if(age>1.9 && age<=2.9){
//   //12.6
//   }else if(age>2.9 && age<=3.9){
//   //13.2
//   }else if(age>3.9 && age<=4.9){
//   //13.6
//   }else if(age>4.9 && age<=5.9){
//   //14.2
//   }else if(age>5.9 && age<=6.9){
//   //14.5
//   }else if(age>6.9 && age<=7.9){
//   //15.1
//   }else if(age>7.9 && age<=8.9){
//   //16
//   }else if(age>8.9 && age<=9.9){
//   //16.7
//   }else if(age>9.9 && age<=10.9){
// // 17
//   }else if(age>10.9 && age<=11.9){
// // 18.1
//   }else if(age>11.9 && age<=12.9){
// // 19.1
//   }else if(age>12.9 && age<=13.9){
// // 19.8
//   }else if(age>13.9 && age<=14.9){
// // 20.1
//   }else if(age>14.9 && age<=15.9){
// // 20.2
//   }else if(age>15.9 && age<=16.9){
// // 20.2
//   }else if(age>16.9 && age<=17.9){
// // 20.5
//   }else if(age>17.9 && age<=18.9){
// // 20.2
//   }else if(age>18.9 && age<=19.9){
// // 20.7
//   }else if(age>19.9 && age<=24.9){
// // 21.2
//   }else if(age>24.9 && age<=34.9){
//
//   }else if(age>34.9 && age<=44.9){
// // 21.8
//   }else if(age>44.9 && age<=54.9){
// // 22
//   }else if(age>54.9 && age<=64.9){
// // 22.5
//   }else if(age>64.9 && age<=74.9){
//     // 22.5
//   }else{
//     //22.5
//   }

  List Ages = [
    1.0,
    1.9,
    2.9,
    3.9,
    4.9,
    5.9,
    6.9,
    7.9,
    8.9,
    9.9,
    10.9,
    11.9,
    12.9,
    13.9,
    14.9,
    15.9,
    16.9,
    17.9,
    18.9,
    24.9,
    34.9,
    44.9,
    54.9,
    64.9,
    74.9
  ];

  List per = [
    12.4,
    12.6,
    13.2,
    13.6,
    14.2,
    14.5,
    15.1,
    16.0,
    16.7,
    17.0,
    18.1,
    19.1,
    19.8,
    20.1,
    20.2,
    20.2,
    20.5,
    20.2,
    20.7,
    21.2,
    21.8,
    22.0,
    22.5,
    22.5,
    22.5
  ];

  double returnValue = 0.0;

  print('age list len : ${Ages.length}');
  print('per list len : ${per.length}');

  try {
    for (var b = 0; b < Ages.length; b++) {
      if (age >= Ages[b] && age <= Ages[b + 1]) {
        print('percentile female: ${per[b]}');
        returnValue = per[b];
        break;
      }
    }
  } catch (e) {
    print('exception: ${e}');

    if (e.toString().contains('RangeError')) {
      print('yes range error');
      print('percentile female: ${per.last}');
      returnValue = per.last;
    }
  }
  return returnValue;
}

Future<double> getPercentileMale(double age) async {
  List Ages = [
    1.0,
    1.9,
    2.9,
    3.9,
    4.9,
    5.9,
    6.9,
    7.9,
    8.9,
    9.9,
    10.9,
    11.9,
    12.9,
    13.9,
    14.9,
    15.9,
    16.9,
    17.9,
    18.9,
    24.9,
    34.9,
    44.9,
    54.9,
    64.9,
    74.9
  ];

  List per = [
    12.7,
    13.0,
    13.7,
    14.1,
    14.7,
    15.1,
    16.0,
    16.2,
    17.0,
    18.0,
    18.3,
    19.5,
    21.1,
    22.3,
    23.7,
    24.9,
    25.8,
    26.4,
    27.3,
    27.9,
    28.6,
    28.1,
    27.8,
    26.8,
    26.8,
  ];

  print('age list len : ${Ages.length}');
  print('per list len : ${per.length}');
  double returnValue = 0.0;
  try {
    for (var b = 0; b < Ages.length; b++) {
      // print('a: ${per[b]}');

      if (age >= Ages[b] && age <= Ages[b + 1]) {
        print('percentile male: ${per[b]}');
        returnValue = per[b];
        break;
      }
    }
  } catch (e) {
    print('exception: ${e}');

    if (e.toString().contains('RangeError')) {
      print('yes range error');
      print('percentile male: ${per.last}');
      returnValue = per.last;
    }
  }
  return returnValue;
}


// 50th percentile means multiply by 100 to total
Future<String> getMAMCPer(double mamc, double percentile) async {
  double total = (mamc / percentile)*100.0;

  print('MAMC % : $total');

  return total.toStringAsFixed(1);
}

// IF < 0.7 = <70% (SEVERE MALNUTRITION)
// IF ≥ 0.7 AND < 0.8 = BETWEEN 70-80% (MODERATE MALNUTRITION).
// IF ≥ 0.8 AND < 0.9 = BETWEEN 80-90% (MILD MALNUTRITION).
// IF ≥ 0.9 = ≥ 90% (EUTROPHIC).


Future<String> getMAMCPerTitle(String mamc) async {
  double total = double.parse(mamc);

  if(total <70.0){
    return 'SEVERE MALNUTRITION';
  }else if(total >= 70.0  && total < 80.0){
    return 'MODERATE MALNUTRITION';
  }else if(total >= 80.0  && total < 90.0){
    return 'MILD MALNUTRITION';
  }else if(total>=90.0){
    return 'EUTROPHIC';
  }
}
