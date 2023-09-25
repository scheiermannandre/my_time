// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Model for a project for the Projects feature.
@immutable
class ProjectModel {
  /// Creates a [ProjectModel].
  ProjectModel({
    required this.name,
    required this.groupId,
  }) : id = const Uuid().v1();

  /// Factory for a [ProjectModel].
  const ProjectModel.factory({
    required this.name,
    required this.groupId,
    required this.id,
  });

  /// The id of the group that holds the project.
  final String groupId;

  /// The name of the project.
  final String name;

  /// The id of the project.
  final String id;

  /// Creates a copy of this [ProjectModel]
  ProjectModel copyWith({
    String? groupId,
    String? name,
    String? id,
    bool? isMarkedAsFavourite,
  }) {
    return ProjectModel.factory(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  @override
  String toString() => 'ProjectModel(groupId: $groupId, name: $name, id: $id)';

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.groupId == groupId && other.name == name && other.id == id;
  }

  @override
  int get hashCode => groupId.hashCode ^ name.hashCode ^ id.hashCode;
}
