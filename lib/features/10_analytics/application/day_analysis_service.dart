import 'package:my_time/domain/analytics_domain/models/balance_model.dart';
import 'package:my_time/domain/analytics_domain/models/day_analytics_model.dart';
import 'package:my_time/domain/analytics_domain/models/day_off_model.dart';
import 'package:my_time/domain/analytics_domain/models/project_time_model.dart';
import 'package:my_time/domain/entry_domain/models/entry/new_entry_model.dart';
import 'package:my_time/features/10_analytics/data/analytics_entry_repository.dart';
import 'package:my_time/features/10_analytics/data/analytics_group_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'day_analysis_service.g.dart';

class DayAnalysisService {
  DayAnalysisService({required this.groupRepo, required this.entryRepo});

  final AnalyticsEntryRepository entryRepo;
  final AnalyticsGroupRepository groupRepo;
  Future<DayAnalyticsModel> fetchEntryEntitiesByDateRange(
    String groupId,
    DateTime lowerboundary,
    DateTime upperboundary,
  ) async {
    final data = await entryRepo.fetchEntriesByDateRange(
      groupId,
      lowerboundary,
      upperboundary,
    );

    final group = await groupRepo.fetchGroup(groupId);

    var expectedWorkTime = Duration.zero;
    var actualTime = Duration.zero;
    final projectTimeModels = <ProjectTimeModel>[];
    final workEntries = data.whereType<NewWorkEntryModel>().toList();

    for (final project in group.projects) {
      expectedWorkTime +=
          project.timeManagement?.workingHoursPerDay ?? Duration.zero;
    }

    for (final entry in workEntries) {
      actualTime += entry.totalTime;
      projectTimeModels.add(
        ProjectTimeModel(
          name: entry.projectName,
          time: entry.totalTime,
        ),
      );
    }

    final balance = BalanceModel(
      actualTime: actualTime,
      expectedWorkTime: expectedWorkTime,
    );
    return DayAnalyticsModel(
      balance: balance,
      projectTime: projectTimeModels,
      entries: [],
      dayOffModel: DayOffModel(
        isSick: false,
        isVacation: false,
        isPublicHoliday: true,
      ),
    );
  }
}

@riverpod
FutureOr<DayAnalyticsModel> fetchDayAnalytics(
  FetchDayAnalyticsRef ref,
  String groupId,
  DateTime lowerboundary,
  DateTime upperboundary,
) {
  final groupRepo = ref.read(analyticsGroupRepositoryProvider);

  final entryRepo = ref.read(analyticsEntryRepositoryProvider);
  final service =
      DayAnalysisService(groupRepo: groupRepo, entryRepo: entryRepo);

  return service.fetchEntryEntitiesByDateRange(
    groupId,
    lowerboundary,
    upperboundary,
  );
}
