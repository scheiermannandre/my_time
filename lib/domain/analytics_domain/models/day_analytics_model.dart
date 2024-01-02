import 'package:my_time/domain/analytics_domain/models/analysis_type.dart';
import 'package:my_time/domain/analytics_domain/models/balance_model.dart';
import 'package:my_time/domain/analytics_domain/models/day_off_model.dart';
import 'package:my_time/domain/analytics_domain/models/project_time_model.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';

class DayAnalyticsModel {
  DayAnalyticsModel({
    required this.balance,
    required this.projectTime,
    required this.entries,
    required this.dayOffModel,
  });

  final BalanceModel balance;
  final List<ProjectTimeModel> projectTime;
  final List<NewWorkEntryModel> entries;
  final DayOffModel dayOffModel;
  bool get isWork => entries.isNotEmpty;
  final AnalysisType analysisType = AnalysisType.day;
}
