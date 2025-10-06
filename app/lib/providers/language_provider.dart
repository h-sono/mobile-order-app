import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('ja')); // Default to Japanese

  void setLanguage(String languageCode) {
    state = Locale(languageCode);
  }

  void toggleLanguage() {
    if (state.languageCode == 'ja') {
      state = const Locale('en');
    } else {
      state = const Locale('ja');
    }
  }
}