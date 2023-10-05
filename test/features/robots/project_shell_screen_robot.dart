import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/features/3_project_timer_page/view/project_shell_screen.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../mock_realm_db_repositories.dart';
import 'test_robot.dart';

typedef MakeRepoReturn = ({
  MockRealmDbProjectShellScreenRepository screenRepo,
  MockRealmDbProjectTimerPageRepository timerRepo,
});

class ProjectShellScreenRobot {
  ProjectShellScreenRobot(this.tester) : $ = null;
  ProjectShellScreenRobot.patrol(this.$, this.screenRepo, this.timerRepo)
      : tester = null;

  final WidgetTester? tester;
  final PatrolTester? $;
  MockRealmDbProjectShellScreenRepository? screenRepo;
  MockRealmDbProjectTimerPageRepository? timerRepo;

  static MakeRepoReturn makeRepos({
    required String groupId,
    required String projectId,
    required String projectName,
    required bool isMarkedAsFavourite,
  }) {
    final projectsRepo = MockRealmDbProjectShellScreenRepository();
    final timerRepo = MockRealmDbProjectTimerPageRepository();

    final project = ProjectModel.factory(
      groupId: groupId,
      id: projectId,
      name: projectName,
      isMarkedAsFavourite: isMarkedAsFavourite,
    );

    final timerData = ProjectTimerModel.factory(
      projectId: projectId,
      id: '123',
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      breakStartTimes: [],
      breakEndTimes: [],
      timerState: TimerState.off.toString(),
    );

    when(() => projectsRepo.fetchProject(projectId)).thenAnswer((_) {
      return Future.value(
        project,
      );
    });

    when(() => timerRepo.fetchTimerData(projectId)).thenAnswer((_) {
      return Future.value(
        timerData,
      );
    });

    return (screenRepo: projectsRepo, timerRepo: timerRepo);
  }

  void getOverride(List<Override> overrides) {
    overrides.addAll([
      projectsRepositoryProvider.overrideWithValue(screenRepo!),
      timerDataRepositoryProvider.overrideWithValue(timerRepo!),
    ]);
  }

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
        tester!,
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

  Future<void> expectProjectShellScreen() async {
    expect(
      $!(ProjectShellScreen),
      findsOneWidget,
    );
  }

  Future<void> closeInPatrolTest() async {
    expect(
      $!(ProjectShellScreen),
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
      if ($!(ProjectShellScreen).evaluate().isEmpty) {
        break;
      }
    }

    expect(
      $!(ProjectShellScreen),
      findsNothing,
    );
  }

  Future<void> expectIsOpen() async {
    expect(
      $!(ProjectShellScreen),
      findsOneWidget,
    );
  }
}
