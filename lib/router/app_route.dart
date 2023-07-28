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

class AppRoute {
  static String get home => _AppRoute.home.name;
  static String get addGroup => _AppRoute.addGroup.name;
  static String get addProject => _AppRoute.addProject.name;
  static String get group => _AppRoute.group.name;
  static String get project => _AppRoute.project.name;
  static String get timeEntryForm => _AppRoute.timeEntryForm.name;
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
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
          fullscreenDialog: false,
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
          fullscreenDialog: false,
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
          fullscreenDialog: false,
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
          fullscreenDialog: false,
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
            final projectID = state.pathParameters['pid'] ?? "";
            final isEdit = state.uri.queryParameters['isEdit'] ?? "false";
            final tid = state.uri.queryParameters['tid'] ?? "";
            final String projectName = state.uri.queryParameters['pname'] ?? "";
            return MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: TimeEntryFormScreen(
                isEdit: isEdit == "true" ? true : false,
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
