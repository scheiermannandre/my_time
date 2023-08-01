import 'package:my_time/features/0_common/common_time_entry_model.dart';

/// Model for a time entry for the Project Timer feature.
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
}
