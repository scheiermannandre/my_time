import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_time/common/dialogs/policy_dialog.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/mighty_theme.dart';
import 'package:my_time/config/theme/space_tokens.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// A widget representing the action footer for authentication pages.
class AuthActionFooter extends StatelessWidget {
  /// Constructs an [AuthActionFooter].
  const AuthActionFooter({
    required this.controller,
    required this.pageSwitchAction,
    required this.pageSwitchActionText,
    required this.pageSwitchQuestion,
    required this.agreementOnActionText,
    super.key,
  });

  /// The controller for the theme.
  final MightyThemeController controller;

  /// The question prompting the page switch action.
  final String pageSwitchQuestion;

  /// The text for the action that triggers a page switch.
  final String pageSwitchActionText;

  /// The callback function triggered by the page switch action.
  final VoidCallback pageSwitchAction;

  /// Text related to agreements and actions.
  final String agreementOnActionText;

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      spacing: SpaceTokens.medium,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rich text for account creation and agreements
        RichText(
          text: TextSpan(
            text: pageSwitchQuestion,
            style: controller.small,
            children: [
              TextSpan(
                text: pageSwitchActionText,
                style: controller.small.copyWith(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = pageSwitchAction,
              ),
            ],
          ),
        ),

        // Agreements text with hyperlinks
        RichText(
          text: TextSpan(
            text: agreementOnActionText,
            style: controller.small,
            children: [
              TextSpan(
                text: context.loc.authActionFooterToS,
                style: controller.small.copyWith(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await MightyMarkDownDialog.show(
                      context: context,
                      mdFileName: 'terms_of_use.md',
                    );
                  },
              ),
              TextSpan(
                text: context.loc.authActionFooterAnd,
                style: controller.small,
              ),
              TextSpan(
                text: context.loc.authActionFooterPP,
                style: controller.small.copyWith(
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await MightyMarkDownDialog.show(
                      context: context,
                      mdFileName: 'privacy_policy.md',
                    );
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
