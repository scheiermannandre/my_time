// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:uuid/uuid.dart';

class ProjectModel {
  ProjectModel({
    required this.name,
    required this.groupId,
  }) : id = const Uuid().v1();

  ProjectModel.factory({
    required this.name,
    required this.groupId,
    required this.id,
  });
  final String groupId;
  final String name;
  final String id;

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
    );
  }
}
