import 'package:my_time/common/extensions/iterable_extension.dart';
import 'package:my_time/common/extensions/string_extensions.dart';
import 'package:my_time/layers/interface/dto/timer_data.dart';
import 'package:my_time/layers/interface/dto/timer_data_dto.dart';
import 'package:my_time/layers/presentation/5_time_entry_form/domain/custom_timer.dart';
import 'package:realm/realm.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:my_time/exceptions/app_exception.dart' as app_exception;

class TimerDataRepository {
  final Realm realm;
  TimerDataRepository(this.realm);

  Future<TimerDataDto?> fetchTimerData(String projectId) async {
    final timerDataList =
        realm.all<TimerData>().query("projectId == '$projectId'");
    if (timerDataList.isEmpty) {
      return null;
    }
    final timerData = timerDataList.first;
    return mapTimerData(timerData);
  }

  Future<TimerDataDto> saveTimerData(TimerDataDto timerData) async {
    final timerDataList = realm.all<TimerData>();
    if (timerDataList.isNotEmpty) {
      throw const app_exception.AppException.multipleTimerStarts();
    }
    TimerData dbTimerData = TimerData(
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

  Future<TimerDataDto> deleteTimerData(
      TimerDataDto timerData, DateTime endTime) async {
    final timerDataList =
        realm.all<TimerData>().query("projectId == '${timerData.projectId}'");
    final timerDataDB = timerDataList.first;

    TimerDataDto? newTimerData;
    await realm.writeAsync(() {
      timerDataDB.endTime = endTime;
      if (timerDataDB.breakStartTimes.length >
          timerDataDB.breakEndTimes.length) {
        timerDataDB.breakEndTimes.add(endTime);
      }
      timerDataDB.timerState = TimerState.off.toString();
      newTimerData = mapTimerData(timerDataDB);
      realm.delete<TimerData>(timerDataDB);
    });
    return newTimerData!;
  }

  Future<TimerDataDto> updateTimerDataState(
      TimerDataDto timerData, DateTime stateChangeTime) async {
    final timerDataList =
        realm.all<TimerData>().query("projectId == '${timerData.projectId}'");
    if (timerDataList.isEmpty) {
      throw const app_exception.AppException.timerDataNotFound();
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

  TimerDataDto mapTimerData(TimerData dbTimerData) {
    TimerDataDto timerDataDto = TimerDataDto.factory(
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

final timerDataRepositoryProvider = Provider<TimerDataRepository>((ref) {
  final config = Configuration.local([TimerData.schema]);
  return TimerDataRepository(Realm(config));
});
