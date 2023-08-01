import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/screens/shell_screen.dart';
import 'package:my_time/features/1_groups/views/add_group_screen.dart';
import 'package:my_time/features/1_groups/views/groups_screen.dart';
import 'package:my_time/features/2_projects/views/add_project_screen.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'package:my_time/features/3_project_timer_page/view/project_shell_screen.dart';
import 'package:my_time/features/3_project_timer_page/view/project_timer_shell_page.dart';
import 'package:my_time/features/4_time_entry_form/view/time_entry_form_screen.dart';
import 'package:my_time/features/5_project_history/view/proejct_history_shell_page.dart';
import 'package:my_time/features/6_group_analytics/view/group_analytics_shell_page.dart';
import 'package:my_time/router/not_found_screen.dart';

enum _AppRoute {
  home,
  addGroup,
  addProject,
  group,
  project,
  timeEntryForm,
}

/// The routes of the app.
class AppRoute {
  /// The fast access to the home route.
  static String get home => _AppRoute.home.name;

  /// The fast access to the add group route.
  static String get addGroup => _AppRoute.addGroup.name;

  /// The fast access to the add project route.
  static String get addProject => _AppRoute.addProject.name;

  /// The fast access to the group route.
  static String get group => _AppRoute.group.name;

  /// The fast access to the project route.
  static String get project => _AppRoute.project.name;

  /// The fast access to the time entry form route.
  static String get timeEntryForm => _AppRoute.timeEntryForm.name;
}

/// Gorouter for the app.
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const GroupsScreen(),
    ),

    // GoRoute(
    //   path: '/group/:gid',
    //   name: AppRoute.group,
    //   pageBuilder: (context, state) {
    //     final groupId = state.pathParameters['gid']!;
    //     return MaterialPage(
    //       key: state.pageKey,
    //       fullscreenDialog: false,
    //       child: ProjectsPerGroupListScreen(groupId: groupId),
    //     );
    //   },
    // ),

    GoRoute(
      path: '/group/:gid',
      name: AppRoute.group,
      pageBuilder: (context, state) {
        final groupId = state.pathParameters['gid']!;
        return MaterialPage(
          key: state.pageKey,
          child: ShellScreen(
            children: [
              GroupProjectsShellPage(
                groupId: groupId,
                context: context,
              ),
              GroupAnalyticsShellPage(
                groupId: groupId,
                context: context,
              )
            ],
          ),
        );
      },
    ),
    GoRoute(
      path: '/newgroup',
      name: AppRoute.addGroup,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const AddGroupScreen(),
        );
      },
    ),
    GoRoute(
      path: '/newproject',
      name: AppRoute.addProject,
      pageBuilder: (context, state) {
        final groupId = state.uri.queryParameters['gid'];
        return MaterialPage(
          key: state.pageKey,
          child: AddProjectScreen(
            groupId: groupId,
          ),
        );
      },
    ),
    GoRoute(
      path: '/project/:pid',
      name: AppRoute.project,
      pageBuilder: (context, state) {
        final projectId = state.pathParameters['pid']!;
        return MaterialPage(
          key: state.pageKey,
          child: ProjectShellScreen(
            projectId: projectId,
            children: [
              ProjectTimerShellPage(
                projectId: projectId,
                context: context,
              ),
              ProjectHistoryShellPage(projectId: projectId, context: context)
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: 'timeentryform',
          name: AppRoute.timeEntryForm,
          pageBuilder: (context, state) {
            final projectID = state.pathParameters['pid'] ?? '';
            final isEdit = state.uri.queryParameters['isEdit'] ?? 'false';
            final tid = state.uri.queryParameters['tid'] ?? '';
            final projectName = state.uri.queryParameters['pname'] ?? '';
            return MaterialPage(
              key: state.pageKey,
              child: TimeEntryFormScreen(
                isEdit: isEdit == 'true',
                timeEntryId: tid,
                projectId: projectID,
                projectName: projectName,
              ),
            );
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
