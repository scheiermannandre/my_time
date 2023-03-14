import 'package:my_time/layers/interface/dto/group_dto.dart';

abstract class GroupsRepository {
  Future<List<GroupDTO>> getGroups();
  Future<bool> addGroup(GroupDTO group);
  Future<GroupDTO?> getGroup(String groupId);
  Future<bool> deleteGroup(String groupId);
}
