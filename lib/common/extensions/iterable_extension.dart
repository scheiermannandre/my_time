import 'dart:convert';

/// Extension for the [Iterable] class.
extension IterableExtensions<T> on Iterable<T> {
  ///Returns the first element that satisfies the given predicate else null.
  T? firstWhereOrNull(bool Function(T) func) {
    final sublist = where(func);
    return sublist.isEmpty ? null : sublist.first;
  }

  /// Returns a deep copy of the list of DateTimes.
  static List<DateTime> deepCopyDateTimeList(List<DateTime> dateTimes) {
    final encodedList =
        json.encode(dateTimes, toEncodable: _dateTimeSerializer);
    final decodedListDynamic = json.decode(encodedList) as List<dynamic>;
    final decodedListDateTime = <DateTime>[];
    for (final value in decodedListDynamic) {
      if (value is String) {
        decodedListDateTime.add(DateTime.parse(value));
      }
    }
    return decodedListDateTime;
  }

  static dynamic _dateTimeSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }
}
