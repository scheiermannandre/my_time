import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


// ToDo -> PageViews werden multiple times geladen, könnte an den PageView
// ToDO -> setStates liegen -> bitte Prüfen! vermutlihc liegts an den KeepAlives
// ToDo -> WorkingHours as Duration
// ToDo -> times as TimeOfDay instead of Duration
// ToDo -> let user set the hours how many days he want to work per week/month/year
// ToDo -> let user set the hours how many hour he wants to work per per
// ToDo -> settings like workhours etc. should be set for group not project
// ToDo -> work on weekday only
// ToDo -> define a SOLL-Zeit per project??
class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({
    this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('AnalyticsPage'));
  final StatefulNavigationShell? navigationShell;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  void _goBranch(int index) {
    widget.navigationShell?.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == widget.navigationShell!.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell?.currentIndex ?? 0,
        destinations: const [
          NavigationDestination(label: 'Day', icon: Icon(Icons.home)),
          NavigationDestination(label: 'Week', icon: Icon(Icons.settings)),
          NavigationDestination(label: 'Month', icon: Icon(Icons.settings)),
          NavigationDestination(label: 'Year', icon: Icon(Icons.settings)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}



class WeeksPage extends StatelessWidget {
  /// Creates a RootScreen
  const WeeksPage({
    super.key,
  });

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
            const Text('Weeks'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Screen Weeks',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class MonthsPage extends StatelessWidget {
  /// Creates a RootScreen
  const MonthsPage({
    super.key,
  });

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
            const Text('MonthsPage'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Screen MonthsPage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class YearsPage extends StatelessWidget {
  /// Creates a RootScreen
  const YearsPage({
    super.key,
  });

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
            const Text('YearsPage'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Screen YearsPage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
