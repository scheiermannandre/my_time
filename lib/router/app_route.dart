import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/layers/presentation/0_home_screen/groups_list_screen.dart';
import 'package:my_time/layers/presentation/1_add_group_screen/add_group_screen.dart';
import 'package:my_time/layers/presentation/2_add_project_screen/add_project_screen.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/projects_per_group_list_screen.dart';
import 'package:my_time/layers/presentation/4_project_screen/project_screen.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/time_entry_form_screen.dart';
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
      builder: (context, state) => const GroupsListScreen(),
    ),
    GoRoute(
      path: '/group/:gid',
      name: AppRoute.group,
      pageBuilder: (context, state) {
        final groupId = state.pathParameters['gid']!;
        return MaterialPage(
          key: state.pageKey,
          fullscreenDialog: false,
          child: ProjectsPerGroupListScreen(groupId: groupId),
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
        final groupId = state.queryParameters['gid'];
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
        final productId = state.pathParameters['pid']!;
        return MaterialPage(
          key: state.pageKey,
          fullscreenDialog: false,
          child: ProjectScreen(projectId: productId),
        );
      },
      routes: [
        GoRoute(
          path: 'timeentryform',
          name: AppRoute.timeEntryForm,
          pageBuilder: (context, state) {
            final projectID = state.pathParameters['pid'] ?? "";
            final isEdit = state.queryParameters['isEdit'] ?? "false";
            final tid = state.queryParameters['tid'] ?? "";
            final String projectName = state.queryParameters['pname'] ?? "";
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
