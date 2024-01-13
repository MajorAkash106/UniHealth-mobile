import 'package:flutter/material.dart';

class Languages {
  static const String ENGLISH = 'en';
  static const String PORTUGUESE = 'pt';
  static const String ARABIC = 'ar';



  Locale locale(String languageCode) {
    Locale _temp;
    switch (languageCode) {
      case ENGLISH:
        _temp = Locale(languageCode, 'US');
        break;
      case PORTUGUESE:
        _temp = Locale(languageCode, 'BR');
        break;
      case ARABIC:
        _temp = Locale(languageCode, 'SA');
        break;
      default:
        _temp = Locale(ENGLISH, 'US');
    }
    return _temp;
  }


  Locale currentLan(String languageCode) {
    Locale _temp;

    switch (languageCode) {
      case ENGLISH:
        _temp = Locale(languageCode, 'US');
        break;
      case PORTUGUESE:
        _temp = Locale(languageCode, 'BR');
        break;
      case ARABIC:
        _temp = Locale(languageCode, 'SA');
        break;
      default:
        _temp = Locale(ENGLISH, 'US');
    }
    return _temp;
  }
}
