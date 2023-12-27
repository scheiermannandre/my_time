import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/size_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

/// A circular progress indicator that adapts its appearance based
/// on the provided theme.
class LoadingIndicator extends StatelessWidget {
  /// Constructs a [LoadingIndicator] with the required
  /// theme controller.
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(SpaceTokens.small),
        decoration: BoxDecoration(
          color: ThemeColorBuilder(context).getActionsColor(),
          shape: BoxShape.circle,
        ),
        child: const SizedBox(
          height: SizeTokens.x24,
          width: SizeTokens.x24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
