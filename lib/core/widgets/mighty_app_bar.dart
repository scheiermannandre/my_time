import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/config/theme/color_tokens.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/text_style_tokens.dart';

/// A customized app bar that adapts its appearance based on the
/// system theme mode.
///
/// This widget extends [ConsumerWidget] and implements [PreferredSizeWidget],
/// providing a powerful combination of state management and a
/// preferred size for the app bar.
class MightyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Constructs a [MightyAppBar] with required parameters.
  const MightyAppBar({
    required this.themeMode,
    required this.title,
    super.key,
    this.actions = const [],
  });

  /// The system theme mode to adapt the app bar's appearance.
  final SystemThemeMode themeMode;

  /// The title to display on the app bar.
  final String title;

  /// The list of widgets to display as actions on the app bar.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configure app bar based on the system theme mode
    if (themeMode == SystemThemeMode.light) {
      return AppBar(
        title: Text(
          title,
          style: TextStyleTokens.getHeadline4(
            LightThemeColorTokens.darkestColor,
          ),
        ),
        actions: actions,
        backgroundColor: LightThemeColorTokens.primaryColor,
        iconTheme: const IconThemeData(
          color: LightThemeColorTokens.darkestColor,
        ),
      );
    } else {
      return AppBar(
        title: Text(
          title,
          style: TextStyleTokens.getHeadline4(
            DarkThemeColorTokens.darkestColor,
          ),
        ),
        actions: actions,
        backgroundColor: DarkThemeColorTokens.primaryColor,
        iconTheme: const IconThemeData(
          color: DarkThemeColorTokens.darkestColor,
        ),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
