/// Represents the ProjectModel in the context of the ProjectHistory feature.
class ProjectModel {
  /// Factory constructor for ProjectModel.
  ProjectModel.factory({
    required this.name,
    required this.id,
  });

  /// The name of the project.
  final String name;

  /// The id of the project.
  final String id;
}
