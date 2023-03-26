// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

class ProjectDTO {
  ProjectDTO({
    required this.name,
    required this.groupId,
  })  : id = const Uuid().v1(),
        isMarkedAsFavourite = false;

  ProjectDTO._private({
    required this.name,
    required this.groupId,
    required this.id,
    required this.isMarkedAsFavourite,
  });
  final String groupId;
  final String name;
  final String id;
  final bool isMarkedAsFavourite;

  ProjectDTO copyWith({
    String? groupId,
    String? name,
    String? id,
    bool? isMarkedAsFavourite,
  }) {
    return ProjectDTO._private(
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      id: id ?? this.id,
      isMarkedAsFavourite: isMarkedAsFavourite ?? this.isMarkedAsFavourite,
    );
  }

  @override
  bool operator ==(covariant ProjectDTO other) {
    if (identical(this, other)) return true;
  
    return 
      other.groupId == groupId &&
      other.name == name &&
      other.id == id &&
      other.isMarkedAsFavourite == isMarkedAsFavourite;
  }

  @override
  int get hashCode {
    return groupId.hashCode ^
      name.hashCode ^
      id.hashCode ^
      isMarkedAsFavourite.hashCode;
  }

  @override
  String toString() {
    return 'ProjectDTO(groupId: $groupId, name: $name, id: $id, isMarkedAsFavourite: $isMarkedAsFavourite)';
  }
}
