import 'dart:async';

import 'package:clock/clock.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_service.g.dart';

/// Provides a TimerService.
@riverpod
TimerService timerService(TimerServiceRef ref) {
  final service = TimerService();
  ref.onDispose(service.cancelTimer);
  return service;
}

/// TimerService class, that is responsible for making a timer tick
/// and providng the elapsed time on each tick.
class TimerService {
  /// Constructor for the [TimerService].
  TimerService();
  TimerServiceData? _timerServiceData;

  /// Returns the [TimerServiceData], so that the properties of the Timer
  /// cann be accessed.
  TimerServiceData? get timerServiceData => _timerServiceData;

  Timer? _timer;

  /// The interval of the timer.
  Duration? interval;

  /// The callback that is called cyclically and provides the caller with the
  /// elapsed time.
  void Function(Duration elapsed)? _tickEvent;

  void _tick() {
    _tickEvent?.call(_timerServiceData!.totalRun);
  }

  /// Initializes the [TimerService].
  void init({
    required Duration interval,
    required void Function(Duration) tickEvent,
    TimerServiceData? timerData,
  }) {
    _timerServiceData = timerData;
    this.interval = interval;
    _tickEvent = tickEvent;
  }

  /// Starts the timer.
  TimerServiceData startTimer() {
    _timerServiceData ??= TimerServiceData(
      start: clock.now().toUtc(),
      breakStarts: [],
      breakEnds: [],
    );

    _timer = Timer.periodic(
      interval!,
      (timer) => _tick(),
    );

    return _timerServiceData!;
  }

  /// Stops the timer.
  TimerServiceData cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    final timerData = _timerServiceData!.cancel();
    _timerServiceData = null;
    return timerData;
  }

  void _pauseTimer() {
    _timerServiceData!.startBreak();
    _timer!.cancel();
  }

  void _resumeTimer() {
    _timerServiceData!.endBreak();
    startTimer();
  }

  /// Pauses or resumes the timer.
  void pauseResumeTimer() {
    if (_timer != null && _timer!.isActive) {
      _pauseTimer();
    } else {
      _resumeTimer();
    }
  }
}

/// Holds the data of a timer.
class TimerServiceData {
  /// Creates a [TimerServiceData].
  TimerServiceData({
    required this.start,
    required this.breakStarts,
    required this.breakEnds,
    TimerState? state,
  })  : end = null,
        _timerState = state ?? TimerState.running;

  TimerServiceData._privateCtor({
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
      final currentBreak = breakStarts.last;
      final finishedBreaks = breakEnds
          .asMap()
          .entries
          .map((entry) => entry.value.difference(breakStarts[entry.key]))
          .reduce((value, element) => value + element);
      return finishedBreaks + _now().difference(currentBreak);
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

  /// Returns a new [TimerServiceData] and sets the end time.
  TimerServiceData cancel() {
    return TimerServiceData._privateCtor(
      start: start,
      end: _now(),
      breakStarts: breakStarts,
      breakEnds: breakEnds,
      timerState: TimerState.off,
    );
  }
}
