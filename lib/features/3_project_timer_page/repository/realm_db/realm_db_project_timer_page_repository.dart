// ignore_for_file: only_throw_errors

import 'package:my_time/common/common.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// RealmDb implementation of the [ProjectTimerPageRepository].
class RealmDbProjectTimerPageRepository implements ProjectTimerPageRepository {
  /// Constructor for the [RealmDbProjectTimerPageRepository].
  RealmDbProjectTimerPageRepository(this.realm);

  /// The realm instance.
  final Realm realm;

  @override
  Future<ProjectTimerModel?> fetchTimerData(String projectId) async {
    final timerDataList =
        realm.all<TimerDataRealmModel>().query("projectId == '$projectId'");
    if (timerDataList.isEmpty) {
      return null;
    }
    final timerData = timerDataList.first;
    return _mapTimerData(timerData);
  }

  @override
  Future<ProjectTimerModel> saveTimerData(ProjectTimerModel timerData) async {
    final timerDataList = realm.all<TimerDataRealmModel>();
    if (timerDataList.isNotEmpty) {
      throw const app_exception.CustomAppException.multipleTimerStarts();
    }
    final dbTimerData = TimerDataRealmModel(
      timerData.id,
      timerData.projectId,
      timerData.startTime,
      timerData.endTime,
      timerData.state.toString(),
      breakStartTimes: timerData.breakStartTimes,
      breakEndTimes: timerData.breakEndTimes,
    );

    await realm.writeAsync(() {
      realm.add(dbTimerData);
    });
    return _mapTimerData(dbTimerData);
  }

  @override
  Future<ProjectTimerModel> deleteTimerData(
    ProjectTimerModel timerData,
    DateTime endTime,
  ) async {
    final timerDataList = realm
        .all<TimerDataRealmModel>()
        .query("projectId == '${timerData.projectId}'");
    final timerDataDB = timerDataList.first;

    ProjectTimerModel? newTimerData;
    await realm.writeAsync(() {
      timerDataDB.endTime = endTime;
      if (timerDataDB.breakStartTimes.length >
          timerDataDB.breakEndTimes.length) {
        timerDataDB.breakEndTimes.add(endTime);
      }
      timerDataDB.timerState = TimerState.off.toString();
      newTimerData = _mapTimerData(timerDataDB);
      realm.delete<TimerDataRealmModel>(timerDataDB);
    });
    return newTimerData!;
  }

  @override
  Future<ProjectTimerModel> updateTimerDataState(
    ProjectTimerModel timerData,
    DateTime stateChangeTime,
  ) async {
    final timerDataList = realm
        .all<TimerDataRealmModel>()
        .query("projectId == '${timerData.projectId}'");
    if (timerDataList.isEmpty) {
      throw const app_exception.CustomAppException.timerDataNotFound();
    }
    final timerDataDb = timerDataList.first;
    await realm.writeAsync(() {
      final stateDb = timerDataDb.timerState.toEnum(TimerState.values);
      if (stateDb == TimerState.running) {
        timerDataDb.breakStartTimes.add(stateChangeTime);
      } else if (stateDb == TimerState.paused) {
        timerDataDb.breakEndTimes.add(stateChangeTime);
      }
      timerDataDb.timerState = timerData.state.toString();
    });

    return _mapTimerData(timerDataDb);
  }

  ProjectTimerModel _mapTimerData(TimerDataRealmModel dbTimerData) {
    final timerDataDto = ProjectTimerModel.factory(
      id: dbTimerData.id,
      projectId: dbTimerData.projectId,
      startTime: dbTimerData.startTime,
      endTime: dbTimerData.endTime,
      breakStartTimes: IterableExtensions.deepCopyDateTimeList(
        dbTimerData.breakStartTimes,
      ),
      breakEndTimes:
          IterableExtensions.deepCopyDateTimeList(dbTimerData.breakEndTimes),
      timerState: dbTimerData.timerState,
    );
    return timerDataDto;
  }
}

/// Provides the [RealmDbProjectTimerPageRepository].
final timerDataRepositoryProvider =
    Provider<RealmDbProjectTimerPageRepository>((ref) {
  final config = Configuration.local([TimerDataRealmModel.schema]);
  final realm = Realm(config);
  ref.onDispose(realm.close);
  return RealmDbProjectTimerPageRepository(realm);
});
