import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import '../mock_realm_db_groups_repository.dart';
import '../robots/test_robot.dart';

typedef MakeRepoReturn = ({
  MockRealmDbGroupsRepository repo,
  List<GroupModel> groups,
  List<ProjectModel> favProjects,
});

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  group('groupScreen', () {
    MakeRepoReturn makeGroupsRepo({
      int groupsCount = 0,
      int favProjectCount = 0,
      bool streamErrors = false,
    }) {
      final groupsRepo = MockRealmDbGroupsRepository();

      final groups = <GroupModel>[];
      final favProjects = <ProjectModel>[];
      for (var i = 0; i < groupsCount; i++) {
        groups.add(
          GroupModel.factory(
            id: i.toString(),
            name: 'Group $i',
          ),
        );
      }
      for (var i = 0; i < favProjectCount; i++) {
        favProjects.add(
          ProjectModel.factory(
            id: i.toString(),
            name: 'Project $i',
          ),
        );
      }

      if (!streamErrors) {
        when(groupsRepo.streamGroups).thenAnswer(
          (_) => Stream.value(
            groups,
          ),
        );
        when(groupsRepo.streamFavouriteProjects).thenAnswer(
          (_) => Stream.value(
            favProjects,
          ),
        );
      } else {
        when(groupsRepo.streamGroups).thenAnswer(
          (_) => Stream.error(
            Exception('Error'),
          ),
        );
        when(groupsRepo.streamFavouriteProjects).thenAnswer(
          (_) => Stream.error(
            Exception('Error'),
          ),
        );
      }

      return (repo: groupsRepo, groups: groups, favProjects: favProjects);
    }

    testWidgets('Test Hamburger menu', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeGroupScreenBottomSheetRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen.clickHamburger();
        await robot.groupsScreenBottomSheet.expectIsOpen();
        await robot.groupsScreenBottomSheet.expectPrivacyPolicyIsWorking();
        await robot.groupsScreenBottomSheet.expectTermsOfUseIsWorking();
        await robot.groupsScreenBottomSheet.expectShowAboutIsWorking();
        await robot.groupsScreenBottomSheet.close();
      });
    });

    testWidgets('Group Screen contains Header', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo();
        final robot = TestRobot(tester)..makeGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen.expectHeader();
      });
    });

    testWidgets('Empty Groups Screen shows NoItemsFound', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddGroupScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen.expectNoItemsFound();
        await robot.groupsScreen.clickNoItemsFoundBtn();
        await robot.addGroupScreen.close();
      });
    });

    testWidgets('Groups Screen shows 2 GroupTiles', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo(groupsCount: 2);
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeGroupProjectsShellPageRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen.expectGroups(2, result.groups);
        await robot.groupsScreen.clickGroupTile(result.groups[0]);
        await robot.groupProjectsShellPage.close();
      });
    });

    testWidgets('Groups Screen shows favourite Projects', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo(groupsCount: 2, favProjectCount: 2);

        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeProjectShellScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen
            .expectFavProjectsTileIsWorking(1, result.favProjects);
        await robot.groupsScreen.clickProjectTile(result.favProjects[0]);
        await robot.projectShellScreen.close();
        debugPrint('Stage 1 Works');
      });
    });

    testWidgets('Open Add Group Screen via RoundedLabelButton', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddGroupScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen.openAddGroupScreen();
        await robot.addGroupScreen.close();
      });
    });

    testWidgets('Open Add Project Screen via RoundedLabelButton',
        (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddProjectScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen.openAddProjectScreen();
        await robot.addProjectScreen.close();
      });
    });

    testWidgets('Loading Error', (tester) async {
      await tester.runAsync(() async {
        final result = makeGroupsRepo(streamErrors: true);
        final robot = TestRobot(tester)..makeGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen.expectLoadingErrorWidget();
      });
    });
  });
}
