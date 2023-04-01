import 'package:uuid/uuid.dart' as uuid;

class GroupDTO {
  String id = "";
  String name = "";
  GroupDTO({required this.name}) : id = const uuid.Uuid().v1();
  GroupDTO.factory({required this.id, required this.name});
}
