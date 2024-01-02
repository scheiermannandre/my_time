//ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/firebase_options.dart';
import 'package:my_time/foundation/config/config.dart';
import 'package:my_time/foundation/config/theme/dark_theme.dart';
import 'package:my_time/foundation/config/theme/light_theme.dart';
// import 'package:realm/realm.dart';
// import 'package:my_time/features/0_common/realmModel/realm_model.dart';
import 'package:go_router/go_router.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // final realm = Realm(
  //   Configuration.local([
  //     Group.schema,
  //     GroupRealmModel.schema,
  //     Project.schema,
  //     ProjectRealmModel.schema,
  //     TimeEntry.schema,
  //     TimeEntryRealmModel.schema,
  //   ]),
  // );
  // await realm.writeAsync(() {
  //   try {
  //     realm.deleteAll<Group>();
  //     realm.deleteAll<GroupRealmModel>();
  //     realm.deleteAll<Project>();
  //     realm.deleteAll<ProjectRealmModel>();
  //     realm.deleteAll<TimeEntry>();
  //     realm.deleteAll<TimeEntryRealmModel>();
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // });
  // await realm.writeAsync(() {
  //   try {
  //     realm.add(Group("groupId", name: "group.name", projects: [
  //       Project("projectId", "groupId", "name",
  //           isMarkedAsFavourite: true,
  //           timeEntries: [
  //             TimeEntry(
  //               "entryId",
  //               "projectId",
  //               "groupId",
  //               DateTime.now(),
  //               DateTime.now().add(
  //                 const Duration(hours: 4),
  //               ),
  //               const Duration(hours: 4).toString(),
  //               const Duration(hours: 1).toString(),
  //               description: "description",
  //             )
  //           ])
  //     ]));
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // });
  // final oldGroupsFromDB = realm.all<Group>();

  // await realm.writeAsync(() {
  //   for (var oldGroup in oldGroupsFromDB) {
  //     var newGroup = GroupRealmModel(
  //       oldGroup.id,
  //       name: oldGroup.name,
  //     );
  //     for (var oldProjects in oldGroup.projects) {
  //       var newProject = ProjectRealmModel(
  //         oldProjects.id,
  //         oldProjects.groupId,
  //         oldProjects.name,
  //         isMarkedAsFavourite: oldProjects.isMarkedAsFavourite,
  //       );
  //       for (var oldEntry in oldProjects.timeEntries) {
  //         var newEntry = TimeEntryRealmModel(
  //           oldEntry.id,
  //           oldEntry.projectId,
  //           oldEntry.groupId,
  //           oldEntry.startTime,
  //           oldEntry.endTime,
  //           oldEntry.totalTimeStr,
  //           oldEntry.breakTimeStr,
  //           description: oldEntry.description,
  //         );
  //         newProject.timeEntries.add(newEntry);
  //       }
  //       newGroup.projects.add(newProject);
  //     }
  //     realm.add(newGroup);
  //     realm.delete(oldGroup);
  //   }
  // });
  // final groupsFromDB = realm.all<GroupRealmModel>();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // * Register error handlers. For more info, see:
  // * https://docs.flutter.dev/testing/errors
  registerErrorHandlers();
  // * Entry point of the app
  runApp(const ProviderScope(child: MyApp()));
}

void registerErrorHandlers() {
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint(error.toString());
    return true;
  };
  // * Show some error UI when any widget in the app fails to build
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('An error occurred'),
      ),
      body: Center(child: Text(details.toString())),
    );
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    // Set portrait orientation
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'My Time-Tracker',
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: lightTheme,
      darkTheme: darkTheme,

      // theme: ThemeData(
      //   colorScheme: const ColorScheme(
      //     brightness: Brightness.light,
      //     primary: Colors.white,
      //     onPrimary: Colors.white,
      //     secondary: Colors.white,
      //     onSecondary: Colors.white,
      //     error: Colors.red,
      //     onError: Colors.white,
      //     background: Colors.white,
      //     onBackground: Colors.white,
      //     surface: Colors.white,
      //     onSurface: Colors.white,
      //   ),
      //   // This is needed
      //   bottomSheetTheme: const BottomSheetThemeData(
      //     backgroundColor: Colors.transparent,
      //   ),
      //   // This is needed
      // ),
    );
  }
}

// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.



final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _sectionANavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionANav');

// This example demonstrates how to setup nested navigation using a
// BottomNavigationBar, where each bar item uses its own persistent navigator,
// i.e. navigation state is maintained separately for each item. This setup also
// enables deep linking into nested pages.

// void main() {
//   runApp(NestedTabNavigationExampleApp());
// }

/// An example demonstrating how to use nested navigators
class NestedTabNavigationExampleApp extends StatelessWidget {
  /// Creates a NestedTabNavigationExampleApp
  NestedTabNavigationExampleApp({super.key});

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (context, state) {
      print(state.uri);
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const MyWidget(),
        routes: [
          StatefulShellRoute.indexedStack(
            pageBuilder: (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              // Return the widget that implements the custom shell (in this case
              // using a BottomNavigationBar). The StatefulNavigationShell is passed
              // to be able access the state of the shell and to navigate to other
              // branches in a stateful way.
              return MaterialPage<void>(
                fullscreenDialog: true,
                child: ScaffoldWithNavBar(navigationShell: navigationShell),
              );
            },
            branches: <StatefulShellBranch>[
              // The route branch for the first tab of the bottom navigation bar.
              StatefulShellBranch(
                navigatorKey: _sectionANavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the first tab of the
                    // bottom navigation bar.
                    name: 'a',
                    path: 'a',
                    builder: (BuildContext context, GoRouterState state) =>
                        const RootScreen(
                      label: 'A',
                      detailsPath: '/a/details',
                    ),
                    routes: <RouteBase>[
                      // The details screen to display stacked on navigator of the
                      // first tab. This will cover screen A but not the application
                      // shell (bottom navigation bar).
                      GoRoute(
                        path: 'details',
                        builder: (BuildContext context, GoRouterState state) =>
                            const DetailsScreen(label: 'A'),
                      ),
                    ],
                  ),
                ],
              ),

              // The route branch for the second tab of the bottom navigation bar.
              StatefulShellBranch(
                // It's not necessary to provide a navigatorKey if it isn't also
                // needed elsewhere. If not provided, a default key will be used.
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the second tab of the
                    // bottom navigation bar.
                    name: 'b',
                    path: 'b',
                    builder: (BuildContext context, GoRouterState state) =>
                        const RootScreen(
                      label: 'B',
                      detailsPath: '/b/details/1',
                      secondDetailsPath: '/b/details/2',
                    ),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'details/:param',
                        builder: (BuildContext context, GoRouterState state) =>
                            DetailsScreen(
                          label: 'B',
                          param: state.pathParameters['param'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // The route branch for the third tab of the bottom navigation bar.
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    // The screen to display as the root in the third tab of the
                    // bottom navigation bar.
                    name: 'c',
                    path: 'c',
                    pageBuilder: (BuildContext context, GoRouterState state) =>
                        MaterialPage<void>(
                      fullscreenDialog: true,
                      key: state.pageKey,
                      child: const RootScreen(
                        label: 'C',
                        detailsPath: '/c/details',
                      ),
                    ),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'details',
                        builder: (BuildContext context, GoRouterState state) =>
                            DetailsScreen(
                          label: 'C',
                          extra: state.extra,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyWidget'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('MyWidget'),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed('a');
              },
              child: const Text('Go to A'),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed('b');
              },
              child: const Text('Go to B'),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed('c');
              },
              child: const Text('Go to C'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds the "shell" for the app by building a Scaffold with a
/// BottomNavigationBar, where [child] is placed in the body of the Scaffold.
class ScaffoldWithNavBar extends StatelessWidget {
  /// Constructs an [ScaffoldWithNavBar].
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nested Navigation Example'),
      ),
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        // Here, the items of BottomNavigationBar are hard coded. In a real
        // world scenario, the items would most likely be generated from the
        // branches of the shell route, which can be fetched using
        // `navigationShell.route.branches`.
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Section A'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Section B'),
          BottomNavigationBarItem(icon: Icon(Icons.tab), label: 'Section C'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
    );
  }

  /// Navigate to the current location of the branch at the provided index when
  /// tapping an item in the BottomNavigationBar.
  void _onTap(BuildContext context, int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

/// Widget for the root/initial pages in the bottom navigation bar.
class RootScreen extends StatelessWidget {
  /// Creates a RootScreen
  const RootScreen({
    required this.label,
    required this.detailsPath,
    this.secondDetailsPath,
    super.key,
  });

  /// The label
  final String label;

  /// The path to the detail page
  final String detailsPath;

  /// The path to another detail page
  final String? secondDetailsPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.apple),
              onPressed: () {
                GoRouter.of(context).pop();
              },
            ),
            Text('Root of section $label'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Screen $label',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Padding(padding: EdgeInsets.all(4)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).go(detailsPath, extra: '$label-XYZ');
              },
              child: const Text('View details'),
            ),
            const Padding(padding: EdgeInsets.all(4)),
            if (secondDetailsPath != null)
              TextButton(
                onPressed: () {
                  GoRouter.of(context).go(secondDetailsPath!);
                },
                child: const Text('View more details'),
              ),
          ],
        ),
      ),
    );
  }
}

/// The details screen for either the A or B screen.
class DetailsScreen extends StatefulWidget {
  /// Constructs a [DetailsScreen].
  const DetailsScreen({
    required this.label,
    this.param,
    this.extra,
    this.withScaffold = true,
    super.key,
  });

  /// The label to display in the center of the screen.
  final String label;

  /// Optional param
  final String? param;

  /// Optional extra object
  final Object? extra;

  /// Wrap in scaffold
  final bool withScaffold;

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.withScaffold) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Details Screen - ${widget.label}'),
        ),
        body: _build(context),
      );
    } else {
      return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: _build(context),
      );
    }
  }

  Widget _build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Details for ${widget.label} - Counter: $_counter',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Padding(padding: EdgeInsets.all(4)),
          TextButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: const Text('Increment counter'),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          if (widget.param != null)
            Text(
              'Parameter: ${widget.param!}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          const Padding(padding: EdgeInsets.all(8)),
          if (widget.extra != null)
            Text(
              'Extra: ${widget.extra!}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          if (!widget.withScaffold) ...<Widget>[
            const Padding(padding: EdgeInsets.all(16)),
            TextButton(
              onPressed: () {
                GoRouter.of(context).pop();
              },
              child: const Text(
                '< Back',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
