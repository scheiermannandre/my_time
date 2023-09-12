import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'test_robot.dart';

class GroupProjectsShellPageRobot {
  GroupProjectsShellPageRobot(this.tester);
  final WidgetTester tester;

  Future<void> close() async {
    expect(
      find.byType(GroupProjectsShellPage),
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
      find.byType(GroupProjectsShellPage),
      findsNothing,
    );
  }
}
