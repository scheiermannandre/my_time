// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Model for a project for the Groups feature.
@immutable
class ProjectModel {
  /// Creates a [ProjectModel].
  ProjectModel({
    required this.name,
  }) : id = const Uuid().v1();

  /// Factory for a [ProjectModel].
  const ProjectModel.factory({
    required this.name,
    required this.id,
  });

  /// The name of the project.
  final String name;

  /// The id of the project.
  final String id;

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.name == name && other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;

  @override
  String toString() => 'ProjectModel(name: $name, id: $id)';
}
