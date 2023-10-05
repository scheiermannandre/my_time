import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

void main() {
  patrolWidgetTest(
    'GIVEN a valid groupId is passed to the AddProjectScreen '
    'WHEN AddProjectScreen is built '
    'THEN the Screen should show the Group Name',
    (tester) async {
      // // Given
      // final result = AddProjectScreenRobot.makeRepo();
      // final robot = PatrolTestRobot(tester)
      //   ..makeAddProjectScreenRobot(result.repo);

      // // WHEN
      // await robot.pumpWidget(
      //   AddProjectScreen(
      //     groupId: result.group.id,
      //   ),
      // );

      // // THEN
      // await robot.addProjectScreenRobot!
      //     .expectGroupLoadedCorrectly(result.group.name);
    },
    timeout: const Timeout(Duration(seconds: 5)),
  );
}
