import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_time/common/dialogs/policy_dialog.dart';
import 'package:my_time/common/extensions/build_context_extension.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';
import 'package:my_time/core/widgets/spaced_column.dart';

/// A widget representing the action footer for authentication pages.
class AuthActionFooter extends StatelessWidget {
  /// Constructs an [AuthActionFooter].
  const AuthActionFooter({
    required this.pageSwitchAction,
    required this.pageSwitchActionText,
    required this.pageSwitchQuestion,
    required this.agreementOnActionText,
    super.key,
  });

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
        Text.rich(
          TextSpan(
            text: pageSwitchQuestion,
            children: [
              TextSpan(
                text: pageSwitchActionText,
                style: TextStyleTokens.bodyMedium(null).underline(),
                recognizer: TapGestureRecognizer()..onTap = pageSwitchAction,
              ),
            ],
          ),
        ),

        // Agreements text with hyperlinks
        Text.rich(
          TextSpan(
            text: agreementOnActionText,
            children: [
              TextSpan(
                text: context.loc.authActionFooterToS,
                style: TextStyleTokens.bodyMedium(null).underline(),
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
              ),
              TextSpan(
                text: context.loc.authActionFooterPP,
                style: TextStyleTokens.bodyMedium(null).underline(),
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
