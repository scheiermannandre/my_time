import 'package:uuid/uuid.dart';

/// Model for a project for the Groups feature.
class ProjectModel {
  /// Creates a [ProjectModel].
  ProjectModel({
    required this.name,
  }) : id = const Uuid().v1();

  /// Factory for a [ProjectModel].
  ProjectModel.factory({
    required this.name,
    required this.id,
  });

  /// The name of the project.
  final String name;

  /// The id of the project.
  final String id;
}
