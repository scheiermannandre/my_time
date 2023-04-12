// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

// class TimeEntry {
//   final String id;
//   late DateTime startTime;
//   late DateTime endTime;
//   late Duration totalTime;
//   late Duration breakTime;
//   late String description;
//   TimeEntry(this.id, this.startTime, this.endTime, this.totalTime);
// }

class TimeEntryDTO {
  final String id;
  final String projectId;

  final DateTime startTime;
  final DateTime endTime;
  final Duration totalTime;
  final Duration breakTime;
  final String description;

  TimeEntryDTO({
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.breakTime,
    required this.description,
  }) : id = const Uuid().v1();

  TimeEntryDTO.factory({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.breakTime,
    required this.description,
  });

  TimeEntryDTO copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    Duration? breakTime,
    String? description,
  }) {
    DateTime tmpStartTime = startTime ?? this.startTime;
    DateTime tmpEndTime = endTime ?? this.endTime;

    return TimeEntryDTO.factory(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: tmpStartTime,
      endTime: tmpEndTime,
      totalTime: tmpEndTime.difference(tmpStartTime),
      breakTime: breakTime ?? this.breakTime,
      description: description ?? this.description,
    );
  }

  bool checkEntriesIntersect(TimeEntryDTO entry2) {
    bool intersect = _compareEntriesIntersection(this, entry2);
    if (!intersect) {
      intersect = _compareEntriesIntersection(entry2, this);
    }
    return intersect;
  }

  static bool _compareEntriesIntersection(
      TimeEntryDTO entry1, TimeEntryDTO entry2) {
    return (entry1.startTime.isBefore(entry2.endTime) &&
        entry2.startTime.isBefore(entry1.endTime));
  }
}
