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
import 'package:my_time/common/extensions/canvas_extensions.dart';
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
          children: [
            Padding(
              padding: EdgeInsets.all(0),
              child: BarFullyDrawn(
                barHeight: 50,
                barPadding: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarFullyDrawn extends StatelessWidget {
  const BarFullyDrawn({
    super.key,
    required this.barHeight,
    required this.barPadding,
    this.width,
  });
  final double barHeight;
  final double barPadding;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double availableWidth =
              width != null && width! < constraints.maxWidth
                  ? width!
                  : constraints.maxWidth;

          final barContainerHeight = barHeight + barPadding * 2;
          final diagramFrame = DiagrammFrameConfiguration(
            originLabel: '00:00',
            endLabel: '08:00',
            parentWidth: availableWidth,
            barContainerHeight: barContainerHeight,
          );

          final BarItem item = BarItem(
              desiredValue: 1, value: .8, label: 'Actual', valueLabel: '07:00');
          return Container(
            width: availableWidth,
            height: diagramFrame.height,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  width: diagramFrame.width,
                  height: diagramFrame.height,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: DiagramFramePainter(configuration: diagramFrame),
                  ),
                ),
                Container(
                  width: diagramFrame.width,
                  height: barContainerHeight,
                  color: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: barPadding),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.zero,
                      bottomLeft: Radius.zero,
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    child: CustomPaint(
                      painter: BarFullyDrawnPainter(item: item),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BarItem {
  final String label;
  final double desiredValue;
  final double value;
  final String valueLabel;

  BarItem(
      {required this.desiredValue,
      required this.value,
      required this.label,
      required this.valueLabel});
}

class BarFullyDrawnPainter extends CustomPainter {
  final BarItem item;

  BarFullyDrawnPainter({required this.item});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    final y = size.height;
    final x = size.width;
    final points = [
      const Offset(0, 0),
      Offset(0 + 20, y),
      Offset(x - 20, y),
    ];
    canvas.drawPoints(PointMode.polygon, points, paint);
    _drawBar(canvas, size, GlobalProperties.primaryColor,
        value: item.desiredValue);
    _drawBar(canvas, size, const Color(0xFF256B6F),
        value: item.value, isBelow: false);
    _drawText(canvas, size, item.label, Alignment.centerLeft);
    _drawText(canvas, size, item.valueLabel, Alignment.centerRight);
  }

  void _drawText(
      Canvas canvas, Size size, String barDescription, Alignment alignment) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 20,
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

class DiagramFramePainter extends CustomPainter {
  final DiagrammFrameConfiguration configuration;

  DiagramFramePainter({
    required this.configuration,
  });
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawDiagram(configuration.axisPoints);
    for (var element in configuration.xAxisValues) {
      canvas.drawXAxisValue(element.painter, element.offset);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class DiagrammFrameConfiguration {
  static const _labelRowPaddingFactor = 0.15;

  late final double width;
  late final double height;

  late final double yAxisPadding;

  final List<({TextPainter painter, Offset offset})> xAxisValues = [];
  late final List<Offset> axisPoints;
  DiagrammFrameConfiguration({
    required String originLabel,
    required String endLabel,
    required double parentWidth,
    required double barContainerHeight,
  }) {
    final originLabelPainter = _calulateTextSize(originLabel);
    final endLabelPainter = _calulateTextSize(endLabel);

    final labelRowHeight =
        originLabelPainter.size.height * (1 + 2 * _labelRowPaddingFactor);

    height = barContainerHeight + labelRowHeight;
    yAxisPadding = height - labelRowHeight;
    width = parentWidth -
        originLabelPainter.size.width / 2 -
        endLabelPainter.size.width / 2;

    final originLabelOffset = Offset(-originLabelPainter.width / 2,
        barContainerHeight + labelRowHeight * 0.15);

    final endLabelOffset = Offset(width - originLabelPainter.width / 2,
        barContainerHeight + labelRowHeight * 0.15);

    xAxisValues.add((offset: originLabelOffset, painter: originLabelPainter));
    xAxisValues.add((offset: endLabelOffset, painter: endLabelPainter));

    axisPoints = [
      const Offset(0, 0),
      Offset(0, yAxisPadding),
      Offset(width, yAxisPadding),
    ];
  }

  TextPainter _calulateTextSize(String text) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: text, // '00:00',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    return textPainter;
  }
}
