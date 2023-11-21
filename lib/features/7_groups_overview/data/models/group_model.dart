import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_model.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:uuid/uuid.dart' as uuid;

@immutable

/// Represents a model for a group that contains information such as
/// its `id`, `name`, and a list of `projects`.
class GroupModel {
  /// Constructs a `GroupModel` instance with required parameters `name` and
  /// `projects`. Generates a unique `id` using `uuid.Uuid().v1()`.
  GroupModel({
    //required this.id,
    required this.name,
    required this.projects,
  }) : id = const uuid.Uuid().v1();

  /// Internal constructor for creating a `GroupModel` instance with
  /// specified `id`, `name`, and `projects`.
  const GroupModel._internal({
    required this.id,
    required this.name,
    required this.projects,
  });

  /// Factory method to create a `GroupModel` instance
  /// from a `Map<String, dynamic>`.
  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel._internal(
      id: map['id'] as String,
      name: map['name'] as String,
      projects: List<ProjectModel>.from(
        (map['projects'] as List<int>).map<ProjectModel>(
          (x) => ProjectModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  /// Factory method to create a `GroupModel` instance from a JSON `String`.
  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// A unique identifier for the group.
  final String id;

  /// The name or title of the group.
  final String name;

  /// A list of `ProjectModel` instances representing projects associated
  /// with this group.
  final List<ProjectModel> projects;

  /// Returns a new `GroupModel` instance with updated values
  /// for `id`, `name`, or `projects`.
  GroupModel copyWith({
    String? id,
    String? name,
    List<ProjectModel>? projects,
  }) {
    return GroupModel._internal(
      id: id ?? this.id,
      name: name ?? this.name,
      projects: projects ?? this.projects,
    );
  }

  /// Converts the `GroupModel` object to a `GroupEntity` object.
  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      projects: projects.map((project) => project.toEntity()).toList(),
    );
  }

  /// Converts the `GroupModel` object to a
  /// `Map<String, dynamic>` representation.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'projects': projects.map((x) => x.toMap()).toList(),
    };
  }

  /// Provides a string representation of the `GroupModel` instance.
  @override
  String toString() => 'GroupModel(id: $id, name: $name, projects: $projects)';

  /// Overrides the equality operator to compare two
  /// `GroupModel` instances based on their `id`, `name`, and `projects`.
  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.projects, projects);
  }

  /// Generates a hash code based on the `id`, `name`, and `projects`.
  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ projects.hashCode;
}
