import 'package:clock/clock.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';

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
