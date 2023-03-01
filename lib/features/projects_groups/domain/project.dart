import 'package:my_time/features/projects_groups/domain/time_entry.dart';

class Project {
  String name = "";
  String category = "";
  List<TimeEntry> timeEntries = [];
  Project({this.name = ""});
}
