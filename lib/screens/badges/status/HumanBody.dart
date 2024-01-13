import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';
import 'package:medical_app/contollers/other_controller/Refference_notes_Controller.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:page_indicator/page_indicator.dart';

class HumanBody extends StatefulWidget {
  final List<AmputationData> list;
  final bool wantDiscount;
  HumanBody({this.list,this.wantDiscount});
  @override
  _HumanBodyState createState() => _HumanBodyState();
}

class _HumanBodyState extends State<HumanBody> {
  Refference_Notes_Controller ref_controller = Refference_Notes_Controller();

  @override
  void initState() {
    // TODO: implement initState

    print("selected : ${widget.list.length}");
    setState(() {
      wantDiscountOnWeight = widget.wantDiscount;
    });
    getSelectedData();
    super.initState();
  }

  getSelectedData() {
    for (var a = 0; a < widget.list.length; a++) {
      if (!widget.list[a].value) {
        print(widget.list[a].name);
        // if(widget.list[a].name)
        changeStatus(widget.list[a]);
      }
    }
  }

  void changeStatus(AmputationData data) {
    if (data.name == 'checkbox1') {
      setState(() {
        checkbox1 = data.value;
      });
    } else if (data.name == 'checkbox2') {
      setState(() {
        checkbox2 = data.value;
      });
    } else if (data.name == 'checkbox3') {
      setState(() {
        checkbox3 = data.value;
      });
    } else if (data.name == 'checkbox4') {
      setState(() {
        checkbox4 = data.value;
      });
    } else if (data.name == 'checkbox5') {
      setState(() {
        checkbox5 = data.value;
      });
    } else if (data.name == 'checkbox6') {
      setState(() {
        checkbox6 = data.value;
      });
    } else if (data.name == 'checkbox7') {
      setState(() {
        checkbox7 = data.value;
      });
    } else if (data.name == 'checkbox8') {
      setState(() {
        checkbox8 = data.value;
      });
    } else if (data.name == 'checkbox9') {
      setState(() {
        checkbox9 = data.value;
      });
    } else if (data.name == 'checkbox10') {
      setState(() {
        checkbox10 = data.value;
      });
    } else if (data.name == 'checkbox11') {
      setState(() {
        checkbox11 = data.value;
      });
    } else if (data.name == 'checkbox12') {
      setState(() {
        checkbox12 = data.value;
      });
    }
  }

  List<AmputationData> AllBoxes = [];
  void addRemoveBox(String name, bool value) {
    // Map data = {
    //   'name': name,
    //   'value': value,
    // };

    for (var a = 0; a < AllBoxes.length; a++) {
      print(AllBoxes[a].name);

      if (AllBoxes[a].name == name) {
        AllBoxes.remove(AllBoxes[a]);
        // AllBoxes[a].name = name;
        // AllBoxes[a].value = value;
      } else {}
    }

    AllBoxes.add(AmputationData(name: name, value: value));
    print('allBox : ${jsonEncode(AllBoxes)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          "amputation".tr,
          IconButton(
            icon: Icon(
              Icons.info_outline,
              color: card_color,
            ),
            onPressed: () {
              Get.to(ReferenceScreen(
                Ref_list: ref_controller.AMPUTATION_Ref_list,
              ));
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
            child: Column(
              children: [
                Expanded(child: _slider()),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          wantDiscountOnWeight = !wantDiscountOnWeight;
                        });
                      },
                      child: Row(
                        children: [
                          wantDiscountOnWeight
                              ? Icon(Icons.check_box,
                              size: 20.0, color: Colors.green)
                              : Icon(
                            Icons.check_box_outline_blank,
                            size: 20.0,
                            color: Colors.black,
                          ),
                          Expanded(
                              child:Padding(
                                padding: EdgeInsets.only(top: 10, left: 10,),
                                child: Text(
                                  'check_on_amputation'.tr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0,
                                      color: appbar_icon_color),
                                ),
                              ))
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            color: primary_color,
                            child: Center(
                              child: Text(
                                'confirm'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              List allCheck = [];

                              allCheck.add(checkbox1 ? 0 : 2.7);
                              allCheck.add(checkbox2 ? 0 : 2.7);
                              allCheck.add(checkbox3 ? 0 : 1.6);
                              allCheck.add(checkbox4 ? 0 : 1.6);
                              allCheck.add(checkbox5 ? 0 : 0.7);
                              allCheck.add(checkbox6 ? 0 : 0.7);
                              allCheck.add(checkbox7 ? 0 : 10.1);
                              allCheck.add(checkbox8 ? 0 : 10.1);
                              allCheck.add(checkbox9 ? 0 : 4.4);
                              allCheck.add(checkbox10 ? 0 : 4.4);
                              allCheck.add(checkbox11 ? 0 : 1.5);
                              allCheck.add(checkbox12 ? 0 : 1.5);

                              print('allcheck : ${allCheck.length}');
                              print('allcheck : ${allCheck}');

                              addRemoveBox('checkbox1', checkbox1);
                              addRemoveBox('checkbox2', checkbox2);
                              addRemoveBox('checkbox3', checkbox3);
                              addRemoveBox('checkbox4', checkbox4);
                              addRemoveBox('checkbox5', checkbox5);
                              addRemoveBox('checkbox6', checkbox6);
                              addRemoveBox('checkbox7', checkbox7);
                              addRemoveBox('checkbox8', checkbox8);
                              addRemoveBox('checkbox9', checkbox9);
                              addRemoveBox('checkbox10', checkbox10);
                              addRemoveBox('checkbox11', checkbox11);
                              addRemoveBox('checkbox12', checkbox12);

                              var count = 0.0;
                              for (var a = 0; a < allCheck.length; a++) {
                                count = count + allCheck[a];
                              }
                              print(count);

                              Map data = {
                                'count': count.toStringAsFixed(1),
                                'wantDiscount': wantDiscountOnWeight,
                                'Data': AllBoxes,
                              };

                              print('data goes to back : ${jsonEncode(data)}');
                              Get.back(result: data);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }

  bool wantDiscountOnWeight = false;
  Widget _slider() {
    return PageIndicatorContainer(
      child: PageView(
        // controller: _controller,
        // pageSnapping: false,

        allowImplicitScrolling: false,
        onPageChanged: (int index) {
          print(index);
        },
        children: [
          Padding(child: _widget(),padding: EdgeInsets.only(bottom: 10),),
          Padding(child: _widget2(),padding: EdgeInsets.only(bottom: 10),),
        ],
      ),
      align: IndicatorAlign.bottom,
      length: 2,
      indicatorSpace: 10.0,
      padding: const EdgeInsets.only(top: 0),
      indicatorColor: black40_color,
      indicatorSelectorColor: primary_color,
      shape: IndicatorShape.circle(size: 12),
    );
  }

  bool checkbox1 = true;
  bool checkbox2 = true;
  bool checkbox3 = true;
  bool checkbox4 = true;
  bool checkbox5 = true;
  bool checkbox6 = true;

  bool checkbox7 = true;
  bool checkbox8 = true;
  bool checkbox9 = true;
  bool checkbox10 = true;
  bool checkbox11 = true;
  bool checkbox12 = true;

  Widget _widget() {
    return Stack(
      children: [
        Center(child: SvgPicture.asset(AppImages.humanBody,color: primary_color)),
        Positioned(
            right:  Get.width/2.5,
            left: 0.0,
            top: 0.0,
            bottom:Get.height/3.1,
            child: checkbox1 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox1 = !checkbox1;
                    checkbox3 = checkbox1;
                    checkbox5 = checkbox1;

                    addRemoveBox('checkbox1', checkbox1);
                    addRemoveBox('checkbox3', checkbox1);
                    addRemoveBox('checkbox5', checkbox1);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox1 = !checkbox1;
                    checkbox3 = checkbox1;
                    checkbox5 = checkbox1;

                    addRemoveBox('checkbox1', checkbox1);
                    addRemoveBox('checkbox3', checkbox1);
                    addRemoveBox('checkbox5', checkbox1);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left:  Get.width/2.5,
            top: 0.0,
            bottom:Get.height/3.1,
            child: checkbox2 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox2 = !checkbox2;
                    checkbox4 = checkbox2;
                    checkbox6 = checkbox2;
                    addRemoveBox('checkbox2', checkbox2);
                    addRemoveBox('checkbox4', checkbox2);
                    addRemoveBox('checkbox6', checkbox2);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox2 = !checkbox2;
                    checkbox4 = checkbox2;
                    checkbox6 = checkbox2;
                    addRemoveBox('checkbox2', checkbox2);
                    addRemoveBox('checkbox4', checkbox2);
                    addRemoveBox('checkbox6', checkbox2);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right:  Get.width/2.1,
            left: 0.0,
            top: 0.0,
            bottom: Get.height/7.3,
            child: checkbox3 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox3 = !checkbox3;
                    addRemoveBox('checkbox3', checkbox3);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox3 = !checkbox3;
                    addRemoveBox('checkbox3', checkbox3);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left:  Get.width/2.1,
            top: 0.0,
            bottom: Get.height/7.3,
            child: checkbox4 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox4 = !checkbox4;
                    addRemoveBox('checkbox4', checkbox4);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox4 = !checkbox4;
                    addRemoveBox('checkbox4', checkbox4);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: Get.width/1.6,
            left: 0.0,
            top: Get.height/22.3,
            bottom: 0.0,
            child: checkbox5 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox5 = !checkbox5;
                    print(checkbox5);
                    // checkbox3 = checkbox5;
                    // checkbox1 = checkbox5;
                    addRemoveBox('checkbox5', checkbox5);
                    // addRemoveBox('checkbox3', checkbox5);
                    // addRemoveBox('checkbox1', checkbox5);
                    // checkbox3 = !checkbox5;
                    // checkbox1 = !checkbox5;
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox5 = !checkbox5;
                    print(checkbox5);
                    // checkbox3 = checkbox5;
                    // checkbox1 = checkbox5;

                    addRemoveBox('checkbox5', checkbox5);
                    // addRemoveBox('checkbox3', checkbox5);
                    // addRemoveBox('checkbox1', checkbox5);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left:  Get.width/1.6,
            top: Get.height/22.3,
            bottom: 0.0,
            child: checkbox6 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox6 = !checkbox6;
                    // checkbox2 = checkbox6;
                    // checkbox4 = checkbox6;

                    addRemoveBox('checkbox6', checkbox6);
                    // addRemoveBox('checkbox2', checkbox6);
                    // addRemoveBox('checkbox4', checkbox6);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox6 = !checkbox6;
                    // checkbox2 = checkbox6;
                    // checkbox4 = checkbox6;

                    addRemoveBox('checkbox6', checkbox6);
                    // addRemoveBox('checkbox2', checkbox6);
                    // addRemoveBox('checkbox4', checkbox6);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 130,
            left: 0.0,
            top:Get.height/5.3,
            bottom: 0.0,
            child: checkbox7 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox7 = !checkbox7;
                    checkbox9 = checkbox7;
                    checkbox11 = checkbox7;
                    addRemoveBox('checkbox7', checkbox7);
                    addRemoveBox('checkbox9', checkbox7);
                    addRemoveBox('checkbox11', checkbox7);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox7 = !checkbox7;
                    checkbox9 = checkbox7;
                    checkbox11 = checkbox7;
                    addRemoveBox('checkbox7', checkbox7);
                    addRemoveBox('checkbox9', checkbox7);
                    addRemoveBox('checkbox11', checkbox7);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left: 130.0,
            top: Get.height/5.3,
            bottom: 0.0,
            child: checkbox8 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox8 = !checkbox8;
                    checkbox10 = checkbox8;
                    checkbox12 = checkbox8;
                    addRemoveBox('checkbox8', checkbox8);
                    addRemoveBox('checkbox10', checkbox8);
                    addRemoveBox('checkbox12', checkbox8);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox8 = !checkbox8;
                    checkbox10 = checkbox8;
                    checkbox12 = checkbox8;
                    addRemoveBox('checkbox8', checkbox8);
                    addRemoveBox('checkbox10', checkbox8);
                    addRemoveBox('checkbox12', checkbox8);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 120,
            left: 0.0,
            top: Get.height/2.8,
            bottom: 0.0,
            child: checkbox9 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox9 = !checkbox9;
                    addRemoveBox('checkbox9', checkbox9);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox9 = !checkbox9;
                    addRemoveBox('checkbox9', checkbox9);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left: 120.0,
            top: Get.height/2.8,
            bottom: 0.0,
            child: checkbox10 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox10 = !checkbox10;
                    addRemoveBox('checkbox10', checkbox10);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox10 = !checkbox10;
                    addRemoveBox('checkbox10', checkbox10);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 100,
            left: 0.0,
            top: Get.height/1.8,
            bottom: 0.0,
            child: checkbox11 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox11 = !checkbox11;
                    // checkbox9 = checkbox11;
                    // checkbox7 = checkbox11;
                    //
                    addRemoveBox('checkbox11', checkbox11);
                    // addRemoveBox('checkbox9', checkbox11);
                    // addRemoveBox('checkbox7', checkbox11);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox11 = !checkbox11;
                    // checkbox9 = checkbox11;
                    // checkbox7 = checkbox11;
                    //
                    //
                    addRemoveBox('checkbox11', checkbox11);
                    // addRemoveBox('checkbox9', checkbox11);
                    // addRemoveBox('checkbox7', checkbox11);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
        Positioned(
            right: 0.0,
            left: 100.0,
            top: Get.height/1.8,
            bottom: 0.0,
            child: checkbox12 == false
                ? GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox12 = !checkbox12;
                    // checkbox10 = checkbox12;
                    // checkbox8 = checkbox12;

                    addRemoveBox('checkbox12', checkbox12);
                    // addRemoveBox('checkbox10', checkbox12);
                    // addRemoveBox('checkbox8', checkbox12);
                  });
                },
                child:
                Icon(Icons.check_box, size: 20.0, color: Colors.green))
                : GestureDetector(
                onTap: () {
                  setState(() {
                    checkbox12 = !checkbox12;
                    // checkbox10 = checkbox12;
                    // checkbox8 = checkbox12;

                    addRemoveBox('checkbox12', checkbox12);
                    // addRemoveBox('checkbox10', checkbox12);
                    // addRemoveBox('checkbox8', checkbox12);
                  });
                },
                child: Icon(
                  Icons.check_box_outline_blank,
                  size: 18.0,
                  color: Colors.black,
                ))),
      ],
    );
  }

  Widget _widget2() {
    return  Center(
      child: SvgPicture.asset(AppImages.HumanBodyWithPer,color: primary_color,),
    );
  }
}
