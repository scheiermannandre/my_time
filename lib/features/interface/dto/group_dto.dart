import 'package:uuid/uuid.dart' as uuid;

class GroupDto {
  String id = "";
  String name = "";
  GroupDto({required this.name}) : id = const uuid.Uuid().v1();
  GroupDto.factory({required this.id, required this.name});
}
