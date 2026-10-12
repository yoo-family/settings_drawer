import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds [themeMode] and [locale], persists them to on-device storage, and
/// notifies listeners (e.g. a [ChangeNotifierProvider] or `AnimatedBuilder`)
/// whenever either changes.
///
/// A `null` [locale] means "follow the system language" — the same policy
/// [themeMode] follows via [ThemeMode.system], which is the default for
/// both until the user picks something else.
class SettingsController extends ChangeNotifier {
  SettingsController({
    this.supportedLocales = const [],
    String themeModeKey = 'settings_drawer.themeMode',
    String localeKey = 'settings_drawer.locale',
  })  : _themeModeKey = themeModeKey,
        _localeKey = localeKey;

  /// Locales offered by [LocaleTile] in addition to "use system language".
  final List<Locale> supportedLocales;

  final String _themeModeKey;
  final String _localeKey;

  ThemeMode _themeMode = ThemeMode.system;

  /// The current theme mode. Defaults to [ThemeMode.system] until the user
  /// picks a value and it's loaded from storage by [load].
  ThemeMode get themeMode => _themeMode;

  Locale? _locale;

  /// The current locale, or `null` to follow the system language. Defaults
  /// to `null` until the user picks a value and it's loaded from storage by
  /// [load].
  Locale? get locale => _locale;

  /// Reads a previously-saved theme mode and locale from on-device storage.
  /// Call this once (e.g. in `main()`, before `runApp`) and await it so the
  /// first frame already reflects the user's saved preference.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = switch (prefs.getString(_themeModeKey)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final code = prefs.getString(_localeKey);
    _locale = code == null
        ? null
        : supportedLocales.where((l) => l.languageCode == code).firstOrNull;
    notifyListeners();
  }

  /// Updates [themeMode] and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themeModeKey,
        switch (mode) {
          ThemeMode.light => 'light',
          ThemeMode.dark => 'dark',
          ThemeMode.system => 'system',
        });
  }

  /// Updates [locale] and persists it. Pass `null` for "use system
  /// language".
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
