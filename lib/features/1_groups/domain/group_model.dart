import 'package:uuid/uuid.dart' as uuid;

class GroupModel {
  String id = "";
  String name = "";
  GroupModel({required this.name}) : id = const uuid.Uuid().v1();
  GroupModel.factory({required this.id, required this.name});
}
