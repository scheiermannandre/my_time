import 'dart:convert';

extension IterableExtensions<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) func) {
    final sublist = where(func);
    return sublist.isEmpty ? null : sublist.first;
  }

  static List<DateTime> deepCopyDateTimeList(List<DateTime> dateTimes) {
    final encodedList = json.encode(dateTimes, toEncodable: dateTimeSerializer);
    final List<dynamic> decodedListDynami = json.decode(encodedList);
    final List<DateTime> decodedListDateTime = [];
    for (String value in decodedListDynami) {
      decodedListDateTime.add(DateTime.parse(value));
    }
    return decodedListDateTime;
  }

  static dynamic dateTimeSerializer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }
}
