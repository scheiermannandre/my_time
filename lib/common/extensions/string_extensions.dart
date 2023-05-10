extension EnumParser on String {
  T toEnum<T>(List<T> values) {
    return values.firstWhere((e) => e.toString().toLowerCase() == toLowerCase(),
        orElse: () => throw Exception(
            "Invalid Cast. Type not Found.")); //return null if not found
  }
}
