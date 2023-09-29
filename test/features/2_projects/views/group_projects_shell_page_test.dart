import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../1_groups/robots/group_projects_shell_page_robot.dart';
import '../../1_groups/robots/patrol_test_robot.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('ProjectShellPage', () {
    patrolWidgetTest(
      'GIVEN a GroupProjectsShellPage opens with an unknown groupId '
      'WHEN the page is built '
      'THEN the page should show a LoadingErrorWidget',
      (tester) async {
        // Given
        final result = GroupProjectsShellPageRobot.makeRepo();
        final robot = PatrolTestRobot(tester)
          ..makeGroupProjectsShellPageRobot(result.repo);

        // WHEN
        await robot.pumpWidget(
          const GroupProjectsShellPage(
            groupId: '123',
          ),
        );

        // THEN
        await robot.groupProjectsShellPage!.expectLoadingErrorWidget();
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    patrolWidgetTest(
      'GIVEN a GroupProjectsShellPage opens with valid groupId '
      'AND there are no projects for the group '
      'WHEN the page is built '
      'THEN the page should show a NoItemsFoundWidget',
      (tester) async {
        // GIVEN
        final result = GroupProjectsShellPageRobot.makeRepo();
        final robot = PatrolTestRobot(tester)
          ..makeGroupProjectsShellPageRobot(result.repo);

        // WHEN
        await robot.pumpWidget(
          GroupProjectsShellPage(
            groupId: result.group.id,
          ),
        );

        // THEN
        await robot.groupProjectsShellPage!.noItemsFoundWidget();

        // await tester(#emailInput).enterText('user@leancode.co');
        // await tester(#passwordInput).enterText('ny4ncat');

        // // Finds all widgets with text 'Log in' which are descendants of widgets with key
        // // box1, which are descendants of a Scaffold widget and tap on the first one.
        // await tester(Scaffold).tester(#box1).tester('Log in').tap();

        // // Finds all Scrollables which have Text descendant
        // tester(Scrollable).containing(Text);

        // // Finds all Scrollables which have a Button descendant which has a Text descendant
        // tester(Scrollable).containing(tester(Button).containing(Text));

        // // Finds all Scrollables which have a Button descendant and a Text descendant
        // tester(Scrollable).containing(Button).containing(Text);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    patrolWidgetTest(
      'GIVEN a GroupProjectsShellPage opens with valid groupId '
      'AND there are 2 projects for the group '
      'WHEN the page is built '
      'THEN the page should show 2 Projects',
      (tester) async {
        // GIVEN
        final result = GroupProjectsShellPageRobot.makeRepo(projectCount: 2);
        final robot = PatrolTestRobot(tester)
          ..makeGroupProjectsShellPageRobot(result.repo);

        // WHEN
        await robot.pumpWidget(
          GroupProjectsShellPage(
            groupId: result.group.id,
          ),
        );

        // THEN
        await robot.groupProjectsShellPage!.expectProjects(result.projects);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    patrolWidgetTest(
      'GIVEN a GroupProjectsShellPage opens with valid groupId '
      'WHEN the page is built '
      'THEN the title should be the group name ',
      (tester) async {
        // GIVEN
        final result = GroupProjectsShellPageRobot.makeRepo(projectCount: 2);
        final robot = PatrolTestRobot(tester)
          ..makeGroupProjectsShellPageRobot(result.repo);

        // WHEN
        await robot.pumpWidget(
          GroupProjectsShellPage(
            groupId: result.group.id,
          ),
        );

        // THEN
        await robot.groupProjectsShellPage!.expectHeader(result.group.name);
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );

    patrolWidgetTest(
      'GIVEN a GroupProjectsShellPage opens with valid groupId '
      'WHEN DeleteIcon is tapped '
      'THEN the page should show a BottomSheet',
      (tester) async {
        // GIVEN
        final result = GroupProjectsShellPageRobot.makeRepo(projectCount: 2);
        final robot = PatrolTestRobot(tester)
          ..makeGroupProjectsShellPageRobot(result.repo);

        await robot.pumpWidget(
          GroupProjectsShellPage(
            groupId: result.group.id,
          ),
        );

        // WHEN
        await robot.groupProjectsShellPage!.tapDeleteIcon();

        // THEN
        await robot.groupProjectsShellPage!.expectDeleteBottomSheet();
        await robot.groupProjectsShellPage!.closeDeleteBottomSheet();
      },
      timeout: const Timeout(Duration(seconds: 5)),
    );
  });
}
