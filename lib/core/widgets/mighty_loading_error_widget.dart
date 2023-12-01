import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// Widget that is displayed when the loading of the data fails.
class MightyLoadingErrorWidget extends StatelessWidget {
  /// Constructor for the [MightyLoadingErrorWidget].
  const MightyLoadingErrorWidget({
    required this.onRefresh,
    required MightyThemeController themeController,
    super.key,
  }) : _themeController = themeController;

  /// Callback that is called when the refresh button is tapped.
  final VoidCallback onRefresh;

  final MightyThemeController _themeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SpaceTokens.veryVerySmall,
        children: [
          Icon(
            Icons.error_outline,
            color: _themeController.headingTextColor,
            size: 60,
          ),
          const SizedBox(height: SpaceTokens.medium),
          Text(
            context.loc.loadingErrorWidgetTitle,
            style: _themeController.headline5,
          ),
          const SizedBox(height: SpaceTokens.medium),
          Text(
            context.loc.loadingErrorWidgetDescription,
            style: _themeController.small,
          ),
          const SizedBox(height: SpaceTokens.medium),
          MightyActionButton.primary(
            themeController: _themeController,
            label: context.loc.loadingErrorWidgetBtnLabel,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
