import 'package:flutter/material.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/corner_radius_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/text_style_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';

/// A custom SnackBar for the Mighty App.
class MightySnackBar {
  /// Shows a custom SnackBar.
  static void show(
    BuildContext context,
    MightyThemeController controller,
    String message, {
    String? actionLabel,
    Future<void> Function()? onTab,
    VoidCallback? onHide,
    Duration duration = const Duration(seconds: 30),
  }) {
    final mode = controller.themeMode == SystemThemeMode.light
        ? SystemThemeMode.dark
        : SystemThemeMode.light;
    final backgroundColor = ThemeColors.getMainBackgroundColor(mode);

    final textColor = ThemeColors.getHeadingTextColor(mode);
    final textStyle = TextStyleTokens.small(textColor);
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            duration: duration,
            backgroundColor: backgroundColor,
            content: Row(
              children: [
                Expanded(
                  child: Text(
                    message,
                    style: textStyle.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: MightyActionButton.flatText(
                    inverseColor: true,
                    themeController: controller,
                    label: actionLabel ?? 'OK',
                    onPressed: () async {
                      await onTab?.call();
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              ],
            ),
            elevation: 6,
            behavior: SnackBarBehavior.floating,
            shape: const RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(CornerRadiusTokens.small)),
            ),
          ),
        )
        .closed
        .then((value) => onHide?.call());
  }
}
