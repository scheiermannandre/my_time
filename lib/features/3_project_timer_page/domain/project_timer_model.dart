import 'package:my_time/common/common.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

import 'package:uuid/uuid.dart' as uuid;

class ProjectTimerModel {
  final String id;
  final String projectId;
  final DateTime startTime;
  final DateTime endTime;
  final List<DateTime> breakStartTimes;
  final List<DateTime> breakEndTimes;
  final TimerState state;

  ProjectTimerModel({
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required this.state,
  }) : id = const uuid.Uuid().v1();

  ProjectTimerModel.factory({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required String timerState,
  }) : state = timerState.toEnum(TimerState.values);

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
