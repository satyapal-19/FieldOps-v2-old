import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  static const String _storageKey = 'selected_locale_code';

  // Supported Locales
  static const List<Map<String, dynamic>> supportedLocales = [
    {
      'code': 'mr',
      'country': 'IN',
      'name': 'मराठी',
      'subname': 'Marathi',
      'locale': Locale('mr', 'IN'),
    },
    {
      'code': 'hi',
      'country': 'IN',
      'name': 'हिंदी',
      'subname': 'Hindi',
      'locale': Locale('hi', 'IN'),
    },
    {
      'code': 'en',
      'country': 'IN',
      'name': 'English',
      'subname': 'English',
      'locale': Locale('en', 'IN'),
    },
    {
      'code': 'kn',
      'country': 'IN',
      'name': 'ಕನ್ನಡ',
      'subname': 'Kannada',
      'locale': Locale('kn', 'IN'),
    },
  ];

  final Rx<Locale> currentLocale = const Locale('mr', 'IN').obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_storageKey);
      if (code != null) {
        final match = supportedLocales.firstWhere(
          (element) => element['code'] == code,
          orElse: () => supportedLocales.first,
        );
        currentLocale.value = match['locale'] as Locale;
        Get.updateLocale(currentLocale.value);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }
  }

  Future<void> changeLocale(String langCode, [String countryCode = 'IN']) async {
    final newLocale = Locale(langCode, countryCode);
    currentLocale.value = newLocale;
    await Get.updateLocale(newLocale);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, langCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }

  String get currentLanguageName {
    final match = supportedLocales.firstWhere(
      (element) => element['code'] == currentLocale.value.languageCode,
      orElse: () => supportedLocales.first,
    );
    return match['name'] as String;
  }
}
