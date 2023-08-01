import 'package:uuid/uuid.dart';

/// Model for a project for the ProjectTimer feature.
class ProjectModel {
  /// Creates a [ProjectModel].
  ProjectModel({
    required this.name,
    required this.groupId,
  })  : id = const Uuid().v1(),
        isMarkedAsFavourite = false;

  /// Factory for a [ProjectModel].
  ProjectModel.factory({
    required this.name,
    required this.groupId,
    required this.id,
    required this.isMarkedAsFavourite,
  });

  /// The id of the group that holds the project.
  final String groupId;

  /// The name of the project.
  final String name;

  /// The id of the project.
  final String id;

  /// True if the project is marked as favourite.
  final bool isMarkedAsFavourite;

  /// Copy Method, so that the [ProjectModel] can be updated and still be
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
      isMarkedAsFavourite: isMarkedAsFavourite ?? this.isMarkedAsFavourite,
    );
  }
}
