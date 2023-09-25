// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:my_time/features/2_projects/2_projects.dart';

/// Model for the GroupProjectsPage.
@immutable
class GroupProjectsPageModel {
  /// Creates a [GroupProjectsPageModel].
  const GroupProjectsPageModel({required this.group, required this.projects});

  /// The group of the page.
  final GroupModel group;

  /// The projects of the group.
  final List<ProjectModel> projects;

  @override
  String toString() =>
      'GroupProjectsPageModel(group: $group, projects: $projects)';

  @override
  bool operator ==(covariant GroupProjectsPageModel other) {
    if (identical(this, other)) return true;

    return other.group == group && listEquals(other.projects, projects);
  }

  @override
  int get hashCode => group.hashCode ^ projects.hashCode;
}
