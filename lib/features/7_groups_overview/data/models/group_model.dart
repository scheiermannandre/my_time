// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:my_time/features/7_groups_overview/data/models/project_model.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/group_entity.dart';
import 'package:uuid/uuid.dart' as uuid;

@immutable
class GroupModel {
  GroupModel({
    //required this.id,
    required this.name,
    required this.projects,
  }) : id = const uuid.Uuid().v1();

  const GroupModel._internal({
    required this.id,
    required this.name,
    required this.projects,
  });
  final String id;
  final String name;
  final List<ProjectModel> projects;

  GroupModel copyWith({
    String? id,
    String? name,
    List<ProjectModel>? projects,
  }) {
    return GroupModel._internal(
      id: id ?? this.id,
      name: name ?? this.name,
      projects: projects ?? this.projects,
    );
  }

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      projects: projects.map((project) => project.toEntity()).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'projects': projects.map((x) => x.toMap()).toList(),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel._internal(
      id: map['id'] as String,
      name: map['name'] as String,
      projects: List<ProjectModel>.from(
        (map['projects'] as List<int>).map<ProjectModel>(
          (x) => ProjectModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupModel.fromJson(String source) =>
      GroupModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'GroupModel(id: $id, name: $name, projects: $projects)';

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.projects, projects);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ projects.hashCode;
}
