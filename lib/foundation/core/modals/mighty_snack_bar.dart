import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tertiary_button_theme.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';

/// A custom SnackBar for the Mighty App.
class SnackBarPopUp {
  /// Shows a custom SnackBar.
  static void show(
    BuildContext context,
    String message, {
    String? actionLabel,
    Future<void> Function()? onTab,
    VoidCallback? onHide,
    Duration duration = const Duration(seconds: 30),
  }) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: duration,
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                  ),
                ),
                // ignore: lines_longer_than_80_chars
                // ToDo - Future Optimization: Listen to the theme changes via Riverpod and change the button style accordingly.
                ActionButton.text(
                  style: Theme.of(context).brightness == Brightness.light
                      ? TertiaryButtonThemeData.dark().style
                      : TertiaryButtonThemeData.light().style,
                  onPressed: () async {
                    await onTab?.call();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  child: Text(
                    actionLabel ?? 'Ok',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
        .closed
        .then((value) => onHide?.call());
  }
}