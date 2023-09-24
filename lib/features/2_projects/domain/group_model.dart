import 'package:uuid/uuid.dart' as uuid;

/// Model for a group for the Projects feature.
class GroupModel {
  /// Creates a [GroupModel].
  GroupModel({required this.name}) : id = const uuid.Uuid().v1();

  /// Factory for a [GroupModel].
  GroupModel.factory({required this.id, required this.name});

  /// The id of the group.
  String id = '';

  /// The name of the group.
  String name = '';

  @override
  String toString() {
    return 'GroupModel(id: $id, name: $name)';
  }
}
