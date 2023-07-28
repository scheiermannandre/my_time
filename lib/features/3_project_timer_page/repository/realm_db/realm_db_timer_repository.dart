import 'package:my_time/common/common.dart';
import 'package:my_time/features/3_project_timer_page/3_project_timer_page.dart';
import 'package:my_time/features/interface/interface.dart';
import 'package:my_time/exceptions/custom_app_exception.dart' as app_exception;

import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class RealmDbTimerDataRepository {
  final Realm realm;
  RealmDbTimerDataRepository(this.realm);

  Future<ProjectTimerModel?> fetchTimerData(String projectId) async {
    final timerDataList =
        realm.all<TimerDataRealmModel>().query("projectId == '$projectId'");
    if (timerDataList.isEmpty) {
      return null;
    }
    final timerData = timerDataList.first;
    return mapTimerData(timerData);
  }

  Future<ProjectTimerModel> saveTimerData(ProjectTimerModel timerData) async {
    final timerDataList = realm.all<TimerDataRealmModel>();
    if (timerDataList.isNotEmpty) {
      throw const app_exception.CustomAppException.multipleTimerStarts();
    }
    TimerDataRealmModel dbTimerData = TimerDataRealmModel(
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
    return mapTimerData(dbTimerData);
  }

  Future<ProjectTimerModel> deleteTimerData(
      ProjectTimerModel timerData, DateTime endTime) async {
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
      newTimerData = mapTimerData(timerDataDB);
      realm.delete<TimerDataRealmModel>(timerDataDB);
    });
    return newTimerData!;
  }

  Future<ProjectTimerModel> updateTimerDataState(
      ProjectTimerModel timerData, DateTime stateChangeTime) async {
    final timerDataList = realm
        .all<TimerDataRealmModel>()
        .query("projectId == '${timerData.projectId}'");
    if (timerDataList.isEmpty) {
      throw const app_exception.CustomAppException.timerDataNotFound();
    }
    final timerDataDb = timerDataList.first;
    await realm.writeAsync(() {
      TimerState stateDb = timerDataDb.timerState.toEnum(TimerState.values);
      if (stateDb == TimerState.running) {
        timerDataDb.breakStartTimes.add(stateChangeTime);
      } else if (stateDb == TimerState.paused) {
        timerDataDb.breakEndTimes.add(stateChangeTime);
      }
      timerDataDb.timerState = timerData.state.toString();
    });

    return mapTimerData(timerDataDb);
  }

  ProjectTimerModel mapTimerData(TimerDataRealmModel dbTimerData) {
    ProjectTimerModel timerDataDto = ProjectTimerModel.factory(
        id: dbTimerData.id,
        projectId: dbTimerData.projectId,
        startTime: dbTimerData.startTime,
        endTime: dbTimerData.endTime,
        breakStartTimes: IterableExtensions.deepCopyDateTimeList(
            dbTimerData.breakStartTimes),
        breakEndTimes:
            IterableExtensions.deepCopyDateTimeList(dbTimerData.breakEndTimes),
        timerState: dbTimerData.timerState);
    return timerDataDto;
  }
}

final timerDataRepositoryProvider = Provider<RealmDbTimerDataRepository>((ref) {
  final config = Configuration.local([TimerDataRealmModel.schema]);
  return RealmDbTimerDataRepository(Realm(config));
});
