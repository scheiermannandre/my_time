import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_time/features/1_groups/views/groups_screen.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../test_helper.dart';
import '../mock_realm_db_repositories.dart';
import 'group_projects_shell_page_robot.dart';

class PatrolTestRobot {
  PatrolTestRobot(this.$);

  final PatrolTester $;

  GroupProjectsShellPageRobot? groupProjectsShellPage;

  Widget _makeTestableWidget(Widget widget, ProviderContainer container) {
    final gorouterMock = MockGorouter();
    when(gorouterMock.canPop).thenReturn(true);
    // when(() => gorouterMock.pushNamed(any()))
    //     .thenAnswer((_) => Future.value(true));

    when(gorouterMock.pop).thenAnswer((_) {
      Future.delayed(Duration.zero, () {
        $
          ..pumpWidget(
            const GroupsScreen(),
          )
          ..pumpAndSettle();
      });
    });

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: InheritedGoRouter(
          goRouter: gorouterMock,
          child: widget,
        ),
      ),
    );
  }

  void makeGroupProjectsShellPageRobot(MockRealmDbProjectsRepository repo) {
    groupProjectsShellPage = GroupProjectsShellPageRobot.patrol($, repo);
  }

  Future<void> pumpWidget(Widget widget) async {
    final overrides = <Override>[];
    groupProjectsShellPage?.getOverride(overrides);

    final container = ProviderContainer(
      overrides: overrides,
    );
    await disableOverflowErrorsFor(() async {
      await $.pumpWidgetAndSettle(
        _makeTestableWidget(widget, container),
      );
    });

    expect(
      $(widget.runtimeType),
      findsOneWidget,
    );
  }
}
