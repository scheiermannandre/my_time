import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/common/screens/shell_screen.dart';
import 'package:my_time/features/1_groups/views/add_group_screen.dart';
import 'package:my_time/features/2_projects/views/add_project_screen.dart';
import 'package:my_time/features/2_projects/views/group_projects_shell_page.dart';
import 'package:my_time/features/3_project_timer_page/view/project_shell_screen.dart';
import 'package:my_time/features/3_project_timer_page/view/project_timer_shell_page.dart';
import 'package:my_time/features/4_time_entry_form/view/time_entry_form_screen.dart';
import 'package:my_time/features/5_project_history/view/proejct_history_shell_page.dart';
import 'package:my_time/features/6_group_analytics/view/group_analytics_shell_page.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/add_project_wizard/add_project_wizard.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/groups_overview.dart';
import 'package:my_time/features/7_groups_overview/presentation/pages/project_settings_page.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/8_authentication/presentation/pages/auth_actioncode_handler_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/auth_reset_password_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/forgot_password_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/profile_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/sign_in_page.dart';
import 'package:my_time/features/8_authentication/presentation/pages/sign_up_page.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_days_off_wizard/add_days_off_wizard.dart';
import 'package:my_time/features/9_timer/presentation/pages/add_entry_wizard/add_entry_wizard.dart';
import 'package:my_time/features/9_timer/presentation/pages/timer_page.dart';
import 'package:my_time/router/go_router_refresh_stream.dart';
import 'package:my_time/router/not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_route.g.dart';

enum _AppRoute {
  home,
  signIn,
  addGroup,
  addProject,
  group,
  project,
  timeEntryForm,
  addProjectWizard,
  authHandler,
  resetPassword,
  signUp,
  forgotPassword,
  profile,
  timer,
  projectSettings,
  addEntryWizard,
  addDaysOffWizard,
}

/// The routes of the app.
class AppRoute {
  /// The fast access to the home route.
  static String get home => _AppRoute.home.name;

  /// The fast access to the auth route.
  static String get signIn => _AppRoute.signIn.name;

  /// The fast access to the signUp route.
  static String get signUp => _AppRoute.signUp.name;

  /// The fast access to the forgotPassword route.
  static String get forgotPassword => _AppRoute.forgotPassword.name;

  /// The fast access to the forgotPassword route.
  static String get profile => _AppRoute.profile.name;

  /// The fast access to the authHandler route.
  static String get authHandler => _AppRoute.authHandler.name;

  /// The fast access to the resetPassword route.
  static String get resetPassword => _AppRoute.resetPassword.name;

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

  /// The fast access to the add project wizard route.
  static String get addProjectWizard => _AppRoute.addProjectWizard.name;

  /// The fast access to the timer route.
  static String get timer => _AppRoute.timer.name;

  /// The fast access to the timer route.
  static String get projectSettings => _AppRoute.projectSettings.name;

  /// The fast access to the add entry wizard route.
  static String get addEntryWizard => _AppRoute.addEntryWizard.name;

  /// The fast access to the add days off wizard route.
  static String get addDaysOffWizard => _AppRoute.addDaysOffWizard.name;
}

/// Gorouter for the app.
///
// @Riverpod(keepAlive: true)
@riverpod
GoRouter goRouter(GoRouterRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  //final user = ref.watch(currentUserStreamProvider);
  return GoRouter(
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges),
    initialLocation: '/signIn',
    redirect: (context, state) async {
      final user = authRepo.currentUser;
      final isLoggedIn = user != null;
      final isVerified = user?.emailVerified ?? false;
      final path = state.uri.path;
      if (isLoggedIn && isVerified) {
        if (path == '/signIn' ||
            path == '/signUp' ||
            path == '/forgotPassword' ||
            path == '') {
          return '/';
        }
      } else {
        if (path == '/authHandler' ||
            path.startsWith('/resetPassword/') ||
            path == '/signIn' ||
            path == '/signUp' ||
            path == '/forgotPassword') {
          return null;
        }
        return '/signIn';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: const Duration(milliseconds: 200),
            child: SignInPage(
              email: state.uri.queryParameters['email'],
              password: state.uri.queryParameters['password'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
      GoRoute(
        path: '/signUp',
        name: AppRoute.signUp,
        pageBuilder: (context, state) => CustomTransitionPage<void>(
          key: state.pageKey,
          child: SignUpPage(
            email: state.uri.queryParameters['email'],
            password: state.uri.queryParameters['password'],
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: animation.drive(
              Tween<Offset>(
                begin: const Offset(-1, 0),
                end: Offset.zero,
              ).chain(CurveTween(curve: Curves.easeIn)),
            ),
            child: child,
          ),
        ),
      ),
      GoRoute(
        path: '/forgotPassword',
        name: AppRoute.forgotPassword,
        pageBuilder: (context, state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: ForgotPasswordPage(
              email: state.uri.queryParameters['email'],
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
              position: animation.drive(
                Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)),
              ),
              child: child,
            ),
          );
        },
      ),
      GoRoute(
        path: '/authHandler',
        name: AppRoute.authHandler,
        redirect: (context, state) {
          final hasCode = state.uri.queryParameters['oobCode'] != null;
          final hasMode = state.uri.queryParameters['mode'] != null;
          if (!hasMode && !hasCode) {
            return '/signIn';
          }
          return null;
        },
        builder: (context, state) => AuthActionCodeHandlerPage(
          oobCode: state.uri.queryParameters['oobCode']!,
          mode: state.uri.queryParameters['mode']!,
        ),
      ),
      GoRoute(
        redirect: (context, state) {
          final hasCode = state.pathParameters['oobCode'] != null;
          if (!hasCode) {
            return '/signIn';
          }
          return null;
        },
        path: '/resetPassword/:oobCode',
        name: AppRoute.resetPassword,
        builder: (context, state) {
          return AuthRestPasswordPage(
            oobCode: state.pathParameters['oobCode']!,
          );
        },
      ),
      GoRoute(
        path: '/',
        name: AppRoute.home,
        builder: (context, state) => const GroupsOverview(),
        routes: [
          GoRoute(
            path: 'profile',
            name: AppRoute.profile,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
          GoRoute(
            path: 'timer',
            name: AppRoute.timer,
            pageBuilder: (context, state) => MaterialPage<void>(
              fullscreenDialog: true,
              key: state.pageKey,
              child: TimerPage(
                groupId: state.uri.queryParameters['groupId'] ?? '',
                projectId: state.uri.queryParameters['projectId'] ?? '',
                projectName: state.uri.queryParameters['projectName'] ?? '',
              ),
            ),
            routes: [
              GoRoute(
                path: 'projectsettings',
                name: AppRoute.projectSettings,
                builder: (context, state) => ProjectSettingsPage(
                  groupId: state.uri.queryParameters['groupId'] ?? '',
                  projectId: state.uri.queryParameters['projectId'] ?? '',
                  projectName: state.uri.queryParameters['projectName'] ?? '',
                ),
              ),
              GoRoute(
                path: 'addentrywizard',
                name: AppRoute.addEntryWizard,
                builder: (context, state) => AddEntryWizard(
                  groupId: state.uri.queryParameters['groupId'] ?? '',
                  projectId: state.uri.queryParameters['projectId'] ?? '',
                ),
              ),
              GoRoute(
                path: 'adddaysoffwizard',
                name: AppRoute.addDaysOffWizard,
                builder: (context, state) => AddDaysOffWizard(
                  groupId: state.uri.queryParameters['groupId'] ?? '',
                  projectId: state.uri.queryParameters['projectId'] ?? '',
                  entryType:
                      int.parse(state.uri.queryParameters['entryType'] ?? '0'),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/addProjectWizard',
        name: AppRoute.addProjectWizard,
        pageBuilder: (context, state) => MaterialPage<void>(
          fullscreenDialog: true,
          key: state.pageKey,
          child: const AddProjectWizard(),
        ),
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
                ),
                GroupAnalyticsShellPage(
                  groupId: groupId,
                ),
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
                ),
                ProjectHistoryShellPage(projectId: projectId),
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
}
