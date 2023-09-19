import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/common/common.dart';
import 'package:my_time/features/1_groups/1_groups.dart';
import 'package:my_time/features/1_groups/views/add_group_screen.dart';
import 'package:my_time/features/1_groups/views/groups_screen.dart';
import '../mock_realm_db_groups_repository.dart';
import 'test_robot.dart';

class AddGroupScreenRobot {
  AddGroupScreenRobot(this.tester, this.groupsRepo);
  final WidgetTester tester;
  final MockRealmDbGroupsRepository groupsRepo;

  void getOverride(List<Override> overrides) {
    overrides.add(
      deviceStorageGroupsRepositoryProvider.overrideWithValue(groupsRepo),
    );
  }

  static MockRealmDbGroupsRepository makeGroupsRepo() {
    final groupsRepo = MockRealmDbGroupsRepository();

    final groups = <GroupModel>[];
    final favProjects = <ProjectModel>[];

    when(groupsRepo.streamGroups).thenAnswer(
      (_) => Stream.value(
        groups,
      ),
    );
    when(groupsRepo.streamFavouriteProjects).thenAnswer(
      (_) => Stream.value(
        favProjects,
      ),
    );
    return groupsRepo;
  }

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

  Future<void> expectHeader() async {
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
    expect(
      find.text('New Group'),
      findsOneWidget,
    );
  }

  Future<void> expectGroupNameInputField() async {
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
    expect(
      find.text('Name'),
      findsOneWidget,
    );
    expect(
      find.byType(GroupNameField),
      findsOneWidget,
    );
    final textfield = find.byType(TextField);
    expect(textfield, findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'Group 1');
    expect(find.text('Group 1'), findsOneWidget);
  }

  Future<void> clickSubmit() async {
    expect(
      find.byType(AddGroupScreen),
      findsOneWidget,
    );
    final btn = find.byType(NavBarSubmitButton);

    when(
      () => groupsRepo.addGroup(
        any(),
      ),
    ).thenAnswer(
      (_) => Future.value(
        true,
      ),
    );
    await TestRobot.clickWidget(tester, btn);
    expect(
      find.byType(AddGroupScreen),
      findsNothing,
    );
    expect(
      find.byType(GroupsScreen),
      findsNothing,
    );
  }
}
