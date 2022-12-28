import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_time/pages/home_page.dart';
import 'package:my_time/pages/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
      //home: const HomePage(),
    );
  }

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: "settings",
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
