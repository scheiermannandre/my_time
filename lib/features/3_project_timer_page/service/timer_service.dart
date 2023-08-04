import 'dart:async';

import 'package:clock/clock.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_service.g.dart';

/// Provides a TimerService.
@riverpod
TimerService timerService(TimerServiceRef ref) {
  final service = TimerService();
  ref.onDispose(() {
    if (service._timer != null) {
      service._clearTimer();
    }
  });
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

  void _clearTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  /// Stops the timer.
  TimerServiceData cancelTimer() {
    _clearTimer();
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
