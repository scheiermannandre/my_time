// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

class ProjectDto {
  ProjectDto({
    required this.name,
    required this.groupId,
  })  : id = const Uuid().v1(),
        isMarkedAsFavourite = false;

  ProjectDto.factory({
    required this.name,
    required this.groupId,
    required this.id,
    required this.isMarkedAsFavourite,
  });
  final String groupId;
  final String name;
  final String id;
  final bool isMarkedAsFavourite;

  ProjectDto copyWith({
    String? groupId,
    String? name,
    String? id,
    bool? isMarkedAsFavourite,
  }) {
    return ProjectDto.factory(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      id: id ?? this.id,
      isMarkedAsFavourite: isMarkedAsFavourite ?? this.isMarkedAsFavourite,
    );
  }
}
