import 'package:realm/realm.dart';

part 'time_entry_realm_model.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class $TimeEntry {
  late String id;
  late String projectId;
  late String groupId;
  late DateTime startTime;
  late DateTime endTime;
  late String totalTimeStr;
  late String breakTimeStr;
  late String description = "";
}

@RealmModel()
class $TimeEntryRealmModel {
  late String id;
  late String projectId;
  late String groupId;
  late DateTime startTime;
  late DateTime endTime;
  late String totalTimeStr;
  late String breakTimeStr;
  late String description = "";
}
