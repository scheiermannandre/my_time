import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

/// Model for the timer data for the Project Timer feature.
class TimerData {
  /// Creates a [TimerData].
  TimerData({
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.state,
  });

  /// Creates a default [TimerData].
  TimerData.defaultFactory()
      : duration = Duration.zero,
        state = TimerState.off,
        startTime = DateTime(0),
        endTime = DateTime(0);

  /// Creates a [TimerData] with initial values.
  TimerData.start()
      : duration = Duration.zero,
        state = TimerState.running,
        startTime = DateTime.now().toUtc(),
        endTime = DateTime(0);

  /// Creates a [TimerData] when a timer is stopped.
  TimerData.stop({
    required this.startTime,
    required this.duration,
  })  : state = TimerState.off,
        endTime = DateTime.now().toUtc();

  /// Duration of the timer.
  final Duration duration;

  /// State of the timer.
  final TimerState state;

  /// Start time of the timer.
  final DateTime startTime;

  /// End time of the timer.
  final DateTime endTime;

  /// Creates a copy of this [TimerData] but with the given fields,
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
}
