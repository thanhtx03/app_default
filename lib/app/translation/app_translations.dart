import 'package:app_default/app/translation/ja.dart';
import 'package:app_default/app/translation/ko.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_default/app/translation/ar.dart';
import 'package:app_default/app/translation/de.dart';
import 'package:app_default/app/translation/en_us.dart';
import 'package:app_default/app/translation/es.dart';
import 'package:app_default/app/translation/fr.dart';
import 'package:app_default/app/translation/hi.dart';
import 'package:app_default/app/translation/id.dart';
import 'package:app_default/app/translation/pt.dart';


class AppTranslations extends Translations {
  static const fallbackLocale = Locale('en', 'US');
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('pt', 'PT'),
    Locale('hi', 'IN'),
    Locale('de', 'DE'),
    Locale('fr', 'FR'),
    Locale('id', 'ID'),
    Locale('ar', 'SA'),
    Locale('ja', 'JP'),
    Locale('ko', 'KR'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        // English
        'en': enUS,
        'en_US': enUS,
        'en_GB': enUS,
        'en_IN': enUS,

        // Spanish
        'es': es,
        'es_ES': es,
        'es_MX': es,

        // Portuguese
        'pt': pt,
        'pt_PT': pt,
        'pt_EU': pt,
        'pt_BR': pt,

        // Hindi
        'hi': hi,
        'hi_IN': hi,

        // German
        'de': de,
        'de_DE': de,

        // French
        'fr': fr,
        'fr_FR': fr,

        // Indonesian
        'id': id,
        'id_ID': id,

        // Arabic
        'ar': ar,
        'ar_SA': ar,

        // Japanese
        'ja': ja,
        'ja_JP': ja,

        // Korean
        'ko': ko,
        'ko_KR': ko,
      };
}
