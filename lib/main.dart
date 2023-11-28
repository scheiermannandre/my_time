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
import 'package:my_time/router/app_route.dart';
// import 'package:realm/realm.dart';
// import 'package:my_time/features/0_common/realmModel/realm_model.dart';

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
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Colors.white,
        ),
        // This is needed
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        // This is needed
      ),
    );
  }
}
