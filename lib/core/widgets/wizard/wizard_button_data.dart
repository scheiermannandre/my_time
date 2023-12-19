import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/space_tokens.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// Enum representing the type of a wizard button.
enum WizardBtnType {
  /// [forward] is used for the next button because it adds an arrow pointing
  /// to the right.
  forward,

  /// [previous] is used for the previous button because it adds an arrow
  /// pointing to the left.
  previous,

  /// [regular] is used for all other buttons.
  regular,
}

/// A customizable button widget used in the MightyWizard widget.
class WizardButtonData extends StatelessWidget {
  /// Creates a Button widget.
  ///
  /// The [title] parameter is the title text of the button.
  /// The [type] parameter is the type of the button
  /// (forward, previous, regular).
  const WizardButtonData({
    required this.title,
    super.key,
    this.type = WizardBtnType.regular,
  });

  /// The type of the button (forward, previous, regular).
  final WizardBtnType type;

  /// The title text of the button.
  final String title;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Visibility(
            visible: type == WizardBtnType.previous,
            child: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.large),
            child: Text(
              title,
              style: TextStyleTokens.body(null),
              overflow: TextOverflow.fade,
            ),
          ),
          Visibility(
            visible: type == WizardBtnType.forward,
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
