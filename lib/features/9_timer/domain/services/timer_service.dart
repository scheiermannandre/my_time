import 'dart:async';

import 'package:clock/clock.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_data_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_service.g.dart';

/// This Service is used to interact with the timer.
class TimerService {
  /// Constructor for the [TimerService].
  TimerService();
  TimerDataEntity? _timerServiceData;

  /// Returns the [TimerDataEntity], so that the properties of the Timer
  /// cann be accessed.
  TimerDataEntity? get timerServiceData => _timerServiceData;

  Timer? _timer;

  /// The interval of the timer.
  Duration? interval;

  /// The [StreamController] for the timer.
  final StreamController<Duration> _timerStreamController =
      StreamController<Duration>.broadcast();

  /// The [Stream] for the timer.
  Stream<Duration> get timerStream => _timerStreamController.stream;

  void _updateStream() {
    _timerStreamController.add(_timerServiceData?.totalRun ?? Duration.zero);
  }

  /// Initializes the [TimerService].
  void init({
    TimerDataEntity? timerData,
  }) {
    // Already initialized
    if (_timerServiceData != null) {
      return;
    }
    _timerServiceData = timerData;
    interval = const Duration(seconds: 1);
    _updateStream();
  }

  /// Starts the timer.
  TimerDataEntity start() {
    _timerServiceData ??= TimerDataEntity(
      start: clock.now().toUtc(),
      breakStarts: [],
      breakEnds: [],
    );

    _timer = Timer.periodic(
      interval!,
      (timer) => _updateStream(),
    );

    return _timerServiceData!;
  }

  void _clearTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  /// Stops the timer.
  TimerDataEntity cancelTimer() {
    _clearTimer();
    final timerData = _timerServiceData!.cancel();
    _timerServiceData = null;
    _updateStream();
    return timerData;
  }

  /// Disposes the timer.
  void dispose() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _timer = null;
    }

    if (_timerServiceData != null) {
      _timerServiceData!.cancel();
      _timerServiceData = null;
    }
    _timerStreamController.close();
  }

  void _pauseTimer() {
    _timerServiceData!.startBreak();
    _timer!.cancel();
  }

  void _resumeTimer() {
    _timerServiceData!.endBreak();
    start();
  }

  /// Pauses or resumes the timer.
  TimerDataEntity pauseResumeTimer() {
    if (_timer != null && _timer!.isActive) {
      _pauseTimer();
    } else {
      _resumeTimer();
    }
    return _timerServiceData!;
  }

  /// Returns the Stream of the Timer that provides updates on the TimerService.
  Stream<Duration> watchTimer() {
    return timerStream;
  }
}

@riverpod

/// Provider for the TimerService.
TimerService timerService(TimerServiceRef ref, String projectId) {
  final service = TimerService();
  ref.onDispose(service.dispose);
  return service;
}

@riverpod

/// Provider for the TimerService Stream.
Stream<Duration> timerStream(TimerStreamRef ref, String projectId) async* {
  yield* ref.watch(timerServiceProvider(projectId)).watchTimer();
}
