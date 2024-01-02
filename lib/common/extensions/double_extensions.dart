extension DoubleExtensions on double {
  Duration convertToHHMMDuration() {
    final hours = floor();
    final minutes = ((this - hours) * 60).round();
    return Duration(hours: hours, minutes: minutes);
  }
}
