import 'package:flutter/material.dart';

import 'option_picker_sheet.dart';
import 'settings_controller.dart';

/// A [ListTile] that shows the current language as its subtitle and opens
/// a [showOptionPickerSheet] ("use system language" plus
/// [SettingsController.supportedLocales]) when tapped.
///
/// Rebuilds itself whenever [controller] changes, so it always reflects
/// the latest value without the parent needing to wrap it in a listener.
class LocaleTile extends StatelessWidget {
  const LocaleTile({
    super.key,
    required this.controller,
    required this.localeLabel,
    this.icon = Icons.language,
    this.iconColor,
    this.title = 'Language',
    this.systemLabel = 'Use system language',
    this.closeDrawerOnSelect = true,
  });

  /// The controller this tile reads from and updates.
  final SettingsController controller;

  /// Maps a locale to its display label, e.g. `(locale) => locale.languageCode
  /// == 'ko' ? '한국어' : 'English'`. Language names are conventionally shown
  /// in their own language (endonyms) regardless of the current UI
  /// language, so this is left to the caller rather than hard-coded.
  final String Function(Locale locale) localeLabel;

  /// Leading icon. Pass `null` to omit it.
  final IconData? icon;

  /// Tint for [icon].
  final Color? iconColor;

  /// Row title, and the bottom sheet's heading.
  final String title;

  /// Label for the "follow the system language" option.
  final String systemLabel;

  /// Whether picking a value also closes the enclosing [Drawer], if any
  /// (via `Scaffold.maybeOf(context)?.closeDrawer()` — a no-op outside a
  /// drawer, so this is safe to leave on even when reusing the tile in a
  /// plain settings screen).
  final bool closeDrawerOnSelect;

  String _currentLabel() {
    final locale = controller.locale;
    return locale == null ? systemLabel : localeLabel(locale);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListTile(
          leading: icon == null ? null : Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: Text(_currentLabel()),
          onTap: () async {
            final picked = await showOptionPickerSheet<Locale?>(
              context: context,
              title: title,
              currentValue: controller.locale,
              options: [
                SettingsOption(value: null, label: systemLabel),
                for (final locale in controller.supportedLocales)
                  SettingsOption(value: locale, label: localeLabel(locale)),
              ],
            );
            // `picked` (the SettingsOption) is only null when the sheet was
            // dismissed without a choice — `picked.value` being null is a
            // separate, valid case ("use system language"), so this check
            // alone doesn't swallow that choice.
            if (picked == null) return;
            await controller.setLocale(picked.value);
            if (closeDrawerOnSelect && context.mounted) {
              Scaffold.maybeOf(context)?.closeDrawer();
            }
          },
        );
      },
    );
  }
}
