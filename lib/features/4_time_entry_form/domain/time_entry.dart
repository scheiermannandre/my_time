import 'package:my_time/features/0_common/common_time_entry_model.dart';

/// Model for the time entry for time entry form feature.
class TimeEntryModel extends CommonTimeEntryModel {
  /// Creates a [TimeEntryModel].
  TimeEntryModel({
    required super.projectId,
    required super.startTime,
    required super.endTime,
    required super.totalTime,
    required super.breakTime,
    required super.description,
  });

  /// Factory for a [TimeEntryModel].
  TimeEntryModel.factory({
    required super.id,
    required super.projectId,
    required super.startTime,
    required super.endTime,
    required super.totalTime,
    required super.breakTime,
    required super.description,
  }) : super.factory();

  @override
  TimeEntryModel copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    Duration? breakTime,
    String? description,
  }) {
    final tmpStartTime = startTime ?? this.startTime;
    final tmpEndTime = endTime ?? this.endTime;

    return TimeEntryModel.factory(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: tmpStartTime,
      endTime: tmpEndTime,
      totalTime: tmpEndTime.difference(tmpStartTime),
      breakTime: breakTime ?? this.breakTime,
      description: description ?? this.description,
    );
  }
}
