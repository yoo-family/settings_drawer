# settings_drawer

Theme and language picker tiles for a Flutter app drawer, with persisted
`ThemeMode`/`Locale` state. Composable building blocks first, with an
optional ready-made drawer on top — so it fits into a drawer you already
have instead of demanding you hand over the whole thing.

## Features

- `SettingsController` — holds `themeMode` and `locale`, persists them with
  `shared_preferences`, and notifies listeners. Defaults to "follow the
  system" for both, same as most apps' theme behavior.
- `ThemeModeTile` / `LocaleTile` — self-contained `ListTile`s that show the
  current value as a subtitle and open a picker sheet on tap. Drop them
  into *your own* `Drawer`, next to whatever other menu items you already
  have.
- `showOptionPickerSheet` — the generic bottom-sheet-with-checkmark picker
  the tiles are built on, usable on its own for any list of options.
- `SettingsDrawer` — an optional, ready-made `Drawer` that assembles a
  header, your extra menu items, and both tiles, for when you don't need
  anything more custom.

## Usage

### As building blocks (recommended)

```dart
Drawer(
  child: ListView(
    children: [
      DrawerHeader(child: Text('My App')),
      ListTile(title: const Text('Help'), onTap: openHelp), // your own items
      const Divider(),
      ThemeModeTile(controller: settings),
      LocaleTile(controller: settings, localeLabel: myLocaleLabel),
    ],
  ),
)
```

### As a ready-made drawer

```dart
Scaffold(
  drawer: SettingsDrawer(
    controller: settings,
    localeLabel: myLocaleLabel,
    header: DrawerHeader(child: Text('My App')),
    extraItems: [
      ListTile(title: const Text('Help'), onTap: openHelp),
    ],
  ),
)
```

### Setting up the controller

```dart
final settings = SettingsController(
  supportedLocales: const [Locale('en'), Locale('ko')],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await settings.load(); // reads the saved theme/locale before first frame
  runApp(MyApp(settings: settings));
}
```

Wire `settings.themeMode`/`settings.locale` into your `MaterialApp` as
usual (`themeMode:`, `locale:`), rebuilding on `settings`'s notifications
(e.g. with `AnimatedBuilder` or your state-management tool of choice).

`localeLabel` is a `String Function(Locale)` you provide — language names
are conventionally shown in their own language (endonyms, e.g. "한국어"
even in an English UI) rather than translated, so this package leaves
that mapping to you instead of hard-coding it.

Run the bundled `example/` to see both usage styles side by side.

## Additional information

Issues and pull requests are welcome on the
[GitHub repository](https://github.com/yoo-family/settings_drawer).
