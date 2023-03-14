import 'package:uuid/uuid.dart';

class ProjectDTO {
  ProjectDTO({
    required this.name,
    required this.parentId,
  }) : id = const Uuid().v1();
  final String parentId;
  final String name;
  final String id;
}
