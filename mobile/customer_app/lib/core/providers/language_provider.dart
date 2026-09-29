import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _languageKey = 'selected_language';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden in main');
});

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(_languageKey);
    
    if (code != null) {
      return Locale(code);
    }
    
    // Default fallback to English if not set
    return const Locale('en');
  }

  Future<void> setLocale(String languageCode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_languageKey, languageCode);
    state = Locale(languageCode);
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});
