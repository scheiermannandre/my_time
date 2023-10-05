import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/2_projects/views/add_project_screen.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../mock_realm_db_repositories.dart';
import 'test_robot.dart';

typedef MakeRepoReturn = ({
  MockRealmDbProjectsRepository repo,
  GroupModel group,
});

class AddProjectScreenRobot {
  AddProjectScreenRobot(this.tester) : $ = null;
  AddProjectScreenRobot.patrol(this.$, this.repo) : tester = null;

  final WidgetTester? tester;
  final PatrolTester? $;
  MockRealmDbProjectsRepository? repo;

  static MakeRepoReturn makeRepo() {
    final projectsRepo = MockRealmDbProjectsRepository();

    const group = GroupModel.factory(
      id: '1',
      name: 'Group 1',
    );

    when(() => projectsRepo.fetchGroup(group.id)).thenAnswer(
      (_) => Future.value(
        group,
      ),
    );

    return (repo: projectsRepo, group: group);
  }

  Future<void> close() async {
    expect(
      find.byType(AddProjectScreen),
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
        tester!,
        icon,
      );
      if (find.byType(AddProjectScreen).evaluate().isEmpty) {
        break;
      }
    }
    expect(
      find.byType(AddProjectScreen),
      findsNothing,
    );
  }

  Future<void> closeInPatrolTest() async {
    expect(
      $!(AddProjectScreen),
      findsOneWidget,
    );
    final icon = $!(Icons.arrow_back);

    expect(
      icon,
      findsOneWidget,
    );

    // The Screen shows an error because the database is not available.
    // An error message is shown which has to be dismissed first.
    for (var i = 0; i < 2; i++) {
      await icon.tap(
        settlePolicy: SettlePolicy.settle,
        settleTimeout: const Duration(milliseconds: 1000),
      );

      if ($!(AddProjectScreen).evaluate().isEmpty) {
        break;
      }
    }
    expect(
      $!(AddProjectScreen),
      findsNothing,
    );
  }

  Future<void> expectGroupLoadedCorrectly(String groupName) async {
    final groupNameText = $!(groupName);
    expect(
      groupNameText,
      findsOneWidget,
    );
  }

  Future<void> expectIsOpen() async {
    expect(
      $!(AddProjectScreen),
      findsOneWidget,
    );
  }
}
