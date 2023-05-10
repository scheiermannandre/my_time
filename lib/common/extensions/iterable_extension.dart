extension IterableX<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) func) {
    final sublist = where(func);
    return sublist.isEmpty ? null : sublist.first;
  }
}