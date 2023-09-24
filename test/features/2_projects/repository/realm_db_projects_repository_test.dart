import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/1_groups/1_groups.dart' as groups;

import 'package:my_time/features/2_projects/2_projects.dart' as projects;
import 'package:my_time/features/2_projects/repository/realm_db_projects_repository.dart';
import 'package:realm/realm.dart';
import '../../RealmDBTests/RealmRepoTester.dart';

void main() {
  group('RealmDbProjectsRepository', () {
    final realms = <Realm>[];

    tearDownAll(() async {
      await RealmRepoTester.tearDownAll(realms);
    });

    group('Add Project', () {
      testWidgets(
        'GIVEN a RealmDBProjectsRepo is instantiated '
        'AND a valid group is saved to the DB '
        'AND a valid project is created given the group Id of a valid group '
        'WHEN addProject is called '
        'THEN true should be returned indicating succes',
        (tester) async {
          await tester.runAsync(() async {
            // Given
            final realmGroupsRepo =
                RealmRepoTester.makeRealmGroupsRepoInstance(realms);
            final group = groups.GroupModel(name: 'Test Group');
            await realmGroupsRepo.repo.addGroup(group);

            final realmProjectRepo =
                RealmRepoTester.makeRealmProjectsRepoInstance(
              realmGroupsRepo.realm,
            );
            final project =
                projects.ProjectModel(name: 'Test Project', groupId: group.id);

            // When
            final result = await realmProjectRepo.addProject(project);

            //Then
            expect(result, true);
          });
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    });

    group('delete group', () {
      testWidgets(
        'GIVEN there is a valid group '
        'AND there is at least one project associated with the group '
        'WHEN deleteGroup is called '
        'THEN the group and the projects should be gone',
        (tester) async {
          await tester.runAsync(() async {
            // Given
            final realmGroupsRepo =
                RealmRepoTester.makeRealmGroupsRepoInstance(realms);
            final group = groups.GroupModel(name: 'Test Group');
            await realmGroupsRepo.repo.addGroup(group);

            final realmProjectRepo =
                RealmRepoTester.makeRealmProjectsRepoInstance(
              realmGroupsRepo.realm,
            );
            final project =
                projects.ProjectModel(name: 'Test Project', groupId: group.id);

            await realmProjectRepo.addProject(project);

            // When
            await realmProjectRepo.deleteGroup(group.id);

            //Then
            final fetchedGroups = await realmProjectRepo.fetchGroups();

            expect(fetchedGroups.isEmpty, true);
          });
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    });

    group('fetch group', () {
      testWidgets(
        'GIVEN there is a valid group '
        'WHEN fetchGroup is called '
        'THEN the group is returned',
        (tester) async {
          await tester.runAsync(() async {
            // Given
            final realmGroupsRepo =
                RealmRepoTester.makeRealmGroupsRepoInstance(realms);
            final group = groups.GroupModel(name: 'Test Group');
            await realmGroupsRepo.repo.addGroup(group);

            final realmProjectRepo =
                RealmRepoTester.makeRealmProjectsRepoInstance(
              realmGroupsRepo.realm,
            );

            // When
            final fetchedGroup = await realmProjectRepo.fetchGroup(group.id);

            //Then
            expect(fetchedGroup.toString(), group.toString());
          });
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    });

    group('stream projects', () {
      projects.ProjectModel addProject(
        RealmDbProjectsRepository realmRepo,
        String groupId,
        String name,
      ) {
        final project = projects.ProjectModel(name: name, groupId: groupId);
        realmRepo.addProject(project);
        return project;
      }

      testWidgets(
        'GIVEN valid project are added into the db '
        'WHEN when streamProjectsByGroupId is called '
        'THEN the projects are streamed ',
        (tester) async {
          await tester.runAsync(() async {
            // Given
            final realmGroupsRepo =
                RealmRepoTester.makeRealmGroupsRepoInstance(realms);
            final group = groups.GroupModel(name: 'Test Group');
            await realmGroupsRepo.repo.addGroup(group);

            final realmProjectRepo =
                RealmRepoTester.makeRealmProjectsRepoInstance(
              realmGroupsRepo.realm,
            );
            final project1 =
                addProject(realmProjectRepo, group.id, 'project 1');
            final project2 =
                addProject(realmProjectRepo, group.id, 'project 2');

            expect(
              // WHEN
              realmProjectRepo.streamProjectsByGroupId(group.id),
              // THEN
              emitsInOrder([
                <projects.ProjectModel>[],
                <projects.ProjectModel>[project1],
                <projects.ProjectModel>[project1, project2],
              ]),
            );
          });
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    });
  });
}
