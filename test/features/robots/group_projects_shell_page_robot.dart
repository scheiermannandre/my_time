import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/2_projects/2_projects.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../mock_realm_db_repositories.dart';
import 'test_robot.dart';

typedef MakeRepoReturn = ({
  MockRealmDbProjectsRepository repo,
  GroupModel group,
  List<ProjectModel> projects,
});

class GroupProjectsShellPageRobot {
  GroupProjectsShellPageRobot(this.tester) : $ = null;
  GroupProjectsShellPageRobot.patrol(this.$, this.repo) : tester = null;

  final WidgetTester? tester;
  final PatrolTester? $;
  MockRealmDbProjectsRepository? repo;

  static MakeRepoReturn makeRepo({
    required String groupId,
    required String groupName,
    int projectCount = 0,
    bool streamErrors = false,
  }) {
    final projectsRepo = MockRealmDbProjectsRepository();

    final projects = <ProjectModel>[];
    final group = GroupModel.factory(
      id: groupId,
      name: groupName,
    );

    for (var i = 0; i < projectCount; i++) {
      projects.add(
        ProjectModel.factory(
          id: i.toString(),
          name: 'Project $i',
          groupId: group.id,
        ),
      );
    }

    when(() => projectsRepo.streamProjectsByGroupId(group.id)).thenAnswer(
      (_) => Stream.value(
        projects,
      ),
    );
    when(() => projectsRepo.fetchGroup(group.id)).thenAnswer((_) {
      return Future.value(
        group,
      );
    });

    return (repo: projectsRepo, group: group, projects: projects);
  }

  void getOverride(List<Override> overrides) {
    overrides.add(
      deviceStorageProjectsRepositoryProvider.overrideWithValue(repo!),
    );
  }

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
      tester!,
      icon,
    );
    expect(
      find.byType(GroupProjectsShellPage),
      findsNothing,
    );
  }

  Future<void> expectLoadingErrorWidget() async {
    expect(
      $!(LoadingErrorWidget),
      findsOneWidget,
    );
  }

  Future<void> expectNoItemsFoundWidget() async {
    expect($!(NoItemsFoundWidget), findsOneWidget);
  }

  Future<void> expectProjects(List<ProjectModel> projects) async {
    for (final project in projects) {
      expect(
        $!(CustomListTile).containing(project.name),
        findsOneWidget,
      );
    }
  }

  Future<void> expectHeader(String groupName) async {
    expect(
      $!(CustomAppBar).containing(groupName),
      findsOneWidget,
    );
  }

  Future<void> tapDeleteIcon() async {
    final icon = $!(CustomAppBar).$(IconButton).$(Icons.delete);

    expect(
      icon,
      findsOneWidget,
    );
    await icon.tap(
      settlePolicy: SettlePolicy.settle,
      settleTimeout: const Duration(seconds: 1),
    );
  }

  Future<void> tapAddIcon() async {
    final icon = $!(CustomAppBar).$(IconButton).$(Icons.add);

    expect(
      icon,
      findsOneWidget,
    );
    await icon.tap(
      settlePolicy: SettlePolicy.settle,
      settleTimeout: const Duration(seconds: 1),
    );
  }

  Future<void> tapProjectTile(String projectName) async {
    final projecttile = $!(CustomListTile).$(projectName);

    expect(
      projecttile,
      findsOneWidget,
    );
    await projecttile.tap(
      settlePolicy: SettlePolicy.settle,
      settleTimeout: const Duration(seconds: 1),
    );
  }

  Future<void> expectDeleteBottomSheet() async {
    expect(
      $!(ModalBottomSheet),
      findsOneWidget,
    );
  }

  Future<void> closeDeleteBottomSheet() async {
    final cancelBtn = $!(ModalBottomSheet).$('Cancel');

    expect(
      cancelBtn,
      findsOneWidget,
    );
    await cancelBtn.tap(
      settlePolicy: SettlePolicy.settle,
      settleTimeout: const Duration(seconds: 1),
    );

    expect(
      $!(ModalBottomSheet),
      findsNothing,
    );
  }

  Future<void> expectGroupProjectPageIsClosed() async {
    expect(
      $!(GroupProjectsShellPage),
      findsNothing,
    );
  }

  Future<void> deleteGroup() async {
    when(() => repo!.deleteGroup(any())).thenAnswer(
      (_) => Future.value(
        true,
      ),
    );

    final confirmBtn = $!(ModalBottomSheet).$('Confirm');

    expect(
      confirmBtn,
      findsOneWidget,
    );
    await confirmBtn.tap(
      settlePolicy: SettlePolicy.settle,
      settleTimeout: const Duration(seconds: 1),
    );

    expect(
      $!(ModalBottomSheet),
      findsNothing,
    );
  }

  Future<void> expectAddIcon() async {
    expect(
      $!(CustomAppBar).containing(Icons.add),
      findsOneWidget,
    );
  }
}
