import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

void main() {
  group('PeriodicTimer', () {
    test('Timer starts with a given PeriodicTimerModel', () {
      final start = clock.now().toUtc();
      final model = TimerServiceData(
        start: start,
        breakStarts: [],
        breakEnds: [],
      );
      final periodicTimer = TimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
          timerData: model,
        );

      expect(periodicTimer.timerServiceData!.state, TimerState.running);
    });

    test('Timer starts and creates PeriodicTimerModel', () {
      final periodicTimer = TimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        );
      expect(periodicTimer.timerServiceData!.state, TimerState.running);
    });

    test('Timer starts and is cancelled', () {
      final periodicTimer = TimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        )
        ..cancelTimer();
      expect(periodicTimer.timerServiceData!.state, TimerState.off);
    });

    test('Timer starts with and creates PeriodicTimerModel', () {
      final periodicTimer = TimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        )
        ..cancelTimer();
      expect(periodicTimer.timerServiceData!.state, TimerState.off);
    });

    test('Timer starts, then pauses and resumed', () {
      final periodicTimer = TimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        )
        ..pauseResumeTimer();

      expect(periodicTimer.timerServiceData!.state, TimerState.paused);

      periodicTimer.pauseResumeTimer();
      expect(periodicTimer.timerServiceData!.state, TimerState.running);
    });

    test('Timer calls callback correctly', () {
      const simulatedSeconds = 5;
      final start = clock.now().toUtc();
      // Any code run within [fakeAsync] is run within the context of the
      // [FakeAsync] object passed to the callback.
      fakeAsync(
        (async) {
          final durations = <Duration>[];

          TimerService().init(
            interval: const Duration(seconds: 1),
            tickEvent: durations.add,
          );

          // All asynchronous features that rely on timing are automatically
          // controlled by [fakeAsync].
          expect(
            Completer<void>().future.timeout(const Duration(seconds: 5)),
            throwsA(isA<TimeoutException>()),
          );

          // This will cause the timeout above to fire immediately,
          //without waiting 5 seconds of real time.
          async.elapse(const Duration(seconds: simulatedSeconds));
          expect(durations.length, simulatedSeconds);

          for (var i = 0; i < simulatedSeconds; i++) {
            expect(
              durations[i],
              start.add(Duration(seconds: i + 1)).difference(start),
            );
          }
        },
        initialTime: start,
      );
    });
  });
}
