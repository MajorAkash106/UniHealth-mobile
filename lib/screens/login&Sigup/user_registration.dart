import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/contollers/other_controller/user_registration_controller.dart';
import 'package:medical_app/model/PatientListModel.dart';
import 'package:medical_app/model/hospitalListModel.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class UserRegistration extends StatefulWidget {
  final String title;
  UserRegistration({this.title});
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final UserRegistrationController _controller = UserRegistrationController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity().then((internet) {
      print('internet');
      if (internet != null && internet) {
        _controller.getHospital().then((resp) {
          print('return: $resp');
          _controller.getClientData();
        });
        // _controller.getClientData();
        print('internet avialable');
      }
    });
  }

  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var cpnj = TextEditingController();
  var country = TextEditingController();
  var state = TextEditingController();
  var city = TextEditingController();
  var street = TextEditingController();
  var number = TextEditingController();
  var pass = TextEditingController();
  List hospitals = [];
  List clients = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _multiSelectKey,
        appBar: BaseAppbar('${widget.title}', null),
        body: Obx(
          () => Container(
              child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Expanded(child: Container(child: ListView(
                      children: [
                        Text(
                          "User's Info",
                          style:
                          TextStyle(color: appbar_icon_color, fontSize: 16),
                        ),
                        Card(
                          color: card_color,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  _textfield(
                                      "User's name", name, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // _textfield("Phone", phone,TextInputType.phone),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11),
                                    ],
                                    controller: phone,
                                    decoration: InputDecoration(
                                      labelText: "Phone",
                                      contentPadding: EdgeInsets.all(0.0),
                                    ),
                                    onChanged: (String newValue) {
                                      // _stashItem.width = "$newValue $_widthUnit";
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield(
                                      "Email", email, TextInputType.emailAddress),
                                  SizedBox(
                                    height: 20,
                                  ),

                                  Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: _textfield(
                                              "CPNJ", cpnj, TextInputType.text)),
                                      SizedBox(
                                        width: 40,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: date_of_LED("L.E.D", LED))
                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield(
                                      "Country", country, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield("State", state, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield("City", city, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield(
                                      "Street", street, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _textfield(
                                      "Number", number, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MultiSelectDialogField(
                                    items: _controller.hospitalList
                                        .map((e) =>
                                        MultiSelectItem<HospitalListData>(
                                            e, e.name))
                                        .toList(),
                                    title: Text("Hospitals"),
                                    searchable: true,
                                    selectedColor: primary_color,
                                    onSelectionChanged: (v) {
                                      print('changedd');
                                      FocusScopeNode currentFocus =
                                      FocusScopeNode();
                                      currentFocus.unfocus();
                                      currentFocus.unfocus();
                                    },
                                    buttonIcon: Icon(
                                      Icons.arrow_drop_down,
                                      // color: Colors.blue,
                                    ),
                                    buttonText: Text(
                                      "Select Hospitals",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onConfirm: (results) {
                                      print('result: $results');
                                      hospitals.clear();
                                      hospitals.addAll(results);
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MultiSelectDialogField(
                                    items: _controller.clientList
                                        .map((e) => MultiSelectItem<PatientData>(
                                        e, e.name))
                                        .toList(),
                                    title: Text("Clients"),
                                    searchable: true,
                                    selectedColor: primary_color,
                                    buttonIcon: Icon(
                                      Icons.arrow_drop_down,
                                      // color: Colors.blue,
                                    ),
                                    buttonText: Text(
                                      "Select Clients",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                    onConfirm: (results) {
                                      print('result: $results');
                                      clients.clear();
                                      clients.addAll(results);
                                    },
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),

                                  _textfield(
                                      "Password", pass, TextInputType.text),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                      ],
                    ),),),
                   Container(
                    width: Get.width,
                     child: CustomButton(
                     text: "Confirm",
                     myFunc: onpreesss,
                   ),),
                    SizedBox(
                      height: 10,
                    ),
                  ],)
              )),
        ));
  }

  void onpreesss() {
    _controller.onSaved(name.text, phone.text, email.text, cpnj.text, LED, country.text, state.text, city.text, street.text, number.text, hospitals, clients, pass.text);
  }

  Widget _textfield(
      text, TextEditingController controller, TextInputType _type) {
    return TextFormField(
      keyboardType: _type,
      // inputFormatters: <TextInputFormatter>[
      //   WhitelistingTextInputFormatter.digitsOnly
      // ],

      controller: controller,
      decoration: InputDecoration(
        labelText: "$text",
        contentPadding: EdgeInsets.all(0.0),
      ),
      onChanged: (String newValue) {
        // _stashItem.width = "$newValue $_widthUnit";
      },
    );
  }

  var LED;

  final format = DateFormat("dd-MM-yyyy");
  Widget date_of_LED(text, value) {
    return DateTimeField(
      format: format,
      onChanged: (DateTime newValue) {
        setState(() {
          print(value);
          print(newValue);
          LED = newValue;
        });
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          labelText: "$text",
          suffixIcon: Icon(
            Icons.date_range,
            color: primary_color,
          )
          // icon: Icon(Icons.date_range)
          ),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },
    );
  }
}
