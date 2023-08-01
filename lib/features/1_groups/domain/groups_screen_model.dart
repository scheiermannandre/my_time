import 'package:my_time/features/1_groups/1_groups.dart';

/// Model for the GroupsScreen.
class GroupsScreenModel {
  /// Creates a [GroupsScreenModel].
  GroupsScreenModel({
    this.groups = const [],
    this.favouriteProjects = const [],
  });

  /// The groups of the user.
  final List<GroupModel> groups;

  /// The projects of the user.
  final List<ProjectModel> favouriteProjects;
}
