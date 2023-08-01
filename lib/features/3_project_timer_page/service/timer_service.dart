import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Service for the Timer.
class TimerService {
  /// Constructor for the [TimerService].
  TimerService();

  /// The timer.
  late Timer timer;

  /// The callback that is called cyclically.
  late VoidCallback callback;

  /// Starts the timer.
  Timer startTimer(VoidCallback callback) {
    this.callback = callback;
    return Timer.periodic(
      const Duration(seconds: 1),
      (timer) => callback(),
    );
  }

  /// Stops the timer.
  void stopTimer() {
    timer.cancel();
  }

  /// Pauses or resumes the timer.
  void pauseResumeTimer() {
    if (timer.isActive) {
      stopTimer();
    } else {
      startTimer(callback);
    }
  }
}

/// Provides the [TimerService].
final timerServiceProvider = Provider<TimerService>((ref) {
  return TimerService();
});
