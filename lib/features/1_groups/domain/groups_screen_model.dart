import 'package:my_time/features/1_groups/1_groups.dart';

class GroupsScreenModel {
  final List<GroupModel> groups;
  final List<ProjectModel> projects;
  GroupsScreenModel({this.groups = const [], this.projects = const []});
}
