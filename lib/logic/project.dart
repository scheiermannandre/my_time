import 'package:my_time/logic/time_entry.dart';

class Project {
  String name = "";
  String category = "";
  List<TimeEntry> timeEntries = [];

  Project({required this.name});
}
