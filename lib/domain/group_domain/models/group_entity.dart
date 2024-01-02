import 'package:my_time/domain/group_domain/models/project_entity.dart';

/// Represents a group entity.
class NewGroupModel {
  /// Constructor for GroupEntity.
  NewGroupModel({
    required this.id,
    required this.name,
    required this.projects,
  });

  /// Unique identifier for the group.
  final String id;

  /// Name of the group.
  final String name;

  /// List of projects associated with the group.
  final List<NewProjectModel> projects;

  /// Factory method to create a `GroupModel` instance
  /// from a `Map<String, dynamic>`.
  factory NewGroupModel.fromMap(Map<String, dynamic> map) {
    return NewGroupModel(
      id: map['id'] as String,
      name: map['name'] as String,
      projects: List<NewProjectModel>.from(
        (map['projects'] as Map<String, dynamic>).values.map<NewProjectModel>(
              (x) => NewProjectModel.fromMap(x as Map<String, dynamic>),
            ),
      ),
    );
  }
}
