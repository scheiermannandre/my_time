import 'package:uuid/uuid.dart';

class ProjectModel {
  ProjectModel({
    required this.name,
    required this.groupId,
  })  : id = const Uuid().v1(),
        isMarkedAsFavourite = false;

  ProjectModel.factory({
    required this.name,
    required this.groupId,
    required this.id,
    required this.isMarkedAsFavourite,
  });
  final String groupId;
  final String name;
  final String id;
  final bool isMarkedAsFavourite;

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
