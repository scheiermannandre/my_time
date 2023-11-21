import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

@immutable

/// Represents a model for a project that contains information such as
/// its `id`, `name`, `groupId`, and whether it is marked as a favorite.
class ProjectModel {
  /// Constructs a `ProjectModel` instance with required
  /// parameters `id`, `name`, `groupId`, and `isFavorite`.
  const ProjectModel({
    required this.id,
    required this.name,
    required this.groupId,
    required this.isFavorite,
  });

  /// Factory method to create a `ProjectModel`
  /// instance from a map representation.
  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

  /// Factory method to create a `ProjectModel` instance from a JSON `String`.
  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// A unique identifier for the project.
  final String id;

  /// The name or title of the project.
  final String name;

  /// The identifier of the group associated with this project.
  final String groupId;

  /// Represents whether the project is marked as a favorite or not.
  final bool isFavorite;

  /// Returns a new `ProjectModel` instance with updated
  /// values for `id`, `name`, `groupId`, or `isFavorite`.
  ProjectModel copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Converts the `ProjectModel` object to a `ProjectEntity` object.
  ProjectEntity toEntity() {
    return ProjectEntity(
      //id: id,
      name: name,
      groupId: groupId,
      isFavorite: isFavorite,
    );
  }

  /// Converts the `ProjectModel` object to
  /// a `Map<String, dynamic>` representation.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'groupId': groupId,
      'isFavorite': isFavorite,
    };
  }

  /// Converts the `ProjectModel` object to a JSON `String`.
  String toJson() => json.encode(toMap());

  /// Provides a string representation of the `ProjectModel` instance.
  @override
  String toString() {
    return '''ProjectModel(id: $id, name: $name, groupId: $groupId, isFavorite: $isFavorite)''';
  }

  /// Overrides the equality operator to compare two `ProjectModel`
  /// instances based on their `id`, `name`, `groupId`, and `isFavorite`.
  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.groupId == groupId &&
        other.isFavorite == isFavorite;
  }

  /// Generates a hash code based on the
  /// `id`, `name`, `groupId`, and `isFavorite`.
  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ groupId.hashCode ^ isFavorite.hashCode;
  }
}
