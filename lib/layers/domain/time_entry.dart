// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

class TimeEntry {
  final String id;
  late DateTime startTime;
  late DateTime endTime;
  late Duration totalTime;
  late Duration breakTime;
  late String description;
  TimeEntry(this.id, this.startTime, this.endTime, this.totalTime);
}

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
    Duration? totalTime,
    Duration? breakTime,
    String? description,
  }) {
    return TimeEntryDTO.factory(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalTime: totalTime ?? this.totalTime,
      breakTime: breakTime ?? this.breakTime,
      description: description ?? this.description,
    );
  }
}
