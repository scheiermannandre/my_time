import 'dart:async';

import 'package:clock/clock.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

import '../robots/work_robot.dart';

void main() {
  group('TimerServiceData', () {
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

      fakeAsync(
        (async) {
          // All asynchronous features that rely on timing are automatically
          // controlled by [fakeAsync].
          expect(
            Completer<void>().future.timeout(const Duration(seconds: 5)),
            throwsA(isA<TimeoutException>()),
          );
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

          // simulate 60 minutes of working and go to break
          workMinutes = 60;
          final secondWorkLength = Duration(minutes: workMinutes);

          worker.workAndStartBreak(
            timeAfterFirstBreak,
            secondWorkLength,
            model,
          );

          breakMinutes = 40;
          final secondBreakLengthUntillNow = Duration(minutes: breakMinutes);

          async.elapse(secondBreakLengthUntillNow);

          // expect 20 + 40 minutes of break
          withClock(
            Clock.fixed(
              start
                  .add(firstWorkLength)
                  .add(firstBreakLength)
                  .add(secondWorkLength)
                  .add(secondBreakLengthUntillNow),
            ),
            () => expect(
              firstBreakLength + secondBreakLengthUntillNow,
              model.totalBreak,
            ),
          );
        },
        initialTime: start,
      );
    });

    test('Test TotalBreak with ongoing break', () async {
      final start = clock.now().toUtc();
      final worker = WorkRobot();

      fakeAsync(
        (async) {
          // All asynchronous features that rely on timing are automatically
          // controlled by [fakeAsync].
          expect(
            Completer<void>().future.timeout(const Duration(seconds: 5)),
            throwsA(isA<TimeoutException>()),
          );

          // build  and initiliaze model
          final model = worker.comeToWork(start);

          // simulate 5 minutes of working and 20 minutes of break
          const workMinutes = 5;
          const firstWorkLength = Duration(minutes: workMinutes);

          const breakMinutes = 40;
          const firstBreakLengthUntillNow = Duration(minutes: breakMinutes);
          worker.workAndStartBreak(
            start,
            firstWorkLength,
            model,
          );

          async.elapse(firstBreakLengthUntillNow);

          // expect 40 minutes of break
          withClock(
            Clock.fixed(
              start.add(firstWorkLength).add(firstBreakLengthUntillNow),
            ),
            () => expect(firstBreakLengthUntillNow, model.totalBreak),
          );
        },
        initialTime: start,
      );
    });
  });
}

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy HH:mm:ss.SSS').format(date);
}