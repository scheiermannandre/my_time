import 'package:my_time/features/9_timer/data/repositories/timer_data_repository.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_data_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_page_controller.g.dart';

@riverpod

/// A controller for the TimerPage.
class TimerPageController extends _$TimerPageController {
  @override
  FutureOr<void> build() {}

  /// Saves the timer data to the database.
  bool saveTimerData(String projectId, TimerDataEntity timerData) {
    ref.read(timerDataRepositoryProvider).saveTimerData(projectId, timerData);
    return true;
  }

  /// Saves the timer data to the database.
  bool deleteTimerData(String projectId) {
    ref.read(timerDataRepositoryProvider).deleteTimerData(projectId);
    return true;
  }
}
