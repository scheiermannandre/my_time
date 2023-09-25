// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Model for a group for the Projects feature.
@immutable
class GroupModel {
  /// Creates a [GroupModel].
  GroupModel({required this.name}) : id = const uuid.Uuid().v1();

  /// Factory for a [GroupModel].
  const GroupModel.factory({required this.id, required this.name});

  /// The id of the group.
  final String id;

  /// The name of the group.
  final String name;

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
