import 'package:my_time/features/projects_groups/projects/domain/project.dart';

class Group {
  String id = "";

  String name = "";
  List<Project> projects = [];
  Group({this.name = "", this.id = "", this.projects = const []});
}
