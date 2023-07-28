import 'package:my_time/features/1_groups/1_groups.dart';

abstract class GroupsRepository {
  Future<List<GroupModel>> fetchGroups();
  Future<bool> addGroup(GroupModel group);
  Future<GroupModel?> fetchGroup(String groupId);
  Future<List<ProjectModel>> fetchFavouriteProjects();
}
