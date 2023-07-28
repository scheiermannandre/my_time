import 'package:my_time/features/interface/realModel/time_entry_realm_model.dart';
import 'package:realm/realm.dart'; // import realm package

part 'project_realm_model.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class $Project {
  late String id;
  late String groupId;
  late String name;
  bool isMarkedAsFavourite = false;
  List<$TimeEntry> timeEntries = [];
}

@RealmModel() // define a data model class named `_Car`.
class $ProjectRealmModel {
  late String id;
  late String groupId;
  late String name;
  bool isMarkedAsFavourite = false;
  List<$TimeEntryRealmModel> timeEntries = [];
}
