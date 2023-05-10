import 'dart:async';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class TimerService {
  TimerService();

  late Timer timer;
  late Function callback;

  Timer startTimer(Function callback) {
    this.callback = callback;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        this.callback();
        debugPrint(DateTime.now().toIso8601String());
      },
    );
    return timer;
  }

  void stopTimer() {
      timer.cancel();
  }
  
  void pauseResumeTimer() {
    if (timer.isActive) {
      stopTimer();
    } else {
      startTimer(callback);
    }
  }
}

final timerServiceProvider = Provider<TimerService>((ref) {
  ref.onDispose(
    () {
      debugPrint("TimerServiceDisposed");
    },
  );
  return TimerService();
});
