import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

import '../mock_realm_db_groups_repository.dart';

void main() {
  group('GroupsScreenService', () {
    late MockRealmDbGroupsRepository groupsRepository;
    setUp(() {
      groupsRepository = MockRealmDbGroupsRepository();
    });
    GroupsScreenService makeGroupScreenService() {
      final container = ProviderContainer(
        overrides: [
          deviceStorageGroupsRepositoryProvider
              .overrideWithValue(groupsRepository),
        ],
      );
      addTearDown(container.dispose);
      return container.read(groupsScreenServiceProvider);
    }

    test('streamGroupsScreenModel emits Combined Groups and Favourite Projects',
        () {
      const group1 = GroupModel.factory(id: '1', name: 'Group 1');
      const group2 = GroupModel.factory(id: '2', name: 'Group 2');

      const project1 = ProjectModel.factory(id: '1', name: 'Project 1');
      const project2 = ProjectModel.factory(id: '2', name: 'Project 2');
      final service = makeGroupScreenService();
      when(groupsRepository.streamGroups).thenAnswer(
        (_) => Stream.value(
          [
            group1,
            group2,
          ],
        ),
      );
      when(groupsRepository.streamFavouriteProjects).thenAnswer(
        (_) => Stream.value(
          [
            project1,
            project2,
          ],
        ),
      );

      expect(
        service.streamGroupsScreenModel(),
        emitsInOrder(
          [
            const GroupsScreenModel(
              groups: [
                group1,
                group2,
              ],
              favouriteProjects: [
                project1,
                project2,
              ],
            ),
            emitsDone,
          ],
        ),
      );
    });
  });
}
