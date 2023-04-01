extension DurationExtension on Duration {
  String toFormattedString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes";
  }

  static Duration parseDuration(String durationStr) {
    // hh:mm:ss.ffffff
    final componentsStr = durationStr.split(':');
    final sAndMs = componentsStr.last.split('.');
    componentsStr.removeLast();
    componentsStr.addAll(sAndMs);
    final components = componentsStr.map(int.parse).toList();
    Duration duration = Duration(
      hours: components[0],
      minutes: components[1],
      seconds: components[2],
      microseconds: components[3],
    );
    return duration;
  }
}
