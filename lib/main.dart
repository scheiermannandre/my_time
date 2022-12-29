import 'dart:math';

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
        builder: (context, state) =>  HomePage(),
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

class SamplePage extends StatelessWidget {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 250.0;

  final ValueNotifier<double> _titlePaddingNotifier = ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 0.0;

    if (_scrollController.hasClients) {
      return min(_kBasePadding + kCollapsedPadding,
          _kBasePadding + (kCollapsedPadding * _scrollController.offset)/(kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return Scaffold(

      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: true,
                leading: Icon(Icons.arrow_back),
                  expandedHeight: kExpandedHeight,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    
                      collapseMode: CollapseMode.pin,
                      centerTitle: false,
                      titlePadding: EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                      title: ValueListenableBuilder(
                        valueListenable: _titlePaddingNotifier,
                        builder: (context, value, child) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: value),
                            child: Text(
                              "Title"),
                          );
                        },
                      ),
                      background: Container(color: Colors.green)
                  )
              ),
            ];
          },
          body: Text("Body text")
        ),
    );
  }
}