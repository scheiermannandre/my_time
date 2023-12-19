import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_time/features/9_timer/data/models/entry_model.dart';
import 'package:my_time/features/9_timer/data/models/timer_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firestore_entry_data_source.g.dart';

/// An class representing a Firebase data source for managing
/// [TimerDataModel]s.
class FirestoreEntryDataSource {
  /// Constructs a [FirestoreEntryDataSource].
  FirestoreEntryDataSource(FirebaseFirestore firestore)
      : _firestore = firestore;
  final FirebaseFirestore _firestore;
  static String _entryPath(
    String uid,
    String groupId,
    String projectId,
    String entryId,
  ) =>
      'users/$uid/groups/$groupId/entries/$entryId';

  /// Document reference for a group of a user.
  DocumentReference<EntryModel?> entriesDocument(
    String uid,
    String groupId,
    String projectId,
    String entryId,
  ) =>
      _firestore
          .doc(_entryPath(uid, groupId, projectId, entryId))
          .withConverter(
        fromFirestore: (doc, _) {
          if (doc.exists) {
            return EntryModel.fromMap(doc.data()!);
          }
          return null;
        },
        toFirestore: (entryModel, options) {
          final map = entryModel?.toMap() ?? <String, Object?>{};
          return map;
        },
      );

  /// Saves the [entry] to the database.
  Future<void> createEntry(
    String uid,
    String groupId,
    String projectId,
    EntryModel entry,
  ) {
    return entriesDocument(uid, groupId, projectId, entry.id).set(entry);
  }

  /// Saves the [entries] to the database.
  Future<void> createDayOffEnries(
    String uid,
    String groupId,
    String projectId,
    List<EntryModel> entries,
  ) {
    final writeBatch = _firestore.batch();

    for (final entry in entries) {
      writeBatch.set(entriesDocument(uid, groupId, projectId, entry.id), entry);
    }
    return writeBatch.commit();
  }

  /// Fetches the [TimerDataModel] from the database.
  Future<EntryModel?> fetchEntry(
    String uid,
    String groupId,
    String projectId,
    String entryId,
  ) {
    return entriesDocument(uid, groupId, projectId, entryId)
        .get()
        .then((value) => value.data());
  }

  /// Deletes the [TimerDataModel] from the database.
  Future<void> deleteEntry(
    String uid,
    String groupId,
    String projectId,
    String entryId,
  ) {
    return entriesDocument(uid, groupId, projectId, entryId).delete();
  }
}

/// Riverpod provider for creating an instance
/// of [FirestoreEntryDataSource].
@riverpod
FirestoreEntryDataSource entryFirestoreDataSource(
  EntryFirestoreDataSourceRef ref,
) {
  return FirestoreEntryDataSource(FirebaseFirestore.instance);
}
