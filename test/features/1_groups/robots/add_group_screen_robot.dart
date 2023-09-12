import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/1_groups/views/add_group_screen.dart';
import 'test_robot.dart';

class AddGroupScreenRobot {
  AddGroupScreenRobot(this.tester);
  final WidgetTester tester;

  Future<void> close() async {
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
    final icon = find.byIcon(Icons.arrow_back);
    expect(
      icon,
      findsOneWidget,
    );
    await TestRobot.clickWidget(
      tester,
      icon,
    );
    expect(
      find.byType(AddGroupScreen),
      findsNothing,
    );
  }
}
