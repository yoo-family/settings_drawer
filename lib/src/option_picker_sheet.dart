import 'package:flutter/material.dart';

/// One choice offered by [showOptionPickerSheet].
class SettingsOption<T> {
  const SettingsOption({required this.value, required this.label, this.icon});

  /// The value this option represents, compared against the sheet's
  /// current value with `==` to decide which row gets the checkmark.
  final T value;

  /// The text shown for this option.
  final String label;

  /// An optional leading icon for this option.
  final IconData? icon;
}

/// Shows a [SettingsOption] list in a [showModalBottomSheet], with a
/// checkmark on whichever option equals [currentValue].
///
/// Returns the picked [SettingsOption], or `null` if the sheet was
/// dismissed without a selection. Returning the whole option — rather than
/// just its `value` — keeps "dismissed" and "picked" unambiguous even when
/// `T` is itself nullable (e.g. `Locale?`, where `null` is a legitimate
/// choice meaning "follow the system language"): read `.value` off the
/// result once you've confirmed it's non-null.
Future<SettingsOption<T>?> showOptionPickerSheet<T>({
  required BuildContext context,
  required List<SettingsOption<T>> options,
  required T currentValue,
  String? title,
}) {
  return showModalBottomSheet<SettingsOption<T>>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(title,
                    style: Theme.of(sheetContext).textTheme.titleMedium),
              ),
            for (final option in options)
              ListTile(
                leading: option.icon == null ? null : Icon(option.icon),
                title: Text(option.label),
                trailing: option.value == currentValue
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.of(sheetContext).pop(option),
              ),
          ],
        ),
      );
    },
  );
}
