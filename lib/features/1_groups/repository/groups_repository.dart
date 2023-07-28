import 'package:my_time/features/1_groups/1_groups.dart';

abstract class GroupsRepository {
  Future<bool> addGroup(GroupModel group);
  Stream<GroupsScreenModel> streamGroups();
}
