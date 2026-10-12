import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_drawer/settings_drawer.dart';

String _localeLabel(Locale locale) => switch (locale.languageCode) {
      'ko' => '한국어',
      _ => 'English',
    };

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('SettingsController', () {
    test('defaults to system theme mode and system locale', () {
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      expect(controller.themeMode, ThemeMode.system);
      expect(controller.locale, isNull);
    });

    test('persists and reloads theme mode and locale', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await controller.load();

      await controller.setThemeMode(ThemeMode.dark);
      await controller.setLocale(const Locale('ko'));

      final reloaded = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await reloaded.load();

      expect(reloaded.themeMode, ThemeMode.dark);
      expect(reloaded.locale, const Locale('ko'));
    });

    test('setLocale(null) persists as "use system language"', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await controller.load();
      await controller.setLocale(const Locale('ko'));
      await controller.setLocale(null);

      final reloaded = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await reloaded.load();
      expect(reloaded.locale, isNull);
    });
  });

  group('ThemeModeTile', () {
    testWidgets('picking an option updates the controller and the subtitle',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController();
      await controller.load();

      await tester.pumpWidget(_wrap(ThemeModeTile(controller: controller)));
      expect(find.text('Use system setting'), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      expect(controller.themeMode, ThemeMode.dark);
      expect(find.text('Dark'), findsOneWidget);
    });
  });

  group('LocaleTile', () {
    testWidgets('picking "use system language" actually sets locale to null',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await controller.load();
      await controller.setLocale(const Locale('ko'));

      await tester.pumpWidget(
        _wrap(LocaleTile(controller: controller, localeLabel: _localeLabel)),
      );
      expect(find.text('한국어'), findsOneWidget);

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Use system language'));
      await tester.pumpAndSettle();

      expect(controller.locale, isNull);
      expect(find.text('Use system language'), findsOneWidget);
    });

    testWidgets(
        'dismissing the sheet without a choice leaves the locale untouched',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await controller.load();
      await controller.setLocale(const Locale('ko'));

      await tester.pumpWidget(
        _wrap(LocaleTile(controller: controller, localeLabel: _localeLabel)),
      );
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Tap the scrim above the sheet to dismiss it without picking anything.
      await tester.tapAt(const Offset(200, 50));
      await tester.pumpAndSettle();

      expect(controller.locale, const Locale('ko'));
      expect(find.text('한국어'), findsOneWidget);
    });
  });

  group('SettingsDrawer', () {
    testWidgets('renders header, extra items, and both tiles', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final controller = SettingsController(
          supportedLocales: const [Locale('en'), Locale('ko')]);
      await controller.load();

      await tester.pumpWidget(
        _wrap(
          SettingsDrawer(
            controller: controller,
            localeLabel: _localeLabel,
            header: const Text('My App'),
            extraItems: const [ListTile(title: Text('Open website'))],
          ),
        ),
      );

      expect(find.text('My App'), findsOneWidget);
      expect(find.text('Open website'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
    });
  });
}
