import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/features/3_project_timer_page/view/project_shell_screen.dart';
import 'test_robot.dart';

class ProjectShellScreenRobot {
  ProjectShellScreenRobot(this.tester);
  final WidgetTester tester;

  Future<void> close() async {
    expect(
      find.byType(ProjectShellScreen),
      findsOneWidget,
    );
    final icon = find.byIcon(Icons.arrow_back);
    expect(
      icon,
      findsOneWidget,
    );

    // The Screen shows an error because the database is not available.
    // An error message is shown which has to be dismissed first.
    for (var i = 0; i < 2; i++) {
      await TestRobot.clickWidget(
        tester,
        icon,
      );
      if (find.byType(ProjectShellScreen).evaluate().isEmpty) {
        break;
      }
    }

    expect(
      find.byType(ProjectShellScreen),
      findsNothing,
    );
  }
}
