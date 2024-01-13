import 'Data.dart';

class Log_out_model {
    Data data;
    String message;
    bool success;

    Log_out_model({this.data, this.message, this.success});

    factory Log_out_model.fromJson(Map<String, dynamic> json) {
        return Log_out_model(
            data: json['data'] != null ? Data.fromJson(json['data']) : null, 
            message: json['message'], 
            success: json['success'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['message'] = this.message;
        data['success'] = this.success;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}