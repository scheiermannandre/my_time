import 'package:flutter/material.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/mighty_action_button.dart';
import 'package:my_time/core/widgets/spaced_column.dart';
import 'package:my_time/features/8_authentication/presentation/pages/widgets/text_divider.dart';

/// A widget representing the social login buttons for authentication.
class AuthSocialButtons extends StatelessWidget {
  /// Constructs an [AuthSocialButtons] with required parameters.
  const AuthSocialButtons({
    required this.controller,
    required this.googleBtnText,
    required this.googleBtnAction,
    required this.appleBtnText,
    required this.appleBtnAction,
    super.key,
  });

  /// The controller for managing the theme.
  final MightyThemeController controller;

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
            'or',
            style: controller.small,
          ),
          dividerColor: controller.nonDecorativeBorderColor,
        ),

        // Google sign-in button
        MightyActionButton.secondary(
          themeController: controller,
          label: googleBtnText,
          onPressed: googleBtnAction,
        ),

        // Apple sign-in button
        MightyActionButton.secondary(
          themeController: controller,
          label: appleBtnText,
          onPressed: appleBtnAction,
        ),
      ],
    );
  }
}