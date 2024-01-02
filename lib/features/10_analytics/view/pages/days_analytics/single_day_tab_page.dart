// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_time/domain/analytics_domain/models/analysis_type.dart';
import 'package:my_time/domain/analytics_domain/models/day_analytics_model.dart';
import 'package:my_time/domain/analytics_domain/models/day_off_model.dart';
import 'package:my_time/features/10_analytics/application/day_analysis_service.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/entry_card.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/new_balance_bar_chart.dart';
import 'package:my_time/features/10_analytics/view/widgets/charts/project_times_chart.dart';
import 'package:my_time/foundation/config/theme/tokens/space_tokens.dart';

class SingleDayTabPage extends ConsumerWidget {
  const SingleDayTabPage({
    required this.date,
    required this.groupId,
    super.key,
  });
  final DateTime date;
  final String groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsyncValue =
        ref.watch(fetchDayAnalyticsProvider(groupId, date, date));

    return dataAsyncValue.when(
      data: (data) {
        if (data.isWork) {
          return SingleDayTabWidget(data: data);
        } else {
          return DayOffDisplay(
            data: data.dayOffModel,
            type: data.analysisType,
          );
        }
      },
      error: (e, st) => Text(e.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

class DayOffDisplay extends StatelessWidget {
  const DayOffDisplay({required this.data, required this.type, super.key});
  final DayOffModel data;
  final AnalysisType type;
  @override
  Widget build(BuildContext context) {
    const svgBasePath = 'assets/analysis_svgs';
    var imageName = '';
    var mode = 'light';
    const svgFileType = '.svg';

    var message = 'You were ';

    if (Theme.of(context).brightness == Brightness.dark) {
      mode = 'dark';
    }
    //  that day
    //  that day
    ///  that day
    ///  this day.
    ///
    ///  this week
    ///  this week
    ///  this week
    ///  this week.
    ///
    ///  this month
    ///  this month
    ///  this month
    ///  this month.
    ///
    ///  this year
    ///  this year
    ///  this year
    ///  this year.

    if (data.isMultiple) {
      imageName = 'no_work';
      message += 'away from work on';
    } else if (data.isSick) {
      imageName = 'sick';
      message += 'sick';
    } else if (data.isVacation) {
      imageName = 'vacation';
      message += 'on vacation ';
    } else if (data.isPublicHoliday) {
      imageName = 'holiday';
      message += 'on public holiday';
    }

    switch (type) {
      case AnalysisType.day:
        message += ' that day.';
      case AnalysisType.week:
        message += ' that week.';
      case AnalysisType.month:
        message += ' that month.';
      case AnalysisType.year:
        message += ' that year.';
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        SvgPicture.asset(
          '$svgBasePath/${imageName}_$mode$svgFileType',
        ),
      ],
    );
  }
}

class SingleDayTabWidget extends StatelessWidget {
  const SingleDayTabWidget({required this.data, super.key});
  final DayAnalyticsModel data;

  @override
  Widget build(BuildContext context) {
    var expectedTime = data.balance.expectedWorkTime;
    expectedTime = const Duration(hours: 8);

    var actualTime = data.balance.actualTime;
    actualTime = const Duration(hours: 9);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpaceTokens.medium),
      child: ListView(
        children: [
          const SizedBox(height: SpaceTokens.medium),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(SpaceTokens.medium),
              child: Column(
                children: [
                  NewBalanceBarChart(
                    expectedTime: expectedTime,
                    actualTime: actualTime,
                  ),
                ],
              ),
            ),
          ),
          if (data.projectTime.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: SpaceTokens.medium),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(SpaceTokens.medium),
                    child: ProjectTimesChart(
                      projectTimes: data.projectTime
                          .where((element) => element.time.inMinutes > 0)
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          const SizedBox(height: SpaceTokens.medium),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.entries.length,
            itemBuilder: (context, index) {
              return EntryCard.fromEntry(
                context: context,
                entry: data.entries[index],
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: SpaceTokens.small);
            },
          ),
          const SizedBox(height: SpaceTokens.medium),
        ],
      ),
    );
  }
}
