import 'package:clock/clock.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_state.dart';

/// Holds the data of a timer.
class TimerDataEntity {
  /// Creates a [TimerDataEntity].
  TimerDataEntity({
    required this.start,
    required this.breakStarts,
    required this.breakEnds,
    TimerState? state,
  })  : end = null,
        _timerState = state ?? TimerState.running;

  TimerDataEntity._privateCtor({
    required this.start,
    required this.breakStarts,
    required this.breakEnds,
    required this.end,
    required TimerState timerState,
  }) : _timerState = timerState;

  /// The start time of the project timer.
  final DateTime start;

  /// The start times of the breaks of the project timer.
  final List<DateTime> breakStarts;

  /// The end times of the breaks of the project timer.
  final List<DateTime> breakEnds;

  /// The start time of the project timer.
  final DateTime? end;

  /// The state of the project timer.
  Duration get totalRun => _now().difference(start) - totalBreak;

  /// The state of the project timer.
  Duration get totalBreak {
    if (breakStarts.isEmpty && breakEnds.isEmpty) {
      return Duration.zero;
    } else if (breakEnds.isEmpty) {
      return _now().difference(breakStarts.last);
    } else if (breakStarts.length == breakEnds.length) {
      return breakEnds
          .asMap()
          .entries
          .map((entry) => entry.value.difference(breakStarts[entry.key]))
          .reduce((value, element) => value + element);
    } else {
      final currentBreakStart = breakStarts.last;
      final finishedBreaks = breakEnds
          .asMap()
          .entries
          .map((entry) => entry.value.difference(breakStarts[entry.key]))
          .reduce((value, element) => value + element);
      return finishedBreaks + _now().difference(currentBreakStart);
    }
  }

  late TimerState _timerState;

  /// Presents the state the timer is in to the accessor.
  TimerState get state => _timerState;

  /// Changes the state of the timer and tracks the time when a break started.
  void startBreak() {
    breakStarts.add(_now());
    _timerState = TimerState.paused;
  }

  /// Changes the state of the timer and tracks the time when a break ended.
  void endBreak() {
    breakEnds.add(_now());
    _timerState = TimerState.running;
  }

  DateTime _now() => clock.now().toUtc();

  /// Returns a new [TimerDataEntity] and sets the end time.
  TimerDataEntity cancel() {
    return TimerDataEntity._privateCtor(
      start: start,
      end: _now(),
      breakStarts: breakStarts,
      breakEnds: breakEnds,
      timerState: TimerState.off,
    );
  }
}
