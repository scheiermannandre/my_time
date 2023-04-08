import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_time/l10n/l10n.dart';
import 'package:my_time/router/app_route.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
    // make a list of type DateFormat nad add every possible DateFormat of the class DateFormat into it
  final formats = <DateFormat>[
    DateFormat.yMd(),
    DateFormat.yMEd(),
    DateFormat.yMMMMd(),
    DateFormat.yMMMMEEEEd(),
    DateFormat.MMMMd(),
    DateFormat.E(),
    DateFormat.EEEE(),
    DateFormat.Hm(),
    DateFormat.Hms(),
    DateFormat.jm(),
    DateFormat.jms(),
    DateFormat.Md(),
    DateFormat.MEd(),
    DateFormat.MMMd(),
    DateFormat.MMMEd(),
    DateFormat.MMMMEEEEd(),
    DateFormat.MMMMd(),
    DateFormat.MMMM(),
    DateFormat.y(),
    DateFormat.yM(),
    DateFormat.yMd(),
    DateFormat.yMEd(),
    DateFormat.yMMM(),
    DateFormat.yMMMd(),
    DateFormat.yMMMEd(),
    DateFormat.yMMMM(),
    DateFormat.yMMMMd(),
    DateFormat.yMMMMEEEEd(),
    DateFormat.H(),
    DateFormat.Hm(),
    DateFormat.Hms(),
    DateFormat.j(),
    DateFormat.jm(),
    DateFormat.jms(),
    DateFormat.m(),
    DateFormat.ms(),
    DateFormat.s(),
    DateFormat.E(),
    DateFormat.EEEE(),
    DateFormat.Hms(),
    DateFormat.jms(),
    DateFormat.m(),
    DateFormat.ms(),
    DateFormat.s()
  ];

// for each format in the list of formats, print the format for DateTime.Now() and print the name of the format method
  for (final format in formats) {
    print('${format.format(DateTime.now())} - ${format.pattern}');
  }


  WidgetsFlutterBinding.ensureInitialized();
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
    return MaterialApp.router(
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'app',
      onGenerateTitle: (BuildContext context) => 'My Time-Tracker',
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
