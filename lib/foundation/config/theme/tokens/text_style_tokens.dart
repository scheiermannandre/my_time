import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

/// A utility class providing predefined text style tokens for
/// consistent typography.
class TextStyleTokens {
  static const _normal = FontWeight.w400;

  static const _bold = FontWeight.w600;

  /// Returns a text style for headline 1 with the specified [fontColor].
  static TextStyle getHeadline1(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 48,
      fontWeight: _bold,
    );
  }

  /// Returns a text style for headline 3 with the specified [fontColor].
  static TextStyle getHeadline3(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: _bold,
    );
  }

  /// Returns a text style for headline 4 with the specified [fontColor].
  static TextStyle getHeadline4(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: _bold,
    );
  }

  /// Returns a text style for headline 5 with the specified [fontColor].
  static TextStyle getHeadline5(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: _bold,
    );
  }

  /// Returns a text style for body text with the specified [fontColor].
  static TextStyle title(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: _bold,
    );
  }

  /// Returns a text style for body text with the specified [fontColor].
  static TextStyle body(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: _normal,
      color: fontColor,
    );
  }

  /// Returns a text style for small headlines with the specified [fontColor].
  static TextStyle smallHeadline(Color? fontColor) {
    return TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w600,
      color: fontColor,
    );
  }

   static TextStyle bodyTickMoreMedium(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: _normal,
      color: fontColor,
    );
  }

  /// Returns a text style for small text with the specified [fontColor].
  static TextStyle bodyMedium(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: _normal,
      color: fontColor,
    );
  }

  /// Returns a text style for small text with the specified [fontColor].
  static TextStyle bodySmall(Color? fontColor) {
    return GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: _normal,
    );
  }
}

/// A utility class providing extensions for [TextStyle].
extension TextStyleExtensions on TextStyle {
  /// Returns a copy of this [TextStyle] with an underline.
  TextStyle underline() {
    return copyWith(
      decoration: TextDecoration.underline,
    );
  }
}
