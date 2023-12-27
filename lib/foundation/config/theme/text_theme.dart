import 'package:flutter/material.dart';
import 'package:my_time/foundation/config/theme/tokens/text_style_tokens.dart';

/// The text theme of the application.
TextTheme get textTheme => TextTheme(
      labelLarge:
          TextStyleTokens.bodyMedium(null), // necessary for snackbar TextButton
      bodyLarge: TextStyleTokens.body(null),
      bodyMedium: TextStyleTokens.bodyMedium(null),

      titleLarge: TextStyleTokens.getHeadline4(null), // used for appbar title
      headlineSmall: TextStyleTokens.getHeadline3(null),
    );
