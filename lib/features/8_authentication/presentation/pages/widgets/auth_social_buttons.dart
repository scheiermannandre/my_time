import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/text_divider.dart';
import 'package:my_time/foundation/config/theme/tokens/color_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';
import 'package:my_time/foundation/core/widgets/action_button.dart';
import 'package:my_time/foundation/core/widgets/spaced_column.dart';

/// A widget representing the social login buttons for authentication.
class AuthSocialButtons extends StatelessWidget {
  /// Constructs an [AuthSocialButtons] with required parameters.
  const AuthSocialButtons({
    required this.googleBtnText,
    required this.googleBtnAction,
    required this.appleBtnText,
    required this.appleBtnAction,
    super.key,
  });

  /// Text displayed on the Google sign-in button.
  final String googleBtnText;

  /// Action triggered when the Google sign-in button is pressed.
  final VoidCallback googleBtnAction;

  /// Text displayed on the Apple sign-in button.
  final String appleBtnText;

  /// Action triggered when the Apple sign-in button is pressed.
  final VoidCallback appleBtnAction;

  @override
  Widget build(BuildContext context) {
    // Builds a column of social login buttons (Google and Apple).
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Divider to separate social login buttons
        TextDivider(
          dividerText: Text(
            context.loc.authSocialBtnOr,
          ),
          dividerColor:
              ThemeColorBuilder(context).getNonDecorativeBorderColor(),
        ),
        // Google sign-in button
        ActionButton.secondary(
          onPressed: () async {
            googleBtnAction.call();
          },
          child: Text(googleBtnText),
        ),
        // Apple sign-in button
        ActionButton.secondary(
          onPressed: () async {
            appleBtnAction.call();
          },
          child: Text(appleBtnText),
        ),
      ],
    );
  }
}
