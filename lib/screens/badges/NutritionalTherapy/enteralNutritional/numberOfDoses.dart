import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/cons.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/time_picker/time_picker.dart';

class NumberOfDoses extends StatefulWidget {
  final List<NumberOfDays> privousdata;
  NumberOfDoses({this.privousdata});
  @override
  _NumberOfDosesState createState() => _NumberOfDosesState();
}

class _NumberOfDosesState extends State<NumberOfDoses> {
  var one = TextEditingController();
  var two = TextEditingController();
  var three = TextEditingController();
  var four = TextEditingController();
  var five = TextEditingController();
  var six = TextEditingController();
  var seven = TextEditingController();
  var eight = TextEditingController();

  bool checkbox1 = true;
  bool checkbox2 = true;
  bool checkbox3 = true;
  bool checkbox4 = true;
  bool checkbox5 = true;
  bool checkbox6 = true;
  bool checkbox7 = true;
  bool checkbox8 = true;

  TimeOfDay result1;
  TimeOfDay result2;
  TimeOfDay result3;
  TimeOfDay result4;
  TimeOfDay result5;
  TimeOfDay result6;
  TimeOfDay result7;
  TimeOfDay result8;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print('get previous data ${widget.privousdata.length}');

    if (!widget.privousdata.isNullOrBlank) {
      getData();
    }
  }

  getData() {
    for (var a in widget.privousdata) {
      if (a.index == 1) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          one.text = a.hour;
          checkbox1 = a.istoday;
          result1 = _startTime;
        }
      } else if (a.index == 2) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          two.text = a.hour;
          checkbox2 = a.istoday;
          result2 = _startTime;
        }
      } else if (a.index == 3) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          three.text = a.hour;
          checkbox3 = a.istoday;
          result3 = _startTime;
        }
      } else if (a.index == 4) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          four.text = a.hour;
          checkbox4 = a.istoday;
          result4 = _startTime;
        }
      } else if (a.index == 5) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          five.text = a.hour;
          checkbox5 = a.istoday;
          result5 = _startTime;
        }
      } else if (a.index == 6) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          six.text = a.hour;
          checkbox6 = a.istoday;
          result6 = _startTime;
        }
      } else if (a.index == 7) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          seven.text = a.hour;
          checkbox7 = a.istoday;
          result7 = _startTime;
        }
      } else if (a.index == 8) {
        if (a.hour.isNotEmpty) {
          String s = a.hour;
          TimeOfDay _startTime = TimeOfDay(
              hour: int.parse(s.split(":")[0]),
              minute: int.parse(s.split(":")[1]));
          eight.text = a.hour;
          checkbox8 = a.istoday;
          result8 = _startTime;
        }
      }
    }
  }

  Future<bool> willPopScope() {
    print('press on back');
    onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: willPopScope,
        child: Scaffold(
          appBar: BaseAppbar(
              'number_of_doses'.tr,
              // IconButton(
              //     icon: Icon(Icons.add),
              //     onPressed: () {
              //       getData();
              //     })
              null),
          body: Container(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '    ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        'hour'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'check_if_tomorrow'.tr,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'1st'.tr}: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result1?.hour,
                                            result1?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result1 = time;
                                      one.text =
                                          "${result1.hour < 10 ? '0${result1.hour}' : result1.hour}:${result1.minute < 10 ? '0${result1.minute}' : result1.minute}";

                                      print(result1.minute);
                                      setState(() {});
                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", one, () {
                                      print(one);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox1 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (one.text.isNotEmpty) {
                                            setState(() {
                                              checkbox1 = !checkbox1;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (one.text.isNotEmpty) {
                                            setState(() {
                                              checkbox1 = !checkbox1;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),

                                one.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              checkbox1 = true;
                                              one.clear();
                                              setState(() {});
                                            }),
                                      )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'2nd'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result2?.hour,
                                            result2?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result2 = time;
                                      two.text =
                                          "${result2.hour < 10 ? '0${result2.hour}' : result2.hour}:${result2.minute < 10 ? '0${result2.minute}' : result2.minute}";

                                      print(result2.minute);

                                      setState(() {});

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", two, () {
                                      print(two);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox2 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (two.text.isNotEmpty) {
                                            setState(() {
                                              checkbox2 = !checkbox2;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (two.text.isNotEmpty) {
                                            setState(() {
                                              checkbox2 = !checkbox2;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),

                                two.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox2 = true;
                                        two.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'3rd'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result3?.hour,
                                            result3?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result3 = time;
                                      three.text =
                                          "${result3.hour < 10 ? '0${result3.hour}' : result3.hour}:${result3.minute < 10 ? '0${result3.minute}' : result3.minute}";

                                      print(result3.minute);
                                      setState(() {});

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", three, () {
                                      print(three);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox3 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (three.text.isNotEmpty) {
                                            setState(() {
                                              checkbox3 = !checkbox3;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (three.text.isNotEmpty) {
                                            setState(() {
                                              checkbox3 = !checkbox3;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),

                                three.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox3 = true;
                                        three.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'4th'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result4?.hour,
                                            result4?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result4 = time;
                                      four.text =
                                          "${result4.hour < 10 ? '0${result4.hour}' : result4.hour}:${result4.minute < 10 ? '0${result4.minute}' : result4.minute}";

                                      print(result4.minute);

                                      setState(() {});

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", four, () {
                                      print(four);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox4 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (four.text.isNotEmpty) {
                                            setState(() {
                                              checkbox4 = !checkbox4;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (four.text.isNotEmpty) {
                                            setState(() {
                                              checkbox4 = !checkbox4;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),

                                four.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox4 = true;
                                        four.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'5th'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result5?.hour,
                                            result5?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result5 = time;
                                      five.text =
                                          "${result5.hour < 10 ? '0${result5.hour}' : result5.hour}:${result5.minute < 10 ? '0${result5.minute}' : result5.minute}";

                                      print(result5.minute);
                                      setState(() {});

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", five, () {
                                      print(five);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox5 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (five.text.isNotEmpty) {
                                            setState(() {
                                              checkbox5 = !checkbox5;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (five.text.isNotEmpty) {
                                            setState(() {
                                              checkbox5 = !checkbox5;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),


                                five.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox5 = true;
                                        five.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'6th'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result6?.hour,
                                            result6?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result6 = time;
                                      six.text =
                                          "${result6.hour < 10 ? '0${result6.hour}' : result6.hour}:${result6.minute < 10 ? '0${result6.minute}' : result6.minute}";

                                      print(result6.minute);

                                      setState(() {

                                      });

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", six, () {
                                      print(six);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox6 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (six.text.isNotEmpty) {
                                            setState(() {
                                              checkbox6 = !checkbox6;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (six.text.isNotEmpty) {
                                            setState(() {
                                              checkbox6 = !checkbox6;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),



                                six.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox6 = true;
                                        six.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'7th'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result7?.hour,
                                            result7?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result7 = time;
                                      seven.text =
                                          "${result7.hour < 10 ? '0${result7.hour}' : result7.hour}:${result7.minute < 10 ? '0${result7.minute}' : result7.minute}";

                                      print(result7.minute);

                                      setState(() {

                                      });

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", seven, () {
                                      print(seven);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox7 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (seven.text.isNotEmpty) {
                                            setState(() {
                                              checkbox7 = !checkbox7;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (seven.text.isNotEmpty) {
                                            setState(() {
                                              checkbox7 = !checkbox7;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),


                                seven.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox7 = true;
                                        seven.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  '${'8th'.tr}:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    timePicker(context, result8?.hour,
                                            result8?.minute)
                                        .then((time) {
                                      print('return time : $time');
                                      result8 = time;
                                      eight.text =
                                          "${result8.hour < 10 ? '0${result8.hour}' : result8.hour}:${result8.minute < 10 ? '0${result8.minute}' : result8.minute}";

                                      print(result8.minute);
                                      setState(() {

                                      });

                                    });
                                  },
                                  child: Container(
                                    width: 100.0,
                                    height: 40.0,
                                    child: texfld2("07:00", eight, () {
                                      print(eight);
                                    }),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                checkbox8 == false
                                    ? GestureDetector(
                                        onTap: () {
                                          if (eight.text.isNotEmpty) {
                                            setState(() {
                                              checkbox8 = !checkbox8;
                                            });
                                          }
                                        },
                                        child: Icon(Icons.check_box,
                                            size: 23.0, color: Colors.green))
                                    : GestureDetector(
                                        onTap: () {
                                          if (eight.text.isNotEmpty) {
                                            setState(() {
                                              checkbox8 = !checkbox8;
                                            });
                                          }
                                        },
                                        child: Icon(
                                          Icons.check_box_outline_blank,
                                          size: 22.0,
                                          color: Colors.black,
                                        )),


                                eight.text.isEmpty
                                    ? SizedBox()
                                    : Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        checkbox8 = true;
                                        eight.clear();
                                        setState(() {});
                                      }),
                                )

                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: Get.width,
                        child: CustomButton(
                          text: "confirm".tr,
                          myFunc: () {
                            print('confirm');
                            // Get.back();
                            onConfirm();
                          },
                        ),
                      )
                    ],
                  ))),
        ));
  }

  Widget texfld2(String hint, TextEditingController controller, Function _fun,
      {Function onsubmit_func}) {
    return TextField(
      controller: controller,
      enabled: false,
      //focusNode: focus,
      keyboardType: TextInputType.name,
      onChanged: (_value) {
        _fun();
      },
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        border: new OutlineInputBorder(
            //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            borderSide:
                BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
            ),
        hintStyle: TextStyle(
            color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  onConfirm() {
    List<NumberOfDays> AB = [];

    for (var a = 1; a <= 8; a++) {
      print('a : $a');

      if (a == 1) {
        if (one.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = one.text;
          numberOfDays.timePerday = result1.toString();
          numberOfDays.istoday = checkbox1;
          numberOfDays.index = 1;
          numberOfDays.schdule_date = checkbox1
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 2) {
        if (two.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = two.text;
          numberOfDays.timePerday = result2.toString();
          numberOfDays.istoday = checkbox2;
          numberOfDays.index = 2;
          numberOfDays.schdule_date = checkbox2
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 3) {
        if (three.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = three.text;
          numberOfDays.timePerday = result3.toString();
          numberOfDays.istoday = checkbox3;
          numberOfDays.index = 3;
          numberOfDays.schdule_date = checkbox3
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';
          AB.add(numberOfDays);
        }
      } else if (a == 4) {
        if (four.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = four.text;
          numberOfDays.timePerday = result4.toString();
          numberOfDays.istoday = checkbox4;
          numberOfDays.index = 4;
          numberOfDays.schdule_date = checkbox4
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 5) {
        if (five.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = five.text;
          numberOfDays.timePerday = result5.toString();
          numberOfDays.istoday = checkbox5;
          numberOfDays.index = 5;
          numberOfDays.schdule_date = checkbox5
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 6) {
        if (six.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = six.text;
          numberOfDays.timePerday = result6.toString();
          numberOfDays.istoday = checkbox6;
          numberOfDays.index = 6;
          numberOfDays.schdule_date = checkbox6
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 7) {
        if (seven.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = seven.text;
          numberOfDays.timePerday = result7.toString();
          numberOfDays.istoday = checkbox7;
          numberOfDays.index = 7;
          numberOfDays.schdule_date = checkbox7
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      } else if (a == 8) {
        if (eight.text.isNotEmpty) {
          NumberOfDays numberOfDays = NumberOfDays();
          numberOfDays.hour = eight.text;
          numberOfDays.timePerday = result8.toString();
          numberOfDays.istoday = checkbox8;
          numberOfDays.index = 8;
          numberOfDays.schdule_date = checkbox8
              ? '${DateFormat(commonDateFormat).format(DateTime.now())}'
              : '${DateFormat(commonDateFormat).format(DateTime.now().add(Duration(days: 1)))}';

          AB.add(numberOfDays);
        }
      }
    }

    print('final data : ${jsonEncode(AB)}');
    Get.back(result: AB);
  }
}

//
// var a = TextEditingController();
// bool checkbox12 = false;

// Future numberOfDoses(BuildContext context){
//  return showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           // You need this, notice the parameters below:
//           builder: (BuildContext context, StateSetter setState) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//               // Padding(padding: EdgeInsets.only(left: 10),child:   Align(
//               //   alignment: Alignment.topLeft,
//               //   child: Text(
//               //     'Number of Doses',
//               //     style: TextStyle(
//               //         color: Colors.black,
//               //         fontWeight: FontWeight.bold,
//               //         fontSize: 17.0),
//               //   ),
//               // ),),
//                 Padding(
//                   padding: EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '    ',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                               width: 100.0,
//                               height: 40.0,
//                               child: Center(
//                                 child: Text(
//                                   'Hours',
//                                   style:
//                                   TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                               )),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Text(
//                             'Check if tommorrow',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(
//                             '1st:',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           Container(
//                             width: 100.0,
//                             height: 40.0,
//                             child: texfld2("07:00", a, () {
//                               print(a);
//                             }),
//                           ),
//                           SizedBox(
//                             width: 15,
//                           ),
//                           checkbox12 == false
//                               ? GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(Icons.check_box,
//                                   size: 23.0, color: Colors.green))
//                               : GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   checkbox12 = !checkbox12;
//                                 });
//                               },
//                               child: Icon(
//                                 Icons.check_box_outline_blank,
//                                 size: 22.0,
//                                 color: Colors.black,
//                               ))
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                       bottom: MediaQuery.of(context).viewInsets.bottom),
//                   child:  Container(
//                       width: Get.width,
//                       child: RaisedButton(
//                         // shape: RoundedRectangleBorder(
//                         //   borderRadius: BorderRadius.circular(10.0),
//                         // ),
//                         padding: EdgeInsets.all(15.0),
//                         elevation: 0,
//                         onPressed: () {
//
//                         },
//                         color: primary_color,
//                         textColor: Colors.white,
//                         child: Text("Save",
//                             style: TextStyle(fontSize: 14)),
//                       )),
//                 )
//               ],
//             );
//           },
//         );
//       });
// }

Widget texfld2(String hint, TextEditingController controller, Function _fun,
    {Function onsubmit_func}) {
  return TextField(
    controller: controller,
    // enabled: enable,
    //focusNode: focus,
    keyboardType: TextInputType.name,
    onChanged: (_value) {
      _fun();
    },
    style: TextStyle(fontSize: 12),
    decoration: InputDecoration(
      hintText: hint,
      border: new OutlineInputBorder(
          //borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          borderSide:
              BorderSide(color: Colors.white, width: 0.0) //This is Ignored,
          ),
      hintStyle: TextStyle(
          color: black40_color, fontSize: 9.0, fontWeight: FontWeight.bold),
    ),
  );
}

class NumberOfDays {
  String hour;
  String timePerday;
  bool istoday;
  String schdule_date;
  int index;

  NumberOfDays(
      {this.hour,
      this.timePerday,
      this.istoday,
      this.schdule_date,
      this.index});

  NumberOfDays.fromJson(Map<String, dynamic> json) {
    hour = json['hour'];
    timePerday = json['timePerday'];
    istoday = json['istoday'];
    schdule_date = json['schdule_date'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hour'] = this.hour;
    data['timePerday'] = this.timePerday;
    data['istoday'] = this.istoday;
    data['schdule_date'] = this.schdule_date;
    data['index'] = this.index;
    return data;
  }
}
