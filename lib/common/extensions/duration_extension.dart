extension DurationExtension on Duration {
  String toFormattedString() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes";
  }
}
