// ignore_for_file: lines_longer_than_80_chars
// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_time/features/1_groups/1_groups.dart';
// import 'package:my_time/features/2_projects/2_projects.dart' as projects;

// import 'package:patrol_finders/patrol_finders.dart';

// import '../../robots/group_projects_shell_page_robot.dart';
// import '../../robots/group_screen_robot.dart';
// import '../../robots/patrol_test_robot.dart';
// import '../../robots/project_shell_screen_robot.dart';
// import '../../robots/test_robot.dart';

// void main() {
//   setUpAll(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//   });

//   group('ProjectShellPage', () {
//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'AND there are no projects for the group '
//       'WHEN the page is built '
//       'THEN the page should show a NoItemsFoundWidget',
//       (tester) async {
//         // GIVEN
//         final result = await prepareGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//         );

//         // WHEN
//         await result.testRobot.groupsScreen!.clickGroupTile(result.groups[0]);

//         // THEN
//         await result.robot.groupProjectsShellPage!.expectNoItemsFoundWidget();
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'AND there are 2 projects for the group '
//       'WHEN the page is built '
//       'THEN the page should show 2 Projects',
//       (tester) async {
//         // GIVEN
//         final result = await prepareGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//           projectCount: 2,
//         );
//         // WHEN
//         await result.testRobot.groupsScreen!.clickGroupTile(result.groups[0]);

//         // THEN
//         await result.robot.groupProjectsShellPage!
//             .expectProjects(result.projects);
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'WHEN the page is built '
//       'THEN the title should be the group name ',
//       (tester) async {
//         // GIVEN
//         final groupResult = GroupScreenRobot.makeGroupsRepo(groupsCount: 1);
//         final testRobot = TestRobot(tester.tester)
//           ..makeGroupScreenRobot(groupResult.repo);

//         final result = GroupProjectsShellPageRobot.makeRepo(
//           projectCount: 2,
//           groupId: groupResult.groups[0].id,
//           groupName: groupResult.groups[0].name,
//         );
//         final robot = PatrolTestRobot(tester)
//           ..makeGroupProjectsShellPageRobot(result.repo);

//         await testRobot.pumpMyApp(
//           getOverrides: <GetOverrideFunction>[
//             robot.groupProjectsShellPage!.getOverride,
//           ],
//         );

//         // WHEN
//         await testRobot.groupsScreen!.clickGroupTile(groupResult.groups[0]);

//         // THEN
//         await robot.groupProjectsShellPage!.expectHeader(result.group.name);
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'WHEN DeleteIcon is tapped '
//       'THEN the page should show a BottomSheet',
//       (tester) async {
//         // GIVEN
//         final result = await openGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//           projectCount: 2,
//         );

//         // WHEN
//         await result.robot.groupProjectsShellPage!.tapDeleteIcon();

//         // THEN
//         await result.robot.groupProjectsShellPage!.expectDeleteBottomSheet();
//         await result.robot.groupProjectsShellPage!.closeDeleteBottomSheet();
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'AND DeleteIcon is tapped '
//       'WHEN Delete is Confirmed in the BottomSheet '
//       'THEN the Group should be deleted and the page should be closed',
//       (tester) async {
//         // GIVEN
//         final result = await openGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//           projectCount: 2,
//         );
//         await result.robot.groupProjectsShellPage!.tapDeleteIcon();
//         await result.robot.groupProjectsShellPage!.expectDeleteBottomSheet();

//         // WHEN
//         await result.robot.groupProjectsShellPage!.deleteGroup();

//         // THEN
//         await result.robot.groupProjectsShellPage!
//             .expectGroupProjectPageIsClosed();
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'WHEN DeleteIcon is tapped '
//       'THEN the AddGroupScreen opens',
//       (tester) async {
//         // GIVEN
//         final result = await openGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//           projectCount: 2,
//         );

//         // WHEN
//         await result.robot.groupProjectsShellPage!.tapAddIcon();

//         // THEN
//         await result.robot.addProjectScreenRobot!.expectIsOpen();
//         await result.robot.addProjectScreenRobot!.closeInPatrolTest();
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );

//     patrolWidgetTest(
//       'GIVEN a GroupProjectsShellPage opens with valid groupId '
//       'AND there are Projects '
//       'WHEN a ProjectTile is tapped '
//       'THEN ProjectShellPage opens',
//       (tester) async {
//         // GIVEN
//         final result = await openGroupsProjectShellPage(
//           tester,
//           groupsCount: 1,
//           projectCount: 2,
//         );

//         // WHEN
//         await result.robot.groupProjectsShellPage!
//             .tapProjectTile(result.projects[0].name);

//         // THEN
//         await result.robot.projectShellScreenRobot!.expectIsOpen();
//         await result.robot.projectShellScreenRobot!.closeInPatrolTest();
//       },
//       timeout: const Timeout(Duration(seconds: 5)),
//     );
//   });
// }

// Future<({PatrolTestRobot robot, List<projects.ProjectModel> projects})>
//     openGroupsProjectShellPage(
//   PatrolTester tester, {
//   int groupsCount = 0,
//   int projectCount = 0,
// }) async {
//   final result = await prepareGroupsProjectShellPage(
//     tester,
//     groupsCount: groupsCount,
//     projectCount: projectCount,
//   );
//   await result.testRobot.groupsScreen!.clickGroupTile(result.groups[0]);
//   return (robot: result.robot, projects: result.projects);
// }

// Future<
//     ({
//       PatrolTestRobot robot,
//       TestRobot testRobot,
//       List<GroupModel> groups,
//       List<projects.ProjectModel> projects,
//     })> prepareGroupsProjectShellPage(
//   PatrolTester tester, {
//   int groupsCount = 0,
//   int projectCount = 0,
// }) async {
//   final groupResult = GroupScreenRobot.makeGroupsRepo(groupsCount: groupsCount);
//   final testRobot = TestRobot(tester.tester)
//     ..makeGroupScreenRobot(groupResult.repo);

//   final result = GroupProjectsShellPageRobot.makeRepo(
//     projectCount: projectCount,
//     groupId: groupResult.groups[0].id,
//     groupName: groupResult.groups[0].name,
//   );

//   final projectScreenRepos = ProjectShellScreenRobot.makeRepos(
//     groupId: groupResult.groups[0].id,
//     projectId: result.projects.isNotEmpty ? result.projects[0].id : '',
//     projectName: result.projects.isNotEmpty ? result.projects[0].name : '',
//     isMarkedAsFavourite: false,
//   );

//   final robot = PatrolTestRobot(tester)
//     ..makeGroupProjectsShellPageRobot(result.repo)
//     ..makeAddProjectScreenRobot(result.repo)
//     ..makeProjectShellScreenRobot(
//       projectScreenRepos.screenRepo,
//       projectScreenRepos.timerRepo,
//     );

//   await testRobot.pumpMyApp(
//     getOverrides: <GetOverrideFunction>[
//       robot.groupProjectsShellPage!.getOverride,
//       robot.projectShellScreenRobot!.getOverride,
//     ],
//   );

//   await testRobot.groupsScreen!.clickGroupTile(groupResult.groups[0]);

//   return (
//     robot: robot,
//     testRobot: testRobot,
//     groups: groupResult.groups,
//     projects: result.projects,
//   );
// }
