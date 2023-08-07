import 'package:flutter/foundation.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

/// Model for the GroupsScreen.
@immutable
class GroupsScreenModel {
  /// Creates a [GroupsScreenModel].
  const GroupsScreenModel({
    this.groups = const [],
    this.favouriteProjects = const [],
  });

  /// The groups of the user.
  final List<GroupModel> groups;

  /// The projects of the user.
  final List<ProjectModel> favouriteProjects;

  @override
  bool operator ==(covariant GroupsScreenModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.groups, groups) &&
        listEquals(other.favouriteProjects, favouriteProjects);
  }

  @override
  int get hashCode => groups.hashCode ^ favouriteProjects.hashCode;

  @override
  String toString() =>
      '''GroupsScreenModel(groups: $groups, favouriteProjects: $favouriteProjects)''';
}
