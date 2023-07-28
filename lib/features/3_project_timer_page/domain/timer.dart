import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

class Timer {
  Timer();
  final Stopwatch watch = Stopwatch();
  late TimerData data;
  TimerData getData() {
    data = data.copyWith(duration: watch.elapsed);
    return data;
  }

  void startTimer() {
    data = TimerData.start();
    watch.reset();
    watch.start();
  }

  TimerData stopTimer() {
    watch.stop();
    final result =
        TimerData.stop(startTime: data.startTime, duration: watch.elapsed);
    data = TimerData.defaultFactory();
    watch.reset();
    return result;
  }

  void pauseResumeTimer() {
    if (watch.isRunning) {
      data = data.copyWith(state: TimerState.paused);
      watch.stop();
    } else {
      data = data.copyWith(state: TimerState.running);
      watch.start();
    }
  }
}
