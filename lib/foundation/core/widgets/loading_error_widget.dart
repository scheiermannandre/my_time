import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';

/// Widget that is displayed when the loading of the data fails.
class LoadingErrorWidget extends StatelessWidget {
  /// Constructor for the [LoadingErrorWidget].
  const LoadingErrorWidget({
    required this.onRefresh,
    super.key,
  });

  /// Callback that is called when the refresh button is tapped.
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: SpaceTokens.medium,
        children: [
          const Icon(
            Icons.error_outline,
            size: 60,
          ),
          Text(
            context.loc.loadingErrorWidgetTitle,
            style: TextStyleTokens.getHeadline5(null),
          ),
          Text(
            context.loc.loadingErrorWidgetDescription,
            style: TextStyleTokens.bodySmall(null),
          ),
          ActionButton.primary(
            onPressed: onRefresh,
            child: Text(context.loc.loadingErrorWidgetBtnLabel),
          ),
        ],
      ),
    );
  }
}
