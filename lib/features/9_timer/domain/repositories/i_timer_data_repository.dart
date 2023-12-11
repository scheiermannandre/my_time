import 'package:my_time/features/9_timer/domain/entities/timer_data_entity.dart';

/// A repository for the timer data.
abstract class ITimerDataRepository {
  /// Fetches the timer data from the database.
  Future<TimerDataEntity?> fetchTimerData(String projectId);

  /// Saves the timer data to the database.
  void saveTimerData(String projectId, TimerDataEntity timerData);

  /// Clears the timer data from the database.
  void deleteTimerData(String projectId);
}
