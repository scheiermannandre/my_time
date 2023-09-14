import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/1_groups/views/add_group_screen.dart';
import 'package:my_time/features/2_projects/views/add_project_screen.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'package:my_time/features/3_project_timer_page/view/project_shell_screen.dart';

import '../mock_realm_db_groups_repository.dart';
import 'test_robot.dart';

class GroupScreenRobot {
  GroupScreenRobot(this.tester, this.groupsRepo);
  final WidgetTester tester;
  final MockRealmDbGroupsRepository groupsRepo;

  Override getOverride() {
    return deviceStorageGroupsRepositoryProvider.overrideWithValue(groupsRepo);
  }

  Future<void> expectHeader() async {
    expect(find.text('Groups'), findsOneWidget);
  }

  Future<void> expectNoItemsFound() async {
    expect(
      find.byType(NoItemsFoundWidget),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.text('No Groups found'), findsOneWidget);
    expect(
      find.text('Click on the button below to add a new Group'),
      findsOneWidget,
    );
  }

  Future<void> clickNoItemsFoundBtn() async {
    final noItemsFoundBtn = find.byType(ElevatedButton);
    expect(
      noItemsFoundBtn,
      findsOneWidget,
    );
    await TestRobot.clickWidget(tester, noItemsFoundBtn);
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
  }

  Future<void> expectGroups(int count, List<GroupModel> groups) async {
    expect(
      find.byType(CustomListTile),
      findsNWidgets(2),
    );
    for (var i = 0; i < count; i++) {
      expect(
        find.text(groups[i].name),
        findsOneWidget,
      );
    }
  }

  Future<void> clickGroupTile(GroupModel group) async {
    await TestRobot.clickWidget(
      tester,
      find.text(group.name),
    );
    expect(
      find.byType(GroupProjectsShellPage),
      findsOneWidget,
    );
  }

  Future<void> expectFavProjectsTileIsWorking(
    int count,
    List<ProjectModel> favProjects,
  ) async {
    final dropDownIcon = await _findAndClickCustomExpansionTile();
    for (var i = 0; i < count; i++) {
      expect(
        find.text(favProjects[i].name),
        findsOneWidget,
      );
    }

    expect(find.byType(Divider), findsWidgets);
    await TestRobot.clickWidget(tester, dropDownIcon);
    for (var i = 0; i < count; i++) {
      expect(
        find.text(favProjects[i].name),
        findsNothing,
      );
    }
  }

  Future<Finder> _findAndClickCustomExpansionTile() async {
    final projectsTile = find.byType(CustomExpansionTile);
    expect(
      projectsTile,
      findsOneWidget,
    );
    final dropDownIcon = find.byKey(CustomExpansionTile.dropDownIconKey);
    expect(
      projectsTile,
      findsOneWidget,
    );
    await TestRobot.clickWidget(tester, dropDownIcon);

    return dropDownIcon;
  }

  Future<void> clickProjectTile(ProjectModel project) async {
    await _findAndClickCustomExpansionTile();

    await TestRobot.clickWidget(
      tester,
      find.text(project.name),
    );
    expect(
      find.byType(ProjectShellScreen),
      findsOneWidget,
    );
  }

  Future<void> clickHamburger() async {
    final hamburger = find.byWidgetPredicate(
      (widget) =>
          widget is AnimatedIcon && widget.icon == AnimatedIcons.menu_close,
    );
    expect(
      hamburger,
      findsOneWidget,
    );

    // Gets the [AnimatedIcon] widget
    final animatedIconWidget = tester.widget(hamburger) as AnimatedIcon;
    final animatedIconProgress = animatedIconWidget.progress.value;
    // Verifies that [AnimatedIcon] is not animating
    expect(animatedIconProgress, 0);

    await TestRobot.clickWidget(tester, hamburger);

    final updatedAnimatedIconProgress = animatedIconWidget.progress.value;
    // Verifies that the [AnimatedIcon] has completed its animation
    expect(updatedAnimatedIconProgress, 1);
  }

  Future<void> openAddGroupScreen() async {
    final addGroupBtnIcon = find.byIcon(Icons.category);
    expect(
      addGroupBtnIcon,
      findsOneWidget,
    );
    await TestRobot.clickWidget(tester, addGroupBtnIcon);
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
  }

  Future<void> openAddProjectScreen() async {
    final addProjectBtnIcon = find.byIcon(Icons.work);
    expect(
      addProjectBtnIcon,
      findsOneWidget,
    );
    await TestRobot.clickWidget(tester, addProjectBtnIcon);
    expect(
      find.byType(AddProjectScreen),
      findsOneWidget,
    );
  }

  Future<void> expectLoadingErrorWidget() async {
    final loadingErrorWidget = find.byType(LoadingErrorWidget);
    expect(
      loadingErrorWidget,
      findsOneWidget,
    );
    final refreshBtn = find.byType(ElevatedButton);
    expect(
      refreshBtn,
      findsOneWidget,
    );
    await TestRobot.clickWidget(tester, refreshBtn);
  }

  Future<void> dragRefresh(GroupModel group) async {
    final handle = tester.ensureSemantics();

    await tester.fling(find.text(group.name), const Offset(0, 300), 1000);
    await tester.pump();
    expect(
      tester.getSemantics(find.byType(RefreshProgressIndicator)),
      matchesSemantics(
        label: 'Refresh',
      ),
    );
    await tester
        .pump(const Duration(seconds: 1)); // finish the scroll animation
    await tester.pump(
      const Duration(seconds: 1),
    ); // finish the indicator settle animation
    await tester.pump(
      const Duration(seconds: 1),
    ); // finish the indicator hide animation
    //await TestRobot.dragCloseWidget(tester, scaffold, const Offset(0, -500));
    handle.dispose();
  }
}
