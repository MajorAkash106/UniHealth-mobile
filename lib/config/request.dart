import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:medical_app/config/cons/APIs.dart';
import 'package:medical_app/config/funcs/CheckConnectivity.dart';

class Request {
  final String url;
  final dynamic body;

  Request({this.url, this.body});


  Future<http.Response> post() {
    // checkConnectivity().then((internet){
    //   if (internet != null && internet) {
    //     print('internet avialable');
    //     return http.post(url, body: body).timeout(Duration(minutes: 2));
    //
    //   }
    // });
    return http.post(Uri.parse(url), body: body).timeout(Duration(minutes: 2));

  }


  Future<http.Response> get() {
    return http.get(Uri.parse(url)).timeout(Duration(minutes: 2));
  }


  Future<Response>postWithDio()async{

    var dio = Dio();
    final  response = await dio.post(
      this.url,
      data: body,
      onSendProgress: (int sent, int total) {
        print("progess---$sent $total");
      },

    );
    return response;

  }

}