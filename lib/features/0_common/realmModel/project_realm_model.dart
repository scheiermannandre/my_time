import 'package:my_time/features/0_common/realmModel/time_entry_realm_model.dart';
import 'package:realm/realm.dart';

part 'project_realm_model.g.dart';

/// The RealmModel for the Project.
@RealmModel()
class $Project {
  /// The id of the project.
  late String id;

  /// The id of the group.
  late String groupId;

  /// The name of the project.
  late String name;

  /// The flag if the project is marked as favourite.
  bool isMarkedAsFavourite = false;

  /// The list of time entries.
  List<$TimeEntry> timeEntries = [];
}

/// The RealmModel for the Project.
@RealmModel()
class $ProjectRealmModel {
  /// The id of the project.
  @PrimaryKey()
  late String id;

  /// The id of the group.
  late String groupId;

  /// The name of the project.
  late String name;

  /// The flag if the project is marked as favourite.
  bool isMarkedAsFavourite = false;

  /// The list of time entries.
  List<$TimeEntryRealmModel> timeEntries = [];
}
