import 'package:my_time/layers/interface/dto/time_entry.dart';
import 'package:realm/realm.dart'; // import realm package

part 'project.g.dart'; // declare a part file.

@RealmModel() // define a data model class named `_Car`.
class $Project {
  late String id;
  late String groupId;
  late String name;
  bool isMarkedAsFavourite = false;
  List<$TimeEntry> timeEntries = [];
}