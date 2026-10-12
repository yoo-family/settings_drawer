import 'package:flutter/material.dart';
import 'package:settings_drawer/settings_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = SettingsController(
    supportedLocales: const [Locale('en'), Locale('ko')],
  );
  await controller.load();
  runApp(ExampleApp(controller: controller));
}

String localeLabel(Locale locale) => switch (locale.languageCode) {
      'ko' => '한국어',
      _ => 'English',
    };

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          title: 'settings_drawer example',
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          darkTheme: ThemeData(
            colorSchemeSeed: Colors.indigo,
            brightness: Brightness.dark,
            useMaterial3: true,
          ),
          themeMode: controller.themeMode,
          home: HomePage(controller: controller),
        );
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('settings_drawer')),
      // The ready-made drawer: header + an app-specific extra item +
      // the theme/language tiles, all in one widget.
      drawer: SettingsDrawer(
        controller: controller,
        localeLabel: localeLabel,
        header: const DrawerHeader(child: Text('My App')),
        extraItems: [
          ListTile(
            leading: const Icon(Icons.open_in_browser_outlined),
            title: const Text('Visit website'),
            onTap: () async {
              Navigator.of(context).pop();
              await launchUrl(
                Uri.parse('https://pub.dev/packages/settings_drawer'),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Open the drawer (top-left) to try the theme and language pickers.'),
            const SizedBox(height: 24),
            // The same tiles, used standalone outside a drawer — e.g. on a
            // dedicated settings screen.
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ThemeModeTile(
                      controller: controller, closeDrawerOnSelect: false),
                  LocaleTile(
                    controller: controller,
                    localeLabel: localeLabel,
                    closeDrawerOnSelect: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
