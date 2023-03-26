// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';

class TimerData {
  TimerData({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.state,
  });

  final Duration duration;
  final TimerState state;
  final DateTime startTime;
  final DateTime endTime;

  TimerData copyWith({
    Duration? duration,
    TimerState? state,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return TimerData(
      duration: duration ?? this.duration,
      state: state ?? this.state,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }

  TimerData.defaultFactory()
      : duration = Duration.zero,
        state = TimerState.off,
        startTime = DateTime(0),
        endTime = DateTime(0);

  TimerData.start()
      : duration = Duration.zero,
        state = TimerState.running,
        startTime = DateTime.now().toUtc(),
        endTime = DateTime(0);

  TimerData.stop({
    required this.startTime,
    required this.duration,
  })  : state = TimerState.off,
        endTime = DateTime.now().toUtc();
}
