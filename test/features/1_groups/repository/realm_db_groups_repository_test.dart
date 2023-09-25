import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:realm/realm.dart';

import '../../RealmDBTests/realm_repo_tester.dart';

void main() {
  /// WHEN TESTING REALM YOU FIRST HAFE TO RUN
  /// 'dart run realm install'
  /// BE AWARE THAT YOU HAVE TO RUN THIS COMMAND IN THE CI PIPELINE AS WELL
  group('RealmDbGroupsRepository', () {
    final realms = <Realm>[];

    tearDownAll(() async {
      await RealmRepoTester.tearDownAll(realms);
    });

    GroupModel addGroup(RealmDbGroupsRepository realmRepo, String name) {
      final group = GroupModel(name: name);
      realmRepo.addGroup(group);
      return group;
    }

    group('add Group', () {
      test('valid', () async {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);
        final group = GroupModel(name: 'Test Group');
        final result = await realmRepo.repo.addGroup(group);

        expect(result, true);
      });

      test('same group id throws exception', () async {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);
        final group = addGroup(realmRepo.repo, 'group 1');

        await expectLater(
          () => realmRepo.repo.addGroup(group),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('streamGroup', () {
      test('get all groups with count = 0', () {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);

        expect(
          realmRepo.repo.streamGroups(),
          emitsInOrder([]),
        );
      });

      test('get all groups with count = 1', () {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);

        final group = addGroup(realmRepo.repo, 'group 1');

        expect(
          realmRepo.repo.streamGroups(),
          emitsInOrder([
            <GroupModel>[],
            <GroupModel>[group],
          ]),
        );
      });

      test('get all groups with count = 2', () {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);

        final group1 = addGroup(realmRepo.repo, 'group 1');
        final group2 = addGroup(realmRepo.repo, 'group 2');

        expect(
          realmRepo.repo.streamGroups(),
          emitsInOrder([
            <GroupModel>[],
            <GroupModel>[group1],
            <GroupModel>[group1, group2],
          ]),
        );
      });
    });

    group('streamFavouriteProjects', () {
      test('get all FavouriteProjects with count = 0', () {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);

        expect(
          realmRepo.repo.streamFavouriteProjects(),
          emitsInOrder([]),
        );
      });
      Future<ProjectModel> addGroupWithFavouriteProjects(
        RealmDbGroupsRepository realmRepo,
        String groupName,
        String groupID,
        String projectName,
        String projectId,
      ) async {
        final groupRealmModel = GroupRealmModel(groupID, name: groupName);

        final projectRealmModel = ProjectRealmModel(
          projectId,
          groupRealmModel.id,
          projectName,
          isMarkedAsFavourite: true,
        );

        final project = ProjectModel.factory(
          name: projectRealmModel.name,
          id: projectRealmModel.id,
        );

        groupRealmModel.projects.add(projectRealmModel);

        await realmRepo.realm.writeAsync(() {
          realmRepo.realm.add(
            groupRealmModel,
          );
        });
        return project;
      }

      test('get all FavouriteProjects with count = 1', () async {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);

        final project = await addGroupWithFavouriteProjects(
          realmRepo.repo,
          'group 1',
          '1',
          'project 1',
          '1',
        );
        expect(
          realmRepo.repo.streamFavouriteProjects(),
          emitsInOrder([
            <ProjectModel>[
              project,
            ],
          ]),
        );
      });

      test('get all FavouriteProjects with count = 2', () async {
        final realmRepo = RealmRepoTester.makeRealmGroupsRepoInstance(realms);
        final projects = <ProjectModel>[
          await addGroupWithFavouriteProjects(
            realmRepo.repo,
            'group 1',
            '1',
            'project 1',
            '1',
          ),
          await addGroupWithFavouriteProjects(
            realmRepo.repo,
            'group 2',
            '2',
            'project 2',
            '2',
          ),
        ];
        await expectLater(
          realmRepo.repo.streamFavouriteProjects(),
          emitsInOrder([
            <ProjectModel>[
              projects[0],
              projects[1],
            ],
          ]),
        );
      });
    });
  });

  group('deviceStorageGroupsRepositoryProvider', () {
    RealmDbGroupsRepository makeRealmDbGroupsRepository() {
      //final realmRepoInstance = makeRealmRepoInstance();
      final container = ProviderContainer(
        overrides: [],
      );
      addTearDown(container.dispose);
      return container.read(deviceStorageGroupsRepositoryProvider);
    }

    test('get deviceStorageGroupsRepository from Provider', () async {
      final realmRepo = makeRealmDbGroupsRepository();
      expect(realmRepo, isA<RealmDbGroupsRepository>());

      final path = realmRepo.realm.config.path;
      realmRepo.realm.close();
      Realm.deleteRealm(path);
      await File('$path.lock').delete();

      expect(realmRepo.realm.isClosed, true);
    });
  });
}
