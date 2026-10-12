import 'package:flutter/material.dart';

import 'locale_tile.dart';
import 'settings_controller.dart';
import 'theme_mode_tile.dart';

/// A ready-made [Drawer] that assembles an optional [header], any
/// [extraItems] you want above the settings section, and a theme +
/// language picker pair.
///
/// This is a convenience on top of [ThemeModeTile]/[LocaleTile] — if your
/// drawer needs a different shape (section order, grouping, extra
/// sections), build it directly from those tiles instead of this widget.
class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({
    super.key,
    required this.controller,
    required this.localeLabel,
    this.header,
    this.extraItems = const [],
    this.sectionLabel = 'Settings',
    this.themeModeTile,
    this.localeTile,
  });

  /// The controller the theme/language tiles read from and update.
  final SettingsController controller;

  /// Forwarded to the default [LocaleTile] — see
  /// [LocaleTile.localeLabel]. Unused if you supply your own [localeTile].
  final String Function(Locale locale) localeLabel;

  /// An optional widget shown above [extraItems] — typically a
  /// `DrawerHeader` with your app's logo/name.
  final Widget? header;

  /// Extra menu items (e.g. app-specific actions) shown between [header]
  /// and the settings section.
  final List<Widget> extraItems;

  /// Heading shown above the theme/language tiles.
  final String sectionLabel;

  /// Override the default [ThemeModeTile] (e.g. to customize its icon or
  /// labels) instead of accepting the one this widget builds.
  final ThemeModeTile? themeModeTile;

  /// Override the default [LocaleTile] (e.g. to customize its icon or
  /// labels) instead of accepting the one this widget builds.
  final LocaleTile? localeTile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            if (header != null) header!,
            ...extraItems,
            if (extraItems.isNotEmpty) const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                sectionLabel,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            themeModeTile ?? ThemeModeTile(controller: controller),
            localeTile ??
                LocaleTile(controller: controller, localeLabel: localeLabel),
          ],
        ),
      ),
    );
  }
}
