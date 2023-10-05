import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/1_groups/1_groups.dart';

import '../../robots/add_group_screen_robot.dart';
import '../../robots/test_robot.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const GroupModel.factory(id: '123', name: 'Group1'));
  });

  group('AddGroupScreen', () {
    testWidgets('Check Header', (tester) async {
      final repo = AddGroupScreenRobot.makeGroupsRepo();

      await tester.runAsync(() async {
        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(repo)
          ..makeAddGroupScreenRobot(repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.openAddGroupScreen();
        await robot.addGroupScreen!.expectHeader();
        await robot.addGroupScreen!.close();
      });
    });

    testWidgets('Type Group Name and Submit', (tester) async {
      await tester.runAsync(() async {
        final repo = AddGroupScreenRobot.makeGroupsRepo();

        final robot = TestRobot(tester)
          ..makeGroupScreenRobot(repo)
          ..makeAddGroupScreenRobot(repo);
        await robot.pumpMyApp();
        await robot.groupsScreen!.openAddGroupScreen();
        await robot.addGroupScreen!.expectGroupNameInputField();
        await robot.addGroupScreen!.clickSubmit();
      });
    });
  });
}
