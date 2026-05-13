import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class TranslationHelper {
  static Map<String, Map<String, dynamic>> _translations = {};
  static String? _lastLocale;

  static Future<void> load(String locale) async {
    if (_lastLocale == locale && _translations.containsKey(locale)) return;
    
    try {
      final String response = await rootBundle
          .loadString('assets/l10n/tests_$locale.json')
          .timeout(const Duration(seconds: 5));
      final data = json.decode(response);
      _translations[locale] = data;
      _lastLocale = locale;
    } catch (e) {
      debugPrint('Error loading translations for $locale: $e');
    }
  }

  static String translateCategory(BuildContext context, String categoryName) {
    final locale = Localizations.localeOf(context).languageCode;
    final data = _translations[locale];
    
    if (data != null && data['categories'] != null) {
      return data['categories'][categoryName] ?? categoryName;
    }
    return categoryName;
  }

  static String translateTest(BuildContext context, String testName) {
    final locale = Localizations.localeOf(context).languageCode;
    final data = _translations[locale];
    
    if (data != null && data['tests'] != null) {
      return data['tests'][testName] ?? testName;
    }
    return testName;
  }
}
