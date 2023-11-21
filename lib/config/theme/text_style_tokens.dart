import 'package:flutter/painting.dart';

/// A utility class providing predefined text style tokens for
/// consistent typography.
class TextStyleTokens {
  /// Returns a text style for headline 1 with the specified [fontColor].
  static TextStyle getHeadline1(Color fontColor) {
    return TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      color: fontColor,
    );
  }

  /// Returns a text style for headline 3 with the specified [fontColor].
  static TextStyle getHeadline3(Color fontColor) {
    return TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: fontColor,
    );
  }

  /// Returns a text style for headline 4 with the specified [fontColor].
  static TextStyle getHeadline4(Color fontColor) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: fontColor,
    );
  }

  /// Returns a text style for headline 5 with the specified [fontColor].
  static TextStyle getHeadline5(Color fontColor) {
    return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: fontColor,
    );
  }

  /// Returns a text style for body text with the specified [fontColor].
  static TextStyle body(Color fontColor) {
    return TextStyle(
      fontSize: 18,
      color: fontColor,
    );
  }

  /// Returns a text style for small headlines with the specified [fontColor].
  static TextStyle smallHeadline(Color fontColor) {
    return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: fontColor,
    );
  }

  /// Returns a text style for small text with the specified [fontColor].
  static TextStyle small(Color fontColor) {
    return TextStyle(
      fontSize: 14,
      color: fontColor,
    );
  }
}
