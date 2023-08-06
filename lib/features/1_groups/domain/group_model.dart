import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart' as uuid;

/// Model for a group for the Groups feature.
@immutable
class GroupModel {
  /// Creates a [GroupModel].
  GroupModel({
    required this.name,
  }) : id = const uuid.Uuid().v1();

  /// Factory for a [GroupModel].
  const GroupModel.factory({required this.id, required this.name});

  /// The id of the group.
  final String id;

  /// The name of the group.
  final String name;

  @override
  bool operator ==(covariant GroupModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'GroupModel(id: $id, name: $name)';
}
