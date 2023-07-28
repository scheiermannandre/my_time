// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

class CommonTimeEntryModel {
  final String id;
  final String projectId;

  final DateTime startTime;
  final DateTime endTime;
  final Duration totalTime;
  final Duration breakTime;
  final String description;

  CommonTimeEntryModel({
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.breakTime,
    required this.description,
  }) : id = const Uuid().v1();

  CommonTimeEntryModel.factory({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.totalTime,
    required this.breakTime,
    required this.description,
  });

  CommonTimeEntryModel copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    Duration? breakTime,
    String? description,
  }) {
    DateTime tmpStartTime = startTime ?? this.startTime;
    DateTime tmpEndTime = endTime ?? this.endTime;

    return CommonTimeEntryModel.factory(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: tmpStartTime,
      endTime: tmpEndTime,
      totalTime: tmpEndTime.difference(tmpStartTime),
      breakTime: breakTime ?? this.breakTime,
      description: description ?? this.description,
    );
  }

  bool checkEntriesIntersect(CommonTimeEntryModel entry2) {
    bool intersect = _compareEntriesIntersection(this, entry2);
    if (!intersect) {
      intersect = _compareEntriesIntersection(entry2, this);
    }
    return intersect;
  }

  static bool _compareEntriesIntersection(
      CommonTimeEntryModel entry1, CommonTimeEntryModel entry2) {
    return (entry1.startTime.isBefore(entry2.endTime) &&
        entry2.startTime.isBefore(entry1.endTime));
  }
}
