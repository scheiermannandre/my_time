import 'package:uuid/uuid.dart';

class ProjectModel {
  ProjectModel({
    required this.name,
  }) : id = const Uuid().v1();

  ProjectModel.factory({
    required this.name,
    required this.id,
  });
  final String name;
  final String id;
}
