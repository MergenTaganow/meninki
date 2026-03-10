import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DynamicLocalization {
  static String? arbContent;
  static Map<String, dynamic>? localizedMap = {};

  static init(Locale? locale) async {
    var filePath = 'lib/l10n/app_${locale?.languageCode ?? 'en'}.arb';
    arbContent = await rootBundle.loadString(filePath);
    localizedMap = jsonDecode(arbContent!) as Map<String, dynamic>;
  }

  static String translate(String key) {
    return localizedMap?[key] ?? key;
  }
}
