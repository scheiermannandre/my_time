import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/projects_groups/groups/presentation/groups_screen/groups_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/new_project_screen/new_project_page.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/add_project_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/group_settings.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/groups_list_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/group_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_screen/project_screen.dart';
import 'package:my_time/router/not_found_screen.dart';

enum _AppRoute {
  home,
  groups,
  project,
  addProject,
  group,
  groupSettings,
  addProjectToGroup,
  addProjectFromHome,
  addProjectFromGroup,
}

class AppRoute {
  static String get home => _AppRoute.home.name;
  static String get groups => _AppRoute.groups.name;
  static String get group => _AppRoute.group.name;

  static String get addProject => _AppRoute.addProject.name;
  static String get project => _AppRoute.project.name;
  static String get groupSettings => _AppRoute.groupSettings.name;
  static String get addProjectToGroup => _AppRoute.addProjectToGroup.name;
  static String get addProjectFromHome => _AppRoute.addProjectFromHome.name;
  static String get addProjectFromGroup => _AppRoute.addProjectFromGroup.name;
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const GroupsListScreen(),
      routes: [
        GoRoute(
          path: 'addprojectfromhome',
          name: AppRoute.addProjectFromHome,
          pageBuilder: (context, state) {
            final initialPageStr = state.extra as String;
            InitialLocation initialPage = InitialLocation.values.firstWhere(
                (e) => e.name == initialPageStr,
                orElse: () => InitialLocation.group);

            return MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: AddProjectScreen(
                initialPage: initialPage,
              ),
            );
          },
        ),
        GoRoute(
          path: 'groups',
          name: AppRoute.groups,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: const GroupsScreen(),
            );
          },
        ),
        GoRoute(
          path: 'addProject',
          name: AppRoute.addProject,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: const NewProjectScreen(),
            );
          },
        ),
        GoRoute(
          path: 'group/:gid',
          name: AppRoute.group,
          pageBuilder: (context, state) {
            final groupId = state.params['gid']!;
            return MaterialPage(
              key: state.pageKey,
              fullscreenDialog: false,
              child: GroupScreen(groupId: groupId),
            );
          },
          routes: [
            GoRoute(
              path: 'settings',
              name: AppRoute.groupSettings,
              pageBuilder: (context, state) {
                final groupName = state.params['gid']!;
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: false,
                  child: GroupSettings(
                    groupName: groupName,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'addprojectfromgroup',
              name: AppRoute.addProjectFromGroup,
              pageBuilder: (context, state) {
                final groupName = state.params['gid']!;
                final initialPageStr = state.extra as String;
                InitialLocation initialPage = InitialLocation.values.firstWhere(
                    (e) => e.name == initialPageStr,
                    orElse: () => InitialLocation.group);

                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: false,
                  child: AddProjectScreen(
                    group: groupName,
                    initialPage: initialPage,
                  ),
                );
              },
            ),
            GoRoute(
              path: 'project/:pid',
              name: AppRoute.project,
              pageBuilder: (context, state) {
                final productId = state.params['pid']!;
                return MaterialPage(
                  key: state.pageKey,
                  fullscreenDialog: false,
                  child: ProjectScreen(projectId: productId),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);
