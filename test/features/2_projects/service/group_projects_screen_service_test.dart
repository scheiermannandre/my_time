import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/2_projects/2_projects.dart';

import '../../1_groups/mock_realm_db_repositories.dart';

void main() {
  group('GroupsScreenService', () {
    late MockRealmDbProjectsRepository projectsRepository;
    setUp(() {
      projectsRepository = MockRealmDbProjectsRepository();
    });
    GroupProjectsScreenService makeGroupScreenService() {
      final container = ProviderContainer(
        overrides: [
          deviceStorageProjectsRepositoryProvider
              .overrideWithValue(projectsRepository),
        ],
      );
      addTearDown(container.dispose);
      return container.read(groupProjectsScreenServiceProvider);
    }

    test(
      'GIVEN there is a Group in the DB '
      'AND there are Projects associated with the Group '
      'WHEN streamGroupProjectsPageModel is called '
      '''THEN a GroupProjectsPageModel should be emitted containing the Group and the Projects''',
      () async {
        //GIVEN
        const group1 = GroupModel.factory(id: '1', name: 'Group 1');
        final project1 = ProjectModel.factory(
          id: '1',
          name: 'Project 1',
          groupId: group1.id,
        );
        final project2 = ProjectModel.factory(
          id: '2',
          name: 'Project 2',
          groupId: group1.id,
        );
        final service = makeGroupScreenService();
        when(() => projectsRepository.fetchGroup(group1.id)).thenAnswer(
          (_) => Future.value(
            group1,
          ),
        );
        when(() => projectsRepository.streamProjectsByGroupId(group1.id))
            .thenAnswer(
          (_) => Stream.value(
            [
              project1,
              project2,
            ],
          ),
        );
        // WHEN
        final actual =
            await service.streamGroupProjectsPageModel(group1.id).last;
        final expected = GroupProjectsPageModel(
          group: group1,
          projects: [
            project1,
            project2,
          ],
        );
        // THEN
        expect(actual, expected);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    test(
      'GIVEN there is a Group in the DB '
      'WHEN deleteGroup is called '
      'Then the group should be delted',
      () async {
        //GIVEN
        const group1 = GroupModel.factory(id: '1', name: 'Group 1');
        final service = makeGroupScreenService();
        when(() => projectsRepository.deleteGroup(group1.id)).thenAnswer(
          (_) => Future.value(
            true,
          ),
        );
        // WHEN
        final actual = await service.deleteGroup(group1.id);
        // THEN
        expect(actual, true);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });
}
