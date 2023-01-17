import 'dart:async';

class CustomTimer {
  Timer? _timer;
  final Function stateCallback;
  Duration duration = const Duration(seconds: 0);
  final int secondsPerDay = 86400;
  CustomTimer({required this.stateCallback});
  bool isActive() {
    if (_timer == null) {
      return false;
    } else {
      return _timer!.isActive;
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _addTime());
  }

  void stopTimer() {
    if (_timer == null) {
      return;
    }
    _timer?.cancel();
    _timer = null;
    duration = const Duration(seconds: 0);
    stateCallback();
  }

  void _addTime() {
    if (duration.inSeconds >= secondsPerDay - 1) {
      stopTimer();
    } else {
      int seconds = duration.inSeconds + 1;
      duration = Duration(seconds: seconds);
      stateCallback();
    }
  }

  void pauseResumeTimer() {
    if (_timer == null) {
      return;
    }
    if (_timer!.isActive) {
      _timer?.cancel();
    } else {
      startTimer();
    }
  }
}
