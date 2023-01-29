import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/features/projects_groups/groups/presentation/groups_screen/groups_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/new_project_screen/new_project_page.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_list_screen/projects_list_screen.dart';
import 'package:my_time/features/projects_groups/projects/presentation/project_screen/project_screen.dart';
import 'package:my_time/router/not_found_screen.dart';

enum _AppRoute {
  home,
  groups,
  project,
  addProject,
}

class AppRoute {
  static String get home => _AppRoute.home.name;
  static String get groups => _AppRoute.groups.name;
  static String get addProject => _AppRoute.addProject.name;
  static String get project => _AppRoute.project.name;
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.home,
      builder: (context, state) => const ProjectsListScreen(),
      routes: [
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
          path: 'project/:id',
          name: AppRoute.project,
          pageBuilder: (context, state) {
            final productId = state.params['id']!;
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
  errorBuilder: (context, state) => const NotFoundScreen(),
);
