import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

void main() {
  group('PeriodicTimer', () {
    TimerService makeTimerService() {
      final container = ProviderContainer(
        overrides: [],
      );
      addTearDown(container.dispose);
      return container.read(timerServiceProvider);
    }

    test('Timer starts with a given PeriodicTimerModel', () {
      final start = clock.now().toUtc();
      final model = TimerServiceData(
        start: start,
        breakStarts: [],
        breakEnds: [],
      );
      final timerService = makeTimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
          timerData: model,
        );

      expect(timerService.timerServiceData!.state, TimerState.running);
    });

    test('Timer service is initialized with TimerServiceData equals null', () {
      final timerService = makeTimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        );
      expect(timerService.timerServiceData, isNull);
    });

    test('Timer starts and is cancelled', () {
      final timerService = makeTimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        )
        ..startTimer();
      final serviceData = timerService.cancelTimer();
      expect(serviceData.state, TimerState.off);
    });

    test('Timer starts, then pauses and resumed', () {
      final timerService = makeTimerService()
        ..init(
          interval: const Duration(seconds: 1),
          tickEvent: (elapsed) {},
        )
        ..startTimer()
        ..pauseResumeTimer();

      expect(timerService.timerServiceData!.state, TimerState.paused);

      timerService.pauseResumeTimer();
      expect(timerService.timerServiceData!.state, TimerState.running);
    });

    test('Timer calls callback correctly', () {
      const simulatedSeconds = 5;
      final start = clock.now().toUtc();
      // Any code run within [fakeAsync] is run within the context of the
      // [FakeAsync] object passed to the callback.
      fakeAsync(
        (async) {
          final durations = <Duration>[];
          final timerService = TimerService()
            ..init(
              interval: const Duration(seconds: 1),
              tickEvent: durations.add,
            )
            ..startTimer();

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
          timerService.cancelTimer();
        },
        initialTime: start,
      );
    });
  });
}
