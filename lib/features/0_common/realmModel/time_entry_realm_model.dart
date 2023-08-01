import 'package:realm/realm.dart';

part 'time_entry_realm_model.g.dart';

/// The OLD RealmModel for the TimeEntry.
@RealmModel()
class $TimeEntry {
  /// The id of the time entry.
  late String id;

  /// The id of the project.
  late String projectId;

  /// The id of the group.
  late String groupId;

  /// The start time of the time entry.
  late DateTime startTime;

  /// The end time of the time entry.
  late DateTime endTime;

  /// The total time of the time entry.
  late String totalTimeStr;

  /// The break time of the time entry.
  late String breakTimeStr;

  /// The description of the time entry.
  late String description = '';
}

/// The NEW RealmModel for the TimeEntry.
@RealmModel()
class $TimeEntryRealmModel {
  /// The id of the time entry.
  late String id;

  /// The id of the project.
  late String projectId;

  /// The id of the group.
  late String groupId;

  /// The start time of the time entry.
  late DateTime startTime;

  /// The end time of the time entry.
  late DateTime endTime;

  /// The total time of the time entry.
  late String totalTimeStr;

  /// The break time of the time entry.
  late String breakTimeStr;

  /// The description of the time entry.
  late String description = '';
}
