// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:my_time/global/globals.dart';
// import 'package:my_time/router/app_route.dart';
// // ignore:depend_on_referenced_packages
// import 'package:flutter_web_plugins/url_strategy.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter/services.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitDown,
//     DeviceOrientation.portraitUp,
//   ]);
//   // turn off the # in the URLs on the web
//   usePathUrlStrategy();
//   // * Register error handlers. For more info, see:
//   // * https://docs.flutter.dev/testing/errors
//   registerErrorHandlers();
//   // * Entry point of the app
//   runApp(const ProviderScope(child: MyApp()));
// }

// void registerErrorHandlers() {
//   // * Show some error UI if any uncaught exception happens
//   FlutterError.onError = (FlutterErrorDetails details) {
//     FlutterError.presentError(details);
//     debugPrint(details.toString());
//   };
//   // * Handle errors from the underlying platform/OS
//   PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
//     debugPrint(error.toString());
//     return true;
//   };
//   // * Show some error UI when any widget in the app fails to build
//   ErrorWidget.builder = (FlutterErrorDetails details) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: const Text('An error occurred'),
//       ),
//       body: Center(child: Text(details.toString())),
//     );
//   };
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // Set portrait orientation
//     return MaterialApp.router(
//       routerConfig: goRouter,
//       debugShowCheckedModeBanner: false,
//       restorationScopeId: 'app',
//       onGenerateTitle: (BuildContext context) => 'My Time-Tracker',
//       supportedLocales: AppLocalizations.supportedLocales,
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         indicatorColor: Colors.red, // GlobalProperties.primaryColor,
//         colorScheme: const ColorScheme.light().copyWith(
//           primary: GlobalProperties.primaryColor,
//           secondary: GlobalProperties.secondaryColor,
//           background: GlobalProperties.backgroundColor,
//           //primarySwatch: Colors.green,
//         ),
//         scaffoldBackgroundColor: GlobalProperties.backgroundColor,
//         dialogBackgroundColor: GlobalProperties.backgroundColor,
//         // ---Icon--- //
//         listTileTheme: const ListTileThemeData(
//           iconColor: GlobalProperties.textAndIconColor,
//         ),
//         iconTheme: const IconThemeData(
//           color: GlobalProperties.textAndIconColor,
//         ),
//         iconButtonTheme: const IconButtonThemeData(
//           style: ButtonStyle(
//               iconColor:
//                   MaterialStatePropertyAll(GlobalProperties.textAndIconColor)),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ButtonStyle(
//             shape: const MaterialStatePropertyAll(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(5)),
//               ),
//             ),
//             padding: MaterialStateProperty.all(
//                 const EdgeInsets.fromLTRB(0, 12.5, 0, 12.5)),
//             backgroundColor: MaterialStateProperty.resolveWith<Color>(
//               (states) {
//                 if (states.contains(MaterialState.disabled)) {
//                   return Colors.black.withOpacity(.25); // Disabled color
//                 }
//                 return GlobalProperties.primaryColor; // Regular color
//               },
//             ),
//             foregroundColor: MaterialStateProperty.all(
//               GlobalProperties.textAndIconColor,
//             ),
//           ),
//         ),
//         appBarTheme: AppBarTheme(
//           backgroundColor: GlobalProperties.primaryColor,
//           foregroundColor: GlobalProperties.textAndIconColor,
//           iconTheme: const IconThemeData(
//             color: GlobalProperties.textAndIconColor,
//           ),
//           toolbarTextStyle: const TextTheme(
//             titleLarge: TextStyle(
//               color: GlobalProperties.textAndIconColor,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.15,
//             ),
//           ).bodyMedium,
//           titleTextStyle: const TextTheme(
//             titleLarge: TextStyle(
//               color: GlobalProperties.textAndIconColor,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.15,
//             ),
//           ).titleLarge,
//         ),
//         tabBarTheme: const TabBarTheme(
//           labelColor: GlobalProperties.textAndIconColor,
//           unselectedLabelColor: GlobalProperties.textAndIconColor,
//           indicator: BoxDecoration(
//             border: Border(
//               bottom: BorderSide(
//                 color: GlobalProperties.secondaryColor,
//                 width: 2,
//               ),
//             ),
//           ),
//         ),
//         // ---Icon--- //
//         textTheme: TextTheme(
//           // ---Title--- //
//           displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           displayMedium: Theme.of(context).textTheme.displayMedium!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           displaySmall: Theme.of(context).textTheme.displaySmall!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           headlineMedium: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           headlineSmall: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           titleLarge: Theme.of(context).textTheme.titleLarge!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           titleSmall: Theme.of(context).textTheme.titleSmall!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           bodyLarge: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           bodyMedium: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           labelLarge: Theme.of(context).textTheme.labelLarge!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           bodySmall: Theme.of(context).textTheme.bodySmall!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//           labelSmall: Theme.of(context).textTheme.labelSmall!.copyWith(
//                 color: GlobalProperties.textAndIconColor,
//               ),
//         ),
//         progressIndicatorTheme: const ProgressIndicatorThemeData(
//           color: GlobalProperties.secondaryColor,
//         ),
//         textButtonTheme: TextButtonThemeData(
//           style: ButtonStyle(
//             foregroundColor: MaterialStateProperty.resolveWith<Color>(
//               (states) {
//                 if (states.contains(MaterialState.disabled)) {
//                   return Colors.black.withOpacity(.25); // Disabled color
//                 }
//                 return GlobalProperties.secondaryColor; // Regular color
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:my_time/global/globals.dart';

void main() => runApp(const MyApp());

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}

final List<ChartData> data = [
  ChartData('Item 1', 10),
  ChartData('Item 2', 5),
  ChartData('Item 3', 8),
  ChartData('Item 4', 12),
];

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bar Chart App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bar Chart'),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [BarFullyDrawn(), DailyBalanceChart()],
        ),
      ),
    );
  }
}

class DailyBalanceChart extends StatelessWidget {
  const DailyBalanceChart({super.key});

  @override
  Widget build(BuildContext context) {
    const width = 350.0;
    const height = 350 / 3;
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1.5, color: Colors.grey[500]!),
            left: BorderSide(width: 1.5, color: Colors.grey[500]!),
          ),
        ),
        padding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: height * 0.2),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.zero,
            bottomLeft: Radius.zero,
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Container(
            color: GlobalProperties.primaryColor,
            child: CustomPaint(
              painter: BarPainter(value: .8),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Actual",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text("07:00",
                        style:
                            TextStyle(fontSize: 20, color: Colors.grey[600])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BarPainter extends CustomPainter {
  final double value;

  BarPainter({required this.value});
  @override
  void paint(Canvas canvas, Size size) {
    _drawBar(canvas, size, const Color(0xFF256B6F),
        value: value, isBelow: false);
  }

  void _drawBar(Canvas canvas, Size size, Color color,
      {required double value, bool isBelow = true}) {
    assert(value >= 0 && value <= 1);
    final verticalRadiusRight =
        value == 1 ? const Radius.circular(10) : const Radius.circular(0);
    const verticalRadiusLeft = Radius.circular(0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width * value,
      size.height,
      topLeft: verticalRadiusLeft,
      bottomRight: verticalRadiusRight,
      topRight: verticalRadiusRight,
      bottomLeft: verticalRadiusLeft,
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarFullyDrawn extends StatelessWidget {
  const BarFullyDrawn({super.key});

  @override
  Widget build(BuildContext context) {
    const width = 350.0;
    const height = 350 / 3;
    return Center(
      child: Container(
        width: width,
        height: height,
        color: Colors.yellow,
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: height * 0.2),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.zero,
              bottomLeft: Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: CustomPaint(painter: BarFullyDrawnPainter()),
          ),
        ),
      ),
    );
  }
}

class BarFullyDrawnPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final y = size.height;
    final x = size.width;
    final points = [
      const Offset(0, 0),
      Offset(0, y),
      Offset(x, y),
    ];
    canvas.drawPoints(PointMode.polygon, points, paint);
    _drawBar(canvas, size, Colors.blue, value: 1);
    _drawBar(canvas, size, Colors.red, value: .98, isBelow: false);
    _drawText(canvas, size, 'Actual', Alignment.centerLeft);
    _drawText(canvas, size, '07:00', Alignment.centerRight);
  }

  void _drawText(
      Canvas canvas, Size size, String barDescription, Alignment alignment) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: barDescription,
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final xCenter = alignment == Alignment.centerLeft
        ? 10.0
        : size.width - textPainter.width - 10.0;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  void _drawBar(Canvas canvas, Size size, Color color,
      {required double value, bool isBelow = true}) {
    assert(value >= 0 && value <= 1);
    final verticalRadiusRight =
        value == 1 ? const Radius.circular(0) : const Radius.circular(0);
    const verticalRadiusLeft = Radius.circular(0);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width * value,
      size.height,
      topLeft: verticalRadiusLeft,
      bottomRight: verticalRadiusRight,
      topRight: verticalRadiusRight,
      bottomLeft: verticalRadiusLeft,
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
