import 'package:my_time/common/common.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

import 'package:uuid/uuid.dart' as uuid;

/// Model for a project timer for the Project Timer feature.
class ProjectTimerModel {
  /// Creates a [ProjectTimerModel].
  ProjectTimerModel({
    required this.projectId,
    required this.startTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required this.state,
    DateTime? endTime,
  })  : id = const uuid.Uuid().v1(),
        endTime = endTime ?? DateTime(0);

  /// Factory for a [ProjectTimerModel].
  ProjectTimerModel.factory({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required String timerState,
  }) : state = timerState.toEnum(TimerState.values);

  /// The id of the project timer.
  final String id;

  /// The id of the project.
  final String projectId;

  /// The start time of the project timer.
  final DateTime startTime;

  /// The end time of the project timer.
  final DateTime endTime;

  /// The start times of the breaks of the project timer.
  final List<DateTime> breakStartTimes;

  /// The end times of the breaks of the project timer.
  final List<DateTime> breakEndTimes;

  /// The state of the project timer.
  final TimerState state;

  /// Copy Method, so that the [ProjectTimerModel] can be updated and still be
  /// immutable.
  ProjectTimerModel copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    List<DateTime>? breakStartTimes,
    List<DateTime>? breakEndTimes,
    TimerState? state,
  }) {
    return ProjectTimerModel.factory(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakStartTimes: breakStartTimes ?? this.breakStartTimes,
      breakEndTimes: breakEndTimes ?? this.breakEndTimes,
      timerState: state.toString(),
    );
  }
}
