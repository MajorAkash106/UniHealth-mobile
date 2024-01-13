import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/contollers/register_controller/state_cityController.dart';
import 'package:medical_app/model/state_cities_model.dart';
import 'package:medical_app/model/user_registration/state_cityModel.dart';

class SelectScreen extends StatefulWidget {
 final String UserId;
 final String attributeId;
 final String imagePath;
 SelectScreen({this.UserId,this.attributeId,this.imagePath});

  @override
  _SelectScreenState createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  String dropdownValue = 'One';
  State_cityController state_cityController = State_cityController();

  String _value;
  String _City_value;
  List<Cities> cities = [];
  List<Cities> cities1 = [];
  var currencies = [
    "Food",
    "Transport",
    "Personal",
    "Shopping",
    "Medical",
  ];

  String _currentSelectedValue = "ww";
  @override
  void initState() {
    state_cityController.GetState_City().then((value) {
      setState(() {});
    });
    super.initState();
    _currentSelectedValue = currencies[0];

    getHospital();
  }


  getHospital(){
    Future.delayed(const Duration(milliseconds: 100), () {
      state_cityController.getHospitalsData().then((value){
        setState(() {

        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness:
            Brightness.dark //or set color with: Color(0xFF0000FF)
        ));
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            _headingText(),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "State",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      // dropDown(50,'state')
                      dropdwon(state_cityController.state_list, _value,
                          (value) {
                        setState(() {
                          _value = value;
                          print(_value);
                          _City_value = null;
                          cities.clear();
                          cities.addAll(state_cityController
                              .state_cityModel.cities
                              .where((element) => element.sTATE == _value));
                        });
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "City",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),

                      // dropDown(60,'city')
                      dropdwon_city(
                          cities.length == 0 ? cities1 : cities, _City_value,
                          (value) {
                        setState(() {
                          _City_value = value;
                          print(_City_value);
                          //   cities.addAll(state_cityController.state_cityModel.cities.where((element) => element.sTATE==_value));
                        });
                      })
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hospital",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      dropDown(20, 'Hospital')
                    ],
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  _subText(),
                  SizedBox(
                    height: 60,
                  ),
                  _clickTextContainer(),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  _nextButton(),
                  SizedBox(
                    height: 10.0,
                  ),
                  // _backButton(),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _headingText() {
    return Center(
      child: Text(
        "Select the hospital you are working",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
      ),
    );
  }

  _clickTextContainer() {
    return InkWell(
      child: Container(
        width: Get.width,
        padding: EdgeInsets.only(left: 40, right: 50, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: Colors.lightGreen, borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Click here to contact us on",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              "WhatsApp",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        state_cityController.GetState_City().then((value) {
          print('ddddd');
        });
      },
    );
  }

  _nextButton() {
    return Container(
        width: Get.width,
        child: CustomButton(
          text: "Next",
          myFunc: () {
           if(!_value.isNullOrBlank && !_City_value.isNullOrBlank && !selectedHosp.isNullOrBlank) {
              print(selectedHosp);

              var hospdata = state_cityController.allHospitals.firstWhere(
                  (element) => element.sId == selectedHosp,
                  orElse: () => null);

              Map data = {"_id": hospdata.sId, "name": hospdata.name};

              print(jsonEncode(data));
              state_cityController.addRequest(widget.UserId, widget.attributeId,
                  widget.imagePath, _value, _City_value, data);
            }else{
             ShowMsg('All fields are mandatory.');
           }
          },
        ));
  }

  _backButton() {
    return Container(
        width: Get.width,
        child: CustomButton(
            text: "Back",
            myFunc: () {
              Get.back();
            }));
  }

  _subText() {
    return Text(
      "If your hospital is not listed,don't worry we will make it availaible it in 24h (business day).",
      style: TextStyle(color: Colors.black, fontSize: 16),
    );
  }


  String selectedHosp;
  Widget dropDown(
    double rightPadding,
    String hintname,
  ) {
    return Expanded(
      child: Container(
        width: 200,
        margin: EdgeInsets.only(top: 10, left: rightPadding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
                decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 13.0),
                    hintText: hintname,
                    border: InputBorder.none),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down,size: 22,),
                    value: selectedHosp,hint: Text('Hospitals'),
                    isDense: true,
                    onChanged: (String newValue) {
                      setState(() {
                        selectedHosp = newValue;
                      });
                    },
                    items: state_cityController.allHospitals.map((e) {
                      return DropdownMenuItem<String>(
                        value: e.sId,
                        child: Text(e.name,style: TextStyle(fontSize: 13.0),),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget dropdwon(List data, String selected, Function _func) {
    return Expanded(
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(
              //   width: 1,
              // )
            ),
            //height: 40.0,
            width: MediaQuery.of(context).size.width,
            child:
                //Container(child: Center(child: _value==0?,),),
                Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,size: 22,),
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                    iconEnabledColor: Colors.black,
                    // isExpanded: true,
                    iconSize: 30.0,
                    dropdownColor: Colors.white,
                    hint: Text('States'),
                    value: selected,
                    items: data
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text('${e.rO}'),
                            value: '${e.rO}',
                          ),
                        )
                        .toList(),
                    onChanged: _func
                    //     (value) {
                    //
                    //   setState(() {
                    //     selected = value;
                    //     print(selected);
                    //
                    //
                    //   });
                    // }

                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdwon_city(List data, String selected, Function _func) {
    return Expanded(
      child: Container(
        width: 200,
        child: Padding(
          padding: const EdgeInsets.only(left: 62.0),
          child: Container(
            decoration: BoxDecoration(
              // color: Colors.white,
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10.0),
              // border: Border.all(
              //   width: 1,
              // )
            ),
            //height: 40.0,
            width: MediaQuery.of(context).size.width,
            child:
                //Container(child: Center(child: _value==0?,),),
                Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    icon: Icon(Icons.keyboard_arrow_down,size: 22,),
                    style: TextStyle(color: Colors.black, fontSize: 13.0),
                    iconEnabledColor: Colors.black,
                    // isExpanded: true,
                    iconSize: 30.0,
                    dropdownColor: Colors.white,
                    hint: Text('Cities'),
                    value: selected,
                    items: data
                        .map(
                          (e) => DropdownMenuItem(
                            child: Text('${e.cITY}'),
                            value: '${e.cITY}',
                          ),
                        )
                        .toList(),
                    onChanged: _func
                    //     (value) {
                    //
                    //   setState(() {
                    //     selected = value;
                    //     print(selected);
                    //
                    //
                    //   });
                    // }

                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
