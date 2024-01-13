import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';
import 'package:medical_app/config/cons/colors.dart';
import 'package:medical_app/config/widgets/buttons.dart';
import 'package:medical_app/config/widgets/textfields.dart';
import 'package:medical_app/contollers/other_controller/change_pass_controller.dart';
import 'package:medical_app/config/widgets/unihealth_button.dart';


class Change_Password extends StatefulWidget {
  @override
  _Change_PasswordState createState() => _Change_PasswordState();
}

class _Change_PasswordState extends State<Change_Password> {
  final ChangePasswordController _controller = Get.put(ChangePasswordController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('change_password'.tr),centerTitle: true,),
    bottomNavigationBar: CommonHomeButton(),
    resizeToAvoidBottomInset: false,
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 30.0,),
        Row(children: [SizedBox(width: 20.0,),
        Text('enter_old_password'.tr,style: TextStyle(fontWeight: FontWeight.bold),)
        ],),

        Padding(
          padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
          child: Container(
            child: CustomTextField('password'.tr, _controller.oldPassword, TextInputType.emailAddress, false,
                Icon(Icons.security), Icon(null), null),
          ),
        ),

          SizedBox(height: 30.0,),

          //Container(height: 50.0,width: 200.0,color: Colors.red,),
          Row(children: [SizedBox(width: 20.0,),
          Text('${'enter_new_password'.tr} & ${'confirm'.tr}',style: TextStyle(fontWeight: FontWeight.bold),),

          ],),

          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
            child: Container(
              // width: 200.0,height: 50.0,
              //color: Colors.red,
                child:CustomTextField('enter_new_password'.tr,_controller.newPassword, TextInputType.emailAddress, false,
                    Icon(Icons.security), Icon(null), null),
                // TextField(
                //   decoration: InputDecoration(hintText: 'New Password'),
                // )
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 10.0),
            child: Container(
              // width: 200.0,height: 50.0,
              //color: Colors.red,
                child:
                CustomTextField('confirm'.tr, _controller.confirmPassword, TextInputType.emailAddress, false,
                    Icon(Icons.security), Icon(null), null),
                // TextField(
                //   decoration: InputDecoration(hintText: 'Confirm'),
                // )
            ),
          ),
          SizedBox(height: 50.0,),
          Row(children: [Expanded(
            child: RaisedButton(
                child: Container(width: MediaQuery.of(context).size.width,height: 50.0,
                  child: Center(child: Text('confirm'.tr,style: TextStyle(color: Colors.white),),),),
                color: primary_color,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                onPressed: (){
                  checkConnectivity().then((internet){
                    print('internet');
                    if(internet!=null && internet){
                      _controller.apiCall();
                      print('internet avialable');
                    }
                  });
                }

            ),
          )

          ],),



        ],),
    ),
    );
  }
}
