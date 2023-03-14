class TimeEntry {
  final String id;
  late DateTime startTime;
  late DateTime endTime;
  late Duration totalTime;
  late Duration breakTime;
  late String description;
  TimeEntry(this.id, this.startTime, this.endTime, this.totalTime);
}
