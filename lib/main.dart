import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_time/router/app_route.dart';
// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class BoolObject {
  BoolObject({this.value = false});
  bool value = false;
}

class BooleanController extends StateNotifier<AsyncValue<BoolObject>> {
  BooleanController() : super(AsyncValue.data(BoolObject()));

  void toggle() {
    final tmp = !state.value!.value;
    state = AsyncValue.data(BoolObject(value: !state.value!.value));
    print(state.value!.value);
  }
}

// final boolObjectProvider = StateNotifierProvider.autoDispose<BooleanController, AsyncValue<BoolObject>>(
//     (_) => BooleanController());

final boolObjectProvider = StateNotifierProvider.autoDispose<BooleanController,
    AsyncValue<BoolObject>>((ref) {
  return BooleanController();
});

// final boolObjectState =
//     Provider<BoolObject>((ref) => ref.watch(boolObjectProvider));

class MemoryExample extends HookConsumerWidget {
  const MemoryExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(boolObjectProvider.notifier);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Riverpod Animation Example"),
        ),
        body: Column(
          children: [
            const AnimatedWidget(),
            ElevatedButton(
              child: const Text("Toggle"),
              onPressed: () {
                notifier.toggle();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedWidget extends HookConsumerWidget {
  final Duration duration = const Duration(milliseconds: 1000);
  static double containerWidth = 200;
  static double circleRadius = 25;
  static double beginPoint = (containerWidth / 2 - circleRadius / 2) * -1;
  static double endPoint = (containerWidth / 2 - circleRadius / 2);

  const AnimatedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useAnimationController(
        duration: duration,
        lowerBound: beginPoint,
        upperBound: endPoint,
        initialValue: beginPoint);

    ref.listen<AsyncValue<BoolObject>>(boolObjectProvider, (previous, next) {
      if (next.value!.value) {
        controller.forward();
      } else {
        controller.reverse();
      }
    });

    // useValueChanged<bool, Function(bool, bool)>(boolState, (_, __) {
    //   if (boolState) {
    //     controller.forward();
    //   } else {
    //     controller.reverse();
    //   }
    //   return null;
    // });

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            height: containerWidth,
            width: containerWidth,
            decoration: BoxDecoration(
                color: Colors.white70, border: Border.all(color: Colors.green)),
            child: Transform.translate(
              offset: Offset(controller.value, 0),
              child: Align(
                child: Container(
                  width: circleRadius,
                  height: circleRadius,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: RefreshIndicatorExample(),
//     );
//   }
// }

// class RefreshIndicatorExample extends StatefulWidget {
//   const RefreshIndicatorExample({super.key});

//   @override
//   State<RefreshIndicatorExample> createState() =>
//       _RefreshIndicatorExampleState();
// }

// class _RefreshIndicatorExampleState extends State<RefreshIndicatorExample> {
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('RefreshIndicator Sample'),
//       ),
//       body: RefreshIndicator(
//         key: _refreshIndicatorKey,
//         color: Colors.white,
//         backgroundColor: Colors.blue,
//         strokeWidth: 4.0,
//         onRefresh: () async {
//           // Replace this delay with the code to be executed during refresh
//           // and return a Future when code finishs execution.
//           return Future<void>.delayed(const Duration(seconds: 3));
//         },
//         // Pull from top to show refresh indicator.
//         child: ListView.builder(
//           itemCount: 25,
//           itemBuilder: (BuildContext context, int index) {
//             return ListTile(
//               title: Text('Item $index'),
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           // Show refresh indicator programmatically on button tap.
//           _refreshIndicatorKey.currentState?.show();
//         },
//         icon: const Icon(Icons.refresh),
//         label: const Text('Show Indicator'),
//       ),
//     );
//   }
// }
