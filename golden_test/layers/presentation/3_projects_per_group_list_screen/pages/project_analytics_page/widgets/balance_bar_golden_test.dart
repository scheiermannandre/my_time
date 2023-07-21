import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_chart_configuration.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/models/balance_bar_item.dart';
import 'package:my_time/layers/presentation/3_projects_per_group_list_screen/pages/project_analytics_page/widgets/balance_bar_chart.dart';

void main() {
  Widget createBalanceBar(TimeOfDay desired, TimeOfDay actual) {
    BalanceBarItem item = BalanceBarItem(
      desiredTime: desired,
      actualTime: actual,
      barDescriptionLabel: 'Actual',
    );
    BalanceBarChartStyle style = BalanceBarChartStyle(
      desiredBalanceColor: const Color(0xff8bc4b7),
      undesiredBalanceColor: const Color(0xffc85552),
      barStyle: HorizontalBalanceBarStyle(
        barTextColor: Colors.black,
        desiredBarStateColor: const Color(0xfffadeb4),
        actualUnderHourBarStateColor: const Color(0xff8bc4b7),
        actualOverHourBarStateColor: const Color(0xffc85552),
      ),
      axisLabelColor: Colors.black38,
      frameColor: Colors.black38,
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: BalanceBarChart(
        item: item,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        barHeight: 45,
        barPadding: 10,
        labelCount: 2,
        showVerticalHelperLines: false,
        style: style,
      ),
    );
  }

  Widget createNeutralBalancebarChart() {
    return createBalanceBar(const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 8, minute: 0));
  }

  Widget createUnderHoursBalancebarChart() {
    return createBalanceBar(const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 6, minute: 0));
  }

  Widget createOverHoursBalancebarChart() {
    return createBalanceBar(const TimeOfDay(hour: 8, minute: 0),
        const TimeOfDay(hour: 9, minute: 0));
  }

  group('BalanceBarStates', () {
    testWidgets('Test neutral balance bar', (WidgetTester tester) async {
      Widget widget = createNeutralBalancebarChart();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(BalanceBarChart),
        matchesGoldenFile('./neutralBalanceBarGoldenImage.png'),
        skip: !Platform.isMacOS,
      );
    });

    testWidgets('Test under hours balance bar', (WidgetTester tester) async {
      Widget widget = createUnderHoursBalancebarChart();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(BalanceBarChart),
        matchesGoldenFile('./underHoursBalanceBarGoldenImage.png'),
        skip: !Platform.isMacOS,
      );
    });

    testWidgets('Test under hours balance bar', (WidgetTester tester) async {
      Widget widget = createOverHoursBalancebarChart();
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(BalanceBarChart),
        matchesGoldenFile('./overHoursBalanceBarGoldenImage.png'),
        skip: !Platform.isMacOS,
      );
    });
  });
}
