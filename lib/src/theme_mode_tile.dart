import 'package:flutter/material.dart';

import 'option_picker_sheet.dart';
import 'settings_controller.dart';

/// A [ListTile] that shows the current [ThemeMode] as its subtitle and
/// opens a [showOptionPickerSheet] (system / light / dark) when tapped.
///
/// Rebuilds itself whenever [controller] changes, so it always reflects
/// the latest value without the parent needing to wrap it in a listener.
class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({
    super.key,
    required this.controller,
    this.icon = Icons.brightness_6_outlined,
    this.iconColor,
    this.title = 'Theme',
    this.systemLabel = 'Use system setting',
    this.lightLabel = 'Light',
    this.darkLabel = 'Dark',
    this.closeDrawerOnSelect = true,
  });

  /// The controller this tile reads from and updates.
  final SettingsController controller;

  /// Leading icon. Pass `null` to omit it.
  final IconData? icon;

  /// Tint for [icon].
  final Color? iconColor;

  /// Row title, and the bottom sheet's heading.
  final String title;

  /// Label for the "follow the system setting" option.
  final String systemLabel;

  /// Label for [ThemeMode.light].
  final String lightLabel;

  /// Label for [ThemeMode.dark].
  final String darkLabel;

  /// Whether picking a value also closes the enclosing [Drawer], if any
  /// (via `Scaffold.maybeOf(context)?.closeDrawer()` — a no-op outside a
  /// drawer, so this is safe to leave on even when reusing the tile in a
  /// plain settings screen).
  final bool closeDrawerOnSelect;

  String _labelFor(ThemeMode mode) => switch (mode) {
        ThemeMode.system => systemLabel,
        ThemeMode.light => lightLabel,
        ThemeMode.dark => darkLabel,
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ListTile(
          leading: icon == null ? null : Icon(icon, color: iconColor),
          title: Text(title),
          subtitle: Text(_labelFor(controller.themeMode)),
          onTap: () async {
            final picked = await showOptionPickerSheet<ThemeMode>(
              context: context,
              title: title,
              currentValue: controller.themeMode,
              options: [
                SettingsOption(value: ThemeMode.system, label: systemLabel),
                SettingsOption(value: ThemeMode.light, label: lightLabel),
                SettingsOption(value: ThemeMode.dark, label: darkLabel),
              ],
            );
            if (picked == null) return;
            await controller.setThemeMode(picked.value);
            if (closeDrawerOnSelect && context.mounted) {
              Scaffold.maybeOf(context)?.closeDrawer();
            }
          },
        );
      },
    );
  }
}
