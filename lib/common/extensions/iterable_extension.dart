extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    final sublist = where(test);
    return sublist.isEmpty ? null : sublist.first;
  }
}