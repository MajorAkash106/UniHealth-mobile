import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/state_manager.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/widgets/common_appbar.dart';
import 'package:medical_app/config/widgets/reference_screen.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';

class INFUSIONP extends StatefulWidget {
  @override
  _INFUSIONPState createState() => _INFUSIONPState();
}

class _INFUSIONPState extends State<INFUSIONP> {
  List<Infusion> _infusion = [
    Infusion(false, "No Register Of Infusion"),
    Infusion(false, "Infusion Error"),
    Infusion(false, "Medical Order"),
    Infusion(false, "CATHETER LINE DISCONNECTION"),
    Infusion(false, "HYPERTRIGLYCERIDEMIA"),
    Infusion(false, "HEMODYNAMIC INSTABILITY"),
    Infusion(false, "FEVER"),
    Infusion(false, "CATHETER RELATED INFECTION"),
    Infusion(false, "FASTING (MISCONDUCT)"),
    Infusion(false, "PATIENT REFUSED"),
    Infusion(false, "LOSS OF VENOUS CATHETER"),
    Infusion(false, "HYPERGLYCEMIA"),
    Infusion(false, "INSTABILITY (HIGH LEVELS OF VASOPRESSORS, AND OTHERS)"),
    Infusion(false, "PROCEDURES"),
    Infusion(false, "OTHER"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar("INFUSION", null),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Justificative for reduced infusion last 24h',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _infusion.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 12.0, bottom: 12.0, right: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              child: Card(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: _infusion[index].selected
                                                ? Colors.green
                                                : Colors.black.withAlpha(100)),
                                        borderRadius:
                                        BorderRadius.circular(5.0)),
                                    child: _infusion[index].selected
                                        ? Icon(Icons.check,
                                        size: 20.0, color: Colors.green)
                                        : Icon(
                                      Icons.check,
                                      size: 18.0,
                                      color: Colors.transparent,
                                    )),
                                elevation: 4.0,
                              ),
                              onTap: () {
                                setState(() {
                                  for (var a in _infusion) {
                                    if (a.Agreement_desc !=
                                        _infusion[index].Agreement_desc) {
                                      a.selected = false;
                                    }
                                  }

                                  _infusion[index].selected =
                                  !_infusion[index].selected;
                                });
                              },
                            ),
                            // SizedBox(height:15.0,)
                          ],
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    _infusion[index]
                                        .Agreement_desc
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black54,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
          //Spacer(),
          // SizedBox(
          //   height: 30.0,
          // ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25.0, top: 10, bottom: 20),
            child: Container(
              height: 50.0,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                color: primary_color,
                child: Center(
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Infusion {
  String Agreement_desc;
  bool selected;
  Infusion(this.selected, this.Agreement_desc);
}
