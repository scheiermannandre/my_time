import 'package:uuid/uuid.dart';

class GroupDTO {
  String id = "";
  String name = "";
  GroupDTO({required this.name}) : id = const Uuid().v1();
}
