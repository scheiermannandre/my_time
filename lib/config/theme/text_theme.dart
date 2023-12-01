import 'package:flutter/material.dart';
import 'package:my_time/config/theme/tokens/text_style_tokens.dart';

/// The text theme of the application.
TextTheme get textTheme => TextTheme(
      bodyLarge: TextStyleTokens.body(null),
      bodyMedium: TextStyleTokens.bodyMedium(null),
    );
