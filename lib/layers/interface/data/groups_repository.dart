import 'package:my_time/layers/interface/dto/group_dto.dart';

abstract class GroupsRepository {
  Future<List<GroupDTO>> fetchGroups();
  Future<bool> addGroup(GroupDTO group);
  Future<GroupDTO?> fetchGroup(String groupId);
  Future<bool> deleteGroup(String groupId);
}
