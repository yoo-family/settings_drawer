import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings_drawer/settings_drawer.dart';

import 'package:settings_drawer_example/main.dart';

void main() {
  testWidgets('opens the drawer and shows the settings section',
      (tester) async {
    final controller = SettingsController(
      supportedLocales: const [Locale('en'), Locale('ko')],
    );
    await tester.pumpWidget(ExampleApp(controller: controller));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('My App'), findsOneWidget);
    expect(find.text('Visit website'), findsOneWidget);
    expect(find.text('Theme'), findsWidgets);
    expect(find.text('Language'), findsWidgets);
  });
}
