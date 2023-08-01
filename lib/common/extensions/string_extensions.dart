/// String Extensions
extension EnumParser on String {
  /// Converts a string to an enum value.
  T toEnum<T>(List<T> values) {
    return values.firstWhere(
      (e) => e.toString().toLowerCase() == toLowerCase(),
      orElse: () => throw Exception(
        'Invalid Cast. Type not Found.',
      ),
    ); //return null if not found
  }
}
