import 'package:my_time/features/1_groups/1_groups.dart';

abstract class GroupsRepository {
  Future<bool> addGroup(GroupModel group);
  Stream<List<GroupModel>> streamGroups();
  Stream<List<ProjectModel>> streamFavouriteProjects();
}
