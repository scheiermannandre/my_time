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

import 'package:flutter/material.dart';
import 'package:my_time/common/extensions/canvas_extensions.dart';
import 'package:my_time/common/extensions/time_of_day_extension.dart';
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
          int labelCount = 5;
          List<double> slots = generateSlots(
              const TimeOfDay(hour: 9, minute: 0).toMinutes().toDouble(),
              labelCount);
          List<String> labels = slots.map(formatTime).toList();
          final double availableWidth =
              width != null && width! < constraints.maxWidth
                  ? width!
                  : constraints.maxWidth;

          final barContainerHeight = barHeight + barPadding * 2;
          final diagramFrame = DiagrammFrameConfiguration(
            labels: labels,
            labelCount: labelCount,
            parentWidth: availableWidth,
            barContainerHeight: barContainerHeight,
          );

          final BarItem item = BarItem(
              desiredValue: 1, value: .5, label: 'Actual', valueLabel: '07:00');
          return Container(
            width: availableWidth,
            height: diagramFrame.fullDiagramHeight,
            color: Colors.transparent,
            child: Stack(
              children: [
                Container(
                  width: diagramFrame.innerDiagramWidth,
                  height: diagramFrame.fullDiagramHeight,
                  color: Colors.transparent,
                  child: CustomPaint(
                    painter: DiagramFramePainter(configuration: diagramFrame),
                  ),
                ),
                HorizontalBalanceBar(
                    diagramFrame: diagramFrame,
                    barPadding: barPadding,
                    barContainerHeight: barContainerHeight,
                    item: item),
              ],
            ),
          );
        },
      ),
    );
  }

  List<double> generateSlots(double timeOfDay, int count) {
    List<double> timeList = [];

    // Handle count = 1 separately
    if (count == 1) {
      timeList.add(timeOfDay);
      return timeList;
    }
    // Calculate the interval between each time slot
    double interval = timeOfDay / (count - 1);

    // Generate the time slots
    for (int i = 0; i < count; i++) {
      double slotTime = interval * i;
      timeList.add(slotTime);
    }

    return timeList;
  }

  String formatTime(double time) {
    int hour = time ~/ 60;
    int minute = time.toInt() % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class HorizontalBalanceBar extends StatelessWidget {
  const HorizontalBalanceBar({
    super.key,
    required this.diagramFrame,
    required this.barPadding,
    required this.barContainerHeight,
    required this.item,
  });

  final DiagrammFrameConfiguration diagramFrame;
  final double barPadding;
  final double barContainerHeight;
  final BarItem item;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: diagramFrame.axisPoints.first.dx,
      top: 0,
      right: diagramFrame.endLabelCenterWidth,
      bottom: barPadding * 2,
      child: Container(
        width: diagramFrame.innerDiagramWidth,
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
    canvas.drawVerticalHelperLines(configuration.verticalHelperLines);
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

  late final double innerDiagramWidth;
  late final double fullDiagramWidth;
  late final double fullDiagramHeight;
  late final double innerDiagramHeight;
  final double barContainerHeight;
  late final double endLabelCenterWidth;
  final List<({TextPainter painter, Offset offset})> xAxisValues = [];
  late final List<Offset> axisPoints;
  final List<({Offset top, Offset bottom})> verticalHelperLines = [];
  DiagrammFrameConfiguration(
      {required double parentWidth,
      required List<String> labels,
      required int labelCount,
      required this.barContainerHeight,
      bool drawVerticalHelperLines = true}) {
    fullDiagramWidth = parentWidth;

    ({double textWidth, double textCenterWidth, double textHeight}) end =
        _getTextMetaData(labels.last);
    endLabelCenterWidth = end.textCenterWidth;

    ({double textWidth, double textCenterWidth, double textHeight}) origin = (
      textWidth: 0,
      textCenterWidth: 0,
      textHeight: 0,
    );
    if (labelCount > 1) {
      origin = _getTextMetaData(labels.first);
    }

    double labelFieldHeight = _calculateDiagramHeights(end.textHeight);
    _calculateDiagramWidths(parentWidth, origin.textCenterWidth);
    _configureXAxis(labels, parentWidth, end.textWidth, origin.textWidth,
        labelCount, labelFieldHeight, drawVerticalHelperLines);
    _configureDiagramFrame(origin.textCenterWidth);
  }

  ({double textWidth, double textCenterWidth, double textHeight})
      _getTextMetaData(String text) {
    TextPainter textPainter = _getTextPainter(text);
    double textWidth = textPainter.width;
    double textCenterWidth = textWidth / 2;
    double textHeight = textPainter.height;
    return (
      textWidth: textWidth,
      textCenterWidth: textCenterWidth,
      textHeight: textHeight
    );
  }

  void _configureXAxis(
      List<String> labels,
      double parentWidth,
      double endWidth,
      double originWidth,
      int labelCount,
      double labelFieldHeight,
      bool drawVerticalHelperLines) {
    for (int i = 0; i < labels.length; i++) {
      String element = labels[i];
      // Calculate the interval between each x-Value
      double interval =
          (parentWidth - endWidth / 2 - originWidth / 2) / (labelCount - 1);
      // Generate the x-Value
      double x = interval * i + originWidth / 2;

      _configureXAxisLabels(element, labelFieldHeight, x);
      _configureVerticalHelperLines(drawVerticalHelperLines, x);
    }
  }

  void _calculateDiagramWidths(
      double parentWidth, double originLabelCenterWidth) {
    innerDiagramWidth =
        parentWidth - originLabelCenterWidth - endLabelCenterWidth;
  }

  void _configureDiagramFrame(double originLabelCenterWidth) {
    axisPoints = [
      Offset(originLabelCenterWidth, 0),
      Offset(originLabelCenterWidth, innerDiagramHeight),
      Offset(xAxisValues.last.offset.dx + xAxisValues.last.painter.width / 2,
          innerDiagramHeight),
    ];
  }

  double _calculateDiagramHeights(double textHeight) {
    double labelFieldHeight = textHeight * (1 + 2 * _labelRowPaddingFactor);
    fullDiagramHeight = barContainerHeight + labelFieldHeight;
    innerDiagramHeight = fullDiagramHeight - labelFieldHeight;

    return labelFieldHeight;
  }

  void _configureXAxisLabels(
      String element, double labelFieldHeight, double x) {
    TextPainter textPainter = _getTextPainter(element);
    double y = barContainerHeight + labelFieldHeight * 0.15;
    double xOffset = textPainter.width / 2;
    Offset offset = Offset(x - xOffset, y);

    xAxisValues.add(
      (
        offset: offset,
        painter: textPainter,
      ),
    );
  }

  void _configureVerticalHelperLines(bool drawVerticalHelperLines, double x) {
    if (drawVerticalHelperLines) {
      verticalHelperLines.add((
        top: Offset(x, 0),
        bottom: Offset(x, innerDiagramHeight),
      ));
    }
  }

  TextPainter _getTextPainter(String text) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );
    final textSpan = TextSpan(
      text: text,
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
