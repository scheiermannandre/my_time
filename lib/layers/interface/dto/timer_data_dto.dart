// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart' as uuid;

import 'package:my_time/common/extensions/string_extensions.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';

class TimerDataDto {
  final String id;
  final String projectId;
  final DateTime startTime;
  final DateTime endTime;
  final List<DateTime> breakStartTimes;
  final List<DateTime> breakEndTimes;
  final TimerState state;

  TimerDataDto({
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required this.state,
  }) : id = const uuid.Uuid().v1();

  TimerDataDto.factory({
    required this.id,
    required this.projectId,
    required this.startTime,
    required this.endTime,
    required this.breakStartTimes,
    required this.breakEndTimes,
    required String timerState,
  }) : state = timerState.toEnum(TimerState.values);

  TimerDataDto copyWith({
    String? id,
    String? projectId,
    DateTime? startTime,
    DateTime? endTime,
    List<DateTime>? breakStartTimes,
    List<DateTime>? breakEndTimes,
    TimerState? state,
  }) {
    return TimerDataDto.factory(
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
