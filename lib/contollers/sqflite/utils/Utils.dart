import 'package:flutter/material.dart';
import 'package:medical_app/config/Snackbars.dart';


final String tableUser = 'user';
final String columnId = '_id';
final String columnName = 'name';
final String columnPhone = 'phone';
final String columnEmail = 'email';

showtoast(String string) {
 ShowMsg(string);
}

showProgress() {
  return CircularProgressIndicator();
}



Future<String>DATADOESNOTEXIST(){
  String msg = "Data does't exist in Offline Storage, please try again with internet connection at least once!";
  ShowMsg(msg);

}



