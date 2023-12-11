import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/9_timer/data/models/timer_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_timer_data_data_source.g.dart';

/// An class representing a Firebase data source for managing
/// [TimerDataModel]s.
class FirestoreTimerDataDataSource {
  /// Constructs a [FirestoreTimerDataDataSource].
  FirestoreTimerDataDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;
  static String _timerPath(String uid, String projectId) =>
      'users/$uid/timers/$projectId';

  /// Document reference for a group of a user.
  DocumentReference<TimerDataModel?> timersDocument(
    String uid,
    String groupId,
  ) =>
      _firestore.doc(_timerPath(uid, groupId)).withConverter(
            fromFirestore: (doc, _) {
              if (doc.exists) {
                return TimerDataModel.fromMap(doc.data()!);
              }
              return null;
            },
            toFirestore: (timerDataModel, options) =>
                timerDataModel?.toMap() ?? <String, Object?>{},
          );

  /// Saves the [timerData] to the database.
  Future<void> saveTimerData(
    String uid,
    String projectId,
    TimerDataModel timerData,
  ) {
    return timersDocument(uid, projectId).set(timerData);
  }

  /// Fetches the [TimerDataModel] from the database.
  Future<TimerDataModel?> fetchTimerData(
    String uid,
    String projectId,
  ) {
    return timersDocument(uid, projectId).get().then((value) => value.data());
  }

  /// Deletes the [TimerDataModel] from the database.
  Future<void> deleteTimerData(
    String uid,
    String projectId,
  ) {
    return timersDocument(uid, projectId).delete();
  }
}

/// Riverpod provider for creating an instance
/// of [FirestoreTimerDataDataSource].
@riverpod
FirestoreTimerDataDataSource timerDataFirestoreDataSource(
  TimerDataFirestoreDataSourceRef ref,
) {
  return FirestoreTimerDataDataSource(FirebaseFirestore.instance);
}
