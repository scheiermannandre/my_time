import 'package:flutter_test/flutter_test.dart';
import '../robots/group_screen_robot.dart';
import '../robots/test_robot.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  group('groupScreen', () {
    testWidgets('Test Hamburger menu', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeGroupScreenBottomSheetRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen!.clickHamburger();
        await robot.groupsScreenBottomSheet!.expectIsOpen();
        await robot.groupsScreenBottomSheet!.expectPrivacyPolicyIsWorking();
        await robot.groupsScreenBottomSheet!.expectTermsOfUseIsWorking();
        await robot.groupsScreenBottomSheet!.expectShowAboutIsWorking();
        await robot.groupsScreenBottomSheet!.close();
      });
    });

    testWidgets('Group Screen contains Header', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo();
        final robot = TestRobot(tester)..makeGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.expectHeader();
      });
    });

    testWidgets('Empty Groups Screen shows NoItemsFound', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.expectNoItemsFound();
        await robot.groupsScreen!.clickNoItemsFoundBtn();
        await robot.addGroupScreen!.close();
      });
    });

    testWidgets('Groups Screen shows 2 GroupTiles', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo(groupsCount: 2);
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeGroupProjectsShellPageRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen!.expectGroups(2, result.groups);
        await robot.groupsScreen!.clickGroupTile(result.groups[0]);
        await robot.groupProjectsShellPage!.close();
      });
    });

    testWidgets('Groups Screen shows favourite Projects', (tester) async {
      await tester.runAsync(() async {
        final result =
            GroupScreenRobot.makeGroupsRepo(groupsCount: 2, favProjectCount: 2);

        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeProjectShellScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen!
            .expectFavProjectsTileIsWorking(1, result.favProjects);
        await robot.groupsScreen!.clickProjectTile(result.favProjects[0]);
        await robot.projectShellScreen!.close();
      });
    });

    testWidgets('Open Add Group Screen via RoundedLabelButton', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.openAddGroupScreen();
        await robot.addGroupScreen!.close();
      });
    });

    testWidgets('Open Add Project Screen via RoundedLabelButton',
        (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo();
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeAddProjectScreenRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen!.openAddProjectScreen();
        await robot.addProjectScreen!.close();
      });
    });

    testWidgets('Loading Error', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo(streamErrors: true);
        final robot = TestRobot(tester)..makeGroupScreenRobot(result.repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.expectLoadingErrorWidget();
      });
    });

    testWidgets('Refresh via drag', (tester) async {
      await tester.runAsync(() async {
        final result = GroupScreenRobot.makeGroupsRepo(groupsCount: 2);
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(result.repo)
          ..makeGroupProjectsShellPageRobot();
        await robot.pumpMyApp();
        await robot.groupsScreen!.dragRefresh(result.groups[0]);
      });
    });
  });
}
