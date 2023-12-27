import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/corner_radius_tokens.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

/// The input decoration theme that styles text fields.
InputDecorationTheme getInputDecorationTheme(
  Color enabledColor,
  Color errorColor,
) {
  return InputDecorationTheme(
    filled: true,
    border: _getBorder(enabledColor),
    enabledBorder: _getBorder(enabledColor),
    focusedBorder: _getBorder(enabledColor),
    errorBorder: _getBorder(errorColor),
    focusedErrorBorder: _getBorder(errorColor),
    hintStyle: TextStyleTokens.body(null),
  );
}

InputBorder _getBorder(Color borderColor) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(
      Radius.circular(
        CornerRadiusTokens.small,
      ),
    ),
    borderSide: BorderSide(
      color: borderColor,
    ),
  );
}
