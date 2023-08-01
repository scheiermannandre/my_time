import 'package:realm/realm.dart';

part 'timer_data_realm_model.g.dart';

/// The RealmModel for the TimerData.
@RealmModel()
class $TimerDataRealmModel {
  /// The id of the timer data.
  late String id;

  /// The id of the project.
  late String projectId;

  /// The start time of the timer data.
  late DateTime startTime;

  /// The end time of the timer data.
  late DateTime endTime;

  /// The times when breaks started.
  late List<DateTime> breakStartTimes;

  /// The times when breaks ended.
  late List<DateTime> breakEndTimes;

  /// The TimerState of the timer data.
  late String timerState;
}
