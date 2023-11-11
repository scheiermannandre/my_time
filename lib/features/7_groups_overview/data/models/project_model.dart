// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_time/features/7_groups_overview/domain/entities/project_entity.dart';

@immutable
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.groupId,
    required this.isFavorite,
  });
  final String id;
  final String name;
  final String groupId;
  final bool isFavorite;

  ProjectModel copyWith({
    String? id,
    String? name,
    String? groupId,
    bool? isFavorite,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      groupId: groupId ?? this.groupId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  ProjectEntity toEntity() {
    return ProjectEntity(
      //id: id,
      name: name,
      groupId: groupId,
      isFavorite: isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'groupId': groupId,
      'isFavorite': isFavorite,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      isFavorite: map['isFavorite'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '''ProjectModel(id: $id, name: $name, groupId: $groupId, isFavorite: $isFavorite)''';
  }

  @override
  bool operator ==(covariant ProjectModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.groupId == groupId &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ groupId.hashCode ^ isFavorite.hashCode;
  }
}
