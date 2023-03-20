import 'dart:async';

import 'package:my_time/layers/presentation/5_time_entry_form/domain/timer_data.dart';

enum TimerState {
  off,
  running,
  paused,
}

class CustomTimer {
  CustomTimer();
  Timer? _timer;
  //final Function stateCallback;
  late TimerData data;
  Duration duration = const Duration(seconds: 0);
  final int secondsPerDay = 86400;

  TimerData watchTimerData(int i) {
    return data;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _addTime());
    data = TimerData(duration: duration, state: TimerState.running);
  }

  void stopTimer() {
    if (_timer == null) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    //duration = const Duration(seconds: 0);
    data = TimerData(duration: duration,  state: TimerState.off);
    //stateCallback();
  }

  void _addTime() {
    if (duration.inSeconds >= secondsPerDay - 1) {
      stopTimer();
    } else {
      int seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
      data = TimerData(duration: duration,  state: TimerState.running);
      if (seconds % 10 == 0) {
        print("Timer alive");
      }
      //stateCallback();
    }
  }

  void pauseResumeTimer() {
    if (_timer == null) {
      return;
    }
    if (_timer!.isActive) {
      _timer?.cancel();
      data = TimerData(duration: duration,  state: TimerState.paused);
    } else {
      startTimer();
    }
  }
}
