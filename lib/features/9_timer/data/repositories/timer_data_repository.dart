import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_time/domain/entry_domain/data_sources/firestore_timer_data_data_source.dart';
import 'package:my_time/features/8_authentication/data/repositories/auth_repository_impl.dart';
import 'package:my_time/features/9_timer/data/models/timer_data_model.dart';
import 'package:my_time/features/9_timer/domain/entities/timer_data_entity.dart';
import 'package:my_time/features/9_timer/domain/repositories/i_timer_data_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'timer_data_repository.g.dart';

/// A reference to the [TimerDataRepository].
class TimerDataRepository extends ITimerDataRepository {
  /// Creates a [TimerDataRepository].
  TimerDataRepository({required Ref<Object?> ref}) : _ref = ref;

  final Ref _ref;
  @override
  Future<TimerDataEntity?> fetchTimerData(String projectId) {
    final uid = _ref.read(authRepositoryProvider).currentUser!.uid;
    return _ref
        .read(timerDataFirestoreDataSourceProvider)
        .fetchTimerData(uid, projectId)
        .then((timerDataModel) {
      return timerDataModel?.toEntity();
    });
  }

  @override
  Future<void> saveTimerData(String projectId, TimerDataEntity timerData) {
    final uid = _ref.read(authRepositoryProvider).currentUser!.uid;
    return _ref
        .read(timerDataFirestoreDataSourceProvider)
        .saveTimerData(uid, projectId, TimerDataModel.fromEntity(timerData));
  }

  @override
  Future<void> deleteTimerData(String projectId) {
    final uid = _ref.read(authRepositoryProvider).currentUser!.uid;
    return _ref
        .read(timerDataFirestoreDataSourceProvider)
        .deleteTimerData(uid, projectId);
  }
}

@riverpod

/// A provider for the [TimerDataRepository].
TimerDataRepository timerDataRepository(TimerDataRepositoryRef ref) {
  return TimerDataRepository(ref: ref);
}

@riverpod

/// A provider to fetch the [TimerDataEntity].
FutureOr<TimerDataEntity?> timerDataFuture(
  TimerDataFutureRef ref,
  String projectId,
) {
  return ref.read(timerDataRepositoryProvider).fetchTimerData(projectId);
}
