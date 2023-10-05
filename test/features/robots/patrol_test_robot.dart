import 'package:patrol_finders/patrol_finders.dart';

import '../mock_realm_db_repositories.dart';
import 'add_project_screen_robot.dart';
import 'group_projects_shell_page_robot.dart';
import 'project_shell_screen_robot.dart';

class PatrolTestRobot {
  PatrolTestRobot(this.$);

  final PatrolTester $;

  GroupProjectsShellPageRobot? groupProjectsShellPage;
  AddProjectScreenRobot? addProjectScreenRobot;
  ProjectShellScreenRobot? projectShellScreenRobot;
  // Widget _makeTestableWidget(Widget widget, ProviderContainer container) {
  //   // final gorouterMock = MockGorouter();
  //   // when(gorouterMock.canPop).thenReturn(true);

  //   return UncontrolledProviderScope(
  //     container: container,
  //     child: MaterialApp(
  //       supportedLocales: AppLocalizations.supportedLocales,
  //       localizationsDelegates: AppLocalizations.localizationsDelegates,
  //       home: InheritedGoRouter(
  //         goRouter: gorouterMock,
  //         child: widget,
  //       ),
  //     ),
  //   );
  // }

  void makeGroupProjectsShellPageRobot(MockRealmDbProjectsRepository repo) {
    groupProjectsShellPage = GroupProjectsShellPageRobot.patrol($, repo);
  }

  void makeAddProjectScreenRobot(MockRealmDbProjectsRepository repo) {
    addProjectScreenRobot = AddProjectScreenRobot.patrol($, repo);
  }

  void makeProjectShellScreenRobot(
    MockRealmDbProjectShellScreenRepository screenRepo,
    MockRealmDbProjectTimerPageRepository timerRepo,
  ) {
    projectShellScreenRobot =
        ProjectShellScreenRobot.patrol($, screenRepo, timerRepo);
  }

  // Future<void> pumpWidget(Widget widget) async {
  //   final overrides = <Override>[];
  //   groupProjectsShellPage?.getOverride(overrides);

  //   final container = ProviderContainer(
  //     overrides: overrides,
  //   );
  //   await disableOverflowErrorsFor(() async {
  //     await $.pumpWidgetAndSettle(
  //       _makeTestableWidget(widget, container),
  //     );
  //   });

  //   expect(
  //     $(widget.runtimeType),
  //     findsOneWidget,
  //   );
  // }
}
