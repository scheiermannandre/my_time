/// A typedef representing the result of a numeric check.
///
/// It includes a result indicating whether the input is numeric and a number,
/// which is the parsed numeric value (defaulting to 0 if not numeric).
typedef IsNumericRecord = ({bool result, num number});

/// Extension methods for the `String` class providing additional functionality.
extension StringExtension on String {
  /// Checks if the current string is numeric.
  ///
  /// Returns an [IsNumericRecord] indicating the result of the numeric check,
  /// including a boolean result and the parsed number.
  IsNumericRecord isNumeric() {
    final number = num.tryParse(this);

    return (
      result: number != null,
      number: number ?? 0,
    );
  }

  /// Checks if the string contains only letters (alphabetic characters).
  ///
  /// Returns `true` if the string contains only letters, otherwise `false`.
  bool containsOnlyLetters() {
    final regex = RegExp(r'^[a-zA-Z]+$');
    return regex.hasMatch(this);
  }

  /// Checks if the string is formatted as a currency.
  ///
  /// Returns `true` if the string matches the currency format,
  /// otherwise `false`.
  bool isCurrency() {
    final regex = RegExp(r'^[a-zA-Z\s]*$');
    return regex.hasMatch(this);
  }

  /// Capitalizes the first letter of the string.
  ///
  /// Returns a new string with the first letter capitalized.
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
