import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/Snackbars.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/cons/images.dart';
import 'package:medical_app/config/funcs/offline_func.dart';
import 'package:medical_app/config/widgets/initial_loader.dart';
import 'package:medical_app/contollers/sqflite/database/offline_handler.dart';
import 'package:medical_app/contollers/sqflite/database/patient_offline.dart';
import 'package:medical_app/model/patientDetailsModel.dart';
import 'package:medical_app/screens/home/home_screen.dart';

class CustomButton extends StatelessWidget {
  final Function myFunc;
  final String text;

  CustomButton({this.myFunc, this.text});

  @override
  Widget build(BuildContext context) {
    // return RaisedButton(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10.0),
    //   ),
    //   padding: EdgeInsets.all(15.0),
    //   onPressed: myFunc,
    //   color: primary_color,
    //   textColor: Colors.white,
    //   child: Text("$text", style: TextStyle(fontSize: 14)),
    // );
    return ElevatedButton(
      child: Text("$text", style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis,),
      onPressed: myFunc,
      style: ElevatedButton.styleFrom(
        backgroundColor: primary_color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: EdgeInsets.all(15.0),
      ),
    );
  }
}

class CommonHomeButton extends StatefulWidget {
  @override
  _CommonHomeButtonState createState() => _CommonHomeButtonState();
}

class _CommonHomeButtonState extends State<CommonHomeButton> {
  SaveDataSqflite sqlite = SaveDataSqflite();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(10.0),
        backgroundColor: primary_color,
        textStyle: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Get.to(HomeScreen());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          blackWidget(),
          Icon(
            Icons.home,
            size: 32,
          ),
          FutureBuilder(
              initialData: null,
              future: sqlite.allOfflineData(),
              builder: (context, AsyncSnapshot snapshot) {
                List<PatientDetailsData> allData = snapshot?.data;

                if (snapshot.data == null) {
                  return SizedBox();
                }
                return allData.isNullOrBlank
                    ? blackWidget()
                    : InkWell(
                        onTap: () {
                          askToSendData('').then((value) {
                            print('close popup with $value');
                            if (value == "YES") {
                              checkConnectivity().then((internet) {
                                if (internet != null && internet) {
                                  OfflineHandler _offlinehandler =
                                      OfflineHandler();
                                  showLoader();
                                  _offlinehandler.DataToServerMultiple(allData)
                                      .then((value) {
                                    print('return res: $value');
                                    // ShowMsg('Your offline data sink successfully.');
                                    if (value == 'success') {
                                      sqlite.clearPatientIds().then((r) {
                                        Get.back();
                                        ShowMsg(
                                            'data_sink_successfully'.tr);
                                        setState(() {});
                                      });
                                    }
                                  });
                                }
                              });
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              AppImages.redCloud,
                              height: 25,
                            ),
                            Positioned(
                                right: 0.0,
                                left: 25.0,
                                top: 0.0,
                                bottom: 15.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Center(
                                    child: Text(
                                      "${allData.length}",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ),
                                  radius: 15,
                                ))
                          ],
                        ));
              }),
        ],
      ),
    );
  }

  Widget blackWidget() {
    return Stack(
      children: [
        SvgPicture.asset(
          AppImages.redCloud,
          height: 25,
          color: primary_color,
        ),
        Positioned(
            right: 0.0,
            left: 25.0,
            top: 0.0,
            bottom: 15.0,
            child: CircleAvatar(
              backgroundColor: primary_color,
              child: Center(
                child: Text(
                  "",
                  style: TextStyle(fontSize: 10, color: primary_color),
                ),
              ),
              radius: 15,
            ))
      ],
    );
  }
}
