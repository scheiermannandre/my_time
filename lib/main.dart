import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/global/globals.dart';
import 'package:my_time/router/app_route.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set portrait orientation
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'My Time-Tracker',
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        indicatorColor: Colors.red, // GlobalProperties.primaryColor,
        colorScheme: const ColorScheme.light().copyWith(
          primary: GlobalProperties.primaryColor,
          secondary: GlobalProperties.secondaryColor,
          background: GlobalProperties.backgroundColor,
          //primarySwatch: Colors.green,
        ),
        scaffoldBackgroundColor: GlobalProperties.backgroundColor,
        dialogBackgroundColor: GlobalProperties.backgroundColor,
        // ---Icon--- //
        listTileTheme: const ListTileThemeData(
          iconColor: GlobalProperties.textAndIconColor,
        ),
        iconTheme: const IconThemeData(
          color: GlobalProperties.textAndIconColor,
        ),
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
              iconColor:
                  MaterialStatePropertyAll(GlobalProperties.textAndIconColor)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: const MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
            padding: MaterialStateProperty.all(
                const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5)),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black.withOpacity(.25); // Disabled color
                }
                return GlobalProperties.primaryColor; // Regular color
              },
            ),
            foregroundColor: MaterialStateProperty.all(
              GlobalProperties.textAndIconColor,
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: GlobalProperties.primaryColor,
          foregroundColor: GlobalProperties.textAndIconColor,
          iconTheme: const IconThemeData(
            color: GlobalProperties.textAndIconColor,
          ),
          toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: GlobalProperties.textAndIconColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ).bodyMedium,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: GlobalProperties.textAndIconColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
            ),
          ).titleLarge,
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: GlobalProperties.textAndIconColor,
          unselectedLabelColor: GlobalProperties.textAndIconColor,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: GlobalProperties.secondaryColor,
                width: 2,
              ),
            ),
          ),
        ),
        // ---Icon--- //
        textTheme: TextTheme(
          // ---Title--- //
          displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          displayMedium: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          displaySmall: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          headlineMedium: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          titleSmall: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
          labelSmall: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: GlobalProperties.textAndIconColor,
              ),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: GlobalProperties.secondaryColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black.withOpacity(.25); // Disabled color
                }
                return GlobalProperties.secondaryColor; // Regular color
              },
            ),
          ),
        ),
      ),
    );
  }
}
