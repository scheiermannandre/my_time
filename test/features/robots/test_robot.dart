import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/main.dart';

import '../../test_helper.dart';
import '../mock_realm_db_repositories.dart';
import 'add_group_screen_robot.dart';
import 'add_project_screen_robot.dart';
import 'group_projects_shell_page_robot.dart';
import 'group_screen_bottom_sheet_robot.dart';
import 'group_screen_robot.dart';
import 'project_shell_screen_robot.dart';

typedef GetOverrideFunction = void Function(List<Override>);

class TestRobot {
  TestRobot(this.tester);
  final WidgetTester tester;
  GroupScreenRobot? groupsScreen;
  GroupScreenBottomSheetRobot? groupsScreenBottomSheet;
  AddGroupScreenRobot? addGroupScreen;
  GroupProjectsShellPageRobot? groupProjectsShellPage;
  ProjectShellScreenRobot? projectShellScreen;
  AddProjectScreenRobot? addProjectScreen;

  void makeGroupScreenRobot(MockRealmDbGroupsRepository groupsRepo) {
    groupsScreen = GroupScreenRobot(tester, groupsRepo);
  }

  void makeGroupScreenBottomSheetRobot() {
    groupsScreenBottomSheet = GroupScreenBottomSheetRobot(tester);
  }

  void makeAddGroupScreenRobot(MockRealmDbGroupsRepository groupsRepo) {
    addGroupScreen = AddGroupScreenRobot(tester, groupsRepo);
  }

  void makeGroupProjectsShellPageRobot() {
    groupProjectsShellPage = GroupProjectsShellPageRobot(tester);
  }

  void makeProjectShellScreenRobot() {
    projectShellScreen = ProjectShellScreenRobot(tester);
  }

  void makeAddProjectScreenRobot() {
    addProjectScreen = AddProjectScreenRobot(tester);
  }

  Future<void> pumpMyApp({List<GetOverrideFunction>? getOverrides}) async {
    final overrides = <Override>[];
    groupsScreen?.getOverride(overrides);
    addGroupScreen?.getOverride(overrides);

    getOverrides?.forEach((element) {
      element(overrides);
    });
    final container = ProviderContainer(
      overrides: overrides,
    );
    await disableOverflowErrorsFor(() async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MyApp(),
        ),
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
    });
  }

  static Future<void> clickWidget(
    WidgetTester tester,
    Finder widget, {
    bool pumpAndSettle = true,
  }) async {
    await tester.tap(widget);
    await disableOverflowErrorsFor(() async {
      if (pumpAndSettle) {
        await tester.pumpAndSettle(const Duration(milliseconds: 1000));
      } else {
        await tester.pump();
      }
    });
  }

  static Future<void> dragCloseWidget(
    WidgetTester tester,
    Finder widget,
    Offset offset, {
    bool pumpAndSettle = true,
  }) async {
    await tester.drag(widget, offset);
    await disableOverflowErrorsFor(() async {
      if (pumpAndSettle) {
        await tester.pumpAndSettle();
      } else {
        await tester.pump();
      }
    });
  }

  static Future<void> dragWidget(
    WidgetTester tester,
    Finder widget,
    Offset offset, {
    bool pumpAndSettle = true,
  }) async {
    await tester.drag(widget, offset);
  }
}
