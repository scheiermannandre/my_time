import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
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

  group('PeriodicTimerModel', () {
    test('On Cancel end time isNotNull', () async {
      final start = clock.now().toUtc();

      final model = TimerServiceData(
        start: start,
        breakStarts: [],
        breakEnds: [],
      );
      expect(model.cancel().end, isNotNull);
    });

    test('''
    On Cancel end time equals actual end time measured with clock. 
    MICROSECONDS are considered as irrelevant. ''', () async {
      final start = clock.now().toUtc();
      var model = withClock(
        Clock.fixed(start),
        () => TimerServiceData(
          start: clock.now().toUtc(),
          breakStarts: [],
          breakEnds: [],
        ),
      );
      final end = start.add(const Duration(seconds: 5));
      model = withClock(
        Clock.fixed(end),
        () => model.cancel(),
      );

      expect(formatDate(end), formatDate(model.end!));
    });

    test('Test TotalBreak by multiple breaks', () async {
      final start = clock.now().toUtc();
      final worker = WorkRobot();

      // build  and initiliaze model
      final model = worker.comeToWork(start);

      // simulate 5 minutes of working and 20 minutes of break
      var workMinutes = 5;
      var breakMinutes = 20;
      final firstWorkLength = Duration(minutes: workMinutes);
      final firstBreakLength = Duration(minutes: breakMinutes);

      final timeAfterFirstBreak = worker.workAndDoBreak(
        start,
        firstWorkLength,
        firstBreakLength,
        model,
      );
      // expect 20 minutes of break
      expect(firstBreakLength, model.totalBreak);

      // simulate 60 minutes of working and 40 minutes of break
      workMinutes = 60;
      breakMinutes = 40;
      final secondWorkLength = Duration(minutes: workMinutes);
      final secondBreakLength = Duration(minutes: breakMinutes);

      worker.workAndDoBreak(
        timeAfterFirstBreak,
        secondWorkLength,
        secondBreakLength,
        model,
      );

      // expect 60 minutes of break
      expect(firstBreakLength + secondBreakLength, model.totalBreak);
    });

    test('Totalrun', () async {
      final start = clock.now().toUtc();
      final model = withClock(
        Clock.fixed(start),
        () => TimerServiceData(
          start: clock.now().toUtc(),
          breakStarts: [],
          breakEnds: [],
        ),
      );
      const expectedTotalRun = Duration(seconds: 5);
      final end = start.add(expectedTotalRun);
      final actualTotalRun = withClock(
        Clock.fixed(end),
        () {
          return model.totalRun;
        },
      );

      expect(expectedTotalRun, actualTotalRun);
    });
    test('Test TotalBreak while in a break', () async {
      final start = clock.now().toUtc();
      final worker = WorkRobot();

      // build  and initiliaze model
      final model = worker.comeToWork(start);

      // simulate 5 minutes of working and 20 minutes of break
      var workMinutes = 5;
      const breakMinutes = 20;
      final firstWorkLength = Duration(minutes: workMinutes);
      const firstBreakLength = Duration(minutes: breakMinutes);

      final timeAfterFirstBreak = worker.workAndDoBreak(
        start,
        firstWorkLength,
        firstBreakLength,
        model,
      );
      // expect 20 minutes of break
      expect(firstBreakLength, model.totalBreak);

      // simulate 60 minutes of working and go to break
      workMinutes = 60;
      final secondWorkLength = Duration(minutes: workMinutes);

      worker.workAndStartBreak(
        timeAfterFirstBreak,
        secondWorkLength,
        model,
      );

      // expect 20 minutes of break
      expect(firstBreakLength, model.totalBreak);
    });
  });

  test('Test TotalBreak 0', () async {
    final start = clock.now().toUtc();
    final worker = WorkRobot();

    // build  and initiliaze model
    final model = worker.comeToWork(start);

    // simulate 5 minutes of working and 20 minutes of break
    const workMinutes = 5;
    const firstWorkLength = Duration(minutes: workMinutes);

    worker.workAndStartBreak(
      start,
      firstWorkLength,
      model,
    );
    // expect 0 minutes of break
    expect(Duration.zero, model.totalBreak);
  });
}

class WorkRobot {
  TimerServiceData comeToWork(DateTime start) {
    final model = withClock(
      Clock.fixed(start),
      () => TimerServiceData(
        start: clock.now().toUtc(),
        breakStarts: [],
        breakEnds: [],
      ),
    );
    return model;
  }

  DateTime workAndDoBreak(
    DateTime start,
    Duration workLength,
    Duration breakLength,
    TimerServiceData model,
  ) {
    final breakStart = workAndStartBreak(
      start,
      workLength,
      model,
    );

    final breakEnd = breakAndGetBackToWork(
      breakStart,
      breakLength,
      model,
    );

    return breakEnd;
  }

  DateTime workAndStartBreak(
    DateTime start,
    Duration workLength,
    TimerServiceData model,
  ) {
    final breakStart = start.add(workLength);
    withClock(
      Clock.fixed(breakStart),
      model.startBreak,
    );
    return breakStart;
  }

  DateTime breakAndGetBackToWork(
    DateTime startFirstBreak,
    Duration breakTime,
    TimerServiceData model,
  ) {
    final breakEnd = startFirstBreak.add(breakTime);
    withClock(
      Clock.fixed(breakEnd),
      model.endBreak,
    );
    return breakEnd;
  }
}

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy HH:mm:ss.SSS').format(date);
}
