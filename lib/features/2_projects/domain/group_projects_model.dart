import 'package:my_time/features/2_projects/2_projects.dart';

/// Model for the GroupProjectsPage.
class GroupProjectsPageModel {
  /// Creates a [GroupProjectsPageModel].
  GroupProjectsPageModel({required this.group, required this.projects});

  /// The group of the page.
  final GroupModel group;

  /// The projects of the group.
  final List<ProjectModel> projects;
}
