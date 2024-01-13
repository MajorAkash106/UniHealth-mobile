import 'package:get/get.dart';
import 'package:medical_app/config/Locale/strings/en.dart';
import 'package:medical_app/config/Locale/strings/pt.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'pt': ptBR,
        'en_US': enUS,
        // 'ar': {
        //   'greeting': '---',
        // },
      };
}
